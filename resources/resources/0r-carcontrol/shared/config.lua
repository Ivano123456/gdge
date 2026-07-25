Config = {}

Config.VehClass = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains",
    [22] = "Open Wheel"
}

Config.SQL = 'oxmysql' -- ['ghmattimysql' 'oxmysql' 'mysql-async']

Config.Framework = 'esx' -- ['qb' 'oldqb' 'esx']

Config.Mileage = false

Config.WaitTime = 1000

Config.Command = 'carcontrol'

Config.KeyBind = "M"

Config.PlayMusicOnlyInVehicle = false

Config.DontPauseOnLeaveVeh = false -- if Config.PlayMusicOnlyInVehicle true this feature does not work!

Config.MusicDistance = 7.5

-- Disable ped moving seat from pass to driver unintentionally
Config.DisableSeatShuffle = true