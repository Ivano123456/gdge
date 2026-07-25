local config = require 'shared.main'

local function lokacijaIgraca()
    local coords = GetEntityCoords(cache.ped)
    local ulicaHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    return coords, GetStreetNameFromHashKey(ulicaHash)
end

local function posaljiDojavu(data)
    KreirajPoziv(data)
end

function Pucnjava()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('civil_call'),
        description = locale('shooting'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = 'S.O.S',
        blip = {
            sprite = 156,
            velicina = 1.0,
            text = locale('call_blips.pucnjava'),
            boja = 1,
        }
    })
end

function PucnjavaVozila()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('civil_call'),
        description = locale('pucnjava_vozilo'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = 'S.O.S',
        blip = {
            sprite = 229,
            velicina = 1.0,
            text = locale('call_blips.pucnjava_vozilo'),
            boja = 1,
        }
    })
end

function Tucnjava()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('civil_call'),
        description = locale('fight_in_progress'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        kod = '10-10',
        tip = 'S.O.S',
        blip = {
            sprite = 630,
            velicina = 1.0,
            text = locale('call_blips.fight_in_progress'),
            boja = 1,
        }
    })
end

function OtimanjeVozila()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('civil_call'),
        description = locale('OtimanjeVozila'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = 'S.O.S',
        kod = '10-61',
        blip = {
            sprite = 620,
            velicina = 1.0,
            text = locale('call_blips.OtimanjeVozila'),
            boja = 1,
        }
    })
end

function ObijanjeVozila()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('civil_call'),
        description = locale('obijanje_vozila'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = 'S.O.S',
        kod = '10-61',
        blip = {
            sprite = 620,
            velicina = 1.0,
            text = locale('call_blips.obijanje_vozila'),
            boja = 1,
        }
    })
end

function Eksplozija()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('civil_call'),
        description = locale('Eksplozija'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        kod = '10-99',
        tip = 'S.O.S',
        blip = {
            sprite = 652,
            velicina = 1.0,
            text = locale('call_blips.Eksplozija'),
            boja = 6,
        }
    })
end

function PrekoracenjeBrzine()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = locale('radar_detect'),
        description = locale('PrekoracenjeBrzine'),
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        kod = '10-20',
        tip = 'DET',
        blip = {
            sprite = 652,
            velicina = 1.0,
            text = locale('call_blips.PrekoracenjeBrzine'),
            boja = 6,
        }
    })
end

function PozivHitne()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = 'Poziv u pomoc',
        description = 'Lice je povredjeno i zahteva se hitna medicinska pomoc.',
        posao = { 'hitna', 'doa', 'police' },
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = 'SOS',
        blip = {
            sprite = 126,
            velicina = 1.0,
            text = 'Povredjeno lice',
            boja = 46,
        }
    })
end

exports('PozivHitne', PozivHitne)

function SluzbeSalter(posao, label)
    local coords, ulicaIme = lokacijaIgraca()
    local orgLabel = label or posao or 'Sluzba'
    posaljiDojavu({
        title = 'Poziv od strane civila',
        description = ('Zamolili su pristustvo na salteru: %s.'):format(orgLabel),
        posao = posao,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        tip = 'SOS',
        blip = {
            sprite = 535,
            velicina = 0.3,
            text = orgLabel .. ' Salter',
            boja = 46,
        }
    })
end

exports('SluzbeSalter', SluzbeSalter)

function PlajckaProdavnice()
    local coords, ulicaIme = lokacijaIgraca()
    posaljiDojavu({
        title = 'Poziv od strane civila',
        description = 'Pljacka prodavnice u toku.',
        posao = config.PolicijskiPoslovi,
        vremeBlipa = 2,
        coords = coords,
        ulica = ulicaIme,
        kod = '10-31',
        tip = 'SOS',
        blip = {
            sprite = 52,
            velicina = 1.0,
            text = 'Pljacka prodavnice',
            boja = 1,
        }
    })
end

exports('PlajckaProdavnice', PlajckaProdavnice)
