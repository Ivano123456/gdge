Config = Config or {}
Loc = {}

-- //////////////////////////////////////////////////
-- ///////////////// Our Discord ////////////////////
-- //////// https://discord.gg/bJNxYDAm5u ///////////
-- //////////////////////////////////////////////////

Config = {
    debug = false, -- Shows polyzones created inside the game
    Lan = 'en', -- Translation, 'en' 'pl' 'de' 'da' 'fr' 'in' 'am' 'ph' 'no' 'nl' 'ja' 'da' 'ru' 'gr' 'se' 'lt' 'ar' 'bg' 'bs', 'cn', 'cs', 'ee', 'el', 'en', 'es', 'et', 'fa', 'fi', 'ge', 'he', 'hu', 'id', 'is', 'it', 'lv', 'pt', 'pt-br', 'ro', 'rs', 'sl', 'sv', 'th', 'tr', 'vn'
    Framework = 'esx', -- 'qb-core' 'qbox' 'esx' or 'custom'
    ESX = "new", -- (only for ESX users) "new" or "old" chosoe the version of ESX you are using
    Inventory = "ox", -- "ox" "qb" "codem" "origen" "tgiann" "esx" "lj" "ps", if you arent using any of these inventories, put it as "other" and you will need to edit the inventory export function, or open a ticket on discord.
    Dispatch = "jamaica", -- "jamaica" "ps" "cd" "origen" "tk" "codem" "rcore" "l2s" "redutzu" "lb" "sonoran" or "outlaw", if you arent using any of these dispatch systems, put it as "other" and you will need to edit the dispatch export function, or open a ticket on discord.
    Notification = "ox", -- "ox" or "qb" or "esx"
    Progressbar = "ox", -- "ox" or "qb"

    Target = 'ox_target', -- Target name, leave it as qb-target if you are using ox_target
    WorldInteract = false, -- Enable/Disable World Interactions (Only use this if you have the interact script, otherwise leave it as false)

    TestingMode = false, -- Enable/Disable Testing Mode (No Minigames)

    DiscordLogStatus = true, -- Choose whether u want to turn on discord logs or not, you need to add a webhook below for it to work
    -- To add your webhook go to opensource -> server, line 1 and add your webhook there

    Cooldown = {
        Global = true, -- Global cooldown (Set to false to have individual cooldowns on fleecas, true to have cooldowns on all fleecas when one is robbed)
        Timer = 60, -- (Minutes) timer duration
    },

    AllRobberiesCooldown = true, -- For this to work you need to download projectx-utility from our github

    PoliceJobs = {["police"] = true}, -- Add the jobs that will be checked
    MinimumPolice = 5, -- Minimum police required to rob a fleeca

    ListLength = 100, -- Length of the employee list that will appear on the board
    DisableEmployeePuzzle = false, -- Disable the employee puzzle
    DisableParticles = false, -- Disable particle effects
    DisableLoudApproach = false, -- Disable loud approach
    DisableSilentApproach = false, -- Disable silent approach

    GruppeSechsJob17mov = false, -- Enable/Disable GruppeSechs Job Compatibility by 17mov

    -- Progression item (Item that can be obtained at the end of the heist, can be used for the next heist) 
    Bonus = {
        Status = false, -- Enable/Disable Bonus items
        BonusChance = 15, -- Chance of an item being given
        ItemCount = 1, -- How many items can be given from the table below
        Items = { -- You can remove items and add items as you wish
            {Name = "x_device", Chance = 30, Amount = {min = 1, max = 1}}, -- Chance(%) -- Amount(Items given from that type)
            {Name = "x_phone", Chance = 50, Amount = {min = 1, max = 1}},
            {Name = "x_stethoscope", Chance = 20, Amount = {min = 1, max = 1}},
        },
    },

    RequireBag = true, -- Require bag to pickup loot

    -- Strike System (Silent = High risk, Higher reward, Loud = No risk, Fixed reward)
    TotalTrolleys = 4, -- Total maximum amount of trolleys that could spawn, they spawn depending on the settings below
    Strikes = 2, -- How many strikes players have to reach before having their reward cut
    StrikeAmount = 2, -- (Silent Approach ONLY) How many trollys will be removed if they reach the strike limit
    StrikeLoud = 3, -- (Loud Approach ONLY) How many trollys will spawn (preferably less than TotalTrolleys by 1, to give them insentive to do the loud approach aswell)

    -- Skill System
    SkillSystem = false, -- If want to use a skill system to initiate the heist set this to true
    MinimumLevel = 10, -- Minimum level required to start the heist
    ServerSideEvents = true, -- If you use a server sided skill events set this to true, if you use a client sided skill events set this to false

    -- Evidence and Stress Systems
    Evidence = {
        ["Status"] = true, -- Choose whether you want to have evidence dropped on the crime scene
        ["Chance"] = 50, -- Chance of fingerprints on the crime scene
    },

    Stress = { -- Stress gets applied on minigames failing only
        ["Status"] = true, -- Choose whether you want to have stress system
        ["Chance"] = 90, -- Chance of stress on the crime scene
        ["Amount"] = {min = 1, max = 3}, -- Amount of stress applied
    },

    DispatchLocation = { -- Choose where the alarm gets triggered, only one should be picked
        ["Fusebox"] = true,
        ["FirstKeypad"] = false, -- Alarm gets triggered instantly when they start the heist
        ["ElectricBox"] = true,
        ["Vault"] = false,
    },

    -- Drawtext and Target options 
    Drawtext = "OX", -- OLDQB for old qb-drawtext, QB for new qbcore drawtext, OX for ox_lib
    DrawTextZoneSize = vec3(0.8, 0.8, 2), -- Size of the drawtext zone
    Interaction = { -- true = target, false = drawtext
        ["Button"] = 38, -- [E] by default

        ["KeypadOne"] = true,
        ["Fingerprint"] = true,
        ["Board"] = true,
        ["Printer"] = true,
        ["Fusebox"] = true,
        ["ShelfOne"] = true,
        ["ShelfTwo"] = true,
        ["ShelfThree"] = true,
        ["ElectricBox"] = true,
        ["Vault"] = true,
        ["JailDoorLeft"] = true,
        ["JailDoorRight"] = true,
        ["Table"] = true,
        ["Trollys"] = true,
    },

    -- Durations 
    NotificationDuration = 2500, -- Duration of the displayed notifications
    FingerprintDuration = 6000, -- Duration of the fingerprint progressbar
    FuseboxDuration = 6000, -- Duration of the fusebox progressbar
    ShelfDuration = 5000, -- Duration of the shelf progressbar
    KeypadOneDuration = 6000, -- Duration of the keypad progressbar
    SearchDuration = 6000, -- Duration of the search progressbar
    ElectricBoxDuration = 7500, -- Duration of the electricbox progressbar
    PrinterDuration = 7500, -- Duration of the printer progressbar
    VaultDuration = 6000, -- Duration of the vault progressbar
    JailDoorDuration = 5000, -- Duration of the jaildoor progressbar
}

Config.Inputs = { -- All the ox_lib Input texts
    ["SecretCombination"] = {Title = 'Hidden Password', Label = 'Password', Description = 'Enter the login password', Icon = 'fas fa-lock'},
}

Config.Items ={
    ["Device"] = "x_device",
    ["Pliers"] = "pliers",
    ["Pictures"] = "employeepictures",
    ["Bag"] = "bag",
    ["Keycard"] = "fleecacard",
    ["Laptop"] = "x_laptop",
}

Config.ItemsBreak = {
    ["Device"] = 0, -- % chance of breaking
    ["Pliers"] = 0, -- % chance of breaking
    ["Laptop"] = 0, -- % chance of breaking
}

