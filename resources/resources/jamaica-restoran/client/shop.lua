local shopCache = {}

local function notify(msg, ntype)
    lib.notify({ title = 'Restoran', description = msg, type = ntype or 'inform', position = 'right-center' })
end

local function itemImage(itemName)
    return (Config.ImagePath or 'nui://ox_inventory/web/images/%s.png'):format(itemName)
end

local function formatMoney(amount)
    return '$' .. tostring(math.floor(tonumber(amount) or 0))
end

local function purchaseItem(restoranId, item)
    local stock = math.floor(tonumber(item.stock) or 0)
    if stock < 1 then
        notify('Artikal nije na stanju.', 'error')
        return
    end

    local input = lib.inputDialog(('Kupi — %s'):format(item.label), {
        { type = 'slider', label = 'Količina', min = 1, max = math.min(20, stock), step = 1, default = 1 },
        {
            type = 'select',
            label = 'Plaćanje',
            default = 'cash',
            options = {
                { value = 'cash', label = 'Keš' },
                { value = 'bank', label = 'Banka' },
            },
        },
    })
    if not input then return end

    local qty = math.floor(tonumber(input[1]) or 0)
    local payment = input[2]
    if qty < 1 or (payment ~= 'cash' and payment ~= 'bank') then return end

    TriggerServerEvent('jamaica-restoran:purchase', {
        restoranId = restoranId,
        payment = payment,
        items = {
            { itemId = item.id, quantity = qty, price = item.price },
        },
    })
end

local function buildItemOptions(restoranId, items)
    local options = {}
    for i = 1, #items do
        local it = items[i]
        local img = itemImage(it.item)
        local cat = Config.CategoryLabels[it.category] or it.category or ''
        local stock = math.floor(tonumber(it.stock) or 0)
        options[#options + 1] = {
            title = it.label,
            description = stock > 0
                and ('%s | %s | Stanje: %d'):format(formatMoney(it.price), cat, stock)
                or ('%s | %s | Nema na stanju'):format(formatMoney(it.price), cat),
            icon = img,
            image = img,
            arrow = stock > 0,
            disabled = stock < 1,
            onSelect = stock > 0 and function()
                purchaseItem(restoranId, it)
            end or nil,
        }
    end

    if #options < 1 then
        options[#options + 1] = {
            title = 'Nema artikala',
            icon = 'ban',
            disabled = true,
        }
    end

    return options
end

local function filterItems(items, category)
    if not category or category == 'sve' then return items end
    local out = {}
    for i = 1, #items do
        if items[i].category == category then
            out[#out + 1] = items[i]
        end
    end
    return out
end

local function countInStock(items, category)
    local filtered = filterItems(items, category)
    local n = 0
    for i = 1, #filtered do
        if (tonumber(filtered[i].stock) or 0) > 0 then
            n = n + 1
        end
    end
    return n
end

local function openCategoryMenu(restoranId, categoryId, categoryLabel)
    local data = shopCache[restoranId]
    if not data then return end

    local items = filterItems(data.items, categoryId)
    local menuId = ('jamaica_restoran_shop_%s_%s'):format(restoranId, categoryId)

    lib.registerContext({
        id = menuId,
        title = ('%s — %s'):format(data.label, categoryLabel),
        menu = 'jamaica_restoran_shop_' .. restoranId,
        options = buildItemOptions(restoranId, items),
    })
    lib.showContext(menuId)
end

function OpenRestoranShop(restoranId)
    local data = lib.callback.await('jamaica-restoran:getShopData', false, restoranId)
    if not data then
        notify('Restoran nije dostupan.', 'error')
        return
    end
    if not data.items or #data.items < 1 then
        notify('Nema artikala u ponudi.', 'error')
        return
    end

    shopCache[restoranId] = data
    local rootId = 'jamaica_restoran_shop_' .. restoranId
    local options = {
        {
            title = ('Keš: %s | Banka: %s'):format(formatMoney(data.cash or 0), formatMoney(data.bank or 0)),
            icon = 'wallet',
            disabled = true,
        },
    }

    local categories = data.categories or Config.Categories or {}
    for i = 1, #categories do
        local cat = categories[i]
        if cat.id == 'hrana' or cat.id == 'pice' then
            local count = countInStock(data.items, cat.id)
            options[#options + 1] = {
                title = cat.label,
                description = count > 0 and ('%d na stanju'):format(count) or 'Nema na stanju',
                icon = cat.id == 'pice' and 'wine-glass' or 'burger',
                arrow = count > 0,
                disabled = count < 1,
                onSelect = count > 0 and function()
                    openCategoryMenu(restoranId, cat.id, cat.label)
                end or nil,
            }
        end
    end

    lib.registerContext({
        id = rootId,
        title = data.label or 'Restoran',
        options = options,
    })
    lib.showContext(rootId)
end
