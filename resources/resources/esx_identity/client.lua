local loadingScreenFinished = false
local guiEnabled = false
local nuiLoaded = false
local cachedDiscordAvatar = nil

local function waitFor(condition)
    while not condition() do
        Wait(100)
    end
end

local function setDiscordImage(image)
    SendNUIMessage({ type = 'setdiscord', image = image })
end

local function resolveAvatarForGender(sex)
    if Config.EnableDiscordImages then
        if cachedDiscordAvatar then
            setDiscordImage(cachedDiscordAvatar)
            return
        end

        ESX.TriggerServerCallback('esx_identity:GetPlayerAvatar', function(image)
            cachedDiscordAvatar = image
            setDiscordImage(image)
        end, sex)
        return
    end

    setDiscordImage((sex == 'm') and Config.MaleDefaultImage or Config.FemaleDefaultImage)
end

RegisterNetEvent('esx_identity:alreadyRegistered', function()
    waitFor(function()
        return loadingScreenFinished
    end)
    TriggerEvent('esx_skin:playerRegistered')
end)

CreateThread(function()
    waitFor(function()
        return nuiLoaded
    end)
    SendNUIMessage({ type = 'set_translation', Translation = Config.Translation })
end)

RegisterNetEvent('esx_identity:setPlayerData', function(data)
    ESX.SetPlayerData('name', ('%s %s'):format(data.firstName, data.lastName))
    ESX.SetPlayerData('firstName', data.firstName)
    ESX.SetPlayerData('lastName', data.lastName)
    ESX.SetPlayerData('dateofbirth', data.dateOfBirth)
    ESX.SetPlayerData('sex', data.sex)
    ESX.SetPlayerData('height', data.height)
end)

AddEventHandler('esx:loadingScreenOff', function()
    loadingScreenFinished = true
end)

RegisterNUICallback('ready', function(_, cb)
    nuiLoaded = true
    cb(1)
end)

function EnableGui(state)
    waitFor(function()
        return loadingScreenFinished and nuiLoaded and NetworkIsPlayerActive(PlayerId())
    end)

    SetNuiFocus(state, state)
    guiEnabled = state

    SendNUIMessage({
        type = 'enableui',
        enable = state,
        Translation = Config.Translation,
        Logo = Config.Logo,
        maxValues = {
            MaxNameLength = Config.MaxNameLength,
            MinHeight = Config.MinHeight,
            MaxHeight = Config.MaxHeight,
            LowestYear = Config.LowestYear,
            HighestYear = Config.HighestYear,
        },
    })

    if state then
        cachedDiscordAvatar = nil
        resolveAvatarForGender('m')
    end
end

RegisterNUICallback('GenderChange', function(data, cb)
    resolveAvatarForGender(data.sex)
    cb('ok')
end)

RegisterNetEvent('esx_identity:showRegisterIdentity', function()
    TriggerEvent('esx_skin:resetFirstSpawn')
    if not ESX.PlayerData.dead then
        EnableGui(true)
    end
end)

RegisterNUICallback('register', function(data, cb)
    ESX.TriggerServerCallback('esx_identity:registerIdentity', function(callback)
        if callback then
            ESX.ShowNotification(Config.Translation.NotifWelcome)
            EnableGui(false)
            if not ESX.GetConfig().Multichar then
                if Config.CharCreator == 'vms_charcreator' then
                    TriggerEvent('vms_charcreator:openCreator', data.sex)
                elseif Config.CharCreator == 'esx_skin' then
                    TriggerEvent('esx_skin:playerRegistered')
                elseif Config.CharCreator == 'fivem-appearance' then
                    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
                        if appearance then
                            print('Saved')
                        else
                            print('Canceled')
                        end
                    end, {
                        ped = true,
                        headBlend = true,
                        faceFeatures = true,
                        headOverlays = true,
                        components = true,
                        props = true,
                        allowExit = true,
                        tattoos = true,
                    })
                end
            end
        end
    end, data)
    cb('ok')
end)

CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)
