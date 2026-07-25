local ESX = exports.es_extended:getSharedObject()

local MENU_NAME = 'mehanicar_f6'

local function notify(msg, ntype)
    MehanicarNotify(msg, ntype, 'Auto Umro')
end

local function isMechanicOnDuty()
    local job = ESX.GetPlayerData().job
    return job and Config.IsMechanicJob(job.name)
end

function CloseMehanicarF6()
    ESX.UI.Menu.CloseAll()
end

local function getNearbyVehicle()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = ESX.Game.GetClosestVehicle(coords)

    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return nil
    end

    if #(coords - GetEntityCoords(vehicle)) > Config.MaxVehicleDistance then
        return nil
    end

    return vehicle
end

local function runProgress(label, duration, anim)
    return lib.progressBar({
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = anim,
    })
end

local function doRepairVehicle()
    local vehicle = getNearbyVehicle()
    if not vehicle then
        return notify('Nema vozila u blizini.', 'error')
    end

    exports['jamaica-mehanicar']:startMechanicRepair(vehicle)
end

local function doCleanVehicle()
    local vehicle = getNearbyVehicle()
    if not vehicle then
        return notify('Nema vozila u blizini.', 'error')
    end

    local ok = runProgress('Cistim vozilo...', Config.CleanDuration, {
        dict = 'switch@franklin@cleaning_car',
        clip = '001946_01_fras_v2_4_cleaning_car',
    })
    if not ok then return end

    if NetworkGetEntityIsNetworked(vehicle) then
        local deadline = GetGameTimer() + 2000
        while GetGameTimer() < deadline do
            if NetworkHasControlOfEntity(vehicle) then break end
            NetworkRequestControlOfEntity(vehicle)
            Wait(50)
        end
    end

    SetVehicleDirtLevel(vehicle, 0.0)
    WashDecalsFromVehicle(vehicle, 1.0)
    notify('Vozilo je ocisceno.', 'success')
end

RegisterNetEvent('jamaica-mehanicar:notify', function(message, ntype)
    notify(message, ntype)
end)

local function openMehanicarMenu()
    if not isMechanicOnDuty() then return end

    if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), MENU_NAME) then
        ESX.UI.Menu.CloseAll()
        return
    end

    local job = ESX.GetPlayerData().job
    local jobLabel = job and (job.label or job.name) or 'Auto Umro'

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), MENU_NAME, {
        title = ('🔧 | %s'):format(jobLabel),
        align = 'right-center',
        elements = {
            { label = '🔧 | Popravi vozilo', value = 'repair_vehicle' },
            { label = '🧼 | Ocisti vozilo', value = 'clean_vehicle' },
        },
    }, function(data, menu)
        menu.close()
        local action = data.current.value
        if action == 'repair_vehicle' then
            doRepairVehicle()
        elseif action == 'clean_vehicle' then
            doCleanVehicle()
        end
    end, function(_, menu)
        menu.close()
    end)
end

RegisterKeyMapping('+mehanicarmeni', 'Mehanicar meni', 'keyboard', Config.MenuKey)
RegisterCommand('+mehanicarmeni', function()
    if not isMechanicOnDuty() then return end
    if GetResourceState('jamaica-safezone') == 'started' and exports['jamaica-safezone']:BlockJobMenu() then
        return
    end
    openMehanicarMenu()
end, false)

RegisterCommand('-mehanicarmeni', function() end, false)
