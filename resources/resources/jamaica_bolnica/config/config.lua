Jamaica =
{
    PotrebanPosao = 'hitna',
    --
    Blip =
    {
        Koordinate = vec3(-813.6456, -1231.8682, 6.7260),
        Ime = "Bolnica",
        Sprite = 61,
        Display = 2,
        Boja = 1,
        Velicina = 1.0
    },
    --
    Koordinate =
    {
        Respawn =
        {
            {
                Koordinate = vec3(-798.8041, -1203.5425, 6.7205),
                Heading = 136.0148
            },
            Sekunde = 600
        },
        Odjeca =
        {
            Objekt = "prop_dress_disp_02",
            Koordinate = vec3(-807.5707, -1224.8302, 11.3143),
            Heading = 244.3899,
            Opcije =
            {
                {
                    label = "Bolnicka Garderoba",
                    icon = "fa-solid fa-vest",
                    iconColor = "red",
                    distance = 1.5,
                    onSelect = function()
                        return exports['jamaica-core']:OpenJobWardrobe()
                    end
                }
            }
        },
        Vozila =
        {
            ModelPED = "s_m_m_doctor_01",
            Koordinate = vec3(-820.5632, -1214.3130, 6.9353),
            Heading = 48.7222,
            Opcije =
            {
                {
                    label = "Bolnicka Vozila",
                    icon = "fa-solid fa-truck-medical",
                    iconColor = "red",
                    distance = 1.5,
                    onSelect = function()
                        return TriggerEvent("jamaica_bolnica>client>OtvoriMenu", "Vozila")
                    end
                }
            },
            Spawn =
            {
                Koordinate = vec3(-829.1060, -1218.7019, 6.5643),
                Heading = 321.0282
            },
            Vracanje =
            {
                Koordinate = vec3(-829.1060, -1218.7019, 6.5643),
                Heading = 321.0282
            },
            Nadogradnje =
            {
                color1 = 39,
                color2 = 39,
                customPrimaryColor = {205, 33, 42},
                customSecondaryColor = {205, 33, 42},
                interiorColor = 39,
                dashboardColor = 39,
                customXenonColor = {205, 33, 42},
                modXenon = true
            }
        },
        Sef =
        {
            Objekt = "prop_ld_int_safe_01",
            Koordinate = vec3(-818.6194, -1225.1434, 11.3143),
            Heading = 136.8823,
            Opcije = 
            {
                {
                    label = "Pristupi Sefu",
                    icon = "fa-solid fa-vault",
                    iconColor = "red",
                    distance =1.5,
                    onSelect = function()
                        return TriggerEvent("jamaica_bolnica>client>OtvoriMenu", "Sef")
                    end
                }
            },
            Slotovi = 30,
            Kilaza = 200000
        },
        Adrenalin =
        {
            ModelPED = "s_m_m_doctor_01",
            Koordinate = vec3(-790.3855, -1241.7032, 11.3143),
            Heading = 234.1951,
            Kolicina = 15,
            CooldownMinuta = 60,
            BandageKolicina = 30,
            GpsKolicina = 1,
            Opcije =
            {
                {
                    label = "Uzmi Adrenalin",
                    icon = "fa-solid fa-syringe",
                    iconColor = "red",
                    distance = 1.5,
                    onSelect = function()
                        return TriggerServerEvent("jamaica_bolnica>server>UzmiAdrenalin")
                    end
                },
                {
                    label = "Uzmi Bandaze",
                    icon = "fa-solid fa-bandage",
                    iconColor = "red",
                    distance = 1.5,
                    onSelect = function()
                        return TriggerServerEvent("jamaica_bolnica>server>UzmiBandaze")
                    end
                },
                {
                    label = "Uzmi GPS",
                    icon = "fa-solid fa-location-dot",
                    iconColor = "red",
                    distance = 1.5,
                    onSelect = function()
                        return TriggerServerEvent("jamaica_bolnica>server>UzmiGps")
                    end
                }
            }
        },
        Helikopteri =
        {
            ModelPED = "s_m_m_doctor_01",
            Koordinate = vec3(-834.3608, -1230.8685, 6.9339),
            Heading = 51.3706,
            Opcije =
            {
                {
                    label = "Bolnicki Helikopteri",
                    icon = "fa-solid fa-helicopter",
                    iconColor = "red",
                    distance =1.5,
                    onSelect = function()
                        return TriggerEvent("jamaica_bolnica>client>OtvoriMenu", "Helikopteri")
                    end
                },
                {
                    label = "Obrisi Helikopter",
                    icon = "fa-solid fa-trash",
                    iconColor = "red",
                    distance =1.5,
                    onSelect = function()
                        return TriggerEvent("jamaica_bolnica>client>ObrisiVozilo", "Helikopter")
                    end
                }
            },
            Spawn =
            {
                Koordinate = vec3(-834.3608, -1230.8685, 6.9339),
                Heading = 51.3706
            },
            Nadogradnje =
            {
                color1 = 39,
                color2 = 39,
                customPrimaryColor = {205, 33, 42},
                customSecondaryColor = {205, 33, 42},
                interiorColor = 39,
                dashboardColor = 39,
                customXenonColor = {205, 33, 42},
                modXenon = true
            }
        },
        Propovi =
        {
            {
                Model = "imp_prop_engine_hoist_02a",
                Koordinate = vec3(1839.249, 3687.354, 34.04332),
                Heading = 133.9722
            },

            {
                Model = "imp_prop_engine_hoist_02a",
                Koordinate = vec3(-1054.8867, -869.9349, 5.1553),
                Heading = 324
            },
            {
                Model = "imp_prop_engine_hoist_02a",
                Koordinate = vec3(292.7926, -351.4850, 44.980),
                Heading =  227.6529
            }
        }
    },
    --
    Vozila =
    {
        {
            Model = "DLRSQ8EMS",
            Label = "Audi Q8"
        }
    },
    --
    Helikopteri =
    {
        {
            Model = "AW109",
            Label = "Bolnicarski Heli"
        }
    },
    --
    RevivePlaca = 1500,
    BandagePlaca = 500,
    --
    Izlijeci = 100,
    --
    NLR =
    {
        Vrijeme = 30,
        Upozorenja = 3,
        Markeri = 20
    },
    --
    SelfRevive =
    {
        Sekunde = 30
    },
    --
    NPCBolnicar = {
        ModelPEDa = 's_m_m_doctor_01',
        ModelVozila = 'ambulance'
    },
    --
    AdminGrupe = {
        'vlasnik',
        'suvlasnik',
        'asistent',
        'menadzer',
        'vodja_admina',
        'vodja_lidera',
        'vodja_eventa',
        'headadmin',
        'superadmin',
        'admin',
        'helper',
    }
}
