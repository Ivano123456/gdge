ESX = exports['es_extended']:getSharedObject()
lib.locale()

local inService = false
local remaining = 0
local props = {}
local cleaning = false
local loopRunning = false

local function updateCounter()
    if not inService then
        lib.hideTextUI()
        return
    end

    lib.showTextUI(string.format(locale('remairing_actions'), remaining), {
        position = 'right-center',
        icon = 'broom',
        style = {
            backgroundColor = 'rgba(0, 0, 0, 0.7)',
            color = 'white',
        },
    })
end

local function deleteProp(entity)
    exports.ox_target:removeLocalEntity(entity, 'cs_clean')

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    for i = #props, 1, -1 do
        if props[i] == entity then
            table.remove(props, i)
            break
        end
    end
end

local function clearProps()
    for i = #props, 1, -1 do
        deleteProp(props[i])
    end
end

local function spawnTrash()
    if not inService or #props >= Config.MaxProps then return end

    local offset = vector3(math.random(-10, 10), math.random(-10, 10), 0.0)
    local coords = Config.ServiceLocation + offset
    local model = Config.Props[math.random(#Config.Props)]

    lib.requestModel(model)

    local entity = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
    PlaceObjectOnGroundProperly(entity)
    FreezeEntityPosition(entity, true)
    props[#props + 1] = entity

    exports.ox_target:addLocalEntity(entity, {
        {
            name = 'cs_clean',
            label = locale('clean_trash'),
            icon = 'fas fa-broom',
            canInteract = function()
                return inService and not cleaning
            end,
            onSelect = function()
                if cleaning or not inService then return end

                cleaning = true

                CreateThread(function()
                    local ok = lib.progressBar({
                        duration = Config.CleanDuration,
                        label = locale('cleaning_trash'),
                        useWhileDead = false,
                        canCancel = false,
                        disable = { move = true, car = true, combat = true },
                        anim = {
                            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                            clip = 'machinic_loop_mechandplayer',
                            flag = 49,
                        },
                    })

                    cleaning = false
                    if not ok or not inService then return end

                    local newRemaining = lib.callback.await('tj_communityservice:completeAction', false)
                    deleteProp(entity)

                    if not newRemaining or newRemaining <= 0 then return end

                    remaining = newRemaining
                    updateCounter()
                    spawnTrash()
                end)
            end,
        },
    })
end

local function refillTrash()
    while inService and #props < Config.MaxProps do
        spawnTrash()
    end
end

local function runServiceLoop()
    if loopRunning then return end
    loopRunning = true

    CreateThread(function()
        while inService do
            DisablePlayerFiring(cache.playerId, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            if #(GetEntityCoords(cache.ped) - Config.ServiceLocation) > Config.MaxDistance then
                SetEntityCoords(cache.ped, Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z, false, false, false, false)
            end

            Wait(500)
        end

        loopRunning = false
    end)
end

local function enterService(count)
    inService = true
    remaining = count
    cleaning = false

    SetEntityCoords(cache.ped, Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z, false, false, false, false)
    updateCounter()
    refillTrash()
    runServiceLoop()
end

local function exitService()
    inService = false
    remaining = 0
    cleaning = false
    clearProps()
    lib.hideTextUI()
    SetEntityCoords(cache.ped, Config.EndServiceLocation.x, Config.EndServiceLocation.y, Config.EndServiceLocation.z, false, false, false, false)
    ESX.ShowNotification(locale('finished'))
end

RegisterNetEvent('tj_communityservice:inService', function(count)
    enterService(count)
end)

RegisterNetEvent('tj_communityservice:updateActions', function(count)
    remaining = count
    updateCounter()
end)

RegisterNetEvent('tj_communityservice:finishService', function()
    exitService()
end)

RegisterNetEvent('tj_communityservice:heal', function()
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
end)

local function sendDialog(useUuid)
    local fields = useUuid and {
        { type = 'number', label = locale('player_uuid'), description = locale('player_uuid_desc'), required = true, min = 1 },
    } or {
        { type = 'number', label = locale('player_id'), description = locale('player_id_desc'), required = true },
    }

    fields[#fields + 1] = { type = 'number', label = locale('actions'), description = locale('actions_desc'), required = true, min = 1 }
    fields[#fields + 1] = { type = 'input', label = locale('reason'), description = locale('reason_desc'), required = true }

    local input = lib.inputDialog(useUuid and locale('send_offline_uuid') or locale('send_player'), fields)
    if not input then return end

    if useUuid then
        TriggerServerEvent('tj_communityservice:sendToServiceByUuid', input[1], input[2], input[3])
    else
        TriggerServerEvent('tj_communityservice:sendToService', input[1], input[2], input[3])
    end
end

local function openPlayerManage(player)
    local input = lib.inputDialog(locale('actions_for', player.name), {
        {
            type = 'select',
            label = locale('edit_actions'),
            options = {
                { label = locale('remove_service'), value = 'release' },
                { label = locale('add_actions'), value = 'add' },
                { label = locale('remove_actions'), value = 'remove' },
            },
            required = true,
        },
    })

    if not input then return end

    if input[1] == 'release' then
        TriggerServerEvent('tj_communityservice:removeFromService', player.id)
        return
    end

    local amount = lib.inputDialog(input[1] == 'add' and locale('add_actions') or locale('remove_actions'), {
        { type = 'number', label = locale('number_actions'), required = true, min = 1 },
    })

    if not amount then return end

    local delta = input[1] == 'add' and amount[1] or -amount[1]
    TriggerServerEvent('tj_communityservice:adjustActions', player.id, delta)
end

local function openActivePlayers()
    local players = lib.callback.await('tj_communityservice:getActivePlayers')
    if #players == 0 then
        return ESX.ShowNotification(locale('no_com_service'))
    end

    local options = {}

    for i = 1, #players do
        local player = players[i]
        options[#options + 1] = {
            title = player.name,
            description = string.format(locale('remaining_resaon'), player.remaining, player.total, player.reason),
            onSelect = function()
                openPlayerManage(player)
            end,
        }
    end

    lib.registerContext({
        id = 'cs_active_players',
        title = locale('active_players'),
        menu = 'cs_admin_menu',
        options = options,
    })

    lib.showContext('cs_active_players')
end

lib.registerContext({
    id = 'cs_admin_menu',
    title = locale('comm_service_menu'),
    options = {
        {
            title = locale('send_player'),
            description = locale('comm_service_count'),
            onSelect = function() sendDialog(false) end,
        },
        {
            title = locale('send_offline_uuid'),
            description = locale('send_offline_uuid_desc'),
            onSelect = function() sendDialog(true) end,
        },
        {
            title = locale('active_player_wiew'),
            description = locale('active_player_desc'),
            onSelect = openActivePlayers,
        },
    },
})

RegisterCommand(Config.Commands.communityservice, function()
    if not lib.callback.await('tj_communityservice:isAdmin', false) then
        return ESX.ShowNotification(locale('no_perm'))
    end

    lib.showContext('cs_admin_menu')
end)

local function openPoliceDialog()
    local nearby = lib.callback.await('tj_communityservice:getNearbyPlayers', false)
    if not nearby or #nearby == 0 then
        return ESX.ShowNotification(locale('no_nearby_players'))
    end

    local options = {}
    for i = 1, #nearby do
        local p = nearby[i]
        options[#options + 1] = { label = ('%s (ID: %s)'):format(p.name, p.id), value = p.id }
    end

    local input = lib.inputDialog(locale('send_player'), {
        { type = 'select', label = locale('player'), options = options, required = true },
        { type = 'number', label = locale('actions'), required = true, min = 1 },
        { type = 'input', label = locale('reason'), required = true },
    })

    if input then
        TriggerServerEvent('tj_communityservice:sendToService', input[1], input[2], input[3])
    end
end

exports.ox_target:addGlobalPlayer({
    {
        name = 'cs_send_player',
        label = locale('send_to_service'),
        icon = 'fas fa-broom',
        canInteract = function()
            return Config.JobRolesAccess[ESX.PlayerData.job.name] and not IsPedInAnyVehicle(cache.ped, false)
        end,
        onSelect = openPoliceDialog,
    },
})

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    clearProps()
    lib.hideTextUI()
end)
