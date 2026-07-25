local spawnedPeds = {}
local sellLocationsById = {}

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'inform' })
end

local function getItemCount(item)
    local count = exports.ox_inventory:Search('count', item)
    if type(count) == 'number' then return count end
    return 0
end

local function startSell(locationId, itemName, amount)
    if lib.progressActive() then return end

    local location = sellLocationsById[locationId]
    if not location then return end

    local completed = lib.progressBar({
        duration = 2000,
        label = 'Prodaja ukradenog nakita...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'mp_common',
            clip = 'givetake1_a',
            flag = 49,
        },
    })

    if not completed then
        notify('Prekinuli ste prodaju.', 'error')
        return
    end

    lib.callback('jamaica-crafting:sell', false, function(result)
        result = result or {}

        if result.ok then
            notify(result.message or 'Uspesno prodato!', 'success')
        elseif result.message then
            notify(result.message, 'error')
        end
    end, locationId, itemName, amount)
end

local function openSellMenu(locationId)
    local location = sellLocationsById[locationId]
    if not location then return end

    local options = {}
    local totalItems = 0
    local totalValue = 0

    for i = 1, #location.items do
        local entry = location.items[i]
        local count = getItemCount(entry.item)

        if count > 0 then
            local value = entry.price * count
            totalItems = totalItems + count
            totalValue = totalValue + value

            options[#options + 1] = {
                title = ('%s x%d'):format(entry.label, count),
                description = ('$%s po komadu | Ukupno: $%s'):format(
                    lib.math.groupdigits(entry.price),
                    lib.math.groupdigits(value)
                ),
                icon = 'gem',
                onSelect = function()
                    startSell(locationId, entry.item, count)
                end,
            }
        end
    end

    if #options == 0 then
        notify('Nemate nista za prodaju.', 'error')
        return
    end

    table.insert(options, 1, {
        title = 'Prodaj sve',
        description = ('%d predmeta | $%s prljavog novca'):format(
            totalItems,
            lib.math.groupdigits(totalValue)
        ),
        icon = 'sack-dollar',
        onSelect = function()
            startSell(locationId, 'all', 0)
        end,
    })

    lib.registerContext({
        id = 'jamaica_crafting_sell_' .. locationId,
        title = location.label,
        options = options,
    })

    lib.showContext('jamaica_crafting_sell_' .. locationId)
end

local function spawnSellPed(location)
    if spawnedPeds[location.id] then return end

    local model = joaat(location.ped or 's_m_y_dealer_01')
    if not lib.requestModel(model, 5000) then return end

    local c = location.coords
    local ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    if not DoesEntityExist(ped) then
        SetModelAsNoLongerNeeded(model)
        return
    end

    SetEntityHeading(ped, c.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    if location.scenario then
        TaskStartScenarioInPlace(ped, location.scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)
    spawnedPeds[location.id] = ped

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'jamaica_crafting_sell_' .. location.id,
            icon = 'fa-solid fa-sack-dollar',
            label = 'Prodaj stvari',
            distance = location.distance or Config.TargetDistance,
            onSelect = function()
                openSellMenu(location.id)
            end,
        },
    })
end

CreateThread(function()
    local sellLocations = Config.SellLocations or {}

    for i = 1, #sellLocations do
        local location = sellLocations[i]
        sellLocationsById[location.id] = location
        spawnSellPed(location)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for locationId, ped in pairs(spawnedPeds) do
        if ped and DoesEntityExist(ped) then
            exports.ox_target:removeLocalEntity(ped)
            DeleteEntity(ped)
        end
        spawnedPeds[locationId] = nil
    end
end)
