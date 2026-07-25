local Config <const> = require 'config.main'
local Locations = {
    ['collect'] = {
        vec4(1003.647, -3091.922, -40.000, 0.0),
        vec4(1006.048, -3091.911, -40.000, 0.0),
        vec4(1008.474, -3091.909, -40.000, 0.0),
        vec4(1010.901, -3091.978, -40.000, 0.0),
        vec4(1013.291, -3091.938, -40.000, 0.0),
        vec4(1015.689, -3091.767, -40.000, 0.0),
        vec4(1018.126, -3091.936, -40.000, 0.0),
        vec4(1003.610, -3100.313, -40.000, 0.0),
        vec4(1006.002, -3100.345, -40.000, 0.0),
        vec4(1008.488, -3100.410, -40.000, 0.0),
        vec4(1010.927, -3100.295, -40.000, 0.0),
        vec4(1013.318, -3100.288, -40.000, 0.0),
        vec4(1015.650, -3100.294, -40.000, 0.0),
        vec4(1018.115, -3100.216, -40.000, 0.0),
        vec4(1018.195, -3108.182, -40.000, 0.0),
        vec4(1015.658, -3108.212, -40.000, 0.0),
        vec4(1013.257, -3108.150, -40.000, 0.0),
        vec4(1010.836, -3108.089, -40.000, 0.0),
        vec4(1008.431, -3108.160, -40.000, 0.0),
        vec4(1006.021, -3108.170, -40.000, 0.0),
        vec4(1003.603, -3108.255, -40.000, 0.0),
        vec4(993.539, -3106.456, -40.000, 90.0),
        vec4(993.592, -3108.917, -40.000, 90.0),
        vec4(993.461, -3111.262, -40.000, 90.0),
        vec4(1026.497, -3111.328, -40.000, 90.0),
        vec4(1026.464, -3108.944, -40.000, 90.0),
        vec4(1026.497, -3106.577, -40.000, 90.0),
        vec4(1003.647, -3091.922, -37.835, 0.0),
        vec4(1006.048, -3091.911, -37.835, 0.0),
        vec4(1008.474, -3091.909, -37.835, 0.0),
        vec4(1010.901, -3091.978, -37.835, 0.0),
        vec4(1013.291, -3091.938, -37.835, 0.0),
        vec4(1015.689, -3091.767, -37.835, 0.0),
        vec4(1018.126, -3091.936, -37.835, 0.0),
        vec4(1003.610, -3100.313, -37.835, 0.0),
        vec4(1006.002, -3100.345, -37.835, 0.0),
        vec4(1008.488, -3100.410, -37.835, 0.0),
        vec4(1010.927, -3100.295, -37.835, 0.0),
        vec4(1013.318, -3100.288, -37.835, 0.0),
        vec4(1015.650, -3100.294, -37.835, 0.0),
        vec4(1018.115, -3100.216, -37.835, 0.0),
        vec4(1018.195, -3108.182, -37.835, 0.0),
        vec4(1015.658, -3108.212, -37.835, 0.0),
        vec4(1013.257, -3108.150, -37.835, 0.0),
        vec4(1010.836, -3108.089, -37.835, 0.0),
        vec4(1008.431, -3108.160, -37.835, 0.0),
        vec4(1006.021, -3108.170, -37.835, 0.0),
        vec4(1003.603, -3108.255, -37.835, 0.0),
        vec4(993.539, -3106.456, -37.835, 90.0),
        vec4(993.592, -3108.917, -37.835, 90.0),
        vec4(993.461, -3111.262, -37.835, 90.0),
        vec4(1026.497, -3111.328, -37.835, 90.0),
        vec4(1026.464, -3108.944, -37.835, 90.0),
        vec4(1026.497, -3106.577, -37.835, 90.0),
    },
    ['dropoff'] = {
        vec4(1025.782, -3092.712, -39.402, 90.0),
        vec4(1025.842, -3094.755, -39.402, 90.0),
        vec4(1025.852, -3096.752, -39.402, 90.0),
        vec4(1025.836, -3098.784, -39.402, 90.0),
    },
    ['vehicles'] =  {
        vec4(1008.94, -3104.35, -40.55, 270.08),
        vec4(1009.15, -3096.04, -40.55, 270.23)
    },
    ['management'] = vec4(993.02, -3095.77, -40.0, 184.8),
    ['exit'] = vec4(992.32, -3097.9, -40.0, 270.76),
    ['controller'] = vec4(1023.71, -3100.62, -40.0, 273.41)
}

