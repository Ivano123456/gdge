local RequestId = 0
local serverRequests = {}
targetLoaded = false
showBar = false
TriggerServerCallback = function(eventName, ...)
    local prom = promise.new()

    local requestId = RequestId
    serverRequests[requestId] = function(...)
        prom:resolve(...)
    end
    TriggerServerEvent(_event('triggerServerCallback'), eventName, requestId, GetInvokingResource() or "unknown", ...)
    RequestId = RequestId + 1


    return Citizen.Await(prom)
end

RegisterNetEvent(_event('serverCallback'), function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return print(("[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.")
            :format(requestId, invoker))
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)

jobData = {
    jobname = nil,
    job_grade_name = nil,
    job_grade = nil,
    job_label = nil
}

local Player = {}
local Loaded = false

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    Wait(1000)
    TriggerServerEvent(_event('server:loadData'))
    Loaded = true
end)


RegisterNetEvent('esx:onPlayerLogout', function()
    Player = table.wipe(Player)
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(1000)
    TriggerServerEvent(_event('server:loadData'))
end)

-- vRP player loaded — multiple event names for cross-fork compatibility.
-- Different vRP forks fire different events; we listen to all known ones.
-- Server-side has its own vRP:playerSpawn handler as the primary path; these
-- client handlers are a fallback for forks where server events don't fire.
local vrpClientLoaded = false
local function vrpClientTriggerLoad()
    if vrpClientLoaded then return end
    vrpClientLoaded = true
    Wait(1000)
    TriggerServerEvent(_event('server:loadData'))
end

AddEventHandler("vRP:Active", function() vrpClientTriggerLoad() end)
AddEventHandler("vRP:playerSpawn", function(first_spawn) vrpClientTriggerLoad() end)
AddEventHandler("vRP:NUIready", function() vrpClientTriggerLoad() end)

-- Standalone framework player loaded event
if Config.Framework == 'standalone' then
    CreateThread(function()
        Wait(1000)
        TriggerServerEvent(_event('server:loadData'))
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    Player = table.wipe(Player)
end)


RegisterNetEvent('esx:setPlayerData', function(key, value)
    if not Loaded or GetInvokingResource() ~= 'es_extended' then return end

    if key ~= 'job' then return end
end)


CreateThread(function()
    -- Standalone framework bypass
    if Config.Framework == 'standalone' then
        Core = true
    else
        Core, Config.Framework = GetCore()
    end
    spawnPed()
    createBlips()
    SetPlayerJob()
end)

AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentServerEndpoint() == nil) then
        return
    end
    if (resource == GetCurrentResourceName()) then
        TriggerServerEvent(_event('server:loadData'))
        ClearPedTasks(PlayerPedId())
    end
end)

function SetPlayerJob()
    while Core == nil do
        Wait(0)
    end
    Wait(500)
    while not nuiLoaded do
        Wait(50)
    end
    WaitPlayer()

    -- Standalone framework (no job system)
    if Config.Framework == 'standalone' then
        jobData.jobname = "garbage"
        jobData.job_grade_name = "Garbage Worker"
        jobData.job_grade = 0
    elseif Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local PlayerData = Core.GetPlayerData()
        jobData.jobname = PlayerData.job.name
        jobData.job_grade_name = PlayerData.job.label
        jobData.job_grade = tonumber(PlayerData.job.grade)
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        local PlayerData = Core.Functions.GetPlayerData()
        jobData.jobname = PlayerData["job"].name
        jobData.job_grade_name = PlayerData["job"].label
        jobData.job_grade = PlayerData["job"].grade.level
    elseif Config.Framework == 'vrp' then
        jobData.jobname = "garbage"
        jobData.job_grade_name = "Garbage Worker"
        jobData.job_grade = 0
    end
end

function WaitPlayer()
    -- Standalone framework (no player data waiting needed)
    if Config.Framework == 'standalone' then
        return
    elseif Config.Framework == "esx" or Config.Framework == 'oldesx' then
        while Core == nil do Wait(0) end
        while Core.GetPlayerData() == nil do Wait(0) end
        while Core.GetPlayerData().job == nil do Wait(0) end
    elseif Config.Framework == "qb" or Config.Framework == "oldqb" then
        while Core == nil do Wait(0) end
        while Core.Functions.GetPlayerData() == nil do Wait(0) end
        while Core.Functions.GetPlayerData().metadata == nil do Wait(0) end
    elseif Config.Framework == "vrp" then
        while Core == nil do Wait(0) end
        Wait(1000)
    end
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    Wait(1000)
    SetPlayerJob()
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(data)
    Wait(1000)
    SetPlayerJob()
end)

local blips = {}

function createBlips()
    if Config.Job['blip']['show'] then
        blips = AddBlipForCoord(tonumber(Config.Job['coords'].intreactionCoords.x),
            tonumber(Config.Job['coords'].intreactionCoords.y),
            tonumber(Config.Job['coords'].intreactionCoords.z))
        SetBlipSprite(blips, Config.Job['blip'].blipType)
        SetBlipDisplay(blips, 4)
        SetBlipScale(blips, Config.Job['blip'].blipScale)
        SetBlipColour(blips, Config.Job['blip'].blipColor)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Job['blip'].blipName)
        EndTextCommandSetBlipName(blips)
    end
end

function canOpen()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        return false
    end
    if Config.Job['job'] then
        if Config.Job['job'] == 'all' then
            return true
        end

        if type(Config.Job['job']) == 'table' then
            local hasJob = false
            for _, allowedJob in ipairs(Config.Job['job']) do
                if allowedJob == jobData.jobname then
                    hasJob = true
                    break
                end
            end
            if not hasJob then
                Config.sendNotification(Config.NotificationText['wrongjob'].text,
                    Config.NotificationText['wrongjob'].type)
                return false
            end
        elseif type(Config.Job['job']) == 'string' then
            if Config.Job['job'] ~= jobData.jobname then
                Config.sendNotification(Config.NotificationText['wrongjob'].text,
                    Config.NotificationText['wrongjob'].type)
                return false
            end
        end
    end
    return true
