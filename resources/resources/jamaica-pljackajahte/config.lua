Config = {}

Config.Locale = 'hr'
Config.YachtCenter = vector3(-2084.56, -1018.07, 11.78)

Config.SearchLocations = {
    vector3(-2074.76, -1024.26, 11.91),
    vector3(-2072.81, -1018.25, 11.91),
    vector3(-2057.70, -1024.97, 11.91),
    vector3(-2054.25, -1031.94, 11.91),
    vector3(-2051.53, -1024.39, 8.97),
    vector3(-2051.47, -1031.28, 8.97),
    vector3(-2077.15, -1020.25, 8.97),
    vector3(-2085.39, -1015.20, 8.97),
    vector3(-2087.29, -1020.66, 8.97),
    vector3(-2094.38, -1020.29, 8.97),
    vector3(-2096.56, -1014.37, 8.98),
}

Config.SpotCount = #Config.SearchLocations
Config.MinPoliceOnline = 7
Config.HeistCooldown = 3600
Config.PlayerCooldown = 2400
Config.RewardMin = 42220
Config.RewardMax = 48520
Config.UseBlackMoney = true
Config.MaxSearchDist = 5.0
Config.MaxStartDist = 12.0
Config.CancelDist = 100.0
Config.InteractDist = 2.5

Config.PoliceBoatMarker = vector3(-1849.55, -887.52, 1.40)
Config.PoliceBoatSpawn = vector4(-1867.97, -899.56, -1.5, 150.0)
Config.PoliceBoatHash = joaat('predator')

Config.PoliceHeliMarker = vector3(-1832.82, -891.97, 2.59)
Config.PoliceHeliSpawn = vector4(-1819.09, -895.48, 2.92, 150.0)
Config.PoliceHeliHash = joaat('polmav')

Config.PoliceJobs = { 'police' }
