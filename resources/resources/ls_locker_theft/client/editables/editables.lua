---Must return true/false
function OnHackStart(locker_entity)
    local camera = HELPERS.custom_camera(locker_entity)

    if Config.dispatch.enabled then
        SendDispatchAlert()
    end

    local success = StartHackMinigame()

    HELPERS.remove_camera(camera)

    return success
end

local last_check = 0
function PoliceCheck()
    if not Config.minimum_police_amount.enabled then
        return true
    end

    if GetGameTimer() - last_check <= 500 then
        return false
    end
    last_check = GetGameTimer()

    local enough_police = HELPERS.callServerAwaitingResponse('police_check')
    if not enough_police then
        exports['kq_link']:Notify(L('not_enough_police'):format(Config.minimum_police_amount.count), 'error')
    end
    return enough_police
end

function StartHackMinigame()
    local promise = promise.new()

    SendNUIMessage({
        action = 'start_hack',
        codeLength = Config.hack.code_length,
        maxAttempts = Config.hack.max_attempts,
        timerLength = Config.hack.timer_length,
        is_debug = Config.debug
    })

    SetNuiFocus(true, true)

    RegisterNUICallback('hackComplete', function(data, cb)
        SetNuiFocus(false, false)
        promise:resolve(data.success)
        cb('ok')
    end)

    return Citizen.Await(promise)
end

function SendDispatchAlert()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent('ls_locker_theft:server:dispatchAlert', {
        x = coords.x,
        y = coords.y,
        z = coords.z,
    })
end