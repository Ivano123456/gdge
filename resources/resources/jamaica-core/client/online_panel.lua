local ESX = exports['es_extended']:getSharedObject()

local lastToggle = 0

local function buildOnlineNotifyText(data)
    local parts = {}

    for i = 1, #(data.organizations or {}) do
        local org = data.organizations[i]
        local count = org.count or 0
        local color = count > 0 and '~g~' or '~s~'
        parts[#parts + 1] = ('%s%s~s~: %s%d'):format(color, org.label, color, count)
    end

    local staff = #(data.admins or {})
    local staffColor = staff > 0 and '~b~' or '~s~'
    parts[#parts + 1] = ('%sStaff na dužnosti~s~: %s%d'):format(staffColor, staffColor, staff)

    return table.concat(parts, '   •   ')
end

RegisterCommand('+jamaica_online_panel', function()
    local now = GetGameTimer()
    if now - lastToggle < 800 then return end
    lastToggle = now

    ESX.TriggerServerCallback('jamaica-core:getOnlinePanel', function(data)
        if not data then return end
        lib.notify({
            title = 'Državne službe',
            description = buildOnlineNotifyText(data),
            type = 'info',
            duration = Config.OnlinePanel.NotifyDuration or 10000,
        })
    end)
end, false)

RegisterCommand('-jamaica_online_panel', function() end, false)
RegisterKeyMapping('+jamaica_online_panel', 'Online status službi', 'keyboard', Config.OnlinePanel.Key)
