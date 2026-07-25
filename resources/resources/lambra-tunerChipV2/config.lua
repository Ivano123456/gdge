debugMode = false -- Enable debug messages in console
------------------------------------------------

Config = {}

Config.Framework = "ESX" -- QB, ESX, or QBOX (ready by default) (You can add support for more frameworks)

Config.Logs = {
    enabled = false, -- Enable webhook logging
    -- If enabled, set your webhook in framework/server.lua line 5
}

Config.Database = {
    searchFakePlate = false -- Also search "fakeplate" column in database queries
}

Config.Installation = {
    time = 4000, -- Time in milliseconds for installation progressbar
}

Config.ChipRemoval = {
    jobs = {"autoumro", "police"}, -- Jobs required to remove chips (empty = everyone can remove)
    -- Example: jobs = {"mechanic"}
}

Config.ChipRemover = {
    deleteOnUse = true, -- Remove "Chip Remover" item after use
    extractChip = true -- Give player the chip that was installed
}

Config.Commands = {
    flames = "flames", -- Toggle flames on/off
    pops = "pops", -- Toggle pops and bangs on/off
    mutePops = "mutepops" -- Mute/unmute pops sound
}

Config.SyncRadius = 67 -- Radius (in units) for syncing turbo sounds and pops
-- (Only recommended to go lower than 67, making it higher you will hear the pops and probably not the vehicle itself)

--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                      TUNER CHIPS                              ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    [PERFORMANCE] - Handling-based performance boosts (percentage multipliers)
        enabled = true/false
        topSpeed = % increase to max speed
        acceleration = % increase to acceleration
    
    [FLAMES] - Exhaust flames on rev/downshift
        enabled = true/false
        size = flame size multiplier
        color = false (no color), "RGB" (rainbow), or "#4000ff" (hex color)
        downshift = {
            enabled = true/false,
            time = time in ms flames stay on after downshift
        }
    
    [POPS_BANGS] - Anti-lag system sounds
        enabled = true/false
        delay = {min, max} time in ms between pops
        rpm = minimum RPM to trigger pops (0.0 to 1.0)
        sounds = list of sound names to randomly play
    
    [TURBO] - Turbo sound and boost system (requires vehicle turbo upgrade)
        enabled = true/false -- Enable turbo module entirely
        sound = turbo sound name (false to disable sound)
        boost = {
            enabled = true/false -- Enable performance boost
            percentage = % additional boost on top of base acceleration
                Example: 50 = 50% additional boost when turbo is active
        }
    
    [WHITELIST] - Vehicle restrictions
        enabled = true/false
        vehicles = list of vehicle model names
            Empty list = works on all vehicles
    
    [JOBS] - Job restrictions
        enabled = true/false
        jobs = list of job names required to install
            Empty list = everyone can install
]]

Config.Chips = {--You can add more chips and customize to your likings below

    ["tunerchip1"] = { -- This is the item name
    performance = {
        enabled = true,
        topSpeed = 2.0, -- +35% top speed
        acceleration = 8.0, -- +60% acceleration
    },
    flames = {
        enabled = false,
        size = 1.2,
        color = "#4000ff",
        downshift = {
            enabled = true,
            time = 1200
        }
    },
    pops_bangs = {
        enabled = true,
        delay = {min = 25, max = 300},
        rpm = 0.55, -- Trigger above 55% RPM
        sounds = {"pops13", "pops15"}
    },
    turbo = {
        enabled = true,
        sound = "turbo2",
        boost = {
            enabled = true,
            percentage = 15.0 -- 50% additional boost when turbo is active
        }
    },
    whitelist = {
        enabled = false,
        vehicles = {} -- Example: {"adder", "t20", "zentorno"}
    },
    jobs = {
        enabled = false,
        list = {"autoumro"} -- Example: {"mechanic", "tunerjob"}
    }
},

    ["tunerchip2"] = { -- This is the item name
    performance = {
        enabled = true,
        topSpeed = 4.0, -- +35% top speed
        acceleration = 10.0, -- +60% acceleration
    },
    flames = {
        enabled = false,
        size = 1.2,
        color = "#4000ff",
        downshift = {
            enabled = true,
            time = 1200
        }
    },
    pops_bangs = {
        enabled = true,
        delay = {min = 25, max = 300},
        rpm = 0.55, -- Trigger above 55% RPM
        sounds = {"pops13", "pops15"}
    },
    turbo = {
        enabled = true,
        sound = "turbo2",
        boost = {
            enabled = true,
            percentage = 25.0 -- 50% additional boost when turbo is active
        }
    },
    whitelist = {
        enabled = false,
        vehicles = {} -- Example: {"adder", "t20", "zentorno"}
    },
    jobs = {
        enabled = false,
        list = {"autoumro"} -- Example: {"mechanic", "tunerjob"}
    }
},
    ["tunerchip3"] = { -- This is the item name
        performance = {
            enabled = true,
            topSpeed = 5.0, -- +35% top speed
            acceleration = 15.0, -- +60% acceleration
        },
        flames = {
            enabled = false,
            size = 1.2,
            color = "#4000ff",
            downshift = {
                enabled = true,
                time = 1200
            }
        },
        pops_bangs = {
            enabled = true,
            delay = {min = 25, max = 300},
            rpm = 0.55, -- Trigger above 55% RPM
            sounds = {"pops13", "pops15"}
        },
        turbo = {
            enabled = true,
            sound = "turbo2",
            boost = {
                enabled = true,
                percentage = 35.0 -- 50% additional boost when turbo is active
            }
        },
        whitelist = {
            enabled = false,
            vehicles = {} -- Example: {"adder", "t20", "zentorno"}
        },
        jobs = {
            enabled = false,
            list = {"autoumro"} -- Example: {"mechanic", "tunerjob"}
        }
    },



}

Locales = {
    ["notInVehicle"] = "Nisi u vozilu",
    ["installed"] = "Uspesno instalirano",
    ["installing"] = "Instaliranje",
    ["noChip"] = "Ovo vozilo nema chip",
    ["chipRemoved"] = "Uklonio si chip:",
    ["notOwnedVehicle"] = "Ovo nije tvoje vozilo",
    ["popsON"] = "UKLJUČENO",
    ["popsOFF"] = "ISKLJUČENO",
    ["noPermission"] = "Nemaš dozvolu za instalaciju",
    ["installChipError"] = "U ovom vozilu je već instaliran chip",
    ["notWhitelisted"] = "Chip nije kompatibilan sa ovim modelom vozila"
}