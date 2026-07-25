RegisterNetEvent('jamaica_utils:copyCoords', function()
    local ped = cache.ped or PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local text = ('%.4f, %.4f, %.4f, %.4f'):format(coords.x, coords.y, coords.z, heading)

    lib.setClipboard(text)
    ESX.ShowNotification('Koordinate kopirane u clipboard: ' .. text)
end)
