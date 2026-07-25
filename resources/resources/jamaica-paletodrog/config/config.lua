Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {}

Config.FarmKey = 'E'
Config.InteractionDistance = 2.0
Config.CollectionTime = 4000
Config.MaxPlayerHeightAboveGround = 30.0

Config.AnimDict = 'anim@mp_snowball'
Config.AnimClip = 'pickup_snowball'

Config.MinGangBonus = 3

Config.BlockedJobs = {
    ['police']   = true,
    ['noose']    = true,
    ['bia']      = true,
    ['fib']      = true,
    ['kgb']      = true,
    ['saj']      = true,
    ['sheriff']  = true,
    ['sheriffp'] = true,
    ['sud']      = true,
    ['cia']      = true,
}

Config.Items = {
    weed = {
        itemname = 'cannabis',
        prop = 'prop_weed_01',
        amount = 1,
        respawnTime = 60,
        label = 'WEED_FARM',
        progressLabel = 'WEED_PROG',
    },

    cocaine = {
        itemname = 'cocaine_list',
        prop = 'prop_plant_cane_02b',
        amount = 1,
        respawnTime = 45,
        label = 'COKE_FARM',
        progressLabel = 'COKE_PROG',
    },

    meth = {
        itemname = 'meth',
        prop = 'prop_barrel_exp_01a',
        amount = 1,
        respawnTime = 20,
        label = 'METH_FARM',
        progressLabel = 'METH_PROG',
    },
}

Config.CircleZones = {

    WeedField = {
        drugType = 'weed',
        coords = vector3(865.6448, 3330.9124, 42.1004),
        radius = 50.0,
        spawnRadius = 25.0,
        propCount = 14,
    },

    CocainaField = {
        drugType = 'cocaine',
        coords = vector3(4828.6582, -5769.6509, 34.7910),
        radius = 50.0,
        spawnRadius = 25.0,
        propCount = 11,
    },

    ChemicalsField = {
        drugType = 'meth',
        coords = vector3(-112.262, 6461.328, 31.469),
        radius = 50.0,
        spawnRadius = 25.0,
        propCount = 11,
    },
}

Config.Dealer = {
    coords = vector3(589.9447, -3282.0310, 6.0696),
    heading = 8.4354,
    model = 's_m_y_dealer_01',
    interactionDistance = 2.5,

    sellPriceMin = 1000,
    sellPriceMax = 1500,
    -- Per-drug override (npr. meth -40% od defaulta)
    sellPrices = {
        meth = { min = 600, max = 900 },
    },
    moneyAccount = 'black_money',

    weaponAmmo = 50,
    maxWeaponsPerDay = 20,
    weaponTrades = {
        { drug = 'meth',     cost = 400, weapon = 'WEAPON_APPISTOL' },
        { drug = 'cannabis', cost = 250, weapon = 'WEAPON_PISTOL50' },
        { drug = 'cocaine_list',  cost = 700, weapon = 'WEAPON_CARBINERIFLE' },
    },
}

Config.Languages = {
    ['hr'] = {
        ["WEED_FARM"]               = "[E] - Cannabis",
        ["COKE_FARM"]               = "[E] - Cocain List",
        ["METH_FARM"]               = "[E] - Meth",
        ["WEED_PROG"]               = "Berete cannabis...",
        ["COKE_PROG"]               = "Berete cocain list...",
        ["METH_PROG"]               = "Uzimate meth...",
        ["INVENTORY_FULL"]          = "Inventar je pun",
        ["COLLECTED"]               = "Prikupili ste drogu",
        ["ZONE_BONUS"]              = "2x bonus - 3+ clanova bande u zoni!",
        ["ZONE_BONUS_OFF"]          = "Bonus iskljucen - manje od 3 clana u zoni",
        ["NOTIFY_ENEMY_ENTERED"]    = "%s je usao u zonu! Neprijatelj!",
        ["NOTIFY_YOU_ENTERED_ENEMY"]= "Neprijateljska banda je vec u ovoj zoni!",
        ["NOTIFY_ALLY_ENTERED"]     = "%s se pridruzio zoni",
        ["NOTIFY_PLAYER_LEFT"]      = "%s je napustio zonu",
        ["NOTIFY_PLAYER_ELIMINATED"]= "%s je eliminiran!",
        ["DEALER_3D"]               = "[E] - Paleto Diler",
        ["DEALER_SELL_TITLE"]       = "Prodaj %s",
        ["DEALER_SELL_DESC"]        = "Cijena: $1000-$1500 po komadu",
        ["DEALER_TRADE_TITLE"]      = "Zamijeni %dx %s za %s",
        ["DEALER_TRADE_DESC"]       = "Max %d dnevno po igracu",
        ["DEALER_DAILY_LIMIT"]      = "Dosegnuli ste dnevni limit za ovo oruzje",
        ["JOB_BLOCKED"]             = "Vas posao vam ne dopusta ovo",
        ["DEALER_SOLD"]             = "Prodano %dx za $%d (preostalo: %d/200)",
        ["SELL_LIMIT_REACHED"]      = "Dosegnuli ste limit prodaje (200 kom / 5 min)",
        ["DEALER_NO_DRUGS"]         = "Nemate dovoljno droge",
        ["DEALER_WEAPON_RECEIVED"]  = "Dobili ste oruzje!",
        ["DEALER_NO_SPACE"]         = "Nemate mjesta u inventaru",
        ["COLLECTION_TOO_FAST"]     = "Prebrzo skupljate, sacekajte malo",
    },
}

function Lang(key)
    return Config.Languages['hr'][key] or key
end

function SendTextMessage(msg, type)
    lib.notify({
        title = 'Farma droge',
        description = msg,
        type = type or 'inform',
        position = 'top',
    })
end
