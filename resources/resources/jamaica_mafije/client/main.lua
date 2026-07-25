local PlayerData, CurrentActionData, dragStatus, levelTabela = {}, {}, {}, nil
local HasAlreadyEnteredMarker, isDead, isHandcuffed = false, false, false
local LastStation, LastPart, LastPartNum, CurrentAction, CurrentActionMsg, CurrentActionCoords
local tinkykralj = TriggerServerEvent

local function formatMarkerText(text)
    if not text or text == '' then return '[E] Interakcija' end
    text = text:gsub('~INPUT_CONTEXT~', '[E]')
    text = text:gsub('~[%w_]+~', '')
    text = text:gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
    if not text:find('%[E%]') then
        text = '[E] ' .. text
    end
    return text
end

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0, 0.35 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

local function resolveMarkerCoords(part, partNum)
    if not PlayerData.job or not Config.Mafije[PlayerData.job.name] then return nil end

    local keys = {
        Armory = 'Armories',
        Vehicles = 'Vehicles',
        Helikopter = 'Helikopter',
        Brodovi = 'Brodovi',
        BossActions = 'BossActions',
        ParkirajAuto = 'ParkirajAuto',
    }

    local configKey = keys[part]
    if not configKey then return nil end

    local points = Config.Mafije[PlayerData.job.name][configKey]
    if not points or not points[partNum] then return nil end

    return points[partNum]
end

local tinkykralj2 = TriggerEvent
local RNE = RegisterNetEvent
local ADV = AddEventHandler
local OxInventory = false
dragStatus.isDragged = false
ESX = nil

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(250) end
    while ESX == nil do tinkykralj2('esx:getSharedObject', function(obj) ESX = obj end) Wait(250) end
    while ESX.GetPlayerData().job == nil do Wait(250) end
    PlayerData = ESX.GetPlayerData()
    if Config.Levelanje then
        Wait(1000)
        getajLevel()
    end
    if GetResourceState("ox_inventory") ~= 'missing' then
        OxInventory = true
    end
    Wait(1000)
    if createOrgBaseBlip then createOrgBaseBlip() end
end)

CreateThread(function()
    while 1 do
        Wait(60000)
        collectgarbage("collect")
    end
end)

RNE('esx:playerLoaded')
ADV('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RNE('esx:setJob')
ADV('esx:setJob', function(job)
    levelTabela = nil
    PlayerData.job = job
    if Config.Levelanje then
        getajLevel()
    end
    if createOrgBaseBlip then createOrgBaseBlip() end
    if job.name == 'unemployed' then
        TriggerEvent('jamaica_mafije:forceCloseNui')
    end
end)

ocistiIgraca = function(playerPed)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

RNE('jamaica_mafije:updateHouse')
ADV('jamaica_mafije:updateHouse', function(text)
    if Config.Levelanje then
        getajLevel()
        ESX.ShowNotification(text)
    end
end)

getajLevel = function()
    if Config.Levelanje then
        if Config.Mafije[PlayerData.job.name] then
            ESX.TriggerServerCallback('jamaica_mafije:getLvL', function(data)
                levelTabela = data
            end, PlayerData.job.name)
        end
    end
end

function LvL()
    local elements = {}
    if Config.Levelanje then
        if levelTabela.stats.level == 0 then
            insertuj(elements, { label = 'Level 1 (' .. Config.lvl1 .. '$)', value = 'lvl1' })
        elseif levelTabela.stats.level == 1 then
            insertuj(elements, { label = 'Level 2 (' .. Config.lvl2 .. '$)', value = 'lvl2' })
        elseif levelTabela.stats.level == 2 then
            insertuj(elements, { label = 'Level 3 (' .. Config.lvl3 .. '$)', value = 'lvl3' })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lvl', {
        title    = 'Odaberi level',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'lvl1' then
            tinkykralj("jamaica_mafije:updateLvL1", PlayerData.job.name)
            menu.close()
            getajLevel()
        end
        if data.current.value == 'lvl2' then
            tinkykralj("jamaica_mafije:updateLvL2", PlayerData.job.name)
            menu.close()
            getajLevel()
        end
        if data.current.value == 'lvl3' then
            tinkykralj("jamaica_mafije:updateLvL3", PlayerData.job.name)
            menu.close()
            getajLevel()
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = nil
    end)
end

local function openSocietyStash()
    if Config.Mafije[PlayerData.job.name]['Sifra'] and Config.KoristiSifruInv then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sifra_sefa',
            {
                title = "Sifra sefa"
            },
            function(data3, menu3)
                local sifraa = data3.value
                if sifraa == nil then
                    ESX.ShowNotification("Morate napisati sifru!!")
                elseif sifraa ~= Config.Mafije[PlayerData.job.name]['Sifra'] then
                    ESX.ShowNotification("Sifra nije tocna!")
                else
                    menu3.close()
                    exports.ox_inventory:openInventory('stash', { id = 'society_' .. PlayerData.job.name })
                end
            end, function(data3, menu3)
                menu3.close()
            end)
    else
        exports.ox_inventory:openInventory('stash', { id = 'society_' .. PlayerData.job.name })
    end
end

