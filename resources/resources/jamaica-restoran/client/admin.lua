local adminCmd = Config.AdminCommand or 'restoranadmin'
local currentDetailId = nil

local function notify(msg, ntype)
    lib.notify({ title = 'Restoran admin', description = msg, type = ntype or 'inform', position = 'right-center' })
end

local function playerCoords()
    local ped = cache.ped or PlayerPedId()
    local c = GetEntityCoords(ped)
    return { x = c.x, y = c.y, z = c.z, h = GetEntityHeading(ped) }
end

local function categoryOptions(selected)
    return {
        { value = 'hrana', label = 'Hrana' },
        { value = 'pice', label = 'Piće' },
    }
end

local function openItemEdit(restoranId, item)
    local isNew = item == nil
    local input = lib.inputDialog(isNew and 'Novi artikal' or ('Izmena — %s'):format(item.label), {
        { type = 'input', label = 'Item name (ox_inventory)', default = item and item.item or '', required = true },
        { type = 'input', label = 'Label (prikaz)', default = item and item.label or '', required = true },
        { type = 'number', label = 'Cena ($)', default = item and item.price or 10, min = 1, required = true },
        { type = 'select', label = 'Kategorija', default = item and item.category or 'hrana', options = categoryOptions(), required = true },
    })
    if not input then return end

    local payload = { item = input[1], label = input[2], price = input[3], category = input[4] }
    if isNew then
        TriggerServerEvent('jamaica-restoran:adminAddItem', restoranId, payload)
    else
        TriggerServerEvent('jamaica-restoran:adminUpdateItem', item.id, payload)
    end
    Wait(200)
    openItemsMenu(restoranId)
end

function openItemsMenu(restoranId)
    local detail = lib.callback.await('jamaica-restoran:adminGetDetail', false, restoranId)
    if not detail then
        notify('Nije moguće učitati artikle.', 'error')
        return
    end

    local options = {
        {
            title = 'Dodaj artikal',
            icon = 'plus',
            onSelect = function()
                openItemEdit(restoranId, nil)
            end,
        },
    }

    for i = 1, #detail.items do
        local it = detail.items[i]
        local cat = Config.CategoryLabels[it.category] or it.category
        options[#options + 1] = {
            title = ('%s — $%d'):format(it.label, it.price),
            description = ('%s | %s'):format(it.item, cat),
            icon = 'burger',
            arrow = true,
            onSelect = function()
                lib.registerContext({
                    id = 'jamaica_restoran_item_' .. it.id,
                    title = it.label,
                    menu = 'jamaica_restoran_items_' .. restoranId,
                    options = {
                        {
                            title = 'Izmeni',
                            icon = 'pen',
                            onSelect = function()
                                openItemEdit(restoranId, it)
                            end,
                        },
                        {
                            title = 'Obriši',
                            icon = 'trash',
                            onSelect = function()
                                local confirm = lib.alertDialog({
                                    header = it.label,
                                    content = ('Ukloniti %s iz ponude?'):format(it.label),
                                    centered = true,
                                    cancel = true,
                                })
                                if confirm == 'confirm' then
                                    TriggerServerEvent('jamaica-restoran:adminDeleteItem', it.id)
                                    Wait(200)
                                    openItemsMenu(restoranId)
                                end
                            end,
                        },
                    },
                })
                lib.showContext('jamaica_restoran_item_' .. it.id)
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_restoran_items_' .. restoranId,
        title = 'Artikli — ' .. (detail.restoran.label or ''),
        menu = 'jamaica_restoran_detail_' .. restoranId,
        options = options,
    })
    lib.showContext('jamaica_restoran_items_' .. restoranId)
end

local function openBlipMenu(restoranId)
    local detail = lib.callback.await('jamaica-restoran:adminGetDetail', false, restoranId)
    if not detail then
        notify('Nije moguće učitati blip podešavanja.', 'error')
        return
    end

    local r = detail.restoran
    local b = r.blip or {}
    local input = lib.inputDialog('Blip — ' .. r.label, {
        { type = 'checkbox', label = 'Prikaži na mapi', checked = b.enabled == nil or b.enabled == true or b.enabled == 1 or b.enabled == '1' },
        { type = 'input', label = 'Ime blipa', default = b.label or r.label or '', required = true },
        { type = 'number', label = 'Blip ID (sprite)', default = tonumber(b.sprite) or 93, min = 1 },
        { type = 'number', label = 'Blip boja', default = tonumber(b.color) or 1, min = 0 },
        { type = 'number', label = 'Blip scale', default = tonumber(b.scale) or 0.7, min = 0.1, max = 2.0, step = 0.1, precision = 1 },
    })
    if not input then return end

    TriggerServerEvent('jamaica-restoran:adminSetBlip', restoranId, {
        enabled = input[1],
        label = input[2],
        sprite = input[3],
        color = input[4],
        scale = input[5],
    })
