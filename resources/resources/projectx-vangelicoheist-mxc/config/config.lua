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

    Interaction = 'ox_target', -- ox_target, qb-target, drawtext, interact -- You can type in your custom target name aswell

    TestingMode = false, -- Enable/Disable Testing Mode (No Minigames)
    Disable2PlayerPuzzles = false, -- Disable the 2 player puzzles (Can be used to test the script solo without the need of another player)

    -- Drawtext Options
    DrawtextButton = 38, -- [E] by default
    Drawtext = "OX", -- OLDQB for old qb-drawtext, QB for new qbcore drawtext, OX for ox_lib
    DrawTextZoneSize = vec3(0.8, 0.8, 2), -- Size of the drawtext zone
    DrawTextRotation = 70.0, -- Rotation of the drawtext zone

    DiscordLogStatus = false, -- Choose whether u want to turn on discord logs or not, you need to add a webhook below for it to work
    -- To add your webhook go to opensource -> server, line 1 and add your webhook there

    PoliceJobs = {["police"] = true}, -- Jobs that can receive the dispatch, to add more follow this format: {["police"] = true, ["fbi"] = true}
    MinimumPolice = 7, -- Minimum police required to start the robbery

    ResetHeist = 60, -- (Minutes) Time to reset the heist after a robbery
    AllRobberiesCooldown = true, -- For this to work you need to download projectx-utility from our github
    AutoAlarmOff = 15, -- (Minutes) Time to turn off the alarm automatically
    RequireBag = true, -- If they need a bag to loot

    DisableSmoke = false, -- Disable Smoke effects
    DisableC4Explosion = false, -- Disable C4 explosion effects
    DisableLaserDamage = false, -- Disable Laser Damage
    DisableParticles = true, -- Disable Laser Damage
    SmokeRepetition = 20, -- How many times the smoke will be thrown
    SmokeTime = 10000, -- How long the smoke will last until the next one is thrown

    JobsThatCanOpenShutters = {"storemanager", "police"}, -- Jobs that can open the shutters, after the lockdown is active. To add more follow this format: {"storemanager", "police"}
    Timers = { -- Timers for shutters to completely start shutting down
        ["Silent"] = 25, -- (Seconds) Intervals of how often the shutters will go down, starts when the alarm is triggered (There is a total of 33 intervals, so if you set it to 20, it will take 11 minutes for the shutters to be completely down)
        ["Loud"] = 30, -- (Seconds) Intervals of how often the shutters will go down, starts when the guard is threatened (There is a total of 33 intervals, so if you set it to 30, it will take 16.5 minutes for the shutters to be completely down)
    },

    -- Strike System (Silent = High risk, Higher reward, Loud = No risk, Fixed reward)
    Strikes = 3, -- How many strikes players have to reach before having their reward cut

    -- Progression item (Item that can be obtained at the end of the heist, can be used for the next heist) 
    Bonus = {
        Status = false, -- Enable/Disable Bonus items
        BonusChance = 15, -- Chance of an item being given
        ItemCount = 1, -- How many items can be given from the table below
        Items = { -- You can remove items and add items as you wish
            {Name = "pacificcard", Chance = 30, Amount = {min = 1, max = 1}}, -- Chance(%) -- Amount(Items given from that type)
            {Name = "fleecacard", Chance = 50, Amount = {min = 1, max = 1}},
            {Name = "paletocardone", Chance = 20, Amount = {min = 1, max = 1}},
        },
    },

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

    DispatchLocation = { -- Choose where the alarm gets triggered, only one should be picked, not including ["Loud"] and ["Silent"]
        ["Loud"] = true, -- Hacking the office keypad
        ["Silent"] = false, -- Second computer hack

        ["MainOfficeDoors"] = false, -- Second computer hack
        ["WorkshopDoors"] = false, -- Hacking the computer
        ["Manager"] = false, -- Hacking the computer
        ["Fingerprint"] = false, -- Hacking the computer
    },

    Code = { -- Password for the number pad
        ["Password"] = {min = 10000, max = 99999}, -- Code range
        ["Header"] = "Numberpad Code", -- Change Translation
        ["Content"] = "Code", -- Change Translation
        ["Input"] = {Title = 'Code', Label = 'Numberpad', Description = 'Enter the code', Icon = 'fas fa-lock'}, -- Change Translation
    },

    Props = {
        ["JewelBox1"] = "ex_office_swag_jewelwatch2",
        ["JewelBox2"] = "ex_office_swag_jewelwatch3",
        ["Button"] = "h4_prop_h4_casino_button_01b",
        ["Fingerprint"] = "ch_prop_fingerprint_scanner_01c",
        ["GasGrenade"] = "prop_gas_grenade",
        ["Necklace"] = "h4_prop_h4_necklace_01a",
        ["Fusebox"] = "ch_prop_ch_fuse_box_01a",
        ["Thermite"] = "hei_prop_heist_thermite",
        ["ShuttersKeypad"] = "h4_prop_h4_fingerkeypad_01a",
    },

    -- Durations
    NotificationDuration = 2500, -- Notification duration

    NpcDuration = 6000, -- Npc duration
    SmokeDuration = 6000, -- Smoke grenade duration
    SafeDuration = 6000, -- Panel duration
    PropsDuration = 3000, -- Props duration
    DisplayDuration = 6000, -- Display duration
    GemDuration = 6000, -- Gem duration
    FingerprintDuration = 6000, -- Fingerprint duration
    FuseboxDuration = 6000, -- Fingerprint duration
    KeypadDuration = 6000, -- Keypad duration
}

