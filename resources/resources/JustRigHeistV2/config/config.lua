Config = {}
Config.Framework = "detect"

Config.Fiveguard = false -- If you are using Fiveguard enable it, if dont purchase it on : https://fiveguard.net

Config.StartingPed = "g_m_m_armboss_01"
Config.StartingCoords = vector4(-440.6304, 6133.9150, 30.4783, 359.4833)

Config.Price = {
    ['fuel'] = 500, -- per liter
}

Config.Lobby = {
    ['playerLocations'] = {
        [1] = vector4(-148.7397, 6570.5547, 33.6037, 246.8999),
        [2] = vector4(-148.7520, 6572.4341, 33.6054, 225.857),
        [3] = vector4(-147.8036, 6573.4653, 33.6054, 231.0847),
        [4] = vector4(-146.2937, 6574.6606, 33.6051, 195.4616)
    },
    ['cameraLocation'] = vector4(-142.0, 6566.0, 35.0, 0.0),
    ['cameraRotation'] = vector3( 0.0, 46.0, 45.0),
}

Config.Accumulation = { 
    ['enable'] = true,
    ['max'] = { 
        ['fuel'] = 1000, -- liter
    },
    ['accumulate'] = {
        ['fuel'] = 50,
    },
    ['interval'] = 5 -- in minutes
}

Config.Reward = 1000 -- how much liters of fuel you will recieve if accomulation is disabled

Config.Vehicle = { 
    ['model'] = "tug",
    ['coords'] = {
        vector4(-1599.3300, 5260.9048, 0.8758, 24.7590),
    }
}

Config.Items = { 
    ['pedModel'] = "a_m_m_og_boss_01",
    ['boxModel'] = "imp_prop_impexp_boxwood_01",
    ['coords'] = { 
        [1] = { ['ped'] = vector4(-381.8676, 6086.2305, 30.5991, 297.6215), ['box'] = vector4(-380.8297, 6088.9116, 30.5991, 208.8041)},
    }
}

Config.FuelAgent = {
    ['pedModel'] = "g_m_m_mexboss_01",
    ['coords'] = {
        [1] = { ['ped'] = vector4(162.1203, 6636.6304, 30.5548, 135.8974) }
    }
}

Config.ClothingBox = { 
    ['pedModel'] = "a_m_m_og_boss_01",
    ['boxModel'] = "prop_cs_heist_bag_01",
    ['coords'] = { 
        [1] = { ['ped'] = vector4(-773.2388, 5598.6265, 32.6050, 169.9517), ['box'] = vector4(-768.6767, 5597.2559, 32.6037, 167.4931), ['placingCoords'] = vector4(-1609.9327, 5257.2510, 2.9741, 26.2269)},
    },
    ['clothes'] = { 
        ['tshirt_1'] = 15, ['tshirt_2'] = 0, 
        ['torso_1'] = 66, ['torso_2'] = 0,
        ['arms'] = 1, 
        ['pants_1'] = 39, ['pants_2'] = 0,
        ['shoes_1'] = 81, ['shoes_2'] = 0,
        ['mask_1'] = 95, ['mask_2'] = 0
    }
}

Config.RigSecurirties = {
    ['camera'] = {
        ['coords'] = vector4(-2897.9013671875,6526.4516601562,35.902294158936,-7.9999723434448),
        ['rotation'] = vector3(-2.988207143062,50.23543548584,93.0)
    },
    ['securities'] = { 
        [1] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2924.1187, 6541.4453, 20.7139),
            heading = 227.471,
          },
        
          [2] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2923.9939, 6591.6050, 20.7120),
            heading = 257.9361,
          },
        
          [3] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2961.9202, 6592.1206, 20.7157),
            heading = 34.5248,
          },
        
          [4] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2961.7693, 6541.3823, 20.7711),
            heading =  125.37,
          },
        
          [5] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2950.6980, 6563.1973, 33.4981),
            heading = 224.8897,
          },
        
          [6] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2926.3696, 6564.7715, 33.5283),
            heading = 274.3124,
          },
        
          [7] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2926.3979, 6549.4155, 33.5283),
            heading = 265.8043,
          },
        
          [8] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2929.5640, 6583.6431, 36.9725),
            heading = 235.1166,
          },
        
          [9] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2929.7051, 6569.5449, 40.3618),
            heading = 279.9780,
          },
        
          [10] = {
            model = 's_m_m_security_01',
            gun = 'WEAPON_CARBINERIFLE',
            coords = vector3(-2958.7378, 6546.6528, 40.3920),
            heading = 251.8731,
          }    
    }
}