end

function spawnPed()
    if Config.Job.coords.ped then
        WaitForModel(Config.Job.coords.pedHash)
        local createNpc = CreatePed("PED_TYPE_PROSTITUTE", Config.Job.coords.pedHash, Config.Job.coords.pedCoords.x,
            Config.Job.coords.pedCoords.y, Config.Job.coords.pedCoords.z - 0.98, Config.Job.coords.pedHeading, false,
            false)
        FreezeEntityPosition(createNpc, true)
        SetEntityInvincible(createNpc, true)
        SetBlockingOfNonTemporaryEvents(createNpc, true)
    end
end

function FormatInteractionText(text)
    local color = Config.InteractionKeyColor or ""
    if color ~= "" then
        text = text:gsub("%[E%]", color .. "[E]~w~")
        text = text:gsub("%[G%]", color .. "[G]~w~")
    end
    return text
end

function DrawText3D(x, y, z, text)
    text = FormatInteractionText(text)
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SetBlipAttributes(blip, id)
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 26)
    ShowNumberOnBlip(blip, id)
    SetBlipShowCone(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(base.resource .. " : " .. id)
    EndTextCommandSetBlipName(blip)
end

RegisterNetEvent(_event('openMenu'), function()
    if canOpen() then
        openJobMenu()
    end
end)

function WaitForModel(model)
    if not IsModelValid(model) then
        return
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
    end

    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
end

Citizen.CreateThread(function()
    local openTriggerZoneId = nil

    Config.OpenTrigger = function(bool)
        if not bool then
            -- Remove zone
            if openTriggerZoneId then
                TargetManager.RemoveZone(openTriggerZoneId)
                openTriggerZoneId = nil
            end
            TargetManager.StopDrawTextLoop("job_menu")
        else
            -- Create zone at NPC coords
            local npcCoords = Config.Job.coords.intreactionCoords
            local zoneId = base.resource .. "_job_menu"

            if TargetManager.IsTarget() then
                openTriggerZoneId = TargetManager.AddSphereZone(zoneId, vector3(npcCoords.x, npcCoords.y, npcCoords.z), 1.5, {
                    {
                        name = zoneId .. "_open",
                        label = Locales[Config.Locale]['OpenJobMenu'],
                        icon = 'fas fa-credit-card',
                        distance = 2.0,
                        onSelect = function()
                            TriggerEvent(_event('openMenu'))
                        end,
                    }
                })
            else
                TargetManager.StartDrawTextLoop("job_menu", {
                    coords = vector3(npcCoords.x, npcCoords.y, npcCoords.z + 1.0),
                    label = Locales[Config.Locale]['pedDrawText'],
                    distance = 1.5,
                    key = 38,
                    onSelect = function()
                        if canOpen() then
                            openJobMenu()
                        end
                    end,
                })
            end
        end
    end
end)

-- Legacy wrapper functions now delegate to TargetManager
CreateThread(function()
    AddModelToTarget = function(model, data)
        TargetManager.AddModel(data.name or "model_" .. tostring(model), model, {
            {
                name = data.name,
                label = data.label,
                icon = data.icon,
                onSelect = data.event and function() TriggerEvent(data.event) end or nil,
                canInteract = data.handler or nil,
            }
        })
    end

    AddCoordsToTarget = function(coords, data)
        TargetManager.AddSphereZone(data.name or "coords_zone", coords, data.radius or 2.0, {
            {
                name = data.name,
                label = data.label,
                icon = data.icon,
                onSelect = data.event and function() TriggerEvent(data.event) end or nil,
                canInteract = data.handler or nil,
                distance = data.radius or 2.0,
            }
        })
    end

    addBoxToTarget = function(coords, data)
        if TargetManager._type == "ox-target" then
            local zoneId = exports.ox_target:addBoxZone({
                name = data.name,
                coords = coords,
                size = vector3(data.radius or 2.0, data.radius or 2.0, 2.0),
                debug = Config.Debug or false,
                options = {
                    {
                        name = data.name,
                        event = data.event,
                        icon = data.icon,
                        label = data.label,
                        canInteract = data.handler or nil,
                    }
                }
            })
            TargetManager._registered.zones[zoneId or data.name] = true
            return zoneId
        elseif TargetManager._type == "qb-target" then
            exports['qb-target']:AddBoxZone(data.name, coords, data.radius or 2.0, data.radius or 2.0, {
                name = data.name,
                useZ = true,
            }, {
                options = {
                    {
                        event = data.event,
                        icon = data.icon,
                        label = data.label,
                        canInteract = data.handler or nil,
                    }
                },
                distance = data.radius or 2.0,
            })
            TargetManager._registered.zones[data.name] = true
            return data.name
        end
    end

    addBoxLocalEntity = function(entities, options)
        TargetManager.AddLocalEntity(entities, options)
    end

    removeBoxLocalEntity = function(entities)
        TargetManager.RemoveLocalEntity(entities)
    end

    addNetworkEntityTarget = function(netId, options)
        local converted = {}
        for i, opt in ipairs(options) do
            converted[i] = {
                name = opt.label,
                label = opt.label,
                icon = opt.icon,
                onSelect = function(entity) if opt.action then opt.action(entity) end end,
                canInteract = opt.canInteract,
            }
        end
        return TargetManager.AddNetworkEntity(netId, converted)
    end

    removeNetworkEntityTarget = function(netId, interactionId)
        TargetManager.RemoveNetworkEntity(netId)
    end

    addCoordinateInteraction = function(data)
        local zoneName = data.name or data.id
        return TargetManager.AddSphereZone(zoneName, data.coords, data.distance or 2.0, {
            {
                name = zoneName,
                label = data.options[1].label,
                icon = data.options[1].icon,
                onSelect = data.options[1].action,
                canInteract = data.options[1].canInteract,
                distance = data.distance or 2.0,
            }
        })
    end

    removeCoordinateInteraction = function(interactionId)
        if interactionId and interactionId ~= true then
            TargetManager.RemoveZone(interactionId)
        end
    end

    targetLoaded = true
end)

local function CheckPlayerHandObjects()
    if playerHandObject.object then
        return true
    end
    return false
end

Citizen.CreateThread(function()
    local sleep = 2000
    while true do
        Citizen.Wait(sleep)
        local isJobing = CoopDataClient and CoopDataClient.roomSetting and true or false
        if isJobing then
            sleep = 0
            local playerPed = PlayerPedId()
            if GetIsTaskActive(playerPed, 160) and CheckPlayerHandObjects() then
                ClearPedTasks(playerPed)
                ClearPedSecondaryTask(playerPed)
                Config.sendNotification(Locales[Config.Locale]['cantentervehicle'])
            end
        end
    end
end)


function showProgressBar(title, time)
    if showBar then return end
    showBar = true
    if Config.Vorp then
        exports["vorp-ui"]:progressBar({
            label = title,
            duration = time * 1000,
            canCancel = false,
        })
    else
        NuiMessage('showProgressBar', { label = title, time = time })
    end
    Citizen.SetTimeout(time * 1000, function()
        showBar = false
    end)
end

function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

function PlayEffect(dict, particleName, entity, off, rot, time, cb)
    CreateThread(function()
        RequestNamedPtfxAsset(dict)
        while not HasNamedPtfxAssetLoaded(dict) do
            Wait(0)
        end
        UseParticleFxAssetNextCall(dict)
        Wait(10)
        local particleHandle = StartParticleFxLoopedOnEntity(particleName, entity, off.x, off.y, off.z, rot.x, rot.y,
            rot.z, 1.0)
        SetParticleFxLoopedColour(particleHandle, 0, 255, 0, 0)
        Wait(time)
        StopParticleFxLooped(particleHandle, false)
        cb()
    end)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function GetVehicles()
    return GetGamePool('CVehicle')
end

function GetVehiclesInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(GetVehicles(), false, coords, maxDistance)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end
    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end
    return nearbyEntities
end

function v2(coords) return vec3(coords.x, coords.y, 0.0) end

function CreateProp(modelHash, ...)
    if not IsModelInCdimage(modelHash) then
        return
    end
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return obj
end

function GiveJobClothing()
    if Config.ChangeClothesSystem then
        local gender
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
            gender = 'male'
        elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            gender = 'female'
        else
            return
        end
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent("esx_skin:setLastSkin", skin)
        end)

        local clothes = Config.JobClothes[gender]
        if clothes then
            for _, cloth in ipairs(clothes) do
                for part, id in pairs(cloth) do
                    if part ~= "texture" then
                        ChangeClothes(part, id, cloth.texture)
                    end
                end
            end
        end
    end
