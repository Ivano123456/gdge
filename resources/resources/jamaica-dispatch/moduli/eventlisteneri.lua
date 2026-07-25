local tajmercic = {}
local config = require 'shared.main'
local Core = require 'shared.frameworks.client'

local function Tajmer(name, action)
    if not config.DefaultAlerts[name] then return end
    if tajmercic[name] then return end

    if not action() then return end

    tajmercic[name] = true
    SetTimeout((config.Cooldowns[name] or 5) * 1000, function()
        tajmercic[name] = false
    end)
end

local function jelPedSvedok(witnesses, ped)
    if not witnesses then return true end
    for _, v in pairs(witnesses) do
        if v == ped then
            return true
        end
    end
    return false
end

local function nijePolicija()
    return not ImaPravoNaPoziv(Core.Posao(), config.PolicijskiPoslovi)
end

local dozvoljenaOruzja = {}
for i = 1, #config.DozvoljenaOruzja do
    dozvoljenaOruzja[joaat(config.DozvoljenaOruzja[i])] = true
end

local function ZabranjenaOruzja(ped)
    return dozvoljenaOruzja[GetSelectedPedWeapon(ped)] == true
end

if config.DefaultAlerts.Shooting then
    AddEventHandler('CEventGunShot', function(witnesses, ped)
        if cache.ped ~= ped then return end
        if IsPedCurrentWeaponSilenced(ped) then return end
        if ZabranjenaOruzja(ped) then return end

        Tajmer('Shooting', function()
            if not nijePolicija() then return false end
            if not jelPedSvedok(witnesses, ped) then return false end

            if cache.vehicle then
                PucnjavaVozila()
            else
                Pucnjava()
            end
            return true
        end)
    end)
end

if config.Dodaci['Tucnjava'] and config.DefaultAlerts.Melee then
    AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, ped)
        if cache.ped ~= ped then return end
        if not IsPedInMeleeCombat(ped) then return end

        Tajmer('Melee', function()
            if not nijePolicija() then return false end
            if not jelPedSvedok(witnesses, ped) then return false end

            Tucnjava()
            return true
        end)
    end)
end

if config.Dodaci['OtimanjeVozila'] and config.DefaultAlerts.Autotheft then
    AddEventHandler('CEventPedJackingMyVehicle', function(_, ped)
        if cache.ped ~= ped then return end

        Tajmer('AutotheftJack', function()
            if not nijePolicija() then return false end

            OtimanjeVozila()
            return true
        end)
    end)
end

if config.Dodaci['ObijanjeVozila'] and config.DefaultAlerts.Autotheft then
    AddEventHandler('CEventShockingCarAlarm', function(_, ped)
        if cache.ped ~= ped then return end

        Tajmer('AutotheftAlarm', function()
            if not nijePolicija() then return false end

            ObijanjeVozila()
            return true
        end)
    end)
end

if config.Dodaci['Eksplozija'] and config.DefaultAlerts.Explosion then
    AddEventHandler('CEventExplosionHeard', function(witnesses, ped)
        if cache.ped ~= ped then return end
        if not jelPedSvedok(witnesses, ped) then return end

        Tajmer('Explosion', function()
            if not nijePolicija() then return false end

            Eksplozija()
            return true
        end)
    end)
end

local exemptVehicleClass = {
    [15] = true,
    [16] = true,
}

local SpeedTrigger = 0

if config.Dodaci['PrekoracenjeBrzine'] and config.DefaultAlerts.Speeding then
    local SpeedingEvents = {
        'CEventShockingCarChase',
        'CEventShockingDrivingOnPavement',
        'CEventShockingBicycleOnPavement',
        'CEventShockingMadDriverBicycle',
        'CEventShockingMadDriverExtreme',
        'CEventShockingEngineRevved',
        'CEventShockingInDangerousVehicle'
    }

    for i = 1, #SpeedingEvents do
        AddEventHandler(SpeedingEvents[i], function(_, ped)
            if cache.ped ~= ped then return end

            Tajmer('Speeding', function()
                local currentTime = GetGameTimer()
                if currentTime - SpeedTrigger < 10000 then
                    return false
                end

                if not nijePolicija() then return false end
                if not cache.vehicle then return false end

                local vehicleClass = GetVehicleClass(cache.vehicle)
                if exemptVehicleClass[vehicleClass] then return false end
                if GetEntitySpeed(cache.vehicle) * 3.6 < (80 + math.random(0, 20)) then return false end
                if cache.ped ~= GetPedInVehicleSeat(cache.vehicle, -1) then return false end

                PrekoracenjeBrzine()
                SpeedTrigger = currentTime
                return true
            end)
        end)
    end
end
