Config, Locales = {}, {}

Config.Locale = 'sr' -- en / pt / es / fr / de / nl / sr

Config.DevMode = false -- true = Can restart the script in game that everything works | false = You can't restart the script in game otherwise it stops working

Config.Debug = false

Config.UseOkokNotify = false -- true = okokNotify | false = esxNotify ( You can change the notification system on cl_utils.lua )

Config.UseOkokTextUI = true -- true = okokTextUI | false = esxTextUI

Config.UseOkokRequests = true -- true = okokRequests | false = Hire right away

Config.UseOkokBanking = false -- true = The transactions will be registered on okokBanking

Config.Currency = '$' -- The currency used on the script

Config.CurrencyonLeft = false -- true = The currency symbol will be in the left side | false = On the right side on UI

Config.Key = 38 -- [E] Key to open the interaction, check here the keys ID: https://docs.fivem.net/docs/game-references/controls/#controls

Config.EventPrefix = "okokGasStation" -- This will change the prefix of the events name so if Config.EventPrefix = "example" the events will be "example:event"

Config.MaxGasStationsPerPlayer = 1 -- How many gas stations a player can own

Config.MaxEmployeesPerGasStation = 10 -- How many employees a gas station can have

Config.UseRopeToRefuel = true -- true = You will need to use a rope to refuel the vehicles | false = You can refuel the vehicles without a rope

Config.HireDistance = 3 -- How close a player needs to be to be in the hiring range

Config.MaxGasPrice = 20 -- The max price a player can set the gas price to

Config.ShowOwnerBlip = true -- Activate/Deactivate owner blips

Config.ShowBuyGasStationBlip = false -- Activate/Deactivate buy store blip

Config.ShowGasStationBlip = false -- Activate/Deactivate the normal blips if you set Config.ShowBuyGasStationBlip = false

Config.SellBusinessReceivePercentage = 50 -- How much % a player will receive for selling his business (in percentage, 50 = 50%)

Config.DefaultGasPrice = 2.00 -- Default price for gas after purchasing a store

Config.DefaultMaxStock = 2000 -- The Default max stock available after purchasing the store

Config.TotalMaxStock = 20000 -- The Max Stock available on total to upgrade the store

Config.RewardPercentageOnOrder = 20 -- The percentage that the employee will get when doing an order depending on the capacity price ( price is 750, reward will be 75 on 10%)

Config.SalesDateFormat = "%d/%m - %H:%M" -- The Date that will be shown on Sales History

Config.TruckBlip = { blipId = 67, blipColor = 2, blipScale = 0.8, blipText = "Kamion misije" } -- Blip of the truck when someone accepts an order

Config.OrderBlip = { blipId = 8, blipColor = 2, blipScale = 0.8, blipText = "Narudžba goriva", blipFinish = "Završi narudžbu" }  -- Blip of the gas location when someone accepts an order

