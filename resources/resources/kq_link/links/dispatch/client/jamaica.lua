if Link.dispatch.system ~= 'jamaica' then return end

function SendDispatchMessage(data)
    local coords = data.coords or GetEntityCoords(PlayerPedId())
    local ulicaHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local ulicaIme = GetStreetNameFromHashKey(ulicaHash)
    local blip = data.blip or {}

    exports['jamaica-dispatch']:KreirajPoziv({
        title = data.message or '',
        description = data.description or '',
        posao = data.jobs or { 'police' },
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = data.code or '10-35',
        blip = {
            sprite = blip.sprite or 4,
            velicina = blip.scale or 1.0,
            text = blip.text or data.message or '',
            boja = blip.color or 1,
        }
    })
end
