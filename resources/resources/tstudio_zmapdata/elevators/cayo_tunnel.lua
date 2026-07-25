return {
    resourceName = "tstudio_cayo_tunnel",
    
    locales = {
        ["en"] = {
            ["menu-title"] = "Cayo Tunnel",
            ["menu-description"] = "Cayo Tunnel Elevator",
            ["floor-description"] = "Teleport to %s",
            ["floor-label"] = "➤",
            ["elevator-help-notify"] = "~INPUT_CONTEXT~ Open Elevator",
            -- Car elevator locale
            ["car-menu-title"] = "Car Elevator",
            ["car-menu-description"] = "Cayo Tunnel Vehicle Transport",
            ["car-floor-description"] = "Drive to %s",
            ["car-help-notify"] = "~INPUT_CONTEXT~ Use Car Elevator",
            ["car-help-return"] = "~INPUT_CONTEXT~ Return",
            ["car-no-vehicle"] = "You need a vehicle to use this elevator"
        },
        ["de"] = {
            ["menu-title"] = "Cayo Tunnel",
            ["menu-description"] = "Cayo Tunnel Aufzug",
            ["floor-description"] = "Auf %s teleportieren",
            ["floor-label"] = "➤",
            ["elevator-help-notify"] = "~INPUT_CONTEXT~ Aufzug öffnen",
            -- Car elevator locale
            ["car-menu-title"] = "Autoaufzug",
            ["car-menu-description"] = "Cayo Tunnel Fahrzeugtransport",
            ["car-floor-description"] = "Fahren nach %s",
            ["car-help-notify"] = "~INPUT_CONTEXT~ Autoaufzug benutzen",
            ["car-help-return"] = "~INPUT_CONTEXT~ Zurück",
            ["car-no-vehicle"] = "Du brauchst ein Fahrzeug für diesen Aufzug"
        }
    },
    
    marker = {
        type = 2,
        r = 128,
        g = 64,
        b = 0,
        alpha = 50
    },
    
    -- Header gradient colors (top to bottom)
    header = {
        topColor = {r = 128, g = 64, b = 0},      -- Orange top
        bottomColor = {r = 64, g = 32, b = 0}     -- Darker orange bottom
    },
    
    -- Garage - Lobby - 2. Floor - (Apartments) - Rooftop
    elevators = {},

    -- Car marker: flat cylinder, larger for vehicles
    carMarker = {
        type = 1,
        r = 128,
        g = 64,
        b = 0,
        alpha = 100,
        scaleX = 5.0,
        scaleY = 5.0,
        scaleZ = 0.5
    },

    -- Car Elevators: multiple sources lead to a single destination
    -- Destination returns randomly to one of the sources
    carElevators = {
        {
            destination = {
                name = "Crime Entry Point A",
                pos = vector4(1471.865, -2785.974, -52.883, 229.521) -- TODO: Replace with actual coordinates
            },
            sources = {
                [1] = {
                    name = "Crime Tunnel Point A",
                    pos = vector4(680.936, -2680.148, 6.487, 92.946) -- TODO: Replace with actual coordinates
                },
            }
        },
        {
            destination = {
                name = "Crime Entry Point B",
                pos = vector4(3783.599, -4680.369, -52.85, 59.025) -- TODO: Replace with actual coordinates
            },
            sources = {
                [1] = {
                    name = "Crime Tunnel Point B",
                    pos = vector4(4482.846, -4450.955, 4.62, 194.972) -- TODO: Replace with actual coordinates
                },
            }
        }
    }
}
