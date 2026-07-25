local ESX = exports.es_extended:getSharedObject()

local spawnedProps = {}
local coordinateZones = {}
local locationsById = {}
local recipeDescriptions = {}
local locationsReady = false

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'inform' })
end

local function buildRecipeDescription(recipe)
    local parts = { ('⏱ %ds'):format(recipe.duration) }
    local ingredients = recipe.ingredients

    for i = 1, #ingredients do
        local ing = ingredients[i]
        if ing.name == 'money' then
            parts[#parts + 1] = ('💵 $%s'):format(lib.math.groupdigits(ing.count))
        else
            parts[#parts + 1] = ('%s x%d'):format(ing.label, ing.count)
        end
    end

    return table.concat(parts, ' | ')
end

local function getPlayerJob()
    local data = ESX.GetPlayerData()
    return data and data.job
end

local function canAccessLocation(location)
    local job = getPlayerJob()
    if not job then return false end

    local required = location.job
    if required and required ~= 'all' and job.name ~= required then
        return false
    end

    local minGrade = location.minGrade or 0
    return (job.grade or 0) >= minGrade
end

local function canAccessItem(playerGrade, entry)
    if not entry then return false end

    local grades = entry.grades
    if grades then
        for i = 1, #grades do
            if grades[i] == playerGrade then
                return true
            end
        end
        return false
    end

    return playerGrade >= (entry.minGrade or 0)
end

local function startMoneyPurchase(locationId, moneyItemIndex)
    if lib.progressActive() then return end

    local location = locationsById[locationId]
    local moneyItem = location and location.moneyItems and location.moneyItems[moneyItemIndex]
    if not moneyItem then return end

    lib.callback('jamaica-crafting:canBuy', false, function(canBuy, message)
        if not canBuy then
            notify(message or 'Ne možete kupiti ovaj predmet.', 'error')
            return
        end

        local outputLabel = moneyItem.count > 1
            and ('%s x%d'):format(moneyItem.label, moneyItem.count)
            or moneyItem.label

        local completed = lib.progressBar({
            duration = 2000,
            label = ('Kupovina: %s'):format(outputLabel),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
        })

        if not completed then
            notify('Prekinuli ste kupovinu.', 'error')
            return
        end

        lib.callback('jamaica-crafting:buy', false, function(result)
            result = result or {}

            if result.ok then
                notify(result.message or 'Uspešno kupljeno!', 'success')
            elseif result.message then
                notify(result.message, 'error')
            end
        end, locationId, moneyItemIndex)
    end, locationId, moneyItemIndex)
end

local function startCraft(locationId, recipeIndex)
    if lib.progressActive() then return end

    local location = locationsById[locationId]
    local recipe = location and location.items and location.items[recipeIndex]
    if not recipe then return end

    lib.callback('jamaica-crafting:canCraft', false, function(canCraft, message)
        if not canCraft then
            notify(message or 'Nemate dovoljno materijala.', 'error')
            return
        end

        local completed = lib.progressBar({
            duration = recipe.duration * 1000,
            label = ('Kraftanje: %s'):format(recipe.label),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_player',
                flag = 1,
            },
        })

        if not completed then
            notify('Prekinuli ste kraftanje.', 'error')
            return
        end

        lib.callback('jamaica-crafting:craft', false, function(result)
            result = result or {}

            if result.ok then
                notify(result.message or 'Uspešno iskraftano!', 'success')
            elseif result.message then
                notify(result.message, 'error')
            end
        end, locationId, recipeIndex)
    end, locationId, recipeIndex)
end

local function openCraftMenu(locationId)
    if lib.progressActive() then return end

    local location = locationsById[locationId]
    if not location then return end

    if not canAccessLocation(location) then
        notify('Nemate pristup crafting oružja.', 'error')
        return
    end

    local job = getPlayerJob()
    local playerGrade = job and (job.grade or 0) or 0
    local options = {}
    local items = location.items or {}

    for i = 1, #items do
        local recipe = items[i]
        if canAccessItem(playerGrade, recipe) then
            local outputLabel = recipe.count > 1
                and ('%s x%d'):format(recipe.label, recipe.count)
                or recipe.label

            options[#options + 1] = {
                title = outputLabel,
                description = recipeDescriptions[locationId .. '_' .. i],
                icon = 'hammer',
                onSelect = function()
                    startCraft(locationId, i)
                end,
            }
        end
    end

    local moneyItems = location.moneyItems or {}
    for i = 1, #moneyItems do
        local moneyItem = moneyItems[i]
        if canAccessItem(playerGrade, moneyItem) then
            local outputLabel = moneyItem.count > 1
                and ('%s x%d'):format(moneyItem.label, moneyItem.count)
                or moneyItem.label

            options[#options + 1] = {
                title = outputLabel,
                description = ('💵 $%s'):format(lib.math.groupdigits(moneyItem.price)),
                icon = 'dollar-sign',
                onSelect = function()
                    startMoneyPurchase(locationId, i)
                end,
            }
        end
    end

    if #options == 0 then return end

    lib.registerContext({
        id = 'jamaica_crafting_' .. locationId,
        title = '🔧 | ' .. location.label,
        options = options,
    })
    lib.showContext('jamaica_crafting_' .. locationId)
end

local function hasLocationProp(location)
    local prop = location.prop
    return type(prop) == 'string' and prop ~= ''
end

local function getLocationTargetOptions(location, targetName)
    return {
        {
            name = targetName,
            icon = 'fa-solid fa-hammer',
            label = location.label,
            distance = Config.TargetDistance,
            canInteract = function()
                return canAccessLocation(location)
            end,
            onSelect = function()
                openCraftMenu(location.id)
            end,
        },
    }
end

local function kreirajObjekat(model, coords)
    if not model or not coords then return end

    local modelHash = type(model) == 'string' and GetHashKey(model) or model
    lib.requestModel(model)

    local obj = CreateObject(modelHash, vector3(coords.x, coords.y, coords.z - 1), false, true)
    SetEntityHeading(obj, coords.w)
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)
    SetModelAsNoLongerNeeded(modelHash)

    return obj
