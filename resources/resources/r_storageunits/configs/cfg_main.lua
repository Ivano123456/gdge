--            _                                         _ _
--  _ __  ___| |_ ___  _ __ __ _  __ _  ___ _   _ _ __ (_) |_ ___
-- | '__|/ __| __/ _ \| '__/ _` |/ _` |/ _ \ | | | '_ \| | __/ __|
-- | |   \__ \ || (_) | | | (_| | (_| |  __/ |_| | | | | | |_\__ \
-- |_|___|___/\__\___/|_|  \__,_|\__, |\___|\__,_|_| |_|_|\__|___/
--  |_____|                      |___/
--
--  Need support? Join our Discord server for help: https://discord.gg/rscripts
--
Cfg = {
    --  ___  ___ _ ____   _____ _ __
    -- / __|/ _ \ '__\ \ / / _ \ '__|
    -- \__ \  __/ |   \ V /  __/ |
    -- |___/\___|_|    \_/ \___|_|
    Server = {
        Language = 'en',     -- Resource language ('en': English, 'es': Spanish, 'fr': French, 'de': German, 'pt': Portuguese, 'zh': Chinese)
        VersionCheck = true, -- Version check (true: enabled, false: disabled)
    },
    --              _   _
    --   ___  _ __ | |_(_) ___  _ __  ___
    --  / _ \| '_ \| __| |/ _ \| '_ \/ __|
    -- | (_) | |_) | |_| | (_) | | | \__ \
    --  \___/| .__/ \__|_|\___/|_| |_|___/
    --       |_|
    Options = {
        NuiColor = 'green', -- Colors: ('dark', 'gray', 'red', 'pink', 'grape', 'violet', 'indigo', 'blue', 'cyan', 'teal', 'green', 'lime', 'yellow', 'orange')

        Office = {
            Location = vec4(-79.44, -1197.20, 26.61, 183.93), -- Office location (vector4: x, y, z, heading)
            PedModel = 'ig_siemonyetarian',                   -- Ped model for the office (string: model name)
            Blip = {
                enabled = true,                               -- Enable blip on the map (true: enabled, false: disabled)
                sprite = 120,                                 -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/#blips)
                color = 0,                                    -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 0.7,                                  -- Blip scale (float: 0.1 to 1.0)
            },

            UnitPrice = 10000,         -- Unit lease price (Default: 1000)
            LeasePeriod = 7,          -- Lease period in days (Default: 7)
            MaxOverdue = 3,           -- Maximum overdue days before eviction (Default: 3)
            MaxOwnedUnits = 1,        -- Max units a player can own (Default: 3)
            RentCheck = '0 12 * * *', -- Cron expression for rent check (Default: '0 12 * * *' - every day at 12:00 PM)
        },

        Units = {
            Locations = {                            -- Storage Unit Locations
                [1] = vec3(-78.72, -1204.44, 28.04), -- Go in order, strictly following the format, failure to do so will result in errors.
                [2] = vec3(-73.10, -1196.90, 28.07), -- You can add up to 64 units... again, follow the format.
                [3] = vec3(-71.41, -1206.52, 28.26),
                [4] = vec3(-66.91, -1199.27, 28.21),
                [5] = vec3(-61.20, -1205.01, 28.59),
                [6] = vec3(-65.97, -1211.99, 28.79),
                [7] = vec3(-55.98, -1210.20, 28.90),
                [8] = vec3(-52.78, -1216.35, 29.12),
                [9] = vec3(-56.42, -1229.43, 29.21),
                [10] = vec3(-66.87, -1226.43, 29.25),
                [11] = vec3(-60.64, -1233.99, 29.32),
                [12] = vec3(-72.63, -1233.62, 29.43),
                [13] = vec3(-66.01, -1239.75, 29.45),
                [14] = vec3(-73.93, -1243.47, 29.51),
                [15] = vec3(-43.99, -1235.61, 29.33),
                [16] = vec3(-43.98, -1242.10, 29.33),
                [17] = vec3(-43.98, -1252.49, 29.25)
            },

            Blips = {
                enabled = false, -- Enable blips on the map (true: enabled, false: disabled)
                sprite = 50,    -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/#blips)
                color = 38,     -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 0.5,    -- Blip scale (float: 0.1 to 1.0)
            },

            MaxWeight = 250000, -- Maximum weight for storage units (Default: 50000)
        },

        PoliceRaids = {
            JobsAllowed = {
                { job = 'police', grade = 9 },
                -- { job = 'sheriff', grade = 1},
            },
            RequiredItem = 'bolt_cutters' -- Item required to raid a unit (string: item name)
        },

        WebhookEnabled = true, -- Enable webhook logging (true: enabled, false: disabled)
        -- Webhook URL can be set in core/server/webhook.lua
    },
    --      _      _
    --   __| | ___| |__  _   _  __ _
    --  / _` |/ _ \ '_ \| | | |/ _` |
    -- | (_| |  __/ |_) | |_| | (_| |
    --  \__,_|\___|_.__/ \__,_|\__, |
    --                         |___/
    Debug = false -- Enable debug prints (true: enabled, false: disabled)
}
