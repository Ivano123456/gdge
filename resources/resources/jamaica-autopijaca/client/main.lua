local ESX = exports.es_extended:getSharedObject()

local displayVehicles = {}
local sellLoopStarted = false
local blipHandle = nil

local sellErrors = {
    invalid = 'Neispravna cijena ili podaci vozila.',
    not_owner = 'Ovo vozilo nije vase.',
    full = 'Nema slobodnih mjesta na auto pijaci.',
    listed = 'Ovo vozilo je vec na prodaji.',
    financed = 'Ovo vozilo je na kreditu, ne mozete ga staviti na auto pijacu.',
    db = 'Greska pri postavljanju vozila. Pokusajte ponovo.',
    not_listed = 'Ovo vozilo nije na prodaji.',
    own_listing = 'Ne mozete kupiti sopstveno vozilo.',
    no_money = 'Nemate dovoljno novca na racunu.',
}

local function notify(msg)
    ESX.ShowNotification(msg)
end

local function loadModel(model)
    if not IsModelInCdimage(model) then return false end

    RequestModel(model)

    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then
            return false
        end
        Wait(0)
    end

    return true
end

local function markProtectedVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return end
    DecorSetInt(vehicle, 'jamaica_autopijaca', 1)
    Entity(vehicle).state:set('jamaica_autopijaca', true, true)
    displayVehicles[vehicle] = true
end

local function unmarkProtectedVehicle(vehicle)
    if vehicle and displayVehicles[vehicle] then
        displayVehicles[vehicle] = nil
    end

    if vehicle and DoesEntityExist(vehicle) then
        Entity(vehicle).state:set('jamaica_autopijaca', nil, true)
    end
end

local function clearSlot(slot)
    local entity = slot.entityId
    if entity and DoesEntityExist(entity) then
        unmarkProtectedVehicle(entity)
        SetEntityAsMissionEntity(entity, true, true)
        DeleteVehicle(entity)
    end

    slot.entityId = nil
    slot.price = nil
    slot.plate = nil
    slot.owner = nil
end

local function removeDisplayVehicles()
    for i = 1, #Config.VehiclePositions do
        clearSlot(Config.VehiclePositions[i])
    end
end

