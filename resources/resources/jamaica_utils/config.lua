Config = {}
Config.FlatTireMaxSpeed = 40
Config.SlovaTablice  = 3
Config.BrojeviTablice  = 3
Config.BotIcon = 'https://r2.fivemanage.com/FwHL7CGQjt9xGphPKssIi/logo.png'

Config.Blipovi = {
    {id = 307, boja = 46, velicina = 0.6, text = "Cayo Perico Most", kordinate = vector3(743.2055, -2792.8418, 5.6583)},
    {id = 79, boja = 46, velicina = 0.6, text = "Topionica", kordinate = vector3(1101.2698, -2002.9213, 29.7162)},
}

Config.SeeOwnLabel = true
Config.SeeDistance = 20
Config.TextSize = 0.8
Config.ZOffset = 1.0
Config.NearCheckWait = 500

Config.TagGroups = {
    'helper',
    'admin',
    'roleplayadmin',
    'eventadmin',
    'superadmin',
    'headadmin',
    'vodja_eventa',
    'vodja_lidera',
    'vodja_admina',
    'menadzer',
    'asistent',
    'suvlasnik',
    'vlasnik',
}

Config.Itemi = {
    {item = "celicni_ostaci",    min = 2, max = 5, chance = 18},
    {item = "plastika",          min = 2, max = 6, chance = 16},
    {item = "bakar_zica",        min = 1, max = 4, chance = 12},
    {item = "guma",              min = 1, max = 3, chance = 10},
    {item = "srafovi",           min = 2, max = 5, chance = 12},
    {item = "opruga",            min = 1, max = 2, chance = 10},
    {item = "prazna_cahura",     min = 1, max = 3, chance = 10},
    {item = "elektronski_otpad", min = 1, max = 3, chance = 8},
    {item = "balisticno_platno",   min = 1, max = 2, chance = 4},
    {item = "lockpick",            min = 1, max = 2, chance = 4},
}

Config.Kontejneri = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

Config.Barut = {
    coords = vector4(1087.9120, -2001.8534, 30.8806, 131.2439),
    drawDistance = 15.0,
    interactDistance = 2.0,
    duration = 5000,
    item = 'barut',
    amount = 1,
}

Config.GroupLabels = {
    helper        = '~y~HELPER',
    admin         = '~y~ADMIN',
    roleplayadmin = '~y~ROLEPLAY ADMIN',
    eventadmin    = '~y~EVENT ADMIN',
    superadmin    = '~y~SUPER ADMIN',
    headadmin     = '~y~HEAD ADMIN',
    vodja_eventa  = '~y~VODJA EVENTA',
    vodja_lidera  = '~y~VODJA LIDERA',
    vodja_admina  = '~y~VODJA ADMINA',
    menadzer      = '~y~MENADŽER',
    asistent      = '~y~ASISTENT',
    suvlasnik     = '~y~SU-VLASNIK',
    vlasnik       = '~y~VLASNIK',
}

function Config.IsTagGroup(group)
    if type(group) ~= 'string' or group == '' then
        return false
    end
    return Config.GroupLabels[group] ~= nil
end

Config.NpcDisable = {
    enabled = true,

    pedDensity = 0.35,
    scenarioPedInterior = 0.0,
    scenarioPedExterior = 0.35,
    vehicleDensity = 0.1,
    randomVehicleDensity = 0.1,
    parkedVehicleDensity = 0.0,

    pedPopulationBudget = nil,
    vehiclePopulationBudget = nil,

    disableRandomCops = true,
    disableGarbageTrucks = true,
    disableRandomBoats = true,
    disableDistantCopCars = true,
    disableParkedVehicleGenerators = true,

    spheres = {
        -- { coords = vector3(441.0, -981.0, 30.0), radius = 120.0, pedMult = 0.0, vehMult = 0.0 },
    },

    areas = {
        -- { pos1 = vector3(407.0, -1035.0, 29.0), pos2 = vector3(492.0, -963.0, 27.0), pedMult = 0.0, vehMult = 0.0 },
    },
}


