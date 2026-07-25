Config = {}

Config.TargetDistance = 2.5
Config.LicenseKey = 'oruzje'
Config.PurchaseCooldownMs = 2000

Config.Categories = {
    { id = 'all', name = 'Sve', icon = 'grid' },
    { id = 'oruzje', name = 'Vatreno oružje', icon = 'gun' },
    { id = 'municija', name = 'Municija', icon = 'ammo' },
    { id = 'hladno', name = 'Hladno oružje', icon = 'melee' },
}

Config.Items = {
    {
        id = 'weapon_pistol',
        item = 'weapon_pistol',
        label = 'Pistol',
        description = 'Standardni 9mm pistol. Pouzdan, kompaktan i legalan uz važeću dozvolu.',
        category = 'oruzje',
        price = 28500,
        maxQty = 1,
        requiresLicense = true,
        stats = { damage = 'Srednja', range = 'Bliska', control = 'Laka' },
    },
    {
        id = 'ammo_9',
        item = 'ammo-9',
        label = '9mm Municija',
        description = 'Paket od 30 komada 9mm patrona. Kompatibilno sa pistolima kalibra 9mm.',
        category = 'municija',
        price = 450,
        maxQty = 10,
        qtyStep = 30,
        requiresLicense = false,
        stats = { kalibar = '9mm', paket = '30 kom' },
    },
    {
        id = 'weapon_bat',
        item = 'weapon_bat',
        label = 'Bejzbol palica',
        description = 'Aluminijumska palica. Brzo rešenje kad razgovor ne uspe.',
        category = 'hladno',
        price = 6000,
        maxQty = 1,
        requiresLicense = false,
        stats = { damage = 'Visoka', range = 'Bliska', control = 'Teška' },
    },
    {
        id = 'weapon_knife',
        item = 'weapon_knife',
        label = 'Nož',
        description = 'Oštar nož za svakodnevnu upotrebu. Diskretan i efikasan.',
        category = 'hladno',
        price = 8000,
        maxQty = 1,
        requiresLicense = false,
        stats = { damage = 'Visoka', range = 'Kontakt', control = 'Precizna' },
    },
}

Config.Shops = {
    legion = {
        label = 'Oružarnica',
        ped = vector4(22.56, -1105.52, 29.80, 157.0),
        pedModel = `s_m_y_ammucity_01`,
        blip = { sprite = 110, color = 2, scale = 0.75, label = 'Oružarnica' },
    },
    vinewood = {
        label = 'Oružarnica',
        ped = vector4(252.89, -50.00, 69.94, 70.0),
        pedModel = `s_m_y_ammucity_01`,
        blip = { sprite = 110, color = 2, scale = 0.75, label = 'Oružarnica' },
    },
    la_mesa = {
        label = 'Oružarnica',
        ped = vector4(842.34, -1033.22, 28.19, 0.0),
        pedModel = `s_m_y_ammucity_01`,
        blip = { sprite = 110, color = 2, scale = 0.75, label = 'Oružarnica' },
    },
    paleto = {
        label = 'Oružarnica',
        ped = vector4(-330.24, 6083.88, 31.45, 225.0),
        pedModel = `s_m_m_ammucountry`,
        blip = { sprite = 110, color = 2, scale = 0.75, label = 'Oružarnica' },
    },
}
