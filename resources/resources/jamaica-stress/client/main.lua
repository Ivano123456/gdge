local UNARMED = `WEAPON_UNARMED`

local stressPercent = 0
local effectTier = 0
local statusRegistered = false
local lastShootAt = 0
local lastDamageAt = 0
local lastFastDriveAt = 0
local lastMeleeAt = 0
local lastStressGainAt = 0
local reliefUntil = 0
local wasDead = false

local function resetTimers()
    lastShootAt = 0
    lastDamageAt = 0
    lastFastDriveAt = 0
    lastMeleeAt = 0
    lastStressGainAt = 0
    reliefUntil = 0
end

local function touchStressGain()
    lastStressGainAt = GetGameTimer()
end

local function addStress(amount)
    if amount <= 0 then return end
    touchStressGain()
    TriggerEvent('esx_status:add', 'stress', amount)
end

local function removeStress(amount)
    if amount <= 0 then return end
    TriggerEvent('esx_status:remove', 'stress', amount)
end

local function clearEffects()
    if effectTier == 0 then return end
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    ClearTimecycleModifier()
    SetPedMotionBlur(cache.ped, false)
    effectTier = 0
end

local function applyEffectTier(tier, intensity)
    if tier == 3 then
        SetTimecycleModifier('spectator5')
        SetTimecycleModifierStrength(0.35 + (intensity * 0.45))
        SetPedMotionBlur(cache.ped, true)
        ShakeGameplayCam('DRUNK_SHAKE', 0.5 + (intensity * 0.9))
    elseif tier == 2 then
        SetTimecycleModifier('spectator5')
        SetTimecycleModifierStrength(0.15 + (intensity * 0.25))
        SetPedMotionBlur(cache.ped, false)
        ShakeGameplayCam('DRUNK_SHAKE', 0.25 + (intensity * 0.35))
    else
        ClearTimecycleModifier()
        SetPedMotionBlur(cache.ped, false)
        ShakeGameplayCam('DRUNK_SHAKE', 0.08 + (intensity * 0.2))
    end
    effectTier = tier
end

local function syncVisualEffects()
    if stressPercent < Config.Effects.ShakeMin then
        clearEffects()
        return
    end

    local intensity = stressPercent * 0.01
    local tier = stressPercent >= Config.Effects.HeavyMin and 3
        or stressPercent >= Config.Effects.BlurMin and 2
        or 1

    if tier ~= effectTier then
        applyEffectTier(tier, intensity)
    end
end

local function clearAllStress()
    stressPercent = 0
    resetTimers()
    TriggerEvent('esx_status:set', 'stress', 0)
    clearEffects()
    SetPedCanRagdoll(cache.ped, true)
end

local function isReliefProtected()
    return GetGameTimer() < reliefUntil or lib.progressActive()
end

local function endRagdoll(ped)
    if not IsPedRagdoll(ped) then return end
    ClearPedTasksImmediately(ped)
    ResetPedRagdollTimer(ped)
end

local function beginStressRelief(durationMs)
    local ped = cache.ped
    local untilAt = GetGameTimer() + durationMs + 750
    if untilAt > reliefUntil then
        reliefUntil = untilAt
    end
    endRagdoll(ped)
    SetPedCanRagdoll(ped, false)
end

local function registerStressStatus()
    if statusRegistered then return end
    statusRegistered = true
    TriggerEvent('esx_status:registerStatus', 'stress', 0, '#e74c3c', function(status)
        return status.val > 0
    end, function() end)
end

exports('GetStress', function()
    return stressPercent
end)

exports('AddStress', addStress)
exports('RemoveStress', removeStress)
exports('ClearAllStress', clearAllStress)
exports('BeginStressRelief', beginStressRelief)

RegisterNetEvent('jamaica-stress:modify', function(amount)
    if type(amount) ~= 'number' or amount == 0 then return end
    if amount > 0 then
        addStress(amount)
    else
        removeStress(-amount)
    end
end)

RegisterNetEvent('jamaica-stress:clear', clearAllStress)

RegisterNetEvent('jamaica_bolnica>client>Revive', clearAllStress)
RegisterNetEvent('esx_ambulancejob:revive', clearAllStress)

AddEventHandler('esx_status:loaded', registerStressStatus)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    SetTimeout(2500, registerStressStatus)
end)

AddEventHandler('esx_status:onTick', function(statuses)
    for i = 1, #statuses do
        local s = statuses[i]
        if s.name == 'stress' then
            if s.percent ~= stressPercent then
                stressPercent = s.percent
                syncVisualEffects()
            end
            return
        end
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end
    if args[1] ~= cache.ped then return end
    local now = GetGameTimer()
    if now - lastDamageAt < Config.Gain.DamageCooldown then return end
    lastDamageAt = now
    addStress(Config.Gain.Damaged)
end)

AddStateBagChangeHandler('Mrtav', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value == true then
        wasDead = true
    elseif wasDead then
        wasDead = false
        clearAllStress()
    end
end)

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(500) end
    touchStressGain()

    while ESX.PlayerLoaded do
        local sleep = 800
        local ped = cache.ped

        if IsPedShooting(ped) then
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= UNARMED then
                local now = GetGameTimer()
                if now - lastShootAt >= Config.Gain.ShootCooldown then
                    lastShootAt = now
                    addStress(Config.Gain.Shooting)
                end
                sleep = 200
            end
        elseif IsPedInMeleeCombat(ped) then
            local now = GetGameTimer()
            if now - lastMeleeAt >= Config.Gain.MeleeCooldown then
                lastMeleeAt = now
                addStress(Config.Gain.Melee)
            end
            sleep = 600
        elseif IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, -1) == ped then
                local speed = GetEntitySpeed(veh) * 3.6
                if speed >= Config.Gain.FastDriveSpeed then
                    local now = GetGameTimer()
                    if now - lastFastDriveAt >= Config.Gain.FastDriveInterval then
                        lastFastDriveAt = now
                        addStress(Config.Gain.FastDrive)
                    end
                    sleep = 800
                else
                    sleep = 1500
                end
            else
                sleep = 2000
            end
        end

        if isReliefProtected() then
            SetPedCanRagdoll(ped, false)
            if lib.progressActive() then
                reliefUntil = GetGameTimer() + 1500
                endRagdoll(ped)
            end
        elseif GetGameTimer() >= reliefUntil then
            SetPedCanRagdoll(ped, true)
        end

        if stressPercent > 0 then
            local now = GetGameTimer()
            local idleFor = now - lastStressGainAt
            if idleFor >= Config.Decay.IdleBefore then
                removeStress(Config.Decay.Amount)
                sleep = Config.Decay.Interval
            elseif idleFor > Config.Decay.IdleBefore - 10000 then
                local remain = Config.Decay.IdleBefore - idleFor
                if remain > sleep then
                    sleep = math.min(remain, 5000)
                end
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if stressPercent >= Config.Effects.CriticalMin
            and not isReliefProtected()
            and not IsPedInAnyVehicle(cache.ped, false)
            and not IsPedRagdoll(cache.ped)
            and math.random(100) <= Config.Effects.RagdollChance
        then
            SetPedToRagdoll(cache.ped, 1200, 1200, 0, false, false, false)
            Wait(4000)
        else
            Wait(3000)
        end
    end
end)

AddEventHandler('esx:onPlayerLogout', function()
    wasDead = false
    stressPercent = 0
    resetTimers()
    clearEffects()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    statusRegistered = false
    stressPercent = 0
    resetTimers()
    clearEffects()
    SetPedCanRagdoll(cache.ped, true)
    TriggerEvent('esx_status:unregisterStatus', 'stress')
end)
