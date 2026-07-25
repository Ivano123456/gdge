Registration = {
    Config = {
        esxobject = 'esx:getSharedObject',
        esxsetjob = 'esx:setJob',
        esxplayerloaded = 'esx:playerLoaded',
        Price = 5000,
        Duration = 60 * 60 * 24 * 7,
        EarliestRegistration = 60 * 60 * 24,
        InsurancePrice = 3000,
        InsuranceDuration = 60 * 60 * 24 * 7,
        EarliestInsurance = 60 * 60 * 24,
        DrawDistance = 10,
        MarkerSettings  = {type = 36, r = 102, g = 0, b = 102, a = 100, rotate = false},
        InsuranceMarkerSettings = {type = 36, r = 0, g = 102, b = 204, a = 100, rotate = false},
        Zones = {
            {
                pos = vector3(-1083.30, -248.19, 37.76),
                size = 0.5,
                type = 'registration'
            }
        },
        InsuranceZones = {
            {
                pos = vector3(-1081.09, -247.04, 37.76),
                size = 0.5,
                type = 'insurance'
            }
        },
        Blip = {
            enabled = true,
            coords = vector3(-1081.09, -247.04, 37.76),
            sprite = 50,
            color = 3,
            scale = 0.8,
            name = "Registracija i osiguranje vozila"
        },
        Cooldown = 15,
        CommandCheck = 'checkreg',
        CommandCheckInsurance = 'checkinsurance',
        JobChecks = {
            "police",
            "sheriff"
        },
    },
    Vehicles = {},
    Insurance = {}
}
