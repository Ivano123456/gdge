local ESX = exports.es_extended:getSharedObject()

local uiOpen = false
local shopBlips = {}
local shopPedEntities = {}
local shopZonesActive = {}

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'inform' })
end

local function closeUi()
    if not uiOpen then return end
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openShop(shopId, shopData)
    if uiOpen then return end

    ESX.TriggerServerCallback('jamaica-oruzarnice:getShopData', function(data)
        if not data then
            notify('Oružarnica trenutno nije dostupna.', 'error')
            return
        end

        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            shopId = shopId,
            shopLabel = shopData.label,
            categories = data.categories or Config.Categories,
            items = data.items or {},
            hasLicense = data.hasLicense,
            cash = data.cash,
            bank = data.bank,
        })
    end)
end

RegisterNUICallback('close', function(_, cb)
    closeUi()
    cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
    if not data or not data.itemId then
        cb({ ok = false })
        return
    end

    ESX.TriggerServerCallback('jamaica-oruzarnice:purchase', function(result)
        if result and result.ok then
            SendNUIMessage({
                action = 'updateMoney',
                cash = result.cash,
                bank = result.bank,
            })
        end
        cb(result or { ok = false })
    end, {
        itemId = data.itemId,
        quantity = data.quantity,
        payment = data.payment,
    })
end)

local function getShopPedModel(shop)
    local model = shop.pedModel or `s_m_y_ammucity_01`
    if type(model) == 'string' then model = joaat(model) end
    return model
end

local function deleteShopPed(id)
    local ped = shopPedEntities[id]
    if ped and DoesEntityExist(ped) then
        DeletePed(ped)
    end
    shopPedEntities[id] = nil
end

local function spawnShopPed(id, shop)
    if shopPedEntities[id] and DoesEntityExist(shopPedEntities[id]) then return end

    local c = shop.ped
    if not c then return end

    local model = getShopPedModel(shop)
    if not IsModelInCdimage(model) or not IsModelValid(model) then return end

    lib.requestModel(model)

    local ped = CreatePed(0, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    SetModelAsNoLongerNeeded(model)
    if not DoesEntityExist(ped) then return end

    SetEntityAlpha(ped, 0, false)
    Wait(50)
    SetEntityAlpha(ped, 255, false)
    SetPedFleeAttributes(ped, 2)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedDiesWhenInjured(ped, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetPedCanPlayAmbientAnims(ped, false)

    shopPedEntities[id] = ped
end

local function shopPedTargetId(entity)
    for id, ped in pairs(shopPedEntities) do
        if ped == entity and shopZonesActive[id] then
            return id
        end
    end
    return nil
end

local function setupShopLocations()
    local pedModels = {}
    local zoneRadius = 50.0
    local targetDist = Config.TargetDistance or 2.5

    for shopId, shop in pairs(Config.Shops) do
        local c = shop.ped
        if c then
            pedModels[getShopPedModel(shop)] = true

            lib.zones.sphere({
                coords = vector3(c.x, c.y, c.z),
                radius = zoneRadius,
                onEnter = function()
                    shopZonesActive[shopId] = true
                    spawnShopPed(shopId, shop)
                end,
                onExit = function()
                    shopZonesActive[shopId] = nil
                    deleteShopPed(shopId)
                end,
            })
        end

        if shop.blip and shop.ped then
            local b = shop.blip
            local blip = AddBlipForCoord(shop.ped.x, shop.ped.y, shop.ped.z)
            SetBlipSprite(blip, b.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, b.scale)
            SetBlipColour(blip, b.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(b.label)
            EndTextCommandSetBlipName(blip)
            shopBlips[shopId] = blip
        end
    end

    if GetResourceState('ox_target') ~= 'started' then return end

    local models = {}
    for model in pairs(pedModels) do
        models[#models + 1] = model
    end
    if #models < 1 then return end

    exports.ox_target:addModel(models, {
        {
            name = 'jamaica_oruzarnica_open',
            icon = 'fa-solid fa-gun',
            label = 'Otvori oružarnicu',
            distance = targetDist,
            canInteract = function(entity)
                return shopPedTargetId(entity) ~= nil
            end,
            onSelect = function(data)
                local shopId = shopPedTargetId(data.entity)
                if shopId then
                    openShop(shopId, Config.Shops[shopId])
                end
            end,
        },
    })
end

local function cleanupShops()
    for id, _ in pairs(shopPedEntities) do
        deleteShopPed(id)
    end
    shopZonesActive = {}

    for _, blip in pairs(shopBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    shopBlips = {}

    if GetResourceState('ox_target') == 'started' then
        local pedModels = {}
        for _, shop in pairs(Config.Shops) do
            if shop.ped then
                pedModels[getShopPedModel(shop)] = true
            end
        end
        local modelList = {}
        for model in pairs(pedModels) do
            modelList[#modelList + 1] = model
        end
        if #modelList > 0 then
            exports.ox_target:removeModel(modelList, { 'jamaica_oruzarnica_open' })
        end
    end
end

CreateThread(function()
    setupShopLocations()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    closeUi()
    cleanupShops()
end)