local PalettsModels = {
    `sm_prop_smug_crate_m_bones`,
    `ba_prop_battle_crate_m_antiques`,
    `h4_prop_h4_boxpile_01b`,
    `v_ind_meatpacks_03`,
    `prop_boxpile_02c`,
    `ba_prop_battle_crate_closed_bc`,
    `ba_prop_battle_crate_m_tobacco`,
}

local ForkliftCarryingObject = {}
local PalletObject = {}
local DropOffReferenceObjects = {}
local DropOffObjects = {}

local isDropOffAnimationRunning = false
local isControllerBusy = false

local ActiveControllerPoint = nil
local ActiveManagementPoint = nil
local ActiveSyncControllerPoint = nil

function CleanupTaskEntities(vehicles, managementPed)
    if ForkliftCarryingObject and ForkliftCarryingObject.entity and DoesEntityExist(ForkliftCarryingObject.entity) then
        DeleteEntity(ForkliftCarryingObject.entity)
    end
    ForkliftCarryingObject = {}

    for _, object in pairs(DropOffReferenceObjects) do
        if object and DoesEntityExist(object.entity) then
            DeleteEntity(object.entity)
        end
    end
    DropOffReferenceObjects = {}

    for _, object in pairs(DropOffObjects) do
        if object and DoesEntityExist(object.entity) then
            DeleteEntity(object.entity)
        end
    end
    DropOffObjects = {}

    for _, pallet in pairs(PalletObject) do
        if pallet and pallet.entity and DoesEntityExist(pallet.entity) then
            DeleteEntity(pallet.entity)
        end
    end
    PalletObject = {}

    if vehicles then
        for _, vehicle in pairs(vehicles) do
            local veh = NetworkGetEntityFromNetworkId(vehicle.netId)
            if veh and DoesEntityExist(veh) then
                DeleteEntity(veh)
            end
        end
    end

    if managementPed and DoesEntityExist(managementPed) then
        DeleteEntity(managementPed)
    end

    if Target and Config.UseTarget then
        pcall(function() Target.RemoveZone('forklift_multiplayer_controller') end)
        pcall(function() Target.RemoveZone('forklift_multiplayer_management') end)
    else
        if ActiveControllerPoint then
            ActiveControllerPoint:remove()
            ActiveControllerPoint = nil
        end
        if ActiveManagementPoint then
            ActiveManagementPoint:remove()
            ActiveManagementPoint = nil
        end
        if ActiveSyncControllerPoint then
            ActiveSyncControllerPoint:remove()
            ActiveSyncControllerPoint = nil
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if not CurrentMultiplayerData or next(CurrentMultiplayerData) == nil then return end
        if not CurrentMultiplayerData.settings or not CurrentMultiplayerData.settings.task then return end
        if not CurrentMultiplayerData.settings.task.started then return end

        CleanupTaskEntities()
    end
end)

