local warActive = false
local warEnemyBlips = {}
local warBlipThread = nil

local function removeWarBlips()
    for i = 1, #warEnemyBlips do
        if DoesBlipExist(warEnemyBlips[i]) then
            RemoveBlip(warEnemyBlips[i])
        end
    end
    warEnemyBlips = {}
end

local function stopWarBlipLoop()
    warActive = false
    removeWarBlips()
    warBlipThread = nil
end

local function createEnemyBlip(coords, name)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 303)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name or 'Protivnik')
    EndTextCommandSetBlipName(blip)
    warEnemyBlips[#warEnemyBlips + 1] = blip
end

local function startWarBlipLoop()
    if warBlipThread then return end
    warActive = true
    warBlipThread = CreateThread(function()
        local refresh = (Config.Ratovi and Config.Ratovi.BlipRefreshMs) or 2000
        while warActive do
            TriggerServerEvent('jamaica_mafije:requestWarEnemyBlips')
            Wait(refresh)
        end
        warBlipThread = nil
    end)
end

RegisterNetEvent('jamaica_mafije:syncWarEnemyBlips')
AddEventHandler('jamaica_mafije:syncWarEnemyBlips', function(blipsList)
    if not warActive then return end
    removeWarBlips()
    if not blipsList then return end
    for i = 1, #blipsList do
        local entry = blipsList[i]
        if entry.coords then
            createEnemyBlip(entry.coords, entry.name)
        end
    end
end)

RegisterNetEvent('jamaica_mafije:warStarted')
AddEventHandler('jamaica_mafije:warStarted', function()
    startWarBlipLoop()
    if MafiaNotify then
        MafiaNotify('Rat je poceo! Protivnici su vidljivi na mapi.', 'warning', 8000)
    end
end)

RegisterNetEvent('jamaica_mafije:warEnded')
AddEventHandler('jamaica_mafije:warEnded', function()
    stopWarBlipLoop()
    SendNUIMessage({ type = 'warHudHide' })
end)

RegisterNetEvent('jamaica_mafije:warHudUpdate')
AddEventHandler('jamaica_mafije:warHudUpdate', function(data)
    SendNUIMessage({
        type = 'warHudShow',
        attackerLabel = data.attackerLabel,
        defenderLabel = data.defenderLabel,
        attackerKills = data.attackerKills,
        defenderKills = data.defenderKills,
        endsUnix = data.endsUnix,
    })
end)

local function syncMyActiveWar()
    if not ESX or not ESX.TriggerServerCallback then return end
    ESX.TriggerServerCallback('jamaica_mafije:getMyActiveWar', function(war)
        if not war then return end
        startWarBlipLoop()
        SendNUIMessage({
            type = 'warHudShow',
            attackerLabel = war.attackerLabel,
            defenderLabel = war.defenderLabel,
            attackerKills = war.attackerKills,
            defenderKills = war.defenderKills,
            endsUnix = war.endsUnix,
        })
    end)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if not warActive then return end
    local killerId = 0
    if data then
        killerId = data.killerServerId or data.killerId or 0
    end
    if not killerId or killerId == 0 then
        local ped = PlayerPedId()
        local killerPed = GetPedSourceOfDeath(ped)
        if killerPed and killerPed ~= ped and DoesEntityExist(killerPed) and IsPedAPlayer(killerPed) then
            local idx = NetworkGetPlayerIndexFromPed(killerPed)
            if idx and idx >= 0 then
                killerId = GetPlayerServerId(idx)
            end
        end
    end
    TriggerServerEvent('jamaica_mafije:warPlayerDied', killerId)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    SetTimeout(2500, syncMyActiveWar)
end)

CreateThread(function()
    Wait(4000)
    syncMyActiveWar()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        stopWarBlipLoop()
        SendNUIMessage({ type = 'warHudHide' })
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        SendNUIMessage({ type = 'warHudHide' })
    end
end)
