local ESX = exports['es_extended']:getSharedObject()

local isOpen = false
local tabletProp = nil
local myWantedLevel = 0
local suspectBlips = {}

local ANIM_DICT = 'amb@world_human_seat_wall_tablet@female@base'
local ANIM_NAME = 'base'
local BONE_HAND = 57005

local POLICE_JOBS = {
    police = true,
}

local function isPoliceJob(jobName)
    return POLICE_JOBS[jobName] == true
end

local function hasAccess(playerData)
    if not playerData or not playerData.job then return false end
    if isPoliceJob(playerData.job.name) then return true end
    return Config.TabletOwners and Config.TabletOwners[playerData.identifier] == true
end

local function attachTabletProp()
    if tabletProp then return end
    CreateThread(function()
        RequestAnimDict(ANIM_DICT)
        while not HasAnimDictLoaded(ANIM_DICT) do Wait(0) end

        local ped = PlayerPedId()
        local model = joaat('prop_cs_tablet')
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        tabletProp = CreateObject(model, 0.0, 0.0, 0.0, true, true, true)
        AttachEntityToEntity(tabletProp, ped, GetPedBoneIndex(ped, BONE_HAND),
            0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, ANIM_DICT, ANIM_NAME, 8.0, -8.0, -1, 50, 0, false, false, false)
        SetModelAsNoLongerNeeded(model)
    end)
end

local function detachTabletProp()
    local ped = PlayerPedId()
    StopAnimTask(ped, ANIM_DICT, ANIM_NAME, 8.0)
    if tabletProp and DoesEntityExist(tabletProp) then
        DeleteEntity(tabletProp)
        tabletProp = nil
    end
end

local function closeTablet()
    if not isOpen then return end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    detachTabletProp()
    isOpen = false
end

local function openTablet()
    local playerData = ESX.GetPlayerData()
    if not hasAccess(playerData) then
        lib.notify({ title = 'MDT', description = 'Nemate pristup tabletu.', type = 'error', position = 'top' })
        return
    end
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', job = playerData.job.name })
    CreateThread(attachTabletProp)
    isOpen = true
end

RegisterCommand('tablet', function()
    if isOpen then closeTablet() else openTablet() end
end, false)

RegisterNUICallback('close', function(_, cb)
    closeTablet()
    cb({})
end)

for _, name in ipairs({
    'searchPlayer', 'getActivePD', 'getOnlinePlayers', 'searchByPlate', 'getAllWarrants',
    'getPlayerByIdentifier', 'getNotes', 'getWarrantComments', 'getPlayerById',
    'getBolo', 'getBoloComments', 'getEvidencija', 'getChatHistory', 'getWantedList',
}) do
    RegisterNUICallback(name, function(data, cb)
        local args = {}
        if name == 'searchPlayer' then args = { data.query }
        elseif name == 'searchByPlate' then args = { data.plate }
        elseif name == 'getAllWarrants' then args = { data.forceRefresh }
        elseif name == 'getPlayerByIdentifier' or name == 'getNotes' then args = { data.identifier }
        elseif name == 'getWarrantComments' then args = { data.warrantId }
        elseif name == 'getPlayerById' then args = { data.id }
        elseif name == 'getBoloComments' then args = { data.boloId }
        end
        ESX.TriggerServerCallback('jamaica-tablet:' .. name, cb, table.unpack(args))
    end)
end

RegisterNUICallback('addNote', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:addNote', function(ok) cb({ success = ok }) end, data.identifier, data.note)
end)

RegisterNUICallback('deleteNote', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:deleteNote', function(ok) cb({ success = ok }) end, data.noteId)
end)

RegisterNUICallback('addWarrant', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:addWarrant', function(ok) cb({ success = ok }) end, data.identifier, data.tip, data.razlog)
end)

RegisterNUICallback('revokeWarrant', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:revokeWarrant', function(ok) cb({ success = ok }) end, data.warrantId)
end)

RegisterNUICallback('addWarrantComment', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:addWarrantComment', function(ok) cb({ success = ok }) end, data.warrantId, data.tekst)
end)

RegisterNUICallback('deleteWarrantComment', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:deleteWarrantComment', function(ok) cb({ success = ok }) end, data.commentId)
end)

RegisterNUICallback('postBolo', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:postBolo', function() cb({}) end, data.type, data.desc, data.location)
end)

RegisterNUICallback('resolveBolo', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:resolveBolo', function() cb({}) end, data.id)
end)

RegisterNUICallback('deleteBolo', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:deleteBolo', function() cb({}) end, data.id)
end)

RegisterNUICallback('addBoloComment', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:addBoloComment', function(ok) cb({ success = ok }) end, data.boloId, data.tekst)
end)

RegisterNUICallback('sendChatMessage', function(data, cb)
    ESX.TriggerServerCallback('jamaica-tablet:sendChatMessage', function() cb({}) end, data.text)
end)

