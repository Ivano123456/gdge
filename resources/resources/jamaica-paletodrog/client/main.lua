ESX = exports['es_extended']:getSharedObject()

local isCollecting = false
local spawnedProps = {}
local collectedProps = {}
local insideZone = {}
local zoneStatus = {}

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function IsDeadCheck()
    local ped = PlayerPedId()
    return IsEntityDead(ped) or IsPedFatallyInjured(ped) or GetEntityHealth(ped) <= 0
end

local function GetRandomSpawnCoord(zoneData)
    local center = zoneData.coords
    local spawnRadius = zoneData.spawnRadius or zoneData.radius or 50.0
    local angle = math.random() * 2.0 * math.pi
    local dist = math.sqrt(math.random()) * spawnRadius
    local x = center.x + dist * math.cos(angle)
    local y = center.y + dist * math.sin(angle)
    local z = center.z
    local found, groundZ = GetGroundZFor_3dCoord(x, y, center.z + 50.0, false)
    if found then
        z = groundZ
    end
    return vector3(x, y, z)
end

local function CreatePropAtCoord(hash, coord)
    local prop = CreateObject(hash, coord.x, coord.y, coord.z - 1.0, false, false, false)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    SetEntityAsMissionEntity(prop, true, true)
    return prop
end

local function SpawnZoneProps(zoneName, zoneData)
    if spawnedProps[zoneName] then return end
    spawnedProps[zoneName] = {}

    local drugType = zoneData.drugType
    local propModel = Config.Items[drugType].prop
    local hash = GetHashKey(propModel)
    local count = zoneData.propCount or 10

    lib.requestModel(hash)

    for i = 1, count do
        local propKey = zoneName .. '_' .. i
        if not collectedProps[propKey] then
            local coord = GetRandomSpawnCoord(zoneData)
            local prop = CreatePropAtCoord(hash, coord)
            spawnedProps[zoneName][i] = { entity = prop, coord = coord }
        end
    end

    SetModelAsNoLongerNeeded(hash)
end

local function RemoveZoneProps(zoneName)
    if not spawnedProps[zoneName] then return end
    for _, data in pairs(spawnedProps[zoneName]) do
        if data.entity and DoesEntityExist(data.entity) then
            DeleteEntity(data.entity)
        end
    end
    spawnedProps[zoneName] = nil
end

local function RespawnSingleProp(zoneName, zoneData, propIndex)
    local propKey = zoneName .. '_' .. propIndex
    collectedProps[propKey] = nil

    if not spawnedProps[zoneName] then return end

    local drugConfig = Config.Items[zoneData.drugType]
    local hash = GetHashKey(drugConfig.prop)

    lib.requestModel(hash)

    local coord = GetRandomSpawnCoord(zoneData)
    local prop = CreatePropAtCoord(hash, coord)
    spawnedProps[zoneName][propIndex] = { entity = prop, coord = coord }

    SetModelAsNoLongerNeeded(hash)
end

local function CollectDrug(zoneName, zoneData, propIndex, propKey)
    if isCollecting or IsDeadCheck() then return end

    isCollecting = true

    local drugType = zoneData.drugType
    local drugConfig = Config.Items[drugType]

    local success = lib.progressCircle({
        duration = Config.CollectionTime,
        label = Lang(drugConfig.progressLabel),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = Config.AnimDict,
            clip = Config.AnimClip,
            flag = 49,
        },
    })

    if success then
        if spawnedProps[zoneName] and spawnedProps[zoneName][propIndex] then
            local propData = spawnedProps[zoneName][propIndex]
            if propData.entity and DoesEntityExist(propData.entity) then
                DeleteEntity(propData.entity)
            end
            spawnedProps[zoneName][propIndex] = nil
        end

        collectedProps[propKey] = true

        lib.callback.await('jamaica_paletodroge:collectDrug', false, drugType, zoneName)

        SetTimeout((drugConfig.respawnTime or 60) * 1000, function()
            RespawnSingleProp(zoneName, zoneData, propIndex)
        end)
    end

    isCollecting = false
end

RegisterNetEvent('jamaica_paletodroge:notify', function(msg, type)
    SendTextMessage(msg, type)
end)

RegisterNetEvent('jamaica_paletodroge:zoneStatus', function(zoneName, status)
    local oldStatus = zoneStatus[zoneName]
    zoneStatus[zoneName] = status

    if oldStatus ~= status then
        if status == 'bonus' and oldStatus ~= 'bonus' then
            SendTextMessage(Lang('ZONE_BONUS'), 'success')
        elseif oldStatus == 'bonus' and status ~= 'bonus' then
            SendTextMessage(Lang('ZONE_BONUS_OFF'), 'inform')
        end
    end
end)

