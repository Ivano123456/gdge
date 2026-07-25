Config                       = {}
Locales                      = Locales or {}
Config.Framework             =
'esx'                                                                                         -- esx, oldesx, qb, oldqb, vrp,  qb = qbox, standalone -- || type qb if you are using qbox
Config.Locale                = 'en'
Config.CurrencyUnit          = '$'                                                           -- '€' -- '₺'  '$'
Config.SQL                   = "oxmysql"                                                     -- oxmysql / mysql-async / ghmattimysql
Config.Inventory             =
"ox_inventory"                                                                               -- qb_inventory / esx_inventory / ox_inventory / qs_inventory / tgiann-inventory / codem-inventory / need Config.missioncompletedItems
Config.ServerName            = "TWORST"                                                      -- Server Name MAX 10
Config.MoneyType             = "$"                                                           -- Money Type
Config.MoneyType2            = "bank"                                                        -- Money Type bank / cash
Config.InteractionHandler    =
'drawtext'                                                                                   -- drawtext - qb-target - ox-target
Config.ExampleProfilePicture = "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png" -- bu kısım değişecek

Config.MaxPlayersInLobby     = 4                                                             --[4] Max players in lobby max number write 4

-- Vehicle Plate Configuration
-- Custom plate is set BEFORE any vehicle logic starts (keys, fuel, interactions)
Config.VehiclePlate          = {
    enabled = true,       -- true = use custom plate, false = use GTA default random plate
    format = "GARB %03d", -- Format string: %d = job number, %03d = zero-padded (001, 002...)
    -- Examples: "N 21 WST", "GARBAGE1", "TW-%03d", "JOB %d"
    static = nil,         -- Set a static plate (e.g., "N 21 WST") - overrides format if set
}

Config.Command               = {
    jobReset = "jobresetgarbage",
    jobLeave = "jobleavegarbage",
    openTutorial = "openTutorialgarbage",
}

Config.jobCoolDownHours      = 0     -- Job Cooldown Hours if 0 no cooldowns
Config.ChangeClothesSystem   = false -- true / false
Config.ClothingScript        =
"qb-clothing"                        -- fivem-appearance / illenium-appearance  / esx_skin / qb-clothing / rcore_clothing
Config.TebexSystem           = false -- true / false -- There is currently no tebex system, infrastructure for future addition
Config.Debug                 = false -- true / false (PRODUCTION: false, test için: true)
Config.jobLevelCheck         = false -- true / false
Config.closeInvisable        = false -- prevents the player from being invisible during UI
Config.EnableConvertDumpster = true  -- true / false - Enable or disable the convert dumpster task (4th mission)

Config.InteractionKeys       = {
    ['E'] = 38,
    ['G'] = 47,
}

Config.InteractionKeyColor   =
"~g~" -- GTA color codes: ~r~ red, ~g~ green, ~b~ blue, ~y~ yellow, ~p~ purple, ~o~ orange, ~w~ white (default)

Config.Keys                  = {
    inviteAccept  = 246, -- Y key
    inviteDecline = 306, -- CTRL key
}


Config.TrashVisuals       = {
    enableOutline = true,
    viewDistance = 15.0
}

Config.DefaultUIPositions = {
    teamList = { top = '77.22vh', left = '85.94vw' },
    scoreList = { top = '2.64vh', left = '1.61vw' },
    inviteSide = { top = '2.85vh', left = '73.07vw' },
    notificationDiv = { top = '40.48vh', left = '81.54vw' }
}