end

local function openJobMenu(restoranId, currentJob)
    local jobs = lib.callback.await('jamaica-restoran:adminGetJobs', false)
    if not jobs then return end

    local options = {}
    for i = 1, #jobs do
        local j = jobs[i]
        options[#options + 1] = {
            title = j.label,
            description = j.name,
            icon = j.name == currentJob and 'check' or 'briefcase',
            onSelect = function()
                TriggerServerEvent('jamaica-restoran:adminSetJob', restoranId, j.name)
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_restoran_jobs_' .. restoranId,
        title = 'Job organizacije — ' .. (currentJob or ''),
        menu = 'jamaica_restoran_detail_' .. restoranId,
        options = options,
    })
    lib.showContext('jamaica_restoran_jobs_' .. restoranId)
end

local function openRestoranDetail(restoranId)
    currentDetailId = restoranId
    local detail = lib.callback.await('jamaica-restoran:adminGetDetail', false, restoranId)
    if not detail then
        notify('Restoran nije pronađen.', 'error')
        return
    end

    local r = detail.restoran
    local pedInfo = r.ped and (math.abs(r.ped.x or 0) > 0.01 or math.abs(r.ped.y or 0) > 0.01) and ('%.1f, %.1f, %.1f'):format(r.ped.x, r.ped.y, r.ped.z) or 'Nije postavljeno — stani na mesto i klikni'
    local craftHranaInfo = r.craftHrana and ('%.1f, %.1f, %.1f'):format(r.craftHrana.x, r.craftHrana.y, r.craftHrana.z) or 'Nije postavljeno — stani na mesto i klikni'
    local craftPiceInfo = r.craftPice and ('%.1f, %.1f, %.1f'):format(r.craftPice.x, r.craftPice.y, r.craftPice.z) or 'Nije postavljeno — stani na mesto i klikni'
    if not Config.UseCraftRecipes then
        craftHranaInfo = craftHranaInfo .. ' | Artikli iz ponude'
        craftPiceInfo = craftPiceInfo .. ' | Artikli iz ponude'
    end

    local options = {
            {
                title = 'Postavi ped poziciju',
                description = pedInfo,
                icon = 'location-dot',
                onSelect = function()
                    local c = playerCoords()
                    TriggerServerEvent('jamaica-restoran:adminSetPed', restoranId, c)
                end,
            },
            {
                title = 'Ped model',
                description = r.ped and r.ped.model or Config.DefaultPedModel,
                icon = 'user',
                onSelect = function()
                    local input = lib.inputDialog('Ped model', {
                        { type = 'input', label = 'Model (npr. s_m_y_barman_01)', default = r.ped and r.ped.model or Config.DefaultPedModel, required = true },
                    })
                    if input then TriggerServerEvent('jamaica-restoran:adminSetPedModel', restoranId, input[1]) end
                end,
            },
            {
                title = 'Naziv restorana',
                description = r.label,
                icon = 'signature',
                onSelect = function()
                    local input = lib.inputDialog('Naziv', {
                        { type = 'input', label = 'Label', default = r.label, required = true },
                    })
                    if input then TriggerServerEvent('jamaica-restoran:adminSetLabel', restoranId, input[1]) end
                end,
            },
            {
                title = 'Job organizacije (prihod)',
                description = r.job or '—',
                icon = 'briefcase',
                arrow = true,
                onSelect = function()
                    openJobMenu(restoranId, r.job)
                end,
            },
            {
                title = 'Blip na mapi',
                description = r.blip and r.blip.enabled and (r.blip.label or r.label) or 'Isključen',
                icon = 'map-location-dot',
                onSelect = function()
                    openBlipMenu(restoranId)
                end,
            },
            {
                title = 'Postavi craft — HRANA',
                description = craftHranaInfo,
                icon = 'burger',
                onSelect = function()
                    local c = playerCoords()
                    TriggerServerEvent('jamaica-restoran:adminSetCraft', restoranId, 'hrana', { x = c.x, y = c.y, z = c.z })
                end,
            },
            {
                title = 'Postavi craft — PIĆE',
                description = craftPiceInfo,
                icon = 'wine-glass',
                onSelect = function()
                    local c = playerCoords()
                    TriggerServerEvent('jamaica-restoran:adminSetCraft', restoranId, 'pice', { x = c.x, y = c.y, z = c.z })
                end,
            },
    }

    if Config.UseCraftRecipes then
        options[#options + 1] = {
            title = 'Craft recepti',
            description = ('%d recepata'):format(#(detail.crafts or {})),
            icon = 'kitchen-set',
            arrow = true,
            onSelect = function()
                OpenCraftAdminMenu(restoranId)
            end,
        }
    end

    options[#options + 1] = {
        title = 'Artikli u ponudi',
        description = ('%d artikala'):format(#detail.items),
        icon = 'utensils',
        arrow = true,
        onSelect = function()
            openItemsMenu(restoranId)
        end,
    }
    options[#options + 1] = {
        title = r.enabled and 'Isključi restoran' or 'Uključi restoran',
        icon = r.enabled and 'toggle-off' or 'toggle-on',
        onSelect = function()
            TriggerServerEvent('jamaica-restoran:adminToggleEnabled', restoranId)
        end,
    }
    options[#options + 1] = {
        title = 'Obriši restoran',
        icon = 'trash',
        onSelect = function()
            local confirm = lib.alertDialog({
                header = r.label,
                content = 'Trajno obrisati restoran i sve artikle?',
                centered = true,
                cancel = true,
            })
            if confirm == 'confirm' then
                TriggerServerEvent('jamaica-restoran:adminDelete', restoranId)
            end
        end,
    }

    lib.registerContext({
        id = 'jamaica_restoran_detail_' .. restoranId,
        title = ('#%d — %s'):format(restoranId, r.label),
        menu = 'jamaica_restoran_admin_list',
        options = options,
    })
    lib.showContext('jamaica_restoran_detail_' .. restoranId)
end

local function openCreateMenu()
    local jobs = lib.callback.await('jamaica-restoran:adminGetJobs', false) or {}
    local jobOptions = {}
    for i = 1, #jobs do
        jobOptions[#jobOptions + 1] = { value = jobs[i].name, label = ('%s (%s)'):format(jobs[i].label, jobs[i].name) }
    end

    local fields = {
        { type = 'input', label = 'Naziv restorana', required = true },
    }
    if #jobOptions > 0 then
        fields[#fields + 1] = { type = 'select', label = 'Job organizacije', options = jobOptions, required = true }
    else
        fields[#fields + 1] = { type = 'input', label = 'Job organizacije (npr. ballas)', required = true }
    end

    local input = lib.inputDialog('Novi restoran', fields)
    if not input then return end

    local job = #jobOptions > 0 and input[2] or input[2]
    TriggerServerEvent('jamaica-restoran:adminCreate', { label = input[1], job = job })
end

local function openAdminList()
    local list = lib.callback.await('jamaica-restoran:adminList', false)
    if not list then
        notify('Nemaš dozvolu.', 'error')
        return
    end

    local options = {
        {
            title = 'Novi restoran',
            description = 'Kreiraj lokaciju i postavi ped',
            icon = 'plus',
            onSelect = openCreateMenu,
        },
    }

    for i = 1, #list do
        local e = list[i]
        local status = e.enabled and 'Aktivan' or 'Isključen'
        options[#options + 1] = {
            title = ('#%d — %s'):format(e.id, e.label),
            description = ('%s | job: %s | %d artikala'):format(status, e.job, e.itemCount),
            icon = 'store',
            arrow = true,
            onSelect = function()
                openRestoranDetail(e.id)
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_restoran_admin_list',
        title = 'Restorani — admin',
        options = options,
    })
    lib.showContext('jamaica_restoran_admin_list')
end

local function openAdminMenu()
    openAdminList()
end

RegisterNetEvent('jamaica-restoran:openAdminMenu', openAdminMenu)

RegisterNetEvent('jamaica-restoran:adminRefresh', function(restoranId)
    if currentDetailId == restoranId then
        Wait(300)
        openRestoranDetail(restoranId)
    end
end)

RegisterCommand(adminCmd, function()
    TriggerServerEvent('jamaica-restoran:requestAdminMenu')
end, false)