local function GetRandomPalletModel()
    return PalettsModels[math.random(#PalettsModels)]
end

local function SpawnPallet(model, coords)
    Debug('info', '[SpawnPallet] Spawning pallet at %.2f, %.2f, %.2f', coords.x, coords.y, coords.z)
    if not HasModelLoaded(model) then
        lib.requestModel(model, 10000)
    end

    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)

    SetEntityHeading(obj, coords.w or 0.0)
    FreezeEntityPosition(obj, false)
    SetEntityCollision(obj, false, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetModelAsNoLongerNeeded(model)

    return obj
end

local function CreateDropOffReferenceObjects()
    for _, pallet in pairs(Locations['dropoff']) do
        local model = `prop_boxpile_03a`

        if not HasModelLoaded(model) then
            lib.requestModel(model, 10000)
        end

        local obj = CreateObject(model, pallet.x, pallet.y, pallet.z, false, true, false)
        SetEntityHeading(obj, pallet.w or 0.0)
        FreezeEntityPosition(obj, true)
        SetEntityAsMissionEntity(obj, true, true)
        SetEntityVisible(obj, false, false)
        SetEntityCollision(obj, false, true)
        SetModelAsNoLongerNeeded(model)

        DropOffReferenceObjects[#DropOffReferenceObjects + 1] = {
            id = tostring(#DropOffReferenceObjects + 1),
            entity = obj,
            model = model,
            coords = pallet
        }
    end
end

local function PlayControllerAnimation(callback)
    if isControllerBusy then return end
    isControllerBusy = true

    CreateThread(function()
        local ped = cache.ped

        FreezeEntityPosition(ped, true)

        local animDict = 'anim_heist@hs3f@ig6_push_button@male@'
        local animName = 'push_button'

        if not HasAnimDictLoaded(animDict) then
            lib.requestAnimDict(animDict, 10000)
        end

        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

        Wait(100)
        while IsEntityPlayingAnim(ped, animDict, animName, 3) do
            Wait(100)
        end

        ClearPedTasks(ped)
        RemoveAnimDict(animDict)

        FreezeEntityPosition(ped, false)

        if callback then
            callback()
        end

        isControllerBusy = false
    end)
end

local function PlayDropOffAnimation()
    if isDropOffAnimationRunning then return end
    isDropOffAnimationRunning = true
    Debug('info', '[PlayDropOffAnimation] Starting drop off animation')

    local animationSteps = 240
    local stepDelay = 15
    local moveDistance = 30.0
    local cleanupDelay = 100

    local function easeInOutQuad(t)
        return t < 0.5 
            and 2 * t * t 
            or 1 - ((-2 * t + 2) ^ 2) / 2
    end

    local function lerp(start, target, t)
        return start + (target - start) * t
    end

    local function getValidEntities()
        local entities = {}

        for _, data in ipairs(DropOffObjects) do
            if data?.entity and DoesEntityExist(data.entity) then
                table.insert(entities, data.entity)
            end
        end

        return entities
    end

    local function animateEntity(entity)
        CreateThread(function()
            FreezeEntityPosition(entity, true)
            SetEntityCollision(entity, false, false)

            local startPos = GetEntityCoords(entity)
            local targetPos = vector3(
                startPos.x,
                startPos.y + moveDistance,
                startPos.z
            )

            for step = 1, animationSteps do
                if not DoesEntityExist(entity) then
                    break
                end

                local progress = step / animationSteps
                local easedProgress = easeInOutQuad(progress)

                local currentPos = vector3(
                    lerp(startPos.x, targetPos.x, easedProgress),
                    lerp(startPos.y, targetPos.y, easedProgress),
                    lerp(startPos.z, targetPos.z, easedProgress)
                )

                SetEntityCoordsNoOffset(
                    entity,
                    currentPos.x,
                    currentPos.y,
                    currentPos.z,
                    false,
                    false,
                    false
                )

                Wait(stepDelay)
            end

            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end)
    end

    local entitiesToMove = getValidEntities()

    if #entitiesToMove == 0 then
        isDropOffAnimationRunning = false
        return
    end

    for _, entity in ipairs(entitiesToMove) do
        animateEntity(entity)
    end

    Wait((animationSteps * stepDelay) + cleanupDelay)
    DropOffObjects = {}
    isDropOffAnimationRunning = false
    Debug('success', '[PlayDropOffAnimation] Drop off animation completed')
end

local function MoveDropOffObjectsSmooth()
    if isDropOffAnimationRunning then return end
    Debug('info', '[MoveDropOffObjectsSmooth] Triggering drop off animation sync')
    TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'startDropOffAnimation')
    PlayDropOffAnimation()
    TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'resetDropOffObjects')
end

local function canStopJob(selectedTask)
    return CurrentMultiplayerData
        and CurrentMultiplayerData.settings
        and CurrentMultiplayerData.settings.task
        and CurrentMultiplayerData.settings.task.started
        and selectedTask
        and selectedTask.setting
        and CurrentMultiplayerData.settings.task.progress < selectedTask.setting.palletsNumber
end

local function canCompleteJob(selectedTask)
    return CurrentMultiplayerData
        and CurrentMultiplayerData.settings
        and CurrentMultiplayerData.settings.task
        and CurrentMultiplayerData.settings.task.started
        and selectedTask
        and selectedTask.setting
        and CurrentMultiplayerData.settings.task.progress >= selectedTask.setting.palletsNumber
        and CurrentMultiplayerData.settings.objects
        and CurrentMultiplayerData.settings.objects.dropoff == 0
end

local function IsOvertime()
    if not Config.Overtime.enabled then return false end

    local hour = GetClockHours()
    local min = Config.Overtime.min
    local max = Config.Overtime.max

    if min > max then
        return hour >= min or hour < max
    else
        return hour >= min and hour < max
    end
end

local isBusy = false
local lastManagementPressTime = 0
lib.onCache('vehicle', function(value, oldValue)
    if not CurrentMultiplayerData or next(CurrentMultiplayerData) == nil then return end
    if not CurrentMultiplayerData.settings or not CurrentMultiplayerData.settings.task then return end
    if not CurrentMultiplayerData.settings.task.started then return end

    if GetEntityModel(GetVehiclePedIsIn(cache.ped, false)) ~= `forklift` then return end

    while IsPedInAnyVehicle(cache.ped, false) and GetEntityModel(GetVehiclePedIsIn(cache.ped, false)) == `forklift` do
        local sleep = 1000
        local vehicle = GetVehiclePedIsIn(cache.ped, false)

        if not isBusy and (not ForkliftCarryingObject or next(ForkliftCarryingObject) == nil) and CurrentMultiplayerData.settings.objects.dropoff < 4 then
            local boneCoords = GetEntityBonePosition_2(vehicle, 4)
            local closestPallet = nil
            local closestDistance = math.huge

            for _, pallet in pairs(PalletObject) do
                if pallet.entity and DoesEntityExist(pallet.entity) then
                    local dist = #(GetEntityCoords(pallet.entity) - boneCoords)
                    if dist < closestDistance then
                        closestDistance = dist
                        closestPallet = pallet
                    end
                end
            end

            if closestPallet and closestDistance < 2.0 then
                isBusy = true

                DeleteEntity(closestPallet.entity)

                for idx, p in pairs(PalletObject) do
                    if p.id == closestPallet.id then
                        table.remove(PalletObject, idx)
                        break
                    end
                end

                TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'palletCollected', closestPallet.id)

                local propHash = closestPallet.model
                if not HasModelLoaded(propHash) then
                    lib.requestModel(propHash, 10000)
                end

                local prop = CreateObject(propHash, boneCoords.x, boneCoords.y, boneCoords.z, true, true, false)
                SetEntityVisible(prop, false, false)
                SetEntityAsMissionEntity(prop, true, true)
                SetEntityCollision(prop, false, false)
                SetModelAsNoLongerNeeded(propHash)
                AttachEntityToEntity(prop, vehicle, 4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 2, true)

                local timeout = 0
                while not IsEntityAttached(prop) and timeout < 20 do
                    Wait(100)
                    AttachEntityToEntity(prop, vehicle, 4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 2, true)
                    timeout = timeout + 1
                end

                SetEntityVisible(prop, true, false)
                ForkliftCarryingObject = { entity = prop, model = propHash }
                isBusy = false
            elseif closestDistance < 4.0 then
                sleep = 100
            end

        elseif ForkliftCarryingObject and next(ForkliftCarryingObject) ~= nil then
            sleep = 0
            local vehicle = GetVehiclePedIsIn(cache.ped, false)
            local boneCoords = GetEntityBonePosition_2(vehicle, 5)

            local dropOff = false
            local drawCoords = vector3(1025.8198, -3094.6272, -37)
            if CurrentMultiplayerData.settings.objects.dropoff >= 4 then
                DrawMarker(28, drawCoords.x, drawCoords.y, drawCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 0, 0, 100, false, true, 2, nil, nil, false)
            else
                DrawMarker(28, drawCoords.x, drawCoords.y, drawCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 165, 0, 100, false, true, 2, nil, nil, false)
            end

            for _, coords in pairs(Locations['dropoff']) do

                local distance = #(boneCoords - vec3(coords.x, coords.y, coords.z))
                if distance < 3.0 then
                    dropOff = true
                    break
                end
            end

            if dropOff and CurrentMultiplayerData.settings.objects.dropoff < 4 then
                DetachEntity(ForkliftCarryingObject.entity, true, true)
                DeleteEntity(ForkliftCarryingObject.entity)

                local index = 1
                if CurrentMultiplayerData.settings.objects.dropoff > 0 then
                    index = CurrentMultiplayerData.settings.objects.dropoff + 1
                end

                local model = ForkliftCarryingObject.model
                local dropoffLocation = Locations['dropoff'][index]

                TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'palletDelivered', {
                    model = ForkliftCarryingObject.model,
                })


                if not HasModelLoaded(model) then
                    lib.requestModel(model, 10000)
                end

                local obj = CreateObject(model, dropoffLocation.x, dropoffLocation.y, dropoffLocation.z - 0.05, false, true, false)
                SetEntityHeading(obj, dropoffLocation.w or 0.0)
                FreezeEntityPosition(obj, true)
                SetEntityAsMissionEntity(obj, true, true)
                SetEntityVisible(obj, true, true)
                SetEntityCollision(obj, false, true)
                SetModelAsNoLongerNeeded(model)

                DropOffObjects[#DropOffObjects + 1] = {
                    id = tostring(#DropOffObjects + 1),
                    entity = obj,
                    model = model,
                    coords = dropoffLocation
                }

                ForkliftCarryingObject = {}

                for _, object in pairs(DropOffReferenceObjects) do
                    SetEntityDrawOutline(object.entity, false)
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent(Event('client:startMultiplayerTask'), function()
    lastManagementPressTime = 0
    Debug('info', '[client:startMultiplayerTask] Starting multiplayer task')
    if not CurrentMultiplayerData or next(CurrentMultiplayerData) == nil then
        Debug('error', '[client:startMultiplayerTask] Not in team')
        Notify.SendNotify(locale('notification.error.not_in_team'), 'error')
        return
    end

    if not CurrentMultiplayerData.settings.task or not CurrentMultiplayerData.settings.task.started then
        Debug('error', '[client:startMultiplayerTask] Task already started')
        Notify.SendNotify(locale('notification.error.task_already_started'), 'error')
        return
    end

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Wait(100)
    end

    TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'startTask')

    local ped = cache.ped
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, Locations['exit'].x, Locations['exit'].y, Locations['exit'].z, false, false, false, true)
    SetEntityHeading(ped, Locations['exit'].w)

    while not HasCollisionLoadedAroundEntity(ped) do
        Wait(50)
    end

    local memberCount = #CurrentMultiplayerData.members
    for i, location in pairs(Locations['vehicles']) do
        if i > memberCount then break end

        local vehilceModel = `forklift`
        if not HasModelLoaded(vehilceModel) then
            lib.requestModel(vehilceModel, 10000)
        end

        local vehicle = CreateVehicle(vehilceModel, location.x, location.y, location.z, location.w, true, false)
        SetModelAsNoLongerNeeded(vehilceModel)
        if Fuel then
            Fuel.SetFuel(vehicle, 100.0)
        end

        if VehicleKey then
            VehicleKey.GiveKeys(vehicle, GetVehicleNumberPlateText(vehicle))
        end

        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        while not NetworkDoesNetworkIdExist(netId) do
            Wait(100)
        end

        TriggerServerEvent(Event('server:registerNetId'), CurrentMultiplayerData.teamId, 'vehicle', netId, GetVehicleNumberPlateText(vehicle))
    end

    local pedModel = `s_m_m_dockwork_01`
    if not HasModelLoaded(pedModel) then
        lib.requestModel(pedModel, 10000)
    end

    local managementPed = CreatePed(4, pedModel, Locations['management'].x, Locations['management'].y, Locations['management'].z, Locations['management'].w, true, true)
    TaskStartScenarioInPlace(managementPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    SetEntityAsMissionEntity(managementPed, true, true)
    SetEntityInvincible(managementPed, true)
    SetBlockingOfNonTemporaryEvents(managementPed, true)
    FreezeEntityPosition(managementPed, true)

    local netId = NetworkGetNetworkIdFromEntity(managementPed)
    while not NetworkDoesNetworkIdExist(netId) do
        Wait(100)
    end

    local selectedTask = Config.Tasks[CurrentMultiplayerData.settings.task.id]
    if not selectedTask then return end

    local collectLocations = Locations['collect']
    local availableIndexes = {}
    for i = 1, #collectLocations do
        table.insert(availableIndexes, i)
    end

    for i = #availableIndexes, 2, -1 do
        local j = math.random(i)
        availableIndexes[i], availableIndexes[j] = availableIndexes[j], availableIndexes[i]
    end

    local spawned = 0
    local maxPallets = selectedTask.setting.palletsNumber

    for _, index in ipairs(availableIndexes) do
        if spawned >= maxPallets then break end

        local coords = collectLocations[index]
        local model = GetRandomPalletModel()
        local pallet = SpawnPallet(model, coords)

        PalletObject[#PalletObject + 1] = {
            id = tostring(#PalletObject + 1),
            entity = pallet,
            model = model,
            coords = coords
        }
        spawned = spawned + 1
    end

    Debug('success', '[client:startMultiplayerTask] Spawned %d pallets for task', spawned)

    CreateDropOffReferenceObjects()

    local controllerCoords = Locations['controller']
    if Target and Config.UseTarget then
        Target.AddSphereZone('forklift_multiplayer_controller', controllerCoords, 2.5, {
            {
                name = 'forklift_multiplayer_controller',
                icon = 'fa-solid fa-clipboard-list',
                label = locale('target.controller.label'),
                onSelect = function()
                    PlayControllerAnimation(MoveDropOffObjectsSmooth)
                end,
                canInteract = function()
                    return CurrentMultiplayerData
                        and CurrentMultiplayerData.settings
                        and CurrentMultiplayerData.settings.task
                        and CurrentMultiplayerData.settings.task.started
                        and CurrentMultiplayerData.settings.objects.dropoff == 4
                        and not cache.vehicle
                end
            }
        })

        Target.AddSphereZone('forklift_multiplayer_management', Locations['management'], 2.5, {
            {
                name = 'forklift_multiplayer_stop',
                icon = 'fa-solid fa-stop',
                label = locale('target.management.stop_job'),
                onSelect = function()
                    local currentTime = GetGameTimer()
                    if (currentTime - lastManagementPressTime) < 1000 then return end
                    lastManagementPressTime = currentTime
                    CleanupTaskEntities(CurrentMultiplayerData.settings.vehicles)
                    TriggerServerEvent(Event('server:stopMultiplayerTask'), CurrentMultiplayerData.teamId)
                end,
                canInteract = function()
                    return canStopJob(selectedTask)
                end
            },
            {
                name = 'forklift_multiplayer_complete',
                icon = 'fa-solid fa-check',
                label = locale('target.management.complete_job'),
                onSelect = function()
                    local currentTime = GetGameTimer()
                    if (currentTime - lastManagementPressTime) < 1000 then return end
                    lastManagementPressTime = currentTime
                    CleanupTaskEntities(CurrentMultiplayerData.settings.vehicles, managementPed)
                    TriggerServerEvent(Event('server:completeMultiplayerTask'), CurrentMultiplayerData.teamId)
                end,
                canInteract = function()
                    return canCompleteJob(selectedTask)
                end
            }
        })
    else
        ActiveControllerPoint = lib.points.new({
            coords = controllerCoords,
            distance = 2.5,
        })

        function ActiveControllerPoint:onEnter()
            local isAviable = CurrentMultiplayerData and CurrentMultiplayerData.settings.task.started and CurrentMultiplayerData.settings.objects.dropoff == 4
            if not isAviable then return end
            HelpText.ShowHelpText(Config.Interaction.label .. " " .. locale('target.controller.label'), 'left-center')
        end

        function ActiveControllerPoint:onExit()
            HelpText.HideHelpText()
        end

        function ActiveControllerPoint:nearby()
            local isAviable = CurrentMultiplayerData and CurrentMultiplayerData.settings.task.started and CurrentMultiplayerData.settings.objects.dropoff == 4
            if not isAviable then goto continue end
            if isControllerBusy then goto continue end

            if self.currentDistance < 2.5 and IsControlJustReleased(0, Config.Interaction.id) and not cache.vehicle then
                PlayControllerAnimation(MoveDropOffObjectsSmooth)
            end

            ::continue::
        end

        ActiveManagementPoint = lib.points.new({
            coords = Locations['management'],
            distance = 2.5,
        })

        function ActiveManagementPoint:onEnter()
            if canStopJob(selectedTask) then
                HelpText.ShowHelpText(Config.Interaction.label .. " " .. locale('target.management.stop_job'), 'left-center')
            elseif canCompleteJob(selectedTask) then
                HelpText.ShowHelpText(Config.Interaction.label .. " " .. locale('target.management.complete_job'), 'left-center')
            end
        end

        function ActiveManagementPoint:onExit()
            HelpText.HideHelpText()
        end

        function ActiveManagementPoint:nearby()
            local currentTime = GetGameTimer()
            if self.currentDistance < 2.5 and IsControlJustReleased(0, Config.Interaction.id) and not cache.vehicle then
                if (currentTime - lastManagementPressTime) < 1000 then return end

                if canStopJob(selectedTask) then
                    lastManagementPressTime = currentTime
                    CleanupTaskEntities(CurrentMultiplayerData.settings.vehicles, managementPed)
                    TriggerServerEvent(Event('server:stopMultiplayerTask'), CurrentMultiplayerData.teamId)
                elseif canCompleteJob(selectedTask) then
                    lastManagementPressTime = currentTime
                    CleanupTaskEntities(CurrentMultiplayerData.settings.vehicles)
                    TriggerServerEvent(Event('server:completeMultiplayerTask'), CurrentMultiplayerData.teamId, IsOvertime())
                end
            end
        end
    end

    TriggerServerEvent(Event('server:registerNetId'), CurrentMultiplayerData.teamId, 'managementPed', netId, nil)
    TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'recieveVehiclekey')
    TriggerServerEvent(Event('server:syncMultiplayerData'), CurrentMultiplayerData.teamId, 'spawnedPallets', PalletObject)

    FreezeEntityPosition(ped, false)

    DoScreenFadeIn(1000)

    local totalPallets = selectedTask.setting.palletsNumber
    NuiMessage('task/toggle-info', {
        show = true,
        totalPallets = totalPallets,
    })
end)

