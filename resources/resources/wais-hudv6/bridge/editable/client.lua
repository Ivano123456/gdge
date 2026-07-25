-----------------------------------------------------------------------------------------
-- EVENT'S --
-----------------------------------------------------------------------------------------

--- @important When player loaded, this event will be triggered.
RegisterNetEvent('wais:hudv6:client:custom:playerLoaded', function()
    wFramework.CustomPlayerLoaded()
end)

--- @important When player unloaded, this event will be triggered.
RegisterNetEvent('wais:hudv6:client:custom:playerUnloaded', function()
    wFramework.playerUnloaded()
end)

--- @param job table { label = string, grade = { name = string }, onDuty = boolean }
RegisterNetEvent('wais:hudv6:client:custom:setPlayerJob', function(job)
    wFramework.SetPlayerJob(job)
end)

--- @param gang table { label = string, grade = { name = string } }
RegisterNetEvent('wais:hudv6:client:custom:setPlayerGang', function(gang)
    wFramework.SetPlayerGang(gang)
end)

--- @param money number
RegisterNetEvent('wais:hudv6:client:custom:setPlayerMoney', function(money)
    wFramework.SetPlayerMoney(money)
end)

--- @param bank number
RegisterNetEvent('wais:hudv6:client:custom:setPlayerBank', function(bank)
    wFramework.SetPlayerBank(bank)
end)

--- @param status table { hunger = number, thirst = number, stress = number }
RegisterNetEvent('wais:hudv6:client:custom:setPlayerStatus', function(status)
    wFramework.SetPlayerCustomStatus(status)
end)

if Config.StressSystem then
    local lastStress = -1

    local function pushStress(value)
        local stress = math.floor((value or 0) + 0.5)
        if stress == lastStress then return end
        lastStress = stress
        wFramework.SetPlayerCustomStatus({ stress = stress })
    end

    AddEventHandler('esx_status:onTick', function(statuses)
        for i = 1, #statuses do
            if statuses[i].name == 'stress' then
                pushStress(statuses[i].percent)
                return
            end
        end
    end)

    AddEventHandler('esx_status:loaded', function()
        TriggerEvent('esx_status:getStatus', 'stress', function(status)
            if status then
                pushStress(status.getPercent())
            end
        end)
    end)

    AddEventHandler('wais:hudv6:client:custom:playerLoaded', function()
        if GetResourceState('jamaica-stress'):find('start') then
            pushStress(exports['jamaica-stress']:GetStress())
        end
    end)

    AddEventHandler('wais:hudv6:client:custom:playerUnloaded', function()
        lastStress = -1
    end)
end

--- This code block is doing this action: If the qs-crime-creator resource exist, its listening the statebag for gang stuff.
if GetResourceState("qs-crime-creator"):find("start") then
    AddStateBagChangeHandler("organization", nil, function(bagName, key, value) 
        if value ~= nil then
            TriggerEvent('wais:get:crime', value, function(label)
                wFramework.SetPlayerGang({label = label,grade = {name = Lang('unknown')}})
            end)

            return
        end

        return wFramework.SetPlayerGang({label = Lang('unknown'), grade = {name = Lang('unknown')}})
    end)
end

-----------------------------------------------------------------------------------------
-- NUI CALLBACK'S --
-----------------------------------------------------------------------------------------

RegisterNUICallback('toggleEngine', function(_, cb)
    if Player.vehicle.vehicle <= 0 or not DoesEntityExist(Player.vehicle.vehicle) then
        return cb('ok')
    end

    local currState = IsVehicleEngineOn(Player.vehicle.vehicle)
    SetVehicleEngineOn(Player.vehicle.vehicle, not currState, false, true)
    cb('ok')
end)

-----------------------------------------------------------------------------------------
-- FUNCTION'S --
-----------------------------------------------------------------------------------------

local function markPostal(postalId)
    for _, v in pairs(Postals) do
        if v.code == postalId then
            SetNewWaypoint(v.x, v.y)
            return Config.Notification(Lang("postal"), Lang("postal_marked"), "success")
        end
    end

    return Config.Notification(Lang("postal"), Lang("postal_not_found"), "error")
