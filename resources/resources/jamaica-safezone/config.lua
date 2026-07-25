Config = {}

Config.Debug = false

Config.Notify = true
Config.NotifyEnter = 'Ušli ste u safe zonu.'
Config.NotifyExit = 'Izašli ste iz safe zone.'

Config.FreezeNeeds = true

Config.BlockJobMenu = true
Config.BlockJobMenuMessage = 'Ne mozete koristiti F6 u safe zoni.'

Config.CombatControls = {
    24, 25, 47, 58, 69, 70, 92,
    140, 141, 142, 167, 257, 263, 264,
}

Config.Zones = {
    {
        name = 'bolnica',
        type = 'sphere',
        coords = vec3(-813.6456, -1231.8682, 6.7260),
        radius = 90.0,
    },
    {
        name = 'legion',
        type = 'sphere',
        coords = vec3(215.88, -809.86, 30.73),
        radius = 110.0,
    },
    {
        name = 'pillbox_garaza',
        type = 'sphere',
        coords = vec3(275.58, -343.97, 44.92),
        radius = 55.0,
    },
    {
        name = 'pilicar_farma',
        type = 'sphere',
        coords = vec3(-573.0, 5342.0, 70.21),
        radius = 60.0,
    },
    {
        name = 'pilicar_prodaja',
        type = 'sphere',
        coords = vec3(-802.47, 5390.19, 34.52),
        radius = 45.0,
    },
    {
        name = 'pizzajob',
        type = 'sphere',
        coords = vec3(537.0, 98.0, 96.0),
        radius = 50.0,
    },
    {
        name = 'kamioni',
        type = 'sphere',
        coords = vec3(865.0, -920.0, 26.0),
        radius = 65.0,
    },
    {
        name = 'kosac',
        type = 'sphere',
        coords = vec3(-1343.99, 135.41, 56.0),
        radius = 55.0,
    },
    {
        name = 'cayo',
        type = 'sphere',
        coords = vec3(3049.8635, -4698.2500, 15.2616),
        radius = 65.0,
    },
}
