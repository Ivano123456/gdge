-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.StateGroups = {
    'police',
    'hitna',
}

Config.Elevators = {
    PDPolicijaLift = {
        [0] = {
            coords = vec3(-593.2814, -430.8149, 30.1729),
            heading = 269.1191,
            title = 'Garaža',
            description = 'Sprat 0',
            target = {
                width = 2.5,
                length = 2.5,
            },
            groups = Config.StateGroups,
        },
        [1] = {
            coords = vec3(-589.9874, -434.0384, 34.1796),
            heading = 87.6957,
            title = 'Hol',
            description = 'Sprat 1',
            target = {
                width = 2.5,
                length = 2.5,
            },
        },
        [2] = {
            coords = vec3(-590.2733, -433.9844, 38.6401),
            heading = 182.3607,
            title = 'Kancelarije',
            description = 'Sprat 2',
            target = {
                width = 2.5,
                length = 2.5,
            },
            groups = Config.StateGroups,
        },
        [3] = {
            coords = vec3(-589.5599, -434.0559, 44.6355),
            heading = 181.3819,
            title = 'Sastanci',
            description = 'Sprat 3',
            target = {
                width = 2.5,
                length = 2.5,
            },
            groups = Config.StateGroups,
        },
    },

}