RegisterNetEvent(Event('client:syncMultiplayerData'), function(action, ...)
    Debug('info', '[client:syncMultiplayerData] Received sync action: %s', action)
    if not CurrentMultiplayerData or next(CurrentMultiplayerData) == nil then return end
    if not CurrentMultiplayerData.settings or not CurrentMultiplayerData.settings.task then return end
    if not CurrentMultiplayerData.settings.task.started then return end
    if action == 'recieveVehiclekey' then
        Debug('info', '[client:syncMultiplayerData] Processing vehicle keys')
        for _, vehicle in pairs(CurrentMultiplayerData.settings.vehicles or {}) do
            local plate = vehicle.plate
            local netId = vehicle.netId
            if not netId then goto continue end

            local veh = NetworkGetEntityFromNetworkId(netId)
            local attempts = 0
            while not veh or not DoesEntityExist(veh) do
                Wait(100)
                veh = NetworkGetEntityFromNetworkId(netId)
                attempts = attempts + 1
                if attempts >= 50 then
                    Debug('error', 'Failed to retrieve vehicle entity from netId: ' .. tostring(netId))
                    goto continue
                end
            end

            if plate and VehicleKey then
                VehicleKey.GiveKeys(veh, plate)
            end

            ::continue::
        end
    elseif action == 'startTask' then
        Debug('info', '[client:syncMultiplayerData] Starting task, teleporting player')
        DoScreenFadeOut(1000)

        while not IsScreenFadedOut() do
            Wait(100)
        end

        local ped = cache.ped
        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, Locations['exit'].x, Locations['exit'].y, Locations['exit'].z, false, false, false, true)
        SetEntityHeading(ped, Locations['exit'].w)

        while not HasCollisionLoadedAroundEntity(ped) do
            Wait(50)
        end

        TriggerServerEvent(Event('server:setRoutingBucket'), CurrentMultiplayerData.teamId, CurrentMultiplayerData.settings.task.started)

        CreateDropOffReferenceObjects()

        local controllerCoords = Locations['controller']
        if Target and Config.UseTarget then
            Target.AddSphereZone('forklift_multiplayer_controller', controllerCoords, 2.5, {
                {
                    name = 'forklift_multiplayer_controller',
                    icon = 'fa-solid fa-clipboard-list',
                    label = locale('target.controller.label'),
                    onSelect = function()
                        PlayControllerAnimation(MoveDropOffObjectsSmooth)
                    end,
                    canInteract = function()
                        return CurrentMultiplayerData
                            and CurrentMultiplayerData.settings
                            and CurrentMultiplayerData.settings.task
                            and CurrentMultiplayerData.settings.task.started
                            and CurrentMultiplayerData.settings.objects.dropoff < 4
                            and not cache.vehicle
                    end
                }
            })
        else
            ActiveSyncControllerPoint = lib.points.new({
                coords = controllerCoords,
                distance = 2.5,
            })

            function ActiveSyncControllerPoint:onEnter()
                local isAviable = CurrentMultiplayerData and CurrentMultiplayerData.settings.task.started and CurrentMultiplayerData.settings.objects.dropoff == 4
                if not isAviable then return end
                HelpText.ShowHelpText(Config.Interaction.label .. " " .. locale('target.controller.label'), 'left-center')
            end

            function ActiveSyncControllerPoint:onExit()
                HelpText.HideHelpText()
            end

            function ActiveSyncControllerPoint:nearby()
                local isAviable = CurrentMultiplayerData and CurrentMultiplayerData.settings.task.started and CurrentMultiplayerData.settings.objects.dropoff == 4
                if not isAviable then goto continue end

                if self.currentDistance < 2.5 and IsControlJustReleased(0, Config.Interaction.id) and not cache.vehicle then
                    PlayControllerAnimation(MoveDropOffObjectsSmooth)
                end

                ::continue::
            end
    end

        FreezeEntityPosition(ped, false)
        DoScreenFadeIn(1000)

        local totalPallets = Config.Tasks[CurrentMultiplayerData.settings.task.id].setting.palletsNumber
        NuiMessage('task/toggle-info', {
            show = true,
            totalPallets = totalPallets,
        })
    elseif action == 'spawnedPallets' then
        Debug('info', '[client:syncMultiplayerData] Processing spawned pallets')
        local taskData = CurrentMultiplayerData.settings.task
        if not taskData then return end

        local selectedTask = Config.Tasks[taskData.id]
        if not selectedTask then return end

        local pallets = ...
        if not pallets or next(pallets) == nil then return end
        Debug('info', '[client:syncMultiplayerData] Spawning %d pallets', #pallets)

        for _, palletInfo in pairs(pallets) do
            local model = palletInfo.model
            local coords = palletInfo.coords
            local pallet = SpawnPallet(palletInfo.model, palletInfo.coords)

            PalletObject[#PalletObject + 1] = {
                id = tostring(#PalletObject + 1),
                entity = pallet,
                model = model,
                coords = coords
            }
        end
    elseif action == 'palletCollected' then
        local palletId = ...
        if not palletId then return end
        Debug('info', '[client:syncMultiplayerData] Pallet %s collected by other player', palletId)

        for i, pallet in pairs(PalletObject) do
            if pallet.id == palletId then
                if pallet.entity and DoesEntityExist(pallet.entity) then
                    DeleteEntity(pallet.entity)
                end
                table.remove(PalletObject, i)
                break
            end
        end
    elseif action == 'palletDelivered' then
        local palletData = ...
        if not palletData then return end
        if CurrentMultiplayerData.settings.objects.dropoff > 4 then return end
        Debug('info', '[client:syncMultiplayerData] Pallet delivered, dropoff count: %d', CurrentMultiplayerData.settings.objects.dropoff)

        local index = CurrentMultiplayerData.settings.objects.dropoff

        local model = palletData.model
        local dropoffLocation = Locations['dropoff'][index]

        if not HasModelLoaded(model) then
            lib.requestModel(model, 10000)
        end

        local obj = CreateObject(model, dropoffLocation.x, dropoffLocation.y, dropoffLocation.z - 0.05, false, true, false)
        SetEntityHeading(obj, dropoffLocation.w or 0.0)
        FreezeEntityPosition(obj, true)
        SetEntityAsMissionEntity(obj, true, true)
        SetEntityVisible(obj, true, true)
        SetEntityCollision(obj, false, true)
        SetModelAsNoLongerNeeded(model)

        DropOffObjects[#DropOffObjects + 1] = {
            id = tostring(#DropOffObjects + 1),
            entity = obj,
            model = model,
            coords = dropoffLocation
        }
    elseif action == 'startDropOffAnimation' then
        Debug('info', '[client:syncMultiplayerData] Starting drop off animation from sync')
        PlayDropOffAnimation()
    end
end)