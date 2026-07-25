local ESX              = exports['es_extended']:getSharedObject()
local ResourceName     = GetCurrentResourceName()
local CurrentlyWashing = false
local NuiOpen          = false
local PendingAmount    = nil
local ActiveLocation   = nil
local CachedJobName    = nil
local WashPoints       = {}

local function RefreshJobCache()
	local job = ESX.GetPlayerData().job
	CachedJobName = job and job.name or nil
end

RegisterNetEvent('esx:setJob', function(job)
	CachedJobName = job and job.name
end)

local function GetLocationData(index)
	local loc = Config.WashLocations[index]
	if not loc then return nil end
	if loc.coords then
		return loc.coords, loc.job, loc.taxRate or Config.TaxRate, loc.pedModel
	end
	return loc, nil, Config.TaxRate, nil
end

local function HasLocationJob(requiredJob)
	if not requiredJob or requiredJob == '' then return true end
	return CachedJobName == requiredJob
end

local function CloseUI(cancelled)
	if not NuiOpen then return end
	NuiOpen = false
	SetNuiFocus(false, false)
	SendNUIMessage({ action = cancelled and 'cancelled' or 'close' })
end

local function OpenWashUI(locationIndex)
	if CurrentlyWashing then
		lib.notify({ title = 'Trenutno pranje', description = 'Vi već perete novac!', position = 'top', type = 'error' })
		return
	end

	local _, requiredJob, taxRate = GetLocationData(locationIndex)
	if not HasLocationJob(requiredJob) then
		lib.notify({ title = 'Pristup odbijen', description = 'Ova tačka pranja je samo za Auto Umro.', position = 'top', type = 'error' })
		return
	end

	if Config.UseTickets then
		local washTicket = exports.ox_inventory:Search('count', 'moneywash_ticket')
		if (washTicket or 0) < 1 then
			lib.notify({ title = 'Pristup odbijen', description = 'Za korištenje ove mašine potrebna vam je karta za pranje!', position = 'top', type = 'error' })
			return
		end
	end

	local balance, cooldownMs = lib.callback.await('jamaica_moneywash:getBalance', false, locationIndex)
	if balance == nil then return end

	ActiveLocation = locationIndex
	NuiOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		action       = 'open',
		balance      = balance,
		taxRate      = taxRate or Config.TaxRate,
		washDuration = Config.WashDuration,
		resourceName = ResourceName,
		cooldownMs   = cooldownMs or 0,
	})
end

RegisterNUICallback('wash', function(data, cb)
	cb(1)
	local amount = tonumber(data and data.amount)
	if not amount or amount <= 0 then return end

	PendingAmount = amount

	lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@')
	TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)

	TriggerServerEvent('jamaica_moneywash:cleanmoney', amount, ActiveLocation)
end)

RegisterNUICallback('washComplete', function(data, cb)
	cb(1)
	if not CurrentlyWashing then return end
	TriggerServerEvent('jamaica_moneywash:complete')
	CurrentlyWashing = false
	PendingAmount    = nil
	ActiveLocation   = nil
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNUICallback('close', function(data, cb)
	cb(1)
	if CurrentlyWashing then return end
	ActiveLocation = nil
	CloseUI(false)
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('jamaica_moneywash:washactions', function()
	if not NuiOpen or not PendingAmount then return end
	CurrentlyWashing = true
	lib.notify({ title = 'Započelo', description = 'Započeli ste proces pranja.', position = 'top', type = 'inform' })
	SendNUIMessage({
		action   = 'washing',
		amount   = PendingAmount,
		duration = Config.WashDuration,
	})
end)

RegisterNetEvent('jamaica_moneywash:rejected', function(reason)
	if reason and reason ~= '' then
		lib.notify({ title = 'Pranje novca', description = reason, position = 'top', type = 'error' })
	end
	SendNUIMessage({ action = 'rejected' })
	PendingAmount  = nil
	ActiveLocation = nil
	ClearPedTasksImmediately(PlayerPedId())
end)

local function RemoveWashPed(point)
	if not point.entity then return end

	if DoesEntityExist(point.entity) then
		exports.ox_target:removeLocalEntity(point.entity, point.targetName)
		SetEntityAsMissionEntity(point.entity, false, true)
		DeleteEntity(point.entity)
	end

	point.entity = nil
end

local function SpawnWashPed(point)
	if point.entity and DoesEntityExist(point.entity) then return end

	local coords = point.coords4
	local model = point.pedModel or Config.PedModel or `s_m_m_highsec_02`
	if type(model) == 'string' then model = joaat(model) end
	if not IsModelInCdimage(model) or not IsModelValid(model) then return end

	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	if not lib.requestModel(model, 5000) then return end

	local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w or 0.0, false, true)
	SetModelAsNoLongerNeeded(model)
	if not DoesEntityExist(ped) then return end

	SetEntityHeading(ped, coords.w or 0.0)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetPedCanRagdoll(ped, false)
	SetEntityAsMissionEntity(ped, true, true)

	if Config.PedScenario and Config.PedScenario ~= '' then
		TaskStartScenarioInPlace(ped, Config.PedScenario, 0, true)
	end

	exports.ox_target:addLocalEntity(ped, {
		{
			name = point.targetName,
			icon = 'fa-solid fa-money-bill',
			label = 'Pranje Novca',
			distance = Config.TargetDistance or 2.0,
			canInteract = function()
				return not NuiOpen and not CurrentlyWashing and HasLocationJob(point.requiredJob)
			end,
			onSelect = function()
				OpenWashUI(point.index)
			end,
		},
	})

	point.entity = ped
end

local function CleanupWashPoints()
	for i = 1, #WashPoints do
		local point = WashPoints[i]
		RemoveWashPed(point)
		point:remove()
	end
	WashPoints = {}
end

local function SetupWashPoints()
	if GetResourceState('ox_target') ~= 'started' then return end

	CleanupWashPoints()

	for i = 1, #Config.WashLocations do
		local coords, requiredJob, _, pedModel = GetLocationData(i)
		if not coords then goto continue end

		WashPoints[#WashPoints + 1] = lib.points.new({
			coords = vec3(coords.x, coords.y, coords.z),
			distance = 50.0,
			index = i,
			coords4 = coords,
			requiredJob = requiredJob,
			pedModel = pedModel,
			targetName = ('moneywash_use_%s'):format(i),
			entity = nil,
			onEnter = function(self)
				CreateThread(function()
					for _ = 1, 6 do
						if not self.inside then return end
						RequestCollisionAtCoord(self.coords4.x, self.coords4.y, self.coords4.z)
						Wait(500)
						if not self.inside then return end
						SpawnWashPed(self)
						if self.entity and DoesEntityExist(self.entity) then return end
					end
				end)
			end,
			onExit = RemoveWashPed,
		})

		::continue::
	end
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	CachedJobName = xPlayer and xPlayer.job and xPlayer.job.name or nil
	SetupWashPoints()
end)

CreateThread(function()
	while not ESX.PlayerLoaded do Wait(200) end
	while GetResourceState('ox_target') ~= 'started' do Wait(200) end
	RefreshJobCache()
	SetupWashPoints()
end)

AddEventHandler('onResourceStart', function(resource)
	if resource ~= ResourceName then return end
	if not ESX.PlayerLoaded then return end
	CreateThread(function()
		while GetResourceState('ox_target') ~= 'started' do Wait(200) end
		RefreshJobCache()
		SetupWashPoints()
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource ~= ResourceName then return end
	if NuiOpen then SetNuiFocus(false, false) end
	CleanupWashPoints()
end)
