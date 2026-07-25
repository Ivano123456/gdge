ESX = exports['es_extended']:getSharedObject()

local isHacker = false
local hackerDays = 0
local isUIOpen = false
local activeOffer = false
local laptopProp = nil
local laptopDict = 'amb@code_human_in_bus_passenger_idles@female@tablet@base'
local laptopAnim = 'base'
local laptopModel = `prop_laptop_01a`

local function attachLaptop()
    local ped = PlayerPedId()

    RequestModel(laptopModel)
    while not HasModelLoaded(laptopModel) do Wait(10) end

    RequestAnimDict(laptopDict)
    while not HasAnimDictLoaded(laptopDict) do Wait(10) end

    laptopProp = CreateObject(laptopModel, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(
        laptopProp, ped, GetPedBoneIndex(ped, 60309),
        0.06, 0.03, -0.01,
        80.0, 100.0, 0.0,
        true, true, false, true, 1, true
    )
    TaskPlayAnim(ped, laptopDict, laptopAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function removeLaptop()
    local ped = PlayerPedId()
    StopAnimTask(ped, laptopDict, laptopAnim, 1.0)
    if laptopProp and DoesEntityExist(laptopProp) then
        DeleteEntity(laptopProp)
        laptopProp = nil
    end
end

local function closeUI()
    if not isUIOpen then return end
    isUIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    removeLaptop()
end

local function openUI()
    if not isHacker then
        lib.notify({
            title = 'Haker',
            description = Config.Messages.not_hacker,
            type = 'error',
            position = 'center-right',
            duration = 5000,
        })
        return
    end

    if isUIOpen then return end

    attachLaptop()
    isUIOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        days = hackerDays,
        prices = Config.Cene,
    })
end

RegisterNUICallback('close', function(_, cb)
    closeUI()
    cb('ok')
end)

RegisterNUICallback('lookup', function(data, cb)
    TriggerServerEvent('jamaica_haker:lookupPlayer', tonumber(data.playerId))
    cb('ok')
end)

RegisterNUICallback('offerDelete', function(data, cb)
    TriggerServerEvent(
        'jamaica_haker:offerDelete',
        tonumber(data.playerId),
        tonumber(data.recordId),
        data.recordTip
    )
    cb('ok')
end)

RegisterNetEvent('jamaica_haker:hackerStatus', function(status, days)
    isHacker = status == true
    hackerDays = tonumber(days) or 0
    if isUIOpen then
        SendNUIMessage({ action = 'updateDays', days = hackerDays })
    end
end)

RegisterNetEvent('jamaica_haker:hackerExpired', function()
    isHacker = false
    hackerDays = 0
    if isUIOpen then closeUI() end
    lib.notify({
        title = 'Haker',
        description = Config.Messages.hacker_expired,
        type = 'error',
        position = 'center-right',
        duration = 8000,
    })
end)

RegisterNetEvent('jamaica_haker:openMenu', function()
    TriggerServerEvent('jamaica_haker:checkHacker')
    isHacker = true
    openUI()
end)

RegisterNetEvent('jamaica_haker:lookupResult', function(payload)
    SendNUIMessage({
        action = 'lookupResult',
        data = payload,
    })
end)

RegisterNetEvent('jamaica_haker:recordDeleted', function(payload)
    SendNUIMessage({
        action = 'recordDeleted',
        data = payload or {},
    })
end)

RegisterNetEvent('jamaica_haker:deleteOffer', function(data)
    activeOffer = true
    local cena = data.cena or 0
    local label = data.label or 'zapis'
    local poruka = ('Želite li da vam se obriše %s za %s$? Pritisnite F4 da prihvatite.'):format(label, cena)

    lib.notify({
        title = 'Haker',
        description = poruka,
        type = 'inform',
        position = 'center-right',
        duration = 8000,
    })

    TriggerEvent('chat:addMessage', {
        color = { 59, 130, 246 },
        multiline = true,
        args = { 'HAKER', poruka },
    })

    lib.showTextUI(('[F4] Obriši %s — %s$'):format(label, cena))

    SetTimeout((tonumber(data.trajanje) or Config.PonudaTrajanje or 60) * 1000, function()
        if activeOffer then
            activeOffer = false
            lib.hideTextUI()
        end
    end)
end)

RegisterNetEvent('jamaica_haker:offerCancelled', function()
    if activeOffer then
        activeOffer = false
        lib.hideTextUI()
    end
end)

RegisterCommand('+haker_prihvati_brisanje', function()
    if not activeOffer then return end
    activeOffer = false
    lib.hideTextUI()
    TriggerServerEvent('jamaica_haker:acceptOffer')
end, false)

RegisterCommand('-haker_prihvati_brisanje', function() end, false)
RegisterKeyMapping('+haker_prihvati_brisanje', 'Haker — prihvati brisanje zapisa', 'keyboard', 'F4')

CreateThread(function()
    Wait(2000)
    TriggerServerEvent('jamaica_haker:checkHacker')
end)

CreateThread(function()
    while true do
        Wait(5 * 60 * 1000)
        if isHacker then
            TriggerServerEvent('jamaica_haker:checkHacker')
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if isUIOpen then
        SetNuiFocus(false, false)
    end
    removeLaptop()
    if activeOffer then
        lib.hideTextUI()
    end
end)
