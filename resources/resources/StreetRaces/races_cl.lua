local RACE_STATE_NONE = 0
local RACE_STATE_JOINED = 1
local RACE_STATE_RACING = 2
local RACE_STATE_RECORDING = 3
local RACE_CHECKPOINT_TYPE = 45
local RACE_CHECKPOINT_FINISH_TYPE = 9

local races = {}
local raceStatus = {
    state = RACE_STATE_NONE,
    index = 0,
    checkpoint = 0
}

local recordedCheckpoints = {}
local textUIActive = false
local ownedRaceIndex = 0
local pendingCreate = false

local function notify(message, type)
    lib.notify({
        title = Config.Locale.menuTitle,
        description = message,
        type = type or 'info',
        position = Config.NotificationPosition,
        duration = Config.NotificationDuration
    })
end

local function showTextUI(text)
    if Config.UseTextUI and not textUIActive then
        lib.showTextUI(text, {
            position = "right-center"
        })
        textUIActive = true
    end
end

local function hideTextUI()
    if textUIActive then
        lib.hideTextUI()
        textUIActive = false
    end
end

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function setupRaceCheckpoints(race)
    local checkpoints = race.checkpoints
    for cpIndex, checkpoint in pairs(checkpoints) do
        if not checkpoint.blip then
            checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
            SetBlipColour(checkpoint.blip, Config.CheckpointBlipColor)
            SetBlipAsShortRange(checkpoint.blip, true)
            ShowNumberOnBlip(checkpoint.blip, cpIndex)
        end
    end

    SetWaypointOff()
    if checkpoints[1] and checkpoints[1].blip then
        SetBlipRoute(checkpoints[1].blip, true)
        SetBlipRouteColour(checkpoints[1].blip, Config.CheckpointBlipColor)
    end
end

