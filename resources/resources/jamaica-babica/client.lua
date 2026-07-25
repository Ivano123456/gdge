if not lib then return end

lib.locale('hr')

local useTarget = Config.UseOxTarget
local scanRadius = Config.NearbyScanDistance
local reviveMs = Config.ReviveDurationMs
local pedSpawnDist = 40.0
local mediumDist = 80.0

local function countMedics()
    local total = 0
    for i = 1, #Config.MedicJobs do
        local job = Config.MedicJobs[i]
        total += GlobalState[('%s:count'):format(job)] or 0
    end
    return total
end

local function isDown(serverId)
    return Player(serverId).state.Mrtav == true
end

local function displayName(serverId)
    if not Config.ShowCharacterNames then return tostring(serverId) end
    return Player(serverId).state.name or tostring(serverId)
end

local function spawnPed(modelHash, coords, animation)
    local model = lib.requestModel(modelHash)
    if not model then return end

    local ped = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, false, true)
    if animation and animation.scenario then
        TaskStartScenarioInPlace(ped, animation.scenario, 0, true)
    elseif animation and animation.dict then
        lib.requestAnimDict(animation.dict)
        TaskPlayAnim(ped, animation.dict, animation.anim, 8.0, 0.0, -1, animation.flag or 1, 0, false, false, false)
    end

    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function addMapBlip(sprite, colour, label, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function confirmDialog(serverId, price)
    local label = displayName(serverId)
    return lib.alertDialog({
        header = locale('general_title'),
        content = locale('revive_confirmation_content', label, price),
        centered = true,
        cancel = true,
    }) == 'confirm'
end

local function tryReviveTarget(clientId, price)
    if not clientId then
        return lib.notify({ description = locale('no_player_nearby'), type = 'error', position = 'top' })
    end

    local serverId = GetPlayerServerId(clientId)
    if not isDown(serverId) then
        return lib.notify({ description = locale('player_not_dead'), type = 'error', position = 'top' })
    end

    if not confirmDialog(serverId, price) then return end

    local targetPed = GetPlayerPed(clientId)
    local stationPos = GetEntityCoords(cache.ped)

    if lib.progressBar({
        duration = reviveMs,
        label = locale('reviving_player'),
        useWhileDead = true,
        canCancel = true,
        disable = { car = true, move = true, combat = true },
    }) then
        if #(GetEntityCoords(targetPed) - stationPos) > Config.MaxReviveDistance then
            return lib.notify({ description = locale('player_too_far'), type = 'error', position = 'top' })
        end

        local ok, msg = lib.callback.await('jamaica_babica:attemptRevive', false, serverId)
        lib.notify({
            description = locale(msg),
            type = ok and 'success' or 'error',
            position = 'top',
        })
    else
        lib.notify({ description = locale('revive_cancelled'), type = 'error', position = 'top' })
    end
end

local function openNearbyMenu(price)
    local options = {}
    local found = 0
    local myCoords = GetEntityCoords(cache.ped)

    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId == cache.playerId then goto skip end

        local ped = GetPlayerPed(playerId)
        if ped == 0 or #(GetEntityCoords(ped) - myCoords) > scanRadius then goto skip end

        local serverId = GetPlayerServerId(playerId)
        if not isDown(serverId) then goto skip end

        found += 1
        local title = ('%s [%s]'):format(GetPlayerName(playerId) or '?', serverId)
        options[found] = {
            title = title,
            description = locale('revive_player_description', price),
            icon = 'fas fa-user',
            onSelect = function()
                tryReviveTarget(playerId, price)
            end,
        }

        ::skip::
    end

    if found == 0 then
        return lib.notify({ description = locale('no_player_nearby'), type = 'error', position = 'top' })
    end

    lib.registerContext({
        id = 'jamaica_babica_menu',
        title = locale('general_title'),
        options = options,
    })
    lib.showContext('jamaica_babica_menu')
end

local function openStation(payment)
    if countMedics() > Config.MaxMedicsOnline then
        return lib.notify({ description = locale('medics_online'), type = 'error', position = 'top' })
    end

    local price = (payment and payment.price) or 0
    if not Config.NearbyPlayerMenu then
        local closest = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaxReviveDistance, false)
        return tryReviveTarget(closest, price)
    end

    openNearbyMenu(price)
end

local function onEnterStation(st)
    if st.entity then return end

    local model = lib.requestModel(st.ped.model)
    if not model then return end

    local entity = spawnPed(model, st.coords, st.ped.animation)
    if not entity then return end

    if useTarget then
        exports.ox_target:addLocalEntity(entity, {
            label = st.label or locale('general_title'),
            icon = 'fas fa-truck-medical',
            distance = Config.StationInteractDistance,
            onSelect = function()
                openStation(st.payment)
            end,
        })
    end

    st.entity = entity
end

local function onExitStation(st)
    local entity = st.entity
    if not entity then return end

    if useTarget then
        exports.ox_target:removeLocalEntity(entity)
    end

    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, false, true)
        DeleteEntity(entity)
    end

    st.entity = nil
end

CreateThread(function()
    local list = lib.load('data.stations')
    local activeIdx

    for i = 1, #list do
        local st = list[i]
        st.pos = vec3(st.coords.x, st.coords.y, st.coords.z)

        if type(st.blip) == 'table' then
            addMapBlip(st.blip.id, st.blip.colour, st.label or locale('general_title'), st.pos)
        end
    end

    while true do
        local wait = 2000
        local coords = GetEntityCoords(cache.ped)
        local nearestIdx
        local nearestDist = math.huge

        for i = 1, #list do
            local st = list[i]
            if st.ped then
                local dist = #(coords - st.pos)
                if dist < nearestDist then
                    nearestDist = dist
                    nearestIdx = i
                end
            end
        end

        if nearestIdx and nearestDist <= pedSpawnDist then
            wait = 500

            if activeIdx ~= nearestIdx then
                if activeIdx then onExitStation(list[activeIdx]) end
                activeIdx = nearestIdx
                onEnterStation(list[activeIdx])
            end

            if not useTarget then
                if nearestDist < 1.2 then
                    if IsControlJustReleased(0, 38) then
                        openStation(list[nearestIdx].payment)
                    end
                    wait = 0
                end
            end
        elseif activeIdx then
            onExitStation(list[activeIdx])
            activeIdx = nil
            wait = 1000
        elseif nearestIdx and nearestDist <= mediumDist then
            wait = 1000
        end

        Wait(wait)
    end
end)
