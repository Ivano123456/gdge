-- Configuration file for TStudio Pearls Resort
Config = {}

-- Debug settings
Config.Debug = false  -- Set to false to disable debug messages

-- Wave override settings
Config.WaveOverride = {
    activationDistance = 600.0,     -- when wave override starts processing
    maxRadius = 500.0,              -- when wave override starts fading
    minOverride = 0.7,              -- fully calm water
    maxOverride = 0.0,              -- normal waves
    updateInterval = 1000           -- ms
}

-- DryZone polygon coordinates (clockwise)
Config.WaveZone = {
    vector2(-1815.38, -1298.79), vector2(-2019.95, -1334.69),
    vector2(-1912.31, -1220.57), vector2(-2055.39, -1336.02),
    vector2(-2112.21, -1376.8), vector2(-2115.56, -1456.36),
    vector2(-2086.14, -1513.86), vector2(-2005.91, -1544.61),
    vector2(-1930.36, -1533.25), vector2(-1890.92, -1474.41),
    vector2(-1902.95, -1428.28), vector2(-1880.89, -1396.19),
    vector2(-1830.08, -1434.3), vector2(-1779.27, -1378.14),
    vector2(-1832.76, -1338.03)
}

-- Debug box visualization coordinates
Config.DebugBox = {
    minX = -1955.10,
    maxX = -1868.86,
    minY = -1382.15,
    maxY = -1278.73,
    z = 0.0
}
