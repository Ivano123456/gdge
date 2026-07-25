local function showAnnounce(seconds, title, message)
    SendNUIMessage({
        type = 'showDvall',
        title = title,
        message = message,
        time = seconds,
    })
end

local function hideAnnounce()
    SendNUIMessage({
        type = 'hideDvall',
    })
end

RegisterNetEvent('jamaica-dvall:announce', function(seconds, title, message)
    showAnnounce(seconds or Config.DeleteDelaySeconds, title or Config.AnnounceTitle, message or Config.AnnounceMessage)
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        hideAnnounce()
    end
end)
