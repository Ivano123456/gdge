local radioMenu, onRadio = false, false
local RadioChannel = 0
local RadioVolume = 50


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function(playerData)
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)



--Function
local function LoadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

local function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
	onRadio = true
    end
    exports["pma-voice"]:setRadioChannel(channel)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
         Config.ClientNotification(Config.messages['joined to radio'] ..channel.. ' MHz', 'success')
    else
         Config.ClientNotification(Config.messages['joined to radio'] ..channel.. '.00 MHz', 'success')
    end
end

local function closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
end

local function leaveradio()
    closeEvent()
    RadioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    Config.ClientNotification(Config.messages['you leave'] , 'error')
end
--[[
local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
		TriggerEvent("attachItemRadio","radio01")
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		--if radioProp ~= 0 then
			DeleteEntity(radioProp)
			--radioProp = 0
		--end
	end
end]]

function newPhoneProp()
  deletePhone()
  RequestModel("prop_cs_walkie_talkie")
  while not HasModelLoaded("prop_cs_walkie_talkie") do
    Citizen.Wait(1)
  end

  phoneProp = CreateObject("prop_cs_walkie_talkie", 1.0, 1.0, 1.0, 1, 1, 0)
  local bone = GetPedBoneIndex(PlayerPedId(), 28422)
  AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function deletePhone()
  if phoneProp ~= 0 then
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(phoneProp))
    phoneProp = 0
  end
end

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end

local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
		local dict = "cellphone@"
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			dict = "anim@cellphone@in_car@ps"
		end

		loadAnimDict(dict)

		local anim = "cellphone_call_to_text"
		TaskPlayAnim(PlayerPedId(), dict, anim, 3.0, -1, -1, 50, 0, false, false, false)
		newPhoneProp()
	else
		ClearPedSecondaryTask(PlayerPedId())
		deletePhone()
	end
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        toggleRadioAnimation(true)
        SendNUIMessage({type = "open"})
    else
        toggleRadioAnimation(false)
        SendNUIMessage({type = "close"})
    end
end

local function IsRadioOn()
    return onRadio
end

--Exports
exports("IsRadioOn", IsRadioOn)

RegisterNetEvent('esx-radio:use', function()
    toggleRadio(not radioMenu)
end)

RegisterNetEvent('esx-radio:onRadioDrop', function()
    if RadioChannel ~= 0 then
        leaveradio()
    end
end)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
    local rchannel = tonumber(data.channel)
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if rchannel ~= RadioChannel then
                if Config.RestrictedChannels[rchannel] ~= nil then
                    if Config.RestrictedChannels[rchannel][ESX.PlayerData.job.name] then
                        connecttoradio(rchannel)
                    else
                         Config.ClientNotification(Config.messages['restricted channel error'], 'error')
                    end
                else
                    connecttoradio(rchannel)
                end
            else
                 Config.ClientNotification(Config.messages['you on radio'] , 'error')
            end
        else
             Config.ClientNotification(Config.messages['invalid radio'] , 'error')
        end
    else
         Config.ClientNotification(Config.messages['invalid radio'] , 'error')
    end
end)

RegisterNUICallback('leaveRadio', function(data, cb)
    if RadioChannel == 0 then
         Config.ClientNotification(Config.messages['not on radio'], 'error')
    else
        leaveradio()
    end
end)

RegisterNUICallback("volumeUp", function()
	if RadioVolume <= 95 then
		RadioVolume = RadioVolume + 5
		Config.ClientNotification(Config.messages["volume radio"] .. RadioVolume, "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		 Config.ClientNotification(Config.messages["decrease radio volume"], "error")
	end
end)

RegisterNUICallback("volumeDown", function()
	if RadioVolume >= 10 then
		RadioVolume = RadioVolume - 5
		Config.ClientNotification(Config.messages["volume radio"] .. RadioVolume, "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		 Config.ClientNotification(Config.messages["increase radio volume"], "error")
	end
end)

RegisterNUICallback("increaseradiochannel", function(data, cb)
    RadioChannel = RadioChannel + 1
    exports["pma-voice"]:setRadioChannel(RadioChannel)
    Config.ClientNotification(Config.messages["increase decrease radio channel"] .. RadioChannel, "success")
end)

RegisterNUICallback("decreaseradiochannel", function(data, cb)
    if not onRadio then return end
    RadioChannel = RadioChannel - 1
    if RadioChannel >= 1 then
        exports["pma-voice"]:setRadioChannel(RadioChannel)
        Config.ClientNotification(Config.messages["increase decrease radio channel"] .. RadioChannel, "success")
    end
end)

RegisterNUICallback('poweredOff', function(data, cb)
    leaveradio()
end)

RegisterNUICallback('escape', function(data, cb)
    toggleRadio(false)
end)

--Main Thread
CreateThread(function()
    while Config.Item.Require do
        Wait(5000)
        if ESX.IsPlayerLoaded() and onRadio then
            ESX.TriggerServerCallback("esx-radio:server:GetItem", function(hasItem)
                if not hasItem then
                    if RadioChannel ~= 0 then
                        leaveradio()
                    end
                end
            end, Config.Item.name)
        end
    end
end)

for i=1, Config.MaxFrequency do
    RegisterNetEvent('esx-radio:client:JoinRadioChannel'.. i, function(channel)
        exports["pma-voice"]:setRadioChannel(i)
        if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(i), ".")[2] ~= "" then
             Config.ClientNotification(Config.messages['joined to radio'] ..i.. ' MHz', 'success')
        else
             Config.ClientNotification(Config.messages['joined to radio'] ..i.. '.00 MHz', 'success')
        end
    end)
end
--[[
-- Command
RegisterCommand("radio", function(source)
    if Config.Item.Require then 
        ESX.TriggerServerCallback("esx-radio:server:GetItem", function(hasItem)
            if hasItem then
                toggleRadio(not radioMenu)
            end
        end, Config.Item.name)
    else 
        toggleRadio(not radioMenu)
    end
end)

if Config.KeyMappings.Enabled then
    RegisterKeyMapping("radio", 'Toggle Radio', 'keyboard', Config.KeyMappings.Key)
end]]
