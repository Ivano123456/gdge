local ESX = exports['es_extended']:getSharedObject()
local menuOpen = false
local lastCasePick = nil
local lastCaseData = nil

RegisterCommand(Config.Command, function()
    OpenJamaicaMenu('boxes')
end, false)

RegisterKeyMapping(Config.Command, 'Otvori Jamaica meni', 'keyboard', Config.OpenKey)

RegisterNetEvent('jamaica:client:open', function(tab)
    OpenJamaicaMenu(tab or 'boxes')
end)

exports('OpenHub', function(tab)
    OpenJamaicaMenu(tab or 'boxes')
end)

function OpenJamaicaMenu(tab)
    if menuOpen then
        SendNUIMessage({ action = 'switchTab', tab = tab or 'boxes' })
        return
    end
    menuOpen = true
    SetNuiFocus(true, true)
    ESX.TriggerServerCallback('jamaica:getHubData', function(data)
        if not data then
            CloseJamaicaMenu()
            return
        end
        ESX.TriggerServerCallback('jamaica:getDaily', function(daily)
            data.daily = daily
            SendNUIMessage({ action = 'open', tab = tab, data = data })
        end)
    end)
end

local function AutoCollectPendingCase(cb)
    if not lastCasePick or not lastCaseData then
        if cb then cb(false) end
        return
    end
    local pick, data = lastCasePick, lastCaseData
    lastCasePick = nil
    lastCaseData = nil
    ESX.TriggerServerCallback('jamaica:collectCaseItem', function(ok)
        if ok then
            ESX.ShowNotification('Predmet prikupljen!')
        end
        if cb then cb(ok) end
    end, pick, data)
end

function CloseJamaicaMenu()
    if not menuOpen then return end
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    -- Safety: ako NUI nije stigao da prikupi (ESC, focus gubitak), auto PRIKUPI
    AutoCollectPendingCase()
end

RegisterNUICallback('close', function(_, cb)
    CloseJamaicaMenu()
    cb('ok')
end)

RegisterNUICallback('openUrl', function(data, cb)
    if data.url then
        SendNUIMessage({ action = 'openUrl', url = data.url })
    end
    cb('ok')
end)

RegisterNUICallback('claimBpReward', function(data, cb)
    TriggerServerEvent('jamaica:server:claimBpReward', data.type, data.level)
    cb('ok')
end)

RegisterNUICallback('claimDaily', function(_, cb)
    ESX.TriggerServerCallback('jamaica:claimDaily', function(ok, payload)
        cb({ ok = ok, payload = payload })
    end)
end)

RegisterNUICallback('redeemCode', function(data, cb)
    ESX.TriggerServerCallback('jamaica:redeemCode', function(amount)
        cb({ ok = amount ~= false, amount = amount })
    end, data.code)
end)

RegisterNUICallback('buyCaseItem', function(data, cb)
    ESX.TriggerServerCallback('jamaica:buyCaseItem', function(result)
        cb(result or { ok = false })
    end, data)
end)

RegisterNUICallback('buyCasesBatch', function(data, cb)
    ESX.TriggerServerCallback('jamaica:buyCasesBatch', function(result)
        cb(result or { ok = false })
    end, data.items)
end)

RegisterNUICallback('consumeStashCase', function(data, cb)
    ESX.TriggerServerCallback('jamaica:consumeStashCase', function(result)
        cb(result or { ok = false })
    end, data.stashId)
end)

RegisterNUICallback('refreshData', function(_, cb)
    ESX.TriggerServerCallback('jamaica:getHubData', function(data)
        ESX.TriggerServerCallback('jamaica:getDaily', function(daily)
            data.daily = daily
            cb(data)
        end)
    end)
end)

RegisterNUICallback('openCaseSelect', function(data, cb)
    local list = data.caseType == 'premium' and CaseConfig.PremiumCases or CaseConfig.StandardCases
    local caseData
    for i = 1, #list do
        if list[i].uniqueId == data.uniqueId then
            caseData = list[i]
            break
        end
    end
    if not caseData then cb(false) return end
    local pool = {}
    for i = 1, #caseData.items do
        local it = caseData.items[i]
        local n = math.max(1, math.ceil((it.chance or 1) / 0.1))
        for _ = 1, n do pool[#pool + 1] = it end
    end
    lastCasePick = pool[math.random(1, #pool)]
    lastCaseData = caseData
    ESX.TriggerServerCallback('jamaica:openCase', function(ok, itemOrErr, caseInfo)
        if ok then
            lastCasePick = itemOrErr
            lastCaseData = caseInfo or caseData
            cb(lastCasePick)
        else
            lastCasePick = nil
            lastCaseData = nil
            cb(false)
        end
    end, caseData.uniqueId, data.caseType, lastCasePick, data.skipPayment == true)
end)

RegisterNUICallback('collectCaseItem', function(_, cb)
    if not lastCasePick or not lastCaseData then cb(false) return end
    local pick, data = lastCasePick, lastCaseData
    lastCasePick = nil
    lastCaseData = nil
    ESX.TriggerServerCallback('jamaica:collectCaseItem', function(ok, lastItems)
        cb({ ok = ok, lastItems = lastItems })
    end, pick, data)
end)

RegisterNUICallback('sellCaseItem', function(_, cb)
    if not lastCasePick or not lastCaseData then cb(false) return end
    local pick, data = lastCasePick, lastCaseData
    lastCasePick = nil
    lastCaseData = nil
    ESX.TriggerServerCallback('jamaica:sellCaseItem', function(ok)
        cb(ok)
    end, pick, data)
end)

RegisterNetEvent('jamaica:client:updateBattlepass', function(payload)
    SendNUIMessage({ action = 'updateBattlepass', battlepass = payload })
end)

RegisterNetEvent('jamaica:client:refreshBalance', function()
    ESX.TriggerServerCallback('jamaica:getHubData', function(data)
        if data then
            SendNUIMessage({ action = 'updateBalance', goldcoin = data.goldcoin, standardcoin = data.standardcoin })
        end
    end)
end)

RegisterNetEvent('jamaica:client:notify', function(message, ntype)
    ESX.ShowNotification(message)
end)

RegisterNetEvent('jamaica:client:bigWin', function(info)
    SendNUIMessage({ action = 'bigWin', info = info })
end)

CreateThread(function()
    while true do
        if menuOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.PlayTimeStandardInterval * 60000)
        TriggerServerEvent('jamaica:server:addStandardPlaytime')
    end
end)

RegisterNetEvent('jamaica:client:spawnVehicle', function(data)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    ESX.Game.SpawnVehicle(data.hash, vector3(coords.x, coords.y, coords.z), 0.0, function(vehicle)
        SetVehicleNumberPlateText(vehicle, data.plate)
        SetPedIntoVehicle(ped, vehicle, -1)
        Wait(150)
        local props = ESX.Game.GetVehicleProperties(vehicle)
        TriggerServerEvent('jamaica:server:insertVehicle', data.owner, props)
        DeleteVehicle(vehicle)
    end)
end)