end

function ChangeClothes(key, value, texture)
    local playerPed = PlayerPedId()
    value = tonumber(value)
    texture = tonumber(texture)

    if key == 'jacket' then
        SetPedComponentVariation(playerPed, 11, value, texture, 2)
    end
    if key == 'shirt' then
        SetPedComponentVariation(playerPed, 8, value, texture, 2)
    end
    if key == 'arms' then
        SetPedComponentVariation(playerPed, 3, value, texture, 2)
    end
    if key == 'legs' then
        SetPedComponentVariation(playerPed, 4, value, texture, 2)
    end
    if key == 'shoes' then
        SetPedComponentVariation(playerPed, 6, value, texture, 2)
    end
    if key == 'mask' then
        SetPedComponentVariation(playerPed, 1, value, texture, 2)
    end
    if key == 'chain' then
        SetPedComponentVariation(playerPed, 7, value, texture, 2)
    end
    if key == 'decals' then
        SetPedComponentVariation(playerPed, 10, value, texture, 2)
    end
    if key == 'helmet' then
        SetPedPropIndex(playerPed, 0, value, texture, 2)
    end
    if key == 'glasses' then
        SetPedPropIndex(playerPed, 1, value, texture, 2)
    end
    if key == 'watches' then
        SetPedPropIndex(playerPed, 6, value, texture, 2)
    end
    if key == 'bracelets' then
        SetPedPropIndex(playerPed, 7, value, texture, 2)
    end
end

function RefreshSkin()
    Config.RefreshSkin()
end

--- Yields the current thread until a non-nil value is returned by the function.
---@generic T
---@param cb fun(): T?
---@param errMessage string?
---@param timeout? number | false Error out after `~x` ms. Defaults to 1000, unless set to `false`.
---@return T
---@async
function waitForClient(cb, errMessage, timeout)
    local value = cb()
    if value ~= nil then return value end

    if timeout or timeout == nil then
        if type(timeout) ~= 'number' then timeout = 1000 end
    end

    local startTime = timeout and GetGameTimer()

    while value == nil do
        Wait(0)

        if timeout then
            local elapsed = GetGameTimer() - startTime
            if elapsed > timeout then
                return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', elapsed), 2)
            end
        end

        value = cb()
    end

    return value
end

