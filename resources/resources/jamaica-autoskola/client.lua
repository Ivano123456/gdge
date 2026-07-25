local ESX = exports.es_extended:getSharedObject()

local practice = {
    active = false,
    vehicle = nil,
    licenseId = nil,
    route = nil,
    routeIndex = 0,
    maxSpeed = 0,
    errors = 0,
    lastErrorTime = 0
}

local function postNUI(data)
    SendNUIMessage(data)
end

local function resetPracticeState()
    practice.active = false
    practice.vehicle = nil
    practice.licenseId = nil
    practice.route = nil
    practice.routeIndex = 0
    practice.maxSpeed = 0
    practice.errors = 0
    practice.lastErrorTime = 0

    postNUI({ type = 'HIDE_HUD' })
end

local function endPractice(passed)
    if practice.vehicle and DoesEntityExist(practice.vehicle) then
        ESX.Game.DeleteVehicle(practice.vehicle)
    end

    TriggerServerEvent('jamaica-autoskola:completePractice', practice.licenseId, passed)

    postNUI({
        type = 'DISPLAY_RISULTATO',
        errori = practice.errors
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(500)

    resetPracticeState()
end

local function getLicenseData(licenseId)
    for i = 1, #Config.License do
        local license = Config.License[i]
        if license.id == licenseId then
            return license
        end
    end

    return nil
end

local function OpenDMV()
    ESX.TriggerServerCallback('jamaica-autoskola:getData', function(payload)
        if not payload then
            return
        end

        postNUI({
            type = 'SET_CONFIG',
            config = Config
        })
        postNUI({
            type = 'SET_MONEY',
            contanti = payload.money or 0,
            banca = payload.bank or 0
        })
        postNUI({
            type = 'OPEN',
            licenses = payload.licenses or {},
            license = Config.License
        })
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(500)
    end)
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
end)

RegisterNUICallback('refreshData', function(_, cb)
    ESX.TriggerServerCallback('jamaica-autoskola:getData', function(payload)
        if payload then
            postNUI({
                type = 'UPDATE_LICENSE',
                licenses = payload.licenses or {}
            })
            postNUI({
                type = 'SET_MONEY',
                contanti = payload.money or 0,
                banca = payload.bank or 0
            })
        end
        cb({ ok = true })
    end)
end)

RegisterNetEvent('jamaica-autoskola:refresh', function()
    ESX.TriggerServerCallback('jamaica-autoskola:getData', function(payload)
        if not payload then
            return
        end

        postNUI({
            type = 'UPDATE_LICENSE',
            licenses = payload.licenses or {}
        })
        postNUI({
            type = 'SET_MONEY',
            contanti = payload.money or 0,
            banca = payload.bank or 0
        })
    end)
end)

RegisterNUICallback('theoryOk', function(data, cb)
    ESX.TriggerServerCallback('jamaica-autoskola:completeTheory', function(result)
        cb(result or { ok = false })
    end, data.license)
end)

RegisterNUICallback('startTheory', function(data, cb)
    ESX.TriggerServerCallback('jamaica-autoskola:startTheory', function(result)
        cb(result or { ok = false })
    end, data.license)
end)

RegisterNUICallback('startPractice', function(data, cb)
    ESX.TriggerServerCallback('jamaica-autoskola:startPractice', function(result)
        if not result or not result.ok then
            cb(result or { ok = false })
            return
        end

        local license = getLicenseData(data.license)
        if not license then
            cb({ ok = false, reason = 'invalid_license' })
            return
        end

        local spawn = license.vehicle
        local model = joaat(spawn.model)

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(50)
        end

        ESX.Game.SpawnVehicle(spawn.model, spawn.coords, spawn.heading, function(vehicle)
            if not DoesEntityExist(vehicle) then
                cb({ ok = false, reason = 'spawn_failed' })
                return
            end

            SetVehicleNumberPlateText(vehicle, spawn.plate)
            SetEntityAsMissionEntity(vehicle, true, true)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

            local randomRoute = math.random(1, #Config.PracticeCoords)
            practice.active = true
            practice.vehicle = vehicle
            practice.licenseId = data.license
            practice.route = Config.PracticeCoords[randomRoute]
            practice.routeIndex = 1
            practice.maxSpeed = practice.route[1].speedLimit or 0
            practice.errors = 0
            practice.lastErrorTime = 0

            local first = practice.route[1].coordinate
            SetNewWaypoint(first.x, first.y)

            cb({ ok = true })
        end)
    end, data.license)
end)

Citizen.CreateThread(function()
    local waitTime = 1000

    while true do
        Wait(waitTime)

        if not practice.active then
            waitTime = 1000
            goto continue
        end

        waitTime = 0
        local ped = PlayerPedId()

        if not practice.vehicle or not DoesEntityExist(practice.vehicle) then
            endPractice(false)
            goto continue
        end

        local current = practice.route[practice.routeIndex]
        if not current then
            endPractice(practice.errors < Config.MaxErrors)
            goto continue
        end

        local marker = current.coordinate
        DrawMarker(
            Config.MarkerSettings.type,
            marker.x, marker.y, marker.z,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            Config.MarkerSettings.size.x, Config.MarkerSettings.size.y, Config.MarkerSettings.size.z,
            Config.MarkerSettings.color.x, Config.MarkerSettings.color.y, Config.MarkerSettings.color.z, 100,
            Config.MarkerSettings.bump, true, 2, Config.MarkerSettings.rotate, false, false, false
        )

        if GetVehiclePedIsIn(ped, false) ~= practice.vehicle then
            endPractice(false)
            goto continue
        end

        local speed = GetEntitySpeed(practice.vehicle) * Config.SpeedMultiplier
        if practice.maxSpeed > 0 and speed > practice.maxSpeed then
            local currentTime = GetGameTimer()
            if currentTime - practice.lastErrorTime >= 5000 then
                practice.errors = practice.errors + 1
                practice.lastErrorTime = currentTime

                lib.notify({
                    title = 'Jamaica Auto-skola',
                    description = Config.Lang[Config.Language].speed_error,
                    type = 'error',
                    position = 'center-right'
                })

                if practice.errors >= Config.MaxErrors then
                    endPractice(false)
                    goto continue
                end
            end
        end

        local playerCoords = GetEntityCoords(ped)
        if #(playerCoords - marker) < 4.0 then
            practice.routeIndex = practice.routeIndex + 1
            local nextStep = practice.route[practice.routeIndex]
            if nextStep then
                practice.maxSpeed = nextStep.speedLimit or 0
                SetNewWaypoint(nextStep.coordinate.x, nextStep.coordinate.y)
            end
        end

        postNUI({
            type = 'UPDATE_HUD',
            speed = math.floor(speed),
            maxSpeed = practice.maxSpeed,
            errors = practice.errors,
            maxErrors = Config.MaxErrors
        })

        ::continue::
    end
end)

Citizen.CreateThread(function()
    local sleep = 1000

    while true do
        Wait(sleep)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local markerCoords = Config.ReturnMarker.coords
        local distance = #(playerCoords - markerCoords)

        if distance < 50.0 then
            sleep = 0
            DrawMarker(
                Config.ReturnMarker.type,
                markerCoords.x, markerCoords.y, markerCoords.z,
                0, 0, 0, 0, 0, 0,
                Config.ReturnMarker.size.x, Config.ReturnMarker.size.y, Config.ReturnMarker.size.z,
                Config.ReturnMarker.color.x, Config.ReturnMarker.color.y, Config.ReturnMarker.color.z, 100,
                Config.ReturnMarker.bump, true, 2, Config.ReturnMarker.rotate, false, false, false
            )
        end

        if distance < 2.0 then
            DrawText3D(markerCoords.x, markerCoords.y, markerCoords.z + 1.0, "Pritisni ~g~E~w~ da otvoris Jamaica Auto-skolu")
            if IsControlJustPressed(0, 38) then
                OpenDMV()
            end
        elseif distance >= 50.0 then
            sleep = 1000
        else
            sleep = 200
        end

    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then
        return
    end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(225.97, -1384.45, 30.49)
    SetBlipSprite(blip, 498)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Auto-škola")
    EndTextCommandSetBlipName(blip)
end)

