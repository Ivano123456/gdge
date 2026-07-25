local function defaultDurationForCategory(category)
    local cfg = Config.DefaultCraftDuration
    category = category == 'pice' and 'pice' or 'hrana'
    if type(cfg) == 'table' then
        return tonumber(cfg[category]) or tonumber(cfg.hrana) or 6
    end
    return tonumber(cfg) or 10
end

local function craftIngredientString(craft)
    local parts = {}
    for i = 1, #(craft.ingredients or {}) do
        local ing = craft.ingredients[i]
        parts[#parts + 1] = ('%s:%d'):format(ing.item, ing.amount)
    end
    return table.concat(parts, ', ')
end

local function defaultAnimFields(category)
    local defs = Config.DefaultCraftAnim or {}
    local def = defs[category] or defs.hrana or { dict = 'mini@repair', clip = 'fixing_a_player', flag = 49 }
    return def.dict, def.clip, def.flag
end

local function animDefaults(craft, category)
    local anim = craft and craft.anim
    if anim and anim.dict and anim.clip then
        return anim.dict, anim.clip, anim.flag or 49
    end
    return defaultAnimFields(category)
end

local function openCraftEdit(restoranId, craft)
    local isNew = craft == nil
    local category = craft and craft.category or 'hrana'
    local defDict, defClip, defFlag = animDefaults(craft, category)

    local input = lib.inputDialog(isNew and 'Novi craft recept' or ('Izmena — %s'):format(craft.outputLabel or craft.label or ''), {
        { type = 'select', label = 'Kategorija', default = category, options = {
            { value = 'hrana', label = 'Hrana' },
            { value = 'pice', label = 'Piće' },
        }, required = true },
        { type = 'input', label = 'Output item (ox_inventory)', default = craft and craft.outputItem or '', required = true },
        { type = 'input', label = 'Output label', default = craft and craft.outputLabel or '', required = true },
        { type = 'number', label = 'Output količina', default = craft and craft.outputCount or 1, min = 1, required = true },
        { type = 'number', label = 'Trajanje (sekunde)', default = craft and craft.duration or defaultDurationForCategory(category), min = 1, required = true },
        { type = 'input', label = 'Anim dict', default = defDict, required = true },
        { type = 'input', label = 'Anim clip', default = defClip, required = true },
        { type = 'number', label = 'Anim flag', default = defFlag, min = 0 },
        { type = 'input', label = 'Sastojci (item:kolicina, ...)', default = craft and craftIngredientString(craft) or '', required = true },
    })
    if not input then return end

    local payload = {
        category = input[1],
        outputItem = input[2],
        outputLabel = input[3],
        outputCount = input[4],
        duration = input[5],
        animDict = input[6],
        animClip = input[7],
        animFlag = input[8],
        ingredients = input[9],
    }

    if isNew then
        TriggerServerEvent('jamaica-restoran:adminAddCraft', restoranId, payload)
    else
        TriggerServerEvent('jamaica-restoran:adminUpdateCraft', craft.id, payload)
    end
    Wait(250)
    OpenCraftAdminMenu(restoranId)
end

function OpenCraftCategoryAdmin(restoranId, categoryId, categoryLabel)
    local crafts = lib.callback.await('jamaica-restoran:adminGetCrafts', false, restoranId) or {}
    local options = {
        {
            title = 'Dodaj recept',
            icon = 'plus',
            onSelect = function()
                openCraftEdit(restoranId, { category = categoryId })
            end,
        },
    }

    for i = 1, #crafts do
        local c = crafts[i]
        if c.category == categoryId then
            options[#options + 1] = {
                title = ('%s — %ds'):format(c.outputLabel, c.duration),
                description = ('%s | %s'):format(c.outputItem, craftIngredientString(c)),
                icon = 'utensils',
                arrow = true,
                onSelect = function()
                    lib.registerContext({
                        id = 'jamaica_restoran_craft_edit_' .. c.id,
                        title = c.outputLabel,
                        menu = 'jamaica_restoran_craft_cat_' .. restoranId .. '_' .. categoryId,
                        options = {
                            {
                                title = 'Izmeni recept',
                                icon = 'pen',
                                onSelect = function()
                                    openCraftEdit(restoranId, c)
                                end,
                            },
                            {
                                title = 'Obriši recept',
                                icon = 'trash',
                                onSelect = function()
                                    local confirm = lib.alertDialog({
                                        header = c.outputLabel,
                                        content = 'Obrisati ovaj craft recept?',
                                        centered = true,
                                        cancel = true,
                                    })
                                    if confirm == 'confirm' then
                                        TriggerServerEvent('jamaica-restoran:adminDeleteCraft', c.id)
                                        Wait(250)
                                        OpenCraftCategoryAdmin(restoranId, categoryId, categoryLabel)
                                    end
                                end,
                            },
                        },
                    })
                    lib.showContext('jamaica_restoran_craft_edit_' .. c.id)
                end,
            }
        end
    end

    lib.registerContext({
        id = 'jamaica_restoran_craft_cat_' .. restoranId .. '_' .. categoryId,
        title = 'Craft — ' .. categoryLabel,
        menu = 'jamaica_restoran_craft_admin_' .. restoranId,
        options = options,
    })
    lib.showContext('jamaica_restoran_craft_cat_' .. restoranId .. '_' .. categoryId)
end

function OpenCraftAdminMenu(restoranId)
    if not Config.UseCraftRecipes then
        lib.notify({
            title = 'Restoran',
            description = 'Recepti su isključeni. Priprema koristi artikle iz ponude restorana.',
            type = 'inform',
            position = 'right-center',
        })
        return
    end

    local detail = lib.callback.await('jamaica-restoran:adminGetDetail', false, restoranId)
    if not detail then return end

    local crafts = detail.crafts or {}
    lib.registerContext({
        id = 'jamaica_restoran_craft_admin_' .. restoranId,
        title = 'Craft recepti',
        menu = 'jamaica_restoran_detail_' .. restoranId,
        options = {
            {
                title = 'Hrana',
                description = 'Recepti za hranu',
                icon = 'burger',
                arrow = true,
                onSelect = function()
                    OpenCraftCategoryAdmin(restoranId, 'hrana', 'HRANA')
                end,
            },
            {
                title = 'Piće',
                description = 'Recepti za piće',
                icon = 'wine-glass',
                arrow = true,
                onSelect = function()
                    OpenCraftCategoryAdmin(restoranId, 'pice', 'PIĆE')
                end,
            },
            {
                title = ('Ukupno recepata: %d'):format(#crafts),
                icon = 'list',
                disabled = true,
            },
        },
    })
    lib.showContext('jamaica_restoran_craft_admin_' .. restoranId)
end
