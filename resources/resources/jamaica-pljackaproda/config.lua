return {

    Notify = function(msg)
        return TriggerEvent('esx:showNotification', msg)
    end, 

    CallPolice = function()
    end,

    PolicijskiPoslovi = { 'police' },
    KolikoPolicijaca = 0, 
    TrajanjeAlarma = 30, -- sekundi
    CooldownVreme = 30, -- minuta globalni cooldown za sve prodavnice

    Prodavnice = {
        [1] = {
            ['startMarker'] = vec3(375.0069, 328.6609, 103.5661),
            ['registers'] = {
                vec3(373.5339, 328.0127, 104.8916), 
                vec3(373.1784, 326.3442, 104.8964)
            },
            ['safe_coords'] = vec4(379.3970, 327.8661, 100.4543, 255.7256),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
        [2] = {
            ['startMarker'] = vec3(25.9268, -1344.3938, 29.4968),
            ['registers'] = {
                vec3(25.1300, -1345.3353, 30.8252), 
                vec3(25.2333, -1347.2378, 30.8918)
            },
            ['safe_coords'] = vec4(30.7462, -1344.4976, 26.3849, 270.1184),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
        [3] = {
            ['startMarker'] = vec3(1135.6293, -980.8307, 46.4158),
            ['registers'] = {
                vec3(1134.8477, -982.3608, 47.7304)
            },
            ['safe_coords'] = vec4(1127.5176, -983.1862, 45.4157, 190.9032),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
        [4] = {
            ['startMarker'] = vec3(-1486.1481, -380.1414, 40.1634),
            ['registers'] = {
                vec3(-1486.7815, -378.4722, 41.4844)
            },
            ['safe_coords'] = vec4(-1481.3248, -373.4025, 39.1633, 45.9819),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
        [5] = {
            ['startMarker'] = vec3(-1224.0654, -907.9623, 12.3263),
            ['registers'] = {
                vec3(-1222.3638, -907.9043, 13.4941)
            },
            ['safe_coords'] = vec4(-1218.3092, -914.1924, 11.3262, 297.8695),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
        [6] = {
            ['startMarker'] = vec3(1959.8892, 3743.2310, 32.3435),
            ['registers'] = {
                vec3(1959.8147, 3741.7034, 33.6737),
                vec3(1960.5068, 3740.2273, 33.5195)
            },
            ['safe_coords'] = vec4(1964.1989, 3745.4019, 29.2317, 298.2121),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
        [7] = {
            ['startMarker'] = vec3(-3245.1758, 1001.6890, 12.8305),
            ['registers'] = {
                vec3(-3244.3691, 1000.8586, 13.9562),
                vec3(-3242.2898, 1000.5590, 14.1580)
            },
            ['safe_coords'] = vec4(-3244.8250, 1006.4020, 9.7186, 353.6832),
            ['safeProp'] = 'sf_prop_v_43_safe_s_bk_01a',
        }, 
    },

    BonusAktivan = true, 
    Bonus_Sef_Items = {
        { name = "black_money", label = "Prljave Pare Bonus", dobijanje = 20000 },
    },

    SefPdSafeBrojeva = 3,

    BlackListJobovi = {
        ['police'] = true,
        ['hitna'] = true, 
        ['piston'] = true, 
    }

}