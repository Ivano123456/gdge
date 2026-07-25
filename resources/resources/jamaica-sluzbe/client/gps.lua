local cfg = SluzbeGps or {}
local activeTrackers = {}
local placingGps = false
local monitorRunning = false
local animDict = 'amb@world_human_vehicle_mechanic@male@base'

local function notify(msg, ntype)
    ESX.ShowNotification(msg, ntype or 'info')
end

local function countActiveTrackers()
    return #activeTrackers
end

local function formatRemaining(expiresAt)
    local sec = math.max(0, math.floor((expiresAt - GetGameTimer()) / 1000))
    local min = math.floor(sec / 60)
    local rem = sec % 60
    return ('%d:%02d'):format(min, rem)
end

local function removeTrackerAt(index)
    local tracker = activeTrackers[index]
    if not tracker then return end

    if tracker.blip and DoesBlipExist(tracker.blip) then
        RemoveBlip(tracker.blip)
    end

    table.remove(activeTrackers, index)
end

local function ensureMonitorThread()
    if monitorRunning then return end
    monitorRunning = true

    CreateThread(function()
        while #activeTrackers > 0 do
            local now = GetGameTimer()

            for i = #activeTrackers, 1, -1 do
                local tracker = activeTrackers[i]
                if now >= tracker.expiresAt then
                    notify(('GPS tracker (%s) je istekao.'):format(tracker.plate or 'vozilo'), 'info')
                    removeTrackerAt(i)
                else
                    local ent = NetworkGetEntityFromNetworkId(tracker.netId)
                    if ent == 0 or not DoesEntityExist(ent) then
                        notify(('GPS tracker (%s) — vozilo vise nije dostupno.'):format(tracker.plate or 'vozilo'), 'error')
                        removeTrackerAt(i)
                    end
                end
            end

            Wait(1500)
        end

        monitorRunning = false
    end)
end

local function addTracker(netId, plate, durationSec)
    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent == 0 or not DoesEntityExist(ent) then
        notify('Vozilo nije dostupno za pracenje.', 'error')
        return false
    end

    local blip = AddBlipForEntity(ent)
    SetBlipSprite(blip, cfg.BlipSprite or 225)
    SetBlipColour(blip, cfg.BlipColor or 1)
    SetBlipScale(blip, cfg.BlipScale or 0.9)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(('GPS | %s'):format(plate or 'Vozilo'))
    EndTextCommandSetBlipName(blip)

    activeTrackers[#activeTrackers + 1] = {
        netId = netId,
        plate = plate,
        blip = blip,
        expiresAt = GetGameTimer() + ((durationSec or cfg.DurationSec or 900) * 1000),
    }

    ensureMonitorThread()
    notify(('GPS tracker postavljen na %s. Pracenje: 15 min.'):format(plate or 'vozilo'), 'success')
    return true
end

local function getNearestVehicle()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local maxDist = cfg.PlaceDistance or 4.0

    if IsPedInAnyVehicle(ped, false) then
        notify('Izadji iz vozila da postavis GPS tracker.', 'error')
        return nil
    end

    local vehicle = ESX.Game.GetClosestVehicle(coords)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        notify('Nema vozila u blizini.', 'error')
        return nil
    end

    if #(coords - GetEntityCoords(vehicle)) > maxDist then
        notify('Priblizi se vozilu.', 'error')
        return nil
    end

    return vehicle
end

local function pokreniPostavljanjeGps()
    if placingGps then return end

    if not JeSluzbenik() or not ProveriDuznost() then
        notify('Nemas ovlasti za GPS tracker.', 'error')
        return
    end

    if countActiveTrackers() >= (cfg.MaxActive or 2) then
        notify(('Mozes pratiti najvise %d vozila istovremeno.'):format(cfg.MaxActive or 2), 'error')
        return
    end

    local vehicle = getNearestVehicle()
    if not vehicle then return end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if not netId or netId == 0 then
        notify('Vozilo nije dostupno.', 'error')
        return
    end

    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

    placingGps = true
    local ped = PlayerPedId()
    LoadAnimDict(animDict)
    TaskTurnPedToFaceEntity(ped, vehicle, 500)
    Wait(400)
    TaskPlayAnim(ped, animDict, 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

    local success = lib.progressBar({
        duration = cfg.ProgressMs or 8000,
        label = 'Postavljas GPS tracker...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true, mouse = false },
    })

    ClearPedTasks(ped)
    placingGps = false

    if not success then
        notify('Postavljanje GPS trackera prekinuto.', 'error')
        return
    end

    local ok, durationSec = lib.callback.await('jamaica-sluzbe:placeGpsTracker', false, netId, plate)
    if not ok then
        notify(durationSec or 'GPS tracker nije postavljen.', 'error')
        return
    end

    addTracker(netId, plate, durationSec)
end

local function otvoriGpsMeni()
    if not JeSluzbenik() or not ProveriDuznost() then
        notify('Nemas ovlasti za GPS tracker.', 'error')
        return
    end

    local options = {
        {
            title = 'Postavi GPS na vozilo',
            description = 'Prati najblize vozilo (max ' .. (cfg.MaxActive or 2) .. ')',
            icon = 'location-dot',
            onSelect = pokreniPostavljanjeGps,
        },
    }

    for i = 1, #activeTrackers do
        local tracker = activeTrackers[i]
        local idx = i
        options[#options + 1] = {
            title = tracker.plate or ('Tracker #' .. i),
            description = 'Preostalo: ' .. formatRemaining(tracker.expiresAt),
            icon = 'satellite-dish',
            onSelect = function()
                removeTrackerAt(idx)
                notify('GPS tracker uklonjen.', 'info')
            end,
        }
    end

    lib.registerContext({
        id = 'jamaica_sluzbe_gps',
        title = 'GPS Tracker',
        options = options,
    })
    lib.showContext('jamaica_sluzbe_gps')
end

RegisterNetEvent('jamaica-sluzbe:client:openGpsMenu', otvoriGpsMeni)

exports('useGpsTracker', function()
    if placingGps then return end
    CreateThread(pokreniPostavljanjeGps)
end)

exports('OpenSluzbeGpsMenu', otvoriGpsMeni)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for i = #activeTrackers, 1, -1 do
        removeTrackerAt(i)
    end
end)
