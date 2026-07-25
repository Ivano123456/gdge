Config = {}

Config.AdminCommand = 'prodavnicaadmin'
Config.AdminGroups = {
    ['vlasnik'] = true,
    ['suvlasnik'] = true,
}

Config.OwnerBankSharePercent = 70
Config.RestockCostPercent = 50
Config.DefaultStock = 50
Config.MaxStock = 200
Config.KesCacheSeconds = 60

-- Trajanje vlasništva kad se dodeli preko /prodavnicaadmin (zatim mora produženje)
Config.LeaseDays = 30
Config.LeaseCheckIntervalMinutes = 5

-- Fiksna zarada: vlasnik se prikazuje, nema stock/restock, isplata na banku svakih N minuta
Config.FixedIncomeIntervalMinutes = 60

Config.Categories = {
    { id = 'sve', label = 'SVE' },
    { id = 'alati', label = 'ALATI' },
    { id = 'ostalo', label = 'OSTALO' },
}

Config.Shopovi = {
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(26.3137, -1346.8999, 29.4969),
        ['ownerMarker'] = vec3(25.9736, -1351.5778, 29.3332),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(-48.3379, -1757.8835, 29.4210),
        ['ownerMarker'] = vec3(-50.8413, -1760.6851, 29.1750),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(1135.6553, -981.8629, 46.4158),
        ['ownerMarker'] = vec3(1142.4979, -978.6328, 46.3102),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(1163.5841, -323.6811, 69.2050),
        ['ownerMarker'] = vec3(1163.6847, -327.8374, 69.0648),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(374.3239, 326.3814, 103.5662),
        ['ownerMarker'] = vec3(373.5139, 323.0926, 103.4928),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(-1486.9279, -379.2755, 40.1634),
        ['ownerMarker'] = vec3(-1490.5181, -386.4654, 39.6496),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(-1222.5894, -906.9745, 12.3263),
        ['ownerMarker'] = vec3(-1224.2511, -899.8525, 12.3912),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(-707.4130, -914.3082, 19.2156),
        ['ownerMarker'] = vec3(-707.1893, -918.5199, 19.0139),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(1961.3966, 3741.1995, 32.3436),
        ['ownerMarker'] = vec3(1962.5966, 3741.1995, 32.3436),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Market 24/7', 
        ['coords'] = vec3(-3242.3953, 1001.7701, 12.8306),
        ['ownerMarker'] = vec3(1968.9932, 3740.7085, 32.3422),
        ['blip'] = {
            aktiviraj = true, 
            sprite = 52,
            scale = 0.6, 
            color = 2, 
            text = 'Market 24/7'
        },
        ['items'] = {
            { label = 'Outfit Torba', item = 'outfit_bag', price = 1000, category = 'alati' },
            { label = 'Telefon', item = 'phone', price = 1000, category = 'alati' },
            { label = 'Motorola', item = 'radio', price = 500, category = 'alati' },
            { label = 'Dvogled', item = 'binoculars', price = 150, category = 'alati' },
            { label = 'Alat za popravku', item = 'repairkit', price = 2500, category = 'alati' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
            { label = 'Race Chip', item = 'racechip', price = 500, category = 'alati' },
            { label = 'Vatromet', item = 'vatromet', price = 500, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 50, category = 'ostalo' },
            { label = 'Rizla', item = 'rizla', price = 2, category = 'ostalo' },
            { label = 'Grebalica', item = 'srecka', price = 100, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'Bolnicka Kafeterija', 
        ['coords'] = vec3(85.2583, -396.1293, 39.3781),
        ['ownerMarker'] = vec3(-3238.0166, 1007.7242, 12.3824),
        ['blip'] = {
            aktiviraj = false, 
            sprite = 52,
            scale = 0.6, 
            color = 6, 
            text = 'Kafeterija Bolnica'
        },
        ['items'] = {
            { label = 'Smoki', item = 'smoki', price = 2, category = 'ostalo' },
            { label = 'Voda', item = 'water', price = 1, category = 'ostalo' },
            { label = 'Marlboro', item = 'marlboro', price = 5, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 3, category = 'ostalo' },
        },
    },
    { 
        ['label'] = 'PD Kuhinja', 
        ['coords'] = vec3(612.3361, -19.6608, 87.8021),
        ['ownerMarker'] = vec3(613.5361, -19.6608, 87.8021),
        ['blip'] = {
            aktiviraj = false, 
            sprite = 52,
            scale = 0.6, 
            color = 6, 
            text = 'Kafeterija Policijske Uprave'
        },
        ['items'] = {
            { label = 'Smoki', item = 'smoki', price = 2, category = 'ostalo' },
            { label = 'Voda', item = 'water', price = 1, category = 'ostalo' },
            { label = 'Marlboro', item = 'marlboro', price = 5, category = 'ostalo' },
            { label = 'Upaljač', item = 'upaljac', price = 3, category = 'ostalo' },
            { label = 'Boombox', item = 'boombox', price = 1000, category = 'alati' },
        },
    }
}
