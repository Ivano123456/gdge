Config = {}

Config.TabletOwners = {
    ['steam:110000116d20698'] = true,
    ['steam:11000013c9bfb31'] = true,
}

Config.JailTimePerStar = 10 

Config.WantedReward = {
    basePerStar = 500,
    defaultMultiplier = 1.0,
    bossGrade = {
        police = 11,
    },
    nameOverrides = {
        nacelnik = 2.5,
        komandir_jedinice = 2.5,
        komandant = 2.5,
    },
    tierSteps = {
        { upToRatio = 0.18, mult = 1.0 },
        { upToRatio = 0.45, mult = 1.2 },
        { upToRatio = 0.64, mult = 1.5 },
        { upToRatio = 0.82, mult = 1.8 },
        { upToRatio = 1.00, mult = 2.5 },
    },
}

Config.CityCenter = { x = -415.29, y = -790.92 }
Config.CityRadius = 1800.0

Config.LocationUpdateMs = 10000

Config.WantedDecayMinutes = 10

Config.WantedListCacheSeconds = 45
Config.WantedLocationDbSeconds = 30
