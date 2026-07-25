local ESX = exports['es_extended']:getSharedObject()
local nuiOpen = false

local function closeNui()
    if not nuiOpen then return end
    nuiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'forceClose' })
end

RegisterNetEvent('jamaica-welcomee:client:open', function(caseData, imagePath)
    if nuiOpen then return end
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        caseData = caseData,
        imagePath = imagePath,
    })
end)

RegisterNUICallback('openCaseSelect', function(_, cb)
    ESX.TriggerServerCallback('jamaica-welcomee:openCaseSelect', function(result)
        cb(result or false)
    end)
end)

RegisterNUICallback('collectCaseItem', function(_, cb)
    ESX.TriggerServerCallback('jamaica-welcomee:collectCaseItem', function(ok)
        cb(ok == true)
    end)
end)

RegisterNUICallback('close', function(_, cb)
    closeNui()
    TriggerServerEvent('jamaica-welcomee:server:cancel')
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    closeNui()
end)
