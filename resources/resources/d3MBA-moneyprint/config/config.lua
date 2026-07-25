Config.DebugPolyZone = false -- [true/false] - If you want to see polyzone borders, set it to 'true' (Config.DebugPolyZone = true) 

Config.KickReason = "Gde si kreno jajaro jedna?" -- Kick reason if player try to cheat.

Config.BlacklistZonesDebug = false -- true/flase | Default: false | If you set this to true, you will see the Blacklist Zones in the game (marker).
Config.BlacklistZones = { -- Blacklist zones where player can't do actions. 
    {coords = vector3(453.1656, -985.860, 30.689), radius = 70.0}, -- MRPD 
    {coords = vector3(332.6394, -582.348, 43.224), radius = 70.0}, -- Pillbox Hospital 
    
    -- Add more zones as needed
}

-- Config.JobRequired = "JOB_NAME" -- if you want to disable it just set it to 'false' (Config.JobRequired = false) 
Config.JobRequired = false -- Job name e.g. Config.JobRequired = "moneyprint", make sure you have that job in the your framework(qbcore, esx, qbox...)

Config.AdminCommandGroup = 'vlasnik'

-- Particles synchronization   
Config.SyncParticlesWithAllPlayers = { -- If is false particles will see only the player who triggered it. 
    ExtractingInk = true, -- [true/false] - If you want to sync particles with all players, set it to 'true'
    SearchPrinter = true, -- [true/false] - If you want to sync particles with all players, set it to 'true'
}

Config.ShopPed = {
    Use = true, -- [true/false] - Set this to false if you want to disable the shop.

    Account = "cash", -- (bank / cash) | Default: cash | If you set this to bank, you will pay from bank account.

    Model = "a_m_m_og_boss_01", -- https://docs.fivem.net/docs/game-references/ped-models/ - Ped model that will be spawned.
    Pos = vector4(160.3689, 334.1191, 111.1260, 99.4610),

    TimeCheck = {
        Use = true, -- (true/false) | Default: true | If you set this to false, shop will be open 24/7. 
        CheckTime = 3, -- Every 3 sec scitpt will check in game time. 
        OpeningTime = 23, -- Shop opening time = 23:00 PM.
        ClosingTime = 07, -- Shop close time = 07:00 AM.
    },  

    OpenShopAfterBuy = false, -- [true/false] If true, script will open shop menu again after player bought something

    DynamicPrices = {
        Use = true, -- [true/false] - If you want to use dynamic prices, set it to 'true'
        PriceMinMultiplier = 0.7, -- Min price multiplier, 70% of original price
        PriceMaxMultiplier = 1.5, -- Max price multiplier, 150% of original price
    },

    Items = {
        {ItemName = Config.Items.Sheet, Price = 150},
        {ItemName = Config.Items.Microscope, Price = 3500},
        {ItemName = Config.Items.Printer, Price = 250},
        {ItemName = Config.Items.HackingLaptop, Price = 3000},
        {ItemName = Config.Items.BlackBlueprint1, Price = 350},
        {ItemName = Config.Items.BlackBlueprint2, Price = 700},
        {ItemName = Config.Items.BlackBlueprint3, Price = 1400},
    }

}

Config.BlueprintPed = {
    Use = false,

    Account = "cash", -- (bank / cash) | Default: cash | If you set this to bank, you will pay from bank account.
    
    Model = "a_m_m_og_boss_01", -- https://docs.fivem.net/docs/game-references/ped-models/ - Ped model that will be spawned.
    Pos = vector4(161.3689, 334.1191, 112.1260, 99.4610),

    TimeCheck = {
        Use = true, -- (true/false) | Default: true | If you set this to false, shop will be open 24/7. 
        CheckTime = 3, -- Every 3 sec scitpt will check in game time. 
        OpeningTime = 23, -- Shop opening time = 23:00 PM.
        ClosingTime = 07, -- Shop close time = 07:00 AM.
    },  

    OpenShopAfterBuy = false, -- [true/false] If true, script will open shop menu again after player bought something

    DynamicPrices = {
        Use = true, -- [true/false] - If you want to use dynamic prices, set it to 'true'
        PriceMinMultiplier = 0.7, -- Min price multiplier, 70% of original price
        PriceMaxMultiplier = 1.5, -- Max price multiplier, 150% of original price
    },

    Items = {
        -- ItemName = name of item, Price = price of item
        {ItemName = Config.Items.BlackBlueprint1, Price = 350},
        {ItemName = Config.Items.BlackBlueprint2, Price = 700},
        {ItemName = Config.Items.BlackBlueprint3, Price = 1400},

    }
}

Config.HackingLaptop = {
    Prop = "m23_1_prop_m31_laptop_01a", -- Prop = set prop that will be spawned.

    PlacingTime = {
        HackingLaptop = 3,
    }, 

    PickingUpTime = {
        HackingLaptop = 2, -- Time in seconds to pick up the microscope.
    }, 
    
}

