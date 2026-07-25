Config = {}

Config.TargetDistance = 2.5

Config.Items = {
    {
        id = 'bandage',
        item = 'bandage',
        label = 'Bandage',
        description = 'Sterilna zavojna traka za brzu prvu pomoć. Zaustavlja krvarenje i stabilizuje manje povrede.',
        category = 'prva_pomoc',
        tag = 'Prva pomoć',
        icon = 'fa-bandage',
        price = 50,
        maxQty = 10,
        stats = { tip = 'Prva pomoć', efekat = 'Lečenje rana' },
    },
    {
        id = 'redxtableta',
        item = 'redxtableta',
        label = 'RedX Tableta',
        description = 'Antistres lek koji smanjuje napetost za 10%. Preporučeno posle intenzivnih situacija.',
        category = 'lekovi',
        tag = 'Antistres',
        icon = 'fa-pills',
        price = 120,
        maxQty = 5,
        stats = { tip = 'Antistres', efekat = '-10% stress' },
    },
    {
        id = 'adrenalin',
        item = 'adrenalin',
        label = 'Adrenalin',
        description = 'Injekcija za hitno oživljavanje osobe u kritičnom stanju.',
        category = 'prva_pomoc',
        tag = 'Hitna pomoć',
        icon = 'fa-syringe',
        price = 10000,
        maxQty = 3,
        stats = { tip = 'Revive', efekat = 'Oživljava osobu' },
    },
}

Config.Shops = {
    del_perro = {
        label = 'Apoteka Jamaica',
        ped = vector4(-813.9956, -1234.9435, 6.7205, 316.3652),
        pedModel = `s_f_y_scrubs_01`,
        blip = false,
    },
}
