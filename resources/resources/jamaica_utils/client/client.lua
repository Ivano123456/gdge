lib.onCache('vehicle', function(value)
    SetUserRadioControlEnabled(false)
    SetVehRadioStation(value, "OFF")
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local sleep = 500
        if IsPedArmed(ped, 6) then
            sleep = 0
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
        Wait(sleep)
    end
end)

RegisterKeyMapping('blockaction', 'Blokiraj akciju i resetuj zadatke', 'keyboard', 'r')

RegisterCommand('blockaction', function()
    if IsControlPressed(0, 224) then
        local playerPed = PlayerPedId()
        ClearPedTasksImmediately(playerPed)

        local disableTime = 2000
        local startTime = GetGameTimer()

        CreateThread(function()
            while GetGameTimer() - startTime < disableTime do
                DisableAllControlActions(0)
                EnableControlAction(0, 200, true)
                EnableControlAction(0, 199, true)
                EnableControlAction(0, 1, true)
                EnableControlAction(0, 2, true)
                Wait(0)
            end
        end)
    end
end, false)
