local apartmentPeds = {}

local Translations = {
    enter_apartment = "Uđi u svoj apartman",
    apartment_list = "Lista apartmana",
    exit_apartment = "Izađi iz apartmana",
    open_stash = "Otvori sef",
    open_wardrobe = "Otvori garderobu",
    lock_apartment = "Zaključaj apartman",
    unlock_apartment = "Otključaj apartman",
}

local function PreloadPedModels()
    for key, pedConfig in pairs(Config.Peds) do
        local modelHash = GetHashKey(pedConfig.model)
        RequestModel(modelHash)
    end
end

local function AllModelsLoaded()
    for key, pedConfig in pairs(Config.Peds) do
        local modelHash = GetHashKey(pedConfig.model)
        if not HasModelLoaded(modelHash) then
            return false
        end
    end
    return true
end

function CreateLocalPed(model, coords, heading, scenario)
    local modelHash = GetHashKey(model)

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        local timeout = 0
        while not HasModelLoaded(modelHash) and timeout < 50 do
            Wait(50)
            timeout = timeout + 1
        end
        if not HasModelLoaded(modelHash) then
            return nil
        end
    end

    local ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z, heading or coords.w, false, false)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityAsMissionEntity(ped, true, true)

    if scenario then
        TaskStartScenarioInPlace(ped, scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(modelHash)

    return ped
end

function CreateApartmentPeds()
    if pedSpawned then return end

    PreloadPedModels()

    local timeout = 0
    while not AllModelsLoaded() and timeout < 100 do
        Wait(50)
        timeout = timeout + 1
    end

    for key, pedConfig in pairs(Config.Peds) do
        local ped = CreateLocalPed(
            pedConfig.model,
            pedConfig.coords,
            pedConfig.coords.w,
            pedConfig.scenario
        )

        if ped and DoesEntityExist(ped) then
            apartmentPeds[key] = {
                handle = ped,
                entityName = pedConfig.entity,
                position = pedConfig.coords
            }
        end
    end

    pedSpawned = true
end

function RemoveApartmentPeds()
    for key, pedData in pairs(apartmentPeds) do
        if DoesEntityExist(pedData.handle) then
            DeletePed(pedData.handle)
        end
    end
    
    apartmentPeds = {}
    pedSpawned = false
end

function SetupPedInteractions()
    for key, pedData in pairs(apartmentPeds) do
        local ped = pedData.handle
        
        if DoesEntityExist(ped) then
            if key == 'entrance' then
                local options = {
                    {
                        name = 'apartment_enter',
                        icon = 'fa-solid fa-door-open',
                        label = Translations.enter_apartment,
                        distance = 2.0,
                        onSelect = function()
                            EnterOwnApartment()
                        end
                    },
                    {
                        name = 'apartment_list',
                        icon = 'fa-solid fa-clipboard-list',
                        label = Translations.apartment_list,
                        distance = 2.0,
                        onSelect = function()
                            OpenApartmentList()
                        end
                    }
                }
                exports.ox_target:addLocalEntity(ped, options)
            elseif key == 'exit' then
                local options = {
                    {
                        name = 'apartment_exit',
                        icon = 'fa-solid fa-door-open',
                        label = Translations.exit_apartment,
                        distance = 2.0,
                        onSelect = function()
                            LeaveApartment()
                        end
                    },
                    {
                        name = 'apartment_lock_exit',
                        icon = 'fa-solid fa-lock',
                        label = Translations.lock_apartment,
                        distance = 2.0,
                        canInteract = function()
                            return isApartmentLocked == false
                        end,
                        onSelect = function()
                            ToggleApartmentLock()
                        end
                    },
                    {
                        name = 'apartment_unlock_exit',
                        icon = 'fa-solid fa-lock-open',
                        label = Translations.unlock_apartment,
                        distance = 2.0,
                        canInteract = function()
                            return isApartmentLocked == true
                        end,
                        onSelect = function()
                            ToggleApartmentLock()
                        end
                    }
                }
                
                exports.ox_target:addLocalEntity(ped, options)
            elseif key == 'stash' then
                exports.ox_target:addLocalEntity(ped, {
                    {
                        name = 'apartment_stash',
                        icon = 'fa-solid fa-box',
                        label = Translations.open_stash,
                        distance = 2.0,
                        onSelect = function()
                            TriggerServerCallback(GetCurrentResourceName() .. ":getId", function(identifier)
                                local success = exports.ox_inventory:openInventory('stash', {id = ("apartman-" .. identifier)})
                                if success == false then
                                    TriggerServerEvent(GetCurrentResourceName() .. ":registerStash")
                                    Wait(2000)
                                    exports.ox_inventory:openInventory('stash', {id = ("apartman-" .. identifier)})
                                end
                            end)
                        end
                    }
                })
            elseif key == 'wardrobe' then
                exports.ox_target:addLocalEntity(ped, {
                    {
                        name = 'apartment_wardrobe',
                        icon = 'fas fa-shirt',
                        label = Translations.open_wardrobe,
                        distance = 2.0,
                        onSelect = function()
                            OpenWardrobe()
                        end
                    }
                })
            end
        end
    end
end

function RefreshTargetInteractions()
    for key, pedData in pairs(apartmentPeds) do
        if DoesEntityExist(pedData.handle) then
            exports.ox_target:removeLocalEntity(pedData.handle)
        end
    end

    SetupPedInteractions()

    if useFallbackTargets then
        SetupBoxZoneTargets()
    end
end

CreateThread(function()
    while not ESX do
        Wait(100)
    end

    Wait(2000)

    CreateApartmentPeds()

    Wait(1000)
    SetupPedInteractions()

    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName ~= GetCurrentResourceName() then
            return
        end
        RemoveApartmentPeds()
    end)
end)

exports('RefreshTargetInteractions', RefreshTargetInteractions)