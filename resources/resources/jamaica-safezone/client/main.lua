local zoneCount = 0
local active = false
local protectionRunning = false

local function setSafeMode(enabled)
    local playerId = cache.playerId
    local ped = cache.ped

    SetLocalPlayerAsGhost(enabled)
    NetworkSetPlayerIsPassive(playerId, enabled)
    SetCanAttackFriendly(ped, not enabled, false)
    SetPlayerCanDoDriveBy(playerId, not enabled)
    SetEntityCanBeDamaged(ped, not enabled)

    if enabled then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    end
end

local function startProtectionLoop()
    if protectionRunning then
        return
    end

    protectionRunning = true

    CreateThread(function()
        local playerId = cache.playerId
        local controls = Config.CombatControls

        while active do
            DisablePlayerFiring(playerId, true)

            for i = 1, #controls do
                DisableControlAction(0, controls[i], true)
            end

            Wait(0)
        end

        protectionRunning = false
    end)
end

local function onEnterZone()
    zoneCount = zoneCount + 1

    if zoneCount ~= 1 then
        return
    end

    active = true
    setSafeMode(true)
    startProtectionLoop()

    if Config.Notify then
        lib.notify({
            description = Config.NotifyEnter,
            type = 'inform',
        })
    end
end

local function onExitZone()
    if zoneCount == 0 then
        return
    end

    zoneCount = zoneCount - 1

    if zoneCount ~= 0 then
        return
    end

    active = false
    setSafeMode(false)

    if Config.Notify then
        lib.notify({
            description = Config.NotifyExit,
            type = 'inform',
        })
    end
end

local function registerZone(zone)
    local handlers = {
        onEnter = onEnterZone,
        onExit = onExitZone,
        debug = Config.Debug,
    }

    if zone.type == 'sphere' then
        lib.zones.sphere({
            coords = zone.coords,
            radius = zone.radius,
            onEnter = handlers.onEnter,
            onExit = handlers.onExit,
            debug = handlers.debug,
        })
    elseif zone.type == 'box' then
        lib.zones.box({
            coords = zone.coords,
            size = zone.size,
            rotation = zone.rotation or 0,
            onEnter = handlers.onEnter,
            onExit = handlers.onExit,
            debug = handlers.debug,
        })
    elseif zone.type == 'poly' then
        lib.zones.poly({
            points = zone.points,
            thickness = zone.thickness or 20.0,
            onEnter = handlers.onEnter,
            onExit = handlers.onExit,
            debug = handlers.debug,
        })
    end
end

CreateThread(function()
    for i = 1, #Config.Zones do
        registerZone(Config.Zones[i])
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    if active then
        active = false
        zoneCount = 0
        setSafeMode(false)
    end
end)

exports('IsInSafeZone', function()
    return active
end)

exports('ShouldFreezeNeeds', function()
    return Config.FreezeNeeds and active
end)

--- Pozivati SAMO nakon sto je potvrdjeno da igrac ima taj job.
--- Vraca true ako je meni blokiran (i prikazuje notifikaciju).
exports('BlockJobMenu', function()
    if not active or not Config.BlockJobMenu then
        return false
    end

    if Config.Notify then
        lib.notify({
            description = Config.BlockJobMenuMessage,
            type = 'error',
        })
    end

    return true
end)
