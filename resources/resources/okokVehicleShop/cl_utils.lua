ESX = exports.es_extended:getSharedObject()
local Translations = Locales[Config.Locale]
local missionBlips = {}
MissionCanceled = false

-- Functions

RegisterNetEvent("okokVehicleShop:notification")
AddEventHandler("okokVehicleShop:notification", function(title, text, time, type)
    if Config.UseOkokNotify then
        exports['okokNotify']:Alert(title, text, time, type)
    else
        ESX.ShowNotification(text)
    end
end)

function TextUI(text)
	if Config.UseOkokTextUI then
		if text ~= nil then
			exports['okokTextUI']:Open("[E] " .. text, 'darkblue', 'left')
		else
			exports['okokTextUI']:Close()
		end
	else
		if text ~= nil then
			ESX.TextUI(text)
		else
			ESX.HideUI()
		end
	end
end

function GiveVehicleKeys(vehicle, plate)
	-- Give vehicle keys here
end

function RemoveVehicleKeys(vehicle, plate)
    -- Remove your vehicle keys here
end

function SetVehicleFuelLevelCustom(vehicle, level)
    -- Set the fuel level of the vehicle
end

function GetVehiclePropertiesCustom(vehicle)
    return ESX.Game.GetVehicleProperties(vehicle)
end

function RemoveVehicleCustom(vehicle)
    -- You can remove persisent vehicles here
end

function GetTrunkWeight(vehicle, callback)
	-- You can add your own inventory system here
	if callback then
		Citizen.CreateThread(function()
			Wait(0)
			callback(0)
		end)
	end
	return
end

-- Events

