Config = {}

Config.TargetDistance = 2.0
Config.CraftDistance = 3.0

-- job = 'all' → svi mogu; inače tačan ESX job name (npr. 'ballas')
-- minGrade na lokaciji → minimalni grade da uopšte otvori meni
-- Po itemu (items / moneyItems):
--   minGrade = 3        → vidi samo grade >= 3
--   grades = {3, 4, 5}  → vidi samo navedene gradeove (ima prioritet nad minGrade)
Config.Locations = {
    {
        id = 'sandy_crafting_oruzja',
        label = 'Crafting oružja',
        coords = vector4(1536.5037, 3593.6746, 38.7665, 31.6794),
        prop = 'gr_prop_gr_bench_02a',
        job = 'all',
        items = {
            {
                label = 'Rifle Ammo',
                item = 'ammo-rifle',
                count = 30,
                duration = 30,
                ingredients = {
                    { name = 'prazna_cahura', label = 'Prazna čahura', count = 10 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 4 },
                    { name = 'barut', label = 'Barut', count = 3 },
                    { name = 'coal_ore', label = 'Ugljena ruda', count = 1 },
                },
            },
            {
                label = 'Rifle Ammo MK2',
                item = 'ammo-rifle2',
                count = 30,
                duration = 40,
                ingredients = {
                    { name = 'prazna_cahura', label = 'Prazna čahura', count = 10 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 5 },
                    { name = 'barut', label = 'Barut', count = 5 },
                    { name = 'sulfur_chunk', label = 'Komad sumpora', count = 2 },
                    { name = 'graphite_chunk', label = 'Komad grafita', count = 1 },
                },
            },
            {
                label = 'Pancir',
                item = 'armour',
                count = 1,
                duration = 45,
                ingredients = {
                    { name = 'guma', label = 'Guma', count = 3 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 5 },
                    { name = 'balisticno_platno', label = 'Balističko platno', count = 2 },
                    { name = 'plastika', label = 'Plastika', count = 10 },
                },
            },
            {
                label = 'MINI SMG',
                item = 'WEAPON_MINISMG',
                count = 1,
                duration = 50,
                ingredients = {
                    { name = 'weapon_parts', label = 'Delovi za oružje', count = 2 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 6 },
                    { name = 'celicni_ostaci', label = 'Čelični ostaci', count = 30 },
                    { name = 'srafovi', label = 'Šrafovi', count = 4 },
                    { name = 'opruga', label = 'Opruga', count = 2 },
                    { name = 'plastika', label = 'Plastika', count = 50 },
                    { name = 'guma', label = 'Guma', count = 2 },
                },
            },
            {
                label = 'SMG',
                item = 'WEAPON_SMG',
                count = 1,
                duration = 65,
                ingredients = {
                    { name = 'weapon_parts', label = 'Delovi za oružje', count = 3 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 8 },
                    { name = 'celicni_ostaci', label = 'Čelični ostaci', count = 30 },
                    { name = 'srafovi', label = 'Šrafovi', count = 5 },
                    { name = 'opruga', label = 'Opruga', count = 2 },
                    { name = 'plastika', label = 'Plastika', count = 30 },
                    { name = 'bakar_zica', label = 'Bakar žica', count = 3 },
                    { name = 'elektronski_otpad', label = 'Elektronski otpad', count = 2 },
                },
            },
            {
                label = 'CARBINE RIFLE',
                item = 'WEAPON_CARBINERIFLE',
                count = 1,
                duration = 80,
                ingredients = {
                    { name = 'weapon_parts', label = 'Delovi za oružje', count = 4 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 10 },
                    { name = 'celicni_ostaci', label = 'Čelični ostaci', count = 60 },
                    { name = 'srafovi', label = 'Šrafovi', count = 6 },
                    { name = 'opruga', label = 'Opruga', count = 3 },
                    { name = 'plastika', label = 'Plastika', count = 80 },
                    { name = 'bakar_zica', label = 'Bakar žica', count = 2 },
                    { name = 'graphite_chunk', label = 'Komad grafita', count = 2 },
                    { name = 'quartz_crystal', label = 'Kvarcni kristal', count = 1 },
                },
            },
            {
                label = 'ASSAULT RIFLE',
                item = 'WEAPON_ASSAULTRIFLE',
                count = 1,
                duration = 90,
                ingredients = {
                    { name = 'weapon_parts', label = 'Delovi za oružje', count = 5 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 12 },
                    { name = 'celicni_ostaci', label = 'Čelični ostaci', count = 45 },
                    { name = 'srafovi', label = 'Šrafovi', count = 6 },
                    { name = 'opruga', label = 'Opruga', count = 3 },
                    { name = 'plastika', label = 'Plastika', count = 60 },
                    { name = 'bakar_zica', label = 'Bakar žica', count = 3 },
                    { name = 'elektronski_otpad', label = 'Elektronski otpad', count = 2 },
                    { name = 'corundum_chunk', label = 'Komad korunda', count = 2 },
                    { name = 'graphite_chunk', label = 'Komad grafita', count = 2 },
                    { name = 'coal_ore', label = 'Ugljena ruda', count = 2 },
                },
            },
            {
                label = 'SPECIAL CARBINE',
                item = 'WEAPON_SPECIALCARBINE',
                count = 1,
                duration = 100,
                ingredients = {
                    { name = 'weapon_parts', label = 'Delovi za oružje', count = 6 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 14 },
                    { name = 'celicni_ostaci', label = 'Čelični ostaci', count = 60 },
                    { name = 'srafovi', label = 'Šrafovi', count = 6 },
                    { name = 'opruga', label = 'Opruga', count = 3 },
                    { name = 'plastika', label = 'Plastika', count = 80 },
                    { name = 'bakar_zica', label = 'Bakar žica', count = 3 },
                    { name = 'elektronski_otpad', label = 'Elektronski otpad', count = 2 },
                    { name = 'diamond_crystal', label = 'Dijamantski kristal', count = 1 },
                    { name = 'corundum_chunk', label = 'Komad korunda', count = 2 },
                    { name = 'graphite_chunk', label = 'Komad grafita', count = 2 },
                    { name = 'sulfur_chunk', label = 'Komad sumpora', count = 2 },
                },
            },
        },
    },
    {
        id = 'autoumro_oruzarnica',
        label = 'Auto Umro | Oruzarnica',
        coords = vector4(1079.6647, -921.2202, 51.9821, 155.5516),
        prop = '',
        job = 'autoumro',
        minGrade = 3,
        items = {
            {
                label = 'Rifle Ammo',
                item = 'ammo-rifle',
                count = 30,
                duration = 30,
                ingredients = {
                    { name = 'prazna_cahura', label = 'Prazna čahura', count = 10 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 4 },
                    { name = 'barut', label = 'Barut', count = 3 },
                    { name = 'coal_ore', label = 'Ugljena ruda', count = 1 },
                },
            },
            {
                label = 'AUG MEDUSA',
                item = 'WEAPON_AUG_MEDUSA',
                count = 1,
                duration = 45,
                ingredients = {
                    { name = 'weapon_parts', label = 'Delovi za oružje', count = 2 },
                    { name = 'scrap_metal', label = 'Metalni otpad', count = 5 },
                    { name = 'celicni_ostaci', label = 'Čelični ostaci', count = 40 },
                    { name = 'srafovi', label = 'Šrafovi', count = 6 },
                    { name = 'opruga', label = 'Opruga', count = 2 },
                    { name = 'plastika', label = 'Plastika', count = 60 },
                    { name = 'money', label = 'Novac', count = 20000 },
                },
            },
        },
    },
    {
        id = 'autofuseraj_chipovi',
        label = 'Auto Fuseraj | Chipovi',
        coords = vector4(-341.0394, -1332.9092, 31.4548, 351.3542),
        prop = '',
        job = 'autofuseraj',
        moneyItems = {
            { label = 'Tuner Chip 1', item = 'tunerchip1', count = 1, price = 30000, minGrade = 3 },
            { label = 'Tuner Chip 2', item = 'tunerchip2', count = 1, price = 50000, minGrade = 3 },
            { label = 'Tuner Chip 3', item = 'tunerchip3', count = 1, price = 80000, minGrade = 3 },
            { label = 'Chip Remover', item = 'tunerchipr', count = 1, price = 10000, minGrade = 3 },
        },
    },
    {
        id = 'fleeca_oprema',
        label = 'Crno trziste | Fleeca oprema',
        coords = vector4(156.9187, 3131.8760, 43.5841, 17.2679),
        prop = 'gr_prop_gr_bench_02a',
        job = 'all',
        moneyItems = {
            { label = 'Fleeca kartica', item = 'fleecacard', count = 1, price = 75000 },
            { label = 'Hakerski uredjaj', item = 'x_device', count = 1, price = 50000 },
            { label = 'Hakerski laptop', item = 'x_laptop', count = 1, price = 60000 },
            { label = 'Klesta', item = 'pliers', count = 1, price = 5000 },
            { label = 'Torba za pljacku', item = 'bag', count = 1, price = 8000 },
        },
    },
    {
        id = 'vangelico_oprema',
        label = 'Crno trziste | Vangelico oprema',
        coords = vector4(456.9050, 5571.6538, 781.1835, 270.8123),
        prop = 'gr_prop_gr_bench_02a',
        job = 'all',
        moneyItems = {
            { label = 'Torba za pljacku', item = 'bag', count = 1, price = 8000 },
            { label = 'Hakerski uredjaj', item = 'x_device', count = 1, price = 50000 },
            { label = 'Rezac stakla', item = 'glass_cutter', count = 1, price = 12000 },
            { label = 'Tester strujnih kola', item = 'x_circuittester', count = 1, price = 35000 },
            { label = 'Traka za otiske', item = 'x_fingerprinttape', count = 1, price = 15000 },
            { label = 'Kesica za otiske', item = 'x_fingerprintbag', count = 1, price = 12000 },
            { label = 'Termit', item = 'thermite', count = 1, price = 25000 },
            { label = 'MXC kljuc', item = 'mxckey', count = 1, price = 85000 },
        },
    },
}

