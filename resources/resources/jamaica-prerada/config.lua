Config = {}

Config.TargetDistance = 2.0

Config.Recipes = {
    cocaine = {
        id = 'cocaine',
        label = 'Kokain prerada',
        icon = 'fa-solid fa-snowflake',
        input = { item = 'cocaine_list', count = 3, label = 'Cocain List' },
        output = { item = 'cocaine', count = 1, label = 'Kokain' },
        duration = 8000,
        progressLabel = 'Prerada kokaina...',
        anim = {
            dict = 'anim@amb@business@coc@coc_unpack_cut@',
            clip = 'fullcut_cycle_v1_cokecutter',
            flag = 1,
        },
    },
    weed = {
        id = 'weed',
        label = 'Kesica vutre prerada',
        icon = 'fa-solid fa-cannabis',
        input = { item = 'cannabis', count = 3, label = 'Cannabis' },
        output = { item = 'kesica_vutre', count = 1, label = 'Kesica vutre' },
        duration = 7000,
        progressLabel = 'Pripremas kesicu vutre...',
        anim = {
            dict = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@',
            clip = 'weed_stand_checkingleaves_kneeling_01_inspector',
            flag = 1,
        },
    },
}

Config.Stations = {
    cocaine = {
        id = 'cocaine',
        recipe = 'cocaine',
        label = 'Sto za preradu kokaina',
        targetLabel = 'Preradi kokain',
        targetIcon = 'fa-solid fa-snowflake',
        coords = vector4(1416.5780, 6360.4009, 24.0055, 349.9663),
        prop = 'bkr_prop_coke_table01a',
    },
    weed = {
        id = 'weed',
        recipe = 'weed',
        label = 'Sto za preradu trave',
        targetLabel = 'Preradi kesicu vutre',
        targetIcon = 'fa-solid fa-cannabis',
        coords = vector4(730.7596, 2531.8940, 73.2236, 90.0226),
        prop = 'bkr_prop_weed_table_01a',
    },
}
