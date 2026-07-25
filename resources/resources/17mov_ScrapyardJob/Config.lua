Config = {}

Config.VersionCheck = {
    Enabled = false,                                     -- Is version check enabled
    DisplayAsciiArt = true,                             -- Set to false if you don't want to display ascii art in console
    DisplayChangelog = true,                            -- Should display changelog in console?
    DisplayFiles = true,                                -- Should display files that you need update in console?
}

Config.Debug = false                                     -- Enabling debug prints for developers
Config.UseTarget = true                                -- If you want to use taget system instead of markers you should set this to true
Config.UseBuiltInNotifications = true                   -- If you want to use built-in notification system, set this to true. Otherwise set it to false (then it's use default QB/ESX notification system)
Config.AutoSearchForConflicts = true                    -- Enabling system that automatically searches for map conflicts with other scripts.
Config.Lang = "en"                                      -- Select your language from avaliable in locales folder. You can also create your own translation file and add it to locales folder.

Config.AccentColor = { r = 57, g = 151, b = 201 }       -- Color that is used in UI, Markers, Path drawing etc.

Config.RequiredItem = "none"                            -- Set it to anything you want, to require players to have an item in their inventory before they start the job
Config.RequireItemFromWholeTeam = true                  -- If it's false, then only the host needs to have the required item, otherwise entire team needs it.
Config.RequiredJob = "none"                             -- Set to "none" if you dont want to use jobs.
Config.RequireJobAlsoForFriends = true                  -- If it's false, then only the host needs to have the job, if it's true, then everybody from the group needs to have the Config.RequiredJob
Config.RequireOneFriendMinimum = false                  -- Set to true if you want to force players to create teams
Config.LetBossSplitReward = false                        -- If it's true, then boss can manage whole party rewards percent in menu. If set to false, then everybody will get same amount. Avalible only in modern UI
Config.MultiplyRewardWhileWorkingInGroup = false         -- If it's false, then reward will stay by default. For example $1000 for completing whole job. If you set it to true, then the payout will depend on how many players is there in the group. For example, if for full job there's $1000, then if player works in a 4 member group, the reward will be $4000. (baseReward * partyCount)
Config.JobCooldown = 0 * 60 -- 10 * 60                  -- 0 minutes cooldown between making jobs (in brackets there's example for 10 minutes)

Config.ProgressBarOffset = "25px"                       -- Value in px of counter offset on screen
Config.ProgressBarAlign = "bottom-center"               -- Align of the progressbar. Values: top-left, top-center, top-right, bottom-left, bottom-center, bottom-right

Config.TaskList = {
    ToggleKey = 348,                                    -- Key to toggle task list. Default: SCROLLWHEEL BUTTON (PRESS)
    IsDisabledKey = false,                              -- Set to true is ToggleKey is disabled or should be disabled by DisableControlAction native. Otherwise set to false
    Align = "top-right",                                -- Align of the task list. Values: top-left, top-right, bottom-left, bottom-right
    MarginY = "40px",                                   -- Margin of hint from top or bottom of the screen. Each valid CSS unit is accepted (px, %, vh, vmin, vmax etc.)
    MarginX = "0px",                                    -- Margin of hint from left or right of the screen. Each valid CSS unit is accepted (px, %, vh, vmin, vmax etc.)
}

Config.MainBucket = 0                                   -- A bucket id that you're using for your server.

Config.ForkliftModel = `17mov_forklift`
Config.EnableVehicleTeleporting = true                  -- If its true, then the script will teleport the host to the company vehicle. If its false, then the company vehicle will apeear, but the whole squad will need to enter the car manually
Config.DeleteVehicleWithPenalty = true                  -- Delete rented vehicle after job with penalty.

Config.PenaltyAmount = 1000                             -- Penalty when team will not build every objects
Config.OnePercentWorth = 150                            -- A reward per one percent. Tags for searching: price, reward, money, cash

-- Items that player can get as reward after finishing job
Config.RewardItemsToGive = {                            -- Here you can add items reward as payout for job
    {
        itemName = "scrap_metal",
        chance = 70,
        amountPerPercent = 1,
        minimumProgressPercent = 15,
    },
    {
        itemName = "weapon_parts",
        chance = 55,
        amountPerPercent = 1,
        minimumProgressPercent = 45,
    },
    {
        itemName = "old_armor",
        chance = 35,
        amountPerPercent = 1,
        minimumProgressPercent = 60,
    },
}

-- Items that player can get as reward for completing specific parts of the job
Config.RewardItemsForParts = {
    GiveOnlyOneItem = false,                            -- If it's true, then player will get only one item from the list, if it's false, then player will have a chance to get all items from the list that he qualifies for.
    Items = {
        -- {
        --     itemName = "metal_scrap",                -- Name of item
        --     chance = 50,                             -- Chance to get item. Must be between 0-100 (0 = 0% chance, 1 = 1% chance, 100 = 100% chance etc.)
        --     parts = {                                -- Here you can add model of parts that player needs to scrap to have a chance to get the reward.
        --         "17mov_rebel_wheel",
        --         "17mov_emperor_wheel",
        --         "17mov_cheburek_wheel",
        --     },
        --     quantity = function(src)                 -- Must be a function
        --         return math.random(1, 5)             -- Must return number. In this case quantity is random from 1 to 5
        --     end,
        -- },
    }
}

Config.Clothes = {
    male = {
        ["mask"]    = { clotheId = 0,  variation = 0 },
        ["arms"]    = { clotheId = 44, variation = 0 },
        ["pants"]   = { clotheId = 38, variation = 0 },
        ["bag"]     = { clotheId = 0,  variation = 0 },
        ["shoes"]   = { clotheId = 51, variation = 0 },
        ["t-shirt"] = { clotheId = 15, variation = 0 },
        ["torso"]   = { clotheId = 65, variation = 0 },
        ["decals"]  = { clotheId = 0,  variation = 0 },
        ["kevlar"]  = { clotheId = 0,  variation = 0 },
    },
    female = {
        ["mask"]    = { clotheId = 0,  variation = 0 },
        ["arms"]    = { clotheId = 49, variation = 0 },
        ["pants"]   = { clotheId = 38, variation = 0 },
        ["bag"]     = { clotheId = 0,  variation = 0 },
        ["shoes"]   = { clotheId = 25, variation = 0 },
        ["t-shirt"] = { clotheId = 15, variation = 0 },
        ["torso"]   = { clotheId = 59, variation = 0 },
        ["decals"]  = { clotheId = 0,  variation = 0 },
        ["kevlar"]  = { clotheId = 0,  variation = 0 },
    },
}

Config.Panels = {
    RentForklift = {
        title = _L("Panel:RentForklift:Title"),
        subTitle = _L("Panel:RentForklift:SubTitle"),
        content = _L("Panel:RentForklift:Content"),
        confirmBtn = _L("Panel:RentForklift:Confirm"),
        closeBtn = _L("Panel:RentForklift:Close"),
        photo = "assets/images/rentForkliftPhoto.webp"
    },
}

-- Set to true, to hide job blip for players, who dont have RequiredJob. If requried job is "none", then this option will not have any effect.
Config.RestrictBlipToRequiredJob = false

-- Here you can configure Company blip.
Config.Blips = {
    [1] = {
        Sprite = 380,
        Color = 17,
        Scale = 0.8,
        Pos = vector3(-421.31, -1729.82, 19.81),
        Label = _L("Blip:Scrapyard"),
    },
}

-- Used only when Config.UseTarget = false. Colors of the marker. Active = when player stands inside the marker.
Config.MarkerSettings = {
    Active = {
        r = Config.AccentColor.r,
        g = Config.AccentColor.g,
        b = Config.AccentColor.b,
        a = 200,
    },
    UnActive = {
        r = Config.AccentColor.r,
        g = Config.AccentColor.g,
        b = Config.AccentColor.b,
        a = 120,
    },
}

---@class Location
---@field Coords vector3[] | vector4[] Array of coords for this location. If player is close to any of these coords, he will be able to interact with this location.
---@field Scale vector3 Scale of the marker.
---@field Message string Message shown to player when he is close to this location.
---@field OnlyOnDuty? boolean If set to true, then player will need to be on duty to interact with this location.
---@field TurnedOff? boolean If set to true, then this location will be turned off and players wont be able to interact with it.

---Here u can change all of the base job locations.
---@type table<string, Location>
Config.Locations = {
    JobMenu = {
        Coords = {
            vector3(-424.26, -1728.76, 19.81),
        },
        Scale = vector3(1.0, 1.0, 1.0),
        Message = _L("Action:JobMenu"),
    },
    RentForklift = {
        Coords = {
            vector3(-464.66, -1740.11, 16.86),
        },
        Scale = vector3(1.0, 1.0, 1.0),
        Message = _L("Action:RentForklift"),
        OnlyOnDuty = true,
    },
    ReturnForklift = {
        Coords = {
            vector4(-454.04, -1735.18, 16.76, 105.97), -- Here should be vector4, because forklift spawns at return forklift coords, so we need to know heading for forklift
        },
        Scale = vector3(2.5, 2.5, 1.0),
        Message = _L("Action:ReturnForklift"),
        OnlyOnDuty = true,
        TurnedOff = true, -- This location will be turned on, when player rents forklift
    },
}

Config.GarageZones = {
    {
        EnterPed = {
            points = {
                vec2(-509.326630, -1738.443359),
                vec2(-513.422424, -1735.575562),
                vec2(-514.913696, -1737.705322),
                vec2(-510.817963, -1740.573120),
            },
            options = {
                minZ = 18,
                maxZ = 22,
            },
            heading = 320.53,
        },
        ExitPed = {
            points = {
                vec2(-511.217590, -1742.694458),
                vec2(-515.313354, -1739.826660),
                vec2(-513.822083, -1737.696899),
                vec2(-509.726288, -1740.564697),
            },
            options = {
                minZ = -184.3,
                maxZ = -180.3,
            },
            heading = 148.5,
        },
        EnterVehicle = {
            points = {
                vec2(-507.319153, -1735.576294),
                vec2(-511.414948, -1732.708496),
                vec2(-514.913696, -1737.705322),
                vec2(-510.817963, -1740.573120),
            },
            options = {
                minZ = 18,
                maxZ = 22,
            },
            heading = 320.53,
        },
        ExitVehicle = {
            points = {
                vec2(-513.225037, -1745.561523),
                vec2(-517.320801, -1742.693726),
                vec2(-513.822083, -1737.696899),
                vec2(-509.726288, -1740.564697),
            },
            options = {
                minZ = -184.3,
                maxZ = -180.3,
            },
            heading = 148.5,
        },
    },
    {
        EnterPed = {
            points = {
                vec2(-535.696655, -1719.683350),
                vec2(-539.792419, -1716.815552),
                vec2(-541.283691, -1718.945312),
                vec2(-537.187927, -1721.813110),
            },
            options = {
                minZ = 18,
                maxZ = 22,
            },
            heading = 320.53,
        },
        ExitPed = {
            points = {
                vec2(-537.507568, -1724.444458),
                vec2(-541.603333, -1721.576660),
                vec2(-540.112061, -1719.446899),
                vec2(-536.016296, -1722.314697),
            },
            options = {
                minZ = -184.3,
                maxZ = -180.3,
            },
            heading = 148.5,
        },
        EnterVehicle = {
            points = {
                vec2(-533.689209, -1716.816284),
                vec2(-537.784973, -1713.948486),
                vec2(-541.283691, -1718.945312),
                vec2(-537.187927, -1721.813110),
            },
            options = {
                minZ = 18,
                maxZ = 22,
            },
            heading = 320.53,
        },
        ExitVehicle = {
            points = {
                vec2(-539.515015, -1727.311523),
                vec2(-543.610779, -1724.443726),
                vec2(-540.112061, -1719.446899),
                vec2(-536.016296, -1722.314697),
            },
            options = {
                minZ = -184.3,
                maxZ = -180.3,
            },
            heading = 148.5,
        },
    },
}

Config.DropZones = {
    -- Hoods
    {
        models = { `17mov_rebel_hood`, `17mov_emperor_hood`, `17mov_cheburek_hood`, `17mov_tornado_hood` },
        points = {
            vector2(-553.72, -1717.71),
            vector2(-550.94, -1719.66),
            vector2(-547.23, -1714.37),
            vector2(-550.02, -1712.42)
        },
        options = {
            minZ = 17.73,
            maxZ = 20.75,
        }
    },

    -- Mirrors
    {
        models = { `17mov_rebel_mirror_l`, `17mov_rebel_mirror_r`, `17mov_emperor_mirror_l`, `17mov_emperor_mirror_r`, `17mov_cheburek_mirror_int`, `17mov_cheburek_mirror_l`, `17mov_cheburek_mirror_r`, `17mov_tornado_mirror_l`, `17mov_tornado_mirror_r`, `17mov_tornado_mirror_int` },
        points = {
            vector2(-553.73, -1713.09),
            vector2(-552.09, -1714.46),
            vector2(-550.35, -1712.39),
            vector2(-551.99, -1711.02)
        },
        options = {
            minZ = 17.88,
            maxZ = 20.34,
        }
    },

    -- Steering wheel
    {
        models = { `17mov_rebel_steeringwheel`, `17mov_emperor_steeringwheel`, `17mov_cheburek_steeringwheel`, `17mov_tornado_steeringwheel` },
        points = {
            vector2(-562.20, -1701.42),
            vector2(-561.30, -1703.35),
            vector2(-558.85, -1702.21),
            vector2(-559.75, -1700.27)
        },
        options = {
            minZ = 18.16,
            maxZ = 20.66,
        }
    },

    -- Engines
    {
        models = {},
        points = {
            vector2(-523.86, -1677.46),
            vector2(-525.61, -1676.24),
            vector2(-527.16, -1678.46),
            vector2(-525.41, -1679.68)
        },
        options = {
            minZ = 18.20,
            maxZ = 20.81,
        }
    },

    -- Seats
    {
        models = { `17mov_rebel_seat`, `17mov_emperor_seat`, `17mov_cheburek_seat`, `17mov_tornado_seat` },
        points = {
            vector2(-563.31, -1695.76),
            vector2(-562.18, -1693.79),
            vector2(-565.87, -1691.66),
            vector2(-567.00, -1693.63)
        },
        options = {
            minZ = 18.08,
            maxZ = 21.15,
        }
    },

    -- Bumpers & threads
    {
        models = { `17mov_rebel_bumper`, `17mov_rebel_tread_l`,  `17mov_rebel_tread_r`, `17mov_emperor_bumper_f`, `17mov_emperor_bumper_r`, `17mov_cheburek_bumper_f`, `17mov_cheburek_bumper_r`, `17mov_tornado_bumper_f`, `17mov_tornado_bumper_r` },
        points = {
            vector2(-567.24, -1687.87),
            vector2(-565.63, -1686.26),
            vector2(-568.65, -1683.24),
            vector2(-570.26, -1684.85)
        },
        options = {
            minZ = 18.23,
            maxZ = 21.03,
        }
    },

    -- Roll bars
    {
        models = { `17mov_rebel_rollbar` },
        points = {
            vector2(-564.93, -1686.38),
            vector2(-563.07, -1685.07),
            vector2(-565.51, -1681.58),
            vector2(-567.38, -1682.88)
        },
        options = {
            minZ = 18.21,
            maxZ = 21.01,
        }
    },

    -- Suspensions
    {
        models = { `17mov_rebel_suspension`, `17mov_rebel_suspension_r`, `17mov_emperor_suspension_fl`, `17mov_emperor_suspension_fr`, `17mov_emperor_suspension_rl`, `17mov_emperor_suspension_rr`, `17mov_cheburek_suspension_fl`, `17mov_cheburek_suspension_fr`, `17mov_cheburek_suspension_rl`, `17mov_cheburek_suspension_rr`, `17mov_tornado_suspension_fl`, `17mov_tornado_suspension_fr`, `17mov_tornado_suspension_rl`, `17mov_tornado_suspension_rr` },
        points = {
            vector2(-557.64, -1678.18),
            vector2(-561.04, -1678.18),
            vector2(-561.04, -1684.64),
            vector2(-557.64, -1684.64)
        },
        options = {
            minZ = 18.23,
            maxZ = 21.03,
        }
    },

    -- Exhausts
    {
        models = { `17mov_rebel_exhaust`, `17mov_emperor_exhaust1`, `17mov_emperor_exhaust2`, `17mov_cheburek_exhaust1`, `17mov_cheburek_exhaust2`, `17mov_tornado_exhaust1`, `17mov_tornado_exhaust2` },
        points = {
            vector2(-518.27, -1678.64),
            vector2(-520.46, -1676.03),
            vector2(-525.40, -1680.18),
            vector2(-523.22, -1682.79)
        },
        options = {
            minZ = 18.15,
            maxZ = 20.95,
        }
    },

    -- Transmission
    {
        models = { `17mov_rebel_transmission_f`, `17mov_rebel_transmission_r` },
        points = {
            vector2(-512.84, -1748.63),
            vector2(-513.57, -1750.64),
            vector2(-511.05, -1751.55),
            vector2(-510.32, -1749.54)
        },
        options = {
            minZ = 18.00,
            maxZ = 20.86,
        }
    },

    -- Fender
    {
        models = { `17mov_rebel_fender_l`, `17mov_rebel_fender_r`, `17mov_emperor_fender_l`, `17mov_emperor_fender_r`, `17mov_tornado_fender_l`, `17mov_tornado_fender_r` },
        points = {
            vector2(-506.27, -1753.03),
            vector2(-508.32, -1752.06),
            vector2(-510.12, -1755.91),
            vector2(-508.06, -1756.87)
        },
        options = {
            minZ = 17.28,
            maxZ = 20.60,
        }
    },

    -- Doors
    {
        models = { `17mov_rebel_door_fl`, `17mov_rebel_door_fr`, `17mov_emperor_door_fl`, `17mov_emperor_door_fr`, `17mov_emperor_door_rl`, `17mov_emperor_door_rr`, `17mov_cheburek_door_fl`, `17mov_cheburek_door_fr`, `17mov_cheburek_door_rl`, `17mov_cheburek_door_rr`, `17mov_tornado_door_lf`, `17mov_tornado_door_rf` },
        points = {
            vector2(-507.14, -1759.63),
            vector2(-503.94, -1760.80),
            vector2(-501.74, -1754.75),
            vector2(-504.94, -1753.59)
        },
        options = {
            minZ = 17.33,
            maxZ = 20.68,
        }
    },

    -- Breaks
    {
        models = { `17mov_rebel_brakes_l`, `17mov_rebel_brakes_r`, `17mov_emperor_brakes_l`, `17mov_emperor_brakes_r`, `17mov_cheburek_brakes`, `17mov_tornado_brakes_l`, `17mov_tornado_brakes_r` },
        points = {
            vector2(-496.35, -1758.54),
            vector2(-494.25, -1758.91),
            vector2(-493.78, -1756.26),
            vector2(-495.88, -1755.89)
        },
        options = {
            minZ = 17.29,
            maxZ = 19.99,
        }
    },

    -- Wheels
    {
        models = { `17mov_rebel_wheel`, `17mov_emperor_wheel`, `17mov_cheburek_wheel`, `17mov_tornado_wheel` },
        points = {
            vector2(-488.60, -1755.58),
            vector2(-488.79, -1757.84),
            vector2(-484.54, -1758.21),
            vector2(-484.35, -1755.95)
        },
        options = {
            minZ = 17.16,
            maxZ = 20.08,
        }
    },

    -- Boots
    {
        models = { `17mov_rebel_boot`, `17mov_emperor_boot`, `17mov_cheburek_boot`, `17mov_tornado_boot` },
        points = {
            vector2(-482.65, -1754.30),
            vector2(-482.94, -1750.91),
            vector2(-489.37, -1751.46),
            vector2(-489.08, -1754.85)
        },
        options = {
            minZ = 17.12,
            maxZ = 20.16,
        }
    },

    -- Lights
    {
        models = { `17mov_rebel_headlight`, `17mov_rebel_headlight2`, `17mov_rebel_indicator_lf`, `17mov_rebel_indicator_rf`, `17mov_rebel_light_rl`, `17mov_rebel_light_rr`, `17mov_emperor_headlight_l`, `17mov_emperor_headlight_r`, `17mov_emperor_rear_light_l`, `17mov_emperor_rear_light_r`, `17mov_emperor_rev_light`, `17mov_cheburek_headlight_l`, `17mov_cheburek_headlight_r`, `17mov_cheburek_indicator_lf`, `17mov_cheburek_indicator_rf`, `17mov_cheburek_light_rl`, `17mov_cheburek_light_rr`, `17mov_tornado_indicator`, `17mov_tornado_indicator_r`, `17mov_tornado_light_r`, `17mov_tornado_headlight` },
        points = {
            vector2(-490.34, -1748.29),
            vector2(-492.41, -1747.73),
            vector2(-493.10, -1750.34),
            vector2(-491.04, -1750.90)
        },
        options = {
            minZ = 17.35,
            maxZ = 19.94,
        }
    },

    -- Crushed frames
    {
        models = { `17mov_rebel_crash`, `17mov_emperor_crash`, `17mov_cheburek_crash`, `17mov_tornado_crash` },
        points = {
            vector2(-537.15, -1607.56),
            vector2(-543.8, -1619.1),
            vector2(-522.45, -1630.36),
            vector2(-515.95, -1619.8),
        },
        options = {
            minZ = 16.8,
            maxZ = 19.8,
        },
    },
}

Config.Stations = {
    {
        Coords = vector3(-542.7194, -1731.664, -184.3054),
        Rotation = vector3(0.0, 0.0, -35.0),
    },
    {
        Coords = vector3(-535.3941, -1736.794, -184.3054),
        Rotation = vector3(0.0, 0.0, -35.0),
    },
    {
        Coords = vector3(-527.8074, -1742.106, -184.3054),
        Rotation = vector3(0.0, 0.0, -35.0),
    },
    {
        Coords = vector3(-520.1525, -1747.466, -184.3054),
        Rotation = vector3(0.0, 0.0, -35.0),
    },
}

Config.BoltTurnPerPress = 2          -- How many threads will be turned per one press of scroll (both up and down)

Config.Bolts = {
    -- HeadRadius: Used to determinate is bolt is hovered by cursor (you shouldn't change this values)
    -- ThreadLength: Tells you how long the bolt thread actually is
    -- ThreadPitch: Actual distance of thread pitch
    [`17mov_bolt_10`] = {
        HeadRadius = 0.007894 / 2,
        ThreadLength = 0.012958,
        ThreadPitch = 0.000684,
        RequiredTurns = Config.BoltTurnPerPress * 4,
    },
    [`17mov_bolt_15`] = {
        HeadRadius = 0.013875 / 2,
        ThreadLength = 0.017329,
        ThreadPitch = 0.00113,
        RequiredTurns = Config.BoltTurnPerPress * 4,
    },
    [`17mov_bolt_19`] = {
        HeadRadius = 0.02452 / 2,
        ThreadLength = 0.02769,
        ThreadPitch = 0.001426,
        RequiredTurns = Config.BoltTurnPerPress * 4,
    },
}
