local isShopOpen = false
local isRestockOpen = false
local currentShopId = nil

local R_BIZ_DRAW_SQ = 64.0
local R_BIZ_USE_SQ = 2.25

local ownerPoints = {}

local function distSq(px, py, pz, x, y, z)
    local dx, dy, dz = px - x, py - y, pz - z
    return dx * dx + dy * dy + dz * dz
end

local function getKes(shopId)
    local kes = GlobalState.ShopVlasnici
    if not kes then return nil end
    return kes[shopId] or kes[tostring(shopId)]
end

local function Draw3DText(x, y, z, text)
    local cam = GetGameplayCamCoords()
    local dx, dy, dz = x - cam.x, y - cam.y, z - cam.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
    if dist > 25.0 then return end
    SetTextScale(0.0, 0.55 * ((1 / dist) * 2) * ((1 / GetGameplayCamFov()) * 100))
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    SetTextCentre(1)
    SetDrawOrigin(x, y, z, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

for shopId, shop in ipairs(Config.Shopovi) do
    local marker = shop.ownerMarker
    if marker then
        ownerPoints[#ownerPoints + 1] = {
            shopId = shopId,
            x = marker.x,
            y = marker.y,
            z = marker.z,
            label = shop.label or 'Market',
        }
    end
end

local function setUi(open)
    SetNuiFocus(open, open)
end

local function closeShop()
    isShopOpen = false
    currentShopId = nil
    setUi(false)
    SendNUIMessage({ akcija = 'zatvori' })
end

local function closeRestock()
    isRestockOpen = false
    currentShopId = nil
    setUi(false)
    SendNUIMessage({ akcija = 'zatvori_restock' })
end

local function openShop(shopId)
    local data = lib.callback.await('jamaica-shopovi:getShopData', false, shopId)
    if not data then
        lib.notify({ title = 'Greška', description = 'Prodavnica nije dostupna.', type = 'error', position = 'right-center' })
        return
    end
    isShopOpen = true
    currentShopId = shopId
    setUi(true)
    SendNUIMessage({ akcija = 'otvori_shop', data = data })
end

local function openRestock(shopId)
    local res = lib.callback.await('jamaica-shopovi:getRestockData', false, shopId)
    if not res or not res.ok then
        local reason = res and res.reason
        if reason == 'fixed' then
            lib.notify({
                title = 'Prodavnica',
                description = 'Ova prodavnica ima fiksnu zaradu — nema upravljanja stockom.',
                type = 'inform',
                position = 'right-center',
            })
        else
            lib.notify({
                title = 'Greška',
                description = 'Niste vlasnik ove prodavnice!',
                type = 'error',
                position = 'right-center',
            })
        end
        return
    end
    isRestockOpen = true
    currentShopId = shopId
    setUi(true)
    SendNUIMessage({ akcija = 'otvori_restock', data = res })
end

CreateThread(function()
    for shopId, shop in ipairs(Config.Shopovi) do
        exports.ox_target:addSphereZone({
            coords = shop.coords,
            radius = 1.5,
            options = {
                {
                    name = 'shop_' .. shopId,
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Otvori prodavnicu',
                    onSelect = function() openShop(shopId) end,
                },
            },
        })
        local b = shop.blip
        if b and b.aktiviraj then
            local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
            SetBlipSprite(blip, b.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, b.scale)
            SetBlipColour(blip, b.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(b.text)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

CreateThread(function()
    local bizHint = false
    while true do
        local sleep = 750
        if not isShopOpen and not isRestockOpen then
            local ped = cache.ped or PlayerPedId()
            local c = GetEntityCoords(ped)
            local px, py, pz = c.x, c.y, c.z
            local timer = GetGameTimer()
            local nearBiz = false
            local needDraw = false

            for i = 1, #ownerPoints do
                local p = ownerPoints[i]
                local d2 = distSq(px, py, pz, p.x, p.y, p.z)
                if d2 < R_BIZ_DRAW_SQ then
                    needDraw = true
                    local ks = getKes(p.shopId)
                    Draw3DText(p.x, p.y, p.z + 1.0, ('~w~%s'):format(ks and ks.label or p.label))
                    Draw3DText(p.x, p.y, p.z + 0.75, ('~g~Vlasnik: ~w~%s'):format(ks and ks.vlasnik or 'Nema vlasnika'))
                    if ks and ks.expiresAt then
                        Draw3DText(p.x, p.y, p.z + 0.5, ('~w~Zakup do: ~y~%s'):format(os.date('%d.%m.%Y', ks.expiresAt)))
                    end
                    local pulse = math.abs(math.sin(timer / 500.0)) * 0.2 + 0.4
                    DrawMarker(1, p.x, p.y, p.z - 0.99, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, pulse, pulse, 0.15, 34, 197, 94, 220, false, true, 2, false, false, false, false)

                    -- Fiksna zarada: bez [E] restock menija
                    if d2 <= R_BIZ_USE_SQ and ks and not ks.fixed then
                        nearBiz = true
                        if not bizHint then
                            lib.showTextUI('[E] - Upravljanje prodavnicom', { position = 'right-center' })
                            bizHint = true
                        end
                        if IsControlJustPressed(0, 38) then
                            bizHint = false
                            lib.hideTextUI()
                            openRestock(p.shopId)
                        end
                    end
                end
            end

            if bizHint and not nearBiz then
                lib.hideTextUI()
                bizHint = false
            end

            if needDraw then sleep = 0 end
        end
        Wait(sleep)
    end
end)

RegisterNUICallback('zatvori', function(_, cb) closeShop() cb('ok') end)
RegisterNUICallback('zatvori_restock', function(_, cb) closeRestock() cb('ok') end)
RegisterNUICallback('obavestenje', function(msg, cb)
    lib.notify({ title = 'Prodavnica', description = msg, type = 'inform', position = 'right-center' })
    cb('ok')
end)
RegisterNUICallback('Kupovina', function(data, cb)
    if not data or not currentShopId then cb('error') return end
    data.shopId = currentShopId
    TriggerServerEvent('jamaica-shopovi:kupovina', data)
    cb('ok')
end)
RegisterNUICallback('Restock', function(data, cb)
    if not data or not currentShopId then cb('error') return end
    data.shopId = currentShopId
    TriggerServerEvent('jamaica-shopovi:restock', data)
    cb('ok')
end)

RegisterNetEvent('jamaica-shopovi:purchaseDone', function(shopId, stockPatch)
    if isShopOpen and currentShopId == shopId then
        SendNUIMessage({ akcija = 'osvezi_stock', stocks = stockPatch })
    end
end)

RegisterNetEvent('jamaica-shopovi:restockDone', function(shopId, itemName, stock)
    if isRestockOpen and currentShopId == shopId then
        SendNUIMessage({ akcija = 'osvezi_restock_item', item = itemName, stock = stock })
    end
end)
