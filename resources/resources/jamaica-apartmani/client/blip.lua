Citizen.CreateThread(function()
    local blipData = Config.Apartment.blip
    local blipCoords = blipData.blipCoords
    local blipName = blipData.blipName
    local blipId = blipData.blipId
    local blipColor = blipData.blipColor
    local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
    SetBlipSprite(blip, blipId)
    SetBlipColour(blip, blipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipName)
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
end)