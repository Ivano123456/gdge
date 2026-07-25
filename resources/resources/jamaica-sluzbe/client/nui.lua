local isNuiOpen = false
local isF6MenuOpen = false

function SluzbeNotify(message, notifType, duration)
    notifType = notifType or 'info'
    duration = duration or 5000
    SendNUIMessage({
        type = 'sluzbeNotification',
        message = message,
        notifType = notifType,
        duration = duration,
    })
end

RegisterNetEvent('jamaica-sluzbe:notify')
AddEventHandler('jamaica-sluzbe:notify', function(message, notifType, duration)
    SluzbeNotify(message, notifType, duration)
end)

local function getJobConfig()
    local pData = ESX.GetPlayerData()
    if not pData or not pData.job then return nil end
    return GetSluzbaConfig(pData.job.name)
end

function OpenSluzbeF6Menu()
    if isNuiOpen then return end
    if not ProveriDuznost() then return end

    local pData = ESX.GetPlayerData()
    if not pData or not pData.job then return end

    local cfg = getJobConfig()
    if not cfg then return end

    if GetResourceState('jamaica-safezone') == 'started' and exports['jamaica-safezone']:BlockJobMenu() then
        return
    end

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    isNuiOpen = true
    isF6MenuOpen = true

    SendNUIMessage({
        type = 'openF6Menu',
        orgName = pData.job.label or cfg['label'] or pData.job.name,
        showGps = true,
    })
end

local function closeAllNui()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isNuiOpen = false
    isF6MenuOpen = false
    SendNUIMessage({ type = 'closeAllMenus' })
end

CreateThread(function()
    while true do
        if isF6MenuOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 3, true)
            DisableControlAction(0, 4, true)
            DisableControlAction(0, 5, true)
            DisableControlAction(0, 6, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            SetPauseMenuActive(false)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

RegisterNUICallback('closeF6Menu', function(_, cb)
    closeAllNui()
    cb('ok')
end)

RegisterNUICallback('f6Action', function(data, cb)
    closeAllNui()
    if data and data.action then
        if not ProveriDuznost() then
            cb('ok')
            return
        end
        if GetResourceState('jamaica-safezone') == 'started' and exports['jamaica-safezone']:BlockJobMenu() then
            cb('ok')
            return
        end
        TriggerEvent('jamaica-sluzbe:f6Action', data.action)
    end
    cb('ok')
end)

local function refreshVehicleShop()
    ESX.TriggerServerCallback('jamaica-sluzbe:getVehicleShopData', function(data)
        SendNUIMessage({
            type = 'vehicleShopList',
            purchase = data and data.purchase or {},
            garage = data and data.garage or {},
            impound = data and data.impound or {},
            impoundPrice = data and data.impoundPrice or 500,
        })
    end)
end

function OpenSluzbeVehicleShopNUI()
    if isNuiOpen then return end
    if not ProveriDuznost() then return end

    local pData = ESX.GetPlayerData()
    if not pData or not pData.job or not getJobConfig() then return end

    SetNuiFocus(true, true)
    isNuiOpen = true
    SendNUIMessage({
        type = 'openVehicleShop',
        orgName = pData.job.label or pData.job.name,
    })
    refreshVehicleShop()
end

RegisterNetEvent('jamaica-sluzbe:vehicleShopRefresh')
AddEventHandler('jamaica-sluzbe:vehicleShopRefresh', function()
    if isNuiOpen then
        refreshVehicleShop()
    end
end)

RegisterNUICallback('closeVehicleShop', function(_, cb)
    closeAllNui()
    cb('ok')
end)

RegisterNUICallback('purchaseVehicle', function(data, cb)
    if not ProveriDuznost() then
        cb('ok')
        return
    end
    if data and data.model then
        TriggerServerEvent('jamaica-sluzbe:purchaseVehicle', data.model)
    end
    cb('ok')
end)

RegisterNUICallback('payImpound', function(data, cb)
    if not ProveriDuznost() then
        cb('ok')
        return
    end
    if not data or not data.id then
        cb('ok')
        return
    end

    ESX.TriggerServerCallback('jamaica-sluzbe:payImpound', function(success, message)
        if not success then
            SluzbeNotify(type(message) == 'string' and message or 'Impound nije uspeo.', 'error')
            return
        end
        refreshVehicleShop()
    end, data.id)
    cb('ok')
end)

RegisterNUICallback('spawnOrgVehicle', function(data, cb)
    closeAllNui()
    if not ProveriDuznost() then
        cb('ok')
        return
    end
    if not data or not data.id then
        cb('ok')
        return
    end

    ESX.TriggerServerCallback('jamaica-sluzbe:spawnOrgVehicle', function(success, payload)
        if not success then
            SluzbeNotify(type(payload) == 'string' and payload or 'Vozilo nije moglo biti izvuceno.', 'error')
            return
        end
        TriggerEvent('jamaica-sluzbe:client:spawnOrgVehicle', payload)
    end, data.id)
    cb('ok')
end)

RegisterNUICallback('zatvori', function(_, cb)
    closeAllNui()
    cb('ok')
end)

AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then return end
    if isNuiOpen then
        closeAllNui()
    end
end)

exports('OpenSluzbeVehicleShopNUI', OpenSluzbeVehicleShopNUI)
exports('OpenSluzbeF6Menu', OpenSluzbeF6Menu)
exports('SluzbeNotify', SluzbeNotify)