Config.Marker = { id = 21, size = { x = 0.5, y = 0.5, z = 0.5 }, color = { r = 31, g = 94, b = 255, a = 90 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 } -- The marker to tow a vehicle when someone accepts an order

Config.TrailerName = 'Tanker' -- Name of the trailer for the long vehicles mission

Config.SubOwnerRank = 4 -- ID of the rank that will work as a secondary owner ( check the Config.Ranks )

Config.PrioritizeCash = true -- If true, it will prioritize cash over bank money when you refuel

Config.SalesHistoryLimit = 25 -- Records for each shop that will be saved on the sale history table

Config.EnableJerrycan = true --  You can use the jerrycan to refuel vehicles | false = You can't use the jerrycan to refuel vehicles

Config.TurnOffEngineWhenNoFuel = true -- The engine will turn off when the vehicle has no fuel

Config.TurnOnEngineWhenFuel = false -- The engine will turn on when the vehicle has fuel

Config.DaysToRemoveGasStation = 15 -- How many days will take after a gas station has no stock to remove the owner

Config.RefuelTime = 1000 -- Time in ms per liter to refuel a vehicle

Config.UseMetadataItem = false -- true = You will need the item to refuel the vehicle | false = You can refuel the vehicle without the item

Config.MetadataInventory = 'ox_inventory' -- The inventory script you are using ( qs-inventory / ox_inventory / origen_inventory )

Config.FreezePedWhileFueling = false -- true = The player will be frozen while refueling | false = The player will be able to move while refueling

Config.DistanceBetweenPumpAndVehicle = 5 -- The distance between the vehicle and the pump to refuel

Config.JerrycanUsageOnVehicleRefuel = 5 -- How much fuel the jerrycan will use when refueling a vehicle

Config.MaxFuelOnPetrolcan = 100 -- The max fuel the jerrycan can hold if Config.UseMetadataItem = true

Config.Ranks = {  -- These are the ranks available on the gas station stores, you can add or remove as many as you want but leave at least 1
	{ rank = 1, label = "Početnik" },
	{ rank = 2, label = "Iskusan" },
	{ rank = 3, label = "Ekspert" },
	{ rank = 4, label = "Zamenik vlasnika" },
 }

Config.Capacities = {  -- The list of capacities available to update the max stock
	{ capacity = 500,   price = 750 },
	{ capacity = 1000,  price = 1200 },
	{ capacity = 2000,  price = 2000 },
	{ capacity = 5000,  price = 3500 },
	{ capacity = 10000, price = 5000 },
 }

Config.RopePositions = {  -- Change the coords if the rope is not in the right position
	{ vehicle = 'hotknife', x = -0.65,  y = -1.50, z = -0.30 }, -- X = forward and backward | Y = left and right | Z = up and down
	{ vehicle = 'forklift', x = -0.45,  y = -1.00, z = -0.25 },
	{ vehicle = 'bus', 	    x = -1.25,  y = 0.00,  z = -1.10 },
	{ vehicle = 'firetruk', x = -0.90,  y = 0.00,  z = -0.55 },
 }

Config.Stores = { 
    { 
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = 2680.2, y = 3264.06, z = 55.24 }, -- Marker/Shop position
		ownerCoords = { x = 2674.07, y = 3266.96, z = 55.24 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = 2690.84, y = 3271.46, z = 55.31, h = 151.13 }, -- Where the vehicles are spawned for the missions
		refuelLocations = {  -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = 2681.59, y = 3266.09, z = 55.41 },
			{ x = 2679.09, y = 3261.97, z = 55.41 },
		 },
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 },
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation1", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
	{ 
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = 1687.28, y = 4929.37, z = 42.08 }, -- Marker/Shop position
		ownerCoords = { x = 1702.48, y = 4916.58, z = 42.08 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = 1713.06, y = 4940.35, z = 42.18, h = 55.39 }, -- Where the vehicles are spawned for the missions
		refuelLocations = { -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = 1684.00, y = 4932.12, z = 42.23 },
			{ x = 1689.53, y = 4928.31, z = 42.23 },
		 },
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 },
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation2", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
	{ 
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = -1800.2, y = 803.85, z = 138.65 }, -- Marker/Shop position
		ownerCoords = { x = -1818.59, y = 796.98, z = 138.14 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = -1813.31, y = 788.29, z = 137.83, h = 222.49 }, -- Where the vehicles are spawned for the missions
		refuelLocations = { -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = -1790.39, y = 806.88, z = 138.69 },
			{ x = -1795.5, y = 812.38, z = 138.69 },
			{ x = -1801.85, y = 806.47, z = 138.65 },
			{ x = -1796.76, y = 800.92, z = 138.65 },
			{ x = -1803.19, y = 794.79, z = 138.69 },
			{ x = -1808.28, y = 800.34, z = 138.68 },
		 },
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 },
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation3", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
	{ 
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = -724.04, y = -934.02, z = 19.21 }, -- Marker/Shop position
		ownerCoords = { x = -702.82, y = -917.17, z = 19.21 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = -727.35, y = -912.4, z = 19.08, h = 179.75 }, -- Where the vehicles are spawned for the missions
		refuelLocations = { -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = -714.86, y = -939.36, z = 19.2 },
			{ x = -714.85, y = -932.52, z = 19.21 },
			{ x = -723.42, y = -932.51, z = 19.21 },
			{ x = -723.51, y = -939.4, z = 19.2 },
			{ x = -732.06, y = -939.42, z = 19.2 },
			{ x = -732.06, y = -932.51, z = 19.21 },
		 },
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 },
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation4", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
	{ 
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = -70.79, y = -1762.41, z = 29.53 }, -- Marker/Shop position
		ownerCoords = { x = -57.85, y = -1754.48, z = 29.2 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = -39.27, y = -1742.14, z = 29.31, h = 51.75 }, -- Where the vehicles are spawned for the missions
		refuelLocations = { -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = -80.71, y = -1761.92, z = 29.8 },
			{ x = -78.14, y = -1754.86, z = 29.8 },
			{ x = -70.0, y = -1757.81, z = 29.53 },
			{ x = -72.59, y = -1764.91, z = 29.53 },
			{ x = -61.56, y = -1760.6, z = 29.26 },
			{ x = -64.13, y = -1767.65, z = 29.26 },
		 },		
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 },
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation5", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
	{ 
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = 1181.56, y = -330.21, z = 69.32 }, -- Marker/Shop position
		ownerCoords = { x = 1167.89, y = -321.23, z = 69.3 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = 1166.88, y = -331.53, z = 68.98, h = 188.59 }, -- Where the vehicles are spawned for the missions
		refuelLocations = { -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = 1183.23, y = -320.38, z = 69.34 },
			{ x = 1175.57, y = -321.74, z = 69.35 },
			{ x = 1177.43, y = -330.42, z = 69.32 },
			{ x = 1184.78, y = -329.13, z = 69.32 },
			{ x = 1186.34, y = -337.66, z = 69.36 },
			{ x = 1178.88, y = -338.96, z = 69.36 },
		 },
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 },
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation6", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
	{
		name = "Benzinska pumpa", -- Name of the gas station
		currency = "bank", -- Used to buy/sell the business
		hasOwner = true, -- If true, the gas station will have an owner
		coords = { x = 2581.32, y = 361.8, z = 108.47 }, -- Marker/Shop position
		ownerCoords = { x = 2559.4, y = 373.76, z = 108.62 }, -- Marker/Shop position for owner/employees
		spawnMissionVehicle = { x = 2589.75, y = 409.23, z = 108.52, h =  2.98 }, -- Where the vehicles are spawned for the missions
		refuelLocations = { -- Locations where players can refuel their vehicle ( should be close to a pump )
			{ x = 2574.13, y = 359.14, z = 108.65 },
			{ x = 2574.43, y = 364.67, z = 108.65 },
			{ x = 2580.59, y = 364.56, z = 108.65 },
			{ x = 2580.35, y = 358.91, z = 108.65 },
			{ x = 2587.83, y = 358.73, z = 108.65 },
			{ x = 2588.07, y = 364.12, z = 108.65 }
		 },
		smallVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for small vehicles
			{ x = 1524.23, y = -2113.95, z = 76.6, h = 93.54 }, 
			{ x = 865.68, y = -3206.11, z = 5.9, h = 2.46 },
			{ x = -356.36, y = 6068.12, z = 31.5, h = 228.11 },
		 },
		longVehiclesGetFuel = {  -- Locations where someone who accepted an order will have to go (it is random) and it is for trucks with trailers
			{ x = 168.38, y = 6432.32, z = 31.28, h = 75.94 },
			{ x = 1712.04, y = -1573.69, z = 112.6, h = 271.11 },
			{ x = 1271.91, y = -3191.07, z = 5.9, h = 93.71 },
		 },
		vehicles = {  -- Inserted on the database after the gas station purchase, then you can't change this info
			{ label ='Rumpo', vehicleid = 'rumpo', price = 32000, capacity = 500, orderPrice = 1200, owned = false, longTruck = false },
			{ label ='Mule', vehicleid = 'mule', price = 54000, capacity = 1500, orderPrice = 2500, owned = false, longTruck = false },
			{ label ='Phantom', vehicleid = 'phantom', price = 180000, capacity = 10000, orderPrice = 7000, owned = false, longTruck = true },
		 },
		radius = 1, -- Interaction radius for the markers
		pumpRadius = 15, -- Interaction radius for the pumps
		price = 50000000, -- Price of the Gas Station
		startStock = 500, -- The stock of fuel the business starts with
		blip = { blipId = 415, blipColor = 3, blipScale = 0.8, blipText = "Benzinska pumpa" }, -- Blip informations for gas station blip
		ownerBlip = { blipId = 415, blipColor = 2, blipScale = 0.8, blipText = "Panel pumpe" }, -- Blip informations for shops your own/work gas station
		buyBlip = { blipId = 415, blipColor = 1, blipScale = 0.8, blipText = "Pumpa na prodaju" }, -- Blip informations for shop on sale
		marker = { id = 20, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the gas station
		ownerMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		refuelMarker = { id = 21, color = { r = 31, g = 94, b = 255, a = 90 }, size = { x = 0.5, y = 0.5, z = 0.5 }, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0 }, -- Marker informations for the owning menu
		id = "gasstation7", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	 },
 }

