local ESX = exports.es_extended:getSharedObject()

local uiOpen = false
local uiSession = 0
local rentLoc = nil
local rentLocType = 'land'
local activeRentType = 'land'
local rentedVeh = nil
local rentEnd = 0
local rentPeds = {}
local rentBlips = {}
local rentVehBlip = nil
local rentTargetIds = {}

local function notify(msg)
    ESX.ShowNotification(msg)
end

local function hasRent()
    return rentEnd > 0 and rentedVeh and DoesEntityExist(rentedVeh)
end

--- okokGarage: zakljucavanje rent vozila preko itema keys / U
exports('HasActiveRent', function()
    return hasRent()
end)

exports('IsRentVehicle', function(vehicle)
    if not hasRent() or not vehicle or vehicle == 0 then
        return false
    end
    return vehicle == rentedVeh
end)

exports('GetRentVehicle', function()
    if not hasRent() then
        return nil
    end
    return rentedVeh
end)

local function removeRentVehBlip()
    if rentVehBlip and DoesBlipExist(rentVehBlip) then
        RemoveBlip(rentVehBlip)
    end
    rentVehBlip = nil
end

local function showRentVehBlip()
    if not rentedVeh or not DoesEntityExist(rentedVeh) or rentVehBlip then return end

    local cfg = Config.RentVehicleBlip or {}
    rentVehBlip = AddBlipForEntity(rentedVeh)
    SetBlipSprite(rentVehBlip, cfg.sprite or 225)
    SetBlipColour(rentVehBlip, cfg.color or 3)
    SetBlipScale(rentVehBlip, cfg.scale or 0.85)
    SetBlipAsShortRange(rentVehBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(cfg.label or 'Rent vozilo')
    EndTextCommandSetBlipName(rentVehBlip)
end

local function getHudLabel()
    local titles = Config.UiTitles and Config.UiTitles[activeRentType]
    return titles and titles.hud or 'Rent vozila'
end

local function setHudTimer(on)
    if GetResourceState('wais-hudv4') ~= 'started' then return end
    if on then
        exports['wais-hudv4']:JamaicaRentTimer('show', {
            expireAt = rentEnd,
            label = getHudLabel(),
        })
    else
        exports['wais-hudv4']:JamaicaRentTimer('hide', {})
    end
end

local function cancelRent(msg)
    setHudTimer(false)
    removeRentVehBlip()
    rentEnd = 0
    activeRentType = 'land'

    if rentedVeh and DoesEntityExist(rentedVeh) then
        TriggerServerEvent('okokGarage:RemoveKeys', GetVehicleNumberPlateText(rentedVeh))
        local ped = PlayerPedId()
        if GetVehiclePedIsIn(ped, false) == rentedVeh then
            TaskLeaveVehicle(ped, rentedVeh, 0)
            Wait(400)
        end
        ESX.Game.DeleteVehicle(rentedVeh)
    end

    rentedVeh = nil
    if msg then notify(msg) end
end

local function closeUi()
    uiSession = uiSession + 1
    uiOpen = false
    rentLoc = nil
    rentLocType = 'land'
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
end

local function openUi(locId)
    if hasRent() then
        notify('Vec imas rent vozilo. /otkazirent')
        return
    end

    if uiOpen then
        closeUi()
        Wait(50)
    end

    uiSession = uiSession + 1
    local session = uiSession

    local responded = false

    ESX.TriggerServerCallback('jamaica-renta:getUiData', function(data)
        responded = true
        if session ~= uiSession then return end
        if not data then
            notify('Rent meni nije dostupan, pokusaj ponovo.')
            return
        end

        rentLoc = locId
        rentLocType = Config.GetLocationType(locId)
        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'show',
            username = data.username,
            balance = data.balance,
            avatar = data.avatar,
            rentType = rentLocType,
            vehicles = Config.GetVehiclesForLocation(locId),
            uiTitles = Config.UiTitles,
        })
    end)

    SetTimeout(8000, function()
        if responded or session ~= uiSession then return end
        notify('Rent meni nije odgovorio, pokusaj ponovo.')
    end)
end

local function spawnRentVeh(locId, model, color)
    local loc = Config.Locations[locId]
    if not loc or not loc.spawns[1] then return nil end

    local isWater = Config.GetLocationType(locId) == 'water'
    local clearRadius = isWater and 4.0 or 2.5
    local spawn = loc.spawns[1]
    for i = 1, #loc.spawns do
        local s = loc.spawns[i]
        if ESX.Game.IsSpawnPointClear(vector3(s.x, s.y, s.z), clearRadius) then
            spawn = s
            break
        end
    end

    local veh = ESX.Game.SpawnVehicle(model, vector3(spawn.x, spawn.y, spawn.z), spawn.w)
    if not veh or veh == 0 then return nil end

    ESX.Game.SetVehicleProperties(veh, {
        plate = ('RENT%03d'):format(math.random(100, 999)),
    })

    if color then
        SetVehicleCustomPrimaryColour(veh, color.r, color.g, color.b)
        SetVehicleCustomSecondaryColour(veh, color.r, color.g, color.b)
    end

    if isWater then
        SetBoatAnchor(veh, false)
        SetVehicleEngineOn(veh, true, true, false)
    end

    if GetResourceState('okokGasStation') == 'started' then
        exports['okokGasStation']:SetFuel(veh, 100.0)
    else
        SetVehicleFuelLevel(veh, 100.0)
    end

    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    return veh
end

RegisterNUICallback('closeUI', function(_, cb)
    closeUi()
    cb('ok')
end)

