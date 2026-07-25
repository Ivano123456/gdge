Config = {}

Config.Peds = {
    ['entrance'] = {
        ['model'] = 'a_m_y_business_03',
        ['coords'] = vector4(-268.90, -962.31, 30.22, 290.37),
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['name'] = 'Recepcioner',
        ['entity'] = 'jamaica_apartmani_entrance'
    },
    ['exit'] = {
        ['model'] = 'a_f_y_business_04',
        ['coords'] = vector4(-273.56, -967.13, 76.23, 245.78),
        ['scenario'] = 'WORLD_HUMAN_STAND_IMPATIENT',
        ['name'] = 'Izlaz iz Apartmana',
        ['entity'] = 'jamaica_apartmani_exit'
    },
    ['stash'] = {
        ['model'] = 's_m_m_security_01',
        ['coords'] = vector4(-270.64, -958.02, 76.24, 154.19),
        ['scenario'] = 'WORLD_HUMAN_GUARD_STAND',
        ['name'] = 'Zaštitar Sefa',
        ['entity'] = 'jamaica_apartmani_stash'
    },
    ['wardrobe'] = {
        ['model'] = 's_f_m_shop_high',
        ['coords'] = vector4(-265.46, -948.16, 70.03, 153.14),
        ['scenario'] = 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT',
        ['name'] = 'Asistent Garderobe',
        ['entity'] = 'jamaica_apartmani_wardrobe'
    },
}

Config.Apartment = { 
    ['enter'] = {
        ['targetCoords'] = {
            vector3(-269.2933, -961.3566, 21.2231),
            vector3(-271.0760, -957.6136, 21.2231)
        },
        ['spawnCoords'] = vector3(-270.52, -968.18, 77.23)
    },
    ['leave'] = {
        ['targetCoords'] = vector3(-272.6179, -968.3309, 3.231),
        ['spawnCoords'] = vector3(-267.72, -958.23, 31.22),
    },
    ['stash'] = {
        ['targetCoords'] = vector3(-273.0247, -953.7875, 55.8288),
        ['name'] = "Obican Sef Apartmana",
        ['weight'] = 40000,
        ['slotsNumber'] = 50,
    },
    ['wardrobe'] = {
        ['targetCoords'] = vector3(-259.38, -951.75, 50.02),
        ['eventName'] = "fivem-appearance:clothingShop"
    },

    ['blip'] = {
        ['blipCoords'] = vector3(-269.2933, -961.3566, 31.2231),
        ['blipName'] = "Moj Apartman",
        ['blipId'] = 475,
        ['blipColor'] = 2
    }
}

Config.ApartmentBoundary = {
    center = vector3(-264.0, -958.0, 70.0),
    radius = 100.0,
    checkInterval = 2000,
}

Config.Command = {
    ['name'] = "provjeriapartman",
    ["allowedGroups"] = {
        "owner",
        "projectcoordinator",
        "headadmin"
    }
}

Config.Strings = {
    ['knocked_door'] = "Pokucao si na vrata.",
    ['left_apartment'] = "Napustio si apartman",
    ['apartment_locked'] = "Apartman zaključan, skriven sa liste",
    ['apartment_unlocked'] = "Apartman otključan, vidljiv na listi",
    ['no_citizenship'] = "Morate imati državljanstvo za pristup apartmanu!"
}