local function spawnDisplayVehicles()
    ESX.TriggerServerCallback('jamaica-autopijaca:getListings', function(listings)
        local maxSlots = #Config.VehiclePositions

        for i = 1, math.min(#listings, maxSlots) do
            local slot = Config.VehiclePositions[i]
            local listing = listings[i]
            local vehicleProps = listing.vehProps

            if type(vehicleProps) == 'table' and vehicleProps.model and loadModel(vehicleProps.model) then
                local entity = CreateVehicle(
                    vehicleProps.model,
                    slot.x, slot.y, slot.z,
                    slot.h,
                    false,
                    false
                )

                if DoesEntityExist(entity) then
                    ESX.Game.SetVehicleProperties(entity, vehicleProps)
                    SetEntityHeading(entity, slot.h)
                    FreezeEntityPosition(entity, true)
                    SetEntityInvincible(entity, true)
                    SetVehicleDoorsLocked(entity, 2)
                    SetEntityAsMissionEntity(entity, true, true)
                    markProtectedVehicle(entity)

                    slot.entityId = entity
                    slot.price = listing.price
                    slot.plate = vehicleProps.plate
                    slot.owner = listing.owner
                end

                SetModelAsNoLongerNeeded(vehicleProps.model)
            end
        end
    end)
end

local function refreshDisplayVehicles()
    removeDisplayVehicles()
    Wait(500)
    spawnDisplayVehicles()
end

local function getVehicleProps(vehicle)
    if not DoesEntityExist(vehicle) then return nil end
    return ESX.Game.GetVehicleProperties(vehicle)
end

local function promptPrice(defaultPrice)
    local input = lib.inputDialog('Cijena vozila', {
        {
            type = 'number',
            label = 'Cijena ($)',
            min = 1,
            required = true,
            default = defaultPrice,
        },
    })

    if not input then return nil end

    local price = tonumber(input[1])
    if not price or price <= 0 then
        notify('Unesite validnu cijenu.')
        return nil
    end

    return price
end

local function attemptListVehicle(vehicle, price)
    local vehProps = getVehicleProps(vehicle)

    if not vehProps or not vehProps.plate then
        notify('Ne mogu procitati podatke vozila.')
        return
    end

    ESX.TriggerServerCallback('jamaica-autopijaca:listVehicle', function(success, reason)
        if success then
            ESX.Game.DeleteVehicle(vehicle)
            notify('Stavili ste vozilo na prodaju za $' .. price)
        else
            notify(sellErrors[reason] or 'Nije moguce postaviti vozilo na prodaju.')
        end
    end, vehProps, price)
end

local function attemptBuyVehicle(vehicle)
    local vehProps = getVehicleProps(vehicle)

    if not vehProps or not vehProps.plate then
        notify('Ne mogu procitati podatke vozila.')
        return
    end

    ESX.TriggerServerCallback('jamaica-autopijaca:buyVehicle', function(success, reason)
        if success then
            ESX.Game.DeleteVehicle(vehicle)
            notify('Kupili ste vozilo.')
        elseif reason == 'no_money' then
            notify('Nemate dovoljno novca na racunu.')
        else
            notify(sellErrors[reason] or 'Kupovina nije uspjela.')
        end
    end, vehProps)
end

local function attemptRemoveListing(vehicle)
    local vehProps = getVehicleProps(vehicle)

    if not vehProps or not vehProps.plate then
        notify('Ne mogu procitati podatke vozila.')
        return
    end

    ESX.TriggerServerCallback('jamaica-autopijaca:removeListing', function(success, reason)
        if success then
            ESX.Game.DeleteVehicle(vehicle)
            notify('Sklonili ste vozilo sa auto pijace.')
        else
            notify(sellErrors[reason] or 'Nije moguce skinuti vozilo.')
        end
    end, vehProps)
end

local function openListMenu(vehicle)
    local price = promptPrice()

    if price then
        attemptListVehicle(vehicle, price)
    end
end

local function confirmDisplayAction(vehicle, price, plate, isOwner)
    local plateLabel = plate or 'nepoznato'
    local priceLabel = tostring(price or 0)

    if isOwner then
        local confirmed = lib.alertDialog({
            header = 'Skini vozilo',
            content = ('Jesi li siguran da zelis skinuti vozilo sa tablicama %s sa auto pijace?'):format(plateLabel),
            centered = true,
            cancel = true,
            labels = { confirm = 'Da, skini', cancel = 'Odustani' },
        })

        if confirmed == 'confirm' then
            attemptRemoveListing(vehicle)
        end

        return
    end

    local confirmed = lib.alertDialog({
        header = 'Kupovina vozila',
        content = ('Jesi li siguran da zelis kupiti vozilo sa tablicama %s za $%s?'):format(plateLabel, priceLabel),
        centered = true,
        cancel = true,
        labels = { confirm = 'Da, kupi', cancel = 'Odustani' },
    })

    if confirmed == 'confirm' then
        attemptBuyVehicle(vehicle)
    end
end

local function createBlip()
    if blipHandle and DoesBlipExist(blipHandle) then return end

    local cfg = Config.Blip
    blipHandle = AddBlipForCoord(cfg.coords.x, cfg.coords.y, cfg.coords.z)
    SetBlipSprite(blipHandle, cfg.sprite)
    SetBlipDisplay(blipHandle, 4)
    SetBlipScale(blipHandle, cfg.scale)
    SetBlipColour(blipHandle, cfg.color)
    SetBlipAsShortRange(blipHandle, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(cfg.label)
    EndTextCommandSetBlipName(blipHandle)
end

local function startSellLoop()
    if sellLoopStarted then return end
    sellLoopStarted = true

    CreateThread(function()
        while true do
            local sleep = 500
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local sellDist = #(pedCoords - Config.SellPosition)

            if sellDist <= Config.SellDrawDistance then
                sleep = 0

                if sellDist <= Config.SellInteractDistance then
                    ESX.Game.Utils.DrawText3D(Config.SellPosition, '~o~[E]~w~ Postavi vozilo na prodaju', 1.7)

                    if IsControlJustPressed(0, 38) then
                        if IsPedInAnyVehicle(ped, false) then
                            openListMenu(GetVehiclePedIsIn(ped, false))
                        else
                            notify('Morate biti u vozilu.')
                        end
                    end
                end
            end

            for i = 1, #Config.VehiclePositions do
                local slot = Config.VehiclePositions[i]
                local entity = slot.entityId

                if entity and DoesEntityExist(entity) then
                    local vehCoords = GetEntityCoords(entity)
                    local dist = #(pedCoords - vehCoords)

                    if dist <= Config.VehicleInteractDistance then
                        sleep = 0
                        local plateText = slot.plate or '???'
                        ESX.Game.Utils.DrawText3D(vehCoords, ('~o~[E]~w~ %s | $%s'):format(plateText, slot.price or 0), 1.4)

                        if IsControlJustPressed(0, 38) then
                            confirmDisplayAction(entity, slot.price, slot.plate, slot.owner == true)
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end)
end

local function bootstrap()
    DecorRegister('jamaica_autopijaca', 3)
    createBlip()
    startSellLoop()
    refreshDisplayVehicles()
end

RegisterNetEvent('jamaica-autopijaca:refreshDisplay', function()
    refreshDisplayVehicles()
end)

RegisterNetEvent('esx:playerLoaded', function()
    bootstrap()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if ESX.IsPlayerLoaded() then
        bootstrap()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    removeDisplayVehicles()

    if blipHandle and DoesBlipExist(blipHandle) then
        RemoveBlip(blipHandle)
        blipHandle = nil
    end
end)

exports('IsProtectedVehicle', function(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return false
    end

    return displayVehicles[vehicle] == true or DecorExistOn(vehicle, 'jamaica_autopijaca')
end)