function OpenArmoryMenu(station)
   if OxInventory then
        openSocietyStash()
    else
        local elements = {}
        if PlayerData.job.grade_name == 'boss' and Config.Levelanje then
            insertuj(elements, { label = 'Levelanje Baze | 💼', value = 'level' })
        end
        if Config.Levelanje then
            if levelTabela.stats.level == 1 then
                insertuj(elements, { label = _U('remove_object'), value = 'get_stock' })
                insertuj(elements, { label = _U('deposit_object'), value = 'put_stock' })
            elseif levelTabela.stats.level == 2 then
                insertuj(elements, { label = _U('remove_object'), value = 'get_stock' })
                insertuj(elements, { label = _U('deposit_object'), value = 'put_stock' })
                insertuj(elements, { label = _U('buy_weapons'), value = 'buy_weapons' })
            elseif levelTabela.stats.level == 3 then
                insertuj(elements, { label = _U('remove_object'), value = 'get_stock' })
                insertuj(elements, { label = _U('deposit_object'), value = 'put_stock' })
                insertuj(elements, { label = _U('buy_weapons'), value = 'buy_weapons' })
            end
        else
            insertuj(elements, { label = _U('remove_object'), value = 'get_stock' })
            insertuj(elements, { label = _U('deposit_object'), value = 'put_stock' })
        end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
            title = _U('armory'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if data.current.value == 'get_weapon' then
                if closestPlayer ~= -1 and closestDistance > 3.5 then
                    OpenGetWeaponMenu()
                elseif GetNumberOfPlayers() == 1 then
                    OpenGetWeaponMenu()
                else
                    ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
                end
            elseif data.current.value == 'put_weapon' then
                if closestPlayer ~= -1 and closestDistance > 3.5 then
                    OpenPutWeaponMenu()
                elseif GetNumberOfPlayers() == 1 then
                    OpenPutWeaponMenu()
                else
                    ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
                end
            elseif data.current.value == 'put_stock' then
                if closestPlayer ~= -1 and closestDistance > 3.0 then
                    OpenPutStocksMenu()
                elseif GetNumberOfPlayers() == 1 then
                    OpenPutStocksMenu()
                else
                    ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
                end
            elseif data.current.value == 'get_stock' then
                if closestPlayer ~= -1 and closestDistance > 3.0 then
                    OpenGetStocksMenu()
                elseif GetNumberOfPlayers() == 1 then
                    OpenGetStocksMenu()
                else
                    ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
                end
            elseif data.current.value == 'buy_weapons' then
                OpenBuyWeaponsMenu()
            elseif data.current.value == 'level' then
                LvL()
            end
        end, function(data, menu)
            menu.close()
            CurrentAction = 'menu_armory'
            CurrentActionMsg = _U('open_armory')
            CurrentActionData = { station = station }
        end)
    end
end

StvoriVozilo = function(vozilo, spawnType)
    local ped = PlayerPedId()
    local mafiaCfg = Config.Mafije[PlayerData.job.name]
    local spawnCoords = mafiaCfg["Vehicles"][1]

    if spawnType == 'helicopters' and mafiaCfg['Helikopter'] and mafiaCfg['Helikopter'][1] then
        spawnCoords = mafiaCfg['Helikopter'][1]
    elseif spawnType == 'boats' and mafiaCfg['Brodovi'] and mafiaCfg['Brodovi'][1] then
        spawnCoords = mafiaCfg['Brodovi'][1]
    end

    ESX.Game.SpawnVehicle(vozilo, spawnCoords, GetEntityHeading(ped), function(veh)
        NetworkFadeInEntity(veh, true, true)
        SetVehicleEngineOn(veh, true, true, false)
        SetModelAsNoLongerNeeded(veh)
        TaskWarpPedIntoVehicle(ped, veh, -1)
        SetVehicleFuelLevel(veh, 100.0)
        SetVehicleOilLevel(veh, 10.0)
        DecorSetFloat(veh, "_FUEL_LEVEL", GetVehicleFuelLevel(veh))
        local voziloID = NetworkGetNetworkIdFromEntity(vozilo)
        if Config.Mafije[PlayerData.job.name]['Limit'] then
            TriggerServerEvent('jamaica_mafije:updateVozila', voziloID, true)
        end
        if Config.Mafije[PlayerData.job.name]['Boja'] then -- Boja vozila, imate u config.lua!
            local props = {
                color1 = Config.Mafije[PlayerData.job.name]['Boja'],
                color2 = Config.Mafije[PlayerData.job.name]['Boja'],
            }
            ESX.Game.SetVehicleProperties(veh, props)
        end
        if Config.Mafije[PlayerData.job.name]['Zatamni'] then Zatamni(veh) end
        if Config.Mafije[PlayerData.job.name]['Nabudzi'] then Nabudzi(veh) end
        if Config.Mafije[PlayerData.job.name]['Tablice'] then Tablice(veh, Config.Mafije[PlayerData.job.name]['Tablice'])
        end
    end)
end

function Zatamni(vozilo)
    local props = {
        windowTint = 1,
        wheelColor = 0,
        plateIndex = 1
    }
    ESX.Game.SetVehicleProperties(vozilo, props)
end

function Nabudzi(vozilo)
    local props = {
        modArmor = 4,
        modXenon = true,
        modEngine = 3,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 3,
        modTurbo = true,
    }
    ESX.Game.SetVehicleProperties(vozilo, props)
end