-- Otkupljivac pljacke zlatare (puna pljacka ~500k black_money)
Config.SellLocations = {
    {
        id = 'vangelico_otkupljivac',
        label = 'Otkupljivac nakita',
        coords = vector4(705.9120, -966.9844, 30.4128, 321.3333),
        ped = 's_m_y_dealer_01',
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        distance = 2.5,
        moneyItem = 'black_money',
        items = {
            -- VIP izlozi (~132k)
            { label = 'Panterski dragulj', item = 'x_panther_gem', price = 40000 },
            { label = 'Veliki dragulj', item = 'giant_gem', price = 32000 },
            { label = 'Veliki zeleni dragulj', item = 'giant_gem_green', price = 32000 },
            { label = 'Draguljska ogrlica', item = 'gem_necklace', price = 28000 },

            -- Kutije i dijamanti (~130k)
            { label = 'Kutija nakita', item = 'box_of_jewelry', price = 10000 },
            { label = 'Dijamant', item = 'diamond', price = 7500 },

            -- Ogrlice (~160k za ~32 kom)
            { label = 'Dijamantska ogrlica', item = 'diamond_necklace', price = 5500 },
            { label = 'Rubinska ogrlica', item = 'ruby_necklace', price = 5000 },
            { label = 'Safirna ogrlica', item = 'sapphire_necklace', price = 5000 },
            { label = 'Smaragdna ogrlica', item = 'emerald_necklace', price = 4500 },

            -- Prstenje (~84k za ~30 kom)
            { label = 'Dijamantski prsten', item = 'diamond_ring', price = 3500 },
            { label = 'Rubinski prsten', item = 'ruby_ring', price = 3000 },
            { label = 'Safirni prsten', item = 'sapphire_ring', price = 3000 },
            { label = 'Smaragdni prsten', item = 'emerald_ring', price = 2800 },

            -- Mindjuse (~78k za ~30 kom)
            { label = 'Dijamantske mindjuse', item = 'diamond_earring', price = 3200 },
            { label = 'Rubinske mindjuse', item = 'ruby_earring', price = 2800 },
            { label = 'Safirne mindjuse', item = 'sapphire_earring', price = 2800 },
            { label = 'Smaragdne mindjuse', item = 'emerald_earring', price = 2600 },
        },
    },
}
