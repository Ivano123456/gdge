Config                  = {}
-- BlipIgraca i Nabudzi se podesavaju PO MAFIJI u Config.Mafije (ne globalno)
-- BlipIgraca = true  -> blipovi clanova na mapi (gps.lua)
-- Nabudzi = true     -> vozila mafije dobijaju pancir pri spawnu
Config.PranjeProcenat = 10
Config.BossStashSlots = 100
Config.BossStashWeight = 1000000
Config.OrgBlipCacheMs = 2000
Config.OrgBlipMinRequestMs = 1500
Config.OrgBlipClientRefreshMs = 3000
Config.DrawDistance     = 20.0 -- 20.0 je dovoljno, ne treba ni manje ni vise...
Config.Optimizacija     = false -- Ruzni markeri ali zato 0.00ms uvijek :)
Config.MarkerSize       = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerHelikopter = { x = 6.0, y = 6.0, z = 2.5 }
Config.MarkerAuto       = { x = 3.0, y = 3.0, z = 3.0 }
Config.MarkerColor      = { r = 50, g = 50, b = 204 }
Config.KoristiSifruInv  = true -- Ukoliko zelite da koristite sifru za vase sefove, u configu mafija imate sifru :)
Config.Limit            = true -- Dali koristite limit? ako je true onda ce biti limit u sefovima i u pretrazivanju igraca, ako je false onda je tezina itema!
Config.Webhuk           = "" -- Ovdje dodajete svoj wehuk za mafije da imate logove itd :)
Config.UkljuciPranje    = true -- Globalni prekidac za pranje para u boss meniju
Config.Locale           = 'hr'
Config.Levelanje        = false -- Ovo stavite na true ako Å¾elite da mafije idu po levelima
Config.lvl1             = 25000 -- ovo je cijena za upgrade na lvl 1, otkljucava sef
Config.lvl2             = 50000 -- ovo je cijena za upgrade na lvl 2, shop za oruzja
Config.lvl3             = 75000 -- ovo je cijena za upgrade na lvl 3, shop za oruzja
Config.MarkerTypes      = {
    Brodovi = 35,
    BossMeni = 31,
    SpawnAuta = 36,
    ObicanMarker = 27,
    Helikopteri = 34,
    VracanjeAuta = 1,
    Oruzarnica = 21,
}


Config.Permisije = {
	["headadmin"] = true,
	["vodja_eventa"] = true,
	["vodja_lidera"] = true,
	["vodja_admina"] = true,
	["menadzer"] = true,
	["asistent"] = true,
	["suvlasnik"] = true,
	["vlasnik"] = true,
}

