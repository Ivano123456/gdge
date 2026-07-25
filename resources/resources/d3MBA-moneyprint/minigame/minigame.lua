local Framework = exports['d3MBA-lib']:GetFrameworkObject()

function microscopeMiniGame(numberOfRotations, speed)
    local numberOfRotations = numberOfRotations or 5
    local speed = speed or 5
    
    SendNUIMessage({
        action = "open",
        numberOfRotations = numberOfRotations,
        speed = speed,
    })

    SetNuiFocus(true, true)
    SetTimecycleModifier('hud_def_blur') -- blur
end

RegisterNuiCallback('close', function(data, cb) 
    SetNuiFocus(false, false)
    SetTimecycleModifier('default') -- remove blur
end)

RegisterNuiCallback('success', function(data, cb) 
    TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications['you_passed_minigame'], Framework.NotificationsSettings.Success, 5000)

    local certifiedMoneySheetItem = getCertifiedMoneySheet(microscopeSheetAdded)
    if certifiedMoneySheetItem ~= nil then 
        TriggerServerEvent("d3MBA-moneyprint:server:PickupPrintedMoneySheet", GetEntityCoords(MicroscopeEntity), certifiedMoneySheetItem)
        microscopeSheetAdded = nil
    else
        print("Failed to get certified money sheet item! Check your config: config/config.lua, config/items.lua")
    end
end)

RegisterNuiCallback('failed', function(data, cb)
    local randomChance = math.random(1, 100)

    if randomChance <= Config.Microscope.Minigame.ChanceToRemoveItemOnFail then
        microscopeSheetAdded = nil
        TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications['money_sheet_removed'], Framework.NotificationsSettings.Error, 5000)
    else
        TriggerEvent('d3MBA-lib:sendNotification', Config.Notifications['you_failed_minigame'], Framework.NotificationsSettings.Error, 5000)
    end 

end)