RegisterNetEvent("okokVehicleShop:startMission")
AddEventHandler("okokVehicleShop:startMission", function(vehicle_id, mission_id, standInfo, vehicleName, vehicleColor)

	local VehicleColorCustom = nil

	if vehicleColor then
		vehicleColor = json.decode(vehicleColor)
		if vehicleColor?.r and vehicleColor?.g and vehicleColor?.b then
			VehicleColorCustom = vehicleColor
		end
	end

	local hash = GetHashKey(Config.SmallTowTruckID)
	local trailerHash = GetHashKey(Config.TrailerID)
	local vehicleHash = GetHashKey(vehicle_id)
	local ped = PlayerPedId()
    local doingMission = true
	local isTowed = false
	local shown = false
    local missionTruck = nil
    local missionTrailer = 0
    local mission = nil
    local randomIndex = 1
    local missionVehicle = nil

    if #standInfo.missionsVehicleSpawn > 1 then
        randomIndex = math.random(1, #standInfo.missionsVehicleSpawn)
    end
    mission = standInfo.missionsVehicleSpawn[randomIndex]

	if not standInfo.flatbedSettings.bigVehicles then
		hash = GetHashKey(Config.SmallTowTruckID)
	else
		hash = GetHashKey(Config.BigTowTruckID)

		if not HasModelLoaded(trailerHash) then
			RequestModel(trailerHash)
			while not HasModelLoaded(trailerHash) do
				Wait(10)
			end
		end
	end

	if not HasModelLoaded(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Wait(10)
		end
	end

	if missionTruck ~= nil then
		DeleteEntity(missionTruck)
		missionTruck = nil
	end

	missionTruck = CreateVehicle(hash, standInfo.flatbedSettings.spawnPosition.x, standInfo.flatbedSettings.spawnPosition.y, standInfo.flatbedSettings.spawnPosition.z, standInfo.flatbedSettings.spawnPosition.w, true, false)
    SetVehicleDirtLevel(missionTruck, 0.0)
    local plate = GetVehicleNumberPlateText(missionTruck)
    GiveVehicleKeys(missionTruck, plate)

	if not standInfo.flatbedSettings.bigVehicles then
		flatbedvehicle = missionTruck
		TriggerEvent("okokVehicleShop:setupFlatbed", missionTruck)
	end

	if standInfo.flatbedSettings.bigVehicles then
		local trailerCoords = GetOffsetFromEntityInWorldCoords(missionTruck, 0.0, -10.5, 0.0)
		missionTrailer = CreateVehicle(trailerHash, trailerCoords.x, trailerCoords.y, trailerCoords.z, standInfo.flatbedSettings.spawnPosition.h, true, false)
		SetVehicleDirtLevel(missionTrailer, 0.0)
	end

	while not DoesEntityExist(missionTruck) do
		Wait(100)
	end
	TriggerEvent('okokVehicleShop:notification', Translations.got_to_truck.title, Translations.got_to_truck.text, Translations.got_to_truck.time, Translations.got_to_truck.type)

	if not standInfo.flatbedSettings.bigVehicles then
		if Config.UseTarget then
			if Config.TargetSystem == 'ox-target' then
				exports.ox_target:addLocalEntity(missionTruck, {
					{
						label = Translations.translations.raisebed,
						name = "okokVehicleShop:raiseFlatbed",
						icon = "fas fa-caret-up",
						onSelect = function()
							TriggerEvent("okokVehicleShop:raiseFlatbed")
						end
					},
					{
						label = Translations.translations.lowerbed,
						name = "okokVehicleShop:lowerFlatbed",
						icon = "fas fa-caret-down",
						onSelect = function()
							TriggerEvent("okokVehicleShop:lowerFlatbed")
						end
					},
					{
						label = Translations.translations.attachvehicle,
						name = "okokVehicleShop:attachVehicle",
						icon = "fas fa-lock",
						onSelect = function()
							TriggerEvent("okokVehicleShop:attachVehicle")
						end
					},
				}, {
					distance = 3.0
				})
			end
		end
	end

	missionBlips.truck = AddBlipForCoord(standInfo.flatbedSettings.spawnPosition.x, standInfo.flatbedSettings.spawnPosition.y, standInfo.flatbedSettings.spawnPosition.z)
	SetBlipSprite(missionBlips.truck, Config.TruckBlip.blipId)
	SetBlipDisplay(missionBlips.truck, 4)
	SetBlipScale(missionBlips.truck, Config.TruckBlip.blipScale)
	SetBlipColour(missionBlips.truck, Config.TruckBlip.blipColor)
	SetBlipAsShortRange(missionBlips.truck, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.TruckBlip.blipText)
	EndTextCommandSetBlipName(missionBlips.truck)

	if missionBlips.trailer == nil then
		local trailerCoords = GetEntityCoords(missionTrailer)
		missionBlips.trailer = AddBlipForCoord(trailerCoords.x, trailerCoords.y, trailerCoords.z)
		SetBlipSprite(missionBlips.trailer, Config.TrailerBlip.blipId)
		SetBlipDisplay(missionBlips.trailer, 4)
		SetBlipScale(missionBlips.trailer, Config.TrailerBlip.blipScale)
		SetBlipColour(missionBlips.trailer, Config.TrailerBlip.blipColor)
		SetBlipAsShortRange(missionBlips.trailer, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.TrailerBlip.blipText)
		EndTextCommandSetBlipName(missionBlips.trailer)
	end

	local hasTrailer = true
	local setFuel = true
	local failedToLoad = false
	local inVehicleRange = false

	while doingMission do
		Wait(1)
		local waitMore = true
		local inZone = false
		if MissionCanceled then break end
		if standInfo.flatbedSettings.bigVehicles then
			hasTrailer = GetVehicleTrailerVehicle(missionTruck)
		end

		if GetVehiclePedIsIn(ped, false) == missionTruck then
			if setFuel then
				if GetIsVehicleEngineRunning(missionTruck) then
					setFuel = false
					SetVehicleFuelLevel(missionTruck, 100.0)
				end
			end
			if hasTrailer then
				if missionBlips.trailer ~= nil then
					RemoveBlip(missionBlips.trailer)
						missionBlips.trailer = nil
				end
				local playerCoords = GetEntityCoords(ped)
				if not isTowed then
					local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, mission.x, mission.y, mission.z, false)
					if distance < 250 and missionVehicle == nil then

						if not HasModelLoaded(vehicleHash) then

							RequestModel(vehicleHash)
							while not HasModelLoaded(vehicleHash) do
								Wait(10)
							end
						end

						missionVehicle = CreateVehicle(vehicleHash, mission.x, mission.y, mission.z, mission.h, false, false)

						local time = 0
						while not DoesEntityExist(missionVehicle) do
							Wait(10)
							time = time + 10
							if time >= 5000 then
								failedToLoad = true
								TriggerEvent('okokVehicleShop:notification', Translations.failed_to_load.title, Translations.failed_to_load.text, Translations.failed_to_load.time, Translations.failed_to_load.type)
								break
							end
						end

						GiveVehicleKeys(missionVehicle, GetVehicleNumberPlateText(missionVehicle))

						if not inVehicleRange then
							local coord = GetEntityCoords(missionVehicle)
							if missionBlips.order ~= nil then
								RemoveBlip(missionBlips.order)
								missionBlips.order = nil
							end
							if missionBlips.order == nil then
								missionBlips.order = AddBlipForCoord(coord.x, coord.y, coord.z)
								SetBlipSprite(missionBlips.order, Config.OrderBlip.blipId)
								SetBlipColour(missionBlips.order, Config.OrderBlip.blipColor)
								if VehicleColorCustom then
									SetVehicleCustomPrimaryColour(missionVehicle, VehicleColorCustom.r, VehicleColorCustom.g, VehicleColorCustom.b)
									SetVehicleCustomSecondaryColour(missionVehicle, VehicleColorCustom.r, VehicleColorCustom.g, VehicleColorCustom.b)
								else
									SetVehicleCustomPrimaryColour(missionVehicle, VehicleColor.r, VehicleColor.g, VehicleColor.b)
									SetVehicleCustomSecondaryColour(missionVehicle, VehicleColor.r, VehicleColor.g, VehicleColor.b)
								end
								SetBlipAsShortRange(missionBlips.order, false)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(Config.OrderBlip.blipText)
								EndTextCommandSetBlipName(missionBlips.order)
								SetBlipRoute(missionBlips.order, true)
							end
							inVehicleRange = true
						end

						if not failedToLoad then
							SetVehicleDirtLevel(missionVehicle, 0.0)
							SetVehicleDoorsLockedForAllPlayers(missionVehicle, true)
						else
							DeleteEntity(missionVehicle)
							missionVehicle = nil
							if missionBlips.order ~= nil then
								RemoveBlip(missionBlips.order)
								missionBlips.order = nil
							end
							isTowed = true
						end
					end
				else
					local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, standInfo.flatbedSettings.spawnPosition.x, standInfo.flatbedSettings.spawnPosition.y, standInfo.flatbedSettings.spawnPosition.z, false)
					if distance < 100 then
						waitMore = false
						DrawMarker(Config.TowMarker.id, standInfo.flatbedSettings.spawnPosition.x, standInfo.flatbedSettings.spawnPosition.y, standInfo.flatbedSettings.spawnPosition.z, 0, 0, 0, 0, 0, 0, Config.TowMarker.size.x, Config.TowMarker.size.y, Config.TowMarker.size.z, Config.TowMarker.color.r, Config.TowMarker.color.g, Config.TowMarker.color.b, Config.TowMarker.color.a, Config.TowMarker.bobUpAndDown, Config.TowMarker.faceCamera, 2, Config.TowMarker.rotate, Config.TowMarker.textureDict, Config.TowMarker.textureName, Config.TowMarker.drawOnEnts)
						if distance < 5 then
							break
						end
					end
				end

				if missionBlips.order == nil then
					missionBlips.order = AddBlipForCoord(mission.x, mission.y, mission.z)
					SetBlipSprite(missionBlips.order, Config.OrderBlip.blipId)
					SetBlipColour(missionBlips.order, Config.OrderBlip.blipColor)
					SetBlipAsShortRange(missionBlips.order, false)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(Config.OrderBlip.blipText)
					EndTextCommandSetBlipName(missionBlips.order)
					SetBlipRoute(missionBlips.order, true)
				end
			else
				if missionBlips.order ~= nil then
					RemoveBlip(missionBlips.order)
					missionBlips.order = nil
				end

				if missionBlips.trailer == nil then
					local trailerCoords = GetEntityCoords(missionTrailer)
					missionBlips.trailer = AddBlipForCoord(trailerCoords.x, trailerCoords.y, trailerCoords.z)
					SetBlipSprite(missionBlips.trailer, Config.TrailerBlip.blipId)
					SetBlipDisplay(missionBlips.trailer, 4)
					SetBlipScale(missionBlips.trailer, Config.TrailerBlip.blipScale)
					SetBlipColour(missionBlips.trailer, Config.TrailerBlip.blipColor)
					SetBlipAsShortRange(missionBlips.trailer, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(Config.TrailerBlip.blipText)
					EndTextCommandSetBlipName(missionBlips.trailer)
				end
			end

			if missionBlips.truck ~= nil then
				RemoveBlip(missionBlips.truck)
				missionBlips.truck = nil
			end

		elseif GetVehiclePedIsIn(ped, false) == 0 then
			local playerCoords = GetEntityCoords(ped)
			local truckCoordsForLocking = GetEntityCoords(missionTruck)
			local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, truckCoordsForLocking.x, truckCoordsForLocking.y, truckCoordsForLocking.z, false)

			if missionBlips.truck == nil then
				local truckCoords = GetEntityCoords(missionTruck)
				missionBlips.truck = AddBlipForCoord(truckCoords.x, truckCoords.y, truckCoords.z)
				SetBlipSprite(missionBlips.truck, Config.TruckBlip.blipId)
				SetBlipDisplay(missionBlips.truck, 4)
				SetBlipScale(missionBlips.truck, Config.TruckBlip.blipScale)
				SetBlipColour(missionBlips.truck, Config.TruckBlip.blipColor)
				SetBlipAsShortRange(missionBlips.truck, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.TruckBlip.blipText)
				EndTextCommandSetBlipName(missionBlips.truck)
			end

			if hasTrailer then
				if missionBlips.trailer ~= nil then
					RemoveBlip(missionBlips.trailer)
					missionBlips.trailer = nil
				end
				if missionVehicle ~= nil then
					waitMore = false
					local truckCoords = nil
					if standInfo.flatbedSettings.bigVehicles then
						truckCoords = GetOffsetFromEntityInWorldCoords(missionTrailer, 0.0, -7.5, 0.0)
					else
						truckCoords = GetOffsetFromEntityInWorldCoords(missionTruck, 0.0, -6.5, 0.0)
					end

					local orderCoords = GetEntityCoords(missionVehicle)
					local distanceTruck = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, truckCoords.x, truckCoords.y, truckCoords.z, false)
					local distanceOrder = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, orderCoords.x, orderCoords.y, orderCoords.z, false)
					if not isTowed then
						if standInfo.flatbedSettings.bigVehicles then
							DrawMarker(Config.TowMarker.id, truckCoords.x, truckCoords.y, truckCoords.z, 0, 0, 0, 0, 0, 0, Config.TowMarker.size.x, Config.TowMarker.size.y, Config.TowMarker.size.z, Config.TowMarker.color.r, Config.TowMarker.color.g, Config.TowMarker.color.b, Config.TowMarker.color.a, Config.TowMarker.bobUpAndDown, Config.TowMarker.faceCamera, 2, Config.TowMarker.rotate, Config.TowMarker.textureDict, Config.TowMarker.textureName, Config.TowMarker.drawOnEnts)
						end
						if distanceTruck < 1 or isMissionVehicleAttached then
							if standInfo.flatbedSettings.bigVehicles then
								inZone = true
								if IsControlJustReleased(0, Config.Key) then
									local maxDistance = 6
									if standInfo.flatbedSettings.bigVehicles then
										maxDistance = 8
									end
									if distanceOrder < maxDistance then
										isTowed = true
										AttachEntityToEntity(missionVehicle, missionTrailer, GetEntityBoneIndexByName(missionTrailer, 'bodyshell'), standInfo.flatbedSettings.towCoords.xPos, standInfo.flatbedSettings.towCoords.yPos, standInfo.flatbedSettings.towCoords.zPos, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
										if missionBlips.order ~= nil then
											RemoveBlip(missionBlips.order)
												missionBlips.order = nil
										end
										if missionBlips.order == nil then
											missionBlips.order = AddBlipForCoord(standInfo.flatbedSettings.spawnPosition.x, standInfo.flatbedSettings.spawnPosition.y, standInfo.flatbedSettings.spawnPosition.z)
											SetBlipSprite(missionBlips.order, Config.OrderBlip.blipId)
											SetBlipColour(missionBlips.order, Config.OrderBlip.blipColor)
											SetBlipAsShortRange(missionBlips.order, false)
											BeginTextCommandSetBlipName("STRING")
											AddTextComponentString(Config.OrderBlip.blipText)
											EndTextCommandSetBlipName(missionBlips.order)
											SetBlipRoute(missionBlips.order, true)
										end
										TriggerEvent('okokVehicleShop:notification', Translations.towed.title, string.format(Translations.towed.text, vehicleName), Translations.towed.time, Translations.towed.type)
									else
										TriggerEvent('okokVehicleShop:notification', Translations.not_towing.title, Translations.not_towing.text, Translations.not_towing.time, Translations.not_towing.type)
									end
								end

							else
								if standInfo.flatbedSettings.bigVehicles then inZone = true end

								local maxDistance = 6

								if standInfo.flatbedSettings.bigVehicles then
									maxDistance = 8
								end

								if distanceOrder < maxDistance or isMissionVehicleAttached then
									isTowed = true
									AttachEntityToEntity(missionVehicle, missionTruck, GetEntityBoneIndexByName(missionTruck, 'bodyshell'), standInfo.flatbedSettings.towCoords.xPos, standInfo.flatbedSettings.towCoords.yPos, standInfo.flatbedSettings.towCoords.zPos, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
									if missionBlips.order ~= nil then
										RemoveBlip(missionBlips.order)
										missionBlips.order = nil
									end

									if missionBlips.order == nil then
										missionBlips.order = AddBlipForCoord(standInfo.flatbedSettings.spawnPosition.x, standInfo.flatbedSettings.spawnPosition.y, standInfo.flatbedSettings.spawnPosition.z)
										SetBlipSprite(missionBlips.order, Config.OrderBlip.blipId)
										SetBlipColour(missionBlips.order, Config.OrderBlip.blipColor)
										SetBlipAsShortRange(missionBlips.order, false)
										BeginTextCommandSetBlipName("STRING")
										AddTextComponentString(Config.OrderBlip.blipText)
										EndTextCommandSetBlipName(missionBlips.order)
										SetBlipRoute(missionBlips.order, true)
									end
									TriggerEvent('okokVehicleShop:notification', Translations.towed.title, string.format(Translations.towed.text, vehicleName), Translations.towed.time, Translations.towed.type)
								else
									TriggerEvent('okokVehicleShop:notification', Translations.not_towing.title, Translations.not_towing.text, Translations.not_towing.time, Translations.not_towing.type)
								end
							end
						end
					end
				end
			else
				if missionBlips.trailer == nil then
					local trailerCoords = GetEntityCoords(missionTrailer)
					missionBlips.trailer = AddBlipForCoord(trailerCoords.x, trailerCoords.y, trailerCoords.z)
					SetBlipSprite(missionBlips.trailer, Config.TrailerBlip.blipId)
					SetBlipDisplay(missionBlips.trailer, 4)
					SetBlipScale(missionBlips.trailer, Config.TrailerBlip.blipScale)
					SetBlipColour(missionBlips.trailer, Config.TrailerBlip.blipColor)
					SetBlipAsShortRange(missionBlips.trailer, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(Config.TrailerBlip.blipText)
					EndTextCommandSetBlipName(missionBlips.trailer)
				end
			end
		end

		if not shown and inZone then
			shown = true
			if Config.UseOkokTextUI then
				TextUI(Translations.translations.towvehicle)
			else
				TriggerEvent('okokVehicleShop:notification', Translations.translations.towvehicle, Translations.translations.towvehicle, 5000, 'info')
			end
		elseif shown and not inZone then
			shown = false
			if Config.UseOkokTextUI then
				TextUI()
			end
		end

		if waitMore then
			Wait(1000)
		end
	end

	if missionBlips.truck ~= nil then
		RemoveBlip(missionBlips.truck)
		missionBlips.truck = nil
	end

	if missionBlips.order ~= nil then
		RemoveBlip(missionBlips.order)
		missionBlips.order = nil
	end
	TriggerEvent("okokVehicleShop:onFinishMission", missionTruck)
	if missionTruck ~= nil then
		DeleteEntity(missionTruck)
		missionTruck = nil
	end

	if flatbedBed ~= nil then
		DeleteEntity(flatbedBed)
		flatbedBed = 0
	end

	if missionTrailer ~= nil then
		DeleteEntity(missionTrailer)
		missionTrailer = 0
	end

	if missionVehicle ~= nil then
		DeleteEntity(missionVehicle)
		missionVehicle = nil
	end

	flatbedvehicle = 0
	isBedLowered = false
	isBedInAction = false
	bedInfo = {
		prop = nil,
		attached = nil,
		inaction = false,
		lowered = false
	}

	if not MissionCanceled then
		isMissionVehicleAttached = false
		TriggerServerEvent("okokVehicleShop:endMission", mission_id, standInfo)
	end
end)

-- Vehicle Plate Generator

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end

for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(0)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

        if Config.EnablePlatePrefix then
            local prefixLength = string.len(Config.PlatePrefix)
            generatedPlate = string.sub(generatedPlate, 1, -prefixLength)
            generatedPlate = Config.PlatePrefix .. generatedPlate
        end

		local isPlateTaken = lib.callback.await('okokVehicleShop:isPlateTaken', false, generatedPlate)

        if not isPlateTaken then doBreak = true end

		if doBreak then break end
	end

	return generatedPlate
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end