RegisterNUICallback('trackSuspect', function(data, cb)
    local identifier = data.identifier
    local coords = data.coords
    if suspectBlips[identifier] and DoesBlipExist(suspectBlips[identifier]) then
        RemoveBlip(suspectBlips[identifier])
        suspectBlips[identifier] = nil
    end
    if not coords then cb({}) return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local dx = coords.x - Config.CityCenter.x
    local dy = coords.y - Config.CityCenter.y
    local inCity = math.sqrt(dx * dx + dy * dy) < Config.CityRadius

    SetBlipSprite(blip, inCity and 480 or 1)
    SetBlipScale(blip, inCity and 1.5 or 0.8)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('BJEGUNAC (POTJERNICA)')
    EndTextCommandSetBlipName(blip)

    suspectBlips[identifier] = blip
    TriggerServerEvent('jamaica-tablet:startTracking', identifier)
    cb({})
end)

RegisterNUICallback('removeBlip', function(data, cb)
    local blip = suspectBlips[data.identifier]
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
        suspectBlips[data.identifier] = nil
    end
    TriggerServerEvent('jamaica-tablet:stopTracking', data.identifier)
    cb({})
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    CreateThread(function()
        while IsScreenFadedOut() do Wait(200) end
        Wait(3000)
        TriggerServerEvent('jamaica-tablet:requestWantedStatus')
    end)
end)

AddEventHandler('playerSpawned', function()
    if tabletProp and DoesEntityExist(tabletProp) then
        DeleteEntity(tabletProp)
        tabletProp = nil
    end
    CreateThread(function()
        Wait(3000)
        TriggerServerEvent('jamaica-tablet:requestWantedStatus')
    end)
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('jamaica-tablet:chatMessage', function(msg)
    SendNUIMessage({ action = 'chatMessage', message = msg })
end)

RegisterNetEvent('jamaica-tablet:newBolo', function(bolo)
    SendNUIMessage({ action = 'newBolo', bolo = bolo })
end)

RegisterNetEvent('jamaica-tablet:boloDeleted', function(id)
    SendNUIMessage({ action = 'boloDeleted', id = id })
end)

RegisterNetEvent('jamaica-tablet:boloResolved', function(id)
    SendNUIMessage({ action = 'boloResolved', id = id })
end)

RegisterNetEvent('jamaica-tablet:newWarrant', function(_)
    if not isOpen then return end
    lib.notify({ title = 'Nova potjernica', description = 'Ažuriranje liste...', type = 'warning', position = 'top' })
    SendNUIMessage({ action = 'newWarrant' })
end)

RegisterNetEvent('jamaica-tablet:newEvidencija', function()
    if isOpen then SendNUIMessage({ action = 'newEvidencija' }) end
end)

RegisterNetEvent('jamaica-tablet:recordRemoved', function(data)
    SendNUIMessage({ action = 'recordRemoved', data = data })
    if isOpen and data and data.source == 'haker' then
        lib.notify({ title = 'MDT', description = 'Dosije ažuriran — haker obrisao zapis.', type = 'warning', position = 'top' })
    end
end)

RegisterNetEvent('jamaica-tablet:wantedLevelUpdate', function(stars)
    myWantedLevel = stars
end)

RegisterNetEvent('jamaica-tablet:newSuspect', function(name, stars, victimName, victimSteam, steamName)
    SendNUIMessage({
        action = 'newSuspect',
        name = name,
        stars = stars,
        victimName = victimName or '',
        victimSteam = victimSteam or '',
        steamName = steamName or '',
    })
end)

RegisterNetEvent('jamaica-tablet:suspectUpdate', function(identifier, data)
    SendNUIMessage({ action = 'suspectUpdate', identifier = identifier, data = data })
end)

RegisterNetEvent('jamaica-tablet:suspectCoords', function(identifier, x, y, z)
    local blip = suspectBlips[identifier]
    if not blip or not DoesBlipExist(blip) then return end
    SetBlipCoords(blip, x, y, z)
    local dx = x - Config.CityCenter.x
    local dy = y - Config.CityCenter.y
    local inCity = math.sqrt(dx * dx + dy * dy) < Config.CityRadius
    SetBlipSprite(blip, inCity and 480 or 1)
    SetBlipScale(blip, inCity and 1.5 or 0.8)
    SetBlipColour(blip, 1)
end)

RegisterNetEvent('jamaica-tablet:suspectCleared', function(identifier)
    local blip = suspectBlips[identifier]
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
        suspectBlips[identifier] = nil
    end
    SendNUIMessage({ action = 'suspectCleared', identifier = identifier })
end)

CreateThread(function()
    while true do
        Wait(Config.LocationUpdateMs)
        if myWantedLevel > 0 then
            local c = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('jamaica-tablet:updateSuspectLocation', c.x, c.y, c.z)
        end
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    closeTablet()
end)
