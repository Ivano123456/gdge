local Framework = exports['d3MBA-lib']:GetFrameworkObject()

function startHacking(entity)
    exports['ps-ui']:VarHack(function(success) -- YOU CAN CHANGE THE MINIGAME HERE
        if success then
            TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications['you_passed_minigame'], Framework.NotificationsSettings.Success, 5000)
            TriggerServerEvent("d3MBA-moneyprint:server:HackBlueprint", GetEntityCoords(entity))
        else
            TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications['you_failed_minigame'], Framework.NotificationsSettings.Error, 5000)
        end
    end, 5, 20)  -- Number of Blocks, Time in seconds
end
