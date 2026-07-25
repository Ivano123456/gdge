local ESX = exports.es_extended:getSharedObject()

local uiOpen = false
local bankBlips = {}
local bankPeds = {}
local atmObjects = {}

local function notify(msg, ntype)
    lib.notify({ description = msg, type = ntype or 'inform' })
end

local function closeUi()
    if not uiOpen then return end
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openUi()
    if uiOpen then return end

    ESX.TriggerServerCallback('jamaica-banke:getData', function(data)
        if not data then
            notify('Banka trenutno nije dostupna.', 'error')
            return
        end

        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            bank = data.bank,
            cash = data.cash,
            playerName = data.playerName,
        })
    end)
end

RegisterNUICallback('close', function(_, cb)
    closeUi()
    cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
    TriggerServerEvent('jamaica-banke:deposit', data and data.amount)
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    TriggerServerEvent('jamaica-banke:withdraw', data and data.amount)
    cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
    TriggerServerEvent('jamaica-banke:transfer', data and data.amount, data and data.target)
    cb('ok')
end)

RegisterNetEvent('jamaica-banke:updateBalances', function(bank, cash)
    if uiOpen then
        SendNUIMessage({
            action = 'updateBalances',
            bank = bank,
            cash = cash,
        })
    end
end)

CreateThread(function()
    for i, bank in ipairs(Config.Banks) do
        local blipCfg = bank.blip
        if blipCfg then
            local c = bank.blipCoords
            local blip = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(blip, blipCfg.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, blipCfg.scale)
            SetBlipColour(blip, blipCfg.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(bank.label or 'Banka')
            EndTextCommandSetBlipName(blip)
            bankBlips[i] = blip
        end
    end
end)

CreateThread(function()
    local pedCfg = Config.Ped
    if not pedCfg or not pedCfg.model then return end

    local pedModel = joaat(pedCfg.model)
    if not IsModelInCdimage(pedModel) or not IsModelValid(pedModel) then return end

    lib.requestModel(pedModel, 5000)
    if not HasModelLoaded(pedModel) then return end

    for i, bank in ipairs(Config.Banks) do
        local c = bank.ped
        if not c then goto continue end
        local ped = CreatePed(4, pedModel, c.x, c.y, c.z - 1.0, c.w, false, true)
        if not DoesEntityExist(ped) then goto continue end

        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        if pedCfg.scenario then
            TaskStartScenarioInPlace(ped, pedCfg.scenario, 0, true)
        end

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'jamaica_banke_' .. i,
                icon = 'fas fa-university',
                label = 'Otvori banku',
                distance = Config.TargetDistance or 2.0,
                onSelect = function()
                    openUi()
                end,
            },
        })

        bankPeds[i] = ped
        ::continue::
    end

    SetModelAsNoLongerNeeded(pedModel)
end)

CreateThread(function()
    if not Config.ATMs or #Config.ATMs == 0 then return end

    local atmModel = Config.ATMModel or `prop_fleeca_atm`
    lib.requestModel(atmModel)

    for i, coords in ipairs(Config.ATMs) do
        local obj = CreateObject(atmModel, vector3(coords.x, coords.y, coords.z - 1), false, true)
        SetEntityHeading(obj, coords.w)
        FreezeEntityPosition(obj, true)
        SetEntityInvincible(obj, true)
        atmObjects[i] = obj
    end

    SetModelAsNoLongerNeeded(atmModel)
end)

exports.ox_target:addModel(Config.ATMProps, {
    {
        name = 'jamaica_banke_atm',
        icon = 'fas fa-credit-card',
        label = 'Otvori bankomat',
        distance = 1.5,
        onSelect = function()
            openUi()
        end,
    },
})

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    closeUi()
    for i, ped in pairs(bankPeds) do
        if DoesEntityExist(ped) then
            exports.ox_target:removeLocalEntity(ped, 'jamaica_banke_' .. i)
            DeleteEntity(ped)
        end
    end
    for i, obj in pairs(atmObjects) do
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    for _, blip in pairs(bankBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end)