Config.ContainerComputerCoords = vector3(-2942.3530, 6553.1191, 42.4941)

Config.ContainerCamera = { 
    ['ropeStartCoords'] = vector3(-2943.1350, 6554.8267, 35.2850),
    ['cameraCoords'] = vector4(-2942.919921875,6555.9077148438,29.839897155762,-83.000457763672),
    ['cameraRotation'] = vector3(-8.90459205038507,-179.75877380371,98.0),
}

Config.Selling = {
    ['handlerSpawn'] = vector4(472.4605, -3300.3591, 6.2672, 268.3185),
    ['trailerSpawn'] = vector4(490.0994, -3370.6284, 5.0699, 359.0472),
    ['truckSpawn'] = vector4(475.4806, -3351.5847, 5.1366, 271.1685),

    ['bossLocation'] = vector3(1621.3798, -2243.9932, 107.1099),
    ['bossPeds'] = { 
        ['boss'] = { 
            ['model'] = "g_m_m_armboss_01",
            ['coords'] = vector4(1621.3798, -2243.9932, 106.1099, 292.2271)
        },
        ['securities'] =  {
            [1] = { 
                ['model'] = "a_m_m_eastsa_01",
                ['coords'] = vector4(1619.4391, -2246.0422, 106.1693, 317.4598),
                ['pedGun'] = "WEAPON_PISTOL",
            },
            [2] = { 
                ['model'] = "a_m_m_eastsa_01",
                ['coords'] = vector4(1617.9150, -2244.1824, 106.1693, 282.8004),
                ['pedGun'] = "WEAPON_PISTOL",
            },

            [3] = { 
                ['model'] = "g_m_m_mexboss_01",
                ['coords'] = vector4(1618.4403, -2241.7549, 106.1686, 256.6182),
                ['pedGun'] = "WEAPON_PISTOL",
            },
        },
        ['vehicle'] = { 
            ['model'] = "huntley",
            ['coords'] = vector4(1619.9198, -2251.3315, 106.4903, 280.3278)
        }
    },
}

Config.PoliceAI = { 
    ['active'] = true,
    ['cronSystem'] = { 
        ['active'] = false,
        ['startAt'] = "23:00",
        ['stopAt'] = "06:00"
    },
    ['Vehicles'] = {
        [1] = {['model'] = `predator`, ['coords'] = vector4(-2877.0083, 6603.1953, 1.5394, 118.0697)},
        [2] = {['model'] = `predator`, ['coords'] = vector4(-2918.1460, 6664.6792, 1.4075, 164.4871)},
        [3] = {['model'] = `predator`, ['coords'] = vector4(-3061.1169, 6580.3154, 1.8159, 262.1642)},

        [4] = {['model'] = "predator", ['coords'] = vector4(-3264.5203, 3710.9578, 0.6589, 128.0616)},
        [5] = {['model'] = "predator", ['coords'] = vector4(-3247.5852, 3685.2229, 1.7386, 98.3281)},
        [6] = {['model'] = "predator", ['coords'] = vector4(-3237.6279, 3666.6948, 2.9741, 84.7472)},
        [7] = {['model'] = "polmav", ['coords'] = vector4(-3261.9573, 3842.3997, 15.0183, 124.7196)},
        [8] = {['model'] = "polmav", ['coords'] = vector4(-3251.2041, 3721.1943, 15.6471, 130.4967)},

        [9] = {['model'] = "predator", ['coords'] = vector4(-3824.7444, 543.8066, 0.5381, 6.5236)},
        [10] = {['model'] = "predator", ['coords'] = vector4(-3834.6692, 545.8801, 2.0124, 0.5962)},
        [11] = {['model'] = "predator", ['coords'] = vector4(-3786.2983, 532.7228, 3.6447, 350.5398)},
    },
}