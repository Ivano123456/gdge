-- =========================================================================
-- Cayo Tunnel — IPL & Entity Set Configuration
-- =========================================================================
-- Pattern follows tstudio_zmapdata entitysets config format.
--
-- m100 modules have 5 entity sets:
--   Pillars (always 1 of 2 active):
--     "m100_pillar_basic"       — Basic column setup
--     "m100_pillar_wallsign"    — LS/Cayo signage on columns
--   Insets (always 1 of 3 active):
--     "m100_ins01_basic"        — Basic fake inset
--     "m100_ins01_exitladder"   — Inset with exit ladder
--     "m100_ins01_exitdoor"     — Inset with exit door
--
-- mcexit modules have crime props (all false by default, enable as needed):
--     "mcexit_set_drugs"        — Drug lab props
--     "mcexit_set_weapons"      — Weapons cache props
--     "mcexit_set_smug"         — Smuggling props
-- =========================================================================

Config = Config or {}

-- =========================================================================
-- Water Settings
-- =========================================================================
Config.switchPoint    = vector3(2872.3259, -3934.4487, -44.9439)
Config.switchLength   = 50.0
Config.loweredWaterZ  = -57.0   -- Z level to push water to when inside tunnel
Config.debugHud       = false   -- Set to true to enable the debug HUD

-- =========================================================================
-- Rider Protection (water switch)
-- The water type switch happens mid-tunnel, right where a bike is at speed.
-- Reloading the water file snaps every quad back to its default (sea-level)
-- Z for a few frames before the quads are re-lowered, briefly flooding the
-- tunnel ~47m deep. A bike stalls in that water and the rider is dismounted.
-- This brackets each switch with knock-off / ragdoll locks so the rider
-- stays seated, and re-seats them at the same speed if the engine dismounts
-- them anyway — so they just keep driving across the switch.
-- =========================================================================
Config.RiderProtection = {
    enabled    = true,
    durationMs = 1000,   -- how long to hold protection around each water switch (ms)
}

-- =========================================================================
-- Crime Exit Wave Calming
-- Reduces wave strength while the player is inside a Crime Exit interior.
-- Uses the global water override: 0.0 = normal waves, 1.0 = fully calm.
-- Applies to all Config.CrimeExits regardless of which water file is active.
-- =========================================================================
Config.CrimeExitWaves = {
    enabled        = true,
    calmStrength   = 0.9,    -- override strength while inside a crime exit (near-flat water)
    normalStrength = 0.0,    -- override strength when outside (normal waves)
    lerpStep       = 0.05,   -- ramp amount per update (smooth in/out transition)
    updateInterval = 150,    -- ms between updates while ramping
}

