Config, Locales = {}, {}

-- =========================
-- CORE/TOGGLES
-- =========================
Config.Debug = false -- true = will print some debug messages
Config.Locale = 'en' -- en
Config.AddVehiclesFromVehiclesFile = false -- true = will add vehicles from the vehicles table in the database
Config.MaxDistanceToStand = 50 -- Maximum distance to the stand to show markers
Config.InteractionMarkerDistance = 1 -- Interaction marker distance

-- Notifications/UI/Integrations
Config.UseOkokNotify = GetResourceState('okokNotify') == 'started' and true or false -- if you want to use okokNotify set it to true
Config.UseOkokTextUI = GetResourceState('okokTextUI') == 'started' and true or false -- if you want to use okokTextUI set it to true
Config.UseOkokRequests = GetResourceState('okokRequests') == 'started' and true or false -- if you want to use okokRequests set it to true
Config.SocietyGarage = "okokGarage" -- Used for society purchases and trade-in vehicles
Config.KeySystem = '' -- (change on cl_utils.lua)
Config.InventorySystem = '' -- Inventory system to use for trunk weight calculation (changeable on cl_utils.lua)
Config.PlayerLoadedEvent = 'esx:playerLoaded' -- Event to trigger when the player is loaded

-- Vehicle Listing Settings
Config.VehicleListingType = 'categories' -- 'normal' all vehicles in the same page | 'categories' all vehicles in categories
Config.EnableDatabaseUpdateInterval = false -- If true = the database will be updated in the interval set on Config.DatabaseUpdateInterval
Config.DatabaseUpdateInterval = 50000 -- How often the database will be updated in seconds
Config.UseSameImageForAllVehicles = false -- true = will use the same image for all vehicles (web/img/vehicles/default.png) | false = will use the image from the vehicle_id
Config.UseLocalImages = true -- true = will use images from /web/img/vehicles | false = it will get the images from the github repository, if not found it will use an image from the web/img/vehicles/

-- Input/Target
Config.UseTarget = false -- true = will use target | false = will use marker
Config.TargetSystem = 'ox-target' -- 'ox-target'
Config.Key = 38 -- [E] Key to open the interaction, check here the keys ID: https://docs.fivem.net/docs/game-references/controls/#controls

-- Currency/Business
Config.Currency = '$' -- Currency symbol
Config.CurrencySide = 'right' -- left | right
Config.MaxEmployeesPerDealership = 5 -- Maximum number of employees per dealership
Config.HireRange = 3 -- Range to hire an employee
Config.WeeklyGoalResetHours = 168 -- How many hours to reset the weekly goal (168 = 1 week)

-- Pricing Settings
Config.UseMultiplierFactorForMinPrice = false -- true = calculate min price based on the multiplier factor (price*Config.MinPriceMultiplier) | false = min price will be the base price
Config.MinPriceMultiplier = 0.5 -- This is the multiplier factor for the min price (Config.UseMultiplierFactorForMinPrice = true)
Config.UseMultiplierFactorForMaxPrice = false -- true = calculate price based on the multiplier factor (price*Config.MaxPriceAddition) | false = calculate price based on the max price addition (price+Config.MaxPriceAddition)
Config.MaxPriceAddition = 5000 -- This is how much will be added to the vehicle price to create the max_price
Config.OwnerBuyVehiclePercentage = 10 -- How much of a discount the owner has to order a vehicle (bases on the min. price)
Config.SellBusinessReceivePercentage = 50 -- How much % a player will receive for selling his business (in percentage, 50 = 50%)

-- Plate Settings [THE PLATE NEEDS TO BE MAX 8 CHARACTERS, SO THE MAX IS 4 LETTERS AND 2 NUMBERS IF YOU HAVE PLATE PREFIX WITH 2 CHARACTERS]
Config.PlateLetters = 3 -- How many letters the plate has
Config.PlateNumbers = 3 -- How many numbers the plate has
Config.PlateUseSpace = false -- If the plate uses spaces between letters and numbers
Config.EnableCustomPlates = false -- If true = players can use custom plates for their vehicles
Config.CustomPlatePrice = 1000 -- The price for a custom plate
Config.EnablePlatePrefix = false -- If true = the plate will have a prefix
Config.PlatePrefix = "OK" -- The prefix for the plate

