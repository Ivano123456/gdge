local ESX = exports.es_extended:getSharedObject()

local uiOpen = false
local shopPeds = {}

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'inform' })
end

local function closeUi()
    if not uiOpen then return end
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openShop(shop)
    if uiOpen then return end

    ESX.TriggerServerCallback('jamaica-apoteka:getShopData', function(data)
        if not data then
            notify('Apoteka trenutno nije dostupna.', 'error')
            return
        end

        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            shopLabel = shop.label,
            items = data.items,
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

    ESX.TriggerServerCallback('jamaica-apoteka:purchase', function(result)
        result = result or { ok = false }

        if result.ok then
            notify(result.message or 'Kupljeno!', 'success')
        elseif result.message then
            notify(result.message, 'error')
        end

        cb(result)
    end, data)
end)

local function spawnShopPed(shopId, shop)
    local model = shop.pedModel
    if not lib.requestModel(model, 5000) then return end

    local c = shop.ped
    local ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    SetModelAsNoLongerNeeded(model)

    if not DoesEntityExist(ped) then return end

    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'jamaica_apoteka_' .. shopId,
            icon = 'fa-solid fa-prescription-bottle-medical',
            label = 'Otvori apoteku',
            distance = Config.TargetDistance,
            onSelect = function()
                openShop(shop)
            end,
        },
    })

    shopPeds[shopId] = ped
end

CreateThread(function()
    for shopId, shop in pairs(Config.Shops) do
        local blipCfg = shop.blip
        if blipCfg then
            local c = shop.ped
            local blip = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(blip, blipCfg.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, blipCfg.scale)
            SetBlipColour(blip, blipCfg.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipCfg.label)
            EndTextCommandSetBlipName(blip)
        end

        spawnShopPed(shopId, shop)
        Wait(150)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    closeUi()

    for id, ped in pairs(shopPeds) do
        if DoesEntityExist(ped) then
            exports.ox_target:removeLocalEntity(ped, 'jamaica_apoteka_' .. id)
            DeleteEntity(ped)
        end
    end
end)
