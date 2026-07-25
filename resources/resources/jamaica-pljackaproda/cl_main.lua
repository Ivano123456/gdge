local Config = require 'config'

local INTERACT_DIST = 2.5
local INTERACT_SQ = INTERACT_DIST * INTERACT_DIST
local START_DIST = 1.5
local START_SQ = START_DIST * START_DIST
local NEAR_STORE_DIST = 80.0
local NEAR_STORE_SQ = NEAR_STORE_DIST * NEAR_STORE_DIST
local MARKER_DRAW_DIST_SQ = 400.0

local robberyStates = {}
local safeEntities = {}
local alarmSounds = {}
local nearStores = {}
local globalCooldownUntil = 0
local startCooldown = 0
local safeModel = joaat('sf_prop_v_43_safe_s_bk_01a')

local function notify(msg)
    Config.Notify(msg)
end

local function DrawText3D(x, y, z, text)
    local onScreen, sx, sy = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0, 0.35 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(sx, sy)
end

local function pressedE()
    return IsControlJustReleased(0, 38)
end

local function distSq(ax, ay, az, bx, by, bz)
    local dx, dy, dz = ax - bx, ay - by, az - bz
    return dx * dx + dy * dy + dz * dz
end

local function deleteSafe(key)
    local entity = safeEntities[key]
    if entity and DoesEntityExist(entity) then
        DeleteObject(entity)
    end
    safeEntities[key] = nil
end

local function stopAlarm(key)
    local sound = alarmSounds[key]
    if not sound then return end
    StopSound(sound)
    ReleaseSoundId(sound)
    alarmSounds[key] = nil
end

local function cleanupRobbery(key)
    deleteSafe(key)
    stopAlarm(key)
    robberyStates[key] = nil
end

local function spawnSafe(key)
    if safeEntities[key] and DoesEntityExist(safeEntities[key]) then return end

    local store = Config.Prodavnice[key]
    if not store then return end

    lib.requestModel(safeModel, 5000)
    if not HasModelLoaded(safeModel) then return end

    local c = store.safe_coords
    local entity = CreateObject(safeModel, c.x, c.y, c.z - 1.0, false, true, false)
    if not DoesEntityExist(entity) then return end

    SetEntityHeading(entity, c.w)
    FreezeEntityPosition(entity, true)
    SetEntityInvincible(entity, true)
    SetModelAsNoLongerNeeded(safeModel)
    safeEntities[key] = entity
end

local function playAlarm(key)
    if alarmSounds[key] then return end

    local marker = Config.Prodavnice[key].startMarker
    local sound = GetSoundId()
    PlaySoundFromCoord(sound, 'VEHICLES_HORNS_AMBULANCE_WARNING', marker.x, marker.y, marker.z, '', false, 0, false)
    alarmSounds[key] = sound

    SetTimeout(Config.TrajanjeAlarma * 1000, function()
        stopAlarm(key)
    end)
end

local function applyRobberyState(key, state)
    if not state then
        cleanupRobbery(key)
        return
    end

    robberyStates[key] = state
    spawnSafe(key)
    playAlarm(key)
end

local function safeCombo()
    local n = math.min(math.max(Config.SefPdSafeBrojeva or 3, 1), 4)
    local combo = {}
    for i = 1, n do
        combo[i] = math.random(0, 99)
    end
    return combo
end

