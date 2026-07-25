Config = {}

Config.DMVSchool = {
    vector3(214.09, -1399.71, 30.58)
}

Config.ReturnMarker = {
    coords = vector3(215.64, -1398.93, 29.58),
    type = 1,
    size = vector3(1.5, 1.5, 1.5),
    color = vector3(255, 255, 255),
    rotate = false,
    bump = false
}

Config.Language = "bs"

Config.SpeedMultiplier = 3.6 -- 3.6 for kmh, 2.236936 for mph

Config.MaxErrors = 3 -- Max errors before fail

Config.MarkerSettings = {
    type = 2,
    size = vector3(1.5, 1.5, 1.5),
    color = vector3(255, 255, 0),
    rotate = false,
    bump = false
}

Config.PuntiMinimi = 7 -- Minimum points to pass the theory test

-- ATTENTION: Modifying the id after a user has already obtained a license causes them to be lost
Config.License = {
    {
        label = 'Licenca A',
        id = 'bike',
        img = 'license-bike.jpg',
        esxLicenseType = 'drive_bike',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'faggio',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    },
    {
        label = 'Licenca B',
        id = 'car',
        img = 'license-car.jpg',
        esxLicenseType = 'drive',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'blista',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    },
    {
        label = 'Licenca C',
        id = 'truck',
        img = 'license-truck.jpg',
        esxLicenseType = 'drive_truck',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'boxville',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    }
}

Config.PracticeCoords = {
    [1] = {
        {
            coordinate = vector3(227.1181, -1399.691, 30.1),
            speedLimit = 50
        },
        {
            coordinate = vector3(183.7479, -1394.595, 29.05295),
            speedLimit = 50
        },
        {
            coordinate = vector3(210.3608, -1327.127, 29.16619),
            speedLimit = 50
        },
        {
            coordinate = vector3(217.6466, -1145.248, 29.3349),
            speedLimit = 50
        },
        {
            coordinate = vector3(83.13854, -1136.699, 29.15778),
            speedLimit = 50
        },
        {
            coordinate = vector3(55.52874, -1248.127, 29.34311),
            speedLimit = 50
        },
        {
            coordinate = vector3(82.69904, -1338.678, 29.3447),
            speedLimit = 50
        },
        {
            coordinate = vector3(131.4893, -1387.581, 29.28993),
            speedLimit = 50
        },
        {
            coordinate = vector3(220.603, -1445.61, 29.24681),
            speedLimit = 50
        },
        {
            coordinate = vector3(242.2584, -1536.136, 29.24705),
            speedLimit = 50
        },
        {
            coordinate = vector3(301.6448, -1523.68, 29.34156),
            speedLimit = 50
        },
        {
            coordinate = vector3(256.1726, -1445.458, 29.24207),
            speedLimit = 50
        },
        {
            coordinate = vector3(233.427, -1397.215, 30.5071),
            speedLimit = 50
        },
    }
}