Config.Fleecas = {
    ["RockfordHills"] = {
        ["Reset"] = 120, -- (Minutes) Resets the bank
        ["AlarmCoords"] = vector3(-1218.73, -329.83, 40.09),
        ["VaultDoorLeft"] = vector3(-1209.38, -338.02, 36.78), -- Vault Door Left
        ["VaultDoorRight"] = vector3(-1211.08, -338.9, 36.78), -- Vault Door Right

        ["JailDoorLeft"] = vector3(-1207.47, -339.34, 36.78), -- Jail Door Left
        ["JailDoorRight"] = vector3(-1211.14, -341.21, 36.78), -- Jail Door Right

        ["OnCooldown"] = false,

        ["DrawTextRotation"] = -60.0, -- Rotation of the drawtext

        Interactions = {
            ["Fusebox"] = {
                name = "Fusebox",
                label = "Cut wires", -- Text that appears when you target
                coords = vector3(-1217.27, -332.98, 42.13), -- Circle Zone Coords
                drawtext = vector3(-1216.89, -332.87, 42.12),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Fingerprint"] = {
                name = "Fingerprint",
                label = "Fake Fingerprint", -- Text that appears when you target
                coords = vector3(-1209.42, -333.87, 38.17), -- Circle Zone Coords
                drawtext = vector3(-1209.64, -333.5, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-fingerprint", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["KeypadOne"] = {
                name = "KeypadOne",
                label = "Disable Keypad", -- Text that appears when you target
                coords = vector3(-1208.58, -336.64, 38.17), -- Circle Zone Coords
                drawtext = vector3(-1208.2, -336.35, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Printer"] = {
                name = "Printer",
                label = "Print out pictures", -- Text that appears when you target
                coords = vector3(-1213.73, -337.18, 37.91), -- Circle Zone Coords
                drawtext = vector3(-1213.51, -337.61, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-print", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Board"] = {
                name = "Board",
                label = "Employee list", -- Text that appears when you target
                coords = vector3(-1214.55, -339.79, 37.97), -- Circle Zone Coords
                drawtext = vector3(-1214.85, -339.16, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-paperclip", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["ShelfOne"] = {
                name = "ShelfOne",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-1215.48, -335.02, 37.82), -- Circle Zone Coords
                drawtext = vector3(-1215.73, -335.52, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfTwo"] = {
                name = "ShelfTwo",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-1216.41, -333.18, 37.82), -- Circle Zone Coords
                drawtext = vector3(-1216.51, -333.80, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfThree"] = {
                name = "ShelfThree",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-1217.34, -331.33, 37.82), -- Circle Zone Coords
                drawtext = vector3(-1217.55, -331.88, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ElectricBox"] = {
                name = "ElectricBox",
                label = "Disable vault fuse", -- Text that appears when you target
                coords = vector3(-1207.97, -336.70, 37.93), -- Circle Zone Coords
                drawtext = vector3(-1208.21, -336.29, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Vault"] = {
                name = "Vault",
                label = "Enter Keyword", -- Text that appears when you target
                coords = vector3(-1211.83, -338.80, 38.11), -- Circle Zone Coords
                drawtext = vector3(-1212.01, -338.2, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorLeft"] = {
                name = "JailDoorLeft",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(-1207.76, -339.12, 38.17), -- Circle Zone Coords
                drawtext = vector3(-1208.14, -339.27, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorRight"] = {
                name = "JailDoorRight",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(-1211.14, -340.86, 38.17), -- Circle Zone Coords
                drawtext = vector3(-1210.55, -340.6, 37.78),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },
        },

        ["Zone"] = {vector3(-1211.42, -315.51, 37.74), vector3(-1228.35, -323.95, 37.74), vector3(-1216.77, -346.8, 37.74), vector3(-1200.45, -336.72, 37.74)},
    },

    ["Legion"] = {
        ["Reset"] = 120, -- (Minutes) Resets the bank
        ["AlarmCoords"] = vector3(148.76, -1036.29, 32.14),
        ["VaultDoorLeft"] = vector3(146.75, -1048.11, 28.37), -- Vault Door Left
        ["VaultDoorRight"] = vector3(144.96, -1047.45, 28.37), -- Vault Door Right

        ["JailDoorLeft"] = vector3(147.09, -1050.4, 28.37), -- Jail Door Left
        ["JailDoorRight"] = vector3(143.22, -1048.98, 28.37), -- Jail Door Right

        ["OnCooldown"] = false,

        ["DrawTextRotation"] = -110.0, -- Rotation of the drawtext

        Interactions = {
            ["Fusebox"] = {
                name = "Fusebox",
                label = "Cut wires", -- Text that appears when you target
                coords = vector3(135.64, -1046.56, 29.84), -- Circle Zone Coords
                drawtext = vector3(135.41, -1046.76, 29.33),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Fingerprint"] = {
                name = "Fingerprint",
                label = "Fake Fingerprint", -- Text that appears when you target
                coords = vector3(149.75, -1045.24, 29.70), -- Circle Zone Coords
                drawtext = vector3(149.95, -1044.74, 29.37),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-fingerprint", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["KeypadOne"] = {
                name = "KeypadOne",
                label = "Disable Keypad", -- Text that appears when you target
                coords = vector3(148.32, -1047.72, 29.78), -- Circle Zone Coords
                drawtext = vector3(148.8, -1047.8, 29.37),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Printer"] = {
                name = "Printer",
                label = "Print out pictures", -- Text that appears when you target
                coords = vector3(144.37, -1044.32, 29.50), -- Circle Zone Coords
                drawtext = vector3(144.24, -1044.73, 29.36),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-print", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Board"] = {
                name = "Board",
                label = "Employee list", -- Text that appears when you target
                coords = vector3(141.92, -1045.53, 29.56), -- Circle Zone Coords
                drawtext = vector3(142.09, -1044.90, 29.36),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-paperclip", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["ShelfOne"] = {
                name = "ShelfOne",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(144.83, -1041.56, 29.41), -- Circle Zone Coords
                drawtext = vector3(144.28, -1041.83, 29.36),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfTwo"] = {
                name = "ShelfTwo",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(145.52, -1039.66, 29.41), -- Circle Zone Coords
                drawtext = vector3(144.99, -1040.00, 29.36),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfThree"] = {
                name = "ShelfThree",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(146.22, -1037.73, 29.41), -- Circle Zone Coords
                drawtext = vector3(145.72, -1038.02, 29.36),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ElectricBox"] = {
                name = "ElectricBox",
                label = "Disable vault fuse", -- Text that appears when you target
                coords = vector3(148.69, -1048.24, 29.55), -- Circle Zone Coords
                drawtext = vector3(148.8, -1047.8, 29.37),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Vault"] = {
                name = "Vault",
                label = "Enter Keyword", -- Text that appears when you target
                coords = vector3(144.50, -1046.83, 29.72), -- Circle Zone Coords
                drawtext = vector3(144.67, -1046.28, 29.37),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorLeft"] = {
                name = "JailDoorLeft",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(147.05, -1050.04, 29.74), -- Circle Zone Coords
                drawtext = vector3(146.6, -1049.85, 29.37),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorRight"] = {
                name = "JailDoorRight",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(143.47, -1048.76, 29.76), -- Circle Zone Coords
                drawtext = vector3(144.0, -1048.87, 29.37),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },
        },

        ["Zone"] = {vector3(156.71, -1033.39, 29.26), vector3(149.98, -1052.85, 29.26), vector3(140.06, -1049.24, 29.26), vector3(146.39, -1028.81, 29.26)},
    },

    ["Burton"] = {
        ["Reset"] = 120, -- (Minutes) Resets the bank
        ["AlarmCoords"] = vector3(-353.73, -42.97, 52.5),
        ["VaultDoorLeft"] = vector3(-353.94, -57.34, 48.04), -- Vault Door Left
        ["VaultDoorRight"] = vector3(-355.75, -56.71, 48.04), -- Vault Door Right

        ["JailDoorLeft"] = vector3(-353.57, -59.62, 48.04), -- Jail Door Left
        ["JailDoorRight"] = vector3(-357.46, -58.27, 48.04), -- Jail Door Right

        ["OnCooldown"] = false,

        ["DrawTextRotation"] = -110.0, -- Rotation of the drawtext

        Interactions = {
            ["Fusebox"] = {
                name = "Fusebox",
                label = "Cut wires", -- Text that appears when you target
                coords = vector3(-365.26, -71.52, 45.69), -- Circle Zone Coords
                drawtext = vector3(-365.39, -71.92, 45.66),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Fingerprint"] = {
                name = "Fingerprint",
                label = "Fake Fingerprint", -- Text that appears when you target
                coords = vector3(-350.98, -54.43, 49.38), -- Circle Zone Coords
                drawtext = vector3(-350.81, -53.87, 49.04),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-fingerprint", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["KeypadOne"] = {
                name = "KeypadOne",
                label = "Disable Keypad", -- Text that appears when you target
                coords = vector3(-352.37, -56.90, 49.43), -- Circle Zone Coords
                drawtext = vector3(-351.86, -56.95, 49.04),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Printer"] = {
                name = "Printer",
                label = "Print out pictures", -- Text that appears when you target
                coords = vector3(-356.39, -53.61, 49.17), -- Circle Zone Coords
                drawtext = vector3(-356.50, -54.06, 49.03),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-print", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Board"] = {
                name = "Board",
                label = "Employee list", -- Text that appears when you target
                coords = vector3(-358.79, -54.78, 49.22), -- Circle Zone Coords
                drawtext = vector3(-358.63, -54.17, 49.03),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-paperclip", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["ShelfOne"] = {
                name = "ShelfOne",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-355.99, -50.84, 49.07), -- Circle Zone Coords
                drawtext = vector3(-356.52, -51.09, 49.03),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfTwo"] = {
                name = "ShelfTwo",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-355.32, -48.92, 49.07), -- Circle Zone Coords
                drawtext = vector3(-355.84, -49.27, 49.03),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfThree"] = {
                name = "ShelfThree",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-354.64, -46.98, 49.07), -- Circle Zone Coords
                drawtext = vector3(-355.20, -47.18, 49.03),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ElectricBox"] = {
                name = "ElectricBox",
                label = "Disable vault fuse", -- Text that appears when you target
                coords = vector3(-352.02, -57.43, 49.23), -- Circle Zone Coords
                drawtext = vector3(-351.86, -56.95, 49.04),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Vault"] = {
                name = "Vault",
                label = "Enter Keyword", -- Text that appears when you target
                coords = vector3(-356.22, -56.10, 49.41), -- Circle Zone Coords
                drawtext = vector3(-356.12, -55.68, 49.04),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorLeft"] = {
                name = "JailDoorLeft",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(-353.62, -59.29, 49.44), -- Circle Zone Coords
                drawtext = vector3(-354.01, -59.07, 49.04),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorRight"] = {
                name = "JailDoorRight",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(-357.21, -58.02, 49.43), -- Circle Zone Coords
                drawtext = vector3(-356.65, -58.25, 49.04),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },
        },

        ["Zone"] = {vector3(-355.27, -38.79, 49.02), vector3(-343.72, -43.26, 49.02), vector3(-350.61, -62.6, 49.02), vector3(-368.76, -56.43, 49.02)},
    },

    ["Alta"] = {
        ["Reset"] = 120, -- (Minutes) Resets the bank
        ["AlarmCoords"] = vector3(318.57, -275.84, 58.7),
        ["VaultDoorLeft"] = vector3(311.08, -286.47, 53.16), -- Vault Door Left
        ["VaultDoorRight"] = vector3(309.29, -285.82, 53.16), -- Vault Door Right

        ["JailDoorLeft"] = vector3(311.42, -288.77, 53.16), -- Jail Door Left
        ["JailDoorRight"] = vector3(307.55, -287.35, 53.16), -- Jail Door Right

        ["OnCooldown"] = false,

        ["DrawTextRotation"] = -110.0, -- Rotation of the drawtext

        Interactions = {
            ["Fusebox"] = {
                name = "Fusebox",
                label = "Cut wires", -- Text that appears when you target
                coords = vector3(258.69, -308.01, 49.76), -- Circle Zone Coords
                drawtext = vector3(258.79, -307.66, 49.65),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Fingerprint"] = {
                name = "Fingerprint",
                label = "Fake Fingerprint", -- Text that appears when you target
                coords = vector3(314.10, -283.61, 54.54), -- Circle Zone Coords
                drawtext = vector3(314.32, -283.2, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-fingerprint", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["KeypadOne"] = {
                name = "KeypadOne",
                label = "Disable Keypad", -- Text that appears when you target
                coords = vector3(312.66, -286.07, 54.60), -- Circle Zone Coords
                drawtext = vector3(313.15, -286.15, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Printer"] = {
                name = "Printer",
                label = "Print out pictures", -- Text that appears when you target
                coords = vector3(308.71, -282.70, 54.30), -- Circle Zone Coords
                drawtext = vector3(308.56, -283.15, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-print", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Board"] = {
                name = "Board",
                label = "Employee list", -- Text that appears when you target
                coords = vector3(306.25, -283.88, 54.35), -- Circle Zone Coords
                drawtext = vector3(306.50, -283.22, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-paperclip", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["ShelfOne"] = {
                name = "ShelfOne",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(309.15, -279.94, 54.20), -- Circle Zone Coords
                drawtext = vector3(308.61, -280.11, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfTwo"] = {
                name = "ShelfTwo",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(309.84, -278.02, 54.20), -- Circle Zone Coords
                drawtext = vector3(309.33, -278.39, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfThree"] = {
                name = "ShelfThree",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(310.57, -276.11, 54.20), -- Circle Zone Coords
                drawtext = vector3(309.99, -276.27, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ElectricBox"] = {
                name = "ElectricBox",
                label = "Disable vault fuse", -- Text that appears when you target
                coords = vector3(313.00, -286.60, 54.35), -- Circle Zone Coords
                drawtext = vector3(313.15, -286.15, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Vault"] = {
                name = "Vault",
                label = "Enter Keyword", -- Text that appears when you target
                coords = vector3(308.84, -285.20, 54.51), -- Circle Zone Coords
                drawtext = vector3(309.02, -284.79, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorLeft"] = {
                name = "JailDoorLeft",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(311.38, -288.41, 54.55), -- Circle Zone Coords
                drawtext = vector3(310.95, -288.21, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorRight"] = {
                name = "JailDoorRight",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(307.80, -287.14, 54.54), -- Circle Zone Coords
                drawtext = vector3(308.35, -287.32, 54.16),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },
        },

        ["Zone"] = {vector3(306.58, -265.0, 53.96), vector3(326.7, -272.52, 53.93), vector3(315.11, -302.47, 53.95), vector3(291.94, -295.0, 53.95)},
    },

    ["GrandSenoraDesert"] = {
        ["Reset"] = 120, -- (Minutes) Resets the bank
        ["AlarmCoords"] = vector3(1171.15, 2702.71, 40.67), -- Alarm coords
        ["VaultDoorLeft"] = vector3(1175.45, 2714.81, 37.09), -- Vault Door Left
        ["VaultDoorRight"] = vector3(1177.36, 2714.81, 37.09), -- Vault Door Right

        ["JailDoorLeft"] = vector3(1174.34, 2716.85, 37.09), -- Jail Door Left
        ["JailDoorRight"] = vector3(1178.46, 2716.85, 37.09), -- Jail Door Right

        ["OnCooldown"] = false,

        ["DrawTextRotation"] = -90.0, -- Rotation of the drawtext

        Interactions = {
            ["Fusebox"] = {
                name = "Fusebox",
                label = "Cut wires", -- Text that appears when you target
                coords = vector3(1158.14, 2708.95, 37.98), -- Circle Zone Coords
                drawtext = vector3(1157.68, 2708.98, 37.98),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Fingerprint"] = {
                name = "Fingerprint",
                label = "Fake Fingerprint", -- Text that appears when you target
                coords = vector3(1173.62, 2711.09, 38.47), -- Circle Zone Coords
                drawtext = vector3(1173.57, 2710.58, 38.09),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-fingerprint", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["KeypadOne"] = {
                name = "KeypadOne",
                label = "Disable Keypad", -- Text that appears when you target
                coords = vector3(1174.11, 2713.89, 38.49), -- Circle Zone Coords
                drawtext = vector3(1173.64, 2713.83, 38.09),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Printer"] = {
                name = "Printer",
                label = "Print out pictures", -- Text that appears when you target
                coords = vector3(1178.97, 2712.05, 38.22), -- Circle Zone Coords
                drawtext = vector3(1178.97, 2712.54, 38.08),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-print", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Board"] = {
                name = "Board",
                label = "Employee list", -- Text that appears when you target
                coords = vector3(1180.87, 2714.01, 38.28), -- Circle Zone Coords
                drawtext = vector3(1180.88, 2713.37, 38.08),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-paperclip", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["ShelfOne"] = {
                name = "ShelfOne",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(1179.50, 2709.35, 38.13), -- Circle Zone Coords
                drawtext = vector3(1179.94, 2709.77, 38.08),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfTwo"] = {
                name = "ShelfTwo",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(1179.51,2707.30,38.13), -- Circle Zone Coords
                drawtext = vector3(1179.87, 2707.82, 38.08),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfThree"] = {
                name = "ShelfThree",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(1179.50, 2705.25, 38.13), -- Circle Zone Coords
                drawtext = vector3(1179.94, 2705.55, 38.08),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ElectricBox"] = {
                name = "ElectricBox",
                label = "Disable vault fuse", -- Text that appears when you target
                coords = vector3(1173.62, 2714.27, 38.32), -- Circle Zone Coords
                drawtext = vector3(1173.64, 2713.83, 38.09),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Vault"] = {
                name = "Vault",
                label = "Enter Keyword", -- Text that appears when you target
                coords = vector3(1178.00, 2714.39, 38.44), -- Circle Zone Coords
                drawtext = vector3(1177.99, 2713.84, 38.09),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorLeft"] = {
                name = "JailDoorLeft",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(1174.50, 2716.53, 38.47), -- Circle Zone Coords
                drawtext = vector3(1175.04, 2716.54, 38.09),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorRight"] = {
                name = "JailDoorRight",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(1178.31, 2716.54, 38.47), -- Circle Zone Coords
                drawtext = vector3(1177.67, 2716.54, 38.09),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },
        },

        ["Zone"] = {vector3(1181.73, 2698.29, 38.0), vector3(1171.2, 2698.28, 38.0), vector3(1171.17, 2721.76, 38.0), vector3(1181.54, 2721.39, 38.0)},
    },

    ["BanhamCanyon"] = {
        ["Reset"] = 120, -- (Minutes) Resets the bank
        ["AlarmCoords"] = vector3(-2966.54, 480.14, 18.35), -- Alarm coords
        ["VaultDoorLeft"] = vector3(-2954.58, 482.2, 14.7), -- Vault Door Left
        ["VaultDoorRight"] = vector3(-2954.67, 480.28, 14.7), -- Vault Door Right

        ["JailDoorLeft"] = vector3(-2952.5, 483.21, 14.7), -- Jail Door Left
        ["JailDoorRight"] = vector3(-2952.68, 479.09, 14.7), -- Jail Door Right

        ["OnCooldown"] = false,

        ["DrawTextRotation"] = -90.0, -- Rotation of the drawtext

        Interactions = {
            ["Fusebox"] = {
                name = "Fusebox",
                label = "Cut wires", -- Text that appears when you target
                coords = vector3(-2948.08, 481.18, 15.44), -- Circle Zone Coords
                drawtext = vector3(-2947.67, 481.29, 15.44),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Fingerprint"] = {
                name = "Fingerprint",
                label = "Fake Fingerprint", -- Text that appears when you target
                coords = vector3(-2958.23, 484.16, 16.08), -- Circle Zone Coords
                drawtext = vector3(-2958.74, 484.2, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-fingerprint", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["KeypadOne"] = {
                name = "KeypadOne",
                label = "Disable Keypad", -- Text that appears when you target
                coords = vector3(-2955.44, 483.57, 16.08), -- Circle Zone Coords
                drawtext = vector3(-2955.59, 484.1, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Printer"] = {
                name = "Printer",
                label = "Print out pictures", -- Text that appears when you target
                coords = vector3(-2957.59, 478.37, 15.79), -- Circle Zone Coords
                drawtext = vector3(-2957.04, 478.17, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-print", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["Board"] = {
                name = "Board",
                label = "Employee list", -- Text that appears when you target
                coords = vector3(-2955.77, 476.85, 15.88), -- Circle Zone Coords
                drawtext = vector3(-2956.19, 476.96, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-paperclip", -- Icon
                size = 0.5, -- Circle Zone size
            },

            ["ShelfOne"] = {
                name = "ShelfOne",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-2960.15, 478.32, 15.71), -- Circle Zone Coords
                drawtext = vector3(-2960.02, 477.87, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfTwo"] = {
                name = "ShelfTwo",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-2962.29, 478.40, 15.74), -- Circle Zone Coords
                drawtext = vector3(-2961.77, 478.07, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ShelfThree"] = {
                name = "ShelfThree",
                label = "Search through documents", -- Text that appears when you target
                coords = vector3(-2964.27, 478.56, 15.74), -- Circle Zone Coords
                drawtext = vector3(-2964.16, 478.05, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-sheet-plastic", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["ElectricBox"] = {
                name = "ElectricBox",
                label = "Disable vault fuse", -- Text that appears when you target
                coords = vector3(-2955.05, 484.03, 15.91), -- Circle Zone Coords
                drawtext = vector3(-2955.59, 484.1, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-bolt", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["Vault"] = {
                name = "Vault",
                label = "Enter Keyword", -- Text that appears when you target
                coords = vector3(-2955.12, 479.66, 16.07), -- Circle Zone Coords
                drawtext = vector3(-2955.75, 479.69, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-keyboard", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorLeft"] = {
                name = "JailDoorLeft",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(-2952.84, 483.07, 16.07), -- Circle Zone Coords
                drawtext = vector3(-2952.79, 482.49, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },

            ["JailDoorRight"] = {
                name = "JailDoorRight",
                label = "Unlock Gate", -- Text that appears when you target
                coords = vector3(-2952.97, 479.26, 16.06), -- Circle Zone Coords
                drawtext = vector3(-2952.91, 479.84, 15.7),
                distance = 1.0, -- How far will you be able to interact with it
                icon = "fas fa-lock", -- Icon
                size = 0.3, -- Circle Zone size
            },
        },
        ["Zone"] = {vector3(-2972.54, 490.35, 15.3), vector3(-2942.93, 488.71, 15.3), vector3(-2944.23, 468.44, 15.3), vector3(-2973.19, 469.75, 15.3)},
    },
}

Config.Sounds = {
    ["SoundLoops"] = {
        ["MetalDetectorBig"] = 300
    }
}

Config.PuzzleSettings = {
    ["ShowFirstLetter"] = {
        ["Status"] = true, -- Show the first letter of the hidden word
        ["Replace"] = "?" -- If ["Status"] is false, replace the hidden word with the chosen string
    },

    ["ShowLastLetter"] = {
        ["Status"] = false, -- Show the first letter of the hidden word
        ["Replace"] = "?" -- If ["Status"] is false, replace the hidden word with the chosen string
    },

    ["HideOneClue"] = {
        ["Status"] = true, -- Hide one of the clues
        ["Replace"] = "* **Missing** *" -- If ["Status"] is false, replace the hidden word with the chosen string
    }
}

Config.CashPileReward = {
    ['Cash'] = false, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "black_money", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 4800, max = 6100}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of cash you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.Rewardcash = {
    ["ObtainPerPickup"] = true, -- Obtain the specified items below per cash stack pickup from the trolley, false - Obtain the item/cash specified below at the end of the trolley animation
    ['Cash'] = false, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "black_money", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 5000, max = 6000}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of cash you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.Rewardgold = {
    ["ObtainPerPickup"] = false, -- Obtain the specified items below per gold bar pickup from the trolley, false - Obtain the item/cash specified below at the end of the trolley animation
    ['Cash'] = false, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "goldbar", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 3, max = 5}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of gold bars you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.Rewarddiamond = {
    ["ObtainPerPickup"] = true, -- Obtain the specified items below per diamond box pickup from the trolley, false - Obtain the item/cash specified below at the end of the trolley animation
    ['Cash'] = false, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "diamond", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 1, max = 1}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of diamonds you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.LootTables = {
    ["RockfordHills"] = {
        ['Table'] = {
            Name = 'Table', -- !!! Do not touch !!!
            Coords = vector3(-1212.48, -341.86, 37.63),
            Drawtext = vector3(-1211.82, -341.48, 37.78),
            Heading = 293.83,
            Icon = 'fas fa-coins',
            Distance = 1.5, -- Target Distance
            Size = 0.5, -- Circle Zone size
        },
    },
    ["Legion"] = {
        ['Table'] = {
            Name = 'Table', -- !!! Do not touch !!!
            Coords = vector3(141.94, -1048.51, 29.22),
            Drawtext = vector3(142.51, -1048.67, 29.37),
            Heading = 254.43,
            Icon = 'fas fa-coins',
            Distance = 1.5, -- Target Distance
            Size = 0.5, -- Circle Zone size
        },
    },

    ["Burton"] = {
        ['Table'] = {
            Name = 'Table', -- !!! Do not touch !!!
            Coords = vector3(-358.76, -57.79, 48.89),
            Drawtext = vector3(-357.94, -58.13, 49.04),
            Heading = 250.65,
            Icon = 'fas fa-coins',
            Distance = 1.5, -- Target Distance
            Size = 0.5, -- Circle Zone size
        },
    },

    ["Alta"] = {
        ['Table'] = {
            Name = 'Table', -- !!! Do not touch !!!
            Coords = vector3(306.31, -286.88, 54.02),
            Drawtext = vector3(306.91, -287.01, 54.16),
            Heading = 251.26,
            Icon = 'fas fa-coins',
            Distance = 1.5, -- Target Distance
            Size = 0.5, -- Circle Zone size
        },
    },
    ["GrandSenoraDesert"] = {
        ['Table'] = {
            Name = 'Table', -- !!! Do not touch !!!
            Coords = vector3(1179.81, 2716.82, 37.94),
            Drawtext = vector3(1179.25, 2716.81, 38.09),
            Heading = 91.59,
            Icon = 'fas fa-coins',
            Distance = 1.5, -- Target Distance
            Size = 0.5, -- Circle Zone size
        },
    },

    ["BanhamCanyon"] = {
        ['Table'] = {
            Name = 'Table', -- !!! Do not touch !!!
            Coords = vector3(-2952.77, 477.67, 15.6),
            Drawtext = vector3(-2952.75, 478.38, 15.7),
            Heading = 358.21,
            Icon = 'fas fa-coins',
            Distance = 1.5, -- Target Distance
            Size = 0.5, -- Circle Zone size
        },
    },
}

Config.Trollys = {
    ["RockfordHills"] = {
        ['Trolly1'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly1', -- !!! Do not touch !!!
            Coords = vector3(-1205.74, -337.59, 37.78),
            Drawtext = vector3(-1206.17, -338.25, 37.78),
            Heading = 152.26,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly2'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly2', -- !!! Do not touch !!!
            Coords = vector3(-1205.13, -338.87, 37.78),
            Drawtext = vector3(-1205.62, -338.74, 37.78),
            Heading =  75.32,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly3'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly3', -- !!! Do not touch !!!
            Coords = vector3(-1213.11, -343.18, 37.78),
            Drawtext = vector3(-1212.56, -342.94, 37.78),
            Heading = 295.62,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly4'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly4', -- !!! Do not touch !!!
            Coords = vector3(-1213.82, -341.61, 37.78),
            Drawtext = vector3(-1213.36, -341.39, 37.78),
            Heading = 297.9,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
    },

    ["Legion"] = {
        ['Trolly1'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly1', -- !!! Do not touch !!!
            Coords = vector3(149.61, -1050.4, 29.37),
            Drawtext = vector3(149.2, -1050.51, 29.37),
            Heading = 105.26,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly2'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly2', -- !!! Do not touch !!!
            Coords = vector3(149.02, -1051.85, 29.37),
            Drawtext = vector3(148.77, -1051.17, 29.36),
            Heading = 30.02,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly3'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly3', -- !!! Do not touch !!!
            Coords = vector3(140.46, -1048.97, 29.37),
            Drawtext = vector3(140.96, -1049.14, 29.37),
            Heading = 249.07,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly4'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly4', -- !!! Do not touch !!!
            Coords = vector3(141.22, -1047.22, 29.37),
            Drawtext = vector3(141.65, -1047.43, 29.37),
            Heading =  248.78,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
    },

    ["Burton"] = {
        ['Trolly1'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly1', -- !!! Do not touch !!!
            Coords = vector3(-351.0, -59.51, 49.04),
            Drawtext = vector3(-351.35, -59.61, 49.04),
            Heading = 107.99,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly2'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly2', -- !!! Do not touch !!!
            Coords = vector3(-351.48, -61.29, 49.04),
            Drawtext = vector3(-351.68, -60.94, 49.04),
            Heading = 33.27,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly3'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly3', -- !!! Do not touch !!!
            Coords = vector3(-360.19, -58.24, 49.04),
            Drawtext = vector3(-359.85, -58.34, 49.04),
            Heading = 251.45,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly4'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly4', -- !!! Do not touch !!!
            Coords = vector3(-359.63, -56.5, 49.04),
            Drawtext = vector3(-359.17, -56.64, 49.04),
            Heading = 248.21,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
    },

    ["Alta"] = {
        ['Trolly1'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly1', -- !!! Do not touch !!!
            Coords = vector3(314.13, -288.69, 54.16),
            Drawtext = vector3(313.61, -288.79, 54.16),
            Heading = 108.41,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly2'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly2', -- !!! Do not touch !!!
            Coords = vector3(313.55, -290.46, 54.16),
            Drawtext = vector3(313.37, -290.14, 54.16),
            Heading = 39.26,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly3'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly3', -- !!! Do not touch !!!
            Coords = vector3(304.85, -287.3, 54.16),
            Drawtext = vector3(305.25, -287.49, 54.16),
            Heading = 253.59,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly4'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly4', -- !!! Do not touch !!!
            Coords = vector3(305.41, -285.58, 54.16),
            Drawtext = vector3(305.75, -285.74, 54.16),
            Heading = 250.36,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
    },

    ["GrandSenoraDesert"] = {
        ['Trolly1'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly1', -- !!! Do not touch !!!
            Coords = vector3(1171.92, 2715.93, 38.09),
            Drawtext = vector3(1172.2, 2716.09, 38.09),
            Heading = 303.55,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly2'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly2', -- !!! Do not touch !!!
            Coords = vector3(1171.76, 2717.65, 38.09),
            Drawtext = vector3(1172.02, 2717.38, 38.09),
            Heading = 225.79,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly3'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly3', -- !!! Do not touch !!!
            Coords = vector3(1181.03, 2717.66, 38.09),
            Drawtext = vector3(1180.58, 2717.69, 38.09),
            Heading = 88.6,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly4'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly4', -- !!! Do not touch !!!
            Coords = vector3(1181.09, 2716.0, 38.09),
            Drawtext = vector3(1180.69, 2715.98, 38.09),
            Heading = 95.4,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
    },

    ["BanhamCanyon"] = {
        ['Trolly1'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly1', -- !!! Do not touch !!!
            Coords = vector3(-2953.36, 485.77, 15.7),
            Drawtext = vector3(-2953.09, 485.32, 15.7),
            Heading = 214.78,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly2'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly2', -- !!! Do not touch !!!
            Coords = vector3(-2951.48, 485.73, 15.7),
            Drawtext = vector3(-2951.77, 485.43, 15.7),
            Heading = 138.97,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly3'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly3', -- !!! Do not touch !!!
            Coords = vector3(-2951.96, 476.4, 15.7),
            Drawtext = vector3(-2951.95, 476.9, 15.7),
            Heading = 356.62,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
        ['Trolly4'] = {
            Type = "cash", -- Type of loot (cash/gold/diamond)
            Name = 'Trolly4', -- !!! Do not touch !!!
            Coords = vector3(-2953.66, 476.53, 15.7),
            Drawtext = vector3(-2953.75, 476.94, 15.7),
            Heading = 355.81,
            Icon = 'fas fa-dollar-sign', -- Icon
            Distance = 1.0, -- Target distance
            Size = 0.5, -- Target size
        },
    },
}

Config.Employees = {
    [1] = {first = "Olivia", last = "Roberts", residence = "Hawaii", age = "27"},
    [2] = {first = "Ethan", last = "Parker", residence = "Kentucky", age = "34"},
    [3] = {first = "Sophia", last = "Adams", residence = "Mississippi", age = "45"},
    [4] = {first = "Benjamin", last = "Taylor", residence = "Montana", age = "19"},
    [5] = {first = "Ava", last = "Wright", residence = "SouthDakota", age = "31"},
    [6] = {first = "Liam", last = "Davis", residence = "Arizona", age = "40"},
    [7] = {first = "Emma", last = "Wilson", residence = "Connecticut", age = "22"},
    [8] = {first = "Noah", last = "Martinez", residence = "WestVirginia", age = "29"},
    [9] = {first = "Isabella", last = "Anderson", residence = "Delaware", age = "36"},
    [10] = {first = "Alexander", last = "Nelson", residence = "Maryland", age = "50"},
    [11] = {first = "Mia", last = "Johnson", residence = "Iowa", age = "25"},
    [12] = {first = "Elijah", last = "Garcia", residence = "NewMexico", age = "33"},
    [13] = {first = "Sofia", last = "Clark", residence = "Vermont", age = "28"},
    [14] = {first = "William", last = "Brown", residence = "Minnesota", age = "42"},
    [15] = {first = "Charlotte", last = "Harris", residence = "Tennessee", age = "37"},
    [16] = {first = "James", last = "Turner", residence = "Wisconsin", age = "30"},
    [17] = {first = "Amelia", last = "Smith", residence = "NorthDakota", age = "23"},
    [18] = {first = "Liam", last = "Anderson", residence = "Texas", age = "26"},
    [19] = {first = "Olivia", last = "Walker", residence = "Virginia", age = "39"},
    [20] = {first = "Emma", last = "Roberts", residence = "Louisiana", age = "32"},
    [21] = {first = "Ethan", last = "Johnson", residence = "Alabama", age = "33"},
    [22] = {first = "Sophia", last = "Garcia", residence = "Alaska", age = "42"},
    [23] = {first = "Benjamin", last = "Lee", residence = "Arkansas", age = "19"},
    [24] = {first = "Ava", last = "Anderson", residence = "California", age = "30"},
    [25] = {first = "Liam", last = "Williams", residence = "Colorado", age = "40"},
    [26] = {first = "Emma", last = "Brown", residence = "Florida", age = "24"},
    [27] = {first = "Noah", last = "Davis", residence = "Georgia", age = "29"},
    [28] = {first = "Isabella", last = "Taylor", residence = "Idaho", age = "35"},
    [29] = {first = "Alexander", last = "Harris", residence = "Illinois", age = "47"},
    [30] = {first = "Mia", last = "Moore", residence = "Indiana", age = "26"},
    [31] = {first = "Elijah", last = "Clark", residence = "Kansas", age = "39"},
    [32] = {first = "Sofia", last = "Martinez", residence = "Iowa", age = "28"},
    [33] = {first = "William", last = "Turner", residence = "Kentucky", age = "41"},
    [34] = {first = "Charlotte", last = "Johnson", residence = "Louisiana", age = "31"},
    [35] = {first = "James", last = "Anderson", residence = "Maine", age = "27"},
    [36] = {first = "Amelia", last = "Walker", residence = "Maryland", age = "23"},
    [37] = {first = "Liam", last = "Smith", residence = "Massachusetts", age = "36"},
    [38] = {first = "Olivia", last = "Taylor", residence = "Michigan", age = "44"},
    [39] = {first = "Emma", last = "Parker", residence = "Minnesota", age = "32"},
    [40] = {first = "Noah", last = "Garcia", residence = "Mississippi", age = "25"},
    [41] = {first = "Sophia", last = "Moore", residence = "Missouri", age = "38"},
    [42] = {first = "Alexander", last = "Davis", residence = "Nebraska", age = "49"},
    [43] = {first = "Ava", last = "Brown", residence = "Nevada", age = "29"},
    [44] = {first = "Benjamin", last = "Johnson", residence = "NewHampshire", age = "21"},
    [45] = {first = "Ethan", last = "Martinez", residence = "NewJersey", age = "37"},
    [46] = {first = "Olivia", last = "Clark", residence = "NewMexico", age = "43"},
    [47] = {first = "Sophia", last = "Williams", residence = "NewYork", age = "28"},
    [48] = {first = "Liam", last = "Turner", residence = "NorthCarolina", age = "30"},
    [49] = {first = "Emma", last = "Walker", residence = "NorthDakota", age = "26"},
    [50] = {first = "Oliver", last = "Wilson", residence = "Ohio", age = "33"},
    [51] = {first = "Lily", last = "Morris", residence = "Georgia", age = "28"},
    [52] = {first = "Carter", last = "Smith", residence = "Florida", age = "32"},
    [53] = {first = "Ghazi", last = "Bekker", residence = "NorthCarolina", age = "41"},
    [54] = {first = "Henry", last = "Baker", residence = "Texas", age = "41"},
    [55] = {first = "Ella", last = "Foster", residence = "California", age = "29"},
    [56] = {first = "Aiden", last = "Gomez", residence = "NewYork", age = "27"},
    [57] = {first = "Scarlett", last = "Rivera", residence = "Arizona", age = "36"},
    [58] = {first = "Logan", last = "Wright", residence = "Montana", age = "33"},
    [59] = {first = "Aria", last = "Mitchell", residence = "Kansas", age = "23"},
    [60] = {first = "Gabriel", last = "Sanchez", residence = "Colorado", age = "30"},
    [61] = {first = "Madison", last = "Lopez", residence = "Alabama", age = "26"},
    [62] = {first = "Wyatt", last = "Turner", residence = "Louisiana", age = "35"},
    [63] = {first = "Luna", last = "Ward", residence = "Maryland", age = "38"},
    [64] = {first = "Owen", last = "Green", residence = "Minnesota", age = "31"},
    [65] = {first = "Avery", last = "Coleman", residence = "NorthDakota", age = "29"},
    [66] = {first = "Jack", last = "Jenkins", residence = "Michigan", age = "43"},
    [67] = {first = "Isabelle", last = "Russell", residence = "NewMexico", age = "22"},
    [68] = {first = "Luke", last = "Stewart", residence = "SouthDakota", age = "26"},
    [69] = {first = "Emily", last = "White", residence = "Wisconsin", age = "31"},
    [70] = {first = "Mason", last = "Robinson", residence = "Tennessee", age = "34"},
    [71] = {first = "Zoey", last = "Gonzalez", residence = "Delaware", age = "25"},
    [72] = {first = "Sebastian", last = "Lee", residence = "Iowa", age = "39"},
    [73] = {first = "Addison", last = "Cooper", residence = "Mississippi", age = "28"},
    [74] = {first = "Eli", last = "Hernandez", residence = "NewJersey", age = "30"},
    [75] = {first = "Natalie", last = "Phillips", residence = "Ohio", age = "37"},
    [76] = {first = "Grayson", last = "Reed", residence = "Indiana", age = "33"},
    [77] = {first = "Hannah", last = "Price", residence = "Maine", age = "24"},
    [78] = {first = "Caleb", last = "Simmons", residence = "Kentucky", age = "29"},
    [79] = {first = "Elizabeth", last = "Barnes", residence = "WestVirginia", age = "39"},
    [80] = {first = "Levi", last = "Ross", residence = "Alaska", age = "28"},
    [81] = {first = "Chloe", last = "Butler", residence = "Arkansas", age = "36"},
    [82] = {first = "Andrew", last = "Fisher", residence = "Connecticut", age = "31"},
    [83] = {first = "Eleanor", last = "Griffin", residence = "Hawaii", age = "30"},
    [84] = {first = "Lincoln", last = "Hart", residence = "Nebraska", age = "35"},
    [85] = {first = "Hazel", last = "Hawkins", residence = "Idaho", age = "27"},
    [86] = {first = "Ezra", last = "Washington", residence = "Missouri", age = "32"},
    [87] = {first = "Penelope", last = "Morgan", residence = "NewHampshire", age = "26"},
    [88] = {first = "Daniel", last = "Hughes", residence = "Illinois", age = "29"},
    [89] = {first = "Aubrey", last = "Diaz", residence = "Virginia", age = "33"},
    [90] = {first = "Mateo", last = "Bell", residence = "Nevada", age = "31"},
    [91] = {first = "Samantha", last = "Hayes", residence = "Wisconsin", age = "26"},
    [92] = {first = "Adrian", last = "Kim", residence = "Oregon", age = "38"},
    [93] = {first = "Zoe", last = "Harrison", residence = "NorthDakota", age = "30"},
    [94] = {first = "Nolan", last = "Peterson", residence = "Kansas", age = "29"},
    [95] = {first = "Ariana", last = "Gardner", residence = "Iowa", age = "24"},
    [96] = {first = "Dominic", last = "Cole", residence = "SouthCarolina", age = "31"},
    [97] = {first = "Riley", last = "Campbell", residence = "Oklahoma", age = "28"},
    [98] = {first = "Brooklyn", last = "Sullivan", residence = "RhodeIsland", age = "29"},
    [99] = {first = "Elias", last = "Perry", residence = "Louisiana", age = "37"},
    [100] = {first = "Layla", last = "Powell", residence = "Utah", age = "26"},
    [101] = {first = "Max", last = "Rossi", residence = "Vermont", age = "25"},
    [102] = {first = "Bella", last = "Gutierrez", residence = "Michigan", age = "28"},
    [103] = {first = "Adam", last = "Ward", residence = "Mississippi", age = "31"},
    [104] = {first = "Stella", last = "Chapman", residence = "Connecticut", age = "27"},
    [105] = {first = "Ian", last = "Medina", residence = "Arizona", age = "33"},
    [106] = {first = "Violet", last = "Meyer", residence = "Montana", age = "29"},
    [107] = {first = "Lucas", last = "Zhang", residence = "NorthCarolina", age = "35"},
    [108] = {first = "Hannah", last = "Lin", residence = "Texas", age = "32"},
    [109] = {first = "Nathan", last = "Molina", residence = "California", age = "30"},
    [110] = {first = "Paisley", last = "Reyes", residence = "NewYork", age = "26"},
    [111] = {first = "Evan", last = "Ibrahim", residence = "Alabama", age = "29"},
    [112] = {first = "Lila", last = "Garcia", residence = "Louisiana", age = "28"},
    [113] = {first = "Miles", last = "Larson", residence = "Maryland", age = "31"},
    [114] = {first = "Ariana", last = "Khan", residence = "Missouri", age = "27"},
    [115] = {first = "Caleb", last = "Nelson", residence = "SouthDakota", age = "33"},
    [116] = {first = "Nova", last = "Chen", residence = "NorthDakota", age = "25"},
    [117] = {first = "Aaron", last = "Li", residence = "Wisconsin", age = "30"},
    [118] = {first = "Brielle", last = "Gomez", residence = "Tennessee", age = "29"},
    [119] = {first = "Hudson", last = "Roberts", residence = "Delaware", age = "36"},
    [120] = {first = "Ayla", last = "Wright", residence = "Iowa", age = "27"},
    [121] = {first = "Jace", last = "Adams", residence = "Mississippi", age = "32"},
    [122] = {first = "Sophie", last = "Hall", residence = "Nebraska", age = "31"},
    [123] = {first = "Caden", last = "Rivera", residence = "NorthDakota", age = "24"},
    [124] = {first = "Nora", last = "Hernandez", residence = "Kansas", age = "29"},
    [125] = {first = "Grayson", last = "Gonzalez", residence = "Virginia", age = "30"},
    [126] = {first = "Elaina", last = "Bennett", residence = "Nevada", age = "28"},
    [127] = {first = "Harrison", last = "Sanchez", residence = "Wisconsin", age = "33"},
    [128] = {first = "Skylar", last = "Morris", residence = "Oregon", age = "27"},
    [129] = {first = "Theo", last = "Perez", residence = "Washington", age = "31"},
    [130] = {first = "Mila", last = "Cook", residence = "Indiana", age = "26"},
    [131] = {first = "Beckett", last = "Jackson", residence = "NewHampshire", age = "29"},
    [132] = {first = "Savannah", last = "Ward", residence = "Illinois", age = "28"},
    [133] = {first = "Ezra", last = "Barnes", residence = "Ohio", age = "33"},
    [134] = {first = "Ruby", last = "Wright", residence = "Oklahoma", age = "26"},
    [135] = {first = "Oscar", last = "Foster", residence = "RhodeIsland", age = "31"},
    [136] = {first = "Luna", last = "Jenkins", residence = "Arkansas", age = "29"},
    [137] = {first = "Carter", last = "Cruz", residence = "Minnesota", age = "32"},
    [138] = {first = "Clara", last = "Hamilton", residence = "WestVirginia", age = "27"},
    [139] = {first = "Micah", last = "Sullivan", residence = "Alaska", age = "30"},
    [140] = {first = "Summer", last = "Bell", residence = "Hawaii", age = "28"},
    [141] = {first = "Tristan", last = "Kim", residence = "Colorado", age = "33"},
    [142] = {first = "Valentina", last = "Peterson", residence = "Kentucky", age = "25"},
    [143] = {first = "Easton", last = "Gardner", residence = "Michigan", age = "29"},
    [144] = {first = "Maddison", last = "Rossi", residence = "Mississippi", age = "30"},
    [145] = {first = "August", last = "Diaz", residence = "Missouri", age = "26"},
    [146] = {first = "Remi", last = "Hayes", residence = "NewMexico", age = "32"},
    [147] = {first = "Hayden", last = "Washington", residence = "NewYork", age = "27"},
    [148] = {first = "Brynlee", last = "Martin", residence = "NorthCarolina", age = "30"},
    [149] = {first = "Maximus", last = "Lin", residence = "Texas", age = "28"},
    [150] = {first = "Evangeline", last = "Gomez", residence = "California", age = "33"},
    [151] = {first = "Roman", last = "Sanchez", residence = "Louisiana", age = "29"},
    [152] = {first = "Emery", last = "Young", residence = "Iowa", age = "28"},
    [153] = {first = "Sawyer", last = "Allen", residence = "NorthDakota", age = "33"},
    [154] = {first = "Jordyn", last = "Fisher", residence = "NewYork", age = "26"},
    [155] = {first = "Ryder", last = "Gomez", residence = "Florida", age = "31"},
    [156] = {first = "Emerson", last = "Harris", residence = "Arizona", age = "29"},
    [157] = {first = "Elliot", last = "Williams", residence = "Montana", age = "32"},
    [158] = {first = "Harmony", last = "Rivera", residence = "NorthCarolina", age = "27"},
    [159] = {first = "Phoenix", last = "Sullivan", residence = "Colorado", age = "30"},
    [160] = {first = "Lennon", last = "Martinez", residence = "California", age = "28"},
    [161] = {first = "Kieran", last = "Lee", residence = "NewJersey", age = "33"},
    [162] = {first = "Cameron", last = "Clark", residence = "Missouri", age = "26"},
    [163] = {first = "Rowan", last = "Davis", residence = "Ohio", age = "31"},
    [164] = {first = "Skyler", last = "Morris", residence = "Illinois", age = "29"},
    [165] = {first = "Zion", last = "Perry", residence = "Florida", age = "32"},
    [166] = {first = "Sage", last = "Parker", residence = "Georgia", age = "27"},
    [167] = {first = "Marley", last = "Turner", residence = "Indiana", age = "30"},
    [168] = {first = "Archer", last = "Nelson", residence = "Kentucky", age = "28"},
    [169] = {first = "Lyric", last = "Smith", residence = "Louisiana", age = "33"},
    [170] = {first = "Elliott", last = "Allen", residence = "Maine", age = "26"},
    [171] = {first = "Olivia", last = "Roberts", residence = "Hawaii", age = "27"},
    [172] = {first = "Ethan", last = "Parker", residence = "Kentucky", age = "34"},
    [173] = {first = "Sophia", last = "Adams", residence = "Mississippi", age = "45"},
    [174] = {first = "Benjamin", last = "Taylor", residence = "Montana", age = "19"},
    [175] = {first = "Ava", last = "Wright", residence = "SouthDakota", age = "31"},
    [176] = {first = "Liam", last = "Davis", residence = "Arizona", age = "40"},
    [177] = {first = "Emma", last = "Wilson", residence = "Connecticut", age = "22"},
    [178] = {first = "Noah", last = "Martinez", residence = "WestVirginia", age = "29"},
    [179] = {first = "Isabella", last = "Anderson", residence = "Delaware", age = "36"},
    [180] = {first = "Alexander", last = "Nelson", residence = "Maryland", age = "50"},
    [181] = {first = "Mia", last = "Johnson", residence = "Iowa", age = "25"},
    [182] = {first = "Elijah", last = "Garcia", residence = "NewMexico", age = "33"},
    [183] = {first = "Sofia", last = "Clark", residence = "Vermont", age = "28"},
    [184] = {first = "William", last = "Brown", residence = "Minnesota", age = "42"},
    [185] = {first = "Charlotte", last = "Harris", residence = "Tennessee", age = "37"},
    [186] = {first = "James", last = "Turner", residence = "Wisconsin", age = "30"},
    [187] = {first = "Amelia", last = "Smith", residence = "NorthDakota", age = "23"},
    [188] = {first = "Liam", last = "Anderson", residence = "Texas", age = "26"},
    [189] = {first = "Olivia", last = "Walker", residence = "Virginia", age = "39"},
    [190] = {first = "Emma", last = "Roberts", residence = "Louisiana", age = "32"},
    [191] = {first = "Ethan", last = "Johnson", residence = "Alabama", age = "33"},
    [192] = {first = "Sophia", last = "Garcia", residence = "Alaska", age = "42"},
    [193] = {first = "Benjamin", last = "Lee", residence = "Arkansas", age = "19"},
    [194] = {first = "Ava", last = "Anderson", residence = "California", age = "30"},
    [195] = {first = "Liam", last = "Williams", residence = "Colorado", age = "40"},
    [196] = {first = "Emma", last = "Brown", residence = "Florida", age = "24"},
    [197] = {first = "Noah", last = "Davis", residence = "Georgia", age = "29"},
    [198] = {first = "Isabella", last = "Taylor", residence = "Idaho", age = "35"},
    [199] = {first = "Alexander", last = "Harris", residence = "Illinois", age = "47"},
    [200] = {first = "Mia", last = "Moore", residence = "Indiana", age = "26"},
    [201] = {first = "Elijah", last = "Clark", residence = "Kansas", age = "39"},
    [202] = {first = "Sofia", last = "Martinez", residence = "Iowa", age = "28"},
    [203] = {first = "William", last = "Turner", residence = "Kentucky", age = "41"},
    [204] = {first = "Charlotte", last = "Johnson", residence = "Louisiana", age = "31"},
    [205] = {first = "James", last = "Anderson", residence = "Maine", age = "27"},
    [206] = {first = "Amelia", last = "Walker", residence = "Maryland", age = "23"},
    [207] = {first = "Liam", last = "Smith", residence = "Massachusetts", age = "36"},
    [208] = {first = "Olivia", last = "Taylor", residence = "Michigan", age = "44"},
    [209] = {first = "Emma", last = "Parker", residence = "Minnesota", age = "32"},
    [210] = {first = "Noah", last = "Garcia", residence = "Mississippi", age = "25"},
    [211] = {first = "Sophia", last = "Moore", residence = "Missouri", age = "38"},
    [212] = {first = "Alexander", last = "Davis", residence = "Nebraska", age = "49"},
    [213] = {first = "Ava", last = "Brown", residence = "Nevada", age = "29"},
    [214] = {first = "Benjamin", last = "Johnson", residence = "NewHampshire", age = "21"},
    [215] = {first = "Ethan", last = "Martinez", residence = "NewJersey", age = "37"},
    [216] = {first = "Olivia", last = "Clark", residence = "NewMexico", age = "43"},
    [217] = {first = "Sophia", last = "Williams", residence = "NewYork", age = "28"},
    [218] = {first = "Liam", last = "Turner", residence = "NorthCarolina", age = "30"},
    [219] = {first = "Emma", last = "Walker", residence = "NorthDakota", age = "26"},
    [220] = {first = "Oliver", last = "Wilson", residence = "Ohio", age = "33"},
    [221] = {first = "Lily", last = "Morris", residence = "Georgia", age = "28"},
    [222] = {first = "Carter", last = "Smith", residence = "Florida", age = "32"},
    [223] = {first = "Grace", last = "Allen", residence = "NorthCarolina", age = "24"},
    [224] = {first = "Sophia", last = "Nguyen", residence = "Florida", age = "28"},
    [225] = {first = "Ella", last = "Foster", residence = "California", age = "29"},
    [226] = {first = "Aiden", last = "Gomez", residence = "NewYork", age = "27"},
    [227] = {first = "Scarlett", last = "Rivera", residence = "Arizona", age = "36"},
    [228] = {first = "Logan", last = "Wright", residence = "Montana", age = "33"},
    [229] = {first = "Aria", last = "Mitchell", residence = "Kansas", age = "23"},
    [230] = {first = "Gabriel", last = "Sanchez", residence = "Colorado", age = "30"},
    [231] = {first = "Madison", last = "Lopez", residence = "Alabama", age = "26"},
    [232] = {first = "Wyatt", last = "Turner", residence = "Louisiana", age = "35"},
    [233] = {first = "Luna", last = "Ward", residence = "Maryland", age = "38"},
    [234] = {first = "Owen", last = "Green", residence = "Minnesota", age = "31"},
    [235] = {first = "Avery", last = "Coleman", residence = "NorthDakota", age = "29"},
    [236] = {first = "Jack", last = "Jenkins", residence = "Michigan", age = "43"},
    [237] = {first = "Isabelle", last = "Russell", residence = "NewMexico", age = "22"},
    [238] = {first = "Luke", last = "Stewart", residence = "SouthDakota", age = "26"},
    [239] = {first = "Emily", last = "White", residence = "Wisconsin", age = "31"},
    [240] = {first = "Mason", last = "Robinson", residence = "Tennessee", age = "34"},
    [241] = {first = "Zoey", last = "Gonzalez", residence = "Delaware", age = "25"},
    [242] = {first = "Sebastian", last = "Lee", residence = "Iowa", age = "39"},
    [243] = {first = "Addison", last = "Cooper", residence = "Mississippi", age = "28"},
    [244] = {first = "Eli", last = "Hernandez", residence = "NewJersey", age = "30"},
    [245] = {first = "Natalie", last = "Phillips", residence = "Ohio", age = "37"},
    [246] = {first = "Grayson", last = "Reed", residence = "Indiana", age = "33"},
    [247] = {first = "Hannah", last = "Price", residence = "Maine", age = "24"},
    [248] = {first = "Caleb", last = "Simmons", residence = "Kentucky", age = "29"},
    [249] = {first = "Elizabeth", last = "Barnes", residence = "WestVirginia", age = "39"},
    [250] = {first = "Levi", last = "Ross", residence = "Alaska", age = "28"},
    [251] = {first = "Chloe", last = "Butler", residence = "Arkansas", age = "36"},
    [252] = {first = "Andrew", last = "Fisher", residence = "Connecticut", age = "31"},
    [253] = {first = "Eleanor", last = "Griffin", residence = "Hawaii", age = "30"},
    [254] = {first = "Lincoln", last = "Hart", residence = "Nebraska", age = "35"},
    [255] = {first = "Hazel", last = "Hawkins", residence = "Idaho", age = "27"},
    [256] = {first = "Ezra", last = "Washington", residence = "Missouri", age = "32"},
    [257] = {first = "Penelope", last = "Morgan", residence = "NewHampshire", age = "26"},
    [258] = {first = "Daniel", last = "Hughes", residence = "Illinois", age = "29"},
    [259] = {first = "Aubrey", last = "Diaz", residence = "Virginia", age = "33"},
    [260] = {first = "Mateo", last = "Bell", residence = "Nevada", age = "31"},
    [261] = {first = "Samantha", last = "Hayes", residence = "Wisconsin", age = "26"},
    [262] = {first = "Adrian", last = "Kim", residence = "Oregon", age = "38"},
    [263] = {first = "Zoe", last = "Harrison", residence = "NorthDakota", age = "30"},
    [264] = {first = "Nolan", last = "Peterson", residence = "Kansas", age = "29"},
    [265] = {first = "Ariana", last = "Gardner", residence = "Iowa", age = "24"},
    [266] = {first = "Dominic", last = "Cole", residence = "SouthCarolina", age = "31"},
    [267] = {first = "Riley", last = "Campbell", residence = "Oklahoma", age = "28"},
    [268] = {first = "Brooklyn", last = "Sullivan", residence = "RhodeIsland", age = "29"},
    [269] = {first = "Elias", last = "Perry", residence = "Louisiana", age = "37"},
    [270] = {first = "Layla", last = "Powell", residence = "Utah", age = "26"},
    [271] = {first = "Max", last = "Rossi", residence = "Vermont", age = "25"},
    [272] = {first = "Bella", last = "Gutierrez", residence = "Michigan", age = "28"},
    [273] = {first = "Adam", last = "Ward", residence = "Mississippi", age = "31"},
    [274] = {first = "Stella", last = "Chapman", residence = "Connecticut", age = "27"},
    [275] = {first = "Ian", last = "Medina", residence = "Arizona", age = "33"},
    [276] = {first = "Violet", last = "Meyer", residence = "Montana", age = "29"},
    [277] = {first = "Evan", last = "Woods", residence = "NewYork", age = "36"},
    [278] = {first = "Lucy", last = "Ferguson", residence = "California", age = "27"},
    [279] = {first = "Axel", last = "Porter", residence = "Alabama", age = "31"},
    [280] = {first = "Brianna", last = "Hunt", residence = "WestVirginia", age = "30"},
    [281] = {first = "Miles", last = "Lawrence", residence = "Kansas", age = "25"},
    [282] = {first = "Nora", last = "Shaw", residence = "Maine", age = "34"},
    [283] = {first = "Hudson", last = "Sims", residence = "Florida", age = "28"},
    [284] = {first = "Caroline", last = "Ortega", residence = "NorthCarolina", age = "26"},
    [285] = {first = "Micah", last = "Jennings", residence = "Nebraska", age = "29"},
    [286] = {first = "Savannah", last = "Ross", residence = "Nevada", age = "31"},
    [287] = {first = "Jace", last = "Wheeler", residence = "Louisiana", age = "27"},
    [288] = {first = "Aaliyah", last = "Holt", residence = "Utah", age = "32"},
    [289] = {first = "Blake", last = "Douglas", residence = "Vermont", age = "24"},
    [290] = {first = "Everly", last = "Barton", residence = "Michigan", age = "30"},
    [291] = {first = "Kai", last = "Yu", residence = "Mississippi", age = "25"},
    [292] = {first = "Genesis", last = "Morrison", residence = "Connecticut", age = "28"},
    [293] = {first = "Tristan", last = "Newton", residence = "Arizona", age = "35"},
    [294] = {first = "Valentina", last = "Francis", residence = "Montana", age = "31"},
    [295] = {first = "Maddox", last = "Sherman", residence = "NewYork", age = "29"},
    [296] = {first = "Isla", last = "Silva", residence = "California", age = "34"},
    [297] = {first = "Emmett", last = "Hanson", residence = "Alabama", age = "27"},
    [298] = {first = "Delilah", last = "Patterson", residence = "WestVirginia", age = "30"},
    [299] = {first = "Cole", last = "Banks", residence = "Kansas", age = "26"},
    [300] = {first = "Kate", last = "Fitzgerald", residence = "Maine", age = "31"},
}

Config.MaleNoGloves = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [16] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true}
Config.FemaleNoGloves = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true}

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- |   |   |   |   |   |   |   |   |   |   |    DO NOT TOUCH ANYTHING UNDER THIS LINE  |   |   |   |   |   |   |   |   |   |   |    |
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

Config.DoorStates = { -- Sync
    ["RockfordHills"] = {},
    ["Legion"] = {},
    ["Burton"] = {},
    ["Alta"] = {},
    ["GrandSenoraDesert"] = {},
    ["BanhamCanyon"] = {},
}

Config.DoorList = {
    ["RockfordHills"] = {
            -- First Door
        {
            objYaw = 117.42,
            objCoords = vector3(-1207.92, -333.24, 37.93),
            objHash = 1138019403,
            locked = true,
        },
            -- Second Door
        {
            objYaw = 206.61,
            objCoords = vector3(-1209.52, -335.12, 37.93),
            objHash = 1138019403,
            locked = true,
        },
    },

    ["Legion"] = {
            -- First Door
        {
            objYaw = 69.85,
            objCoords = vector3(151.25, -1045.92, 29.52),
            objHash = 1138019403,
            locked = true,
        },
            -- Second Door
        {
            objYaw = 159.85,
            objCoords = vector3(148.79, -1046.03, 29.52),
            objHash = 1138019403,
            locked = true,
        },
    },

    ["Burton"] = {
            -- First Door
        {
            objYaw = 70.86,
            objCoords = vector3(-349.49, -55.07, 49.19),
            objHash = 1138019403,
            locked = true,
        },
            -- Second Door
        {
            objYaw = 161.27,
            objCoords = vector3(-351.95, -55.22, 49.19),
            objHash = 1138019403,
            locked = true,
        },
    },

    ["Alta"] = {
            -- First Door
        {
            objYaw = 69.87,
            objCoords = vector3(315.58, -284.29, 54.31),
            objHash = 1138019403,
            locked = true,
        },
            -- Second Door
        {
            objYaw = 159.87,
            objCoords = vector3(313.12, -284.4, 54.31),
            objHash = 1138019403,
            locked = true,
        },
    },

    ["GrandSenoraDesert"] = {
            -- First Door
        {
            objYaw = 270.0,
            objCoords = vector3(1171.98, 2711.21, 38.24),
            objHash = 1138019403,
            locked = true,
        },
            -- Second Door
        {
            objYaw = 0.0,
            objCoords = vector3(1174.25, 2712.16, 38.24),
            objHash = 1138019403,
            locked = true,
        },
    },

    ["BanhamCanyon"] = {
            -- First Door
        {
            objYaw = 177.54,
            objCoords = vector3(-2958.03, 485.81, 15.85),
            objHash = 1138019403,
            locked = true,
        },
            -- Second Door
        {
            objYaw = 267.54,
            objCoords = vector3(-2957.18, 483.5, 15.85),
            objHash = 1138019403,
            locked = true,
        },
    },
}

Config.Steps = {
    ["RockfordHills"] = {},
    ["Legion"] = {},
    ["Burton"] = {},
    ["Alta"] = {},
    ["GrandSenoraDesert"] = {},
    ["BanhamCanyon"] = {}
}

Config.ExtraSteps = {
    ["RockfordHills"] = {},
    ["Legion"] = {},
    ["Burton"] = {},
    ["Alta"] = {},
    ["GrandSenoraDesert"] = {},
    ["BanhamCanyon"] = {}
}

Config.Tasks = {
    ["RockfordHills"] = {},
    ["Legion"] = {},
    ["Burton"] = {},
    ["Alta"] = {},
    ["GrandSenoraDesert"] = {},
    ["BanhamCanyon"] = {}
}