function cleanupRace()
    if raceStatus.index ~= 0 then
        local race = races[raceStatus.index]
        if race then
            local checkpoints = race.checkpoints
            for _, checkpoint in pairs(checkpoints) do
                if checkpoint.blip then
                    RemoveBlip(checkpoint.blip)
                end
                if checkpoint.checkpoint then
                    DeleteCheckpoint(checkpoint.checkpoint)
                end
            end

            if raceStatus.state == RACE_STATE_RACING then
                local lastCheckpoint = checkpoints[#checkpoints]
                SetNewWaypoint(lastCheckpoint.coords.x, lastCheckpoint.coords.y)
            end

            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            FreezeEntityPosition(ped, false)
            if vehicle ~= 0 then
                FreezeEntityPosition(vehicle, false)
            end
        end
    end
    hideTextUI()
end

function cleanupRecording()
    for _, checkpoint in pairs(recordedCheckpoints) do
        if checkpoint.blip then
            RemoveBlip(checkpoint.blip)
            checkpoint.blip = nil
        end
    end
    recordedCheckpoints = {}
    hideTextUI()
end

local function openSavedRacesMenu()
    TriggerServerEvent('StreetRaces:getSavedRaces_sv')
end

local function showSavedRacesMenu(savedRaces)
    if not savedRaces or #savedRaces == 0 then
        notify(Config.Locale.noRaces, 'error')
        return
    end

    local options = {}
    for _, raceName in ipairs(savedRaces) do
        table.insert(options, {
            title = raceName,
            icon = 'flag-checkered',
            onSelect = function()
                showRaceActionsMenu(raceName)
            end
        })
    end

    lib.registerContext({
        id = 'saved_races_menu',
        title = Config.Locale.listRaces,
        options = options
    })

    lib.showContext('saved_races_menu')
end

function showRaceActionsMenu(raceName)
    lib.registerContext({
        id = 'race_actions_menu',
        title = raceName,
        menu = 'saved_races_menu',
        options = {
            {
                title = Config.Locale.loadRace,
                description = Config.Locale.loadRaceForEdit,
                icon = 'download',
                onSelect = function()
                    TriggerServerEvent('StreetRaces:loadRace_sv', raceName)
                end
            },
            {
                title = Config.Locale.deleteRace,
                description = Config.Locale.permanentlyDelete,
                icon = 'trash',
                iconColor = 'red',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = Config.Locale.deleteRaceConfirm,
                        content = Config.Locale.deleteRaceQuestion:format(raceName),
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        TriggerServerEvent('StreetRaces:deleteRace_sv', raceName)
                    end
                end
            }
        }
    })

    lib.showContext('race_actions_menu')
end

function openMainMenu()
    local options = {}

    -- Check if player has race chip
    local hasRaceChip = lib.callback.await('StreetRaces:hasRaceChip', false)

    -- Record new race (only if has race chip)
    if hasRaceChip then
        table.insert(options, {
            title = Config.Locale.recordRace,
            description = Config.Locale.recordRaceDesc,
            icon = 'video',
            onSelect = function()
                if raceStatus.state == RACE_STATE_JOINED or raceStatus.state == RACE_STATE_RACING then
                    notify(Config.Locale.alreadyInRace, 'error')
                    return
                end
                SetWaypointOff()
                cleanupRecording()
                raceStatus.state = RACE_STATE_RECORDING
                notify(Config.Locale.recordingStarted, 'success')
            end
        })
    end

    -- Save recorded race (only if has race chip)
    if #recordedCheckpoints > 0 and hasRaceChip then
        table.insert(options, {
            title = Config.Locale.saveRace,
            description = Config.Locale.saveRaceDesc .. ' (' .. #recordedCheckpoints .. ' checkpoints)',
            icon = 'floppy-disk',
            iconColor = 'green',
            onSelect = function()
                local input = lib.inputDialog(Config.Locale.saveRace, {
                    {
                        type = 'input',
                        label = Config.Locale.enterRaceName,
                        description = Config.Locale.enterRaceNameDesc,
                        required = true,
                        min = 3,
                        max = 50
                    }
                })

                if input and input[1] then
                    TriggerServerEvent('StreetRaces:saveRace_sv', input[1], recordedCheckpoints)
                    raceStatus.state = RACE_STATE_NONE
                    cleanupRecording()
                end
            end
        })
    end

    -- Load saved race (only if has race chip)
    if hasRaceChip then
        table.insert(options, {
            title = Config.Locale.loadRace,
            description = Config.Locale.loadRaceDesc,
            icon = 'folder-open',
            onSelect = function()
                openSavedRacesMenu()
            end
        })
    end

    -- Start race (only if has race chip)
    if (#recordedCheckpoints > 0 or IsWaypointActive()) and hasRaceChip then
        table.insert(options, {
            title = Config.Locale.startRace,
            description = Config.Locale.startRaceDesc,
            icon = 'flag',
            iconColor = 'yellow',
            onSelect = function()
                local input = lib.inputDialog(Config.Locale.startRace, {
                    {
                        type = 'number',
                        label = Config.Locale.enterBuyIn,
                        description = Config.Locale.enterBuyInDesc:format(Config.MinBuyIn, Config.MaxBuyIn),
                        icon = 'dollar-sign',
                        required = true,
                        min = Config.MinBuyIn,
                        max = Config.MaxBuyIn,
                        default = 1000
                    },
                    {
                        type = 'number',
                        label = Config.Locale.enterStartDelay,
                        description = Config.Locale.enterStartDelayDesc,
                        icon = 'clock',
                        required = true,
                        min = 10,
                        max = 120,
                        default = 30
                    }
                })

                if input then
                    local amount = tonumber(input[1])
                    local startDelay = tonumber(input[2]) * 1000
                    local startCoords = GetEntityCoords(PlayerPedId())

                    pendingCreate = true
                    if #recordedCheckpoints > 0 then
                        TriggerServerEvent('StreetRaces:createRace_sv', amount, startDelay, startCoords, recordedCheckpoints)
                    elseif IsWaypointActive() then
                        local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
                        local retval, nodeCoords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
                        local checkpoints = {{blip = nil, coords = nodeCoords}}
                        TriggerServerEvent('StreetRaces:createRace_sv', amount, startDelay, startCoords, checkpoints)
                    else
                        pendingCreate = false
                    end

                    raceStatus.state = RACE_STATE_NONE
                    cleanupRecording()
                end
            end
        })
    end

    -- Leave race
    if raceStatus.state == RACE_STATE_JOINED or raceStatus.state == RACE_STATE_RACING then
        table.insert(options, {
            title = Config.Locale.leaveRace,
            description = Config.Locale.leaveRaceDesc,
            icon = 'right-from-bracket',
            iconColor = 'red',
            onSelect = function()
                cleanupRace()
                TriggerServerEvent('StreetRaces:leaveRace_sv', raceStatus.index)
                raceStatus.index = 0
                raceStatus.checkpoint = 0
                raceStatus.state = RACE_STATE_NONE
                notify(Config.Locale.leftRace, 'info')
            end
        })
    end

    if ownedRaceIndex > 0 then
        table.insert(options, {
            title = Config.Locale.cancelRace,
            description = Config.Locale.cancelRaceDesc,
            icon = 'ban',
            iconColor = 'red',
            onSelect = function()
                TriggerServerEvent('StreetRaces:cancelRace_sv')
            end
        })
    end

    -- Show message if player doesn't have race chip
    if not hasRaceChip then
        table.insert(options, 1, {
            title = '⚠️ Race Chip Potreban',
            description = 'Trebaš Race Chip da bi mogao kreirati, spremati i pokrenuti utrke',
            icon = 'microchip',
            iconColor = 'orange',
            disabled = true
        })
    end

    lib.registerContext({
        id = 'streetrace_main_menu',
        title = Config.Locale.menuTitle,
        options = options
    })

    lib.showContext('streetrace_main_menu')
end

RegisterNetEvent('StreetRaces:openMenu_cl', function()
    openMainMenu()
end)

exports('useRaceChip', function()
    openMainMenu()
end)

RegisterCommand(Config.Commands.openMenu, function()
    openMainMenu()
end, false)

RegisterNetEvent("StreetRaces:createRace_cl", function(index, amount, startDelay, startCoords, checkpoints)
    local race = {
        amount = amount,
        started = false,
        startTime = GetGameTimer() + startDelay,
        startCoords = startCoords,
        checkpoints = checkpoints,
        startMarker = nil,
        startBlip = nil
    }

    -- Create start location marker (big green checkpoint)
    if Config.StartMarkerEnabled then
        race.startMarker = CreateCheckpoint(
            47, -- Checkpoint type (47 = cylinder outline)
            startCoords.x, startCoords.y, startCoords.z,
            0, 0, 0,
            Config.StartMarkerRadius,
            0, 255, 0, 150, -- Green color with transparency
            0
        )
        SetCheckpointCylinderHeight(race.startMarker, Config.StartMarkerHeight, Config.StartMarkerHeight, Config.StartMarkerRadius)
    end

    -- Create start location blip on map
    if Config.StartMarkerBlipEnabled then
        race.startBlip = AddBlipForCoord(startCoords.x, startCoords.y, startCoords.z)
        SetBlipSprite(race.startBlip, Config.StartMarkerBlipSprite)
        SetBlipColour(race.startBlip, Config.StartMarkerBlipColor)
        SetBlipScale(race.startBlip, 1.2)
        SetBlipAsShortRange(race.startBlip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Locale.raceStartBlip:format(amount))
        EndTextCommandSetBlipName(race.startBlip)
    end

    races[index] = race
    if pendingCreate then
        ownedRaceIndex = index
        pendingCreate = false
        notify(Config.Locale.raceCreated, 'success')
    end
end)

RegisterNetEvent('StreetRaces:createFailed_cl', function()
    pendingCreate = false
end)

RegisterNetEvent("StreetRaces:loadRace_cl", function(checkpoints)
    cleanupRecording()
    recordedCheckpoints = checkpoints
    raceStatus.state = RACE_STATE_RECORDING

    for index, checkpoint in pairs(recordedCheckpoints) do
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipColour(checkpoint.blip, Config.CheckpointBlipColor)
        SetBlipAsShortRange(checkpoint.blip, true)
        ShowNumberOnBlip(checkpoint.blip, index)
    end

    SetWaypointOff()
    if checkpoints[1] then
        SetBlipRoute(checkpoints[1].blip, true)
        SetBlipRouteColour(checkpoints[1].blip, Config.CheckpointBlipColor)
    end

    CreateThread(function()
        Wait(100)
        openMainMenu()
    end)
end)

RegisterNetEvent("StreetRaces:joinedRace_cl", function(index)
    raceStatus.index = index
    raceStatus.state = RACE_STATE_JOINED

    local race = races[index]

    -- Remove start marker and blip when player joins
    if race.startMarker then
        DeleteCheckpoint(race.startMarker)
        race.startMarker = nil
    end
    if race.startBlip then
        RemoveBlip(race.startBlip)
        race.startBlip = nil
    end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        FreezeEntityPosition(vehicle, true)
    end

    notify(Config.Locale.raceJoined, 'success')
end)

RegisterNetEvent("StreetRaces:removeRace_cl", function(index)
    -- Clean up start marker and blip before removing race
    local race = races[index]
    if race then
        if race.startMarker then
            DeleteCheckpoint(race.startMarker)
        end
        if race.startBlip then
            RemoveBlip(race.startBlip)
        end
    end

    if index == raceStatus.index then
        cleanupRace()
        raceStatus.index = 0
        raceStatus.checkpoint = 0
        raceStatus.state = RACE_STATE_NONE
    elseif index < raceStatus.index then
        raceStatus.index = raceStatus.index - 1
    end

    if index == ownedRaceIndex then
        ownedRaceIndex = 0
    elseif index < ownedRaceIndex then
        ownedRaceIndex = ownedRaceIndex - 1
    end

    table.remove(races, index)
end)

RegisterNetEvent("StreetRaces:showSavedRaces_cl", function(savedRaces)
    showSavedRacesMenu(savedRaces)
end)

RegisterNetEvent("StreetRaces:notify_cl", function(message, type)
    notify(message, type)
end)

local function distToStart(position, startCoords)
    return GetDistanceBetweenCoords(position.x, position.y, position.z, startCoords.x, startCoords.y, startCoords.z, true)
end

local function isNearJoinableRace(position)
    local now = GetGameTimer()
    local range = Config.JoinProximity * 1.5
    for _, race in pairs(races) do
        if now < race.startTime and distToStart(position, race.startCoords) < range then
            return true
        end
    end
    return false
end

local function tickJoinRaces(position)
    local now = GetGameTimer()
    for index, race in pairs(races) do
        if now < race.startTime then
            local proximity = distToStart(position, race.startCoords)
            if proximity < Config.JoinProximity then
                local count = math.ceil((race.startTime - now) / 1000.0)
                showTextUI(Config.Locale.pressToJoin:format(race.amount, count))
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('StreetRaces:joinRace_sv', index)
                end
                return
            end
        end
    end
    hideTextUI()
end

local function tickJoinedRace(player)
    local race = races[raceStatus.index]
    if not race then
        raceStatus.index = 0
        raceStatus.state = RACE_STATE_NONE
        hideTextUI()
        return
    end

    local vehicle = GetVehiclePedIsIn(player, false)
    local inVehicle = vehicle ~= 0
    local count = race.startTime - GetGameTimer()

    if inVehicle then
        FreezeEntityPosition(vehicle, true)
        DisableControlAction(0, 71, true)
        DisableControlAction(0, 72, true)
        DisableControlAction(0, 63, true)
        DisableControlAction(0, 64, true)
        DisableControlAction(0, 75, true)
    else
        FreezeEntityPosition(player, true)
    end

    if count <= 0 and inVehicle then
        if race.startMarker then
            DeleteCheckpoint(race.startMarker)
            race.startMarker = nil
        end
        if race.startBlip then
            RemoveBlip(race.startBlip)
            race.startBlip = nil
        end

        setupRaceCheckpoints(race)
        raceStatus.state = RACE_STATE_RACING
        raceStatus.checkpoint = 0
        FreezeEntityPosition(vehicle, false)
        hideTextUI()
    else
        local seconds = math.ceil(count / 1000.0)
        if count <= Config.FreezeDuration then
            Draw2DText(0.5, 0.4, ("~y~%d"):format(seconds), 3.0)
        end
        showTextUI(Config.Locale.joined:format(seconds))
    end
end

local function createCheckpointEntity(checkpoint, cpIndex, total)
    if Config.CheckpointRadius <= 0 then return end
    local checkpointType = cpIndex < total and RACE_CHECKPOINT_TYPE or RACE_CHECKPOINT_FINISH_TYPE
    checkpoint.checkpoint = CreateCheckpoint(
        checkpointType,
        checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z,
        0, 0, 0,
        Config.CheckpointRadius,
        255, 255, 0, 127, 0
    )
    SetCheckpointCylinderHeight(checkpoint.checkpoint, Config.CheckpointHeight, Config.CheckpointHeight, Config.CheckpointRadius)
end

local function tickRacing(player, position)
    local race = races[raceStatus.index]
    if not race then return end

    if raceStatus.checkpoint == 0 then
        raceStatus.checkpoint = 1
        local checkpoint = race.checkpoints[raceStatus.checkpoint]
        createCheckpointEntity(checkpoint, raceStatus.checkpoint, #race.checkpoints)
        SetBlipRoute(checkpoint.blip, true)
        SetBlipRouteColour(checkpoint.blip, Config.CheckpointBlipColor)
    else
        local checkpoint = race.checkpoints[raceStatus.checkpoint]
        if GetDistanceBetweenCoords(position.x, position.y, position.z, checkpoint.coords.x, checkpoint.coords.y, 0, false) < Config.CheckpointProximity then
            RemoveBlip(checkpoint.blip)
            if checkpoint.checkpoint then
                DeleteCheckpoint(checkpoint.checkpoint)
            end

            if raceStatus.checkpoint == #race.checkpoints then
                PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
                TriggerServerEvent('StreetRaces:finishedRace_sv', raceStatus.index, GetGameTimer() - race.startTime)
                raceStatus.index = 0
                raceStatus.state = RACE_STATE_NONE
                hideTextUI()
            else
                PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
                raceStatus.checkpoint = raceStatus.checkpoint + 1
                local nextCheckpoint = race.checkpoints[raceStatus.checkpoint]
                createCheckpointEntity(nextCheckpoint, raceStatus.checkpoint, #race.checkpoints)
                SetBlipRoute(nextCheckpoint.blip, true)
                SetBlipRouteColour(nextCheckpoint.blip, Config.CheckpointBlipColor)
            end
        end
    end

    if Config.HudEnabled and raceStatus.state == RACE_STATE_RACING then
        local timeSeconds = (GetGameTimer() - race.startTime) / 1000.0
        local timeMinutes = math.floor(timeSeconds / 60.0)
        timeSeconds = timeSeconds - 60.0 * timeMinutes
        Draw2DText(Config.HudPosition.x, Config.HudPosition.y, ("~y~%02d:%06.3f"):format(timeMinutes, timeSeconds), 0.7)

        local checkpoint = race.checkpoints[raceStatus.checkpoint]
        if checkpoint then
            local checkpointDist = math.floor(GetDistanceBetweenCoords(position.x, position.y, position.z, checkpoint.coords.x, checkpoint.coords.y, 0, false))
            Draw2DText(Config.HudPosition.x, Config.HudPosition.y + 0.04, ("~y~%s"):format(Config.Locale.checkpoint:format(raceStatus.checkpoint, #race.checkpoints, checkpointDist)), 0.5)
        end
    end
end

CreateThread(function()
    while true do
        local waitMs = 500
        local state = raceStatus.state
        local player = PlayerPedId()

        if state == RACE_STATE_JOINED then
            waitMs = 0
            tickJoinedRace(player)
        elseif state == RACE_STATE_RACING then
            waitMs = 0
            if IsPedInAnyVehicle(player, false) then
                tickRacing(player, GetEntityCoords(player))
            else
                hideTextUI()
            end
        elseif #races > 0 and IsPedInAnyVehicle(player, false) then
            local position = GetEntityCoords(player)
            if isNearJoinableRace(position) then
                waitMs = 0
                tickJoinRaces(position)
            else
                hideTextUI()
            end
        else
            hideTextUI()
        end

        Wait(waitMs)
    end
end)

CreateThread(function()
    while true do
        if raceStatus.state ~= RACE_STATE_RECORDING then
            Wait(500)
        else
            Wait(100)
            showTextUI(Config.Locale.recording:format(#recordedCheckpoints))

            if IsWaypointActive() then
                local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
                local _, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
                SetWaypointOff()

                local removed = false
                for index, checkpoint in pairs(recordedCheckpoints) do
                    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z, false) < 1.0 then
                        RemoveBlip(checkpoint.blip)
                        table.remove(recordedCheckpoints, index)
                        removed = true

                        for i = index, #recordedCheckpoints do
                            ShowNumberOnBlip(recordedCheckpoints[i].blip, i)
                        end
                        notify(Config.Locale.checkpointRemoved, 'warning')
                        break
                    end
                end

                if not removed then
                    if #recordedCheckpoints >= Config.MaxCheckpoints then
                        notify(Config.Locale.tooManyCheckpoints:format(Config.MaxCheckpoints), 'error')
                    else
                        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                        SetBlipColour(blip, Config.CheckpointBlipColor)
                        SetBlipAsShortRange(blip, true)
                        ShowNumberOnBlip(blip, #recordedCheckpoints + 1)
                        table.insert(recordedCheckpoints, { blip = blip, coords = coords })
                        notify(Config.Locale.checkpointAdded:format(#recordedCheckpoints), 'success')
                    end
                end
            end
        end
    end
end)
