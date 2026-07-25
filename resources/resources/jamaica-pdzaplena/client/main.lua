local ESX = exports.es_extended:getSharedObject()

local impoundPed = nil
local spawnLock = false
local trackedPlate = nil

local function notify(msg, ntype)
    lib.notify({
        title = 'PD Zaplena',
        description = msg,
        type = ntype or 'inform',
        position = 'center-right',
    })
end

local function isPolice()
    local data = ESX.GetPlayerData()
    if not data or not data.job then return false end
    return data.job.name == (Config.PoliceJob or 'police')
        and (data.job.grade or 0) >= (Config.MinGrade or 3)
end

local function getClosestVehicle(maxDist)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        return vehicle
    end

    vehicle = ESX.Game.GetClosestVehicle(coords)
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        return nil
    end

    if maxDist and #(coords - GetEntityCoords(vehicle)) > maxDist then
        return nil
    end

    return vehicle
end

local function getVehiclePlate(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    local plate = GetVehicleNumberPlateText(vehicle)
    if not plate or plate == '' then return nil end
    return ESX.Math.Trim(plate)
end

local function collectVehicleProps(vehicle)
    local props = ESX.Game.GetVehicleProperties(vehicle)
    if GetResourceState('okokGasStation') == 'started' then
        props.fuelLevel = exports['okokGasStation']:GetFuel(vehicle)
    else
        props.fuelLevel = GetVehicleFuelLevel(vehicle)
    end
    return props
end

local function applyVehicleProps(vehicle, props, plate)
    ESX.Game.SetVehicleProperties(vehicle, props)
    SetVehicleNumberPlateText(vehicle, plate)
    if GetResourceState('okokGasStation') == 'started' then
        exports['okokGasStation']:SetFuel(vehicle, props.fuelLevel or 100.0)
    else
        SetVehicleFuelLevel(vehicle, props.fuelLevel or 100.0)
    end
end

local function warpIntoVehicle(vehicle)
    local ped = PlayerPedId()
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
end

local function startImpoundFlow()
    if not isPolice() then
        notify('Nemate ovlasti za zaplenu.', 'error')
        return
    end

    local vehicle = getClosestVehicle(Config.ImpoundRadius or 10.0)
    if not vehicle then
        notify('Nema civilnog vozila u blizini.', 'error')
        return
    end

    local plate = getVehiclePlate(vehicle)
    if not plate then
        notify('Tablice nisu pročitane.', 'error')
        return
    end

    local input = lib.inputDialog('Zaplena vozila', {
        {
            type = 'input',
            label = 'Tablice',
            default = plate,
            disabled = true,
        },
        {
            type = 'textarea',
            label = 'Razlog zaplene',
            placeholder = 'Opišite razlog...',
            required = true,
            min = 3,
            max = 120,
        },
    })

    if not input or not input[2] then return end

    if not lib.progressBar({
        duration = 8000,
        label = 'Zaplenjujete vozilo...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
    }) then
        return
    end

    ESX.TriggerServerCallback('jamaica-pdzaplena:impoundVehicle', function(ok, msg)
        notify(msg or (ok and 'Zaplenjeno.' or 'Greška.'), ok and 'success' or 'error')
        if ok and DoesEntityExist(vehicle) then
            ESX.Game.DeleteVehicle(vehicle)
        end
    end, plate, input[2])
end

local function spawnImpoundVehicle(plate)
    if spawnLock then
        notify('Već izvlačite vozilo.', 'error')
        return
    end

    spawnLock = true

    ESX.TriggerServerCallback('jamaica-pdzaplena:spawnImpound', function(ok, data)
        if not ok or type(data) ~= 'table' then
            spawnLock = false
            notify(type(data) == 'string' and data or 'Ne možete izvaditi vozilo.', 'error')
            return
        end

        local spawn = Config.Spawn
        if not ESX.Game.IsSpawnPointClear(vector3(spawn.x, spawn.y, spawn.z), 2.5) then
            TriggerServerEvent('jamaica-pdzaplena:abortSpawn', data.plate)
            spawnLock = false
            notify('Spawn mesto nije slobodno.', 'error')
            return
        end

        local props = data.props or {}
        local model = props.model
        local modelHash = type(model) == 'number' and model or joaat(model)

        ESX.Game.SpawnVehicle(modelHash, vector3(spawn.x, spawn.y, spawn.z), spawn.w, function(veh)
            if not veh or veh == 0 or not DoesEntityExist(veh) then
                TriggerServerEvent('jamaica-pdzaplena:abortSpawn', data.plate)
                spawnLock = false
                notify('Greška pri spawnu vozila.', 'error')
                return
            end

            applyVehicleProps(veh, props, data.plate)
            warpIntoVehicle(veh)
            trackedPlate = data.plate
            spawnLock = false
            notify(('Vozilo %s izvađeno.'):format(data.plate), 'success')
        end)
    end, plate)
end

local function normalizePlateLocal(plate)
    if not plate then return '' end
    return string.upper(string.gsub(plate, '%s+', ''))
end

local function storeImpoundVehicle()
    if not isPolice() then
        notify('Nemate ovlasti.', 'error')
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        notify('Morate biti u vozilu.', 'error')
        return
    end

    local plate = getVehiclePlate(vehicle)
    if not plate then
        notify('Tablice nisu pročitane.', 'error')
        return
    end

    local pedCoords = GetEntityCoords(ped)
    local pedPos = vector3(Config.Ped.x, Config.Ped.y, Config.Ped.z)
    if #(pedCoords - pedPos) > (Config.StoreRadius or 8.0) then
        notify('Morate biti blizu PD garaže zaplene.', 'error')
        return
    end

    local props = collectVehicleProps(vehicle)
    ESX.TriggerServerCallback('jamaica-pdzaplena:storeImpound', function(ok, msg)
        notify(msg or (ok and 'Parkirano.' or 'Greška.'), ok and 'success' or 'error')
        if ok then
            if trackedPlate and normalizePlateLocal(plate) == normalizePlateLocal(trackedPlate) then
                trackedPlate = nil
            end
            ESX.Game.DeleteVehicle(vehicle)
        end
    end, plate, props)
end

local function returnVehicleMenu(plate)
    local alert = lib.alertDialog({
        header = 'Vrati vozilo vlasniku',
        content = ('Da li ste sigurni da vraćate vozilo %s vlasniku?'):format(plate),
        centered = true,
        cancel = true,
    })

    if alert ~= 'confirm' then return end

    ESX.TriggerServerCallback('jamaica-pdzaplena:returnToOwner', function(ok, msg)
        notify(msg or (ok and 'Vraćeno.' or 'Greška.'), ok and 'success' or 'error')
        if ok then
            openImpoundGarageMenu()
        end
    end, plate)
end

function openImpoundGarageMenu()
    if not isPolice() then
        notify('Nemate ovlasti.', 'error')
        return
    end

    ESX.TriggerServerCallback('jamaica-pdzaplena:getImpoundList', function(list)
        if not list then
            notify('Nemate ovlasti.', 'error')
            return
        end

        local options = {}

        if #list == 0 then
            options[#options + 1] = {
                title = 'Nema zaplenjenih vozila',
                icon = 'fa-solid fa-circle-info',
                disabled = true,
            }
        else
            for i = 1, #list do
                local row = list[i]
                local statusText = row.outWithPd and 'Van garaže (PD)' or 'U PD garaži'
                options[#options + 1] = {
                    title = ('%s | %s'):format(row.plate, row.label or 'Vozilo'),
                    description = ('%s\nVlasnik: %s\nRazlog: %s\nZaplenio: %s'):format(
                        row.atText,
                        row.ownerName,
                        row.reason,
                        row.officer
                    ),
                    icon = row.outWithPd and 'fa-solid fa-car-side' or 'fa-solid fa-warehouse',
                    arrow = true,
                    onSelect = function()
                        local sub = {
                            {
                                title = statusText,
                                icon = 'fa-solid fa-circle-info',
                                disabled = true,
                            },
                            {
                                title = 'Izvadi vozilo',
                                icon = 'fa-solid fa-key',
                                disabled = row.outWithPd,
                                onSelect = function()
                                    spawnImpoundVehicle(row.plate)
                                end,
                            },
                            {
                                title = 'Vrati vlasniku',
                                icon = 'fa-solid fa-rotate-left',
                                disabled = row.outWithPd,
                                onSelect = function()
                                    returnVehicleMenu(row.plate)
                                end,
                            },
                            {
                                title = 'Nazad',
                                icon = 'fa-solid fa-arrow-left',
                                onSelect = openImpoundGarageMenu,
                            },
                        }

                        lib.registerContext({
                            id = 'jamaica_pdzaplena_vehicle_' .. row.plate,
                            title = row.plate,
                            menu = 'jamaica_pdzaplena_garage',
                            options = sub,
                        })
                        lib.showContext('jamaica_pdzaplena_vehicle_' .. row.plate)
                    end,
                }
            end
        end

        options[#options + 1] = {
            title = 'Parkiraj zaplenjeno vozilo',
            description = 'Vratite vozilo u PD garažu (morate biti u vozilu)',
            icon = 'fa-solid fa-square-parking',
            onSelect = storeImpoundVehicle,
        }

        options[#options + 1] = {
            title = 'Nazad',
            icon = 'fa-solid fa-arrow-left',
            onSelect = openPedMenu,
        }

        lib.registerContext({
            id = 'jamaica_pdzaplena_garage',
            title = 'PD garaža zaplene',
            menu = 'jamaica_pdzaplena_main',
            options = options,
        })
        lib.showContext('jamaica_pdzaplena_garage')
    end)
end

function openPedMenu()
    if not isPolice() then
        notify('Nemate ovlasti.', 'error')
        return
    end

    lib.registerContext({
        id = 'jamaica_pdzaplena_main',
        title = 'PD zaplena vozila',
        options = {
            {
                title = 'Zapleni vozilo',
                description = 'Zapleni najbliže civilno vozilo',
                icon = 'fa-solid fa-truck-pickup',
                onSelect = startImpoundFlow,
            },
            {
                title = 'PD garaža zaplene',
                description = 'Pregled, izvlačenje i vraćanje vozila',
                icon = 'fa-solid fa-warehouse',
                arrow = true,
                onSelect = openImpoundGarageMenu,
            },
        },
    })
    lib.showContext('jamaica_pdzaplena_main')
end

local function showOwnerImpoundInfo(info)
    if not info then return end

    lib.alertDialog({
        header = 'Vozilo zaplenjeno',
        content = table.concat({
            ('Tablice: %s'):format(info.plate or ''),
            ('Datum: %s'):format(info.atText or ''),
            ('Razlog: %s'):format(info.reason or ''),
            ('Zaplenio: %s'):format(info.officer or 'PD'),
            '',
            'Vozilo možete preuzeti tek kada PD vrati vozilo vlasniku.',
        }, '\n'),
        centered = true,
        labels = { confirm = 'U redu' },
    })
end

RegisterNetEvent('jamaica-pdzaplena:notify', function(msg, ntype)
    notify(msg, ntype)
end)

RegisterNetEvent('jamaica-pdzaplena:showOwnerInfo', function(info)
    showOwnerImpoundInfo(info)
end)

exports('ShowOwnerImpoundInfo', showOwnerImpoundInfo)

RegisterNetEvent('jamaica-pdzaplena:requestOwnerInfo', function(plate)
    ESX.TriggerServerCallback('jamaica-pdzaplena:getOwnerBlockInfo', function(info)
        showOwnerImpoundInfo(info)
    end, plate)
end)

local function spawnPed()
    local modelName = Config.PedModel or 's_m_y_cop_01'
    local model = joaat(modelName)
    if not IsModelInCdimage(model) or not IsModelValid(model) then return end

    local loaded = false
    for _ = 1, 3 do
        if pcall(lib.requestModel, model, 15000) and HasModelLoaded(model) then
            loaded = true
            break
        end
        Wait(1500)
    end
    if not loaded then return end

    local c = Config.Ped
    impoundPed = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    if not DoesEntityExist(impoundPed) then
        SetModelAsNoLongerNeeded(model)
        return
    end

    SetEntityInvincible(impoundPed, true)
    SetBlockingOfNonTemporaryEvents(impoundPed, true)
    FreezeEntityPosition(impoundPed, true)
    SetModelAsNoLongerNeeded(model)

    exports.ox_target:addLocalEntity(impoundPed, {
        {
            name = 'jamaica_pdzaplena_ped',
            icon = 'fa-solid fa-truck-pickup',
            label = 'Zapleni vozilo',
            distance = Config.TargetDistance or 2.5,
            canInteract = function()
                return isPolice()
            end,
            onSelect = openPedMenu,
        },
    })
end

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(500) end
    while GetResourceState('ox_target') ~= 'started' do Wait(200) end
    Wait(2500)
    spawnPed()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    if impoundPed and DoesEntityExist(impoundPed) then
        exports.ox_target:removeLocalEntity(impoundPed, 'jamaica_pdzaplena_ped')
        DeleteEntity(impoundPed)
    end
end)

exports('OpenOwnerImpoundInfo', function(plate)
    TriggerEvent('jamaica-pdzaplena:requestOwnerInfo', plate)
end)