local function robRegister(key, index)
    local ok, msg = lib.callback.await('jamaica-pljackaproda:server:tryRobRegister', false, key, index)
    if not ok then
        if msg then notify(msg) end
        return
    end

    if lib.progressBar({
        duration = 10000,
        label = 'Pljackas kasu...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true, mouse = false },
        anim = { dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab' },
    }) then
        TriggerServerEvent('jamaica-pljackaproda:server:opljackajKasu', key, index)
    else
        notify('Prekinuo si pljacku kase!')
        TriggerServerEvent('jamaica-pljackaproda:server:releaseRegisterBusy', key)
    end
end

local function crackSafe(key)
    if GetResourceState('pd-safe') ~= 'started' then
        notify('Minigame sefa (pd-safe) nije ucitan.')
        return
    end

    local ok, msg = lib.callback.await('jamaica-pljackaproda:server:tryCrackSafe', false, key)
    if not ok then
        if msg then notify(msg) end
        return
    end

    local ped = cache.ped
    local attempts = 0
    local maxAttempts = 2
    local success = false

    while attempts < maxAttempts and not success do
        attempts = attempts + 1
        if exports['pd-safe']:createSafe(safeCombo()) then
            success = true
            if robberyStates[key] then
                robberyStates[key].safeLooted = true
            end
            TriggerServerEvent('jamaica-pljackaproda:server:obijSef', key)
            notify('Uspesno ste obili sef!')
        elseif attempts < maxAttempts then
            notify('Niste uspeli. Preostalo pokusaja: ' .. (maxAttempts - attempts))
            Wait(1000)
        end
        ClearPedTasks(ped)
    end

    if not success then
        TriggerServerEvent('jamaica-pljackaproda:server:removeLockpick')
        notify('Lockpick je pukao, sef ostaje zakljucan.')
    end

    TriggerServerEvent('jamaica-pljackaproda:server:releaseSafeBusy', key)
end

local function tryFetchRobbery(key)
    local info = lib.callback.await('jamaica-pljackaproda:server:getAreaInfo', false, key)
    if not info then return end

    globalCooldownUntil = info.cooldownUntil or 0
    if info.robbery then
        applyRobberyState(key, info.robbery)
    end
end

local function canShowStart(key)
    if robberyStates[key] then return false end
    if globalCooldownUntil > GetCloudTimeAsInt() then return false end
    return true
end

RegisterNetEvent('jamaica-pljackaproda:client:syncGlobalCooldown', function(untilTime)
    globalCooldownUntil = untilTime or 0
end)

RegisterNetEvent('jamaica-pljackaproda:client:syncRobbery', function(key, state, cooldown)
    applyRobberyState(key, state)
    if cooldown then
        globalCooldownUntil = cooldown
    end
end)

CreateThread(function()
    while true do
        local sleep = 500
        local ped = cache.ped
        local coords = GetEntityCoords(ped)
        local px, py, pz = coords.x, coords.y, coords.z

        for key, store in pairs(Config.Prodavnice) do
            local marker = store.startMarker
            local mx, my, mz = marker.x, marker.y, marker.z
            local storeDistSq = distSq(px, py, pz, mx, my, mz)

            if storeDistSq < NEAR_STORE_SQ then
                if not nearStores[key] then
                    nearStores[key] = true
                    tryFetchRobbery(key)
                end
            else
                nearStores[key] = nil
            end

            local state = robberyStates[key]

            if state then
                for i, reg in ipairs(store.registers) do
                    if not state.registers[i] then
                        local rx, ry, rz = reg.x, reg.y, reg.z
                        local regDistSq = distSq(px, py, pz, rx, ry, rz)

                        if regDistSq < MARKER_DRAW_DIST_SQ then
                            sleep = 0
                            DrawMarker(1, rx, ry, rz - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 0.8, 255, 255, 255, 180, false, true, 2, false, false, false, false)

                            if regDistSq < INTERACT_SQ then
                                DrawText3D(rx, ry, rz + 0.35, '[E] Opljackaj kasu')
                                if pressedE() then
                                    robRegister(key, i)
                                end
                            end
                        end
                    end
                end

                if not state.safeLooted then
                    local safe = store.safe_coords
                    local sx, sy, sz = safe.x, safe.y, safe.z
                    local safeDistSq = distSq(px, py, pz, sx, sy, sz)

                    if safeDistSq < MARKER_DRAW_DIST_SQ then
                        sleep = 0
                        DrawMarker(1, sx, sy, sz - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 0.8, 255, 255, 255, 180, false, true, 2, false, false, false, false)

                        if safeDistSq < INTERACT_SQ then
                            DrawText3D(sx, sy, sz + 0.35, '[E] Obij sef')
                            if pressedE() then
                                crackSafe(key)
                            end
                        end
                    end
                end
            elseif canShowStart(key) and storeDistSq < MARKER_DRAW_DIST_SQ then
                sleep = 0
                DrawMarker(1, mx, my, mz - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 180, false, true, 2, false, false, false, false)

                if storeDistSq < START_SQ then
                    DrawText3D(mx, my, mz + 1.0, 'Upucaj vatrenim oruzjem da zapocnes pljacku')

                    if IsPedArmed(ped, 4) and IsPedShooting(ped) then
                        local now = GetGameTimer()
                        if now >= startCooldown then
                            startCooldown = now + 2000

                            local job = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
                            if job and Config.BlackListJobovi[job] then
                                notify('Zaposlenje ti ne dozvoljava ovu akciju!')
                            else
                                local ulicaHash = GetStreetNameAtCoord(px, py, pz)
                                local ulica = GetStreetNameFromHashKey(ulicaHash)
                                TriggerServerEvent('jamaica-pljackaproda:server:startujPljackicu', key, ulica)
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for key in pairs(robberyStates) do
        cleanupRobbery(key)
    end
end)
