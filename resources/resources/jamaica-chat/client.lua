local chatInputActive = false
local chatInputActivating = false
local chatScreenHidden = true
local chatUserDisabled = GetResourceKvpInt('jamaica_chat_off') == 1
local chatAdminMuted = false
local chatLoaded = false

local function isScreenForceHidden()
	return IsScreenFadedOut() or IsPauseMenuActive()
end

local function closeChatInput()
	if not chatInputActive then return end
	chatInputActive = false
	chatInputActivating = false
	SetNuiFocus(false, false)
	SendNUIMessage({ type = 'ON_CLOSE' })
end

local function syncChatVisibility()
	if not chatLoaded then return end
	local hide = chatUserDisabled or isScreenForceHidden()
	SendNUIMessage({
		type = 'ON_CHAT_USER_TOGGLE',
		disabled = chatUserDisabled,
	})
	SendNUIMessage({
		type = 'ON_SCREEN_STATE_CHANGE',
		shouldHide = hide,
	})
end

local function notifyChatState()
	local msg = chatUserDisabled and 'Chat je ugašen.' or 'Chat je uključen.'
	if ESX and ESX.ShowNotification then
		ESX.ShowNotification(msg)
	end
end

local function setChatDisabled(disabled)
	disabled = disabled == true
	if chatUserDisabled == disabled then return end
	chatUserDisabled = disabled
	SetResourceKvpInt('jamaica_chat_off', disabled and 1 or 0)
	if chatUserDisabled then
		closeChatInput()
	end
	SetTextChatEnabled(false)
	syncChatVisibility()
	notifyChatState()
end

exports('SetChatDisabled', setChatDisabled)
exports('IsChatDisabled', function()
	return chatUserDisabled
end)
exports('ToggleChat', function()
	setChatDisabled(not chatUserDisabled)
end)

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:client:ClearChat')

RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')
RegisterNetEvent('jamaica-chat:muteState')

AddEventHandler('jamaica-chat:muteState', function(muted, secondsLeft)
	chatAdminMuted = muted == true
	if chatAdminMuted then
		closeChatInput()
		if ESX and ESX.ShowNotification then
			ESX.ShowNotification(('Mutiran si u chatu još %s.'):format(formatMuteTimeClient(secondsLeft)))
		end
	else
		if ESX and ESX.ShowNotification then
			ESX.ShowNotification('Mute u chatu ti je skinut.')
		end
	end
end)

local function trimStr(s)
	if not s then return '' end
	return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function formatMuteTimeClient(seconds)
	seconds = math.max(0, math.ceil(tonumber(seconds) or 0))
	if seconds >= 3600 then
		local h = math.floor(seconds / 3600)
		local m = math.ceil((seconds % 3600) / 60)
		if m >= 60 then
			h = h + 1
			m = 0
		end
		if m > 0 then
			return ('%dh %dm'):format(h, m)
		end
		return ('%dh'):format(h)
	end
	if seconds >= 60 then
		return ('%d min'):format(math.ceil(seconds / 60))
	end
	return ('%d sek'):format(seconds)
end

local function pushChatMessage(message)
	if chatUserDisabled then return end
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = message,
	})
end

AddEventHandler('chatMessage', function(author, color, text)
	local args = { text }
	if author ~= "" then
		table.insert(args, 1, author)
	end
	pushChatMessage({
		color = color,
		args = args,
	})
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
	pushChatMessage({
		templateId = 'print',
		args = { msg },
	})
end)

AddEventHandler('chat:addMessage', function(message)
	pushChatMessage(message)
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = 'ON_SUGGESTION_ADD',
			suggestion = suggestion
		})
	end
end)

AddEventHandler('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

RegisterNetEvent('chat:resetSuggestions')
AddEventHandler('chat:resetSuggestions', function()
	SendNUIMessage({
		type = 'ON_COMMANDS_RESET'
	})
end)

AddEventHandler('chat:addTemplate', function(id, html)
	SendNUIMessage({
		type = 'ON_TEMPLATE_ADD',
		template = {
			id = id,
			html = html
		}
	})
end)

AddEventHandler('chat:client:ClearChat', function(name)
	SendNUIMessage({
		type = 'ON_CLEAR'
	})
end)

RegisterNUICallback('chatResult', function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)

	if chatAdminMuted then
		if ESX and ESX.ShowNotification then
			ESX.ShowNotification('Mutiran si u chatu i ne možeš slati poruke.')
		end
		cb('ok')
		return
	end

	if not data.canceled then
		if data.message:sub(1, 1) == '/' then
			local cmdLine = data.message:sub(2)
			local cmdName, cmdArgs = cmdLine:match('^(%S+)%s*(.*)$')
			if cmdName and Config.EnableHakerChatCommand and Config.HakerChatCommand
				and cmdName:lower() == Config.HakerChatCommand:lower() then
				TriggerServerEvent('jamaica-chat:hakerChat', trimStr(cmdArgs or ''))
			else
				ExecuteCommand(cmdLine)
			end
		else
			local id = PlayerId()
			TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { 0, 0x99, 255 }, data.message)
		end
	end

	cb('ok')
end)

local function refreshCommands()
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()

		local suggestions = {}

		for _, command in ipairs(registeredCommands) do
			if IsAceAllowed(('command.%s'):format(command.name)) then
				table.insert(suggestions, {
					name = '/' .. command.name,
					help = ''
				})
			end
		end

		TriggerEvent('chat:addSuggestions', suggestions)
	end
end