-- Interface/History Settings
Config.SalesDateFormat = "%d/%m - %H:%M" -- Format of the sales date
Config.MaxLogsDays = 7 -- How many days to keep the logs on the UI (the old ones it will be saved on the database)
Config.MaxEntriesOnVehicleHistory = 24 -- How many entries to keep on the vehicle history to avoid any performance issues

-- Vehicle Classes
Config.UseVehicleClasses = true -- If you want to use vehicle classes set it to true
Config.CalculateVehicleClasses = false -- If you want to enable vehicle class calculation set it to true
Config.VehicleClasses = {
    ['C'] = 350,
    ['B'] = 400,
    ['A'] = 600,
    ['S'] = 800,
    ['S+'] = 1000,
}

-- Vehicle Color ID Settings
Config.UseVehicleColorID = true -- NOTE: If this is set to true, the vehicle color selected will be converted to the closest color ID. It fixes some errors with mechanics not being able to change the vehicle color

-- =========================
-- MISSIONS/ORDERS
-- =========================
Config.MissionForStock = false -- false = when you order a vehicle, the vehicle shop will instantly receive it without doing any order/mission
Config.OrderReceivePercentage = true -- If true = players will receive a percentage of the vehicle price (Config.OrderCompletedPercentage) | if false = players receive a flat rate (Config.OrderCompletedFlatRate)
Config.OrderCompletedPercentage = 10 -- When a employee completes the misson he will get this percentage as a reward, 10 = 10% (Config.OrderReceivePercentage = true)
Config.OrderCompletedFlatRate = 1000 -- When a employee completes the misson he will get paid this value (Config.OrderReceivePercentage = false)
Config.CancelCustomOrderFee = 5 -- When a player cancels a custom order he will lose a fee of the vehicle price, 5 = 5%

-- Vehicle Sales/Trade-ins
Config.EnableSellVehicle = false -- If true = players can sell their vehicles to the vehicle shop
Config.SellVehiclePercentage = 50 -- When a player sells a vehicle to the vehicle shop he will get a percentage of the vehicle price, 50 = 50%
Config.EnableTradeIns = true -- If true = players can trade-in their vehicles for a discount on a new vehicle
Config.TradeInPercentage = 75 -- This is the percentage of the vehicle price that will be given as a discount for the trade-in
Config.TradeInStored = true -- If true = player can only trade-in vehicles that are stored
Config.SocietyTradeInRanksLevel = {3, 4}

-- Blips & Markers
Config.TruckBlip = {blipId = 67, blipColor = 2, blipScale = 0.9, blipText = "Truck"} -- Blip of the truck when someone accepts an order
Config.TrailerBlip = {blipId = 515, blipColor = 2, blipScale = 0.9, blipText = "Trailer"} -- Blip of the trailer when someone accepts an order (for vehicle shops with big vehicles)
Config.OrderBlip = {blipId = 478, blipColor = 5, blipText = "Order"}  -- Blip of the ordered vehicle when someone accepts an order
Config.TowMarker = {id = 21, size = {x = 0.5, y = 0.5, z = 0.5}, color = {r = 31, g = 94, b = 255, a = 90}, bobUpAndDown = false, faceCamera = false, rotate = true, drawOnEnts = false, textureDict = false, textureName = false} -- The marker to tow a vehicle when someone accepts an order

