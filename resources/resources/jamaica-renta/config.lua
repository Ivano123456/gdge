Config = {}

Config.TargetDistance = 2.5

Config.RentVehicleBlip = {
    sprite = 225,
    color = 3,
    scale = 0.85,
    label = 'Rent vozilo',
}
Config.MinRentMinutes = 1
Config.MaxRentMinutes = 60

Config.Vehicles = {
    faggio = { name = 'Motor', model = 'faggio', price = 75, stat = 'Brzo' },
    blista = { name = 'Auto', model = 'blista', price = 125, stat = '4 Sjedala' },
    sanchez = { name = 'Dirt Bike', model = 'sanchez', price = 100, stat = 'Offroad' },
    bati = { name = 'Sport Bike', model = 'bati', price = 150, stat = 'Super Brzo' },
}

Config.WaterVehicles = {
    seashark = { name = 'Jet Ski', model = 'seashark', price = 90, stat = 'Brzo' },
    dinghy = { name = 'Camac', model = 'dinghy', price = 125, stat = '4 mesta' },
    jetmax = { name = 'Speedboat', model = 'jetmax', price = 175, stat = 'Brzo' },
    speeder = { name = 'Motorni brod', model = 'speeder', price = 200, stat = 'Premium' },
}

Config.UiTitles = {
    land = { header = 'RENT CAR', subtitle = 'Renta Car', sidebar = 'Vozila', hud = 'Rent vozila' },
    water = { header = 'RENT BOAT', subtitle = 'Renta Brodova', sidebar = 'Plovila', hud = 'Rent plovila' },
}

Config.ColorMap = {
    red = { r = 230, g = 57, b = 70 },
    orange = { r = 247, g = 127, b = 0 },
    blue = { r = 67, g = 97, b = 238 },
    green = { r = 57, g = 255, b = 20 },
    yellow = { r = 255, g = 190, b = 11 },
    white = { r = 255, g = 255, b = 255 },
    black = { r = 26, g = 26, b = 26 },
}

Config.Locations = {
    -- PD: ped = parking (NPC rent), spawns = spawn kola
    pd = {
        ped = vector4(419.3613, -990.7324, 29.3225, 87.3262), -- PD parking
        pedModel = `s_m_m_autoshop_02`,
        spawns = {
            vector4(407.9149, -988.8893, 28.6594, 51.6370), -- PD kola spawn
        },
        blip = { sprite = 225, color = 2, scale = 0.75, label = 'Rent vozila' },
    },
    -- Ribar: ped = parking, spawns = spawn kola
    ribar = {
        ped = vector4(-1596.9738, -860.8349, 10.1254, 141.1273), -- Ribar parking
        pedModel = `s_m_m_autoshop_02`,
        spawns = {
            vector4(-1602.9045, -867.7897, 9.4105, 138.8842), -- Ribar kola spawn
        },
        blip = { sprite = 225, color = 2, scale = 0.75, label = 'Rent vozila' },
    },
    -- Paleto pumpa: ped = parking, spawns = spawn kola
    paleto_pumpa = {
        ped = vector4(140.8747, 6611.0044, 31.8237, 178.4714), -- Paleto pumpa parking
        pedModel = `s_m_m_autoshop_02`,
        spawns = {
            vector4(140.8508, 6606.3032, 31.2378, 179.4308), -- Paleto pumpa spawn
        },
        blip = { sprite = 225, color = 2, scale = 0.75, label = 'Rent vozila' },
    },
    -- Biro: ped = parking, spawns = spawn kola
    biro = {
        ped = vector4(-245.1955, -992.8926, 29.2890, 246.1119), -- Biro parking
        pedModel = `s_m_m_autoshop_02`,
        spawns = {
            vector4(-238.0851, -989.1989, 28.6042, 340.3033), -- Biro spawn
        },
        blip = { sprite = 225, color = 2, scale = 0.75, label = 'Rent vozila' },
    },
    -- Golf tereni: ped = parking, spawns = spawn kola
    golf_tereni = {
        ped = vector4(-1384.3710, 23.8149, 53.6473, 92.5913), -- Golf tereni parking
        pedModel = `s_m_m_autoshop_02`,
        spawns = {
            vector4(-1387.5004, 27.9011, 52.9839, 133.4824), -- Golf tereni spawn
        },
        blip = { sprite = 225, color = 2, scale = 0.75, label = 'Rent vozila' },
    },
    zatvor = {
        ped = vector4(1852.3551, 2589.7617, 45.6726, 267.3347),
        pedModel = `s_m_m_autoshop_02`,
        spawns = {
            vector4(1869.4381, 2595.2195, 45.0656, 89.7322),
        },
        blip = { sprite = 225, color = 2, scale = 0.75, label = 'Rent vozila' },
    },
    marina_delperro = {
        type = 'water',
        ped = vector4(-1604.64, -1171.45, 1.02, 125.0),
        pedModel = `s_m_y_baywatch_01`,
        spawns = {
            vector4(-1612.04, -1156.12, 0.12, 130.0),
            vector4(-1625.18, -1145.35, 0.10, 125.0),
        },
        blip = { sprite = 410, color = 3, scale = 0.75, label = 'Rent brodova' },
    },
}

function Config.GetLocationType(locId)
    local loc = Config.Locations[locId]
    if loc and loc.type == 'water' then
        return 'water'
    end
    return 'land'
end

function Config.GetVehiclesForLocation(locId)
    if Config.GetLocationType(locId) == 'water' then
        return Config.WaterVehicles
    end
    return Config.Vehicles
end

function Config.GetVehicle(vehicleKey, locId)
    return Config.GetVehiclesForLocation(locId)[vehicleKey]
end

function Config.CalcPrice(vehicleKey, minutes, locId)
    local v = Config.GetVehicle(vehicleKey, locId)
    if not v then return nil end
    minutes = math.max(Config.MinRentMinutes, math.min(Config.MaxRentMinutes, math.floor(tonumber(minutes) or 1)))
    return v.price * minutes, minutes
end