Config.Job                = {
    ['coords'] = {
        ['intreactionCoords'] = vector3(-324.13, -1533.45, 27.57),
        ['ped'] = true,
        ['pedCoords'] = vector3(-324.13, -1533.45, 27.57),
        ['pedHeading'] = 349.59,
        ['pedHash'] = 0x49EA5685,
    },
    ['job'] = 'all', -- Example: 'garbage' or {'garbage', 'unemployed', 'mechanic'}
    ['blip'] = {
        show = true,
        blipName = Locales[Config.Locale]['jobName'],
        blipType = 632,
        blipColor = 25,
        blipScale = 0.55
    },
    ['missionBlips'] = {
        [1] = {
            SetBlipSprite = 365,
            SetBlipColour = 25,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = Locales[Config.Locale]['missionOneBlips']
        },
        [2] = {
            SetBlipSprite = 365,
            SetBlipColour = 25,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = Locales[Config.Locale]['missionTwoBlips']
        },
        [3] = {
            SetBlipSprite = 365,
            SetBlipColour = 25,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = Locales[Config.Locale]['missionThreeBlips']
        },
        [4] = {
            SetBlipSprite = 365,
            SetBlipColour = 25,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = Locales[Config.Locale]['missionFourBlips']
        },
        [5] = {
            SetBlipSprite = 365,
            SetBlipColour = 25,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = Locales[Config.Locale]['missionThreeBlips']
        },
        ['vehicleBlips'] = {
            SetBlipSprite = 67,
            SetBlipColour = 0,
            SetBlipScale = 0.8,
        },
        ['deliveryBlips'] = {
            SetBlipSprite = 38,
            SetBlipColour = 29,
            SetBlipScale = 0.80,
        },
    },
    ['missioncompletedItems'] = {
        giveItemPlayer = true,
        dropMode = "perItem",
        itemList = {
            { item = 'scrap_metal',     min = 2, max = 6, chance = 55 },
            { item = 'prazna_cahura',   min = 2, max = 5, chance = 50 },
            { item = 'weapon_parts',    min = 1, max = 3, chance = 49 },
            { item = 'guma',            min = 1, max = 2, chance = 30 },
            { item = 'old_armor',       min = 1, max = 1, chance = 17 },
        },
    },
    ['drawtext'] = {
        ['deliveryVehicle'] = Locales[Config.Locale]['deliveryVehicle'],
    },
    ['regionData'] = {
        {
            regionID = 1,
            regionInfo = {
                regionName = "El Burro Heights",
                regionJobTask = Locales[Config.Locale] and Locales[Config.Locale]['regionJobTask'],
                regionImage = "region.png",
                regionMinimumLevel = 0
            },
            regionAwards = {
                money = 5000,
                xp = 1000,
                onlineJobExtraAwards = 2,
                bonusExtraMoney = 500,
                bonusExtraXP = 200,
            },
            missioncompletedItems = {
                giveItemPlayer = true,
                dropMode = "perItem",
                itemList = {
                    { item = 'scrap_metal',     min = 2, max = 6, chance = 70 },
                    { item = 'prazna_cahura',   min = 2, max = 5, chance = 45 },
                    { item = 'weapon_parts',    min = 1, max = 2, chance = 28 },
                    { item = 'guma',            min = 1, max = 2, chance = 22 },
                    { item = 'old_armor',       min = 1, max = 1, chance = 12 },
                },
            },
            regionJobVehicle = {
                vehicle = "tolgartur",
            },
            vehicleSpawnCoords = {
                vector4(-341.36, -1522.33, 27.74, 270.22),
            },
            regionJobTask = {
                {
                    id = 1,
                    jobName = "dumpsterClean",
                    missionCount = {
                        minAmount = 2,
                        maxAmount = 2
                    },
                    jobLabel = Locales[Config.Locale]['missionOneBlips']
                },
                {
                    id = 2,
                    jobName = "bagClean",
                    missionCount = {
                        minAmount = 3,
                        maxAmount = 3
                    },
                    jobLabel = Locales[Config.Locale]['missionTwoBlips']
                },
                {
                    id = 3,
                    jobName = "trashCollect",
                    missionCount = {
                        minAmount = 2,
                        maxAmount = 2
                    },
                    jobLabel = Locales[Config.Locale]['missionThreeBlips']
                },
                {
                    id = 4,
                    jobName = "convertDumpster",
                    missionCount = {
                        minAmount = 1,
                        maxAmount = 1
                    },
                    jobLabel = Locales[Config.Locale]['missionFourBlips']
                },
            },
        },
        {
            regionID = 2,
            regionInfo = {
                regionName = "Paleto Bay",
                regionJobTask = Locales[Config.Locale] and Locales[Config.Locale]['regionJobTask'],
                regionImage = "region.png",
                regionMinimumLevel = 2
            },
            regionAwards = {
                money = 5000,
                xp = 1000,
                onlineJobExtraAwards = 2,
                bonusExtraMoney = 500,
                bonusExtraXP = 200,
            },
            missioncompletedItems = {
                giveItemPlayer = true,
                dropMode = "perItem",
                itemList = {
                    { item = 'scrap_metal',     min = 2, max = 6, chance = 70 },
                    { item = 'prazna_cahura',   min = 2, max = 5, chance = 45 },
                    { item = 'weapon_parts',    min = 1, max = 2, chance = 28 },
                    { item = 'guma',            min = 1, max = 2, chance = 22 },
                    { item = 'old_armor',       min = 1, max = 1, chance = 12 },
                },
            },
            regionJobVehicle = {
                vehicle = "tolgartur",
            },
            vehicleSpawnCoords = {
                vector4(-341.36, -1522.33, 27.74, 270.22),
            },
            regionJobTask = {
                {
                    id = 1,
                    jobName = "dumpsterClean",
                    missionCount = {
                        minAmount = 5,
                        maxAmount = 7
                    },
                    jobLabel = Locales[Config.Locale]['missionOneBlips']
                },
                {
                    id = 2,
                    jobName = "bagClean",
                    missionCount = {
                        minAmount = 5,
                        maxAmount = 10
                    },
                    jobLabel = Locales[Config.Locale]['missionTwoBlips']
                },
                {
                    id = 3,
                    jobName = "trashCollect",
                    missionCount = {
                        minAmount = 6,
                        maxAmount = 10
                    },
                    jobLabel = Locales[Config.Locale]['missionThreeBlips']
                },
                {
                    id = 4,
                    jobName = "convertDumpster",
                    missionCount = {
                        minAmount = 1,
                        maxAmount = 1
                    },
                    jobLabel = Locales[Config.Locale]['missionFourBlips']
                },
            },
        },
        {
            regionID = 3,
            regionInfo = {
                regionName = "Sandy Shores",
                regionJobTask = Locales[Config.Locale] and Locales[Config.Locale]['regionJobTask'],
                regionImage = "region.png",
                regionMinimumLevel = 5
            },
            regionAwards = {
                money = 5000,
                xp = 1000,
                onlineJobExtraAwards = 2,
                bonusExtraMoney = 500,
                bonusExtraXP = 200,
            },
            missioncompletedItems = {
                giveItemPlayer = true,
                dropMode = "perItem",
                itemList = {
                    { item = 'scrap_metal',     min = 2, max = 6, chance = 70 },
                    { item = 'prazna_cahura',   min = 2, max = 5, chance = 45 },
                    { item = 'weapon_parts',    min = 1, max = 2, chance = 28 },
                    { item = 'guma',            min = 1, max = 2, chance = 22 },
                    { item = 'old_armor',       min = 1, max = 1, chance = 12 },
                },
            },
            regionJobVehicle = {
                vehicle = "tolgartur",
            },
            vehicleSpawnCoords = {
                vector4(-341.36, -1522.33, 27.74, 270.22),
            },
            regionJobTask = {
                {
                    id = 1,
                    jobName = "dumpsterClean",
                    missionCount = {
                        minAmount = 7,
                        maxAmount = 9
                    },
                    jobLabel = Locales[Config.Locale]['missionOneBlips']
                },
                {
                    id = 2,
                    jobName = "bagClean",
                    missionCount = {
                        minAmount = 7,
                        maxAmount = 14
                    },
                    jobLabel = Locales[Config.Locale]['missionTwoBlips']
                },
                {
                    id = 3,
                    jobName = "trashCollect",
                    missionCount = {
                        minAmount = 8,
                        maxAmount = 16
                    },
                    jobLabel = Locales[Config.Locale]['missionThreeBlips']
                },
                {
                    id = 4,
                    jobName = "convertDumpster",
                    missionCount = {
                        minAmount = 1,
                        maxAmount = 1
                    },
                    jobLabel = Locales[Config.Locale]['missionFourBlips']
                },
            },
        },
    },
    ['dailyMission'] = {
        {
            name = 'jobtask_one',
            header = Locales[Config.Locale]['jobtask'] .. " 1",
            label = Locales[Config.Locale]['dailyjobone'],
            count = 50,
            xp = 2500,
            money = 1000,
        },
        {
            name = 'jobtask_two',
            header = Locales[Config.Locale]['jobtask'] .. " 2",
            label = Locales[Config.Locale]['dailyjobtwo'],
            count = 10,
            xp = 1000,
            money = 3000

        },
        {
            name = 'jobtask_three',
            header = Locales[Config.Locale]['jobtask'] .. " 3",
            label = Locales[Config.Locale]['dailyjobthree'],
            count = 10000,
            xp = 2000,
            money = 3000
        },

        {
            name = 'jobtask_four',
            header = Locales[Config.Locale]['jobtask'] .. " 4",
            label = Locales[Config.Locale]['dailyjobfour'],
            count = 20,
            xp = 2000,
            money = 3000
        },
    },
}

