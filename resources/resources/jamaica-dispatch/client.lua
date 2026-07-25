local config = require 'shared.main'
local Core = require 'shared.frameworks.client'
local poslednjiPanicPoziv = 0 
local panicCooldown = config.Cooldowns['panic_button'] * 1000 

function ImaPravoNaPoziv(playerJob, poslovi)
    if not playerJob then return false end
    if type(poslovi) == "string" then
        return playerJob == poslovi
    elseif type(poslovi) == "table" then
        for _, job in pairs(poslovi) do
            if playerJob == job then
                return true
            end
        end
    end
    return false
end

local function coordsToTable(coords)
    if not coords then return nil end
    local x = coords.x or coords[1]
    local y = coords.y or coords[2]
    local z = coords.z or coords[3]
    if not x or not y or not z then return nil end
    return { x = x + 0.0, y = y + 0.0, z = z + 0.0 }
end

local activeBlips = {}

AddEventHandler("onResourceStop", function(res)
    if GetCurrentResourceName() ~= res then return end
    DeleteWaypoint()
    for i = #activeBlips, 1, -1 do
        RemoveBlip(activeBlips[i].main)
        RemoveBlip(activeBlips[i].radius)
        activeBlips[i] = nil
    end
end)

RegisterNetEvent(config.EventListeneri.onPlayerDeath, function()
    if config.Dodaci['PanicButton']['naSmrtiIgraca'] then
        panicFunkcija()
    end
end)

KreirajPoziv = function(data)
    if not data then return end 
    TriggerServerEvent("jamaica-dispatch:server:SetupajDispatch", data)
end

RegisterNetEvent("jamaica-dispatch:client:SetupajDispatch", function(data)
    if not data or type(data) ~= 'table' then return end
    local posao = Core.Posao()
    if not ImaPravoNaPoziv(posao, data.posao) then return end

    -- vector3/userdata ne sme u NUI — json/msgpack često dropuje ceo message
    SendNUIMessage({
        akcija = 'show',
        title = data.title,
        description = data.description,
        ulica = data.ulica,
        tip = data.tip,
        kod = data.kod,
        coords = coordsToTable(data.coords),
    })
end)

exports('KreirajPoziv', KreirajPoziv)

RegisterNetEvent("jamaica-dispatch:client:KreirajBlip", function(data)
    if not data or type(data) ~= 'table' or not data.blip then return end
    local posao = Core.Posao()
    if not ImaPravoNaPoziv(posao, data.posao) then return end

    local c = coordsToTable(data.coords)
    if not c then return end

    local blip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(blip, data.blip.sprite)
    SetBlipColour(blip, data.blip.boja)
    SetBlipScale(blip, data.blip.velicina)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.blip.text or data.title or 'Dispatch')
    EndTextCommandSetBlipName(blip)

    local radiusBlip = AddBlipForRadius(c.x, c.y, c.z, 100.0)
    SetBlipColour(radiusBlip, data.blip.boja)
    SetBlipAlpha(radiusBlip, 128)

    table.insert(activeBlips, { main = blip, radius = radiusBlip })

    if data.vremeBlipa and data.vremeBlipa > 0 then
        SetTimeout(data.vremeBlipa * 60000, function()
            for i, v in ipairs(activeBlips) do
                if v.main == blip and v.radius == radiusBlip then
                    RemoveBlip(v.main)
                    RemoveBlip(v.radius)
                    table.remove(activeBlips, i)
                    break
                end
            end
        end)
    end
end)

RegisterNetEvent("jamaica-dispatch:client:SendajPozivUpomoz", function(coords)
    local posao = Core.Posao()
    if ImaPravoNaPoziv(posao, config.PolicijskiPoslovi) then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 161)
        SetBlipScale(blip, 1.5)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(locale('call_blips.panic_button'))
        EndTextCommandSetBlipName(blip)
        
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)

        SetTimeout(config.Cooldowns['remove_panic_blip'] * 1000, function()
            RemoveBlip(blip)
        end)
    end

end)

if config.Dodaci['PanicButton']['enablajKomandu'] then 
    RegisterCommand(config.panicButtonCommand, function()
        panicFunkcija()
    end, false)

    if config.panicButtonKey and config.panicButtonKey ~= '' then
        RegisterKeyMapping(config.panicButtonCommand, 'Panic dugme', 'keyboard', config.panicButtonKey)
    end
end

panicFunkcija = function()
    local trenutnoVreme = GetGameTimer() 
    local proteklo = trenutnoVreme - poslednjiPanicPoziv

    local posao = Core.Posao()
    if ImaPravoNaPoziv(posao, config.PolicijskiPoslovi) then 

        if proteklo < panicCooldown then
            local vremeOstatak = math.ceil((panicCooldown - proteklo) / 1000)
            Core.Notifikacija(locale('cooldown_panicbutton'):format(math.floor(vremeOstatak)))
            return
        end

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local ulicaHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z) 
        local ulicaIme = GetStreetNameFromHashKey(ulicaHash) 

        KreirajPoziv({
            title = locale('pomoc'),
            description = locale('policajac_povredjen'),
            posao = config.PolicijskiPoslovi, 
            vremeBlipa = 2, 
            coords = coords, 
            ulica = ulicaIme, 
            kod = config.SluzbeniKodovi['ranjen_policajac'],
            tip = "SOS", 
        })

        TriggerServerEvent("jamaica-dispatch:server:PanicButton")

        poslednjiPanicPoziv = GetGameTimer()
    end
end

local function ImaDispatchPrava()
    local posao = Core.Posao()
    return ImaPravoNaPoziv(posao, config.PolicijskiPoslovi)
        or ImaPravoNaPoziv(posao, config.AmbulancijskiPoslovi)
end

RegisterCommand('pritisnuo_g_dispatch', function()
    if not ImaDispatchPrava() then return end
    SendNUIMessage({ akcija = "pritisnuo_g" })
end)
RegisterKeyMapping('pritisnuo_g_dispatch', "pritisnuo_g_dispatch", "keyboard", 'G')

RegisterCommand('pritisnuo_c_dispatch', function()
    if not ImaDispatchPrava() then return end
    SendNUIMessage({ akcija = "pritisnuo_c" })
end)
RegisterKeyMapping('pritisnuo_c_dispatch', "pritisnuo_c_dispatch", "keyboard", 'C')

RegisterCommand('pritisnuo_m_dispatch', function()
    if not ImaDispatchPrava() then return end
    SendNUIMessage({ akcija = "pritisnuo_m" })
end)
RegisterKeyMapping('pritisnuo_m_dispatch', "pritisnuo_m_dispatch", "keyboard", 'M')

RegisterNUICallback('prikaziMapu', function(_, cb)
    cb('ok')
    CreateThread(function()
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
        Wait(100)
        PauseMenuceptionGoDeeper(149)
        while true do
            Wait(10)
            if IsControlJustPressed(0, 200) then
                SetFrontendActive(0)
                break
            end
        end
    end)
end)

RegisterNUICallback('prihvatiDispatch', function(data, cb)
    cb('ok')
    if data and data.x and data.y then
        SetNewWaypoint(data.x + 0.0, data.y + 0.0)
    end
    Core.Notifikacija(locale('dispatch_accepted'))
end)

RegisterNUICallback('otkazaoDispatch', function(_, cb)
    cb('ok')
    Core.Notifikacija(locale('dispatch_canceled'))
end)