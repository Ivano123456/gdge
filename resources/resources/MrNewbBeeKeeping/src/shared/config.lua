--		___  ___       _   _                  _      _____              _         _
--		|  \/  |      | \ | |                | |    /  ___|            (_)       | |
--		| .  . | _ __ |  \| |  ___ __      __| |__  \ `--.   ___  _ __  _  _ __  | |_  ___
--		| |\/| || '__|| . ` | / _ \\ \ /\ / /| '_ \  `--. \ / __|| '__|| || '_ \ | __|/ __|
--		| |  | || |   | |\  ||  __/ \ V  V / | |_) |/\__/ /| (__ | |   | || |_) || |_ \__ \
--		\_|  |_/|_|   \_| \_/ \___|  \_/\_/  |_.__/ \____/  \___||_|   |_|| .__/  \__||___/
--									          							  | |
--									          							  |_|
--
--		  Need support? Join our Discord server for help: https://discord.gg/mrnewbscripts
--		  If you need help with configuration or have any questions, please do not hesitate to ask.
--		  Docs Are Always Available At -- https://mrnewbs-scrips.gitbook.io/guide

Config = {}

-- Utility Settings
Config.Utility = {
    Debug = false, -- Enable debug messages (for troubleshooting). DO NOT enable in production ever!
}

-- Player and Hive Ownership Settings
Config.PlayerHiveSettings = {
    MaxOwnedHives = 5,     -- Max number of hives a player can own. Set to 0 for no limit
    OwnerOnly = true,      -- Only the owner of a hive can access the hive
    AllowlistOnly = false, -- Only allowlisted players can access the hive
    UsingHiveBlips = true, -- Enable map blips for the player's hive
    HiveBlipID = 837,      -- ID for the map blip representing the hive
    HiveBlipColor = 17,    -- Color ID for the hive blip on the map
}

-- Honey Production Settings
Config.HoneySettings = {
    MaxHoneyCapacity = 70,   -- Maximum honey capacity per hive
}

-- Wax Production Settings
Config.WaxSettings = {
    MaxWaxCapacity = 70,     -- Maximum wax capacity per hive
}

-- Worker Management Settings
Config.WorkerSettings = {
    WorkerLossChance = 0.01,     -- Chance of losing a worker bee per update interval
    MaxWorkerLoss = 3,           -- Maximum number of worker bees that can be lost in one interval
}

-- Hive Update & Minigame Settings
Config.HiveGameplaySettings = {
    UpdateInterval = 7,         -- Time in minutes between hive updates (honey, wax, worker loss)
    HiveMiniGame = "ox",        -- Mini-game for honey extraction (could be "ox" or other options)
}

-- Hive Cleanup Settings
Config.HiveMaintenanceSettings = {
    Enabled = true,             -- Enable automatic hive wipe after inactivity
    DaysWithoutAccess = 14,     -- Days of inactivity before hive is wiped
}

-- Beekeeping Model
Config.BeeKeepingModels = {
    HiveModel = "jim_g_beehive_prop_2", -- Model used for the hive
    Offsets = vector3(0.0, 0.0, 1.0),   -- Position offset for particle effects on the hive
    Scale = 1.0,                        -- Scale factor for the particle effects (make bigger or smaller)
    Radius = 100,                       -- Radius for the point to load
}

-- Shop Settings
Config.ShopSettings = {
    Enabled = true,           -- Enable the in-game shop system
    ShuffleSalePrices = false, -- Enable shuffling of sale prices per restart. IE prevent min/max players farming 1 honey type
    DynamicSalePrices = false, -- Enable dynamic pricing based on sales
    ShopSaleMethod = "bank",  -- Currency used for sales transactions: "bank" or "money"
    ShopData = {
        {
            id = "newb_beekeeper_shop",                          -- Unique ID for the shop
            name = "[Posao] Pcelar",                            -- Display name for the shop (also the blip name)
            ShopBlipID = 480,                                    -- ID for the shop's map blip
            ShopBlipColor = 2,                                   -- Color for the shop's map blip
            pos = vector4(1676.0438, 4883.3379, 41.07, 59.3255), -- Shop coordinates (x, y, z, heading)
            entityType = "ped",                                  -- Entity type for the shop, could be ped or object
            model = "a_m_m_farmer_01",                           -- NPC model for the shopkeeper
            items = {
                { name = 'worker_bees', price = 5,   count = 1000 },
                { name = 'queen_bee',   price = 45,  count = 1000 },
                { name = 'beehive',     price = 800, count = 1000 },
            },
        },
    },

    SellableItems = {
        ["bees_wax"] = 20,
        ["bees_honey"] = 70,
        ["blue_honey"] = 100,
        ["green_honey"] = 130,
        ["red_honey"] = 210,
        ["beehive"] = 1500,
    }
}