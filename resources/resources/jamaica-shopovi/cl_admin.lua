local adminCmd = Config.AdminCommand or 'prodavnicaadmin'

local function assignOwner(entry, useFixed)
    local fields = {
        { type = 'number', label = 'Server ID igrača', required = true, min = 1 },
    }
    if useFixed then
        fields[#fields + 1] = {
            type = 'number',
            label = 'Fiksna zarada ($ po satu)',
            required = true,
            min = 1,
            default = 5000,
        }
    end

    local header = useFixed
        and ('Fiksna zarada — #%d %s'):format(entry.id, entry.label)
        or ('Vlasnik — #%d %s'):format(entry.id, entry.label)

    local input = lib.inputDialog(header, fields)
    if not input then return end

    local targetId = input[1]
    local amount = useFixed and input[2] or nil
    TriggerServerEvent('jamaica-shopovi:adminSetOwner', entry.id, targetId, useFixed, amount)
end

local function openShopMenu(entry)
    local leaseDays = Config.LeaseDays or 30
    local options = {
        {
            title = 'Dodeli vlasnika (stock)',
            description = ('Normalan režim — restock + %% od prodaje | %d dana'):format(leaseDays),
            icon = 'boxes-stacked',
            onSelect = function()
                assignOwner(entry, false)
            end,
        },
        {
            title = 'Dodeli vlasnika (fiksna zarada)',
            description = ('Bez stocka, isplata na sat | %d dana'):format(leaseDays),
            icon = 'money-bill-wave',
            onSelect = function()
                assignOwner(entry, true)
            end,
        },
    }

    if entry.hasOwner then
        options[#options + 1] = {
            title = ('Produži za %d dana'):format(leaseDays),
            description = entry.expiresLabel and ('Trenutno do %s'):format(entry.expiresLabel) or 'Produži zakup',
            icon = 'calendar-plus',
            onSelect = function()
                TriggerServerEvent('jamaica-shopovi:adminExtendLease', entry.id)
            end,
        }
        options[#options + 1] = {
            title = 'Ukloni vlasnika',
            description = entry.vlasnik,
            icon = 'user-minus',
            onSelect = function()
                local confirm = lib.alertDialog({
                    header = ('#%d %s'):format(entry.id, entry.label),
                    content = ('Ukloniti vlasnika?\n%s'):format(entry.vlasnik),
                    centered = true,
                    cancel = true,
                })
                if confirm == 'confirm' then
                    TriggerServerEvent('jamaica-shopovi:adminRemoveOwner', entry.id)
                end
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_shop_admin_shop',
        title = ('#%d — %s'):format(entry.id, entry.label),
        menu = 'jamaica_shop_admin_list',
        options = options,
    })
    lib.showContext('jamaica_shop_admin_shop')
end

local function openShopList(shops)
    local options = {}
    for i = 1, #shops do
        local s = shops[i]
        options[#options + 1] = {
            title = ('#%d — %s'):format(s.id, s.label),
            description = s.vlasnik,
            icon = s.fixedIncome and 'dollar-sign' or (s.hasOwner and 'store' or 'store-slash'),
            arrow = true,
            onSelect = function()
                openShopMenu(s)
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_shop_admin_list',
        title = 'Prodavnice — admin',
        options = options,
    })
    lib.showContext('jamaica_shop_admin_list')
end

local function openAdminMenu()
    local shops = lib.callback.await('jamaica-shopovi:adminListShops', false)
    if not shops or #shops < 1 then
        lib.notify({
            title = 'Greška',
            description = 'Nema prodavnica ili nemaš dozvolu.',
            type = 'error',
            position = 'right-center',
        })
        return
    end
    openShopList(shops)
end

RegisterNetEvent('jamaica-shopovi:openAdminMenu', openAdminMenu)

RegisterCommand(adminCmd, function()
    TriggerServerEvent('jamaica-shopovi:requestAdminMenu')
end, false)