local isPlayAnim = false
function PlayAnim(dataName)
    local playerPed = PlayerPedId()
    if dataName == 'collectTrash' then
        LoadAnimation('anim@heists@narcotics@trash')
        TaskPlayAnim(playerPed, 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0, -1, 49, 0, 0, 0, 0)
        shouldExit = false
        walkAnim(true)
    elseif dataName == 'collectTrash2' then
        local tempShouldExit = shouldExit
        shouldExit = true
        Wait(100)

        LoadAnimation('anim@scripted@freemode@postertag@collect_can@male@')
        TaskPlayAnim(playerPed, 'anim@scripted@freemode@postertag@collect_can@male@', 'poster_tag_collect_can_var03_male',
            6.0, -6.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(1400)
        ClearPedTasks(playerPed)

        if not tempShouldExit then
            shouldExit = false
            walkAnim(true)
        end
    elseif dataName == 'placeTrash' then
        LoadAnimation('anim@mp_fireworks')
        TaskPlayAnim(playerPed, 'anim@mp_fireworks', 'place_firework_box2', 8.0, -8.0, -1, 2, 0, false, false, false)
        Citizen.Wait(1400)
        ClearPedTasks(playerPed)
    end
end

local shouldExit = false
function walkAnim(state)
    if not state then
        shouldExit = true
        ClearPedTasks(PlayerPedId())
        ClearPedTasksImmediately(PlayerPedId())
        return
    end
    shouldExit = false
    CreateThread(function()
        local ped = PlayerPedId()
        local isAnimRunning = true

        while not shouldExit and isAnimRunning do
            if not IsEntityPlayingAnim(ped, 'anim@heists@narcotics@trash', 'walk', 3) then
                if not IsEntityPlayingAnim(ped, 'anim@scripted@freemode@postertag@collect_can@male@', 'poster_tag_collect_can_var03_male', 3) and
                    not IsEntityPlayingAnim(ped, 'anim@mp_fireworks', 'place_firework_box2', 3) and
                    not IsEntityPlayingAnim(ped, 'anim@heists@narcotics@trash', 'throw_b', 3) then
                    ClearPedTasksImmediately(ped)
                    LoadAnimation('anim@heists@narcotics@trash')
                    TaskPlayAnim(ped, 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0, -1, 49, 0, 0, 0, 0)
                end
            end
            Wait(500)

            if shouldExit or IsEntityPlayingAnim(ped, 'anim@heists@narcotics@trash', 'throw_b', 3) then
                isAnimRunning = false
            end
        end

        if shouldExit and not IsEntityPlayingAnim(ped, 'anim@heists@narcotics@trash', 'throw_b', 3) then
            ClearPedTasks(ped)
            ClearPedTasksImmediately(ped)
        end
    end)
end

function disposeOfTrash()
    shouldExit = true
    --LoadAnimation('anim@heists@narcotics@trash')
    --TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    --FreezeEntityPosition(PlayerPedId(), false)
    Citizen.Wait(1200)
    ClearPedTasks(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
end

function LoadParticleLib(dict)
    if not HasNamedPtfxAssetLoaded(dict) then
        RequestNamedPtfxAsset(dict)
        while not HasNamedPtfxAssetLoaded(dict) do
            Citizen.Wait(0)
        end
    end
    UseParticleFxAssetNextCall(dict)
end

function CreateCamera()
    local invehicle = IsPedInAnyVehicle(PlayerPedId(), false)
    if invehicle then return end

    local defaultCoords = Config.Job.coords.pedCoords
    local defaultHeading = Config.Job.coords.pedHeading
    local offset = vector3(0.6, 1.8, 0.3)
    local coords = defaultCoords + offset

    RenderScriptCams(true, true, 500, true, true)
    DestroyCam(cam, false)

    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
        SetCamRot(cam, 5.0, 0.0, defaultHeading - 180.0)
        SetCamNearClip(cam, 0.1)
        SetCamFarClip(cam, 1000.0)
        SetCamFov(cam, 20.0)
        SetCamDofFnumberOfLens(cam, 24.0)
        SetCamDofFocalLengthMultiplier(cam, 50.0)
    end
end

Citizen.CreateThread(function()
    local wait = 1000
    while true do
        Citizen.Wait(wait)
        if openUI or camera then
            if not Config.closeInvisable then
                wait = 0
                SetEntityAlpha(PlayerPedId(), 0, false)
                SetLocalPlayerInvisibleLocally(true)
            end
        end
    end
end)

function ExitCamera()
    SetEntityAlpha(PlayerPedId(), 255, false)
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(cam, false)
    ClearFocus()
    cam = nil
end

function CreateFinishCamera()
    local invehicle = IsPedInAnyVehicle(PlayerPedId(), false)
    if invehicle then return end
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.3, -2.0, 0.0)

    RenderScriptCams(true, true, 500, true, true)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
        SetCamRot(cam, 5.0, 0.0, GetEntityHeading(PlayerPedId()))
        SetCamNearClip(cam, 0.1)
        SetCamFarClip(cam, 1000.0)
        SetCamFov(cam, 40.0)
        SetCamDofFnumberOfLens(camera, 24.0)
        SetCamDofFocalLengthMultiplier(camera, 50.0)
        local heading = GetEntityHeading(PlayerPedId())
        SetEntityHeading(PlayerPedId(), heading + 180.0)
    end
end

function TriggerCallback(name, data)
    local incomingData = false
    local status = 'UNKOWN'
    local counter = 0
    while Core == nil do
        Wait(0)
    end
    if Config.Framework == 'esx' then
        Core.TriggerServerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    else
        Core.Functions.TriggerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    end
    CreateThread(function()
        while incomingData == 'UNKOWN' do
            Wait(1000)
            if counter == 4 then
                status = 'FAILED'
                incomingData = false
                break
            end
            counter = counter + 1
        end
    end)

    while status == 'UNKOWN' do
        Wait(0)
    end
    return incomingData
end

local jobDeliverCoordsInteraction
local deliveryThread = nil

function ToggleVehicleDeliveryInteraction(state)
    if state then
        -- Koordinat alma
        if CoopDataClient and CoopDataClient.roomSetting and CoopDataClient.roomSetting.jobDeliverCoords then
            jobDeliverCoordsInteraction = vector3(
                CoopDataClient.roomSetting.jobDeliverCoords.x,
                CoopDataClient.roomSetting.jobDeliverCoords.y,
                CoopDataClient.roomSetting.jobDeliverCoords.z
            )
        elseif not jobDeliverCoords and CoopDataClient.roomSetting.Mission and CoopDataClient.roomSetting.Mission.jobDeliverCoords then
            jobDeliverCoordsInteraction = vector3(
                CoopDataClient.roomSetting.Mission.jobDeliverCoords.x,
                CoopDataClient.roomSetting.Mission.jobDeliverCoords.y,
                CoopDataClient.roomSetting.Mission.jobDeliverCoords.z
            )
        else
            jobDeliverCoordsInteraction = jobDeliverCoords
        end

        -- Koordinat hazır olana kadar bekle
        local attempts = 0
        while not jobDeliverCoordsInteraction and attempts < 10 do
            Wait(1000)
            attempts += 1
            if CoopDataClient.roomSetting.Mission and CoopDataClient.roomSetting.Mission.jobDeliverCoords then
                jobDeliverCoordsInteraction = vector3(
                    CoopDataClient.roomSetting.Mission.jobDeliverCoords.x,
                    CoopDataClient.roomSetting.Mission.jobDeliverCoords.y,
                    CoopDataClient.roomSetting.Mission.jobDeliverCoords.z
                )
            end
        end

        if not jobDeliverCoordsInteraction then
            print("[DEBUG] Teslim koordinatları alınamadı!")
            return
        end

        VehicleDeliveryInteraction = true

        -- Delivery always uses DrawText (vehicle-based, target not usable)
        if not deliveryThread then
            deliveryThread = true

            Citizen.CreateThread(function()
                while deliveryThread do
                    Wait(0)

                    local playerPed = PlayerPedId()
                    if not IsPedInAnyVehicle(playerPed, false) then
                        Citizen.Wait(1000)
                        goto continue
                    end

                    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
                    local currentPlate = GetVehicleNumberPlateText(currentVehicle)
                    local vehicles = getVehicle() or {}
                    local isPlayerInRegisteredVehicle = false

                    for _, vehData in ipairs(vehicles) do
                        if vehData.plate == currentPlate then
                            isPlayerInRegisteredVehicle = true
                            break
                        end
                    end

                    local serverID = GetPlayerServerId(PlayerId())
                    local ownersrc = CoopDataClient and CoopDataClient.roomSetting and
                        CoopDataClient.roomSetting.ownersrc
                    local isOwner = tostring(ownersrc) == tostring(serverID)

                    if isPlayerInRegisteredVehicle and isOwner and not isInteracting then
                        local playerCoords = GetEntityCoords(playerPed)
                        local dist = #(playerCoords - jobDeliverCoordsInteraction)

                        if dist < 10.0 then
                            DrawText3D(jobDeliverCoordsInteraction.x, jobDeliverCoordsInteraction.y,
                                jobDeliverCoordsInteraction.z + 1.5,
                                "[E] - " .. Locales[Config.Locale]['deliveryVehicle'])
                            if IsControlJustPressed(0, 38) then
                                StartInteraction()
                                TriggerServerEvent(_event('server:LeaveVehicle'),
                                    CoopDataClient.roomSetting.owneridentifier)
                                clearMissionData()
                                Citizen.SetTimeout(1000, function()
                                    EndInteraction()
                                end)
                            end
                        else
                            Citizen.Wait(500)
                        end
                    else
                        Citizen.Wait(500)
                    end

                    ::continue::
                end
            end)
        end
    elseif not state and VehicleDeliveryInteraction then
        deliveryThread = false
        VehicleDeliveryInteraction = false
    end
end

local lastCoords = {}
GetRandomCoordInCircle = function(coord, radiusNumber, count)
    local coordstable = {}
    local minDistance = 1.0
    for i = 1, tonumber(count) do
        local radius = tonumber(radiusNumber) or 75.0
        local coords = vector3(coord.x, coord.y, coord.z + 0.1)
        local x, y, z = GenerateRandomCoords(coords, radius, minDistance, i, coordstable)
        if x ~= nil and y ~= nil and z ~= nil then
            table.insert(coordstable, vector3(x, y, z))
        end
    end
    lastCoords = coordstable
    return coordstable
end

function GenerateRandomCoords(coords, radius, minDistance, attempt, coordstable)
    local x, y, z
    repeat
        x = coords.x + math.random(-radius, radius)
        y = coords.y + math.random(-radius, radius)
        z = FindZForCoords(x, y, coords.z)
    until not IsTooCloseToLastCoords(x, y, minDistance)
    return x, y, z
end

function IsTooCloseToLastCoords(x, y, minDistance)
    for _, existingCoord in ipairs(lastCoords) do
        local distance = GetDistanceBetweenCoords2(existingCoord.x, existingCoord.y, x, y)
        if distance < minDistance then
            return true
        end
    end
    return false
end

function GetDistanceBetweenCoords2(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

local originalPrint = print
function print(...)
    local info = debug.getinfo(2, "Sl")
    local file = info.source and info.source:match("([^/\\]+)$") or "unknown"
    local line = info.currentline or "unknown"
    originalPrint("^3[" .. file .. ":" .. line .. "]^7", ...)
end

-- ============================================================
-- TargetManager: Unified target/interaction system
-- Supports ox-target, qb-target, and drawtext
-- ============================================================

TargetManager = {}
TargetManager._type = Config.InteractionHandler or "drawtext"
TargetManager._registered = {
    entities = {},  -- [entity] = { optionNames }
    zones = {},     -- [zoneId/zoneName] = true
    models = {},    -- [id] = { models, optionName }
}
TargetManager._drawTextLoops = {} -- [id] = { active, coords, label, distance, ... }

function TargetManager.IsTarget()
    return TargetManager._type == "ox-target" or TargetManager._type == "qb-target"
end

-- Clean "[E] - " / "[G] - " prefixes from labels
local function cleanLabel(text)
    if not text then return "Interact" end
    return text:gsub("%[%w%]%s*-%s*", "")
end

-- ============================================================
-- ZONE FUNCTIONS
-- ============================================================

function TargetManager.AddSphereZone(id, coords, radius, options)
    if TargetManager._type == "ox-target" then
        local oxOpts = {}
        for i, opt in ipairs(options) do
            oxOpts[i] = {
                name = opt.name or (id .. "_opt_" .. i),
                label = cleanLabel(opt.label),
                icon = opt.icon or "fas fa-hand",
                distance = opt.distance or 2.0,
                onSelect = opt.onSelect,
                canInteract = opt.canInteract,
            }
        end
        local zoneId = exports.ox_target:addSphereZone({
            name = id,
            coords = coords,
            radius = radius,
            debug = Config.Debug or false,
            options = oxOpts,
        })
        TargetManager._registered.zones[zoneId or id] = true
        return zoneId or id
    elseif TargetManager._type == "qb-target" then
        local qbOpts = {}
        for i, opt in ipairs(options) do
            qbOpts[i] = {
                type = "client",
                icon = opt.icon or "fas fa-hand",
                label = cleanLabel(opt.label),
                action = opt.onSelect,
                canInteract = opt.canInteract,
            }
        end
        exports['qb-target']:AddCircleZone(id, coords, radius, {
            name = id,
            useZ = true,
            debugPoly = Config.Debug or false,
        }, {
            options = qbOpts,
            distance = options[1] and options[1].distance or 2.0,
        })
        TargetManager._registered.zones[id] = true
        return id
    end
    return nil
end

function TargetManager.RemoveZone(id)
    if not id or not TargetManager._registered.zones[id] then return end
    pcall(function()
        if TargetManager._type == "ox-target" then
            exports.ox_target:removeZone(id)
        elseif TargetManager._type == "qb-target" then
            exports['qb-target']:RemoveZone(id)
        end
    end)
    TargetManager._registered.zones[id] = nil
end

-- ============================================================
-- ENTITY FUNCTIONS (local entity handles)
-- ============================================================

function TargetManager.AddLocalEntity(entity, options)
    if not entity or not DoesEntityExist(entity) then return end
    if TargetManager._type == "ox-target" then
        local oxOpts = {}
        for i, opt in ipairs(options) do
            oxOpts[i] = {
                name = opt.name or ("ent_" .. tostring(entity) .. "_" .. i),
                label = cleanLabel(opt.label),
                icon = opt.icon or "fas fa-hand",
                distance = opt.distance or 2.0,
                onSelect = opt.onSelect,
                canInteract = opt.canInteract,
            }
        end
        exports.ox_target:addLocalEntity(entity, oxOpts)
        TargetManager._registered.entities[entity] = true
    elseif TargetManager._type == "qb-target" then
        local qbOpts = {}
        for i, opt in ipairs(options) do
            qbOpts[i] = {
                type = "client",
                icon = opt.icon or "fas fa-hand",
                label = cleanLabel(opt.label),
                action = opt.onSelect,
                canInteract = opt.canInteract,
            }
        end
        exports['qb-target']:AddTargetEntity(entity, {
            options = qbOpts,
            distance = options[1] and options[1].distance or 2.0,
        })
        TargetManager._registered.entities[entity] = true
    end
end

function TargetManager.RemoveLocalEntity(entity)
    if not entity then return end
    pcall(function()
        if TargetManager._type == "ox-target" then
            exports.ox_target:removeLocalEntity(entity)
        elseif TargetManager._type == "qb-target" then
            exports['qb-target']:RemoveTargetEntity(entity)
        end
    end)
    TargetManager._registered.entities[entity] = nil
end

-- ============================================================
-- NETWORK ENTITY FUNCTIONS
-- ============================================================

function TargetManager.AddNetworkEntity(netId, options)
    if not netId or not NetworkDoesNetworkIdExist(netId) then return end
    if TargetManager._type == "ox-target" then
        local oxOpts = {}
        for i, opt in ipairs(options) do
            local capturedNetId = netId
            oxOpts[i] = {
                name = opt.name or ("net_" .. tostring(netId) .. "_" .. i),
                label = cleanLabel(opt.label),
                icon = opt.icon or "fas fa-hand",
                distance = opt.distance or 2.0,
                onSelect = function(data)
                    if opt.onSelect then
                        local entity = (type(data) == "table" and data.entity) or NetworkGetEntityFromNetworkId(capturedNetId)
                        opt.onSelect(entity)
                    end
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    if opt.canInteract then
                        return opt.canInteract(entity, distance, coords)
                    end
                    return true
                end,
            }
        end
        exports.ox_target:addEntity(netId, oxOpts)
        TargetManager._registered.entities[netId] = true
        return netId
    elseif TargetManager._type == "qb-target" then
        local entity = NetworkGetEntityFromNetworkId(netId)
        if not entity or not DoesEntityExist(entity) then return end
        local qbOpts = {}
        for i, opt in ipairs(options) do
            qbOpts[i] = {
                type = "client",
                icon = opt.icon or "fas fa-hand",
                label = cleanLabel(opt.label),
                action = function(ent)
                    if opt.onSelect then opt.onSelect(ent) end
                end,
                canInteract = function(ent, distance, coords)
                    if opt.canInteract then return opt.canInteract(ent, distance, coords) end
                    return true
                end,
            }
        end
        exports['qb-target']:AddTargetEntity(entity, {
            options = qbOpts,
            distance = options[1] and options[1].distance or 2.5,
        })
        TargetManager._registered.entities[netId] = true
        return entity
    end
end

function TargetManager.RemoveNetworkEntity(netId)
    if not netId then return end
    pcall(function()
        if TargetManager._type == "ox-target" then
            if NetworkDoesNetworkIdExist(netId) then
                exports.ox_target:removeEntity(netId)
            end
        elseif TargetManager._type == "qb-target" then
            if NetworkDoesNetworkIdExist(netId) then
                local entity = NetworkGetEntityFromNetworkId(netId)
                if entity and DoesEntityExist(entity) then
                    exports['qb-target']:RemoveTargetEntity(entity)
                end
            end
        end
    end)
    TargetManager._registered.entities[netId] = nil
end

-- ============================================================
-- MODEL FUNCTIONS
-- ============================================================

function TargetManager.AddModel(id, models, options)
    if type(models) ~= "table" then models = { models } end
    if TargetManager._type == "ox-target" then
        local oxOpts = {}
        for i, opt in ipairs(options) do
            oxOpts[i] = {
                name = opt.name or (id .. "_model_" .. i),
                label = cleanLabel(opt.label),
                icon = opt.icon or "fas fa-hand",
                distance = opt.distance or 2.0,
                onSelect = opt.onSelect,
                canInteract = opt.canInteract,
            }
        end
        exports.ox_target:addModel(models, oxOpts)
        TargetManager._registered.models[id] = { models = models, optionNames = {} }
        for _, o in ipairs(oxOpts) do
            table.insert(TargetManager._registered.models[id].optionNames, o.name)
        end
    elseif TargetManager._type == "qb-target" then
        local qbOpts = {}
        for i, opt in ipairs(options) do
            qbOpts[i] = {
                type = "client",
                icon = opt.icon or "fas fa-hand",
                label = cleanLabel(opt.label),
                action = opt.onSelect,
                canInteract = opt.canInteract,
            }
        end
        exports['qb-target']:AddTargetModel(models, {
            options = qbOpts,
            distance = options[1] and options[1].distance or 2.5,
        })
        TargetManager._registered.models[id] = { models = models }
    end
end

function TargetManager.RemoveModel(id)
    local entry = TargetManager._registered.models[id]
    if not entry then return end
    pcall(function()
        if TargetManager._type == "ox-target" then
            exports.ox_target:removeModel(entry.models, entry.optionNames)
        elseif TargetManager._type == "qb-target" then
            exports['qb-target']:RemoveTargetModel(entry.models)
        end
    end)
    TargetManager._registered.models[id] = nil
end

-- ============================================================
-- DRAWTEXT LOOP (fallback for drawtext mode)
-- ============================================================

function TargetManager.StartDrawTextLoop(id, opts)
    if TargetManager._type ~= "drawtext" then return end
    if TargetManager._drawTextLoops[id] then return end

    TargetManager._drawTextLoops[id] = true

    Citizen.CreateThread(function()
        while TargetManager._drawTextLoops[id] do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            local coords = opts.getCoords and opts.getCoords() or opts.coords
            if not coords then Citizen.Wait(500) goto continue end

            local dist = #(playerCoords - coords)
            if dist > (opts.distance or 3.0) then
                Citizen.Wait(500)
                goto continue
            end

            if opts.canInteract and not opts.canInteract() then
                Citizen.Wait(100)
                goto continue
            end

            DrawText3D(coords.x, coords.y, coords.z + (opts.zOffset or 0.0), opts.label or "[E] Interact")

            local key = opts.key or 38 -- E key
            if IsControlJustPressed(0, key) then
                local inVehicle = IsPedInAnyVehicle(playerPed, false)
                if opts.allowInVehicle or not inVehicle then
                    if opts.onSelect then opts.onSelect() end
                end
            end

            ::continue::
        end
    end)
end

function TargetManager.StopDrawTextLoop(id)
    TargetManager._drawTextLoops[id] = nil
end

-- ============================================================
-- SCOPE: Automatic lifecycle management for mission targets
-- ============================================================

function TargetManager.CreateScope(scopeId)
    local scope = {
        _id = scopeId,
        _zones = {},
        _entities = {},
        _netEntities = {},
        _models = {},
        _drawTexts = {},
    }

    function scope.AddSphereZone(id, coords, radius, options)
        local zoneId = scopeId .. "_" .. id
        local result = TargetManager.AddSphereZone(zoneId, coords, radius, options)
        if result then scope._zones[result] = true end
        return result
    end

    function scope.RemoveSphereZone(id)
        local zoneId = scopeId .. "_" .. id
        TargetManager.RemoveZone(zoneId)
        scope._zones[zoneId] = nil
    end

    function scope.AddLocalEntity(entity, options)
        TargetManager.AddLocalEntity(entity, options)
        scope._entities[entity] = true
    end

    function scope.RemoveLocalEntity(entity)
        TargetManager.RemoveLocalEntity(entity)
        scope._entities[entity] = nil
    end

    function scope.AddNetworkEntity(netId, options)
        local result = TargetManager.AddNetworkEntity(netId, options)
        if netId then scope._netEntities[netId] = true end
        return result
    end

    function scope.RemoveNetworkEntity(netId)
        TargetManager.RemoveNetworkEntity(netId)
        scope._netEntities[netId] = nil
    end

    function scope.AddModel(id, models, options)
        local modelId = scopeId .. "_" .. id
        TargetManager.AddModel(modelId, models, options)
        scope._models[modelId] = true
    end

    function scope.RemoveModel(id)
        local modelId = scopeId .. "_" .. id
        TargetManager.RemoveModel(modelId)
        scope._models[modelId] = nil
    end

    function scope.StartDrawTextLoop(id, opts)
        local loopId = scopeId .. "_" .. id
        TargetManager.StartDrawTextLoop(loopId, opts)
        scope._drawTexts[loopId] = true
    end

    function scope.StopDrawTextLoop(id)
        local loopId = scopeId .. "_" .. id
        TargetManager.StopDrawTextLoop(loopId)
        scope._drawTexts[loopId] = nil
    end

    function scope.Cleanup()
        for zoneId in pairs(scope._zones) do
            TargetManager.RemoveZone(zoneId)
        end
        for entity in pairs(scope._entities) do
            TargetManager.RemoveLocalEntity(entity)
        end
        for netId in pairs(scope._netEntities) do
            TargetManager.RemoveNetworkEntity(netId)
        end
        for modelId in pairs(scope._models) do
            TargetManager.RemoveModel(modelId)
        end
        for loopId in pairs(scope._drawTexts) do
            TargetManager.StopDrawTextLoop(loopId)
        end
        scope._zones = {}
        scope._entities = {}
        scope._netEntities = {}
        scope._models = {}
        scope._drawTexts = {}
    end

    return scope
end

-- ============================================================
-- GLOBAL CLEANUP on resource stop
-- ============================================================

function ClearAllInteractionZones()
    for entity in pairs(TargetManager._registered.entities) do
        pcall(function()
            if type(entity) == "number" and entity > 65535 then
                -- likely a netId
                TargetManager.RemoveNetworkEntity(entity)
            else
                TargetManager.RemoveLocalEntity(entity)
            end
        end)
    end
    for zoneId in pairs(TargetManager._registered.zones) do
        TargetManager.RemoveZone(zoneId)
    end
    for modelId in pairs(TargetManager._registered.models) do
        TargetManager.RemoveModel(modelId)
    end
    for loopId in pairs(TargetManager._drawTextLoops) do
        TargetManager._drawTextLoops[loopId] = nil
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ClearAllInteractionZones()
    end
end)

-- ============================================================
-- LEGACY COMPAT: ShowUniversalInteraction (drawtext fallback only)
-- For target modes, use TargetManager directly instead
-- ============================================================

local activeInteractionZones = {}

if TargetManager.IsTarget() then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local now = GetGameTimer()
            for key, zone in pairs(activeInteractionZones) do
                if now - zone.lastTime > 1000 then
                    pcall(function()
                        if TargetManager._type == "ox-target" and zone.zoneId then
                            exports.ox_target:removeZone(zone.zoneId)
                        elseif TargetManager._type == "qb-target" and zone.zoneName then
                            exports['qb-target']:RemoveZone(zone.zoneName)
                        end
                    end)
                    activeInteractionZones[key] = nil
                end
            end
        end
    end)
