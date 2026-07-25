local RNE = RegisterNetEvent

local config = require 'shared'

local aktivniMugshot = nil
local fpsBoostAktivan = false

local oslobodiMugshot = function()
    if aktivniMugshot then
        UnregisterPedheadshot(aktivniMugshot)
        aktivniMugshot = nil
    end
end

local resetujFpsBoost = function()
    fpsBoostAktivan = false
    SetTimecycleModifier()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
end

local toggleFpsBoost = function()
    fpsBoostAktivan = not fpsBoostAktivan

    if fpsBoostAktivan then
        SetTimecycleModifier('yell_tunnel_nodirect')
        ESX.ShowNotification('FPS Boost uključen')
        CreateThread(function()
            while fpsBoostAktivan do
                OverrideLodscaleThisFrame(0.8)
                Wait(0)
            end
        end)
    else
        resetujFpsBoost()
        ESX.ShowNotification('FPS Boost isključen')
    end
end

AddEventHandler("onResourceStop", function(res)
    if GetCurrentResourceName() == res then
        if ESX and ESX.UI and ESX.UI.Menu then
            ESX.UI.Menu.CloseAll()
        end
        oslobodiMugshot()
        resetujFpsBoost()
    end
end)

local cursor = function(bl)
    SetNuiFocus(bl, bl)
end

local uzmiMugshotSaServerId = function(serverId)
    if not serverId then return nil end

    local playerIdx = GetPlayerFromServerId(serverId)
    if playerIdx == -1 then return nil end

    local ped = GetPlayerPed(playerIdx)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return nil end

    oslobodiMugshot()

    local handle, txd = ESX.Game.GetPedMugshot(ped, true)
    if not handle or not txd then return nil end

    aktivniMugshot = handle
    return ('https://nui-img/%s/%s'):format(txd, txd)
end

local uzmiMugshotUrl = function()
    return uzmiMugshotSaServerId(GetPlayerServerId(PlayerId()))
end

local normalizujId = function(id)
    if not id then return nil end
    if type(id) == 'string' and id:find('license:') then
        return id:gsub('license:', '')
    end
    return id
end

local jeSvojDokument = function(citizenid)
    local playerData = ESX.GetPlayerData()
    if not playerData or not playerData.identifier or not citizenid then
        return false
    end
    return normalizujId(playerData.identifier) == normalizujId(citizenid)
end

RegisterNUICallback('zatvori', function()
    cursor(false)
    oslobodiMugshot()
end)

local obogatiPodatkeDokumenta = function(data)
    if not data then return end
    if data.sex or data.pol then return end
    if not jeSvojDokument(data.citizenid) then return end
    local pd = ESX.GetPlayerData()
    if pd and pd.sex ~= nil then
        data.sex = pd.sex
    end
end

otvoriDokument = function(tip, data)
    if not data then return end
    obogatiPodatkeDokumenta(data)
    cursor(true)
    local slika = data.slika

    if not slika and data.citizenid then
        slika = lib.callback.await('jamaica-dokumenti:server:getajSlike', false, data.citizenid, tip)
    end

    if not slika and jeSvojDokument(data.citizenid) then
        slika = uzmiMugshotUrl()
    end

    if not slika and data.showServerId then
        slika = uzmiMugshotSaServerId(data.showServerId)
    end

    Wait(100)

    SendNUIMessage({
        akcija = tip,
        info = data,
        slika = slika
    })
end


RNE('jamaica-dokumenti:client:PrikaziDokument', function(tip, data)
    local igrac, distanca = ESX.Game.GetClosestPlayer()
    if igrac ~= -1 and distanca <= 3.0 then
        local targetServerId = GetPlayerServerId(igrac)
        ESX.ShowNotification('Pokazali ste vas dokument.')
        TriggerServerEvent('jamaica-dokumenti:server:PrikaziDrugomIgracu', targetServerId, tip, data)
    else
        otvoriDokument(tip, data)
    end
end)

RNE('jamaica-dokumenti:client:PrikaziDokument2', function(tip, data)
    otvoriDokument(tip, data)
end)