-- =========================================================================
-- Water Neighbor Lowering
-- After lowering the quads directly under the tunnel path, also lower
-- adjacent ("neighboring") quads so off-centerline water — e.g. the
-- scattered Cayo dock/ramp quads — gets covered too. Oversized quads
-- (open ocean) are skipped so we never punch a hole in the sea.
-- =========================================================================
Config.WaterNeighbors = {
    enabled     = true,
    hops        = 3,       -- how many quads outward to expand (+2 neighbors)
    maxQuadSize = 450.0,   -- skip neighbor quads larger than this (ocean guard)
    probeStep   = 20.0,    -- edge sampling resolution when finding neighbors
}
-- =========================================================================
-- Standard 100m Modules (m100)
-- Pillars: always enable 1 of 2 — toggle true/false
-- Insets:  always enable 1 of 3 — toggle true/false
-- =========================================================================
Config.M100 = {
    {
        name = "M100 Module 01",
        coords = vector3(1574.7312, -2910.397, -47),
        ipl = "tstudio_qx_cayotun_m100_01_milo_",
    },
    {
        name = "M100 Module 02",
        coords = vector3(1662.5155, -2978.98169, -47),
        ipl = "tstudio_qx_cayotun_m100_02_milo_",
    },
    {
        name = "M100 Module 03",
        coords = vector3(1821.2207, -3102.97583, -47),
        ipl = "tstudio_qx_cayotun_m100_03_milo_",
    },
    {
        name = "M100 Module 04",
        coords = vector3(1900.57336, -3164.973, -47),
        ipl = "tstudio_qx_cayotun_m100_04_milo_",
    },
    {
        name = "M100 Module 05",
        coords = vector3(1979.926, -3226.97, -47),
        ipl = "tstudio_qx_cayotun_m100_05_milo_",
    },
    {
        name = "M100 Module 06",
        coords = vector3(2059.27881, -3288.96729, -47),
        ipl = "tstudio_qx_cayotun_m100_06_milo_",
    },
    {
        name = "M100 Module 07",
        coords = vector3(2147.06323, -3357.55176, -47),
        ipl = "tstudio_qx_cayotun_m100_07_milo_",
    },
    {
        name = "M100 Module 08",
        coords = vector3(2305.7688, -3481.54639, -47),
        ipl = "tstudio_qx_cayotun_m100_08_milo_",
    },
    {
        name = "M100 Module 09",
        coords = vector3(2385.12183, -3543.54346, -47),
        ipl = "tstudio_qx_cayotun_m100_09_milo_",
    },
    {
        name = "M100 Module 10",
        coords = vector3(2464.47437, -3605.541, -47),
        ipl = "tstudio_qx_cayotun_m100_10_milo_",
    },
    {
        name = "M100 Module 11",
        coords = vector3(2543.82739, -3667.53784, -47),
        ipl = "tstudio_qx_cayotun_m100_11_milo_",
    },
    {
        name = "M100 Module 12",
        coords = vector3(2631.61157, -3736.1228, -47),
        ipl = "tstudio_qx_cayotun_m100_12_milo_",
    },
    {
        name = "M100 Module 13",
        coords = vector3(2710.96436, -3798.11963, -47),
        ipl = "tstudio_qx_cayotun_m100_13_milo_",
    },
    {
        name = "M100 Module 14",
        coords = vector3(2790.317, -3860.117, -47),
        ipl = "tstudio_qx_cayotun_m100_14_milo_",
    },
    {
        name = "M100 Module 15",
        coords = vector3(2869.66968, -3922.11377, -47),
        ipl = "tstudio_qx_cayotun_m100_15_milo_",
    },
    {
        name = "M100 Module 16",
        coords = vector3(3028.375, -4046.108, -47),
        ipl = "tstudio_qx_cayotun_m100_16_milo_",
    },
    {
        name = "M100 Module 17",
        coords = vector3(3116.15918, -4114.693, -47),
        ipl = "tstudio_qx_cayotun_m100_17_milo_",
    },
    {
        name = "M100 Module 18",
        coords = vector3(3195.51172, -4176.69, -47),
        ipl = "tstudio_qx_cayotun_m100_18_milo_",
    },
    {
        name = "M100 Module 19",
        coords = vector3(3274.8645, -4238.687, -47),
        ipl = "tstudio_qx_cayotun_m100_19_milo_",
    },
    {
        name = "M100 Module 20",
        coords = vector3(3354.21729, -4300.684, -47),
        ipl = "tstudio_qx_cayotun_m100_20_milo_",
    },
    {
        name = "M100 Module 21",
        coords = vector3(3512.92285, -4424.678, -47),
        ipl = "tstudio_qx_cayotun_m100_21_milo_",
    },
    {
        name = "M100 Module 22",
        coords = vector3(3600.70752, -4493.263, -47),
        ipl = "tstudio_qx_cayotun_m100_22_milo_",
    },
    {
        name = "M100 Module 23",
        coords = vector3(1495.37854, -2848.4, -47),
        ipl = "tstudio_qx_cayotun_m100_23_milo_",
    },
    {
        name = "M100 Module 24",
        coords = vector3(3680.0603, -4555.26025, -47),
        ipl = "tstudio_qx_cayotun_m100_24_milo_",
    },
    {
        name = "M100 Module 25",
        coords = vector3(3759.41284, -4617.25732, -47),
        ipl = "tstudio_qx_cayotun_m100_25_milo_",
    },
}

-- =========================================================================
-- 100M Module going up on the Los Santos Side
-- =========================================================================
Config.M100up = {
    {
        name = "M100 Module Up 01",
        coords = vector3(873.3134, -2792.10645, 3.466879),
        ipl = "tstudio_qx_cayotun_m100up_01_milo_",
    },
    {
        name = "M100 Module Up 02",
        coords = vector3(972.810242, -2792.10645, -6.55192757),
        ipl = "tstudio_qx_cayotun_m100up_02_milo_",
    },
    {
        name = "M100 Module Up 03",
        coords = vector3(1072.30713, -2792.10645, -16.5707321),
        ipl = "tstudio_qx_cayotun_m100up_03_milo_",
    },
    {
        name = "M100 Module Up 04",
        coords = vector3(1171.804, -2792.10645, -26.58954),
        ipl = "tstudio_qx_cayotun_m100up_04_milo_",
    },
}

-- =========================================================================
-- Connection Module between Curve and UP on the Los Santos Side
-- =========================================================================
Config.Mconnect = {
        name = "Module Connector 01",
        coords = vector3(1301.72461, -2792.10645, -37.4393463),
        ipl = "tstudio_qx_cayotun_m100up_con_01_milo_",
}

-- =========================================================================
-- Crime Exit Modules (mcexit)
-- Crime setups — only active when desired, all false by default
-- =========================================================================
Config.CrimeExits = {
    {
        name = "Crime Exit 01",
        coords = vector3(1618.62329, -2944.68921, -47),
        ipl = "tstudio_qx_cayotun_mcexit_01_milo_",
    },
    {
        name = "Crime Exit 02",
        coords = vector3(2103.17114, -3323.25928, -47),
        ipl = "tstudio_qx_cayotun_mcexit_02_milo_",
    },
    {
        name = "Crime Exit 03",
        coords = vector3(2587.71973, -3701.83, -47),
        ipl = "tstudio_qx_cayotun_mcexit_03_milo_",
    },
    {
        name = "Crime Exit 04",
        coords = vector3(3072.267, -4080.40039, -47),
        ipl = "tstudio_qx_cayotun_mcexit_04_milo_",
    },
    {
        name = "Crime Exit 05",
        coords = vector3(3556.81519, -4458.9707, -47),
        ipl = "tstudio_qx_cayotun_mcexit_05_milo_",
    },
}