RegisterNUICallback('rentVehicle', function(data, cb)
    cb('ok')
    if not uiOpen or not rentLoc then return end

    local locId = rentLoc
    local locType = rentLocType
    closeUi()

    ESX.TriggerServerCallback('jamaica-renta:payRent', function(ok, msg, minutes, color)
        if not ok then
            notify(msg or 'Placanje nije uspelo.')
            return
        end

        local v = Config.GetVehicle(data.vehicle, locId)
        if not v then
            TriggerServerEvent('jamaica-renta:refund', data.price, data.paymentMethod)
            return
        end

        local veh = spawnRentVeh(locId, v.model, color)
        if not veh then
            TriggerServerEvent('jamaica-renta:refund', data.price, data.paymentMethod)
            notify('Spawn nije uspeo, novac vracen.')
            return
        end

        rentedVeh = veh
        activeRentType = locType
        TriggerServerEvent('okokGarage:GiveKeys', GetVehicleNumberPlateText(veh))
        rentEnd = GetCloudTimeAsInt() + (minutes * 60)
        setHudTimer(true)
        notify(('Rent %s min — /otkazirent za otkaz.'):format(minutes))
    end, {
        vehicle = data.vehicle,
        time = data.time,
        price = data.price,
        paymentMethod = data.paymentMethod,
        color = data.color,
        locationId = locId,
    })
end)

RegisterCommand('otkazirent', function()
    if rentEnd <= 0 then
        notify('Nemas aktivan rent.')
        return
    end
    cancelRent('Rent otkazan.')
end, false)

RegisterCommand('cancelrent', function()
    ExecuteCommand('otkazirent')
end, false)

CreateThread(function()
    while true do
        if uiOpen then
            if IsControlJustReleased(0, 200) or IsControlJustReleased(0, 322) then
                closeUi()
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if rentEnd > 0 then
            if GetCloudTimeAsInt() >= rentEnd then
                cancelRent('Vreme renta je isteklo.')
            elseif rentedVeh and not DoesEntityExist(rentedVeh) then
                cancelRent(nil)
            end
            Wait(1000)
        else
            Wait(5000)
        end
    end
end)

CreateThread(function()
    while true do
        if rentEnd > 0 and rentedVeh and DoesEntityExist(rentedVeh) then
            local ped = PlayerPedId()
            local inRentVeh = GetVehiclePedIsIn(ped, false) == rentedVeh

            if inRentVeh then
                removeRentVehBlip()
            else
                showRentVehBlip()
            end
            Wait(500)
        else
            removeRentVehBlip()
            Wait(1000)
        end
    end
end)

local function cleanupRentLocations()
    for i = 1, #rentPeds do
        local ped = rentPeds[i]
        local targetName = rentTargetIds[i]
        if ped and DoesEntityExist(ped) and targetName then
            exports.ox_target:removeLocalEntity(ped, targetName)
            DeleteEntity(ped)
        elseif ped and DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    rentPeds = {}
    rentTargetIds = {}

    for i = 1, #rentBlips do
        if DoesBlipExist(rentBlips[i]) then
            RemoveBlip(rentBlips[i])
        end
    end
    rentBlips = {}
end

local function setupRentLocations()
    if GetResourceState('ox_target') ~= 'started' then return end

    cleanupRentLocations()

    Wait(3500)

    for id, loc in pairs(Config.Locations) do
        local model = loc.pedModel or `s_m_m_autoshop_02`
        if type(model) ~= 'number' then model = joaat(model) end
        if not IsModelInCdimage(model) or not IsModelValid(model) then goto continue end

        local loaded = false
        for _ = 1, 3 do
            if pcall(lib.requestModel, model, 15000) and HasModelLoaded(model) then
                loaded = true
                break
            end
            Wait(1500)
        end
        if not loaded then goto continue end

        local c = loc.ped
        local ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
        if not DoesEntityExist(ped) then
            SetModelAsNoLongerNeeded(model)
            goto continue
        end

        SetEntityHeading(ped, c.w)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        local isWater = loc.type == 'water'
        local targetName = 'rent_' .. id
        exports.ox_target:addLocalEntity(ped, {
            {
                name = targetName,
                icon = isWater and 'fa-solid fa-ship' or 'fa-solid fa-car',
                label = isWater and 'Iznajmi brod / jet ski' or 'Iznajmi vozilo',
                distance = Config.TargetDistance,
                onSelect = function()
                    openUi(id)
                end,
            },
        })

        rentPeds[#rentPeds + 1] = ped
        rentTargetIds[#rentTargetIds + 1] = targetName
        SetModelAsNoLongerNeeded(model)

        if loc.blip then
            local blip = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(blip, loc.blip.sprite or 225)
            SetBlipColour(blip, loc.blip.color or 2)
            SetBlipScale(blip, loc.blip.scale or 0.75)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(loc.blip.label or 'Rent vozila')
            EndTextCommandSetBlipName(blip)
            rentBlips[#rentBlips + 1] = blip
        end

        ::continue::
    end
end

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(200) end
    while GetResourceState('ox_target') ~= 'started' do Wait(200) end
    setupRentLocations()
end)

RegisterNetEvent('esx:playerLoaded', function()
    CreateThread(function()
        while GetResourceState('ox_target') ~= 'started' do Wait(200) end
        setupRentLocations()
    end)
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    if not ESX.PlayerLoaded then return end
    CreateThread(function()
        while GetResourceState('ox_target') ~= 'started' do Wait(200) end
        setupRentLocations()
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    closeUi()
    cancelRent()
    cleanupRentLocations()
end)
