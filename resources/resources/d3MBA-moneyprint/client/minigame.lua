local Framework = exports['d3MBA-lib']:GetFrameworkObject()

function MiniGame() 
    local Passed = false 
    exports['ps-ui']:Circle(function(success)
        if success then
            TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["you_passed_minigame"], Framework.NotificationsSettings.Success, 5000) 
            Passed = true 
        else
            TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications["you_failed_minigame"], Framework.NotificationsSettings.Error, 5000)
        end
    end, 2, 20) -- NumberOfCircles, MS
    return Passed
end 