Config.PrintMachine = {
    Prop = "d3mba_cash_machine_prop", -- Prop = set prop that will be spawned.

    AnimTime = 3, -- Time in seconds to add/remove/takeout the ink, sheet, and money sheet from the printer.

    PrintingTime = { -- Random time to print the money sheet (in seconds)
        Min = 80,
        Max = 110,
    },

    BillRecipe = {   
        [Config.Items.PrintedMoneySheet1] = {
            Recipe = {
                [Config.Items.BlackInk] = {18, 24},
                [Config.Items.ColorInk] = {7, 10},
            }
        },
        [Config.Items.PrintedMoneySheet2] = {
            Recipe = {
                [Config.Items.BlackInk] = {12, 16},
                [Config.Items.ColorInk] = {12, 16},
            }
        },  
        [Config.Items.PrintedMoneySheet3] = {
            Recipe = {                
                [Config.Items.BlackInk] = {5, 9},
                [Config.Items.ColorInk] = {18, 24},
            }
        },

        -- Add more recipes if needed, make sure that the recipe is in this format.
        -- Don't forget to add the item to the Config.Items (config/items.lua), and your inventory/framework (qbcore/esx)
    },

    BillValue = { -- Bill value of printed money sheet (certified(using microscope) and uncertified)
        -- Cerfified money sheet value
        [Config.Items.CertifiedMoneySheet1] = 20, -- 20$ bill value
        [Config.Items.CertifiedMoneySheet2] = 50, -- 50$ bill value
        [Config.Items.CertifiedMoneySheet3] = 100, -- 100$ bill value
        -- Uncertified money sheet value
        [Config.Items.PrintedMoneySheet1] = 20, -- 20$ bill value
        [Config.Items.PrintedMoneySheet2] = 50, -- 50$ bill value
        [Config.Items.PrintedMoneySheet3] = 100, -- 100$ bill value

        -- Add more bill values if needed, make sure that the item is in the Config.Items (config/items.lua), and your inventory/framework (qbcore/esx)
    }
}

Config.Printer = {
    Prop = { -- Prop = set
        "v_ret_gc_print",
        "v_res_printer",
        "prop_printer_01",
    }, 

    SearchingTime = 8, 

    BlackInk = {
        Chance = 25,
        Amount = {Min = 1, Max = 3},
    },

    ColorInk = {
        Chance = 70,
        Amount = {Min = 1, Max = 2},
    },
    
    ResetTime = 22,

    UseMiniGame = true, -- true/false if is true, you will need to play minigame to pick up the kerosene.

}

Config.ExtractingInk = {
    Time = 15, 
    
    BlackInk = {
        Chance = 25,
        Amount = {Min = 1, Max = 3},
    },

    ColorInk = {
        Chance = 70,
        Amount = {Min = 1, Max = 2},
    }
}

Config.Microscope = {
    Prop = "v_med_microscope", -- Prop = set prop that will be spawned.
    
    PlacingTime = {
        Microscope = 5, -- Time in seconds to place the microscope.
        PrintedMoneySheet = 3, -- Time in seconds to place the printed money sheet.
    }, 

    PickingUpTime = {
        Microscope = 5, -- Time in seconds to pick up the microscope.
        PrintedMoneySheet = 3, -- Time in seconds to pick up the printed money sheet.
        CertifiedMoneySheet = 4, -- Time in seconds to pick up the certified money sheet.
    }, 
    
    Minigame = { -- Minigame settings
        NumberOfRotations = { -- Random number of rotations (between min and max value below)
            Min = 5, -- Min number of rotations
            Max = 8, -- Max number of rotations
        },

        Speed = { -- Random speed of rotation(between min and max value below) 
            Min = 5, -- Min speed of rotation
            Max = 7, -- Max speed of rotation
        },

        ChanceToRemoveItemOnFail = 35,
    }
}

Config.CuttingTable = {
    Prop = "bkr_prop_fakeid_papercutter", 

    CuttingTime = 60,

    BillValueMultiplier = 70,
}

Config.Rotation = {    
    -- Here you can find key codes: https://docs.fivem.net/docs/game-references/controls/
    RotationCounterClockwise = 189, -- 189 = "ARROW LEFT" key
    RotationClockwise = 190, -- 190 = "ARROW RIGHT" key

    Submit = 38, -- 38 = "E" key
    Cancel = 47, -- 47 = "G" key
    
    Text3D = { -- Position of 3D text that will be displayed when you rotate the object. 
        x = 0.365, -- x = 0.365 | 0.365 = center of the screen | 0.0 = left side of the screen | 1.0 = right side of the screen  
        y = 0.95 -- y = 0.95 | 0.95 = bottom of the screen | 0.0 = top of the screen | 1.0 = bottom of the screen 
    },
}
