function GetSharedState(key, value)
    return GetCurrentResourceName() .. '_' .. key .. value
end

function Debug(message)
    if Config.debug then
        print(message)
    end
end

function Chance(chance)
    return math.random(1, 100) <= chance
end

local cells = {
    { door_offset = vector3(-1.5, 0.0, 1.68),  item_offset = vector3(-1.75, 0.3, 1.72), size = 'medium' },
    { door_offset = vector3(-1.5, 0.0, 1.38),  item_offset = vector3(-1.75, 0.3, 1.42), size = 'medium' },
    { door_offset = vector3(-1.5, 0.0, 1.21),  item_offset = vector3(-1.75, 0.3, 1.25), size = 'small' },
    { door_offset = vector3(-1.5, 0.0, 0.65),  item_offset = vector3(-1.75, 0.3, 0.69), size = 'large' },
    { door_offset = vector3(-1.5, 0.0, 0.1),   item_offset = vector3(-1.75, 0.3, 0.14), size = 'large' },

    { door_offset = vector3(-0.95, 0.0, 1.68), item_offset = vector3(-1.2, 0.3, 1.72),  size = 'medium' },
    { door_offset = vector3(-0.95, 0.0, 1.38), item_offset = vector3(-1.2, 0.3, 1.42),  size = 'medium' },
    { door_offset = vector3(-0.95, 0.0, 1.21), item_offset = vector3(-1.2, 0.3, 1.25),  size = 'small' },
    { door_offset = vector3(-0.95, 0.0, 0.65), item_offset = vector3(-1.2, 0.3, 0.69),  size = 'large' },
    { door_offset = vector3(-0.95, 0.0, 0.1),  item_offset = vector3(-1.2, 0.3, 0.14),  size = 'large' },

    { door_offset = vector3(-0.4, 0.0, 1.68),  item_offset = vector3(-0.65, 0.3, 1.72), size = 'medium' },
    { door_offset = vector3(-0.4, 0.0, 1.38),  item_offset = vector3(-0.65, 0.3, 1.42), size = 'medium' },
    { door_offset = vector3(-0.4, 0.0, 1.21),  item_offset = vector3(-0.65, 0.3, 1.25), size = 'small' },
    { door_offset = vector3(-0.4, 0.0, 0.65),  item_offset = vector3(-0.65, 0.3, 0.69), size = 'large' },
    { door_offset = vector3(-0.4, 0.0, 0.1),   item_offset = vector3(-0.65, 0.3, 0.14), size = 'large' },

    { door_offset = vector3(0.95, 0.0, 1.68),  item_offset = vector3(0.65, 0.3, 1.72),  size = 'medium' },
    { door_offset = vector3(0.95, 0.0, 1.38),  item_offset = vector3(0.65, 0.3, 1.42),  size = 'medium' },
    { door_offset = vector3(0.95, 0.0, 1.21),  item_offset = vector3(0.65, 0.3, 1.25),  size = 'small' },
    { door_offset = vector3(0.95, 0.0, 0.65),  item_offset = vector3(0.65, 0.3, 0.69),  size = 'large' },
    { door_offset = vector3(0.95, 0.0, 0.1),   item_offset = vector3(0.65, 0.3, 0.14),  size = 'large' },

    { door_offset = vector3(1.5, 0.0, 1.68),   item_offset = vector3(1.2, 0.3, 1.72),   size = 'medium' },
    { door_offset = vector3(1.5, 0.0, 1.38),   item_offset = vector3(1.2, 0.3, 1.42),   size = 'medium' },
    { door_offset = vector3(1.5, 0.0, 1.21),   item_offset = vector3(1.2, 0.3, 1.25),   size = 'small' },
    { door_offset = vector3(1.5, 0.0, 0.65),   item_offset = vector3(1.2, 0.3, 0.69),   size = 'large' },
    { door_offset = vector3(1.5, 0.0, 0.1),    item_offset = vector3(1.2, 0.3, 0.14),   size = 'large' },

    { door_offset = vector3(2.05, 0.0, 1.68),  item_offset = vector3(1.75, 0.3, 1.72),  size = 'medium' },
    { door_offset = vector3(2.05, 0.0, 1.38),  item_offset = vector3(1.75, 0.3, 1.42),  size = 'medium' },
    { door_offset = vector3(2.05, 0.0, 1.21),  item_offset = vector3(1.75, 0.3, 1.25),  size = 'small' },
    { door_offset = vector3(2.05, 0.0, 0.65),  item_offset = vector3(1.75, 0.3, 0.69),  size = 'large' },
    { door_offset = vector3(2.05, 0.0, 0.1),   item_offset = vector3(1.75, 0.3, 0.14),  size = 'large' },
}

function LockerCellLookup(cell_number)
    return cells[cell_number]
end