Config.Question = {
    ['bs'] = {
        [1] = {
            {
                label = "Koja je boja znaka zabrane?",
                options = {
                    {
                        label = "Crvena",
                        correct = true
                    },
                    {
                        label = "Plava",
                        correct = false
                    },
                    {
                        label = "Žuta",
                        correct = false
                    }
                }
            },
        {
            label = "Šta označava saobraćajni znak u obliku trougla?",
            options = {
                {
                    label = "Raskrsnica sa tri puta",
                    correct = false
                },
                {
                    label = "Daj prednost",
                    correct = true
                },
                {
                    label = "Jednosmjerna ulica",
                    correct = false
                }
            }
        },
        {
            label = "Šta znači puna linija na putu?",
            options = {
                {
                    label = "Smije se preticati",
                    correct = false
                },
                {
                    label = "Zabranjeno preticanje",
                    correct = true
                },
                {
                    label = "Preticanje dozvoljeno samo desno",
                    correct = false
                }
            }
        },
        {
            label = "Koliko je ograničenje brzine u naselju?",
            options = {
                {
                    label = "50 km/h",
                    correct = true
                },
                {
                    label = "70 km/h",
                    correct = false
                },
                {
                    label = "90 km/h",
                    correct = false
                }
            }
        },
        {
            label = "Šta označava znak upozorenja sa kamerom?",
            options = {
                {
                    label = "Zona parkinga",
                    correct = false
                },
                {
                    label = "Zona zabrane zaustavljanja",
                    correct = false
                },
                {
                    label = "Elektronska kontrola brzine",
                    correct = true
                }
            }
        },
        {
            label = "Koliko je minimalno bezbjednosno rastojanje od vozila ispred?",
            options = {
                {
                    label = "1 metar",
                    correct = false
                },
                {
                    label = "2 sekunde razmaka",
                    correct = true
                },
                {
                    label = "0,5 metara",
                    correct = false
                }
            }
        },
        {
            label = "Šta vozač treba učiniti kada priđe željezničkom prelazu sa spuštenom rampom?",
            options = {
                {
                    label = "Ubrzati kako bi prešao prije nego se rampa potpuno spusti",
                    correct = false
                },
                {
                    label = "Preći samo ako nema dolazećih vozova",
                    correct = false
                },
                {
                    label = "Zaustaviti se i sačekati",
                    correct = true
                }
            }
        },
        {
            label = "Šta predstavlja znak STOP?",
            options = {
                {
                    label = "Daj prednost",
                    correct = false
                },
                {
                    label = "Obavezno zaustavljanje",
                    correct = true
                },
                {
                    label = "Jednosmjerna ulica",
                    correct = false
                }
            }
        },
        {
            label = "Šta označava znak sa zelenom strelicom prema gore?",
            options = {
                {
                    label = "Put dozvoljen samo biciklima",
                    correct = false
                },
                {
                    label = "Put dozvoljen samo pješacima",
                    correct = true
                },
                {
                    label = "Put rezervisan za javni prevoz",
                    correct = false
                }
            }
        },
        {
            label = "Koji je dozvoljeni nivo alkohola u krvi za vozače?",
            options = {
                {
                    label = "0,0 promila",
                    correct = false
                },
                {
                    label = "0,3 promila",
                    correct = true
                },
                {
                    label = "0,5 promila",
                    correct = false
                }
            }
        }
        },
        [2] = {
        {
            label = "Šta označava znak zabrane pristupa?",
            options = {
                {
                    label = "Obaveza davanja prednosti",
                    correct = false
                },
                {
                    label = "Zabrana prolaza",
                    correct = true
                },
                {
                    label = "Obavezno preticanje",
                    correct = false
                }
            }
        },
        {
            label = "Šta vozač treba učiniti kada priđe raskrsnici bez znakova?",
            options = {
                {
                    label = "Ubrzati kako bi brzo prešao",
                    correct = false
                },
                {
                    label = "Zaustaviti se, dati prednost i pažljivo nastaviti",
                    correct = true
                },
                {
                    label = "Trubiti kako bi upozorio druge vozače",
                    correct = false
                }
            }
        },
        {
            label = "Šta označava znak opasne krivine lijevo?",
            options = {
                {
                    label = "Blizina odmorišta",
                    correct = false
                },
                {
                    label = "Prisutnost raskrsnice",
                    correct = false
                },
                {
                    label = "Prisutnost opasne lijeve krivine",
                    correct = true
                }
            }
        },
        {
            label = "Koliko je maksimalna brzina na autoputu?",
            options = {
                {
                    label = "130 km/h",
                    correct = true
                },
                {
                    label = "100 km/h",
                    correct = false
                },
                {
                    label = "80 km/h",
                    correct = false
                }
            }
        },
        {
            label = "Šta predstavlja znak pješačkog prelaza?",
            options = {
                {
                    label = "Prelaz dozvoljen samo biciklima",
                    correct = false
                },
                {
                    label = "Zabrana prelaska pješacima",
                    correct = false
                },
                {
                    label = "Mjesto gdje pješaci mogu bezbijedno preći",
                    correct = true
                }
            }
        },
        {
            label = "Kada se smije koristiti daleko svjetlo?",
            options = {
                {
                    label = "Uvijek noću",
                    correct = false
                },
                {
                    label = "Kada ima susretnog vozila",
                    correct = false
                },
                {
                    label = "Samo kada nema susretnog saobraćaja",
                    correct = true
                }
            }
        },
        {
            label = "Šta predstavlja plavi saobraćajni znak?",
            options = {
                {
                    label = "Zabrana",
                    correct = false
                },
                {
                    label = "Obaveza ili naredba",
                    correct = true
                },
                {
                    label = "Opasnost",
                    correct = false
                }
            }
        },
        {
            label = "Kako treba reagovati na žuto trepćuće svjetlo na semaforu?",
            options = {
                {
                    label = "Ubrzati da se prođe prije promjene",
                    correct = false
                },
                {
                    label = "Nastaviti oprezno s posebnom pažnjom",
                    correct = true
                },
                {
                    label = "Nastaviti normalno bez usporavanja",
                    correct = false
                }
            }
        },
        {
            label = "Koliko je minimalna starost za B kategoriju vozačke dozvole?",
            options = {
                {
                    label = "16 godina",
                    correct = false
                },
                {
                    label = "18 godina",
                    correct = true
                },
                {
                    label = "21 godina",
                    correct = false
                }
            }
        },
        {
            label = "Da li je dozvoljeno korištenje mobilnog telefona tokom vožnje?",
            options = {
                {
                    label = "Da, uvijek",
                    correct = false
                },
                {
                    label = "Samo sa hands-free uređajem",
                    correct = true
                },
                {
                    label = "Da, ako se vozi polako",
                    correct = false
                }
            }
        }
        }
    }
}


Config.Lang = {
    ['bs'] = {
        ['speed_error'] = "Vozite prebrzo, usporite!",
        ['open_dmv'] = "Pritisnite ~INPUT_CONTEXT~ da otvorite auto-školu",
        ['dmv'] = "AUTO-ŠKOLA",
        ['point'] = "BODOVI",
        ['error'] = "GREŠKE",
        ['ok'] = "DALJE",
        ['finish'] = "ZAVRŠENO",
        ['start_theory'] = "Teorijski Ispit",
        ['theory_before'] = "POLOŽITE TEORIJU",
        ['start_practice'] = "Praktični Ispit",
        ['test_passed'] = "Ispit Položen!",
        ['already_done'] = "POLOŽENO",
        ['theory_success'] = "Čestitamo, položili ste teorijski ispit! Vratite se uskoro za praktični dio!",
        ['theory_error'] = "Nažalost niste položili teorijski ispit. Ne odustajte, vratite se bolje pripremljeni i pokušajte ponovo!",
        ['practice_success'] = "Čestitamo, položili ste praktični ispit! Sada ste licencirani vozač!",
        ['practice_error'] = "Nažalost niste položili praktični ispit. Ne odustajte, vratite se bolje pripremljeni i pokušajte ponovo!",
        ['money_error'] = "Nemate dovoljno novca za ovaj ispit! Nedostaje vam %s€"
    }
}