end

local function cleanupLocations()
    for locationId, entry in pairs(spawnedProps) do
        if entry and entry.entity and DoesEntityExist(entry.entity) then
            if GetResourceState('ox_target') == 'started' and entry.target then
                exports.ox_target:removeLocalEntity(entry.entity, entry.target)
            end
            DeleteObject(entry.entity)
        end
        spawnedProps[locationId] = nil
    end

    for locationId in pairs(coordinateZones) do
        if GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeZone('jamaica_crafting_zone_' .. locationId)
        end
        coordinateZones[locationId] = nil
    end
end

local function setupLocations()
    cleanupLocations()

    local list = Config.Locations
    if not list then return end

    for i = 1, #list do
        local location = list[i]
        if location and location.coords then
            locationsById[location.id] = location

            if not locationsReady then
                for j = 1, #(location.items or {}) do
                    recipeDescriptions[location.id .. '_' .. j] = buildRecipeDescription(location.items[j])
                end
            end

            if hasLocationProp(location) then
                local prop = kreirajObjekat(location.prop, location.coords)
                local targetName = 'jamaica_crafting_' .. location.id
                spawnedProps[location.id] = { entity = prop, target = targetName }
                exports.ox_target:addLocalEntity(prop, getLocationTargetOptions(location, targetName))
            else
                local c = location.coords
                coordinateZones[location.id] = exports.ox_target:addSphereZone({
                    name = 'jamaica_crafting_zone_' .. location.id,
                    coords = vec3(c.x, c.y, c.z),
                    radius = Config.CraftDistance,
                    options = getLocationTargetOptions(location, 'jamaica_crafting_' .. location.id),
                })
            end
        end
    end

    locationsReady = true
end

CreateThread(function()
    setupLocations()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cleanupLocations()
end)
