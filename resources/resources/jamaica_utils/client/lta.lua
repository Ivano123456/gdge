local ltaTable = {}
local drawActive = false

local function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.10, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('ltalog:client', function(data)
    ltaTable = data or {}
    drawActive = next(ltaTable) ~= nil
end)

CreateThread(function()
    local maxDistSq = 50.0 * 50.0
    while true do
        if drawActive then
            local coords = GetEntityCoords(cache.ped)
            for _, v in pairs(ltaTable) do
                if v.coords then
                    local dx = coords.x - v.coords.x
                    local dy = coords.y - v.coords.y
                    local dz = coords.z - v.coords.z
                    if (dx * dx + dy * dy + dz * dz) < maxDistSq then
                        local text = ('%s je izašao/la sa servera\nId: %s\nUUID: %s\nRazlog: %s'):format(
                            v.name, v.id, v.uuid or 'N/A', v.razlog
                        )
                        DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, text)
                    end
                end
            end
            Wait(0)
        else
            Wait(1000)
        end
    end
end)
