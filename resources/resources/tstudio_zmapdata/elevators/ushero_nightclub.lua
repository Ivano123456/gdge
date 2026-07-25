return {
    resourceName = "tstudio_ushero_nightclub",
    
    locales = {
        ["en"] = {
            ["menu-title"] = "Ushero Night Club",
            ["menu-description"] = "Ushero Night Club",
            ["floor-description"] = "Teleport to %s",
            ["floor-label"] = "➤",
            ["elevator-help-notify"] = "~INPUT_CONTEXT~ Open Elevator"
        },
        ["de"] = {
            ["menu-title"] = "Ushero Night Club",
            ["menu-description"] = "Ushero Night Club",
            ["floor-description"] = "Auf %s teleportieren",
            ["floor-label"] = "➤",
            ["elevator-help-notify"] = "~INPUT_CONTEXT~ Aufzug öffnen"
        }
    },
    
    header = {
        topColor = {r = 255, g = 192, b = 203},  -- Pink
        bottomColor = {r = 128, g = 0, b = 128} -- Purple
    },
    
    marker = {
        type = 2,
        r = 235,
        g = 52,
        b = 210,
        alpha = 50
    },
    
    -- ========================================================================
    --  Ushero Night Club elevators
    -- ========================================================================
    --  Each street entrance is its own simple elevator (Lobby <-> Nightclub) and
    --  they all share the SAME interior point (-1023.4138, -3192.0181, -65.9482).
    --  At a lobby you only see that entrance's own floors. Inside the club the
    --  loader AUTO-MERGES all the overlapping interior markers into ONE marker
    --  whose menu lists every lobby you can leave by (see client/elevator_loader.lua
    --  and Config.ElevatorMergeDistance). So no manual "hub" is needed and there is
    --  no wrong-lobby teleport.
    --
    --  IMPORTANT: give each lobby a UNIQUE descriptive name (not just "Lobby") so
    --  the merged in-club menu is readable.
    --
    --  To DISABLE a location: delete its whole elevator block below (and remove that
    --  location's stream folder). It drops out of the merged in-club menu by itself.
    -- ========================================================================
    elevators = {
        {
            floors = { -- Burton entrance
                [1] = {
                    name = "Burton Lobby",
                    pos = vector4(-475.2523, -80.9544, 40.4027, 53.9934)
                },
                [2] = {
                    name = "Nightclub",
                    pos = vector4(-1023.4138, -3192.0181, -65.9482, 178.9715)
                }
            }
        },
        {
            floors = { -- Vinewood Hills entrance
                [1] = {
                    name = "Vinewood Hills Lobby",
                    pos = vector4(365.0890, 234.8327, 103.0057, 339.7982)
                },
                [2] = {
                    name = "Nightclub",
                    pos = vector4(-1023.4138, -3192.0181, -65.9482, 178.9715)
                }
            }
        },
        {
            floors = { -- Vanilla Unicorn entrance (also serves the Unicorn rooftop)
                [1] = {
                    name = "Vanilla Unicorn Lobby",
                    pos = vector4(119.2576, -1282.4839, 29.2486, 212.8084)
                },
                [2] = {
                    name = "Nightclub",
                    pos = vector4(-1023.4138, -3192.0181, -65.9482, 178.9715)
                },
                [3] = {
                    name = "Vanilla Unicorn Rooftop",
                    pos = vector4(101.8482, -1297.4547, 35.3082, 298.6503)
                }
            }
        },
        {
            floors = { -- Peak Tower entrance (Ushero side)
                [1] = {
                    name = "Ushero Nightclub Lobby",
                    pos = vector4(364.911, 234.748, 3.005, 340.04)
                },
                [2] = {
                    name = "Nightclub",
                    pos = vector4(-1023.4138, -3192.0181, -65.9482, 178.9715)
                }
            }
        },
        {
            floors = { -- Peak Tower connector: Peak Tower Lobby <-> Ushero Nightclub Lobby.
                       -- Does NOT touch the club interior, so it never merges.
                [1] = {
                    name = "Peak Tower Lobby",
                    pos = vector4(126.284, -1067.309, 30.582, 8.739)
                },
                [2] = {
                    name = "Ushero Nightclub Lobby",
                    pos = vector4(375.7585, 241.7496, 3.0057, 73.8090)
                }
            }
        }
    }
}