-- Commands & Resources
Config.AdminMenuCommand = "vsadmin" -- Command to open the admin menu
Config.FlatbedResourceName = "flatbed" -- Name of the flatbed resource (Get it here: https://github.com/flowdgodx/flatbed)
Config.SmallTowTruckID = "flatbed3" -- Id of the truck used to tow the vehicle 
Config.BigTowTruckID = "Hauler"
Config.TrailerID = "TRFlat"

-- =========================
-- JOB RANKS/GOALS
-- =========================
Config.JobRanks = { -- These are the ranks available on the vehicle shops, you can add or remove as many as you want but leave at least 1
	{rank = "Newbie", subowner = false},
	{rank = "Experienced", subowner = false},
	{rank = "Expert", subowner = false},
	{rank = "Sub-Owner", subowner = true}
}

Config.WeeklyGoalOptions = { -- Weekly goal options to show on the dashboard
    [1] = 10000,
	[2] = 25000,
	[3] = 50000,
	[4] = 100000,
	[5] = 250000,
	[6] = 500000,
}

-- =========================
-- FINANCE SETTINGS
-- =========================
Config.FinanceVehiclesSettings = {
	["enabled"] = true, -- if true = the finance vehicles will be enabled
	["command"] = "financedvehicles", -- command to open the finance menu
	["interest_rate"] = 0.15, -- 15% interest rate
	["payment_check_interval"] = 12, -- real hours
	["payments"] = 12, -- how many payments will be made
	["max_failed_payments"] = 3, -- maximum number of failed payments before the vehicle is repossessed
	["max_financed_vehicles"] = 2, -- maximum number of financed vehicles per player
	["loop_check_interval"] = 60, -- seconds, how often the script will check for financed vehicles
}

-- =========================
-- VEHICLE CATEGORIES
-- =========================
Config.Categories = { -- Get the type from the database and make sure to add it here according to the type of vehicle for the test drive to be able to identify the vehicle type
	["car"] = { -- car categories
		vehicles = true,
		luxury = true,
	},
	["boat"] = { -- boat categories
		boats = true,
	},
	["air"] = { -- air categories
		air = true,
	},
}

Config.CategoriesLabels = { -- Categories labels to show on the UI
	["alfa"] = "Alfa Romeo",
	["astonmartin"] = "Aston Martin",
	["audi"] = "Audi",
	["bentley"] = "Bentley",
	["bmw"] = "BMW",
	["cadillac"] = "Cadillac",
	["chevrolette"] = "Chevrolet",
	["dodge"] = "Dodge",
	["drift"] = "Drift",
	["ferrari"] = "Ferrari",
	["ford"] = "Ford",
	["bezanje"] = "Bezanje",
	["honda"] = "Honda",
	["infinity"] = "Infiniti",
	["jeep"] = "Jeep",
	["lamborghini"] = "Lamborghini",
	["land_rang_rover"] = "Land Rover",
	["mazda"] = "Mazda",
	["mclaren"] = "McLaren",
	["mercedes_brabus"] = "Mercedes / Brabus",
	["mitsubishi"] = "Mitsubishi",
	["motori"] = "Motori",
	["nissan"] = "Nissan",
	["opel"] = "Opel",
	["ostali"] = "Ostali",
	["porsche"] = "Porsche",
	["reno"] = "Renault",
	["rr"] = "Rolls-Royce",
	["skoda"] = "Skoda",
	["tesla"] = "Tesla",
	["toyota"] = "Toyota",
	["volvo"] = "Volvo",
	["vw"] = "Volkswagen",
	["vip"] = "Vip"
}

-- =========================
-- VEHICLE SHOPS/LOCATIONS
-- =========================

Config.Stands = {
	{
		label = "Autosalon",
		licenseType = "",
		currency = "bank",
		hasOwner = true,
		blipCoords = vector3(-1018.9434, -1517.3822, 5.5868),
		isVip = false,

		vehicleCameraSettings = {
			location = vector4(-1009.5612, -1503.4229, 5.3324, 149.4107),
			camera = vector4(-1008.7195, -1509.4144, 6.35, 11.1583),
		},

		vehicleSettings = {
			sellVehicleCoords = vector3(-991.8617, -1507.8060, 5.7874),
			purchaseVehicleCoords = {
				{vector4(-993.7682, -1508.9596, 5.1803, 304.8412)},
			}
		},

		testDriveSettings = {
			paid = true,
			price = 100,
			time = 40,
			plate = "TEST",
			carLocation = vector4(-953.762, -3364.62, 13.336, 59.43),
			boatLocation = vector4(-183.548, -3476.81, 1.2252, 249.22),
			airLocation = vector4(-953.762, -3364.62, 13.336, 59.43),
		},

        markerSettings = {
            ownerCoords = vector3(-996.9982, -1501.3053, 5.7874),
			vehicleCoords = vector3(-1002.4913, -1503.1646, 5.7874),
        },

        targetSettings = {
            ownerCoords = vector3(-996.9982, -1501.3053, 4.7874),
			vehicleCoords = vector3(-1002.4913, -1503.1646, 4.7874),
        },

        flatbedSettings = {
            spawnPosition = vector4(-1043.4595, -1523.3386, 4.4286, 35.2704),
            towCoords = {bone = 'bodyshell', xPos = 0.0, yPos = -2.35, zPos = 1.0},
            bigVehicles = false,
        },

		missionsVehicleSpawn = {
			vector3(-1049.8356, -1424.4448, 4.8190),
		},

		radius = 1, -- Interaction radius for the markers
		price = 1000000, -- Price of the vehicle shop
		blip = {blipId = 225, blipColor = 3, blipColorPurchasable = 1, blipScale = 0.9}, -- Blip informations for vehicleshop blip
		marker = {id = 21, color = {r = 31, g = 94, b = 255, a = 90}, size = {x = 0.5, y = 0.5, z = 0.5}, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0, textureDict = 0, textureName = 0}, -- Marker informations for the vehicle shop
		type = "vehicles", -- Type of shop (will change displayed vehicles) | CAN be repeated on other shops
		id = "vehicles1", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	},
--[[	{
		label = "Air Shop", -- name of the vehicle shop
		licenseType = "", -- if you want to use a license system you'll need to set it up on sv_utils.lua
		currency = "bank", -- used to buy/sell the business and buy vehicle
		hasOwner = true, -- true = this vehicle shop can have a owner and will need maintenance to have stock | false = no owner and with vehicles all the time, price = max_price set on the database
		blipCoords = vector3(-1651.31, -3140.09, 13.99), -- blip position for the vehicle shop
		isVip = false, -- if set to true IT WON'T BE OWNED BY ANYONE and will use vip coins instead of currency, check sv_utils.lua to change the vip coins functions

		vehicleCameraSettings = {
			location = vector(-1653.95, -3145.65, 13.57),
			camera = vector4(-1646.35, -3136.25, 13.99, 137.72),
		},

		vehicleSettings = {
			sellVehicleCoords = vector3(-1613.93, -3120.78, 13.29), -- position where the vehicles can be sold
			purchaseVehicleCoords = { -- positions where the vehicles will be spawned when the player purchases a vehicle
				{vector4(-1635.53, -3101.68, 13.94, 339.18)},
				{vector4(-1613.15, -3113.99, 13.94, 329.95)},
			}
		},

		testDriveSettings = {
			paid = true, -- true = the player will pay for the test drive | false = the player will not pay for the test drive
			price = 100, -- Price of the test drive
			time = 45, -- Time of the test drive in seconds
			plate = "TEST", -- Plate of the test drive vehicle [max 8 characters]
			carLocation = vector4(-1332.52, -2205.1, 13.34, 151.03), -- Location of the car test drive
			boatLocation = vector4(-796.85, -1502.27, -0.09, 113.55), -- Location of the boat test drive
			airLocation = vector4(-1332.52, -2205.1, 13.34, 151.03), -- Location of the air test drive
		},

        markerSettings = {
            ownerCoords = vector3(-1621.36, -3152.85, 13.99), -- Marker/Shop position for owner/employees
			vehicleCoords = vector3(-1651.31, -3140.09, 13.99), -- Marker/Shop position for vehicle listing
        },

        targetSettings = {
            ownerCoords = vector3(-1621.36, -3152.85, 13.99), -- Marker/Shop position for owner/employees
			vehicleCoords = vector3(-1651.31, -3140.09, 13.99), -- Marker/Shop position for vehicle listing
        },

        flatbedSettings = {
            spawnPosition = vector4(-1623.12, -3125.0, 13.94, 328.06),
            towCoords = {bone = 'bodyshell', xPos = 0.0, yPos = -2.35, zPos = 1.0},
            bigVehicles = true, -- Set to true if it's airplanes/helicopters/etc... it'll use a truck instead of a flatbed to get the ordered vehicles
        },

		missionsVehicleSpawn = { -- Locations where someone who accepted an order will have to go (it is random)
			vector3(-1576.84, -3096.82, 13.94),
		},

		radius = 1, -- Interaction radius for the markers
		price = 10000, -- Price of the vehicle shop
		blip = {blipId = 64, blipColor = 3, blipColorPurchasable = 1, blipScale = 0.9}, -- Blip informations for vehicleshop blip
		marker = {id = 21, color = {r = 31, g = 94, b = 255, a = 90}, size = {x = 0.5, y = 0.5, z = 0.5}, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0, textureDict = 0, textureName = 0}, -- Marker informations for the vehicle shop
		type = "air", -- Type of shop (will change displayed vehicles) | CAN be repeated on other shops
		id = "air1", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	},
	{
		label = "VIP Vehicle Shop", -- name of the vehicle shop
		licenseType = "", -- if you want to use a license system you'll need to set it up on sv_utils.lua
		currency = "bank", -- used to buy/sell the business and buy vehicle
		hasOwner = false, -- true = this vehicle shop can have a owner and will need maintenance to have stock | false = no owner and with vehicles all the time, price = max_price set on the database
		blipCoords = vector3(-803.42, -224.29, 37.22), -- blip position for the vehicle shop
		isVip = true, -- if set to true IT WON'T BE OWNED BY ANYONE and will use vip coins instead of currency, check sv_utils.lua to change the vip coins functions

		vehicleCameraSettings = {
			location = vector3(-76.54, -821.94, 284.58),
			camera = vector4(-71.75, -827.75, 285.75, 40.86),
		},

		vehicleSettings = {
			sellVehicleCoords = vector3(-768.73, -244.28, 37.24), -- position where the vehicles can be sold
			purchaseVehicleCoords = { -- positions where the vehicles will be spawned when the player purchases a vehicle
				{vector4(-804.76, -235.02, 36.45, 28.62)},
			}
		},

		testDriveSettings = {
			paid = true, -- true = the player will pay for the test drive | false = the player will not pay for the test drive
			price = 100, -- Price of the test drive
			time = 45, -- Time of the test drive in seconds
			plate = "TEST", -- Plate of the test drive vehicle [max 8 characters]
			carLocation = vector4(-1332.52, -2205.1, 13.34, 151.03), -- Location of the car test drive
			boatLocation = vector4(-796.85, -1502.27, -0.09, 113.55), -- Location of the boat test drive
			airLocation = vector4(-1332.52, -2205.1, 13.34, 151.03), -- Location of the air test drive
		},

        markerSettings = {
			vehicleCoords = vector3(-803.42, -224.29, 37.22), -- Marker/Shop position for vehicle listing
        },

        targetSettings = {
			vehicleCoords = vector3(-803.42, -224.29, 37.22), -- Marker/Shop position for vehicle listing
        },

		radius = 1, -- Interaction radius for the markers
		price = 10000, -- Price of the vehicle shop
		blip = {blipId = 225, blipColor = 3, blipColorPurchasable = 1, blipScale = 0.9}, -- Blip informations for vehicleshop blip
		marker = {id = 21, color = {r = 31, g = 94, b = 255, a = 90}, size = {x = 0.5, y = 0.5, z = 0.5}, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0, textureDict = 0, textureName = 0}, -- Marker informations for the vehicle shop
		type = "vehicles", -- Type of shop (will change displayed vehicles) | CAN be repeated on other shops
		id = "vehicles2", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	},
	{
		label = "PDM Vehicle Shop", -- name of the vehicle shop
		licenseType = "", -- if you want to use a license system you'll need to set it up on sv_utils.lua
		currency = "bank", -- used to buy/sell the business and buy vehicle
		hasOwner = true, -- true = this vehicle shop can have a owner and will need maintenance to have stock | false = no owner and with vehicles all the time, price = max_price set on the database
		blipCoords = vector3(660.3, 593.22, 129.24), -- blip position for the vehicle shop
		isVip = false, -- if set to true IT WON'T BE OWNED BY ANYONE and will use vip coins instead of currency, check sv_utils.lua to change the vip coins functions

		vehicleCameraSettings = {
			location = vector3(-76.54, -821.94, 284.58),
			camera = vector4(-71.75, -827.75, 285.75, 40.86),
		},

		vehicleSettings = {
			sellVehicleCoords = vector3(651.12, 597.1, 128.49), -- position where the vehicles can be sold
			purchaseVehicleCoords = { -- positions where the vehicles will be spawned when the player purchases a vehicle
				{vector4(651.12, 597.1, 128.49, 70.46)},
			}
		},

		testDriveSettings = {
			paid = true, -- true = the player will pay for the test drive | false = the player will not pay for the test drive
			price = 100, -- Price of the test drive
			time = 45, -- Time of the test drive in seconds
			plate = "TEST", -- Plate of the test drive vehicle [max 8 characters]
			carLocation = vector4(-1332.52, -2205.1, 13.34, 151.03), -- Location of the car test drive
			boatLocation = vector4(-796.85, -1502.27, -0.09, 113.55), -- Location of the boat test drive
			airLocation = vector4(-1332.52, -2205.1, 13.34, 151.03), -- Location of the air test drive
		},

        markerSettings = {
            ownerCoords = vector3(660.2, 592.93, 129.24), -- Marker/Shop position for owner/employees
			vehicleCoords = vector3(656.16, 588.69, 129.05), -- Marker/Shop position for vehicle listing
        },

        targetSettings = {
            ownerCoords = vector3(660.2, 592.93, 129.24), -- Marker/Shop position for owner/employees
			vehicleCoords = vector3(656.16, 588.69, 129.05), -- Marker/Shop position for vehicle listing
        },

        flatbedSettings = {
            spawnPosition = vector4(644.99, 595.83, 129.0, 339.32),
            towCoords = {bone = 'bodyshell', xPos = 0.0, yPos = -2.35, zPos = 0.90},
            bigVehicles = false, -- Set to true if it's airplanes/helicopters/etc... it'll use a truck instead of a flatbed to get the ordered vehicles
        },

		missionsVehicleSpawn = { -- Locations where someone who accepted an order will have to go (it is random)
		vector3(682.89, 670.85, 128.49),
		},

		radius = 1, -- Interaction radius for the markers
		price = 10000, -- Price of the vehicle shop
		blip = {blipId = 225, blipColor = 3, blipColorPurchasable = 1, blipScale = 0.9}, -- Blip informations for vehicleshop blip
		marker = {id = 21, color = {r = 31, g = 94, b = 255, a = 90}, size = {x = 0.5, y = 0.5, z = 0.5}, bobUpAndDown = 0, faceCamera = 0, rotate = 1, drawOnEnts = 0, textureDict = 0, textureName = 0}, -- Marker informations for the vehicle shop
		type = "vehicles", -- Type of shop (will change displayed vehicles) | CAN be repeated on other shops
		id = "vehicles3", -- ID of the shop, it's used to get what shop is opened | needs to be DIFFERENT for each shop
	},]]
}