end

-----------------------------------------------------------------------------------------
-- COMMAND'S --
-----------------------------------------------------------------------------------------

if not Config.Commands.postal.disabled then
    RegisterCommand(Config.Commands.postal.command, function(_, args)
        local postalId = args[1] and args[1] or nil
        markPostal(postalId)
    end, false)

    TriggerEvent('chat:addSuggestion', ('/%s'):format(Config.Commands.postal.command), Config.Commands.postal.help.command, {
        { name = 'postalid', help = Config.Commands.postal.help.postalid },
    })
end

if not Config.Commands.seat.disabled then
    RegisterCommand(Config.Commands.seat.command, function(_, args)
        if Player.vehicle.vehicle < 0 then 
            return Config.Notification(Lang("seat"), Lang('you_not_in_vehicle'), "error") 
        end

        local seatId = args[1] and tonumber(args[1]) or nil
        if not seatId then 
            return Config.Notification(Lang("seat"), Lang("seat_seatid_not_found"), "error") 
        end

        seatId = seatId - 2
        local max = GetVehicleModelNumberOfSeats(GetEntityModel(Player.vehicle.vehicle)) - 2
        if seatId > max then 
            return Config.Notification(Lang("seat"), Lang("seat_max_exceeded"), "error") 
        end

        if not IsVehicleSeatFree(Player.vehicle.vehicle, seatId) then
            return Config.Notification(Lang("seat"), Lang("seat_busy"), "error") 
        end

        local ped = cache.ped
        SetPedIntoVehicle(ped, Player.vehicle.vehicle, seatId)
        Config.Notification(Lang("seat"), Lang('seat_changed_to', seatId), "success")
    end, false)

    TriggerEvent('chat:addSuggestion', ('/%s'):format(Config.Commands.seat.command), Config.Commands.seat.help.command, {
        { name = 'seatid', help = Config.Commands.seat.help.seatid },
    })
end

-----------------------------------------------------------------------------------------
-- THREAD'S --
-----------------------------------------------------------------------------------------

local hudPlayerIdPushToken = 0

local function getJamaicaUid()
    if GetResourceState('jamaica-uid'):find('start') then
        return exports['jamaica-uid']:GetUniqueId()
    end
end

local function buildHudPlayerIdLabel()
    local serverId = cache.serverId or GetPlayerServerId(PlayerId())
    local uid = getJamaicaUid()

    if uid then
        return ('%s | #%s'):format(serverId, uid)
    end

    return tostring(serverId)
end

local function pushHudPlayerId()
    local uid = getJamaicaUid()

    if uid then
        SendNUIMessage({
            type = 'SET_JM_HUD_UID',
            uid = uid,
        })
    end

    SendNUIMessage({
        type = 'SET_PLAYER_ID',
        id = buildHudPlayerIdLabel(),
    })
end

local function scheduleHudPlayerIdPush()
    hudPlayerIdPushToken = hudPlayerIdPushToken + 1
    local token = hudPlayerIdPushToken

    CreateThread(function()
        local delays = { 0, 500, 1500, 3000, 6000, 10000 }

        for i = 1, #delays do
            if token ~= hudPlayerIdPushToken then return end
            Wait(delays[i])
            if token ~= hudPlayerIdPushToken then return end
            pushHudPlayerId()
        end
    end)
end

AddEventHandler('wais:hudv6:client:custom:playerLoaded', function()
    scheduleHudPlayerIdPush()
end)

AddEventHandler('wais:hudv6:client:custom:playerUnloaded', function()
    hudPlayerIdPushToken = hudPlayerIdPushToken + 1
end)

AddStateBagChangeHandler('ListaUUID', 'global', function(_, _, value)
    if type(value) ~= 'table' then return end

    local serverId = tostring(cache.serverId or GetPlayerServerId(PlayerId()))
    if value[serverId] == nil then return end

    pushHudPlayerId()
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end

    Wait(3000)
    pushHudPlayerId()
end)

-----------------------------------------------------------------------------------------
-- EXPORT'S --
-----------------------------------------------------------------------------------------