Config.Npc = {
    ["Security"] = {
        ["Model"] = "u_m_m_jewelsec_01",
        ["Coords"] = vector4(-617.26, -228.15, 37.17, 157.76),
    },
    ["Employee1"] = {
        ["Model"] = "a_f_y_bevhills_04",
        ["Coords"] = vector4(-622.76, -239.36, 37.17, 118.06),
    },
    ["Employee2"] = {
        ["Model"] = "a_f_y_bevhills_04",
        ["Coords"] = vector4(-621.59, -234.93, 37.17, 26.19),
    },
    ["Manager"] = {
        ["Model"] = "a_m_y_smartcaspat_01",
        ["Coords"] = vector4(-613.11, -230.74, 37.17, 298.73),
    },
}

Config.VangelicoSteps = {
    ["SmokeRoof"] = {
        name = "SmokeRoof",
        label = "Throw a smoke grenade",
        coords = vector3(-608.45, -252.97, 52.60),
        drawtext = vector3(-608.98, -253.35, 52.31),
        distance = 1.0,
        icon = "fas fa-bomb",
        size = 0.5,
    },
    ["Security"] = {
        name = "Security",
        label = "Threaten",
        coords = vector3(-617.26, -228.15, 38.57),
        drawtext = vector3(-617.49, -228.9, 38.17),
        distance = 2.0,
        icon = "fas fa-comment-dots",
        size = 0.6,
    },
    ["Employee1"] = {
        name = "Employee1",
        label = "Threaten",
        coords = vector3(-622.76, -239.36, 38.57),
        drawtext = vector3(-623.78, -240.02, 38.17),
        distance = 2.0,
        icon = "fas fa-comment-dots",
        size = 0.6,
    },
    ["Employee2"] = {
        name = "Employee2",
        label = "Threaten",
        coords = vector3(-621.59, -234.93, 38.57),
        drawtext = vector3(-622.14, -233.74, 38.17),
        distance = 2.0,
        icon = "fas fa-comment-dots",
        size = 0.6,
    },
    ["Manager1"] = {
        name = "Manager1",
        label = "Threaten",
        coords = vector3(-613.11, -230.74, 38.17),
        drawtext = vector3(-613.03, -229.45, 38.17),
        distance = 2.0,
        icon = "fas fa-comment-dots",
        size = 0.65,
    },
    ["Manager2"] = {
        name = "Manager2",
        label = "Threaten",
        coords = vector3(-614.44, -226.23, 38.67),
        drawtext = vector3(-613.35, -225.43, 38.17),
        distance = 2.0,
        icon = "fas fa-comment-dots",
        size = 0.7,
    },
    ["TakeFingerprint"] = {
        name = "TakeFingerprint",
        label = "Swab fingerprint",
        coords = vector3(-609.11, -229.16, 38.2),
        drawtext = vector3(-609.85, -229.83, 38.17),
        distance = 0.75,
        icon = "fas fa-fingerprint",
        size = 0.6,
    },
    ["Fingerprint"] = {
        name = "Fingerprint",
        label = "Use fingerprint",
        coords = vector3(-610.91, -227.78, 38.4),
        drawtext = vector3(-611.39, -228.08, 38.17),
        distance = 0.75,
        icon = "fas fa-fingerprint",
        size = 0.4,
    },
    ["Fusebox1"] = {
        name = "Fusebox1",
        label = "Disable fusebox",
        coords = vector3(-612.74, -224.66, 38.43),
        drawtext = vector3(-613.36, -224.94, 38.17),
        distance = 1.0,
        icon = "fab fa-elementor",
        size = 0.5,
    },
    ["Fusebox2"] = {
        name = "Fusebox2",
        label = "Disable fusebox",
        coords = vector3(-619.12, -253.66, 38.16),
        drawtext = vector3(-619.67, -252.73, 38.17),
        distance = 1.0,
        icon = "fab fa-elementor",
        size = 0.5,
    },
    ["Prop1"] = {
        name = "Prop1",
        label = "Pickup box",
        coords = vector3(-620.70, -236.41, 38.11),
        drawtext = vector3(-618.76, -235.99, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Prop2"] = {
        name = "Prop2",
        label = "Pickup box",
        coords = vector3(-618.91, -235.36, 38.11),
        drawtext = vector3(-620.18, -236.88, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Prop3"] = {
        name = "Prop3",
        label = "Pickup box",
        coords = vector3(-621.35, -238.68, 38.11),
        drawtext = vector3(-620.67, -238.51, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Prop4"] = {
        name = "Prop4",
        label = "Pickup box",
        coords = vector3(-620.38, -240.44, 38.11),
        drawtext = vector3(-620.05, -239.63, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Vitrine1"] = {
        name = "Vitrine1",
        label = "Break vitrine",
        coords = vector3(-623.73, -247.52, 38.06),
        drawtext = vector3(-622.96, -247.11, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine2"] = {
        name = "Vitrine2",
        label = "Break vitrine",
        coords = vector3(-624.54, -246.26, 37.81),
        drawtext = vector3(-623.71, -245.66, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine3"] = {
        name = "Vitrine3",
        label = "Break vitrine",
        coords = vector3(-625.24, -244.91, 38.06),
        drawtext = vector3(-624.42, -244.41, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine4"] = {
        name = "Vitrine4",
        label = "Break vitrine",
        coords = vector3(-626.58, -242.6, 38.06),
        drawtext = vector3(-625.73, -242.14, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine5"] = {
        name = "Vitrine5",
        label = "Break vitrine",
        coords = vector3(-627.38, -241.35, 37.81),
        drawtext = vector3(-626.62, -240.82, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine6"] = {
        name = "Vitrine6",
        label = "Break vitrine",
        coords = vector3(-628.07, -240.01, 38.06),
        drawtext = vector3(-627.3, -239.53, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine7"] = {
        name = "Vitrine7",
        label = "Break vitrine",
        coords = vector3(-625.85, -231.9, 38.06),
        drawtext = vector3(-625.42, -232.71, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine8"] = {
        name = "Vitrine8",
        label = "Break vitrine",
        coords = vector3(-624.59, -231.09, 37.81),
        drawtext = vector3(-624.05, -231.94, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine9"] = {
        name = "Vitrine9",
        label = "Break vitrine",
        coords = vector3(-623.23, -230.38, 38.06),
        drawtext = vector3(-622.82, -231.13, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine10"] = {
        name = "Vitrine10",
        label = "Break vitrine",
        coords = vector3(-620.9, -229.08, 38.49),
        drawtext = vector3(-620.47, -229.82, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine11"] = {
        name = "Vitrine11",
        label = "Break vitrine",
        coords = vector3(-619.66, -228.24, 37.81),
        drawtext = vector3(-619.1, -229.04, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine12"] = {
        name = "Vitrine12",
        label = "Break vitrine",
        coords = vector3(-618.32, -227.59, 38.48),
        drawtext = vector3(-617.87, -228.31, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine13"] = {
        name = "Vitrine13",
        label = "Break vitrine",
        coords = vector3(-622.21, -241.72, 37.8),
        drawtext = vector3(-622.92, -242.15, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine14"] = {
        name = "Vitrine14",
        label = "Break vitrine",
        coords = vector3(-622.85, -240.6, 37.8),
        drawtext = vector3(-623.63, -241.11, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine15"] = {
        name = "Vitrine15",
        label = "Break vitrine",
        coords = vector3(-619.94, -233.28, 37.8),
        drawtext = vector3(-620.4, -232.51, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine16"] = {
        name = "Vitrine16",
        label = "Break vitrine",
        coords = vector3(-621.06, -233.92, 37.8),
        drawtext = vector3(-621.55, -233.21, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine17"] = {
        name = "Vitrine17",
        label = "Break vitrine",
        coords = vector3(-617.33, -234.07, 37.8),
        drawtext = vector3(-616.66, -233.67, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine18"] = {
        name = "Vitrine18",
        label = "Break vitrine",
        coords = vector3(-616.68, -235.19, 37.8),
        drawtext = vector3(-615.96, -234.73, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine19"] = {
        name = "Vitrine19",
        label = "Break vitrine",
        coords = vector3(-618.42, -241.71, 37.8),
        drawtext = vector3(-618.0, -242.38, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine20"] = {
        name = "Vitrine20",
        label = "Break vitrine",
        coords = vector3(-619.55, -242.35, 37.8),
        drawtext = vector3(-619.13, -243.04, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine21"] = {
        name = "Vitrine19",
        label = "Break vitrine",
        coords = vector3(-621.74, -242.52, 38.41),
        drawtext = vector3(-622.53, -243.0, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine22"] = {
        name = "Vitrine20",
        label = "Break vitrine",
        coords = vector3(-619.13, -232.82, 38.41),
        drawtext = vector3(-619.67, -231.89, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine23"] = {
        name = "Vitrine21",
        label = "Break vitrine",
        coords = vector3(-617.78, -233.26, 38.41),
        drawtext = vector3(-616.95, -232.7, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine24"] = {
        name = "Vitrine22",
        label = "Break vitrine",
        coords = vector3(-616.2, -235.99, 38.41),
        drawtext = vector3(-615.41, -235.52, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine25"] = {
        name = "Vitrine23",
        label = "Break vitrine",
        coords = vector3(-617.8, -236.92, 38.41),
        drawtext = vector3(-617.39, -237.74, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine26"] = {
        name = "Vitrine24",
        label = "Break vitrine",
        coords = vector3(-618.55, -239.65, 38.41),
        drawtext = vector3(-617.77, -239.17, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine27"] = {
        name = "Vitrine25",
        label = "Break vitrine",
        coords = vector3(-617.61, -241.25, 38.41),
        drawtext = vector3(-617.06, -242.07, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Vitrine28"] = {
        name = "Vitrine26",
        label = "Break vitrine",
        coords = vector3(-620.35, -242.83, 38.41),
        drawtext = vector3(-619.84, -243.64, 38.17),
        distance = 1.25,
        icon = "fas fa-gem",
        size = 0.6,
    },
    ["Display1"] = {
        name = "Display1",
        label = "Break display",
        coords = vector3(-616.96, -245.49, 38.66),
        drawtext = vector3(-617.51, -244.74, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Display2"] = {
        name = "Display2",
        label = "Break display",
        coords = vector3(-616.02, -244.95, 38.66),
        drawtext = vector3(-616.53, -244.23, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Display3"] = {
        name = "Display3",
        label = "Break display",
        coords = vector3(-615.1, -244.42, 38.66),
        drawtext = vector3(-615.56, -243.75, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Display4"] = {
        name = "Display4",
        label = "Break display",
        coords = vector3(-614.18, -243.89, 38.66),
        drawtext = vector3(-614.67, -243.17, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.5,
    },
    ["Display5"] = {
        name = "Display5",
        label = "Break display",
        coords = vector3(-612.07, -235.5, 39.01),
        drawtext = vector3(-612.72, -236.03, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.75,
    },
    ["Display6"] = {
        name = "Display6",
        label = "Break display",
        coords = vector3(-612.6, -234.58, 39.01),
        drawtext = vector3(-613.24, -235.01, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.75,
    },
    ["Display7"] = {
        name = "Display7",
        label = "Break display",
        coords = vector3(-613.14, -233.65, 39.01),
        drawtext = vector3(-613.75, -233.95, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.75,
    },
    ["Display8"] = {
        name = "Display8",
        label = "Break display",
        coords = vector3(-613.67, -232.73, 39.01),
        drawtext = vector3(-614.16, -233.14, 38.17),
        distance = 0.75,
        icon = "fas fa-gem",
        size = 0.75,
    },
    ["LargeTable"] = {
        name = "LargeTable",
        label = "Break table",
        coords = vector3(-609.04, -240.75, 38.11),
        drawtext = vector3(-608.85, -239.68, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["LargeDisplay"] = {
        name = "LargeTable",
        label = "Break display",
        coords = vector3(-605.56, -241.64, 38.88),
        drawtext = vector3(-606.29, -241.51, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["LargeTable2"] = {
        name = "LargeTable",
        label = "Take loot",
        coords = vector3(-609.04, -240.75, 38.11),
        drawtext = vector3(-608.85, -239.68, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["LargeDisplay2"] = {
        name = "LargeTable",
        label = "Take loot",
        coords = vector3(-605.56, -241.64, 38.88),
        drawtext = vector3(-606.29, -241.51, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["VipDisplay1"] = {
        name = "VipDisplay1",
        label = "Cut glass",
        coords = vector3(-609.38, -236.27, 38.14),
        drawtext = vector3(-609.61, -237.22, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["VipDisplay2"] = {
        name = "VipDisplay2",
        label = "Cut glass",
        coords = vector3(-606.55, -237.03, 38.13),
        drawtext = vector3(-606.71, -237.95, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["VipDisplay3"] = {
        name = "VipDisplay3",
        label = "Cut glass",
        coords = vector3(-608.73, -245.19, 38.14),
        drawtext = vector3(-608.57, -244.42, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["VipDisplay4"] = {
        name = "VipDisplay4",
        label = "Cut glass",
        coords = vector3(-611.56, -244.43, 38.14),
        drawtext = vector3(-611.44, -243.67, 38.17),
        distance = 1.0,
        icon = "fas fa-gem",
        size = 1.0,
    },
    ["PlantThermite1"] = {
        name = "PlantThermite1",
        label = "Plant thermite",
        coords = vector3(-614.99, -230.52, 38.22),
        drawtext = vector3(-615.89, -230.94, 38.17),
        distance = 1.0,
        icon = "fas fa-smog",
        size = 0.5,
    },
    ["PlantThermite2"] = {
        name = "PlantThermite2",
        label = "Plant thermite",
        coords = vector3(-622.05, -248.09, 38.22),
        drawtext = vector3(-622.56, -247.18, 38.17),
        distance = 1.0,
        icon = "fas fa-smog",
        size = 0.5,
    },
    ["Keypad1"] = {
        name = "Keypad1",
        label = "Enter code",
        coords = vector3(-613.26, -241.45, 38.43),
        drawtext = vector3(-613.67, -241.35, 38.17),
        distance = 1.0,
        icon = "fas fa-code-commit",
        size = 0.5,
    },
    ["Keypad2"] = {
        name = "Keypad2",
        label = "Enter code",
        coords = vector3(-612.28, -238.02, 38.43),
        drawtext = vector3(-612.88, -237.83, 38.17),
        distance = 1.0,
        icon = "fas fa-code-commit",
        size = 0.5,
    },
    ["KeypadButton1"] = {
        name = "KeypadButton1",
        label = "Toggle button",
        coords = vector3(-613.26, -241.45, 38.43),
        drawtext = vector3(-613.67, -241.35, 38.17),
        distance = 1.0,
        icon = "fas fa-circle-dot",
        size = 0.5,
    },
    ["KeypadButton2"] = {
        name = "KeypadButton2",
        label = "Toggle button",
        coords = vector3(-612.28, -238.02, 38.43),
        drawtext = vector3(-612.88, -237.83, 38.17),
        distance = 1.0,
        icon = "fas fa-circle-dot",
        size = 0.5,
    },
    ["ShuttersKeypad"] = {
        name = "ShuttersKeypad",
        label = "Use shutters keypad",
        coords = vector3(-627.71, -233.10, 38.40),
        drawtext = vector3(-628.3, -232.9, 38.15),
        distance = 1.0,
        icon = "fas fa-keyboard",
        size = 0.5,
    },
}

Config.Items = {
    ["Bag"] = "bag",
    ["SmokeGrenade"] = "weapon_smokegrenade",
    ["ElectricCutter"] = "glass_cutter",
    ["Circuit"] = "x_circuittester",
    ["Device"] = "x_device",
    ["Key"] = "mxckey",
    ["FingerprintBag"] = "x_fingerprintbag",
    ["FingerprintTape"] = "x_fingerprinttape",
    ["Thermite"] = "thermite",
}

Config.ItemsBreak = {
    ["Device"] = 0, -- % Break Chance
    ["Circuit"] = 0, -- % Break Chance
    ["ElectricCutter"] = 0, -- % Break Chance
}

Config.LootableProps = {
    ["Prop1"] = {Item = "box_of_jewelry", Amount = {min = 1, max = 1}, ObjectHash = "ex_office_swag_jewelwatch2", x = -620.70, y = -236.41, z = 38.1, heading = 29.63, rotx = 0.0, roty = 0.0, rotz = 0.0},
    ["Prop2"] = {Item = "box_of_jewelry", Amount = {min = 1, max = 1}, ObjectHash = "ex_office_swag_jewelwatch3", x = -618.91, y = -235.36, z = 38.1, heading = 0.00, rotx = 0.0, roty = 0.0, rotz = 0.0},
    ["Prop3"] = {Item = "box_of_jewelry", Amount = {min = 1, max = 1}, ObjectHash = "ex_office_swag_jewelwatch3", x = -621.35, y = -238.68, z = 38.1, heading = 105.18, rotx = 0.0, roty = 0.0, rotz = 0.0},
    ["Prop4"] = {Item = "box_of_jewelry", Amount = {min = 1, max = 1}, ObjectHash = "ex_office_swag_jewelwatch3", x = -620.38, y = -240.44, z = 38.1, heading = 176.55, rotx = 0.0, roty = 0.0, rotz = 0.0},
}

if VipDisplay == "VipDisplay1" then Prop = "h4_prop_h4_art_pant_01a" elseif VipDisplay == "VipDisplay2" then Prop = "h4_prop_h4_diamond_01a" elseif VipDisplay == "VipDisplay3" then Prop = "h4_prop_h4_necklace_01a" elseif VipDisplay == "VipDisplay4" then Prop = "mxc_jewelry_props_vipdiamond" end


Config.VipDisplayRewards = {
    ["VipDisplay1"] = {item = "x_panther_gem", amount = {min = 1, max = 1}},
    ["VipDisplay2"] = {item = "giant_gem", amount = {min = 1, max = 1}},
    ["VipDisplay3"] = {item = "gem_necklace", amount = {min = 1, max = 1}},
    ["VipDisplay4"] = {item = "giant_gem_green", amount = {min = 1, max = 1}},
}

Config.DisplayRewards = {
    [1] = {item = "sapphire_necklace", amount = {min = 1, max = 1}},
    [2] = {item = "diamond_necklace", amount = {min = 1, max = 1}},
    [3] = {item = "ruby_necklace", amount = {min = 1, max = 1}},
    [4] = {item = "emerald_necklace", amount = {min = 1, max = 1}},
}

Config.VitrineRewards = {
    [1] = {item = "diamond_necklace", amount = {min = 2, max = 3}},
    [2] = {item = "ruby_necklace", amount = {min = 2, max = 3}},
    [3] = {item = "sapphire_necklace", amount = {min = 2, max = 3}},
    [4] = {item = "emerald_necklace", amount = {min = 2, max = 3}},
    [5] = {item = "diamond_earring", amount = {min = 2, max = 3}},
    [6] = {item = "ruby_earring", amount = {min = 2, max = 3}},
    [7] = {item = "sapphire_earring", amount = {min = 2, max = 3}},
    [8] = {item = "emerald_earring", amount = {min = 2, max = 3}},
    [9] = {item = "diamond_ring", amount = {min = 2, max = 3}},
    [10] = {item = "ruby_ring", amount = {min = 2, max = 3}},
    [11] = {item = "sapphire_ring", amount = {min = 2, max = 3}},
    [12] = {item = "emerald_ring", amount = {min = 2, max = 3}},
}

Config.Rewardcash = {
    ["ObtainPerPickup"] = true, -- Obtain the specified items below per cash stack pickup from the trolley, false - Obtain the item/cash specified below at the end of the trolley animation
    ['Cash'] = true, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "markedbills", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 115, max = 265}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of cash you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.Rewardgold = {
    ["ObtainPerPickup"] = false, -- Obtain the specified items below per gold bar pickup from the trolley, false - Obtain the item/cash specified below at the end of the trolley animation
    ['Cash'] = false, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "goldbar", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 8, max = 11}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of gold bars you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.Rewarddiamond = {
    ["ObtainPerPickup"] = true, -- Obtain the specified items below per diamond box pickup from the trolley, false - Obtain the item/cash specified below at the end of the trolley animation
    ['Cash'] = false, -- Set this to false to use a cash "item", or true to use cash
    ['Item'] = "diamond", -- Item you want to use for cash (['Cash'] = false)
    ['StackAmount'] = {min = 1, max = 1}, -- Cash that is recieved from each cash stack, if you have ["ObtainPerPickup"] set to false, this will be the amount of diamonds you recieve at the end of the trolley animation
    ['ItemInfo'] = false, -- Item info for the cash item, this is used if you have markedbills that has random amount of money in info
}

Config.Trollys = {
    ['Trolly1'] = {
        Type = "diamond", -- Loot type (cash/gold/diamond)
        Name = 'Trolly1', -- !!! Do not touch !!!
        Coords = vector3(-618.08, -246.81, 37.17),
        Drawtext = vector3(-617.74, -247.36, 38.17),
        Heading = 209.75,
        Icon = 'fas fa-gem', -- Icon for Trolly1
        Distance = 1.0, -- How far will you be able to interact with it
        Size = 0.5, -- Circle Zone size
    },
}

Config.SecurityGuards = {
    ["Security1"] = {
        Status = true, -- Set weather you want to spawn this ped or not
        Model = "s_m_m_security_01", -- Security guards ped models (https://docs.fivem.net/docs/game-references/ped-models/)
        Coords = vector4(-609.9, -236.84, 37.17, 163.45), -- You can change his location (only choose locations in the backhallway and security room)
        Weapon = 736523883, -- Weapon hash (https://gtahash.ru/weapons/?page=2)
        Ammo = 200, -- How much ammo the ped has
    },
    ["Security2"] = {
        Status = true, -- Set weather you want to spawn this ped or not
        Model = "s_m_m_security_01", -- Security guards ped models (https://docs.fivem.net/docs/game-references/ped-models/)
        Coords = vector4(-611.74, -243.64, 37.17, 344.24), -- You can change his location (only choose locations in the backhallway and security room)
        Weapon = 736523883, -- Weapon hash (https://gtahash.ru/weapons/?page=2)
        Ammo = 200, -- How much ammo the ped has
    },
}

Config.SecurityOptions = { -- Those options are applied for all the security guard peds
    ["MaxHealth"] = 100, -- 0-200
    ["Health"] = 100, -- 0-200
    ["Armour"] = 100, -- 0-100
    ["CombatMovement"] = 1,
    ["CombatRange"] = 2,
    ["Accuracy"] = 100, -- 0-100
    ["CombatAbility"] = 100,
    ["SeeingRange"] = 150.0,
    ["HearingRange"] = 150.0,
    ["Alertness"] = 3,
}

Config.MaleNoGloves = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [16] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true}
Config.FemaleNoGloves = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true}
Config.UseDecor = false
Config.Decorname = "SpawnedPed"

Config.Weapons = {
    -- Project X Weapons
    "WEAPON_PROJECTXPISTOL", -- PROJECT X PISTOL
    "WEAPON_PROJECTXPISTOLUM", -- PROJECT X PISTOL
    "WEAPON_PROJECTXSMG", -- PROJECT X SMG
    "WEAPON_PROJECTXSMGUM", -- PROJECT X SMG UM
    "WEAPON_PROJECTX", -- PROJECT X WEAPON
    "WEAPON_PROJECTXUM", -- PROJECT X UM Rifle
    "WEAPON_RATREV", -- PROJECT X RAT REVOLVER
    "WEAPON_ORIGIN12", -- PROJECT X ORIGIN-12
    "WEAPON_ORIGIN12B", -- PROJECT X ORIGIN-12B
    "WEAPON_ORIGIN12P", -- PROJECT X ORIGIN-12P
    "WEAPON_ARCTIC516", -- PROJECT X ARCTIC 516
    "WEAPON_ARPW", -- PROJECT X ARP Rifle
    "WEAPON_M1", -- PROJECT X M1 Garand

    -- Melee
    "WEAPON_KNIFE", -- Knife
    "WEAPON_NIGHTSTICK", -- Night Stick
    "WEAPON_HAMMER", -- Hammer
    "WEAPON_BAT", -- Bat
    "WEAPON_CROWBAR", -- Crowbar
    "WEAPON_GOLFCLUB", -- Golfclub
    "WEAPON_BOTTLE", -- Bottle
    "WEAPON_DAGGER", -- Dagger
    "WEAPON_HATCHET", -- Hatchet
    "WEAPON_KNUCKLE", -- Knuckle Duster
    "WEAPON_MACHETE", -- Machete
    "WEAPON_FLASHLIGHT", -- Flashlight
    "WEAPON_SWITCHBLADE", -- Switch Blade
    "WEAPON_POOLCUE", -- Poolcue
    "WEAPON_WRENCH", -- Wrench
    "WEAPON_BATTLEAXE", -- Battle Axe

    -- Pistols
    "WEAPON_PISTOL", -- Pistol
    "WEAPON_PISTOL_MK2", -- Pistol Mk2
    "WEAPON_COMBATPISTOL", -- Combat Pistol
    "WEAPON_PISTOL50", -- Pistol 50
    "WEAPON_SNSPISTOL", -- SNS Pistol 
    "WEAPON_HEAVYPISTOL", -- Heavy Pistol
    "WEAPON_VINTAGEPISTOL", -- Vintage Pistol
    "WEAPON_MARKSMANPISTOL", -- Marksman Pistol
    "WEAPON_REVOLVER", -- Revolver
    "WEAPON_APPISTOL", -- AP Pistol
    "WEAPON_STUNGUN", -- Stun Gun
    "WEAPON_FLAREGUN", -- Flare Gun

    -- SMGs
    "WEAPON_MICROSMG", -- Micro SMG
    "WEAPON_MACHINEPISTOL", -- Machine Pistol
    "WEAPON_SMG", -- SMG
    "WEAPON_SMG_MK2", -- SMG Mk2
    "WEAPON_ASSAULTSMG", -- Assault SMG
    "WEAPON_COMBATPDW", -- Combat PDW
    "WEAPON_MG", -- MG
    "WEAPON_COMBATMG", -- Combat MG
    "WEAPON_COMBATMG_MK2", -- Combat MG Mk2
    "WEAPON_GUSENBERG", -- Gusenberg
    "WEAPON_MINISMG", -- Mini SMG

    -- Assault Rifles
    "WEAPON_ASSAULTRIFLE", -- Assault Rifle
    "WEAPON_ASSAULTRIFLE_MK2", -- Assault Rifle Mk2
    "WEAPON_CARBINERIFLE", -- Carbine Rifle
    "WEAPON_CARBINERIFLE_MK2", -- Carbine Rifle Mk2
    "WEAPON_ADVANCEDRIFLE", -- Advanced Rifle
    "WEAPON_SPECIALCARBINE", -- Special Carbine
    "WEAPON_BULLPUPRIFLE", -- Bullpup Rifle
    "WEAPON_COMPACTRIFLE", -- Compact Rifle
    "WEAPON_MILITARYRIFLE", -- Military Rifle
    "WEAPON_TACTICALRIFLE", -- Tactical Rifle

    -- Sniper rifles
    "WEAPON_SNIPERRIFLE", -- Sniper Rifle
    "WEAPON_HEAVYSNIPER", -- Heavy Sniper
    "WEAPON_HEAVYSNIPER_MK2", -- Heavy Sniper Mk2
    "WEAPON_MARKSMANRIFLE", -- Marksman Rifle

    -- Shotguns
    "WEAPON_PUMPSHOTGUN", -- Pump Shotgun
    "WEAPON_SAWNOFFSHOTGUN", -- Sawnoff Shotgun
    "WEAPON_BULLPUPSHOTGUN", -- Bullpup Shotgun
    "WEAPON_ASSAULTSHOTGUN", -- Assault Shotgun
    "WEAPON_MUSKET", -- Musket
    "WEAPON_HEAVYSHOTGUN", -- Heavy Shotgun
    "WEAPON_DBSHOTGUN", -- Double Barrel Shotgun
    "WEAPON_AUTOSHOTGUN", -- Auto Shotgun

    -- Heavy Weapons
    "WEAPON_GRENADELAUNCHER", -- Grenade Launcher
    "WEAPON_RPG", -- RPG
    "WEAPON_MINIGUN", -- Minigun
    "WEAPON_FIREWORK", -- Firework
    "WEAPON_RAILGUN", -- Railgun
    "WEAPON_HOMINGLAUNCHER", -- Homing Launcher
    "WEAPON_GRENADELAUNCHER_SMOKE", -- Smoke Grenade Launcher 
    "WEAPON_COMPACTLAUNCHER", -- Compact Launcher

    -- Thrown Weapons
    "WEAPON_GRENADE", -- Grenade
    "WEAPON_STICKYBOMB", -- Sticky Bomb
    "WEAPON_PROXMINE", -- Proximity Mine
    "WEAPON_BZGAS", -- BZ Gas
    "WEAPON_MOLOTOV", -- Molotov
    "WEAPON_FIREEXTINGUISHER", -- Fire Extinguisher
    "WEAPON_PETROLCAN", -- Petrol Can
    "WEAPON_FLARE", -- Flare
    "WEAPON_BALL", -- Ball
    "WEAPON_SNOWBALL", -- Snowball
    "WEAPON_SMOKEGRENADE", -- Smoke Grenade
    "WEAPON_PIPEBOMB", -- Pipe Bomb
}

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- |   |   |   |   |   |   |   |   |   |   |    DO NOT TOUCH ANYTHING UNDER THIS LINE  |   |   |   |   |   |   |   |   |   |   |    |
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

Config.Steps = {}
Config.ExtraSteps = {}
Config.Tasks = {}

Config.DoorStates = {} -- Sync
Config.DoorList = {
    	-- Office Door Left (1)
	{
        objCoords = vector3(-616.21, -227.94, 38.58),
        objHash = -1181546872,
        objYaw = 300.0,
        locked = true,
	},
        -- Office Door Right (2)
    {
        objCoords = vector3(-614.94, -230.15, 38.58),
        objHash = -1181546872,
        objYaw = 120.0,
        locked = true,
	},
        -- Workshop Left (3)
    {
        objCoords = vector3(-619.42, -246.95, 38.58),
        objHash = -1181546872,
        objYaw = 210.0,
        locked = true,
    },
        -- Workshop Left (4)
    {
        objCoords = vector3(-621.63, -248.22, 38.58),
        objHash = -1181546872,
        objYaw = 30.0,
        locked = true,
    },
}