local ESX = exports.es_extended:getSharedObject()

local isRepairing = false
local activeJack = nil
local activeVehicle = nil
local jackModel = joaat('prop_carjack')
local animDicts = {
    'mp_car_bomb',
    'move_crawl',
    'amb@world_human_vehicle_mechanic@male@base',
}

function MehanicarNotify(msg, ntype, title)
    lib.notify({
        title = title or 'Auto Umro',
        description = msg,
        type = ntype or 'inform',
    })
end

local function notify(msg, ntype)
    MehanicarNotify(msg, ntype, 'Popravka')
end

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function preloadAssets()
    if not HasModelLoaded(jackModel) then
        lib.requestModel(jackModel, 5000)
    end

    for i = 1, #animDicts do
        loadAnimDict(animDicts[i])
    end
end

local function deleteJack(ent)
    if not ent or ent == 0 then return end
    activeJack = nil
    if not DoesEntityExist(ent) then return end
    DetachEntity(ent, true, true)
    SetEntityAsMissionEntity(ent, true, true)
    SetEntityCollision(ent, false, false)
    SetEntityVisible(ent, false, false)
    DeleteObject(ent)
    if DoesEntityExist(ent) then
        DeleteEntity(ent)
    end
end

local function getTargetVehicle(preferredVehicle)
    local ped = cache.ped
    if IsPedInAnyVehicle(ped, false) then
        return nil
    end

    local maxDist = Config.MaxVehicleDistance
    local coords = GetEntityCoords(ped)

    if preferredVehicle and preferredVehicle ~= 0 and DoesEntityExist(preferredVehicle) and IsEntityAVehicle(preferredVehicle) then
        if #(coords - GetEntityCoords(preferredVehicle)) <= maxDist then
            return preferredVehicle
        end
    end

    local inDirection = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, inDirection.x, inDirection.y, inDirection.z, 10, ped, 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and entityHit ~= 0 and IsEntityAVehicle(entityHit) then
        if #(coords - GetEntityCoords(entityHit)) <= maxDist then
            return entityHit
        end
    end

    local closest = ESX.Game.GetClosestVehicle(coords)
    if closest and closest ~= 0 and DoesEntityExist(closest) then
        if #(coords - GetEntityCoords(closest)) <= maxDist then
            return closest
        end
    end

    return nil
end

local function fixVehicle(vehicle)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)

    for i = 0, 7 do
        SetVehicleTyreFixed(vehicle, i)
    end
end

local function runRepairProgress(time, label)
    CreateThread(function()
        lib.progressBar({
            duration = time,
            label = label,
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
        })
    end)
end

local function startRepair(veh)
    if isRepairing then return false end
    if not veh or veh == 0 or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        return false
    end

    local ped = cache.ped
    if IsPedInAnyVehicle(ped, false) then
        notify('Ne mozes popravljati iz vozila.', 'error')
        return false
    end

    isRepairing = true
    activeVehicle = veh

    preloadAssets()

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local vehpos = GetEntityCoords(veh)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, -2.0, 0.0)
    local dict = 'mp_car_bomb'
    local vehjack = nil

    FreezeEntityPosition(veh, true)

    vehjack = CreateObject(jackModel, vehpos.x, vehpos.y, vehpos.z - 0.5, false, false, false)
    SetEntityAsMissionEntity(vehjack, true, true)
    SetModelAsNoLongerNeeded(jackModel)
    activeJack = vehjack
    AttachEntityToEntity(vehjack, veh, 0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

    runRepairProgress(9250, 'Postavljam dizalicu')

    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
    Wait(1250)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)

    dict = 'move_crawl'

    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.5, true, true, true)
    SetEntityCollision(veh, false, false)
    TaskPedSlideToCoord(ped, offset.x, offset.y, offset.z, heading, 1000)
    Wait(1000)

    runRepairProgress(11000, 'Popravljam vozilo')
    TaskPlayAnimAdvanced(ped, dict, 'onback_bwd', coords.x, coords.y, coords.z, 0.0, 0.0, heading - 180, 1.0, 0.5, 3000, 1, 0.0, 1, 1)

    dict = 'amb@world_human_vehicle_mechanic@male@base'

    Wait(3000)
    TaskPlayAnim(ped, dict, 'base', 8.0, -8.0, 5000, 1, 0, false, false, false)

    dict = 'move_crawl'

    Wait(4000)
    fixVehicle(veh)
    Wait(1000)

    local coords2 = GetEntityCoords(ped)

    TaskPlayAnimAdvanced(ped, dict, 'onback_fwd', coords2.x, coords2.y, coords2.z, 0.0, 0.0, heading - 180, 1.0, 0.5, 2000, 1, 0.0, 1, 1)
    Wait(3000)

    dict = 'mp_car_bomb'
    runRepairProgress(8250, 'Skidam dizalicu')

    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
    Wait(1250)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)

    dict = 'move_crawl'

    Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords.x, coords.y, coords.z, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z, true, true, true)
    FreezeEntityPosition(veh, false)

    Wait(100)

    deleteJack(vehjack)

    SetEntityCollision(veh, true, true)
    ClearPedTasks(ped)
    isRepairing = false
    activeVehicle = nil
    notify('Vozilo je popravljeno.', 'success')
    return true
end

function CancelMehanicarRepair()
    if not isRepairing then return end

    local ped = cache.ped
    local veh = activeVehicle
    local jack = activeJack

    isRepairing = false
    activeVehicle = nil

    deleteJack(jack)

    if veh and veh ~= 0 and DoesEntityExist(veh) then
        FreezeEntityPosition(veh, false)
        SetEntityCollision(veh, true, true)
    end

    ClearPedTasks(ped)
end

exports('useRepairKit', function(data, slot)
    if type(data) ~= 'table' or not data.slot then
        data = slot
    end

    if isRepairing then
        notify('Vec popravljas vozilo.', 'error')
        return
    end

    if IsPedInAnyVehicle(cache.ped, false) then
        notify('Ne mozes koristiti alat iz vozila.', 'error')
        return
    end

    local veh = getTargetVehicle()
    if not veh then
        notify('Nema vozila u blizini.', 'error')
        return
    end

    if type(data) ~= 'table' or not data.slot then
        notify('Greska pri koriscenju alata.', 'error')
        return
    end

    exports.ox_inventory:useItem(data, function(result)
        if not result then return end
        CreateThread(function()
            startRepair(veh)
        end)
    end)
end)

exports('startMechanicRepair', function(preferredVehicle)
    if isRepairing then
        notify('Vec popravljas vozilo.', 'error')
        return false
    end

    if IsPedInAnyVehicle(cache.ped, false) then
        notify('Ne mozes popravljati iz vozila.', 'error')
        return false
    end

    local veh = getTargetVehicle(preferredVehicle)
    if not veh then
        notify('Nema vozila u blizini.', 'error')
        return false
    end

    CreateThread(function()
        startRepair(veh)
    end)

    return true
end)

