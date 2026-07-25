Config = {
    Framework = "esx", -- qb, esx
    ProgressBarType = "ox_progressbar", -- qb_progressbar, ox_progressbar, custom_progressbar
    BorrowOfVehicle = false, -- Can a player take a ped's vehicle with player work ID Card
    Locale = "en",
    IdCard = "id_card", -- Item name for ID Card
    JobCard = "job_card", -- Item name for Job Card
    FakeIdCard = "fake_id_card", -- Item name for Fake Id Card
    FakeJobCard = "fake_job_card", -- Item name for Fake Job Card
    DriverLicense = "driver_license", -- Item name for Driver License
    WeaponLicense = "weapons_license", -- Item name for Weapon License
    Inventory = 'ox_inventory', -- [ 'qb-inventory' / 'ox_inventory' / 'quasar-inventory' / 'codem-inventory' ]
    InteractType = 'ox_target', -- = [ 'drawtext' / 'ox_target' / 'qb-target' ]

    UseQbLicense = false,
    UseEsxLicense = true,

    FakeCardPrice = 100000,

    BadgeAnimation = {
        dict = "paper_1_rcm_alt1-9",
        anim = "player_one_dual-9",
        prop = "prop_fib_badge",
    },

    FakeCardPed = {
        model = "s_m_y_cop_01",
        coords = vector4(839.5072, 2176.6858, 52.2889, 152.9322),
    },

    JobCardPed = {
        model = "s_m_y_cop_01",
        coords = vector4(-584.0831, -422.1900, 35.1785, 274.8436),
    },
    
    Jobs = { -- you can add jobs here to open Job Card Create
        'police',
        'hitna',
    },

    GeneralCardPed = {
        model = "s_m_y_cop_01",
        coords = vector4(-584.1147, -417.2137, 35.1846, 269.7919),
    },

    BorrowWhitelist = {
        ["police"] = true,
    },

    GiveVehicleKey = function(plate)
        if Config.Framework == "qb" then
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        elseif Config.Framework == "esx" then
            TriggerServerEvent("esx_vehicleshop:giveVehicleKeys", plate)
        end
    end,

    CoreExport = function()
        if Config.Framework == "qb" then
            return exports["qb-core"]:GetCoreObject()
        elseif Config.Framework == "esx" then
            return exports["es_extended"]:getSharedObject()
        end
    end,

    Notify = function(message, type)
        if Config.Framework == "qb" then
            TriggerEvent('QBCore:Notify', message, type, 5000)
        else
            Framework.ShowNotification(message)
        end
    end,
    
    -- These are the card types that will be shown depend on the grade.
    CardTypes = {
        ["citizen"] = { -- This will be selected if player has non of the jobs below.
            job = "citizen", -- dont change this
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#555555",
                    text = "Citizen Card",
                },
            }
        },
        ["driver"] = {
            job = "driver", -- dont change this
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#555555",
                    text = "Drivers License",
                },
            }
        },
        ["weapon"] = {
            job = "weapon", -- dont change this
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Weapon License",
                },
            }
        },
        ["police"] = {
            job = "police",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Kadet",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Policajac",
                },
                [2] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Stariji Policajac",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Interventna",
                },
                [4] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Inspektor",
                },
                [5] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Visi Inspektor",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Vodja Inspektora",
                },
                [7] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Vodja Interventne",
                },
                [8] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Narednik",
                },
                [9] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Komandir",
                },
                [10] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Zamenik Nacelnika",
                },
                [11] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Nacelnik",
                },
            }
        },
        ["hitna"] = {
            job = "hitna",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Pripravnik",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Bolnicar",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Doktor",
                },
                [3] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Glavni Doktor",
                },
                [4] = {
                    cardType = "four",
                    textColor = "#FFFFFF",
                    text = "Nacelnik",
                },
            }
        },
        ["sheriff"] = {
            job = "sheriff",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Sheriff Card",
                },
            }
        },
        ["justice"] = {
            job = "justice",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
            }
        },
        ["fib"] = {
            job = "fib",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
            }
        },
    }
}