SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

CreateThread(function()
    SetRadarZoom(1100)
    local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
    while true do
        Wait(500)
        local now = IsPedInAnyVehicle(PlayerPedId(), false)
        if now ~= inVehicle then
            inVehicle = now
            SetRadarZoom(1100)
        end
    end
end)
