ESX = exports['es_extended']:getSharedObject()

local sellBlocked = false
local menuOpen = false
local usedPeds = {}
local targetRegistered = false

local function getPedKey(entity)
    if not entity or entity == 0 then return nil end
    if NetworkGetEntityIsNetworked(entity) then
        local netId = NetworkGetNetworkIdFromEntity(entity)
        if netId and netId ~= 0 then
            return ('n:%s'):format(netId)
        end
    end
    return ('e:%s'):format(entity)
end

local function isBlockedJob()
    local data = ESX.PlayerData
    if not data or not data.job then return false end
    return Config.BlockedJobs[data.job.name] == true
end

local function isInBlacklistZone(coords)
    for i = 1, #Config.BlacklistZones do
        local zone = Config.BlacklistZones[i]
        if #(coords - zone.coords) <= zone.radius then
            return true
        end
    end
    return false
end

local function isValidNpcPed(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return false
    end
    if entity == PlayerPedId() then
        return false
    end
    if IsPedAPlayer(entity) or not IsPedHuman(entity) or IsEntityDead(entity) then
        return false
    end
    if IsPedInAnyVehicle(entity, false) then
        return false
    end
    local key = getPedKey(entity)
    if key and usedPeds[key] then
        return false
    end
    return true
end

local function getDrugCount(item)
    local ok, count = pcall(function()
        return exports.ox_inventory:Search('count', item)
    end)
    if not ok or not count then return 0 end
    return count
end

local function getStreetName(coords)
    local hash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local name = GetStreetNameFromHashKey(hash)
    if name == '' then
        return 'Nepoznata ulica'
    end
    return name
end

local function markPedUsed(entity)
    local key = getPedKey(entity)
    if key then
        usedPeds[key] = true
    end
end

local function preparePedForSale(entity)
    if not entity or not DoesEntityExist(entity) then return end
    ClearPedTasksImmediately(entity)
    SetBlockingOfNonTemporaryEvents(entity, true)
    FreezeEntityPosition(entity, true)
    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
    TaskTurnPedToFaceEntity(entity, PlayerPedId(), 1000)
end

local function releasePed(entity, flee)
    if not entity or not DoesEntityExist(entity) then return end
    FreezeEntityPosition(entity, false)
    SetBlockingOfNonTemporaryEvents(entity, false)
    ClearPedTasks(entity)
    if flee then
        TaskSmartFleePed(entity, PlayerPedId(), 100.0, -1, false, false)
    end
end

local function playRejectReaction(entity)
    releasePed(entity, true)
end

local function openDrugMenu(entity)
    if menuOpen or not isValidNpcPed(entity) or sellBlocked then return end

    local options = {}
    for key, drug in pairs(Config.Drugs) do
        local count = getDrugCount(drug.item)
        if count > 0 then
            options[#options + 1] = {
                title = ('Prodajte %s'):format(drug.label),
                description = ('Imate: %d'):format(count),
                icon = drug.icon,
                onSelect = function()
                    if not isValidNpcPed(entity) or sellBlocked then
                        Notify(Lang('blacklisted'), 'error')
                        return
                    end

                    preparePedForSale(entity)
                    Wait(500)

                    lib.requestAnimDict(Config.AnimDict)

                    local completed = lib.progressBar({
                        duration = Config.SellDuration,
                        label = ('Prodajete %s...'):format(drug.label),
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, car = true, combat = true },
                        anim = {
                            dict = Config.AnimDict,
                            clip = Config.AnimClip,
                            flag = 49,
                        },
                    })

                    RemoveAnimDict(Config.AnimDict)

                    if not completed then
                        releasePed(entity, false)
                        Notify(Lang('cancelled'), 'error')
                        return
                    end

                    if not isValidNpcPed(entity) or sellBlocked then
                        releasePed(entity, false)
                        Notify(Lang('blacklisted'), 'error')
                        return
                    end

                    local coords = GetEntityCoords(PlayerPedId())
                    local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or 0
                    local result = lib.callback.await('jamaica_prodajadroge:sell', false, {
                        drugKey = key,
                        pedNetId = netId,
                        pedKey = getPedKey(entity),
                        coords = { x = coords.x, y = coords.y, z = coords.z },
                        street = getStreetName(coords),
                    })

                    if not result then
                        releasePed(entity, false)
                        return
                    end

                    markPedUsed(entity)

                    if result.rejected then
                        playRejectReaction(entity)
                        Notify(Lang('rejected'), 'error')
                    elseif result.success then
                        releasePed(entity, false)
                        Notify(Lang('sold'):format(result.amount, drug.label, result.payout), 'success')
                    end
                end,
            }
        end
    end

    if #options == 0 then
        Notify(Lang('no_drugs'), 'error')
        return
    end

    menuOpen = true

    lib.registerContext({
        id = 'jamaica_prodajadroge_menu',
        title = Lang('menu_title'),
        onExit = function()
            menuOpen = false
        end,
        options = options,
    })

    lib.showContext('jamaica_prodajadroge_menu')
    menuOpen = false
end

local function registerTarget()
    if targetRegistered then return end
    targetRegistered = true

    exports.ox_target:addGlobalPed({
        {
            name = 'jamaica_prodajadroge',
            icon = 'fas fa-pills',
            label = Lang('target_label'),
            distance = Config.TargetDistance,
            canInteract = function(entity)
                if sellBlocked or isBlockedJob() or menuOpen then
                    return false
                end
                return isValidNpcPed(entity)
            end,
            onSelect = function(data)
                openDrugMenu(data.entity)
            end,
        },
    })
end

CreateThread(function()
    while true do
        sellBlocked = isInBlacklistZone(GetEntityCoords(PlayerPedId()))
        Wait(500)
    end
end)

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do
        Wait(200)
    end

    while GetResourceState('ox_inventory') ~= 'started' do
        Wait(200)
    end

    if ESX.IsPlayerLoaded and not ESX.IsPlayerLoaded() then
        while not ESX.IsPlayerLoaded() do
            Wait(200)
        end
    elseif not ESX.PlayerData or not ESX.PlayerData.job then
        while not ESX.PlayerData or not ESX.PlayerData.job do
            Wait(200)
        end
    end

    registerTarget()
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    if not targetRegistered and GetResourceState('ox_target') == 'started' then
        registerTarget()
    end
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if targetRegistered then
        exports.ox_target:removeGlobalPed('jamaica_prodajadroge')
    end
end)