Config.TutorialList       = {
    { id = 1, title = Locales[Config.Locale]['tutorialTitle1'], description = Locales[Config.Locale]['tutorialDescription1'], name = 'https://r2.fivemanage.com/9NudXTYtpmpSgugXi97iZ/garbage1.mp4' },
    { id = 2, title = Locales[Config.Locale]['tutorialTitle2'], description = Locales[Config.Locale]['tutorialDescription2'], name = 'https://r2.fivemanage.com/9NudXTYtpmpSgugXi97iZ/garbage2.mp4' },
    { id = 3, title = Locales[Config.Locale]['tutorialTitle3'], description = Locales[Config.Locale]['tutorialDescription3'], name = 'https://r2.fivemanage.com/9NudXTYtpmpSgugXi97iZ/garbage3.mp4' },
    { id = 4, title = Locales[Config.Locale]['tutorialTitle4'], description = Locales[Config.Locale]['tutorialDescription4'], name = 'https://r2.fivemanage.com/9NudXTYtpmpSgugXi97iZ/garbage4.mp4' },
    { id = 5, title = Locales[Config.Locale]['tutorialTitle5'], description = Locales[Config.Locale]['tutorialDescription5'], name = 'https://r2.fivemanage.com/9NudXTYtpmpSgugXi97iZ/garbage5.mp4' },
}

