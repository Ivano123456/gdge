RegisterNetEvent('fulltune:applyPerformanceTune')
AddEventHandler('fulltune:applyPerformanceTune', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh ~= 0 then
        SetVehicleModKit(veh, 0)

        -- Samo performance tuning
        SetVehicleMod(veh, 11, GetNumVehicleMods(veh, 11) - 1, false) -- Engine
        SetVehicleMod(veh, 12, GetNumVehicleMods(veh, 12) - 1, false) -- Brakes
        SetVehicleMod(veh, 13, GetNumVehicleMods(veh, 13) - 1, false) -- Transmission
        SetVehicleMod(veh, 15, GetNumVehicleMods(veh, 15) - 1, false) -- Suspension
        SetVehicleMod(veh, 16, GetNumVehicleMods(veh, 16) - 1, false) -- Armor
        ToggleVehicleMod(veh, 18, true) -- Turbo ON

        -- Popravi i očisti auto
        SetVehicleFixed(veh)
        SetVehicleDirtLevel(veh, 0.0)

        -- Poruka igraču
        TriggerEvent('esx:showNotification', '✅ Vozilo potpuno performansno tunirano!')
    else
        TriggerEvent('esx:showNotification', '❌ Moraš biti u vozilu!')
    end
end)
