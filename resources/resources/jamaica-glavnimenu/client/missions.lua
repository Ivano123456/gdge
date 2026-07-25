local lastPos = nil
local drivenKm = 0.0

CreateThread(function()
    while true do
        Wait(5000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local pos = GetEntityCoords(ped)
            if lastPos then
                local dist = #(pos - lastPos) / 1000.0
                if dist > 0.0 and dist < 2.0 then
                    drivenKm = drivenKm + dist
                end
            end
            lastPos = pos
        else
            lastPos = nil
        end
    end
end)

CreateThread(function()
    while true do
        Wait(30000)
        if drivenKm >= 0.05 then
            TriggerServerEvent('jamaica:server:missionDrive', drivenKm)
            drivenKm = 0.0
        end
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        local ped = PlayerPedId()
        local myCoords = GetEntityCoords(ped)
        local nearby = {}
        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() then
                local targetPed = GetPlayerPed(playerId)
                if targetPed ~= 0 and #(myCoords - GetEntityCoords(targetPed)) <= 10.0 then
                    nearby[#nearby + 1] = GetPlayerServerId(playerId)
                end
            end
        end
        if #nearby > 0 then
            TriggerServerEvent('jamaica:server:missionSocialTick', nearby)
        end
    end
end)
