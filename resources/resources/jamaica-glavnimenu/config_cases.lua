-- giveItemType: "item", "vehicle", "money", "gold"
-- itemType: "common", "uncommon", "rare", "mythical", "legendary"
-- Suma chance po kutiji treba da bude 100

CaseConfig = {}

CaseConfig.PremiumCases = {
    {
        uniqueId = 1, -- IDs must be different and sequential
        label = 'BRZA ISPLATA',
        price = 20,
        priceType = "GC", -- GC OR SC
        caseTheme = "green", -- red, blue, orange, purple, green
        caseType = "premium",
        isNew = false, -- If you set it true, the case will be labeled "new"
        coverImage = "./images/items/money.png",
        items = {
            { itemName = "money", label = "500.000$", chance = 15, sellCredit = 5, itemType = "common", itemCount = 500000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "600.000$", chance = 15, sellCredit = 6, itemType = "common", itemCount = 600000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "700.000$", chance = 15, sellCredit = 7, itemType = "common", itemCount = 700000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.000.000$", chance = 15, sellCredit = 10, itemType = "uncommon", itemCount = 1000000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.250.000$", chance = 10, sellCredit = 11, itemType = "uncommon", itemCount = 1250000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.300.000$", chance = 10, sellCredit = 12, itemType = "uncommon", itemCount = 1300000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.350.000$", chance = 5, sellCredit = 13, itemType = "rare", itemCount = 1350000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.400.000$", chance = 5, sellCredit = 14, itemType = "rare", itemCount = 1400000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.500.000$", chance = 5, sellCredit = 15, itemType = "rare", itemCount = 1500000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.600.000$", chance = 2, sellCredit = 16, itemType = "mythical", itemCount = 1600000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "1.800.000$", chance = 2, sellCredit = 18, itemType = "mythical", itemCount = 1800000, giveItemType = "money", image = "./images/items/money.png" },
            { itemName = "money", label = "2.000.000$", chance = 1, sellCredit = 20, itemType = "legendary", itemCount = 2000000, giveItemType = "money", image = "./images/items/money.png" },
        },
    },
    {
        uniqueId = 2, -- IDs must be different and sequential
        label = 'FATALNA KUTIJA',
        price = 20,
        priceType = "GC", -- GC OR SC
        caseTheme = "orange", -- red, blue, orange, purple, green
        caseType = "premium",
        isNew = false, -- If you set it true, the case will be labeled "new"
        items = {
            { itemName = "armour", label = "PANCIR", chance = 19, sellCredit = 5, itemType = "common", itemCount = 50, giveItemType = "item", image = "./images/items/armor.png" },
            { itemName = "weapon_pistol50", label = "PISTOLJ .50", chance = 11, sellCredit = 10, itemType = "uncommon", itemCount = 5, giveItemType = "item", image = "./images/items/weapon_pistol50.png" },
            { itemName = "weapon_appistol", label = "AP PISTOLJ", chance = 11, sellCredit = 8, itemType = "uncommon", itemCount = 15, giveItemType = "item", image = "./images/items/weapon_appistol.png" },
            { itemName = "weapon_combatpistol", label = "COMBAT PISTOLJ", chance = 11, sellCredit = 7, itemType = "uncommon", itemCount = 20, giveItemType = "item", image = "./images/items/weapon_combatpistol.png" },
            { itemName = "weapon_assaultrifle", label = "ASSAULT RIFLE", chance = 11, sellCredit = 10, itemType = "rare", itemCount = 10, giveItemType = "item", image = "./images/items/WEAPON_ASSAULTRIFLE.png" },
            { itemName = "weapon_compactrifle", label = "COMPACT RIFLE", chance = 11, sellCredit = 10, itemType = "rare", itemCount = 15, giveItemType = "item", image = "./images/items/WEAPON_COMPACTRIFLE.png" },
            { itemName = "weapon_molotov", label = "MOLOTOVLJEV KOKTEL", chance = 11, sellCredit = 13, itemType = "mythical", itemCount = 15, giveItemType = "item", image = "./images/items/weapon_molotov.png" },
            { itemName = "weapon_tacticalrifle", label = "TACTICAL RIFLE", chance = 10, sellCredit = 15, itemType = "legendary", itemCount = 7, giveItemType = "item", image = "./images/items/weapon_tacticalrifle.png" },
            { itemName = "weapon_sniperrifle", label = "SNAJPER", chance = 5, sellCredit = 20, itemType = "legendary", itemCount = 1, giveItemType = "item", image = "./images/items/weapon_sniperrifle.png" },
        },
    },
    {
        uniqueId = 3, -- IDs must be different and sequential
        label = 'ADRENALIN KUTIJA',
        price = 50,
        priceType = "GC", -- GC OR SC
        caseTheme = "purple", -- red, blue, orange, purple, green
        caseType = "premium",
        isNew = false, -- If you set it true, the case will be labeled "new"
        items = {
            { itemName = "e63s", label = "E63S", chance = 14, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/e63s.png" },
            { itemName = "bmw8mm", label = "BMW 8M", chance = 11, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/bmw8mm.png" },
            { itemName = "manhartx7", label = "MANHART X7", chance = 10, sellCredit = 10, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/manhartx7.png" },
            { itemName = "hycadeurus", label = "URUS", chance = 10, sellCredit = 10, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/hycadeurus.png" },
            { itemName = "top91121", label = "TOP 911", chance = 8, sellCredit = 15, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/top91121.png" },
            { itemName = "rs6s", label = "AUDI RS6", chance = 8, sellCredit = 15, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/rs6s.png" },
            { itemName = "huracanpriorbeast", label = "Huracan PRIOR BEAST", chance = 8, sellCredit = 15, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/huracanpriorbeast.png" },
            { itemName = "19McLaren600V2", label = "McLaren 600V2", chance = 8, sellCredit = 20, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/19McLaren600V2.png" },
            { itemName = "g700brabusretuned", label = "G700 BRABUS", chance = 8, sellCredit = 20, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/g700brabusretuned.png" },
            { itemName = "TTSTO", label = "TT STO", chance = 5, sellCredit = 35, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/TTSTO.png" },
            { itemName = "fsf90xx", label = "FS F90X", chance = 5, sellCredit = 35, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/fsf90xx.png" },
            { itemName = "2019chiron", label = "Chiron 2019", chance = 4, sellCredit = 40, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/2019chiron.png" },
        },
    },
    {
        uniqueId = 4, -- IDs must be different and sequential
        label = 'PREKRETNICA KUTIJA',
        price = 30,
        priceType = "GC", -- GC OR SC
        caseTheme = "red", -- red, blue, orange, purple, green
        caseType = "premium",
        isNew = false, -- If you set it true, the case will be labeled "new"
        items = {
            { itemName = "AmgGtrLight", label = "AMG GTR EVO", chance = 10, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/AmgGtrLight.png" },
            { itemName = "mk4hycade", label = "MK4 HYCADE", chance = 10, sellCredit = 5, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/mk4hycade.png" },
            { itemName = "fenyrsupersport", label = "FENYR SUPERSPORT", chance = 10, sellCredit = 7, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/fenyrsupersport.png" },
            { itemName = "gta5rp_veh_ferrari19", label = "FERRARI 19", chance = 10, sellCredit = 7, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/gta5rp_veh_ferrari19.png" },
            { itemName = "gx570s", label = "GX 570S", chance = 10, sellCredit = 8, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/gx570s.png" },
            { itemName = "DL_G900", label = "G900", chance = 10, sellCredit = 8, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/DL_G900.png" },
            { itemName = "amrevu23mg", label = "LAMBORGHINI REVUELTO", chance = 10, sellCredit = 10, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/amrevu23mg.png" },
            { itemName = "autobio", label = "RANGE ROVER 2017", chance = 10, sellCredit = 10, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/autobio.png" },
            { itemName = "ikx3abt20", label = "AUDI ABT RS7", chance = 10, sellCredit = 10, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/ikx3abt20.png" },
            { itemName = "r8beastedit", label = "AUDI R8 BEAST", chance = 10, sellCredit = 11, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/r8beastedit.png" },
        },
    },
    {
        uniqueId = 6,
        label = 'BMW KUTIJA',
        price = 30,
        priceType = "GC",
        caseTheme = "blue",
        caseType = "premium",
        isNew = false,
        coverImage = "./images/items/manhartx7.png",
        items = {
            { itemName = "760lig12f", label = "BMW 760Li", chance = 13, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/760lig12f.png" },
            { itemName = "2019m5", label = "BMW M5 2019", chance = 13, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/2019m5.png" },
            { itemName = "bmw8mm", label = "BMW 8M", chance = 13, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/bmw8mm.png" },
            { itemName = "hycm5cs", label = "BMW M5 CS Hycade", chance = 13, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/hycm5cs.png" },
            { itemName = "bmwm5f90v2wb", label = "BMW M5 F90", chance = 12, sellCredit = 15, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/bmwm5f90v2wb.png" },
            { itemName = "m850prior", label = "BMW M850 Prior", chance = 12, sellCredit = 15, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/m850prior.png" },
            { itemName = "m3csg80complain", label = "BMW M3 CS G80", chance = 12, sellCredit = 20, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/m3csg80complain.png" },
            { itemName = "manhartx7", label = "Manhart X7", chance = 12, sellCredit = 35, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/manhartx7.png" },
        },
    },
    {
        uniqueId = 7,
        label = 'LAMBO KUTIJA',
        price = 50,
        priceType = "GC",
        caseTheme = "orange",
        caseType = "premium",
        isNew = true,
        coverImage = "./images/items/huracanpriorbeast.png",
        items = {
            { itemName = "huracanpriorbeast", label = "Huracan Prior Beast", chance = 18, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/huracanpriorbeast.png" },
            { itemName = "1016rwdevo", label = "1016 RWD EVO", chance = 18, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/1016rwdevo.png" },
            { itemName = "urushyc", label = "Urus Hycade", chance = 17, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/urushyc.png" },
            { itemName = "gcmlamboultimae", label = "GCM Lambo Ultimae", chance = 17, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/gcmlamboultimae.png" },
            { itemName = "godzzacoeevo", label = "Zaco EVO", chance = 15, sellCredit = 15, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/godzzacoeevo.png" },
            { itemName = "TTSTO", label = "TT STO", chance = 15, sellCredit = 35, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/ttsto.png" },
        },
    },
    {
        uniqueId = 8,
        label = 'MERCEDES KUTIJA',
        price = 30,
        priceType = "GC",
        caseTheme = "green",
        caseType = "premium",
        isNew = true,
        coverImage = "./images/items/godzvips63amg.png",
        items = {
            { itemName = "cls19", label = "CLS 19", chance = 13, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/cls19.png" },
            { itemName = "amggtbs", label = "AMG GT Black Series", chance = 13, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/amggtbs.png" },
            { itemName = "AmgGtrLight", label = "AMG GTR Light", chance = 13, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "vehicle", image = "./images/items/amggtrlight.png" },
            { itemName = "DL_G900", label = "G900 Brabus", chance = 13, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/dl_g900.png" },
            { itemName = "gls63dy", label = "GLS 63", chance = 12, sellCredit = 8, itemType = "uncommon", itemCount = 1, giveItemType = "vehicle", image = "./images/items/gls63dy.png" },
            { itemName = "dc_sl63mansory", label = "SL63 Mansory", chance = 12, sellCredit = 15, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/dc_sl63mansory.png" },
            { itemName = "godzvips63amg", label = "S63 AMG VIP", chance = 12, sellCredit = 20, itemType = "mythical", itemCount = 1, giveItemType = "vehicle", image = "./images/items/godzvips63amg.png" },
            { itemName = "amrevu23mg", label = "Revuelto", chance = 12, sellCredit = 35, itemType = "legendary", itemCount = 1, giveItemType = "vehicle", image = "./images/items/amrevu23mg.png" },
        },
    },
}

CaseConfig.StandardCases = {
    {
        uniqueId = 1,
        label = "Standard Kutija",
        price = 30,
        priceType = "SC", -- GC OR SC
        caseTheme = "nude",
        isNew = true, -- If you set it true, the case will be labeled "new"
        items = {
            { itemName = "phone", label = "Telefon", chance = 10, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "item", image = "./images/items/phone.png" },
            { itemName = "armour", label = "Pancir", chance = 10, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "item", image = "./images/items/armor.png" },
            { itemName = "weapon_pistol", label = "Pistolj", chance = 10, sellCredit = 5, itemType = "common", itemCount = 1, giveItemType = "item", image = "./images/items/WEAPON_PISTOL.png" },
            { itemName = "cocaine", label = "100x Koks", chance = 10, sellCredit = 5, itemType = "common", itemCount = 100, giveItemType = "item", image = "./images/items/cocaine.png" },
            { itemName = "money", label = "20.000$", chance = 10, sellCredit = 5, itemType = "common", itemCount = 20000, giveItemType = "item", image = "./images/items/money.png" },
            { itemName = "money", label = "50.000$", chance = 10, sellCredit = 5, itemType = "common", itemCount = 50000, giveItemType = "item", image = "./images/items/money.png" },
            { itemName = "money", label = "100.000$", chance = 8, sellCredit = 8, itemType = "uncommon", itemCount = 100000, giveItemType = "item", image = "./images/items/money.png" },
            { itemName = "weapon_smg", label = "SMG", chance = 9, sellCredit = 6, itemType = "uncommon", itemCount = 1, giveItemType = "item", image = "./images/items/WEAPON_SMG.png" },
            { itemName = "sultan", label = "Sultan", chance = 4, sellCredit = 10, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/sultan.png" },
            { itemName = "weapon_carbinerifle", label = "Karabin", chance = 4, sellCredit = 8, itemType = "rare", itemCount = 1, giveItemType = "item", image = "./images/items/WEAPON_CARBINERIFLE.png" },
            { itemName = "gc", label = "10 GC", chance = 1, sellCredit = 8, itemType = "legendary", itemCount = 10, giveItemType = "gold", image = "./images/items/coin.svg" },
            { itemName = "selfrevive", label = "2x Self", chance = 10, sellCredit = 5, itemType = "common", itemCount = 2, giveItemType = "item", image = "./images/items/selfrevive.png" },
            { itemName = "selfrevive", label = "10x Self", chance = 4, sellCredit = 10, itemType = "rare", itemCount = 10, giveItemType = "item", image = "./images/items/selfrevive.png" },
        },
    },
    {
        uniqueId = 2,
        label = "Standard Kutija 2",
        price = 80,
        priceType = "SC", -- GC OR SC
        caseTheme = "nude",
        isNew = true, -- If you set it true, the case will be labeled "new"
        items = {
            { itemName = "weapon_appistol", label = "AP Pistolj", chance = 14, sellCredit = 6, itemType = "common", itemCount = 1, giveItemType = "item", image = "./images/items/weapon_appistol.png" },
            { itemName = "gc", label = "10 GC", chance = 0.5, sellCredit = 8, itemType = "legendary", itemCount = 10, giveItemType = "gold", image = "./images/items/coin.svg" },
            { itemName = "gc", label = "5 GC", chance = 0.5, sellCredit = 4, itemType = "mythical", itemCount = 5, giveItemType = "gold", image = "./images/items/coin.svg" },
            { itemName = "armour", label = "10x Pancir", chance = 14, sellCredit = 6, itemType = "common", itemCount = 10, giveItemType = "item", image = "./images/items/armor.png" },
            { itemName = "weapon_assaultrifle", label = "Kalas", chance = 14, sellCredit = 10, itemType = "uncommon", itemCount = 1, giveItemType = "item", image = "./images/items/WEAPON_ASSAULTRIFLE.png" },
            { itemName = "money", label = "100.000$", chance = 14, sellCredit = 8, itemType = "common", itemCount = 100000, giveItemType = "item", image = "./images/items/money.png" },
            { itemName = "gc", label = "2 GC", chance = 1, sellCredit = 2, itemType = "rare", itemCount = 2, giveItemType = "gold", image = "./images/items/coin.svg" },
            { itemName = "r1", label = "Yamaha R1", chance = 14, sellCredit = 12, itemType = "rare", itemCount = 1, giveItemType = "vehicle", image = "./images/items/r1.png" },
            { itemName = "black_money", label = "200.000$ Prljavih", chance = 14, sellCredit = 10, itemType = "rare", itemCount = 200000, giveItemType = "item", image = "./images/items/black_money.png" },
            { itemName = "joint", label = "20x Joint", chance = 14, sellCredit = 5, itemType = "common", itemCount = 20, giveItemType = "item", image = "./images/items/joint.png" },
        },
    },
}