local function refreshThemes()
	local themes = {}

	for resIdx = 0, GetNumResources() - 1 do
		local resource = GetResourceByFindIndex(resIdx)

		if GetResourceState(resource) == 'started' then
			local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

			if numThemes > 0 then
				local themeName = GetResourceMetadata(resource, 'chat_theme')
				local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

				if themeName and themeData then
					themeData.baseUrl = 'nui://' .. resource .. '/'
					themes[themeName] = themeData
				end
			end
		end
	end

	SendNUIMessage({
		type = 'ON_UPDATE_THEMES',
		themes = themes
	})
end

AddEventHandler('onClientResourceStart', function(resName)
	Wait(500)

	refreshCommands()
	refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
	Wait(500)

	refreshCommands()
	refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
	TriggerServerEvent('chat:init');

	refreshCommands()
	refreshThemes()

	chatLoaded = true
	syncChatVisibility()

	cb('ok')
end)

RegisterCommand('toggleChat', function() end, false)

RegisterKeyMapping('chat', 'Chat', 'keyboard', 't')
RegisterCommand('chat', function()
	if chatUserDisabled then
		if ESX and ESX.ShowNotification then
			ESX.ShowNotification('Chat je ugašen. Uključi ga u F9 meniju → Ugasi/Upali chat.')
		end
		return
	end

	if chatAdminMuted then
		if ESX and ESX.ShowNotification then
			ESX.ShowNotification('Mutiran si u chatu i ne možeš slati poruke.')
		end
		return
	end

	SetTextChatEnabled(false)
	SetNuiFocus(false, false)

	chatInputActive = true
	chatInputActivating = true

	SendNUIMessage({
		type = 'ON_OPEN'
	})

	if chatInputActivating then
		SetNuiFocus(true, true)
		chatInputActivating = false
	end
end)

CreateThread(function()
	while true do
		SetTextChatEnabled(false)
		Wait(500)
		if not chatLoaded then goto continue end
		local screenHidden = isScreenForceHidden()
		if screenHidden ~= chatScreenHidden then
			chatScreenHidden = screenHidden
			syncChatVisibility()
		end
		::continue::
	end
end)

RegisterCommand('toggleChat', function() end, false)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/'..Config.ClearChatCommand, 'Obriši chat (samo za tebe)', {})
	TriggerEvent('chat:addSuggestion', '/'..Config.ClearEveryonesChatCommand, 'Obriši chat (za sve)', {})
	if Config.EnableAdvertisementCommand then
		TriggerEvent('chat:addSuggestion', '/'..Config.AdvertisementCommand, 'Oglas — poruka košta $'..Config.AdvertisementPrice, {})
		TriggerEvent('chat:addSuggestion', '/add', 'Oglas — isto kao /'..Config.AdvertisementCommand, {})
	end
	if Config.EnableTwitchCommand then
		TriggerEvent('chat:addSuggestion', '/'..Config.TwitchCommand, 'Twitch poruka', {})
	end
	if Config.EnableYoutubeCommand then
		TriggerEvent('chat:addSuggestion', '/'..Config.YoutubeCommand, 'Youtube poruka', {})
	end
	if Config.EnableTwitterCommand then
		TriggerEvent('chat:addSuggestion', '/'..Config.TwitterCommand, 'Twitter — poruka košta $'..Config.TwitterPrice, {})
	end
	if Config.EnableHakerChatCommand and Config.HakerChatCommand and Config.HakerChatCommand ~= '' then
		TriggerEvent('chat:addSuggestion', '/'..Config.HakerChatCommand, 'Haker chat (anonimno) ili meni bez teksta', {})
	end
	if Config.EnableStaffPmCommand and Config.StaffPmCommand and Config.StaffPmCommand ~= '' then
		TriggerEvent('chat:addSuggestion', '/'..Config.StaffPmCommand, 'Staff privatna poruka igraču', {
			{ name = 'id', help = 'Server ID igrača' },
			{ name = 'poruka', help = 'Tekst poruke' },
		})
	end
	if Config.EnableStaffObavestenjeCommand and Config.StaffObavestenjeCommand and Config.StaffObavestenjeCommand ~= '' then
		TriggerEvent('chat:addSuggestion', '/'..Config.StaffObavestenjeCommand, 'Staff obaveštenje — vidi ceo server', {})
		local altObav = Config.StaffObavestenjeAltCommand
		if altObav and altObav ~= '' and altObav ~= Config.StaffObavestenjeCommand then
			TriggerEvent('chat:addSuggestion', '/'..altObav, 'Staff obaveštenje — skraćeno', {})
		end
	end
	if Config.EnablePoliceCommand then
		TriggerEvent('chat:addSuggestion', '/'..Config.PoliceCommand, 'Policijsko obaveštenje (grade 10–11)', {})
	end
	if Config.EnableAmbulanceCommand then
		TriggerEvent('chat:addSuggestion', '/'..Config.AmbulanceCommand, 'Hitna pomoć — obaveštenje', {})
	end
	TriggerEvent('chat:addSuggestion', '/'..(Config.MuteCommand or 'mute'), 'Mutiraj igrača u chatu (admin)', {
		{ name = 'id', help = 'Server ID igrača' },
		{ name = 'minuti', help = 'Trajanje u minutama' },
	})
	TriggerEvent('chat:addSuggestion', '/'..(Config.UnmuteCommand or 'unmute'), 'Skini mute u chatu (admin)', {
		{ name = 'id', help = 'Server ID igrača' },
	})
end)