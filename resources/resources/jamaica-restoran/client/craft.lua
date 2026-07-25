local craftZones = {}
local craftPointHandles = {}

local function notify(msg, ntype)
    lib.notify({ title = 'Restoran', description = msg, type = ntype or 'inform', position = 'right-center' })
end

local function itemImage(path, item)
    local base = path or Config.ImagePath or 'nui://ox_inventory/web/images/%s.png'
    return base:format(item)
end

local function ingredientText(ingredients)
    local parts = {}
    for i = 1, #(ingredients or {}) do
        local ing = ingredients[i]
        parts[#parts + 1] = ('%s x%d'):format(ing.item, ing.amount)
    end
    return #parts > 0 and table.concat(parts, ', ') or '—'
end

local function categoryLabel(categoryId)
    for i = 1, #(Config.Categories or {}) do
        local cat = Config.Categories[i]
        if cat.id == categoryId then return cat.label end
    end
    return Config.CategoryLabels and Config.CategoryLabels[categoryId] or categoryId
end

local function craftDurationSec(craft)
    if craft and craft.duration then
        return math.floor(tonumber(craft.duration) or 6)
    end
    local category = craft and craft.category == 'pice' and 'pice' or 'hrana'
    local cfg = Config.DefaultCraftDuration
    if type(cfg) == 'table' then
        return math.floor(tonumber(cfg[category]) or tonumber(cfg.hrana) or 6)
    end
    return math.floor(tonumber(cfg) or 10)
end

local function startCraft(restoranId, craft)
    if lib.progressActive() then return end

    local canCraft, message = lib.callback.await('jamaica-restoran:canCraft', false, restoranId, craft.id)
    if not canCraft then
        notify(message or 'Ne možeš da craftaš.', 'error')
        return
    end

    local anim = craft.anim or {}
    local completed = lib.progressBar({
        duration = craftDurationSec(craft) * 1000,
        label = ('Priprema: %s'):format(craft.label),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = {
            dict = anim.dict or 'mini@repair',
            clip = anim.clip or 'fixing_a_player',
            flag = anim.flag or 49,
        },
    })

    if not completed then
        notify('Prekinuo si pripremu.', 'error')
        return
    end

    local result = lib.callback.await('jamaica-restoran:doCraft', false, restoranId, craft.id)
    if result and result.ok then
        notify(result.message or 'Uspešno iskraftano!', 'success')
    elseif result and result.message then
        notify(result.message, 'error')
    end
end

local function openCraftCategory(restoranId, data, categoryId, categoryLabelText)
    local options = {}
    local useRecipes = data.useRecipes == true
    for i = 1, #data.crafts do
        local c = data.crafts[i]
        if c.category == categoryId then
            local img = itemImage(data.imagePath, c.item)
            options[#options + 1] = {
                title = c.count > 1 and ('%s x%d'):format(c.label, c.count) or c.label,
                description = useRecipes
                    and ('%ds | %s'):format(c.duration, ingredientText(c.ingredients))
                    or ('%ds'):format(c.duration),
                icon = img,
                image = img,
                onSelect = function()
                    startCraft(restoranId, c)
                end,
            }
        end
    end

    if #options < 1 then
        options[#options + 1] = {
            title = useRecipes and 'Nema recepata' or 'Nema artikala u ponudi',
            icon = 'ban',
            disabled = true,
        }
    end

    local menuId = ('jamaica_restoran_craft_%s_%s'):format(restoranId, categoryId)
    lib.registerContext({
        id = menuId,
        title = ('%s — %s'):format(data.label, categoryLabelText),
        options = options,
    })
    lib.showContext(menuId)
end

function OpenRestoranCraftMenu(restoranId, categoryId)
    if lib.progressActive() then return end
    if categoryId ~= 'hrana' and categoryId ~= 'pice' then return end

    local data = lib.callback.await('jamaica-restoran:getCraftData', false, restoranId, categoryId)
    if not data then
        notify('Priprema nije dostupna ili nemaš pristup.', 'error')
        return
    end

    openCraftCategory(restoranId, data, categoryId, categoryLabel(categoryId))
end

local function removeCraftZone(zoneKey)
    if not craftZones[zoneKey] then return end
    exports.ox_target:removeZone(zoneKey)
    craftZones[zoneKey] = nil
end

local function addCraftZone(zoneKey, coords, label, icon, restoranId, categoryId, requiredJob)
    if craftZones[zoneKey] then return end

    exports.ox_target:addSphereZone({
        name = zoneKey,
        coords = vec3(coords.x, coords.y, coords.z),
        radius = Config.InteractDistance or 2.0,
        options = {
            {
                name = zoneKey .. '_open',
                icon = icon,
                label = label,
                distance = 2.5,
                canInteract = function()
                    local job = ESX.PlayerData and ESX.PlayerData.job
                    return job and job.name == requiredJob
                end,
                onSelect = function()
                    OpenRestoranCraftMenu(restoranId, categoryId)
                end,
            },
        },
    })
    craftZones[zoneKey] = true
end

local function removeCraftPoint(zoneKey)
    local handle = craftPointHandles[zoneKey]
    if not handle then return end
    removeCraftZone(zoneKey)
    if handle.point then handle.point:remove() end
    craftPointHandles[zoneKey] = nil
end

local function setupCraftPoint(zoneKey, coords, label, icon, restoranId, categoryId, requiredJob)
    removeCraftPoint(zoneKey)

    craftPointHandles[zoneKey] = {
        point = lib.points.new({
            coords = vec3(coords.x, coords.y, coords.z),
            distance = Config.PedSpawnDistance or 50.0,
            zoneKey = zoneKey,
            onEnter = function(self)
                addCraftZone(zoneKey, coords, label, icon, restoranId, categoryId, requiredJob)
            end,
            onExit = function(self)
                removeCraftZone(self.zoneKey)
            end,
        }),
    }
end

function RebuildRestoranCraftZones(data)
    for zoneKey in pairs(craftPointHandles) do
        removeCraftPoint(zoneKey)
    end
    craftPointHandles = {}
    craftZones = {}

    for id, r in pairs(data or {}) do
        if r.job then
            local numId = tonumber(id) or id
            local requiredJob = r.job
            local restoranId = numId

            if r.craftHrana then
                setupCraftPoint(
                    ('jamaica_restoran_craft_%s_hrana'):format(numId),
                    r.craftHrana,
                    'Priprema hrane',
                    'fa-solid fa-burger',
                    restoranId,
                    'hrana',
                    requiredJob
                )
            end

            if r.craftPice then
                setupCraftPoint(
                    ('jamaica_restoran_craft_%s_pice'):format(numId),
                    r.craftPice,
                    'Priprema pića',
                    'fa-solid fa-wine-glass',
                    restoranId,
                    'pice',
                    requiredJob
                )
            end
        end
    end
end

function ClearRestoranCraftZones()
    for zoneKey in pairs(craftPointHandles) do
        removeCraftPoint(zoneKey)
    end
    craftPointHandles = {}
    craftZones = {}
end
