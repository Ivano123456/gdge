while not Config do Wait(1) end

Config.CourtHearings = {}

Config.CourtHearings.TVs = { -- TV's with incoming court hearings
    ['LegionSquare_1'] = {
        coords = vector3(93.815, -854.852, 35.300),
        rotation = vector3(0.0, 0.0, -20.671),
        distance = 30.0 -- spawn distance
    },

    -- FM CITY HALL LS
    -- ['LS_1'] = {
    --     coords = vector3(-508.8709, -609.7953, 36.2965),
    --     rotation = vector3(0.0, 0.0, 268.4732),
    --     distance = 30.0 -- spawn distance
    -- },
}

-- If you want to manage TV Players, remember you shouldn't restart the script while u on server because it will break the TV
Config.CourtHearings.EnableTVCreator = false -- enable TV creator [/tv_creator command]

Config.CourtHearings.TVPlayer = { -- playable TV's
    ['LegionSquare_1'] = {
        coords = vec3(65.748207, -860.823486, 37.217072),
        menuCoords = vector3(64.3359, -859.8571, 35.3171),
        rotation = vec3(0.000000, 0.000000, -159.000000),
        scale = vector3(1.35, 1.35, 1.35), -- scale x, y, z
        distance = 7.5, -- spawn distance
        jobs = {['sud'] = 0}, -- which jobs can manage the TV
    },

    -- FM CITY HALL LS
    -- ['LS_1'] = {
    --     coords = vec3(-524.146790, -585.560364, 37.803066),
    --     menuCoords = vector3(-523.7545, -583.8952, 35.7031),
    --     rotation = vec3(000000, 0.000000, -90.257896),
    --     scale = vector3(1.35, 1.35, 1.35), -- scale x, y, z
    --     distance = 7.5, -- spawn distance
    --     jobs = {['doj'] = 0}, -- which jobs can manage the TV
    -- },
}


Config.CourtHearings.Gavels = { -- Gavel's on Court hearings
    ['LegionSquare_1'] = {
        coords = vector3(-1568.8843, 220.7719, 59.4434),
        jobs = {['sud'] = 0},
        volume = 1.0, -- sound volume [0.0 - 1.0]
        distance = 17.5 -- sound distance
    },

    -- FM CITY HALL LS
    -- ['LS_1'] = {
    --     coords = vector3(-516.02, -589.89, 36.2),
    --     jobs = {['sud'] = 0},
    --     volume = 0.5, -- sound volume [0.0 - 1.0]
    --     distance = 17.5 -- sound distance
    -- },
}

Config.CourtHearings.Microphones = {
    ['LegionSquare_Judge'] = {
        coords = vector3(-1568.8137, 220.6636, 59.4435),
    },
    ['LegionSquare_Defense'] = {
        coords = vector3(-1572.0559, 219.0904, 58.8536),
    },
    ['LegionSquare_Prosecutor'] = {
        coords = vector3(-1570.0327, 222.7751, 59.4434),
    },

    -- FM CITY HALL LS
    -- ['LS_Judge'] = {
    --     coords = vector3(-516.6210, -589.0395, 36.2142),
    -- },
    -- ['LS_Defense'] = {
    --     coords = vector3(-518.3167, -595.8582, 35.6031),
    -- },
    -- ['LS_Prosecutor'] = {
    --     coords = vector3(-513.0540, -595.8336, 35.6031),
    -- },
}