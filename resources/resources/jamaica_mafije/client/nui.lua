local isNuiOpen = false

local function GetPlayerData()
    if ESX and ESX.GetPlayerData then
        return ESX.GetPlayerData()
    end
    return nil
end

function MafiaNotify(message, notifType, duration)
    notifType = notifType or 'mafia'
    duration = duration or 5000
    SendNUIMessage({
        type = 'mafiaNotification',
        message = message,
        notifType = notifType,
        duration = duration
    })
end

exports('MafiaNotify', MafiaNotify)

RegisterNetEvent('jamaica_mafije:notify')
AddEventHandler('jamaica_mafije:notify', function(message, notifType, duration)
    MafiaNotify(message, notifType, duration)
end)

RegisterNetEvent('jamaica_mafije:forceCloseNui')
AddEventHandler('jamaica_mafije:forceCloseNui', function()
    if isNuiOpen then
        SetNuiFocus(false, false)
        isNuiOpen = false
    end
end)

RegisterNUICallback('zatvori', function(_, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isNuiOpen = false
    cb('ok')
end)

function OpenGarageMenuNUI(garageType)
    if isNuiOpen then return end

    local pData = GetPlayerData()
    if not ESX or not pData or not pData.job then return end

    local mafiaConfig = Config.Mafije[pData.job.name]
    if not mafiaConfig then
        MafiaNotify('Nemate pristup garazi!', 'error')
        return
    end

    ESX.TriggerServerCallback('jamaica_mafije:proveriVozila', function(vehicleCount)
        local spawnedCount = type(vehicleCount) == 'table' and #vehicleCount or 0
        local limit = mafiaConfig['Limit'] or 999

        SetNuiFocus(true, true)
        isNuiOpen = true

        SendNUIMessage({
            type = 'openGarageMenu',
            orgName = pData.job.label or pData.job.name,
            spawnedCount = spawnedCount,
            limit = limit < 999 and tostring(limit) or '∞',
            resetTimeSeconds = 0,
            vehicles = mafiaConfig['MeniVozila'] or {},
            helicopters = mafiaConfig['MeniHelikoptera'] or {},
            boats = mafiaConfig['BrodoviMenu'] or {},
        })
    end)
end

RegisterNUICallback('closeGarageMenu', function(_, cb)
    SetNuiFocus(false, false)
    isNuiOpen = false
    cb('ok')
end)

RegisterNUICallback('garageSpawnVehicle', function(data, cb)
    SetNuiFocus(false, false)
    isNuiOpen = false

    if data.model then
        TriggerEvent('jamaica_mafije:spawnVehicleFromGarage', data.model, data.vehicleType)
    end

    cb('ok')
end)

exports('OpenGarageMenuNUI', OpenGarageMenuNUI)