function Tablice(vozilo, tablice)
    local props = {
        plate = tablice,
    }
    ESX.Game.SetVehicleProperties(vozilo, props)
end

ObrisiVozilo = function()
    local playerPed = PlayerPedId()
    local vozilo = GetVehiclePedIsIn(playerPed, false)
    local vehicleSpeed = math.floor((GetEntitySpeed(GetVehiclePedIsIn(playerPed, false)) * 3.6))
    if (vehicleSpeed > 45) then FreezeEntityPosition(vozilo, true) end
    TaskLeaveVehicle(playerPed, vozilo, 0)
    TaskEveryoneLeaveVehicle(vozilo)
    while IsPedInVehicle(playerPed, vozilo, true) do Wait(0) end
    Wait(500)
    NetworkFadeOutEntity(vozilo, true, true)
    Wait(100)
    ESX.Game.DeleteVehicle(vozilo)
    ESX.ShowNotification("Uspješno ste parkirao ~b~vozilo~s~ u garažu.")
    if Config.Mafije[PlayerData.job.name]['Limit'] then
        TriggerServerEvent('jamaica_mafije:updateVozila', NetworkGetNetworkIdFromEntity(vozilo), false)
    end
end

OtvoriAutoSpawnMenu = function()
    local elements = {}
    for model, label in pairs(Config.Mafije[PlayerData.job.name]["MeniVozila"]) do
        insertuj(elements, { label = '🚗 | ' .. label, value = model })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni', {
        title = 'Izaberi Vozilo | 🚗',
        align = 'left',
        elements = elements
    }, function(data, menu)
        if Config.Mafije[PlayerData.job.name]['Limit'] then
            ESX.TriggerServerCallback('jamaica_mafije:proveriVozila', function(tabela)
                if #tabela < Config.Mafije[PlayerData.job.name]['Limit'] then
                    StvoriVozilo(data.current.value)
                    ESX.UI.Menu.CloseAll()
                    menu.close()
                    CurrentAction = nil
                else
                    ESX.ShowNotification('Ne mozete vise da vadite vozila, nema ih dovoljno u garazi!')
                end
            end)
        else
            StvoriVozilo(data.current.value)
            ESX.UI.Menu.CloseAll()
            menu.close()
            CurrentAction = nil
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_vehicle_spawner' -- commit
        CurrentActionMsg = _U('garage_prompt')
        CurrentActionData = {}
    end)
end

OtvoriHeliSpawnMenu = function()
    local elements = {}
    for model, label in pairs(Config.Mafije[PlayerData.job.name]["MeniHelikoptera"]) do
        insertuj(elements, { label = '🚁 | ' .. label, value = model })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni', {
        title = 'Izaberi Helikopter | 🚁',
        align = 'left',
        elements = elements
    }, function(data, menu)
        if Config.Mafije[PlayerData.job.name]['Limit'] then
            ESX.TriggerServerCallback('jamaica_mafije:proveriVozila', function(tabela)
                if #tabela < Config.Mafije[PlayerData.job.name]['Limit'] then
                    StvoriVozilo(data.current.value, 'helicopters')
                    ESX.UI.Menu.CloseAll()
                    menu.close()
                    CurrentAction = nil
                else
                    ESX.ShowNotification('Ne mozete vise da vadite vozila, nema ih dovoljno u garazi!')
                end
            end)
        else
            StvoriVozilo(data.current.value, 'helicopters')
            ESX.UI.Menu.CloseAll()
            menu.close()
            CurrentAction = nil
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_vehicle_spawner' -- commit
        CurrentActionMsg = _U('garage_prompt')
        CurrentActionData = {}
    end)
end

OtvoriBrodSpawnMenu = function()
    local elements = {}
    for model, label in pairs(Config.Mafije[PlayerData.job.name]["BrodoviMenu"]) do
        insertuj(elements, { label = '🛥️ | ' .. label, value = model })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni', {
        title = 'Izaberi Brod | 🛥️',
        align = 'left',
        elements = elements
    }, function(data, menu)
        if Config.Mafije[PlayerData.job.name]['Limit'] then
            ESX.TriggerServerCallback('jamaica_mafije:proveriVozila', function(tabela)
                if #tabela < Config.Mafije[PlayerData.job.name]['Limit'] then
                    StvoriVozilo(data.current.value, 'boats')
                    ESX.UI.Menu.CloseAll()
                    menu.close()
                    CurrentAction = nil
                else
                    ESX.ShowNotification('Ne mozete vise da vadite vozila, nema ih dovoljno u garazi!')
                end
            end)
        else
            StvoriVozilo(data.current.value, 'boats')
            ESX.UI.Menu.CloseAll()
            menu.close()
            CurrentAction = nil
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_vehicle_spawner' -- commit
        CurrentActionMsg = _U('garage_prompt')
        CurrentActionData = {}
    end)
end

local function openCitizenInteractionMenu()
    local elements = {
        { label = _U('search'), value = 'body_search' },
        { label = _U('handcuff'), value = 'handcuff' },
        { label = _U('drag'), value = 'drag' },
        { label = _U('put_in_vehicle'), value = 'put_in_vehicle' },
        { label = _U('out_the_vehicle'), value = 'out_the_vehicle' },
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
        title    = _U('citizen_interaction'),
        align    = 'right-center',
        elements = elements
    }, function(data2, menu2)
        menu2.close()
        TriggerEvent('jamaica_mafije:f6Action', data2.current.value)
    end, function(data2, menu2)
        menu2.close()
    end)