Config.PumpModels = {  -- Set the pump models you want to use - https://gta-objects.xyz/objects/search?text=pump
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
 }

Config.ConsumptionClasses = {  -- Set the level of consume when the car is stopped but with engine on 
	[0]  = 0.04, -- Compacts
	[1]  = 0.05, -- Sedans
	[2]  = 0.06, -- SUVs
	[3]  = 0.08, -- Coupes
	[4]  = 0.08, -- Muscle
	[5]  = 0.10, -- Sports Classics
	[6]  = 0.12, -- Sports
	[7]  = 0.20, -- Super
	[8]  = 0.05, -- Motorcycles
	[9]  = 0.08, -- Off-road
	[10] = 0.10, -- Industrial
	[11] = 0.09, -- Utility
	[12] = 0.08, -- Vans
	[13] = 0.00, -- Cycles
	[14] = 0.00, -- Boats
	[15] = 0.00, -- Helicopters
	[16] = 0.00, -- Planes
	[17] = 0.09, -- Service
	[18] = 0.10, -- Emergency
	[19] = 0.10, -- Military
	[20] = 0.15, -- Commercial
	[21] = 0.00, -- Trains
 }

Config.FuelUsageByRPM = {  -- The first value is the RPM, the second value it is how much fuel it will be removed from the tank each second
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
 }

