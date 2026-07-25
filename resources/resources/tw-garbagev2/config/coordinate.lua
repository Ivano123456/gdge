Config.Coordinate = {
    [1] = {
        [1] = {
            vector4(-631.64, -1780.3, 22.98, 121.97),
            vector4(-559.82, -1803.08, 21.62, 334.13),
            vector4(-639.18, -1745.28, 23.21, 39.37),
            vector4(-581.82, -1788.42, 21.73, 153.81),
            vector4(-633.73, -1662.62, 24.97, 328.26),
            vector4(-429.8, -1721.26, 18.20, 329.13),
            vector4(-609.41, -1605.37, 25.75, 85.36),
            vector4(-529.69, -1783.04, 20.60, 347.68),
            vector4(-650.54, -1713.47, 23.70, 198.77),
            vector4(-339.53, -985.97, 29.32,175.23),
            vector4(689.11, -950.52, 22.42,218.45),
            vector4(1141.76, -1013.59, 44.06,186.11),
            vector4(1110.02, -792.2, 57.26,356.57),
            vector4(1264.57, -334.72, 68.08,173.5),
            vector4(76.01, 24.45, 68.19,165.56),
            vector4(554.01, -144.08, 57.54,84.63),
            vector4(173.62, 387.1, 108.35,266.8),
            vector4(-888.05, 412.29, 85.09,101.55),
            vector4(-73.46, 909.48, 234.63,208.32),
            vector4(-1077.86, -1715.92, 3.37,35.22),
            vector4(-1286.29, -1156.12, 4.47,269.53),
            vector4(-1416.73, -951.45, 6.18,140.46),
            vector4(-1603.08, -846.96, 9.07,314.02),
            vector4(-2062.8, -442.65, 10.61,222.74),
            vector4(-1320.02, -148.86, 45.78,103.69),
            vector4(-952.8, 303.45, 69.73,292.75),
            vector4(-1381.23, 107.59, 53.94,91.07),
            vector4(-1676.88, 483.79, 127.88, 23.29),
            vector4(-1668.5, -250.83, 53.79,337.26),
            vector4(-1372.67, -642.66, 27.67,123.11)
        },
        [3] = {
            { areaDistance = 10.0, coords = vector3(-492.48, -1828.26, 23.5) },
        }
    },
    [2] = {
        [1] = {
            vector4(-14.68, -1504.17, 29.15, 229.10),
            vector4(175.41, -1521.42, 28.14, 58.98),
            vector4(110.98, -1571.88, 28.6, 311.7),
            vector4(226.43, -1512.01, 28.29, 224.73),
            vector4(264.93, -1697.98, 28.2, 52.26),
            vector4(159.64, -1650.66, 28.29, 34.44),
            vector4(49.13, -1704.84, 28.31, 134.99),
            vector4(164.79, -1658.49, 28.59, 123.31),
            vector4(140.04, -1501.71, 28.14, 224.35),
            vector4(291.11, -1284.89, 28.58, 180.73),
            vector4(25.5, -1594.31, 28.29, 327.87),
            vector4(136.78, -1596.38, 28.37, 224.58),
            vector4(246.89, -1774.62, 27.68, 142.36),
            vector4(174.54, -1815.2, 27.79, 317.19)
        },
        [3] = {
            { areaDistance = 10.0, coords = vector3(-207.51, -1512.6, 31.63) },
        }
    },
    [3] = {
        [1] = { -- 20
            vector4(79.59, 88.7, 78.66, 73.06),
            vector4(97.13, 65.88, 72.42, 75.14),
            vector4(90.12, 300.72, 108.99, 334.48),
            vector4(133.3, 271.78, 108.97, 341.11),
            vector4(116.61, 312.2, 111.13, 345.25),
            vector4(226.24, 389.9, 105.75, 161.08),
            vector4(351.33, 360.44, 103.99, 177.45),
            vector4(394.38, 290.98, 101.97, 157.15),
            vector4(133.65, 167.87, 103.96, 241.66),
            vector4(274.5, 311.83, 104.54, 342.48),
            vector4(205.13, 340.02, 104.62, 347.13),
            vector4(92.57, 155.13, 103.77, 64.63),  
            vector4(-68.03, 209.05, 95.53, 97.98),
            vector4(-60.3, 219.67, 105.55, 256.86),
            vector4(-113.59, 25.3, 70.31, 345.11),
            vector4(-291.04, 110.2, 67.22, 0.38),
            vector4(-346.19, 110.05, 65.71, 5.82),
            vector4(-476.10, 64.55, 57.66, 265.23),
            vector4(-426.40, -43.46, 45.23, 355.49),
            vector4(-309.64, -88.11, 53.42, 342.92),
        },
        [3] = {
            { areaDistance = 12.0, coords = vector3(-600.73, -31.16, 43.14) },
        }
    },
}


function CalculateBagCoordinates(garbageCoords, offsetDistance)
    local x, y, z, heading = garbageCoords.x, garbageCoords.y, garbageCoords.z, garbageCoords.w
    local offsetDistance = offsetDistance or 2.0

    local headingRad = math.rad(heading)

    local frontX = x + math.cos(headingRad) * offsetDistance
    local frontY = y + math.sin(headingRad) * offsetDistance

    local backHeadingRad = math.rad(heading + 180)
    local backX = x + math.cos(backHeadingRad) * offsetDistance
    local backY = y + math.sin(backHeadingRad) * offsetDistance

    local bagZ = z + 0.2

    return {
        vector3(frontX, frontY, bagZ),
        vector3(backX, backY, bagZ)
    }
end

Config.Props = {
    dumpsterObject = "prop_dumpster_01a",
    bagObject = "hei_prop_heist_binbag",
    recycleBaleObject = "prop_recycled_bale",
    trashObject = {
        "ng_proc_litter_plasbot1",
        "ng_proc_litter_plasbot2",
        "ng_proc_sodacan_01a",
        "ng_proc_sodacan_02a",
        "ng_proc_sodabot_01a"
    }
}

Config.MachineCoords = {
    emptyVehicleCoords = vector4(-346.96, -1529.05, 27.57, 356.14),
    startCoords = vector3(-350.21, -1540.6, 27.13),
    waypoints = {
        vector3(-350.11, -1540.53, 27.19 + 0.7),
        vector3(-348.42, -1540.56, 28.16 + 0.7),
        vector3(-347.54, -1540.57, 28.67 + 0.7),
        vector3(-346.1, -1540.58, 29.5 + 0.7),
        vector3(-344.48, -1540.64, 30.44 + 0.7),
        vector3(-343.26, -1540.66, 30.15 + 0.7)
    },
    baleStartCoords = vector3(-342.59, -1538.81, 27.20),
    baleEndCoords = vector3(-342.61, -1532.48, 27.20),
    baleDeliveryCoords = vector3(-357.89, -1537.28, 28.55)
}