-- =========================================================================
-- Open Modules (m100open) — no entity sets
-- =========================================================================
Config.OpenModules = {
    {
        name = "Open Module 01",
        coords = vector3(1741.86816, -3040.97876, -47),
        ipl = "tstudio_qx_cayotun_m100open_01_milo_",
    },
    {
        name = "Open Module 02",
        coords = vector3(2226.41626, -3419.54932, -47),
        ipl = "tstudio_qx_cayotun_m100open_02_milo_",
    },
    {
        name = "Open Module 03",
        coords = vector3(2949.02222, -3984.111, -47),
        ipl = "tstudio_qx_cayotun_m100open_03_milo_",
    },
    {
        name = "Open Module 04",
        coords = vector3(3433.57031, -4362.681, -47),
        ipl = "tstudio_qx_cayotun_m100open_04_milo_",
    },
}

-- =========================================================================
-- Curve on the Los Santos Side
-- =========================================================================
Config.LScurve = {
        name = "Curve Module 01",
        coords = vector3(1424.91919, -2802.70557, -43.34105),
        ipl = "tstudio_qx_cayotun_mcurve_95g_01_milo_",
}

-- =========================================================================
-- Start and End Modules, connection the Tunnel with the rest of the Map
-- =========================================================================
Config.LSexit = {
        name = "Los Santos Exit",
        coords = vector3(821.141663, -2792.106, 8.416906),
        ipl = "tstudio_qx_cayotun_lsexit_milo_",
}

-- =========================================================================
-- Checkpoint Container
-- =========================================================================
Config.Checkpoint = {
    {
        name = "Checkpoint Container LS",
        coords = vector3(795.8579, -2792.10669, 5.35580826),
        ipl = "tstudio_qx_cayotun_checkpoint_container01_milo_",
    },
    {
        name = "Checkpoint Container CAYO",
        coords = vector3(4412.40771, -4656.51025, 6.48764753),
        ipl = "tstudio_qx_cayotun_checkpoint_container02_milo_",
    },
}

-- =========================================================================
-- Cayo Perico Side — mirror modules
-- =========================================================================

-- 100M Modules going up on the Cayo Side (mirror of M100up)
Config.M100up2 = {
    {
        name = "M100 Module Up2 01",
        coords = vector3(4176.5815, -4742.3574, -16.3697),
        ipl = "tstudio_qx_cayotun_m100up2_01_milo_",
    },
    {
        name = "M100 Module Up2 02",
        coords = vector3(4260.5903, -4711.7803, -5.9885),
        ipl = "tstudio_qx_cayotun_m100up2_02_milo_",
    },
    {
        name = "M100 Module Up2 03",
        coords = vector3(4344.5996, -4681.2041, 4.3928),
        ipl = "tstudio_qx_cayotun_m100up2_03_milo_",
    },
}

-- Connection Module between Curve and UP on the Cayo Side (mirror of Mconnect)
Config.Mconnect2 = {
        name = "Module Connector 02",
        coords = vector3(4108.4634, -4767.1948, -23.1306),
        ipl = "tstudio_qx_cayotun_m100up_con2_01_milo_",
}

-- Curve on the Cayo Side (mirror of LScurve)
Config.Cayocurve = {
        name = "Curve Module 02", 
        coords = vector3(4012.4883, -4779.9048, -24.6580),
        ipl = "tstudio_qx_cayotun_mcurve_58g_01_milo_",
}

-- Cayo Perico Exit (mirror of LSexit)
Config.Cayoexit = {
        name = "Cayo Perico Exit",
        coords = vector3(4388.8906, -4665.0869, 9.5496),
        ipl = "tstudio_qx_cayotun_cayoexit_milo_",
}

-- Ramp Module
Config.Ramp = {
        name = "Ramp Module 01",
        coords = vector3(3873.8057, -4706.6309, -33.9603),
        ipl = "tstudio_qx_cayotun_m100_ramp_milo_",
}

-- Elevators
Config.Elevators = {
    {
        name = "Elevator CAYO",
        coords = vector3(3800.2097, -4649.1318, -47.0),
        ipl = "tstudio_qx_cayotun_mcelevator_01_milo_",
    },
    {
        name = "Elevator LS",
        coords = vector3(1454.5819, -2816.5264, -47.0),
        ipl = "tstudio_qx_cayotun_mcelevator_02_milo_",
    },
}

-- Garages
Config.Garages = {
    {
        name = "Garage LS",
        coords = vector3(678.6362, -2680.5759, 9.4900),
        ipl = "tstudio_qx_cayotun_cgarage_01_milo_",
    },
    {
        name = "Garage CAYO",
        coords = vector3(4484.0942, -4452.6396, 7.6228),
        ipl = "tstudio_qx_cayotun_cgarage_02_milo_",
    },
}


