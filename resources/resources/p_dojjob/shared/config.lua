Config = {}

Config.Debug = false -- debug mode? script will print more information in console and debug targets
Config.Language = 'en' -- en / de / pl / es / fr / it / ru / tr / ar
Config.Framework = 'ESX' -- ESX / QB / QBOX
Config.Target = 'ox_target' -- ox_target / qb-target
Config.Commands = true -- enable commands?
Config.RadialMenu = true -- true / false [if you want to use ox_lib radial menu set true, otherwise set false]

Config.Jobs = { -- JOBS THAT CAN ACCESS RADIAL MENU
    ['sud'] = 0
}

Config.Blips = { -- BLIPS ON MAP
    -- FM CITY HALL
    {
        coords = vector3(-1579.8752, 186.8970, 58.8536), -- blip coords
        label = 'Sud', -- label on map
        sprite = 439, -- blip sprite https://docs.fivem.net/docs/game-references/blips/
        color = 46, -- blip color https://docs.fivem.net/docs/game-references/blips/
        scale = 0.8, -- blip scale
    },
    -- FM CITY HALL LS 
    -- {
    --     coords = vector3(-545.4425, -621.2889, 35.6050), -- blip coords
    --     label = 'Department of Justice', -- label on map
    --     sprite = 439, -- blip sprite https://docs.fivem.net/docs/game-references/blips/
    --     color = 46, -- blip color https://docs.fivem.net/docs/game-references/blips/
    --     scale = 0.85, -- blip scale
    -- },
}

Config.Lockers = {
    ['CityHall_1'] = { -- script will create locker with id CityHall_1_Locker
        coords = vector3(-1641.9681, 172.8107, 68.3576),
        jobs = {['sud'] = 0}, -- jobs that can access this locker [jobName] = jobGrade
        slots = 200, -- slots in locker
        weight = 1500000, -- weight in locker
        private = false, -- if true, every player will have their own locker, if false, all players will share the same locker
    },

    -- FM CITY HALL LS
    -- ['CityHall_LS_1'] = { -- script will create locker with id CityHall_1_Locker
    --     coords = vector3(-530.5, -621.3, 35.8),
    --     jobs = {['sud'] = 0}, -- jobs that can access this locker [jobName] = jobGrade
    --     slots = 50, -- slots in locker
    --     weight = 500000, -- weight in locker
    --     private = true, -- if true, every player will have their own locker, if false, all players will share the same locker
    -- },
}

Config.Wardrobes = {
    ['CityHall_1'] = {
        coords = vector3(-1663.4729, 145.0934, 70.7246),
        jobs = {['sud'] = 0}, -- jobs that can access this wardrobe [jobName] = jobGrade
    },

    -- FM CITY HALL LS
    -- ['CityHall_LS_1'] = {
    --     coords = vector3(-571.32, -602.53, 36.0),
    --     jobs = {['sud'] = 0}, -- jobs that can access this wardrobe [jobName] = jobGrade
    -- },
}

Config.WardrobePermissions = { -- which jobs can create outfits
    ['sud'] = 4,
}

Config.DocumentLockers = { -- LOCKERS FOR DOCUMENTS [ACCESSING BY SOME ID]
    ['CityHall_1'] = { -- script will create locker with id CityHall_1_Document_Locker
        coords = vector3(-1645.8505, 178.7439, 61.7574),
        jobs = {['sud'] = 0}, -- jobs that can access this locker [jobName] = jobGrade
        slots = 100, weight = 500000
    },
    ['CityHall_2'] = { -- script will create locker with id CityHall_2_Document_Locker
        coords = vector3(-1584.6104, 193.4621, 58.8536),
        jobs = {['sud'] = 0},
        slots = 100, weight = 500000
    },
}

Config.Garages = {
    ['CityHall_1'] = {
        jobs = {['sud'] = 0}, -- jobs that can access this garage [jobName] = jobGrade
        coords = vector4(-1581.5723, 178.4068, 58.4490, 202.2674),
        spawnPoints = {
            vector4(-1581.0901, 171.0588, 57.8774, 292.2870),
            vector4(-1572.8937, 174.7646, 57.5261, 295.0865)
        },
        ped = {model = 's_m_y_airworker', anim = {}},
        gradeRestricted = true, -- if grade restricted you need to set vehicles for grades, if not you need to set vehicles for all

        vehicles = {
            ['0'] = {
                ['a8l'] = {
                    label = 'Audi A8L',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
            },
            ['1'] = {
                ['a8l'] = {
                    label = 'Audi A8L',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
            },
            ['2'] = {
                ['a8l'] = {
                    label = 'Audi A8L',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
            },
            ['3'] = {
                ['a8l'] = {
                    label = 'Audi A8L',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
            },
            ['4'] = {
                ['a8l'] = {
                    label = 'Audi A8L',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
            },
            ['5'] = {
                ['a8l'] = {
                    label = 'Audi A8L',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
                ['mrkvam5g90'] = {
                    label = 'BMW M5 G90',
                    mods = {
                        ['color1'] = 1, ['color2'] = 1,
                        ['livery'] = 1
                    },
                },
            },
        }
    },

    -- FM CITY HALL LS
    -- ['CityHall_LS_1'] = {
    --     jobs = {['sud'] = 0}, -- jobs that can access this garage [jobName] = jobGrade
    --     coords = vector4(-497.4413, -599.7752, 33.9005, 271.0759),
    --     spawnPoints = {
    --         vector4(-494.1490, -602.5171, 33.9006, 268.5907),
    --         vector4(-494.5722, -606.6237, 33.9006, 268.9452),
    --         vector4(-496.1283, -579.1907, 34.0959, 181.4695),
    --         vector4(-492.0006, -579.4944, 34.0913, 178.9854),
    --         vector4(-487.7417, -579.4999, 34.0863, 176.2200)
    --     },
    --     ped = {model = 's_m_y_airworker', anim = {}},
    --     gradeRestricted = true, -- if grade restricted you need to set vehicles for grades, if not you need to set vehicles for all

    --     -- VEHICLES FOR ALL GRADES
    --     -- vehicles = {
    --     --     ['washington'] = { -- spawn name
    --     --         label = 'Washington',
    --     --         mods = { -- https://github.com/overextended/ox_lib/blob/master/resource/vehicleProperties/client.lua [check all mods here]
    --     --             ['color1'] = 1, ['color2'] = 1,
    --     --             ['livery'] = 1
    --     --         },
    --     --     },
    --     -- },
    --     vehicles = {
    --         ['0'] = {
    --             ['washington'] = { -- spawn name
    --                 label = 'Washington',
    --                 mods = { -- https://github.com/overextended/ox_lib/blob/master/resource/vehicleProperties/client.lua [check all mods here]
    --                     ['color1'] = 1, ['color2'] = 1,
    --                     ['livery'] = 1
    --                 },
    --             }
    --         }
    --     }
    -- },
}