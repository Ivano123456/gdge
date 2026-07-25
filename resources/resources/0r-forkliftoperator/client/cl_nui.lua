local Config <const> = require "config.main"
local oldClothesCache = {}
local oldPropsCache = {}
local isWearingJobClothes = false

RegisterNUICallback('nui/checked', function(data, cb)
    NuiLoaded = true
    cb('ok')
end)

RegisterNUICallback('nui/close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('multiplayer/invite-player', function(data, cb)
    local targetId = data.playerId
    if not targetId then
        Notify.SendNotify(locale('notification.error.enter_player_id'), 'error')
        return
    end

    TriggerServerEvent(Event('server:invitePlayerToMultiplayerTeam'), CurrentMultiplayerData.teamId, targetId)
    cb('ok')
end)

RegisterNUICallback('multiplayer/kick-player', function(data, cb)
    local targetId = data.playerId
    if not targetId then
        Notify.SendNotify(locale('notification.error.enter_player_id'), 'error')
        return
    end

    lib.callback(Event('callback:kickPlayerFromMultiplayerTeam'), false, function(success)
        cb({
            success = success
        })
    end, CurrentMultiplayerData.teamId, targetId)
end)

RegisterNUICallback('multiplayer/leave-team', function(data, cb)
    TriggerServerEvent(Event('server:leaveMultiplayerTeam'), CurrentMultiplayerData.teamId)
    cb('ok')
end)

RegisterNUICallback('task/start-multiplayer-task', function(data, cb)
    if not CurrentMultiplayerData and next(CurrentMultiplayerData) == nil then
        Notify.SendNotify(locale('notification.error.not_in_team'), 'error')
        return
    end

    TriggerServerEvent(Event('server:startMultiplayerTask'), CurrentMultiplayerData.teamId, data.id)
    SetNuiFocus(false, false)

    cb('ok')
end)

RegisterNUICallback('game/changeClothes', function(_, cb)
    local ped = cache.ped
    local pedModel = GetEntityModel(ped)

    local gender = 'male'
    if pedModel == GetHashKey('mp_f_freemode_01') then
        gender = 'female'
    end

    if not Config.JobClothes or not Config.JobClothes[gender] then
        cb('no_config')
        return
    end

    local jobClothes = Config.JobClothes[gender]

    lib.requestAnimDict('mp_masks@truck@ds@')
    TaskPlayAnim(ped, 'mp_masks@truck@ds@', 'put_on_mask', 8.0, 8.0, -1, 49, 0, false, false, false)
    RemoveAnimDict('mp_masks@truck@ds@')

    local success = lib.progressCircle({
        duration = 2000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    })

    if not success then
        ClearPedTasks(ped)
        cb('cancelled')
        return
    end

    if not isWearingJobClothes then
        oldClothesCache = {}
        oldPropsCache = {}

        for compId = 0, 11 do
            if compId == 2 then goto continue end
            oldClothesCache[compId] = {
                item = GetPedDrawableVariation(ped, compId),
                texture = GetPedTextureVariation(ped, compId),
            }
            SetPedComponentVariation(ped, compId, 0, 0, 0)
            ::continue::
        end

        for propId = 0, 7 do
            local drawable = GetPedPropIndex(ped, propId)
            if drawable ~= -1 then
                oldPropsCache[propId] = {
                    item = drawable,
                    texture = GetPedPropTextureIndex(ped, propId),
                }
            end
            ClearPedProp(ped, propId)
        end

        for _, v in pairs(jobClothes) do
            if v.type == 'component' then
                SetPedComponentVariation(ped, v.componentId, v.item, v.texture, 0)
            elseif v.type == 'prop' then
                SetPedPropIndex(ped, v.componentId, v.item, v.texture, true)
            end
        end

        isWearingJobClothes = true
    else
        if oldClothesCache then
            for compId, data in pairs(oldClothesCache) do
                SetPedComponentVariation(ped, compId, data.item, data.texture, 0)
            end
        end
        if oldPropsCache then
            for propId, data in pairs(oldPropsCache) do
                SetPedPropIndex(ped, propId, data.item, data.texture, true)
            end
        end

        oldClothesCache = {}
        oldPropsCache = {}
        isWearingJobClothes = false
    end

    ClearPedTasks(ped)
    cb('ok')
end)