local nuiOpen = false

local function focus(on)
    nuiOpen = on
    SetNuiFocus(on, on)
end

RegisterNUICallback('closeUI', function(_, cb)
    focus(false)
    cb('ok')
end)

RegisterNUICallback('sendReport', function(data, cb)
    local text = data and data.text
    if type(text) ~= 'string' then
        ESX.ShowNotification('Neispravan unos.')
        cb({ ok = false })
        return
    end
    text = text:gsub('^%s+', ''):gsub('%s+$', '')
    if #text < 10 then
        ESX.ShowNotification('Report mora imati najmanje 10 karaktera.')
        cb({ ok = false })
        return
    end
    ESX.TriggerServerCallback('jamaica-reportovi:submitReport', function(ok, err)
        if ok then
            ESX.ShowNotification('Report je poslat administratorima.')
            cb({ ok = true })
            focus(false)
            SendNUIMessage({ type = 'hidePlayer' })
        else
            ESX.ShowNotification(err or 'Greška pri slanju reporta.')
            cb({ ok = false })
        end
    end, text)
end)

RegisterNUICallback('clientNotify', function(data, cb)
    local m = data and data.msg
    if m then ESX.ShowNotification(m) end
    cb('ok')
end)

RegisterNUICallback('adminAction', function(data, cb)
    if type(data) ~= 'table' or type(data.action) ~= 'string' then
        cb({ ok = false })
        return
    end
    TriggerServerEvent('jamaica-reportovi:adminAction', data.action, data.targetId)
    cb({ ok = true })
end)

RegisterNetEvent('jamaica-reportovi:openAdmin', function(list)
    focus(true)
    SendNUIMessage({ type = 'openAdminReports', reports = list or {} })
end)

RegisterNetEvent('jamaica-reportovi:syncReports', function(list)
    if nuiOpen then
        SendNUIMessage({ type = 'updateReports', reports = list or {} })
    end
end)

RegisterNetEvent('jamaica-reportovi:teleportTo', function(x, y, z)
    if not x or not y or not z then return end
    SetEntityCoords(PlayerPedId(), x + 0.0, y + 0.0, z + 0.0, false, false, false, false)
end)

RegisterNetEvent('jamaica-reportovi:trySpectate', function(targetId)
    targetId = tonumber(targetId)
    if targetId then ExecuteCommand(('spectate %s'):format(targetId)) end
end)

RegisterCommand('pomoc', function()
    focus(true)
    SendNUIMessage({ type = 'openPlayerReport' })
end, false)

RegisterCommand('lp', function()
    TriggerServerEvent('jamaica-reportovi:requestAdminOpen')
end, false)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/pomoc', 'Pošalji report administratorima')
    TriggerEvent('chat:addSuggestion', '/lp', 'Lista reportova (samo admin)')
end)
