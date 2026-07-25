local useFallbackTargets = false
local fallbackZonesCreated = false

local TargetTranslations = {
    failed_spawn = "NPC nisu uspješno stvoreni. Korištenje alternativnih zona.",
    enter_apartment = "Uđi u svoj apartman",
    apartment_list = "Lista apartmana",
    exit_apartment = "Izađi iz apartmana",
    inventory = "Inventar",
    wardrobe = "Ormar",
    lock_apartment = "Zaključaj apartman",
    unlock_apartment = "Otključaj apartman"
}

CreateThread(function()
    Wait(10000)
    
    if not pedSpawned then
        useFallbackTargets = true
        SetupBoxZoneTargets()
    end
end)

function SetupBoxZoneTargets()
    if not useFallbackTargets then return end

    if fallbackZonesCreated then
        for k,_ in pairs(Config.Apartment['enter']['targetCoords']) do
            exports.ox_target:removeZone("apartman_ulaz_" .. k)
        end
        exports.ox_target:removeZone("apartman_izlaz")
        exports.ox_target:removeZone("apartman_stash")
        exports.ox_target:removeZone("apartman_ormar")
        exports.ox_target:removeZone("apartman_custom_stash")
    end

    for k,v in pairs(Config.Apartment['enter']['targetCoords']) do
        local options = {
            {
                distance = 1.5,
                icon = "fa-solid fa-door-open",
                label = TargetTranslations.enter_apartment,
                onSelect = function()
                    EnterOwnApartment()
                end
            },
            {
                distance = 1.5,
                icon = "fa-solid fa-door-open",
                label = TargetTranslations.apartment_list,
                onSelect = function()
                    OpenApartmentList()
                end
            },
            {
                distance = 1.5,
                icon = "fa-solid fa-lock",
                label = TargetTranslations.lock_apartment,
                canInteract = function()
                    return isApartmentLocked == false
                end,
                onSelect = function()
                    ToggleApartmentLock()
                end
            },
            {
                distance = 1.5,
                icon = "fa-solid fa-lock-open",
                label = TargetTranslations.unlock_apartment,
                canInteract = function()
                    return isApartmentLocked == true
                end,
                onSelect = function()
                    ToggleApartmentLock()
                end
            }
        }

        exports.ox_target:addBoxZone({
            coords = v,
            size = vec3(1, 1, 3),
            name = "apartman_ulaz_" .. k,
            debug = false,
            options = options
        })
    end
    
    local exitOptions = {
        {
            distance = 1.5,
            icon = "fa-solid fa-door-open",
            label = TargetTranslations.exit_apartment,
            onSelect = function()
                LeaveApartment()
            end
        },
        {
            distance = 1.5,
            icon = "fa-solid fa-lock",
            label = TargetTranslations.lock_apartment,
            canInteract = function()
                return isApartmentLocked == false
            end,
            onSelect = function()
                ToggleApartmentLock()
            end
        },
        {
            distance = 1.5,
            icon = "fa-solid fa-lock-open",
            label = TargetTranslations.unlock_apartment,
            canInteract = function()
                return isApartmentLocked == true
            end,
            onSelect = function()
                ToggleApartmentLock()
            end
        }
    }

    exports.ox_target:addBoxZone({
        coords = Config.Apartment["leave"]['targetCoords'],
        size = vec3(1, 1, 3),
        name = "apartman_izlaz",
        debug = false,
        options = exitOptions
    })
    
    exports.ox_target:addBoxZone({
        coords = Config.Apartment["stash"]['targetCoords'],
        size = vec3(1, 1, 3),
        name = "apartman_stash",
        debug = false,
        options = {{
            distance = 1.5,
            icon = "fa-solid fa-box",
            label = TargetTranslations.inventory,
            onSelect = function()
                TriggerServerCallback(GetCurrentResourceName() .. ":getId", function(identifier)
                    local success = exports.ox_inventory:openInventory('stash', {id = ("apartman-" .. identifier)} )
                    if success == false then
                        TriggerServerEvent(GetCurrentResourceName() .. ":registerStash")
                        Wait(2000)
                        exports.ox_inventory:openInventory('stash', {id = ("apartman-" .. identifier)} )
                    end
                end)
            end
        }}
    })
    
    exports.ox_target:addBoxZone({
        coords = Config.Apartment["wardrobe"]['targetCoords'],
        size = vec3(1, 1, 3),
        name = "apartman_ormar",
        debug = false,
        options = {{
            distance = 1.5,
            icon = "fas fa-shirt",
            label = TargetTranslations.wardrobe,
            onSelect = function()
                OpenWardrobe()
            end
        }}
    })
    
    fallbackZonesCreated = true
end