Config.JobClothes         = {
    male = {
        { jacket = 97,   texture = 0 },
        { shirt = 59,    texture = 0 },
        { arms = 0,      texture = 0 },
        { legs = 9,      texture = 6 },
        { shoes = 12,    texture = 3 },
        { mask = 0,      texture = 0 },
        { chain = 0,     texture = 11 },
        { decals = 0,    texture = 11 },
        { helmet = 0,    texture = 11 },
        { glasses = 0,   texture = 11 },
        { watches = 0,   texture = 11 },
        { bracelets = 0, texture = 11 }
    },
    female = {
        { jacket = 97,   texture = 0 },
        { shirt = 59,    texture = 0 },
        { arms = 0,      texture = 0 },
        { legs = 9,      texture = 6 },
        { shoes = 12,    texture = 3 },
        { mask = 0,      texture = 0 },
        { chain = 0,     texture = 11 },
        { decals = 0,    texture = 11 },
        { helmet = 0,    texture = 11 },
        { glasses = 0,   texture = 11 },
        { watches = 0,   texture = 11 },
        { bracelets = 0, texture = 11 }
    }
}

Config.Vehiclekey         = true

Config.GiveVehicleKey     = function(plate, model, vehicle) -- you can change vehiclekeys export if you use another vehicle key system
    if Config.Vehiclekey then
        if GetResourceState("jc_vehiclekeys") == "started" then
            exports['jc_vehiclekeys']:GiveTempKey(plate)
        elseif GetResourceState("cd_garage") == "started" then
            TriggerEvent('cd_garage:AddKeys', exports['cd_garage']:GetPlate(vehicle))
        elseif GetResourceState("qs-vehiclekeys") == "started" then
            model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
        elseif GetResourceState("wasabi_carlock") == "started" then
            exports.wasabi_carlock:GiveKey(plate)
        elseif GetResourceState("qb-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        elseif GetResourceState("qbx-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        elseif GetResourceState('MrNewbVehicleKeys') == 'started' then
            exports.MrNewbVehicleKeys:GiveKeysByPlate(plate)
        else
            if Config.Framework == "qb" or Config.Framework == "oldqb" then
                TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
            else
                print("No vehicle key system found")
            end
        end
    end
end

Config.Removekeys         = true

Config.RemoveVehiclekey   = function(plate, model, vehicle)
    if Config.Removekeys then
        if GetResourceState("jc_vehiclekeys") == "started" then
            exports['jc_vehiclekeys']:RemoveTempKey(plate)
        elseif GetResourceState("cd_garage") == "started" then
            TriggerServerEvent('cd_garage:RemovePersistentVehicles', exports['cd_garage']:GetPlate(vehicle))
        elseif GetResourceState("qs-vehiclekeys") == "started" then
            model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            exports['qs-vehiclekeys']:RemoveKeys(plate, model)
        elseif GetResourceState("wasabi_carlock") == "started" then
            exports.wasabi_carlock:RemoveKey(plate)
        elseif GetResourceState("qb-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
        elseif GetResourceState("qbx-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
        elseif GetResourceState('MrNewbVehicleKeys') == 'started' then
            exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
        else
            if Config.Framework == "qb" or Config.Framework == "oldqb" then
                TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
            else
                print("No vehicle key system found")
            end
        end
    end
end

Config.SetVehicleFuel     = function(vehicle) -- you can change LegacyFuel export if you use another fuel system
    if GetResourceState("LegacyFuel") == "started" then
        return exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
    elseif GetResourceState("x-fuel") == "started" then
        return exports["x-fuel"]:SetFuel(vehicle, 100.0)
    elseif GetResourceState("ox_fuel") == "started" then
        return SetVehicleFuelLevel(vehicle, 100.0)
    elseif GetResourceState("cdn-fuel") == "started" then
        return exports['cdn-fuel']:SetFuel(vehicle, 100.0)
    elseif GetResourceState("ps-fuel") == "started" then
        return exports['ps-fuel']:SetFuel(vehicle, 100.0)
    elseif GetResourceState("lc_fuel") == "started" then
        exports["lc_fuel"]:SetFuel(vehicle, 100)
    else
        return SetVehicleFuelLevel(vehicle, 100.0)
    end
end

Config.RefreshSkin        = function()
    if Config.ChangeClothesSystem then
        if Config.ChangeClothesSystem then
            if Config.ClothingScript == 'fivem-appearance' then
                -- wasabi-fivem-appearance
                Core.TriggerServerCallback('esx_skin:getPlayerSkin', function(appearance)
                    exports['fivem-appearance']:setPlayerAppearance(appearance)
                end)

                --normal fivem-appearance
                -- TriggerEvent("fivem-appearance:client:reloadSkin")
            end
            if Config.ClothingScript == 'illenium-appearance' then
                TriggerEvent("illenium-appearance:client:reloadSkin")
            end
            if Config.ClothingScript == 'esx_skin' then
                TriggerEvent("esx_skin:getLastSkin", function(lastSkin)
                    TriggerEvent('skinchanger:loadSkin', lastSkin)
                end)
            end
            if Config.ClothingScript == 'qb-clothing' then
                TriggerEvent("qb-clothing:reloadSkin")
                --[[
                    // Add this code in qb-clothing client/main.lua

                    RegisterNetEvent("qb-clothing:reloadSkin")
                    AddEventHandler("qb-clothing:reloadSkin", function()
                        local playerPed = PlayerPedId()
                        local health = GetEntityHealth(playerPed)
                        reloadSkin(health)
                    end)
                --]]
                ExecuteCommand('refreshskin')
            end
            if Config.ClothingScript == 'rcore_clothing' then
                TriggerServerEvent('rcore_clothing:reloadSkin')
            end
        end
    end
end

Config.sendNotification   = function(messageData)
    local message, messageType
    if type(messageData) == "table" then
        message = messageData.text
        messageType = messageData.type
    elseif type(messageData) == "string" then
        for key, value in pairs(Config.NotificationText) do
            if value.text == messageData then
                message = value.text
                messageType = value.type
                break
            end
        end

        if not message then
            message = messageData
            messageType = "info"
        end
    end

    NuiMessage('NOTIFICATION', { message = message, type = messageType })
end

-- This function is called for each player in the lobby before starting the job
-- Return true to allow the player to start, false to prevent
-- @param source: Player's server ID
-- @param owneridentifier: Player's identifier (license/steam/etc)
Config.startJobFunction   = function(source, owneridentifier)
    -- Example: Check if player has specific job
    -- local Player = GetPlayer(source)
    -- if Player and Player.job and Player.job.name == "mechanic" then
    --     return true
    -- end
    -- return false

    return true -- Default: Allow everyone
end
Config.endJobFunction     = function(source, owneridentifier, scoreAmount)
end

Config.NotificationText   = {
    ['vehicleexist'] = {
        text = Locales[Config.Locale]['vehicleexist'],
        type = "error"
    },
    ['wrongjob'] = {
        text = Locales[Config.Locale]['wrongjob'],
        type = "error"
    },
    ['jobcooldown'] = {
        text = Locales[Config.Locale]['jobcooldown'],
        type = "error"
    },
    ['delivervehicle'] = {
        text = Locales[Config.Locale]['delivervehicle'],
        type = "info"
    },
    ['playerfaraway'] = {
        text = Locales[Config.Locale]['playerfaraway'],
        type = "info"
    },
    ['lobbyfull'] = {
        text = Locales[Config.Locale]['lobbyfull'],
        type = "success"
    },
    ['jobnotstarted'] = {
        text = Locales[Config.Locale]['jobnotstarted'],
        type = "error"
    },
    ['jobalreadystarted'] = {
        text = Locales[Config.Locale]['jobalreadystarted'],
        type = "error"
    },
    ['maxlevel'] = {
        text = Locales[Config.Locale]['maxlevel'],
        type = "error"
    },
    ['joblevelnotenough'] = {
        text = Locales[Config.Locale]['joblevelnotenough'],
        type = "error"
    },
    ['playeralreadyinlobby'] = {
        text = Locales[Config.Locale]['playeralreadyinlobby'],
        type = "error"
    },

    ['missionnotselected'] = {
        text = Locales[Config.Locale]['missionnotselected'],
        type = "error"
    },
    ['playerleftlobby'] = {
        text = Locales[Config.Locale]['playerleftlobby'],
        type = "error"
    },
    ['deliverVehile'] = {
        text = Locales[Config.Locale]['deliverVehile'],
        type = "info"
    },
    ['resetJob'] = {
        text = Locales[Config.Locale]['resetJob'],
        type = "error"
    },
    ['notowner'] = {
        text = Locales[Config.Locale]['notowner'],
        type = "error"
    },
    ['usedtbxid'] = {
        text = Locales[Config.Locale]['usedtbxid'],
        type = "error"
    },
    ['successfullyExp'] = {
        text = Locales[Config.Locale]['successfullyExp'],
        type = "success"
    },
    ['notfoundtbxid'] = {
        text = Locales[Config.Locale]['notfoundtbxid'],
        type = "error"
    },
    ['getontruck'] = {
        text = Locales[Config.Locale]['getontruck'],
        type = "info"
    },
    ['alreadyarea'] = {
        text = Locales[Config.Locale]['alreadyarea'],
        type = "error"
    },
    ['alreadyHaveItem'] = {
        text = Locales[Config.Locale]['alreadyHaveItem'],
        type = "error"
    },
    ['isownernotleave'] = {
        text = Locales[Config.Locale]['isownernotleave'],
        type = "error"
    },
    ['bonusjobtask'] = {
        text = Locales[Config.Locale]['bonusjobtask'],
        type = "success"
    },
    ['invehicle'] = {
        text = Locales[Config.Locale]['invehicle'],
        type = "error"
    },

    ['cantentervehicle'] = {
        text = Locales[Config.Locale]['cantentervehicle'],
        type = "error"
    },
    ['settingssaved'] = {
        text = Locales[Config.Locale]['settingssaved'],
        type = "success"
    },

    ['allcoordsoccupied'] = {
        text = Locales[Config.Locale]['allcoordsoccupied'],
        type = "error"
    },

    -- Mıssion 1
    ['cleanedDumster'] = {
        text = Locales[Config.Locale]['cleanedDumster'],
        type = "success"
    },

    -- Mıssion 2
    ['cleanedBag'] = {
        text = Locales[Config.Locale]['cleanedBag'],
        type = "success"
    },

    -- Mıssion 3
    ['cleanedTrash'] = {
        text = Locales[Config.Locale]['cleanedTrash'],
        type = "success"
    },

    -- Mıssion 4
    ['convertedBale'] = {
        text = Locales[Config.Locale]['convertedBale'],
        type = "success"
    },

    -- Mıssion 5
    ['convertedTrash'] = {
        text = Locales[Config.Locale]['convertedTrash'],
        type = "success"
    },

    -- Mıssion 6
}

Config.RequiredXP         = {
    [1] = 1000,
    [2] = 1500,
    [3] = 2000,
    [4] = 2500,
    [5] = 3000,
    [6] = 3500,
    [7] = 4000,
    [8] = 4500,
    [9] = 5000,
    [10] = 5500,
    [11] = 6000,
    [12] = 6500,
    [13] = 7000,
    [14] = 7500,
    [15] = 8000,
    [16] = 8500,
    [17] = 9000,
    [18] = 9500,
    [19] = 10000,
    [20] = 10500,
    [21] = 11000,
    [22] = 11500,
    [23] = 12000,
    [24] = 12500,
    [25] = 13000,
    [26] = 13500,
    [27] = 14000,
    [28] = 14500,
    [29] = 15000,
    [30] = 15500,
    [31] = 16000,
    [32] = 16500,
    [33] = 17000,
    [34] = 17500,
    [35] = 18000,
    [36] = 18500,
    [37] = 19000,
    [38] = 19500,
    [39] = 20000,
    [40] = 20500,
    [41] = 21000,
    [42] = 21500,
    [43] = 22000,
    [44] = 22500,
    [45] = 23000,
    [46] = 23500,
    [47] = 24000,
    [48] = 24500,
    [49] = 25000,
    [50] = 25500,
    [51] = 26500,
    [52] = 27500,
    [53] = 28500,
    [54] = 29500,
    [55] = 30500,
    [56] = 31500,
    [57] = 32500,
    [58] = 33500,
    [59] = 34500,
    [60] = 35500,
    [61] = 36500,
    [62] = 37500,
    [63] = 38500,
    [64] = 39500,
    [65] = 40500,
    [66] = 41500,
    [67] = 42500,
    [68] = 43500,
    [69] = 44500,
    [70] = 45500,

}

Config.LanguageTitle      = {
    { value = 'en', label = 'English' },
    { value = 'tr', label = 'Turkish' },
    { value = 'ar', label = 'Arabic' },
    { value = 'de', label = 'German' },
    { value = 'fr', label = 'French' },
    { value = 'pt', label = 'Portuguese' },
    { value = 'ru', label = 'Russian' },
}