end

OtvoriPosaoMenu = function()
    ESX.UI.Menu.CloseAll()

    local elements = {
        { label = _U('citizen_interaction'), value = 'citizen_interaction' },
    }

    local jobLabel = (PlayerData.job and PlayerData.job.label) or 'Mafija'

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions', {
        title    = '🎩 | ' .. jobLabel,
        align    = 'right-center',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'citizen_interaction' then
            openCitizenInteractionMenu()
        else
            menu.close()
            TriggerEvent('jamaica_mafije:f6Action', data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)
end

PretrazivanjeIgraca = function(player)
    tinkykralj('jamaica_mafije:poruka', GetPlayerServerId(player), _U('being_searched'))
    ESX.TriggerServerCallback('jamaica_mafije:getOtherPlayerData', function(data)
        tinkykralj("jamaica_mafije:PretrazujuMe", GetPlayerServerId(player), true)
        local elements = {}

        for i = 1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                insertuj(elements, {
                    label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
                    value    = 'black_money',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
                })
                break
            end
        end

        insertuj(elements, { label = _U('guns_label') })

        for i = 1, #data.weapons, 1 do
            insertuj(elements, {
                label = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
                value = data.weapons[i].name,
                itemType = 'item_weapon',
                amount = data.weapons[i].ammo
            })
        end

        insertuj(elements, { label = _U('inventory_label') })

        for i = 1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                insertuj(elements, {
                    label = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
                    value = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount = data.inventory[i].count
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
            title    = '🔍 | Pretraga',
            align    = 'right-center',
            elements = elements
        }, function(data, menu)
            if data.current.value then
                local najbliziigrac, distancenajblizi = ESX.Game.GetClosestPlayer()
                if najbliziigrac ~= -1 and distancenajblizi < 2.5 then -- fixan bug sitni :)
                    tinkykralj('jamaica_mafije:oduzmiItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                    PretrazivanjeIgraca(player)
                else
                    ESX.ShowNotification('~y~Ne mozete oduzeti stvari jer ste se ~r~udaljili mnogo')
                    tinkykralj("jamaica_mafije:PretrazujuMe", GetPlayerServerId(player), false)
                    ESX.UI.Menu.CloseAll() -- ugasi sve menije
                end
            end
        end, function(data, menu)
            tinkykralj("jamaica_mafije:PretrazujuMe", GetPlayerServerId(player), false)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end

ADV('jamaica_mafije:hasEnteredMarker', function(station, part, partNum)
    CurrentActionCoords = resolveMarkerCoords(part, partNum)
    if part == 'Cloakroom' then
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = _U('open_cloackroom')
        CurrentActionData = {}
    elseif part == 'Armory' then
        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = { station = station }
    elseif part == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('garage_prompt')
        CurrentActionData = { station = station, part = part, partNum = partNum }
    elseif part == 'Helikopter' then
        CurrentAction     = 'Helikopter'
        CurrentActionMsg  = _U('garage_prompt')
        CurrentActionData = { station = station, part = part, partNum = partNum }
    elseif part == 'Brodovi' then
        CurrentAction     = 'Brodovi'
        CurrentActionMsg  = _U('garage_prompt')
        CurrentActionData = { station = station, part = part, partNum = partNum }
    elseif part == 'ParkirajAuto' then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            CurrentAction     = 'ParkirajAuto'
            CurrentActionMsg  = 'Pritisnite ~INPUT_CONTEXT~ da ~b~parkirate~s~ vozilo u garažu.'
            CurrentActionData = { vehicle = vehicle }
        end
    end
end)

ADV('jamaica_mafije:hasExitedMarker', function(station, part, partNum)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
    CurrentActionCoords = nil
end)

RNE('jamaica_mafije:ugasiga')
ADV('jamaica_mafije:ugasiga', function()
    ESX.UI.Menu.CloseAll()
end)

RNE('jamaica_mafije:vezivanje')
ADV('jamaica_mafije:vezivanje', function()
    isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()
    if isHandcuffed then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do Wait(0) end
        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        SetPedCanPlayGestureAnims(playerPed, false)
        FreezeEntityPosition(playerPed, true)
        DisplayRadar(false)
    else
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
    end
end)

RNE('jamaica_mafije:odvezivanje')
ADV('jamaica_mafije:odvezivanje', function()
    if isHandcuffed then
        isHandcuffed = false
        local playerPed = PlayerPedId()
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
    end
end)

RNE('jamaica_mafije:vuci')
ADV('jamaica_mafije:vuci', function(copId)
    if not isHandcuffed then return end
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)

CreateThread(function()
    local wasDragged

    while 1 do
        local Sleep = 1500

        if isHandcuffed and dragStatus.isDragged then
            Sleep = 50
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                if not wasDragged then
                    AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    wasDragged = true
                else
                    Sleep = 1000
                end
            else
                wasDragged = false
                dragStatus.isDragged = false
                DetachEntity(PlayerPedId(), true, false)
            end
        elseif wasDragged then
            wasDragged = false
            DetachEntity(PlayerPedId(), true, false)
        end
        Wait(Sleep)
    end
end)

RNE('jamaica_mafije:staviUVozilo')
ADV('jamaica_mafije:staviUVozilo', function()
    if isHandcuffed then
        local igrac = PlayerPedId()
        local vozilo, udaljenost = ESX.Game.GetClosestVehicle()

        if vozilo and udaljenost < 5 then
            local max, slobodno = GetVehicleMaxNumberOfPassengers(vozilo)

            for i = max - 1, 0, -1 do
                if IsVehicleSeatFree(vozilo, i) then
                    slobodno = i
                    break
                end
            end

            if slobodno then
                TaskWarpPedIntoVehicle(igrac, vozilo, slobodno)
                dragStatus.isDragged = false
            end
        end
    end
end)

CreateThread(function()
    local DisableControlAction = DisableControlAction
    local IsEntityPlayingAnim = IsEntityPlayingAnim
    while 1 do
        local Sleep = 1000
        local playerPed = PlayerPedId()
        if isHandcuffed then
            Sleep = 0
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 30, true) -- D
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?
            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(2, 36, true) -- Disable going stealth
            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
                ESX.Streaming.RequestAnimDict('mp_arresting', function()
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                end)
            end
        else
            Sleep = 1000
        end
        Wait(Sleep)
    end
end)
if not Config.Optimizacija then
    CreateThread(function()
        local wejtara = 1500
        while 1 do
            Wait(wejtara)

            if PlayerData.job and Config.Mafije[PlayerData.job.name] then
                wejtara = 1000
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local isInMarker, hasExited, letSleep = false, false, true
                local currentStation, currentPart, currentPartNum
                for k, v in pairs(Config.Mafije[PlayerData.job.name]) do
                    for i = 1, #Config.Mafije[PlayerData.job.name]['Armories'], 1 do
                        local distance = #(coords - Config.Mafije[PlayerData.job.name]['Armories'][i])
                        if distance < Config.DrawDistance then
                            DrawMarker(Config.MarkerTypes.Oruzarnica, Config.Mafije[PlayerData.job.name]['Armories'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                            wejtara = 5
                            letSleep = false
                        end
                        if distance < Config.MarkerSize.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
                        end
                    end
                    for i = 1, #Config.Mafije[PlayerData.job.name]['ParkirajAuto'], 1 do
                        local distance = #(coords - Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i])
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if distance < Config.DrawDistance then
                            if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                wejtara = 5
                                letSleep = false
                                DrawMarker(Config.MarkerTypes.VracanjeAuta, Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 20, false, true, 2, true, false, false, false)
                            end
                        end
                        if distance < Config.MarkerAuto.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ParkirajAuto', i
                        end
                    end
                    for i = 1, #Config.Mafije[PlayerData.job.name]['Vehicles'], 1 do
                        local distance = #(coords - Config.Mafije[PlayerData.job.name]['Vehicles'][i])
                        if distance < Config.DrawDistance then
                            if not IsPedInAnyVehicle(playerPed, false) then
                                wejtara = 5
                                letSleep = false
                                DrawMarker(Config.MarkerTypes.SpawnAuta, Config.Mafije[PlayerData.job.name]['Vehicles'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 , 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                            end
                        end
                        if distance < Config.MarkerSize.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
                        end
                    end
                    if Config.Mafije[PlayerData.job.name]['Helikopter'] then
                        for i = 1, #Config.Mafije[PlayerData.job.name]['Helikopter'], 1 do
                            local distance = #(coords - Config.Mafije[PlayerData.job.name]['Helikopter'][i])
                            if distance < Config.DrawDistance then
                                if not IsPedInAnyVehicle(playerPed, false) then
                                    wejtara = 5
                                    letSleep = false
                                    DrawMarker(Config.MarkerTypes.Helikopteri, Config.Mafije[PlayerData.job.name]['Helikopter'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 , 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b , 100, false, true, 2, true, false, false, false)
                                end
                            end
                            if distance < Config.MarkerSize.x then
                                isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helikopter', i
                            end
                        end
                    end
                    if Config.Mafije[PlayerData.job.name]['Brodovi'] then
                        for i = 1, #Config.Mafije[PlayerData.job.name]['Brodovi'], 1 do
                            local distance = #(coords - Config.Mafije[PlayerData.job.name]['Brodovi'][i])
                            if distance < Config.DrawDistance then
                                if not IsPedInAnyVehicle(playerPed, false) then
                                    wejtara = 5
                                    letSleep = false
                                    DrawMarker(Config.MarkerTypes.Brodovi, Config.Mafije[PlayerData.job.name]['Brodovi'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                                end
                            end
                            if distance < Config.MarkerSize.x then
                                isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Brodovi', i
                            end
                        end
                    end
                end
                if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
                    if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
                        tinkykralj2('jamaica_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
                        hasExited = true
                        Wait(200)
                        ESX.UI.Menu.CloseAll()
                    end
                    HasAlreadyEnteredMarker = true
                    LastStation             = currentStation
                    LastPart                = currentPart
                    LastPartNum             = currentPartNum
                    tinkykralj2('jamaica_mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
                end
                if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = false
                    tinkykralj2('jamaica_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
                    Wait(200)
                    ESX.UI.Menu.CloseAll()
                end
                if letSleep then wejtara = 1000 end
            else
                wejtara = 1500
            end
        end
    end)
else
    CreateThread(function()
        Wait(1000)
        local wejtara = 1500
        local tablica = {}
        while 1 do
            Wait(wejtara)
            if PlayerData.job and Config.Mafije[PlayerData.job.name] then
                wejtara = 800
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local isInMarker, hasExited, letSleep = false, false, true
                local currentStation, currentPart, currentPartNum
                for i = 1, #tablica do
                    DeleteCheckpoint(tablica[i])
                end
                for k, v in pairs(Config.Mafije[PlayerData.job.name]) do
                    for i = 1, #Config.Mafije[PlayerData.job.name]['Armories'], 1 do
                        local v = Config.Mafije[PlayerData.job.name]['Armories'][i]
                        local distance = #(coords - Config.Mafije[PlayerData.job.name]['Armories'][i])
                        if distance < Config.DrawDistance then
                            local armory = CreateCheckpoint(47, v.x, v.y, v.z - 1, v, 1.0, 0, 0, 255, 200, 0)
                            SetCheckpointCylinderHeight(armory, 1.5, 1.5, 1.5)
                            insertuj(tablica, armory)
                            letSleep = false
                        end

                        if distance < Config.MarkerSize.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
                        end
                    end
                    for i = 1, #Config.Mafije[PlayerData.job.name]['ParkirajAuto'], 1 do
                        local v = Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i]
                        local distance = #(coords - Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i])
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if distance < Config.DrawDistance then
                            if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                local parkirajvozilo = CreateCheckpoint(47, v.x, v.y, v.z - 1, v, 2.0, 0, 0, 255, 200, 0)
                                SetCheckpointCylinderHeight(parkirajvozilo, 2.0, 2.0, 2.0)
                                insertuj(tablica, parkirajvozilo)
                                letSleep = false
                            end
                        end

                        if distance < Config.MarkerAuto.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ParkirajAuto', i
                        end
                    end
                    for i = 1, #Config.Mafije[PlayerData.job.name]['Vehicles'], 1 do
                        local v = Config.Mafije[PlayerData.job.name]['Vehicles'][i]
                        local distance = #(coords - Config.Mafije[PlayerData.job.name]['Vehicles'][i])

                        if distance < Config.DrawDistance then
                            if not IsPedInAnyVehicle(playerPed, false) then
                                local vozila = CreateCheckpoint(47, v.x, v.y, v.z - 1, v, 2.0, 0, 0, 255, 200, 0)
                                SetCheckpointCylinderHeight(vozila, 2.0, 2.0, 2.0)
                                insertuj(tablica, vozila)
                                letSleep = false
                            end
                        end

                        if distance < Config.MarkerSize.x then
                            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
                        end
                    end
                    if Config.Mafije[PlayerData.job.name]['Helikopter'] then
                        for i = 1, #Config.Mafije[PlayerData.job.name]['Helikopter'], 1 do
                            local v = Config.Mafije[PlayerData.job.name]['Helikopter'][i]
                            local distance = #(coords - Config.Mafije[PlayerData.job.name]['Helikopter'][i])

                            if distance < Config.DrawDistance then
                                if not IsPedInAnyVehicle(playerPed, false) then
                                    local vozila = CreateCheckpoint(47, v.x, v.y, v.z - 1, v, 2.0, 0, 0, 255, 200, 0)
                                    SetCheckpointCylinderHeight(vozila, 2.0, 2.0, 2.0)
                                    insertuj(tablica, vozila)
                                    letSleep = false
                                end
                            end

                            if distance < Config.MarkerSize.x then
                                isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helikopter', i
                            end
                        end
                    end
                    if Config.Mafije[PlayerData.job.name]['Brodovi'] then
                        for i = 1, #Config.Mafije[PlayerData.job.name]['Brodovi'], 1 do
                            local v = Config.Mafije[PlayerData.job.name]['Brodovi'][i]
                            local distance = #(coords - Config.Mafije[PlayerData.job.name]['Brodovi'][i])

                            if distance < Config.DrawDistance then
                                if not IsPedInAnyVehicle(playerPed, false) then
                                    local vozila = CreateCheckpoint(47, v.x, v.y, v.z - 1, v, 2.0, 0, 0, 255, 200, 0)
                                    SetCheckpointCylinderHeight(vozila, 2.0, 2.0, 2.0)
                                    insertuj(tablica, vozila)
                                    letSleep = false
                                end
                            end

                            if distance < Config.MarkerSize.x then
                                isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Brodovi', i
                            end
                        end
                    end
                end
                if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
                    if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
                        tinkykralj2('jamaica_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
                        hasExited = true
                    end
                    HasAlreadyEnteredMarker = true
                    LastStation             = currentStation
                    LastPart                = currentPart
                    LastPartNum             = currentPartNum
                    tinkykralj2('jamaica_mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
                end
                if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = false
                    tinkykralj2('jamaica_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
                end
                if letSleep then wejtara = 5000 end
            else
                wejtara = 5000
            end
        end
    end)
end

RegisterKeyMapping('+mafijameni', 'Mafia meni', 'keyboard', 'F6')
RegisterCommand('+mafijameni', function()
    if isDead then return end
    if not PlayerData.job or not Config.Mafije[PlayerData.job.name] then return end
    if GetResourceState('jamaica-safezone') == 'started' and exports['jamaica-safezone']:BlockJobMenu() then
        return
    end
    if isHandcuffed then
        if MafiaNotify then
            MafiaNotify('Ne mozete otvoriti menu dok ste vezani', 'error')
        else
            ESX.ShowNotification('Ne mozete otvoriti menu dok ste vezani')
        end
    else
        OtvoriPosaoMenu()
    end
end, false)

RegisterCommand('-mafijameni', function() end, false)
CreateThread(function()
    while true do
        local sleep = 1000
        if CurrentAction and CurrentActionCoords and not isDead and not IsNuiFocused()
            and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
            sleep = 0
            DrawText3D(
                CurrentActionCoords.x,
                CurrentActionCoords.y,
                CurrentActionCoords.z + 1.0,
                formatMarkerText(CurrentActionMsg)
            )
            if IsControlPressed(0, 38) then
                if CurrentAction == 'menu_cloakroom' then
                    OpenCloakroomMenu()
                elseif CurrentAction == 'menu_armory' then
                    OpenArmoryMenu(CurrentActionData.station)
                elseif CurrentAction == 'menu_vehicle_spawner' then
                    OpenGarageMenuNUI('all')
                elseif CurrentAction == 'ParkirajAuto' then
                    ObrisiVozilo()
                elseif CurrentAction == 'Helikopter' then
                    OpenGarageMenuNUI('helicopters')
                elseif CurrentAction == 'Brodovi' then
                    OpenGarageMenuNUI('boats')
                end
                if CurrentAction ~= 'menu_vehicle_spawner' and CurrentAction ~= 'Helikopter' and CurrentAction ~= 'Brodovi' then
                    CurrentAction = nil
                end
            end
        end
        Wait(sleep)
    end
end)

ADV('esx:onPlayerDeath', function(data)
    isDead = true
    tinkykralj2('jamaica_mafije:odvezivanje')
end)
ADV('playerSpawned', function(spawn) isDead = false end)
ADV('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        tinkykralj2('jamaica_mafije:odvezivanje')
    end
end)

function OpenGetWeaponMenu()
    ESX.TriggerServerCallback('jamaica_mafije:dbGettajPuske', function(weapons)
        local elements = {}
        for i = 1, #weapons, 1 do
            if weapons[i].count > 0 then
                insertuj(elements, {
                    label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
                    value = weapons[i].name
                })
            end
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
            title    = 'Uzmi oružje',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local oruzje = data.current.value
            if oruzje then
                menu.close()
                ESX.TriggerServerCallback('jamaica_mafije:izvadiIzOruzarnice', function()
                    OpenGetWeaponMenu()
                end, data.current.value)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutWeaponMenu()
    local elements   = {}
    local playerPed  = PlayerPedId()
    local weaponList = ESX.GetWeaponList()
    for i = 1, #weaponList, 1 do
        local weaponHash = GetHashKey(weaponList[i].name)
        if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
            insertuj(elements, {
                label = weaponList[i].label,
                value = weaponList[i].name
            })
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
        title    = 'Ostavi oružje',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        ESX.TriggerServerCallback('jamaica_mafije:staviUoruzarnicu', function()
            OpenPutWeaponMenu()
        end, data.current.value, true)
    end, function(data, menu)
        CurrentAction = nil
        menu.close()
    end)
end

function OpenBuyWeaponsMenu()
    local elements = {}
    local playerPed = PlayerPedId()
    for k, v in pairs(Config.Oruzje[PlayerData.job.grade_name]) do
        local weaponNum, weapon = ESX.GetWeapon(v.weapon)
        local components, label = {}
        local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)
        if v.components then
            for i = 1, #v.components do
                if v.components[i] then
                    local component = weapon.components[i]
                    local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)
                    if hasComponent then
                        label = ('%s: <span style="color:green;">%s</span>'):format(component.label,
                            'Već imaš taj dodatak')
                    else
                        if v.components[i] > 0 then
                            label = ('%s: <span style="color:green;">%s</span>'):format(component.label,
                                '$' .. ESX.Math.GroupDigits(v.components[i]))
                        else
                            label = ('%s: <span style="color:green;">%s</span>'):format(component.label, 'Besplatno!')
                        end
                    end

                    insertuj(components, {
                        label = label,
                        componentLabel = component.label,
                        hash = component.hash,
                        name = component.name,
                        price = v.components[i],
                        hasComponent = hasComponent,
                        componentNum = i
                    })
                end
            end
        end

        if hasWeapon and v.components then
            label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
        elseif hasWeapon and not v.components then
            label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, 'Već imaš tu pušku!')
        else
            if v.price > 0 then
                label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, "$" .. ESX.Math.GroupDigits(v.price))
            else
                label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, 'Besplatno!')
            end
        end

        insertuj(elements, {
            label = label,
            weaponLabel = weapon.label,
            name = weapon.name,
            components = components,
            price = v.price,
            hasWeapon = hasWeapon
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
        title    = 'Oružarnica',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.hasWeapon then
            if #data.current.components > 0 then
                OpenWeaponComponentShop(data.current.components, data.current.name, menu)
            end
        else
            ESX.TriggerServerCallback('jamaica_mafije:kupiOruzje', function(bought)
                if bought then
                    if data.current.price > 0 then
                        ESX.ShowNotification('Kupili ste '..data.current.weaponLabel..' za ~g~$' ..ESX.Math.GroupDigits(data.current.price))
                    end
                    menu.close()
                    OpenBuyWeaponsMenu()
                else
                    ESX.ShowNotification(_U('armory_money'))
                end
            end, data.current.name, 1)
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = nil
    end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
        title = _U('armory_componenttitle'),
        align = 'top-left',
        elements = components
    }, function(data, menu)
        if data.current.hasComponent then
            ESX.ShowNotification(_U('armory_hascomponent'))
        else
            ESX.TriggerServerCallback('jamaica_mafije:kupiOruzje', function(bought)
                if bought then
                    if data.current.price > 0 then
                        ESX.ShowNotification('Kupili ste '..data.current.componentLabel..' za ~g~$' ..ESX.Math.GroupDigits(data.current.price))
                    end
                    menu.close()
                    parentShop.close()
                    OpenBuyWeaponsMenu()
                else
                    ESX.ShowNotification(_U('armory_money'))
                end
            end, weaponName, 2, data.current.componentNum)
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = nil
    end)
end

function OpenGetStocksMenu()
    ESX.TriggerServerCallback('jamaica_mafije:getajsveiteme', function(items)
        local elements = {}

        for i = 1, #items, 1 do
            local item = items[i]
            if item.count > 0 then
                insertuj(elements, {
                    label = 'x' .. items[i].count .. ' ' .. items[i].label,
                    value = items[i].name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title = 'Mafia Stvari',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)
                if not count then
                    ESX.ShowNotification('Ova kolicina je nevazeca!')
                else
                    menu2.close()
                    menu.close()
                    tinkykralj('jamaica_mafije:getStockItem', itemName, count)
                    Wait(50)
                    OpenGetStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
            CurrentAction = nil
        end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback('jamaica_mafije:getajigracevinventory', function(inventory)
        local elements = {}

        for i = 1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                insertuj(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard',
                    value = item.name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title = 'Inventory',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification('Ova kolicina je nevazeca!')
                else
                    menu2.close()
                    menu.close()
                    tinkykralj('jamaica_mafije:putStockItems', itemName, count)
                    Wait(50)
                    OpenPutStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
            CurrentAction = nil
        end)
    end)
end

RegisterNetEvent("jamaica_mafije:PokaziClanove")
AddEventHandler("jamaica_mafije:PokaziClanove", function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lista_clanova', {
		title    = "Online clanovi",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)


RegisterNetEvent("jamaica_mafije:PokaziLidere")
AddEventHandler('jamaica_mafije:PokaziLidere', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lista_lidera', {
		title    = "Online lideri",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('jamaica_mafije:spawnVehicleFromGarage')
AddEventHandler('jamaica_mafije:spawnVehicleFromGarage', function(model, vehicleType)
    if model and model ~= '' then
        StvoriVozilo(model, vehicleType)
    end
end)

RegisterNetEvent('jamaica_mafije:f6Action')
AddEventHandler('jamaica_mafije:f6Action', function(action)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if action == 'body_search' then
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            ESX.TriggerServerCallback('jamaica_mafije:JelPretrazivan', function(br)
                if not br then
                    tinkykralj('jamaica_mafije:poruka', GetPlayerServerId(closestPlayer), _U('being_searched'))
                    if OxInventory then
                        exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
                    else
                        PretrazivanjeIgraca(closestPlayer)
                    end
                else
                    if MafiaNotify then MafiaNotify('Tu osobu vec netko pretrazuje!', 'warning') else ESX.ShowNotification('~y~Tu osobu vec ~r~netko pretrazuje!') end
                end
            end)
        else
            if MafiaNotify then MafiaNotify(_U('no_players_nearby'), 'warning') else ESX.ShowNotification(_U('no_players_nearby')) end
        end
    elseif action == 'handcuff' then
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            tinkykralj('jamaica_mafije:vezivanje', GetPlayerServerId(closestPlayer))
        else
            if MafiaNotify then MafiaNotify(_U('no_players_nearby'), 'warning') else ESX.ShowNotification(_U('no_players_nearby')) end
        end
    elseif action == 'drag' then
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            tinkykralj('jamaica_mafije:vuci', GetPlayerServerId(closestPlayer))
        else
            if MafiaNotify then MafiaNotify(_U('no_players_nearby'), 'warning') else ESX.ShowNotification(_U('no_players_nearby')) end
        end
    elseif action == 'put_in_vehicle' then
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            tinkykralj('jamaica_mafije:staviUVozilo', GetPlayerServerId(closestPlayer))
        else
            if MafiaNotify then MafiaNotify(_U('no_players_nearby'), 'warning') else ESX.ShowNotification(_U('no_players_nearby')) end
        end
    elseif action == 'out_the_vehicle' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if MafiaNotify then MafiaNotify('Ne mozes da radis to dok si u vozilu', 'error') else ESX.ShowNotification('Ne mozes da radis to dok si u vozilu') end
        elseif closestPlayer ~= -1 and closestDistance <= 3.0 then
            tinkykralj('jamaica_mafije:staviVanVozila', GetPlayerServerId(closestPlayer))
        else
            if MafiaNotify then MafiaNotify(_U('no_players_nearby'), 'warning') else ESX.ShowNotification(_U('no_players_nearby')) end
        end
    end
end)

