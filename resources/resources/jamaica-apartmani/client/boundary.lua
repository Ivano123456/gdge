CreateThread(function()
    local interval = Config.ApartmentBoundary.checkInterval or 2000
    local center = Config.ApartmentBoundary.center
    local maxRadius = Config.ApartmentBoundary.radius or 100.0

    while true do
        Wait(interval)

        if apartmentIn > 0 then
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(vector2(coords.x, coords.y) - vector2(center.x, center.y))

            if dist > maxRadius then
                apartmentIn = 0
                isOwner = false
            end
        end
    end
end)