end

function ShowUniversalInteraction(interactionId, coords, text, distance, interactionOptions, allowInVehicle)
    if Config.InteractionHandler == "drawtext" then
        if text and type(text) == "string" then
            DrawText3D(coords.x, coords.y, coords.z, text)
        end

        if interactionOptions and interactionOptions[1] and interactionOptions[1].onSelect and
            type(interactionOptions[1].onSelect) == "function" and
            IsControlJustPressed(0, tonumber(interactionId)) and
            (allowInVehicle or not IsPedInAnyVehicle(PlayerPedId(), false)) then
            interactionOptions[1].onSelect()
        end
    else
        if not interactionOptions or not interactionOptions[1] or not interactionOptions[1].onSelect then return end

        local zoneKey = string.format("%.4f_%.4f_%.4f", coords.x, coords.y, coords.z)

        if activeInteractionZones[zoneKey] then
            activeInteractionZones[zoneKey].lastTime = GetGameTimer()
            activeInteractionZones[zoneKey].callback = interactionOptions[1].onSelect
            return
        end

        local label = text:gsub("%[E%]%s*-%s*", ""):gsub("%[G%]%s*-%s*", ""):gsub("^E%s*-%s*", "")
        local zoneData = {
            lastTime = GetGameTimer(),
            callback = interactionOptions[1].onSelect,
        }

        if Config.InteractionHandler == "ox-target" then
            zoneData.zoneId = exports.ox_target:addSphereZone({
                coords = vector3(coords.x, coords.y, coords.z),
                radius = 0.5,
                options = {
                    {
                        label = label,
                        icon = "fas fa-hand",
                        onSelect = function()
                            if activeInteractionZones[zoneKey] and activeInteractionZones[zoneKey].callback then
                                activeInteractionZones[zoneKey].callback()
                            end
                        end,
                        canInteract = function()
                            return not isInteracting
                        end,
                        distance = distance or 2.0,
                    }
                }
            })
        elseif Config.InteractionHandler == "qb-target" then
            local zoneName = base.resource .. "_ui_" .. zoneKey
            exports['qb-target']:AddCircleZone(zoneName, vector3(coords.x, coords.y, coords.z), 0.5, {
                name = zoneName,
                useZ = true,
                debugPoly = false,
            }, {
                options = {
                    {
                        type = "client",
                        icon = "fas fa-hand",
                        label = label,
                        action = function()
                            if activeInteractionZones[zoneKey] and activeInteractionZones[zoneKey].callback then
                                activeInteractionZones[zoneKey].callback()
                            end
                        end,
                        canInteract = function()
                            return not isInteracting
                        end,
                    }
                },
                distance = distance or 2.0,
            })
            zoneData.zoneName = zoneName
        end

        activeInteractionZones[zoneKey] = zoneData
    end
end

-- Safe entity existence check (prevents warning spam)
local function SafeDoesEntityExist(entity)
    if not entity or entity == 0 then return false end

    -- Try-catch protection against network warnings
    local success, exists = pcall(function()
        return DoesEntityExist(entity)
    end)

    return success and exists
end

-- Safe vehicle from netId (prevents "no object by ID" warning)
function SafeNetToVeh(netId)
    if not netId or netId == 0 then return nil end
    if not NetworkDoesNetworkIdExist(netId) then return nil end

    local success, veh = pcall(function()
        return NetToVeh(netId)
    end)

    if not success or not veh or veh == 0 then return nil end
    if not SafeDoesEntityExist(veh) then return nil end

    return veh
end

-- Safe object from netId (prevents "no object by ID" warning)
function SafeNetToObj(netId)
    if not netId or netId == 0 then return nil end
    if not NetworkDoesNetworkIdExist(netId) then return nil end

    local success, obj = pcall(function()
        return NetToObj(netId)
    end)

    if not success or not obj or obj == 0 then return nil end
    if not SafeDoesEntityExist(obj) then return nil end

    return obj
end
