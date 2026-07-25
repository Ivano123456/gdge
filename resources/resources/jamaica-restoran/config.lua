Config = {}

Config.AdminCommand = 'restoranadmin'
Config.AdminGroups = {
    ['vlasnik'] = true,
    ['suvlasnik'] = true,
}

Config.ImagePath = 'nui://ox_inventory/web/images/%s.png'

Config.DefaultPedModel = 's_m_y_barman_01'

Config.Categories = {
    { id = 'hrana', label = 'HRANA' },
    { id = 'pice', label = 'PIĆE' },
}

Config.CategoryLabels = {
    hrana = 'Hrana',
    pice = 'Piće',
}

Config.InteractDistance = 2.0
Config.PedSpawnDistance = 50.0
Config.BlipShortRange = false

Config.BuyCooldownMs = 400
Config.RestockCooldownMs = 300
Config.MaxStock = 200

Config.DefaultBlip = {
    enabled = true,
    sprite = 93,
    color = 1,
    scale = 0.7,
}

Config.DefaultCraftDuration = {
    hrana = 6,
    pice = 4,
}

Config.DefaultCraftAnim = {
    hrana = { dict = 'amb@prop_human_bbq@male@idle_a', clip = 'idle_b', flag = 49 },
    pice = { dict = 'anim@amb@clubhouse@bar@drink@idle_a', clip = 'idle_a_bartender', flag = 49 },
}

Config.CraftCooldownMs = 500

-- false = priprema artikala iz ponude restorana (anim + progress, bez sastojaka)
-- true  = klasični recepti iz admin menija (jamaica_restoran_craft)
Config.UseCraftRecipes = false
