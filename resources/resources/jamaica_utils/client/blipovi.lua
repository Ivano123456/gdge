CreateThread(function()
    for _, v in pairs(Config.Blipovi) do
        local blip = AddBlipForCoord(v.kordinate)
        SetBlipSprite(blip, v.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.velicina)
        SetBlipColour(blip, v.boja)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.text)
        EndTextCommandSetBlipName(blip)
    end
end)