-- OVDJE DODAJETE NOVE POSLOVE SVE
Config.Mafije = {
    ballas = {
        Armories = { vector3(124.6097, -1959.2865, 15.2000) },
        Vehicles = { vector3(112.9245, -1951.3615, 20.7459) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "4795",
        BossActions = { vector3(123.7552, -1945.4767, 15.2248) },
        ParkirajAuto = { vector3(108.4625, -1944.0510, 20.3661) },
    },
    bratva = {
        Armories = { vector3(-111.1816, 999.5085, 235.7567) },
        Vehicles = { vector3(-123.2970, 1009.2371, 235.7321) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "5281",
        BossActions = { vector3(-112.9606, 986.0143, 235.7541) },
        ParkirajAuto = { vector3(-125.9325, 1000.8213, 234.9932) },
    },
    glodari = {
        Armories = { vector3(637.6401, 1258.2321, 367.2820) },
        Vehicles = { vector3(668.0150, 1272.9683, 361.0101) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        Boja = 0,
        Zatamni = true,
        BlipIgraca = false,
        Nabudzi = true,
        Sifra = "1987",
        Helikopter = { vector3(602.9431, 1295.7119, 360.9993) }, -- namesti koordinate
        MeniHelikoptera = {
            ['supervolito2'] = 'Supervolito 2'
        },
        BossActions = { vector3(-112.9606, 986.0143, 235.7541) },
        ParkirajAuto = { vector3(669.0013, 1281.5073, 360.9812) },
    },
    automafija = {
        Armories = { vector3(722.6727, -1020.9467, 5.2633) },
        Vehicles = { vector3(750.2936, -1048.3242, 0.9684) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan',
            ['SUNRISE2'] = 'Sunrise'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = true,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "9215",
        BossActions = { vector3(-112.9606, 986.0143, 235.7541) },
        ParkirajAuto = { vector3(740.0893, -1046.8397, 0.2684) },
    },
    camorra = {
        Armories = { vector3(-1925.6537, 386.5252, 96.6983) },
        Vehicles = { vector3(-1918.7772, 405.6990, 96.2960) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan',
            ['SUNRISE2'] = 'Sunrise'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "9215",
        BossActions = { vector3(-112.9606, 986.0143, 235.7541) },
        ParkirajAuto = { vector3(-1931.1184, 403.9373, 95.2972) },
    },
    kavacki = {
        Armories = { vector3(-1182.3021, 297.5584, 73.6456) },
        Vehicles = { vector3(-1197.4203, 277.2730, 63.6580) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan',
            ['SUNRISE2'] = 'Sunrise'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "9215",
        BossActions = { vector3(-112.9606, 986.0143, 235.7541) },
        ParkirajAuto = { vector3(-1203.2828, 282.9460, 62.6580) },
    },
    peaky = {
        Armories = { vector3(-1812.9204, 446.9660, 128.5111) },
        Vehicles = { vector3(-1794.0879, 457.8897, 128.3082) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan',
            ['SUNRISE2'] = 'Sunrise'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "9215",
        BossActions = { vector3(-1806.6198, 458.2318, 128.2765) },
        ParkirajAuto = { vector3(-1806.6198, 458.2318, 127.2765) },
    },
    cartel = {
        Armories = { vector3(-647.2380, 854.2178, 229.3440) },
        Vehicles = { vector3(-665.9793, 907.7815, 229.5837) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "7618",
        BossActions = { vector3(-658.4692, 886.5168, 229.2506) },
        ParkirajAuto = { vector3(-671.0449, 910.1615, 229.8206) },
    },
    casablanca = {
        Armories = { vector3(-1516.7773, 851.4125, 181.5948) },
        Vehicles = { vector3(-1531.1827, 851.6346, 181.5828) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "5111",
        BossActions = { vector3(-1520.3446, 849.1136, 181.5948) },
        ParkirajAuto = { vector3(-1542.1907, 888.0152, 181.1349) },
    },
    crips = {
        Armories = { vector3(-336.8680, 47.2143, 44.2238) },
        Vehicles = { vector3(-347.9461, 54.2469, 49.1073) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "9898",
        BossActions = { vector3(-343.6540, 70.2432, 54.4226) },
        ParkirajAuto = { vector3(-348.9021, 59.0077, 48.4043) },
    },
    ghost = {
        Armories = { vector3(9.4289, 534.9415, 170.6174) },
        Vehicles = { vector3(15.0470, 544.4541, 176.0181) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "4575",
        BossActions = { vector3(-10.3604, 530.8649, 170.6171) },
        ParkirajAuto = { vector3(14.4191, 548.3167, 175.6507) },
    },
    vpburgershot = {
        Armories = { vector3(-1202.4355, -890.5781, 13.9878) },
        Vehicles = { vector3(-1177.7339, -885.5867, 13.8619) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan',
            ['vwcaddy'] = 'Caddy'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "4548",
        BossActions = { vector3(-10.3604, 530.8649, 170.6171) },
        ParkirajAuto = { vector3(-1171.6586, -890.4094, 12.9403) },
    },
    beanmachine = {
        Armories = { vector3(116.6693, -1037.0225, 29.3050) },
        Vehicles = { vector3(108.7195, -1034.2080, 29.3561) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan',
            ['vwcaddy'] = 'Caddy'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "7421",
        BossActions = { vector3(118.4955, -1045.4022, 29.3050) },
        ParkirajAuto = { vector3(103.6133, -1040.0442, 29.2727) },
    },
    gsf = {
        Armories = { vector3(-15.8664, -1430.4478, 31.1015) },
        Vehicles = { vector3(-20.4979, -1444.8960, 30.6012) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = true,
        Nabudzi = false,
        Sifra = "7098",
        BossActions = { vector3(-18.3491, -1438.6615, 31.1015) },
        ParkirajAuto = { vector3(-25.1006, -1440.3201, 30.2866) },
    },
    lasveles = {
        Armories = { vector3(1366.9901, -623.3865, 74.7109) },
        Vehicles = { vector3(1361.4309, -608.3679, 74.3380) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "2368",
        BossActions = { vector3(1367.1208, -606.2709, 74.7109) },
        ParkirajAuto = { vector3(1359.9990, -603.4107, 73.7355) },
    },
    narcos = {
        Armories = { vector3(1415.5474, 1163.3584, 114.3342) },
        Vehicles = { vector3(1409.6808, 1115.9287, 114.8376) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "4349",
        BossActions = { vector3(1408.4633, 1160.0927, 114.3339) },
        ParkirajAuto = { vector3(1406.3383, 1119.4683, 114.3998) },
    },
    nostra = {
        Armories = { vector3(-975.9765, 104.0089, 55.8919) },
        Vehicles = { vector3(-966.6462, 110.0548, 55.7699) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "7250",
        BossActions = { vector3(-971.2881, 122.2534, 57.0486) },
        ParkirajAuto = { vector3(-960.7990, 110.3583, 55.8690) },
    },
    omerta = {
        Armories = { vector3(-1537.6179, 126.3375, 56.7801) },
        Vehicles = { vector3(-1535.7622, 97.6487, 56.7753) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "5864",
        BossActions = { vector3(-1537.0269, 130.4820, 57.3714) },
        ParkirajAuto = { vector3(-1530.4153, 83.7668, 56.2580) },
    },
    pink = {
        Armories = { vector3(-1583.6204, 21.2437, 59.5754) },
        Vehicles = { vector3(-1553.3585, 20.7041, 58.6180) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "5292",
        BossActions = { vector3(-1552.1255, 29.1265, 58.3083) },
        ParkirajAuto = { vector3(-1552.1255, 29.1265, 58.3083) },
    },
    sicilia = {
        Armories = { vector3(-803.3564, 185.5263, 72.6055) },
        Vehicles = { vector3(-819.9263, 181.0037, 71.8574) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "5959",
        BossActions = { vector3(-806.3162, 167.7657, 76.7408) },
        ParkirajAuto = { vector3(-824.6263, 179.8736, 71.0837) },
    },
    skyloft = {
        Armories = { vector3(175.9118, 1719.6527, 224.1401) },
        Vehicles = { vector3(173.1925, 1693.3937, 227.4106) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "2063",
        BossActions = { vector3(188.6966, 1713.5571, 231.0917) },
        ParkirajAuto = { vector3(170.7675, 1688.8273, 227.5955) },
    },
    sombra = {
        Armories = { vector3(-1886.1140, 2074.3264, 140.9978) },
        Vehicles = { vector3(-1895.5737, 2050.3958, 140.7516) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "7463",
        BossActions = { vector3(0.0, 0.0, 0.0) },
        ParkirajAuto = { vector3(-1887.3481, 2044.5862, 139.8613) },
    },
    vagos = {
        Armories = { vector3(452.2914, -1286.2791, 24.3617) },
        Vehicles = { vector3(476.6539, -1286.7451, 29.5590) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "9667",
        BossActions = { vector3(473.1223, -1297.5754, 30.3189) },
        ParkirajAuto = { vector3(484.4181, -1287.8893, 28.5713) },
    },
    vipers = {
        Armories = { vector3(-2601.4546, 1912.8490, 167.3203) },
        Vehicles = { vector3(-2583.0947, 1930.3794, 167.3169) },
        MeniVozila = {
            ['sanchez'] = 'Sanchez',
            ['sultan'] = 'Sultan'
        },
        Limit = 10,
        -- Boja = 145,
        Zatamni = false,
        BlipIgraca = false,
        Nabudzi = false,
        Sifra = "1717",
        BossActions = { vector3(-3232.9583, 813.1467, 14.0782) },
        ParkirajAuto = { vector3(-2595.0596, 1930.3346, 166.2976) },
    }
}

Config.Oruzje = {
    ulicar = {
        { weapon = 'WEAPON_APPISTOL', components = { 5000, 5000, 2000, 4000, nil }, price = 25000 }
    },
    diler = {
        { weapon = 'WEAPON_APPISTOL', components = { 2000, 2000, 1000, 4000, nil }, price = 1 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 75000 }
    },
    ubica = {
        { weapon = 'WEAPON_APPISTOL', components = { 2500, 2000, 1000, 4000, nil }, price = 25000 },
        { weapon = 'WEAPON_ADVANCEDRIFLE', components = { 8500, 6000, 1000, 4000, 8000, nil }, price = 125000 }
    },
    novi = {
        { weapon = 'WEAPON_APPISTOL', components = { 5000, 5000, 2000, 4000, nil }, price = 25000 }
    },
    radnik = {
        { weapon = 'WEAPON_APPISTOL', components = { 2000, 2000, 1000, 4000, nil }, price = 1 },
        { weapon = 'WEAPON_ADVANCEDRIFLE', components = { 2000, 6000, 1000, 4000, 8000, nil }, price = 501000 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 1 }
    },
    zamenik = {
        { weapon = 'WEAPON_APPISTOL', components = { 2500, 2000, 1000, 4000, nil }, price = 25000 },
        { weapon = 'WEAPON_ADVANCEDRIFLE', components = { 8500, 6000, 1000, 4000, 8000, nil }, price = 125000 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 6500, 6000, nil }, price = 75000 }
    },
    boss = {
        { weapon = 'WEAPON_APPISTOL', components = { 2500, 2000, 1000, 4000, nil }, price = 25000 },
        { weapon = 'WEAPON_ADVANCEDRIFLE', components = { 8500, 6000, 1000, 4000, 8000, nil }, price = 125000 },
        { weapon = 'WEAPON_PUMPSHOTGUN', components = { 6500, 6000, nil }, price = 75000 }
    }
}

Config.Ratovi = {
    Ukljuceno = true,
    MinClanova = 1,
    MaxRatovaDnevno = 2,
    TrajanjeOpcije = { 15, 20 },
    MinutaPrijeRata = 5,
    BlipRefreshMs = 2000,
}

------------- ne dirati --------------
insertuj = function(tabla, podatak)
	tabla[#tabla + 1] = podatak
end
