local CoreTranslations = {
    enter_apartment = "Uđi u apartman",
    enter_description = "Uđi u svoj apartman",
    apartment_list = "Lista apartmana",
    list_description = "Pregledaj apartmane drugih igrača",
    apartment_options = "Opcije apartmana",
    lock_apartment = "Zaključaj apartman",
    unlock_apartment = "Otključaj apartman",
    lock_description = "Sakrij svoj apartman s liste",
    unlock_description = "Prikaži svoj apartman na listi"
}

CreateThread(function()
    Wait(1000)

    for k, coords in pairs(Config.Apartment['enter']['targetCoords']) do
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            name = 'apartment_entrance_' .. k,
            debug = false,
            options = {
                {
                    name = 'enter_own_apartment',
                    icon = 'fa-solid fa-door-open',
                    label = CoreTranslations.enter_apartment,
                    onSelect = function()
                        EnterOwnApartment()
                    end
                },
                {
                    name = 'apartment_list',
                    icon = 'fa-solid fa-clipboard-list',
                    label = CoreTranslations.apartment_list,
                    onSelect = function()
                        OpenApartmentList()
                    end
                }
            }
        })
    end
end)

function OpenApartmentMenu()
    local options = {
        {
            title = CoreTranslations.enter_apartment,
            description = CoreTranslations.enter_description,
            onSelect = function()
                EnterOwnApartment()
            end
        },
        {
            title = CoreTranslations.apartment_list,
            description = CoreTranslations.list_description,
            onSelect = function()
                OpenApartmentList()
            end
        }
    }

    if apartmentIn > 0 then
        local title = isApartmentLocked and CoreTranslations.unlock_apartment or CoreTranslations.lock_apartment
        local description = isApartmentLocked and CoreTranslations.unlock_description or CoreTranslations.lock_description

        table.insert(options, {
            title = title,
            description = description,
            onSelect = function()
                ToggleApartmentLock()
            end
        })
    end

    lib.registerContext({
        id = 'apartment_menu',
        title = CoreTranslations.apartment_options,
        options = options
    })

    lib.showContext('apartment_menu')
end