CreateThread(function()
    exports.ox_inventory:displayMetadata({
        ime = 'Ime',
        citizenid = 'Citizen ID',
        datum_rodjenja = 'Datum rodjenja',
        nacionalnost = 'Nacionalnost',
    })
end)

RegisterKeyMapping('meniDokumenti', 'Meni F9', 'keyboard', 'F9')
RegisterCommand('meniDokumenti', function()
    OtvoriMeniDokumenti()
end)


OtvoriMeniDokumenti = function()
    local playerData = ESX.GetPlayerData()
    local job = playerData.job.name
    local hasAllowedJob = config.SluzbeneZnacke.jobs[job] == true

    local chatOff = GetResourceState('jamaica-chat') == 'started' and exports['jamaica-chat']:IsChatDisabled()
    local elements = {
        {label = chatOff and '🔊 Upali chat' or '🔇 Ugasi chat', value = 'toggle_chat'},
        {label = fpsBoostAktivan and '⚡ FPS Boost (uključen)' or '⚡ FPS Boost', value = 'fps_boost'},
    }

    if hasAllowedJob then
        table.insert(elements, {label = '🛡️ Službena značka', value = 'sluzbena_znacka'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dokumenti_glavni_meni',
    {
        title = '📋 Meni (F9)',
        align = 'right-center',
        elements = elements
    }, function(data, menu)
        local izabrani = data.current.value

        if izabrani == 'toggle_chat' then
            menu.close()
            if GetResourceState('jamaica-chat') ~= 'started' then
                ESX.ShowNotification('Chat trenutno nije dostupan.')
                return
            end
            local disabled = exports['jamaica-chat']:IsChatDisabled()
            exports['jamaica-chat']:SetChatDisabled(not disabled)
        elseif izabrani == 'fps_boost' then
            menu.close()
            toggleFpsBoost()
        elseif izabrani == 'sluzbena_znacka' then
            MeniZaSluzbenuZnacku()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local pokreniAnimacijuZnacke = function()
    local ped = PlayerPedId()
    local animDict = 'paper_1_rcm_alt1-9'
    RequestAnimDict(animDict)
    local timeout = 0
    while not HasAnimDictLoaded(animDict) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    if HasAnimDictLoaded(animDict) then
        TaskPlayAnim(ped, animDict, 'player_one_dual-9', 8.0, -8.0, -1, 49, 0, false, false, false)
    end
end

local prikaziSluzbenuZnacku = function(akcija)
    local pData = lib.callback.await('jamaica-dokumenti:server:getZnackaData', false)
    if not pData then
        ESX.ShowNotification('Nemate pristup službenoj značci za vaš posao.')
        return
    end

    if akcija == 'pogledaj' then
        ESX.UI.Menu.CloseAll()
        otvoriDokument('sluzbena_znacka', pData)
        ESX.ShowNotification('Pogledali ste svoju službenu značku.')
    elseif akcija == 'pokazi' then
        ESX.UI.Menu.CloseAll()
        local igrac, distanca = ESX.Game.GetClosestPlayer()
        if igrac ~= -1 and distanca <= 3.0 then
            local targetServerId = GetPlayerServerId(igrac)
            ESX.ShowNotification('Pokazujete vašu službenu značku.')
            pokreniAnimacijuZnacke()
            TriggerServerEvent('jamaica-dokumenti:server:PrikaziDrugomIgracu', targetServerId, 'sluzbena_znacka', pData)
        else
            ESX.ShowNotification('Nema ljudi u vašoj blizini.')
        end
    end
end

MeniZaSluzbenuZnacku = function()
    local elements = {
        {label = '👀 Pogledaj svoju službenu značku', value = 'pogledaj_svoju_znacku'},
        {label = '👁️ Pokaži službenu značku', value = 'pokazi_znacku'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'znacka_meni',
    {
        title = '🛡️ Službena značka',
        align = 'right-center',
        elements = elements
    }, function(data, menu)
        local akcija = data.current.value
        if akcija == 'pogledaj_svoju_znacku' then
            prikaziSluzbenuZnacku('pogledaj')
        elseif akcija == 'pokazi_znacku' then
            prikaziSluzbenuZnacku('pokazi')
        end
    end, function(data, menu)
        menu.close()
        OtvoriMeniDokumenti()
    end)
end