-------------------------- DISCORD LOGS

Config.BotName = 'ServerName' -- Write the desired bot name

Config.ServerName = 'ServerName' -- Write your server's name

Config.IconURL = '' -- Insert your desired image link

Config.DateFormat = '%d/%m/%Y [%X]' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html


Config.BuyBusinessWebhook = true
Config.BuyBusinessWebhookColor = '65280'

Config.SellBusinessWebhook = true
Config.SellBusinessWebhookColor = '16711680'

Config.DepositWebhook = true
Config.DepositWebhookColor = '65280'

Config.WithdrawWebhook = true
Config.WithdrawWebhookColor = '16711680'

Config.HireWebhook = true
Config.HireWebhookColor = '65280'

Config.FireWebhook = true
Config.FireWebhookColor = '16711680'

Config.FireYourselfWebhook = true
Config.FireYourselfWebhookColor = '16711680'

Config.EditEmployeeRankWebhook = true
Config.EditEmployeeRankWebhookColor = '65280'

Config.EditGasPriceWebhook = true
Config.EditGasPriceWebhookColor = '65280'

Config.salesHistoryWebhook = true
Config.salesHistoryWebhookColor = '65280'

Config.NewOrderWebhook = true
Config.NewOrderWebhookColor = '65280'

Config.OrderAcceptedWebhook = true
Config.OrderAcceptedWebhookColor = '65280'

Config.OrderCanceledWebhook = true
Config.OrderCanceledWebhookColor = '16711680'


-------------------------- LOCALES (DON'T TOUCH)
	
function _okok(id)
	if Locales[Config.Locale][id] then
		return Locales[Config.Locale][id]
	else
		print("The locale '"..id.."' doesn't exist!")
	end
end