local stockCache = {}

local function notify(msg, ntype)
    lib.notify({ title = 'Restoran', description = msg, type = ntype or 'inform', position = 'right-center' })
end

local function itemImage(itemName)
    return (Config.ImagePath or 'nui://ox_inventory/web/images/%s.png'):format(itemName)
end

local function filterItems(items, category)
    if not category then return items end
    local out = {}
    for i = 1, #items do
        if items[i].category == category then
            out[#out + 1] = items[i]
        end
    end
    return out
end

local function restockItem(restoranId, item, maxStock)
    local current = item.stock or 0
    local room = math.max(0, (maxStock or 200) - current)
    if room < 1 then
        notify('Stock je pun za ovaj artikal.', 'error')
        return
    end

    local input = lib.inputDialog(('Ubaci — %s'):format(item.label), {
        {
            type = 'slider',
            label = ('Količina (stock: %d / %d)'):format(current, maxStock or 200),
            min = 1,
            max = math.min(100, room),
            step = 1,
            default = 1,
        },
    })
    if not input then return end

    local qty = math.floor(tonumber(input[1]) or 0)
    if qty < 1 then return end

    TriggerServerEvent('jamaica-restoran:restock', {
        restoranId = restoranId,
        itemId = item.id,
        quantity = qty,
    })
end

local function buildRestockOptions(restoranId, items, maxStock)
    local options = {}
    for i = 1, #items do
        local it = items[i]
        local img = itemImage(it.item)
        local stock = it.stock or 0
        local cap = maxStock or 200
        options[#options + 1] = {
            title = it.label,
            description = ('Stock: %d / %d'):format(stock, cap),
            icon = img,
            image = img,
            arrow = stock < cap,
            disabled = stock >= cap,
            onSelect = stock < cap and function()
                restockItem(restoranId, it, cap)
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

local function openRestockCategory(restoranId, categoryId, categoryLabel, maxStock)
    local data = stockCache[restoranId]
    if not data then return end

    local items = filterItems(data.items, categoryId)
    local menuId = ('jamaica_restoran_stock_%s_%s'):format(restoranId, categoryId)

    lib.registerContext({
        id = menuId,
        title = ('Ubaci zalihe — %s'):format(categoryLabel),
        menu = 'jamaica_restoran_stock_' .. restoranId,
        options = buildRestockOptions(restoranId, items, maxStock),
    })
    lib.showContext(menuId)
end

function OpenRestoranStockMenu(restoranId)
    local data = lib.callback.await('jamaica-restoran:getRestockData', false, restoranId)
    if not data then
        notify('Nemaš pristup ubacivanju zaliha.', 'error')
        return
    end
    if not data.items or #data.items < 1 then
        notify('Nema artikala za stock.', 'error')
        return
    end

    stockCache[restoranId] = data
    local maxStock = data.maxStock or Config.MaxStock or 200
    local rootId = 'jamaica_restoran_stock_' .. restoranId
    local options = {
        {
            title = ('Maks. stock po artiklu: %d'):format(maxStock),
            icon = 'boxes-stacked',
            disabled = true,
        },
    }

    local categories = data.categories or Config.Categories or {}
    for i = 1, #categories do
        local cat = categories[i]
        if cat.id == 'hrana' or cat.id == 'pice' then
            local count = #filterItems(data.items, cat.id)
            options[#options + 1] = {
                title = cat.label,
                description = count > 0 and ('%d artikala'):format(count) or 'Nema artikala',
                icon = cat.id == 'pice' and 'wine-glass' or 'burger',
                arrow = count > 0,
                disabled = count < 1,
                onSelect = count > 0 and function()
                    openRestockCategory(restoranId, cat.id, cat.label, maxStock)
                end or nil,
            }
        end
    end

    lib.registerContext({
        id = rootId,
        title = ('Ubaci zalihe — %s'):format(data.label or 'Restoran'),
        options = options,
    })
    lib.showContext(rootId)
end
