-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

RegisterNetEvent('wasabi_gps:notify', function(title, message, type)
    if GetResourceState('ox_lib'):find('start') then
        exports.ox_lib:notify({
            title = title,
            description = message,
            type = type or 'inform',
        })
        return
    end

    local ESX = exports.es_extended:getSharedObject()
    ESX.ShowNotification(message, type or 'info')
end)