for zoneName, zoneData in pairs(Config.CircleZones) do
    local circle = CircleZone:Create(zoneData.coords, zoneData.radius, {
        name = zoneName,
        useZ = true,
        debugPoly = false,
    })

    circle:onPlayerInOut(function(isInside, playerPos)
        if isInside then
            insideZone[zoneName] = true
            zoneStatus[zoneName] = 'free'
            SpawnZoneProps(zoneName, zoneData)

            lib.callback.await('jamaica_paletodroge:enterZone', false, zoneName)

            CreateThread(function()
                local wasDead = false
                while insideZone[zoneName] do
                    Wait(500)
                    local isDead = IsDeadCheck()
                    if isDead and not wasDead then
                        lib.callback.await('jamaica_paletodroge:playerDied', false, zoneName)
                    elseif not isDead and wasDead then
                        lib.callback.await('jamaica_paletodroge:enterZone', false, zoneName)
                    end
                    wasDead = isDead
                end
            end)

            CreateThread(function()
                while insideZone[zoneName] do
                    local sleep = 500
                    local playerCoords = GetEntityCoords(PlayerPedId())

                    if spawnedProps[zoneName] and not isCollecting then
                        local closestDist = 999.0
                        local closestIndex = nil

                        for i, propData in pairs(spawnedProps[zoneName]) do
                            if propData and propData.entity and DoesEntityExist(propData.entity) then
                                local propDist = #(playerCoords - propData.coord)
                                if propDist < closestDist then
                                    closestDist = propDist
                                    closestIndex = i
                                end
                            end
                        end

                        if closestIndex and closestDist < Config.InteractionDistance then
                            sleep = 0
                            local propData = spawnedProps[zoneName][closestIndex]
                            local drugType = zoneData.drugType
                            DrawText3D(propData.coord.x, propData.coord.y, propData.coord.z + 0.8, Lang(Config.Items[drugType].label))

                            if IsControlJustPressed(0, Keys[Config.FarmKey]) then
                                local propKey = zoneName .. '_' .. closestIndex
                                CollectDrug(zoneName, zoneData, closestIndex, propKey)
                            end
                        end
                    end

                    Wait(sleep)
                end
            end)
        else
            lib.callback.await('jamaica_paletodroge:exitZone', false, zoneName)

            insideZone[zoneName] = false
            zoneStatus[zoneName] = nil
            RemoveZoneProps(zoneName)
        end
    end, 500)
end

local dealerPed = nil

CreateThread(function()
    local d = Config.Dealer
    local hash = GetHashKey(d.model)

    lib.requestModel(hash)

    dealerPed = CreatePed(4, hash, d.coords.x, d.coords.y, d.coords.z - 1.0, d.heading, false, true)
    PlaceObjectOnGroundProperly(dealerPed)
    SetEntityHeading(dealerPed, d.heading)
    FreezeEntityPosition(dealerPed, true)
    SetEntityInvincible(dealerPed, true)
    SetBlockingOfNonTemporaryEvents(dealerPed, true)
    SetPedDiesWhenInjured(dealerPed, false)
    SetPedCanPlayAmbientAnims(dealerPed, true)
    SetModelAsNoLongerNeeded(hash)
end)

local isDealerMenuOpen = false

local function OpenDealerMenu()
    if isDealerMenuOpen then return end
    isDealerMenuOpen = true

    local d = Config.Dealer
    local drugNames = { cannabis = 'Cannabis', cocaine_list = 'Cocain List', meth = 'Meth' }
    local weaponNames = {
        WEAPON_APPISTOL = 'AP Pistol',
        WEAPON_PISTOL50 = 'Pistol .50',
        WEAPON_CARBINERIFLE = 'Carbine Rifle',
    }
    local options = {}

    for _, item in pairs(Config.Items) do
        local drugItem = item.itemname
        local name = drugNames[drugItem] or drugItem
        local override = d.sellPrices and d.sellPrices[drugItem]
        local priceLo = (override and override.min) or d.sellPriceMin
        local priceHi = (override and override.max) or d.sellPriceMax
        options[#options + 1] = {
            title = Lang('DEALER_SELL_TITLE'):format(name),
            description = ('Cijena: $%d-$%d po komadu'):format(priceLo, priceHi),
            icon = 'fas fa-money-bill',
            onSelect = function()
                lib.callback.await('jamaica_paletodroge:sellDrug', false, drugItem)
            end,
        }
    end


    for i, trade in ipairs(d.weaponTrades) do
        local name = drugNames[trade.drug] or trade.drug
        local wepName = weaponNames[trade.weapon] or trade.weapon
        options[#options + 1] = {
            title = Lang('DEALER_TRADE_TITLE'):format(trade.cost, name, wepName),
            description = Lang('DEALER_TRADE_DESC'):format(d.maxWeaponsPerDay),
            icon = 'fas fa-gun',
            onSelect = function()
                lib.callback.await('jamaica_paletodroge:tradeWeapon', false, i)
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_dealer_menu',
        title = 'Paleto Diler',
        onExit = function()
            isDealerMenuOpen = false
        end,
        options = options,
    })

    lib.showContext('jamaica_dealer_menu')
    isDealerMenuOpen = false
end

CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        local d = Config.Dealer
        local dist = #(playerCoords - d.coords)

        if dist < d.interactionDistance then
            sleep = 0
            DrawText3D(d.coords.x, d.coords.y, d.coords.z + 1.0, Lang('DEALER_3D'))

            if IsControlJustPressed(0, Keys['E']) and not isDealerMenuOpen then
                OpenDealerMenu()
            end
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for zoneName in pairs(spawnedProps) do
        RemoveZoneProps(zoneName)
    end
    if dealerPed and DoesEntityExist(dealerPed) then
        DeleteEntity(dealerPed)
    end
end)
