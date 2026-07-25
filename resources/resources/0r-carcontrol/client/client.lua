Core, FW = GetCore()

TriggerCallback = nil

vehicledatas = {}

local nui = false
local mode = "normal"

CreateThread(function()
    while FW == nil do Wait(500) end
    if FW == 'qb' or FW == 'oldqb' then
        TriggerCallback = Core.Functions.TriggerCallback
    elseif FW == 'esx' or FW == 'oldesx' then
        TriggerCallback = Core.TriggerServerCallback
    end
end)

if Config.DisableSeatShuffle then
    local function getPedVehicleSeat(ped, vehicle)
        for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
            if GetPedInVehicleSeat(vehicle, seat) == ped then
                return seat
            end
        end
    end

    CreateThread(function()
        while true do
            local playerPed = PlayerPedId()

            if IsPedInAnyVehicle(playerPed, false) then
                SetPedConfigFlag(playerPed, 184, true)

                if GetIsTaskActive(playerPed, 165) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local seat = getPedVehicleSeat(playerPed, vehicle)

                    if seat ~= nil then
                        SetPedIntoVehicle(playerPed, vehicle, seat)
                    end
                end

                Wait(0)
            else
                Wait(500)
            end
        end
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('0r-carcontrol:loaded')
end)

RegisterNetEvent('esx:playerLoaded', function()
    TriggerServerEvent('0r-carcontrol:loaded')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Wait(2000)
        TriggerServerEvent('0r-carcontrol:loaded')
    end
  end)

RegisterCommand(Config.Command, function()
    if not nui then
        if IsPedInAnyVehicle(PlayerPedId()) then
            SendNUIMessage({
                action = 'open',
                seats = GetVehicleModelNumberOfSeats(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))
            })
            nui = true
            SetNuiFocus(true,true)
            SetNuiFocusKeepInput(false)
        end
    end
end)

RegisterKeyMapping(Config.Command, 'Open Car Control', 'keyboard', Config.KeyBind)

RegisterNuiCallback('close', function()
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    nui = false
end)

RegisterNuiCallback('close2', function()
    SetNuiFocusKeepInput(true)
end)

RegisterNUICallback('opendoor', function(data)
    if not isDriver() then return end
    local door = data.door
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if GetVehicleDoorLockStatus(vehicle) < 2 then
        if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
            SetVehicleDoorShut(vehicle, door, false)
        else
            SetVehicleDoorOpen(vehicle, door, false)
        end
    end
end)

RegisterNuiCallback('seat', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if IsVehicleSeatFree(vehicle, data.door) then
        SetPedIntoVehicle(PlayerPedId(), vehicle, data.door)
    end
end)

RegisterNUICallback('openw', function(data)
    if not isDriver() then return end
    RollDownWindows(GetVehiclePedIsIn(PlayerPedId()))
end)

RegisterNUICallback('closew', function(data)
    if not isDriver() then return end
    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 0)
    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 1)
    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 2)
    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 3)
end)

RegisterNUICallback('driftmode', function(data)
    if not isDriver() then return end
    TriggerServerEvent('0r-carcontrol:setcarmode', GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())), 'drift')
    SetDriftTyresEnabled(GetVehiclePedIsIn(PlayerPedId()), true)
end)

RegisterNUICallback('normalmode', function(data)
    if not isDriver() then return end
    TriggerServerEvent('0r-carcontrol:setcarmode', GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())), 'normal')
    SetDriftTyresEnabled(GetVehiclePedIsIn(PlayerPedId()), false)
    SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId()),  1.0)
    SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(PlayerPedId()), 1.0)
end)

RegisterNUICallback('sportmode', function(data)
    if not isDriver() then return end
    SetDriftTyresEnabled(GetVehiclePedIsIn(PlayerPedId()), false)
    TriggerServerEvent('0r-carcontrol:setcarmode', GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())), 'sport')
    -- SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId()), 15.0)
    -- SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(PlayerPedId()), 15.0)
end)

RegisterNUICallback('driftmode2', function(data)
    if not isDriver() then return end
    SetDriftTyresEnabled(GetVehiclePedIsIn(PlayerPedId()), true)
end)

RegisterNUICallback('normalmode2', function(data)
    if not isDriver() then return end
    SetDriftTyresEnabled(GetVehiclePedIsIn(PlayerPedId()), false)
    SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId()),  1.0)
    SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(PlayerPedId()), 1.0)
end)

RegisterNUICallback('sportmode2', function(data)
    if not isDriver() then return end
    SetDriftTyresEnabled(GetVehiclePedIsIn(PlayerPedId()), false)
    -- SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId()), 15.0)
    -- SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(PlayerPedId()), 15.0)
end)


RegisterNuiCallback('toggleengine', function()
    if not isDriver() then return end
    if GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId())) then
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), false, false, true)
    else
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), true)
    end
end)


local hazard = false
RegisterNuiCallback('hazard', function()
    if not isDriver() then return end
    hazard = not hazard
    if hazard then
        SetVehicleIndicatorLights(GetVehiclePedIsIn(PlayerPedId()), 0, true)
        SetVehicleIndicatorLights(GetVehiclePedIsIn(PlayerPedId()), 1, true)
    else
        SetVehicleIndicatorLights(GetVehiclePedIsIn(PlayerPedId()), 0, false)
        SetVehicleIndicatorLights(GetVehiclePedIsIn(PlayerPedId()), 1, false)
    end
end)

local lights = false
RegisterNuiCallback('light', function()
    if not isDriver() then return end
    local veh = GetVehiclePedIsIn(PlayerPedId())
    lights = not lights
    if lights then 
        SetVehicleLights(veh, 1)
    else
        SetVehicleLights(veh, 3)
    end

end)


RegisterNuiCallback('interior', function()
    if not isDriver() then return end
    local veh = GetVehiclePedIsIn(PlayerPedId())
    if not IsVehicleInteriorLightOn(veh) then 
        SetVehicleInteriorlight(veh, 1)
    else
        SetVehicleInteriorlight(veh, 0)
    end
end)

currentype = {}

RegisterNuiCallback('openneon', function()
    if not isDriver() then return end
    local veh = GetVehiclePedIsIn(PlayerPedId())
    if IsVehicleNeonLightEnabled(veh, 0) then
        SetVehicleNeonLightsColour(veh, 255.0,255.0,255.0)
        SetVehicleNeonLightEnabled(veh, 0, false)
        SetVehicleNeonLightEnabled(veh, 1, false)
        SetVehicleNeonLightEnabled(veh, 2, false)
        SetVehicleNeonLightEnabled(veh, 3, false)
    else
        local plate = string.gsub(GetVehicleNumberPlateText(veh), '^%s*(.-)%s*$', '%1'):upper()
        currentype[plate] = nil
        SetVehicleNeonLightEnabled(veh, 0, true)
        SetVehicleNeonLightEnabled(veh, 1, true)
        SetVehicleNeonLightEnabled(veh, 2, true)
        SetVehicleNeonLightEnabled(veh, 3, true)
    end
end)

RegisterNUICallback('neon', function(data)
    if not isDriver() then return end
    NeonCustom(data.mode)
end)

function NeonCustom(type)
    if not isDriver() then return end
	local veh = GetVehiclePedIsIn(PlayerPedId())
	local plate = string.gsub(GetVehicleNumberPlateText(veh), '^%s*(.-)%s*$', '%1'):upper()
	currentype[plate] = type
	if type == 'neon1' then
		CreateThread(function()
			local r,g,b = GetVehicleNeonLightsColour(veh)
			while currentype[plate] == type do
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(veh, i, true)
				end
				Citizen.Wait(222)
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(veh, i, false)
				end
				Citizen.Wait(222)
			end
			SetVehicleNeonLightsColour(veh,r,g,b)
			return
		end)
	elseif type == 'neon2' then
		CreateThread(function()
			local r,g,b = GetVehicleNeonLightsColour(veh)
			while currentype[plate] == type do
				rand = math.random(1,4) - 1
				math.randomseed(GetGameTimer())
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				for i = rand, rand do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				Wait(55)
				for i = rand, rand do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				Wait(55)
				for i = rand, rand do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				Wait(55)
				for i = rand, rand do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				Wait(155)
				SetVehicleNeonLightsColour(veh,r,g,b)
			end
			return
		end)
	elseif type == 'random' then
		CreateThread(function()
			local r,g,b = GetVehicleNeonLightsColour(veh)
			while currentype[plate] == type do
				math.randomseed(GetGameTimer())
				SetVehicleNeonLightsColour(veh,math.random(1,255),math.random(1,255),math.random(1,255))
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				Wait(222)
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(veh, i, math.random(1,100) < 50)
				end
				Wait(222)
			end
			SetVehicleNeonLightsColour(veh,r,g,b)
			return
		end)
	else
		for i = 0, 3 do
			SetVehicleNeonLightEnabled(veh, i, true)
		end
	end
end

function getLocationInfo()
    local locationInfo = {}
    local playerCoords = GetEntityCoords(PlayerPedId(), true)
    local streetNames, crossingRoad  = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local streetName1 = GetStreetNameFromHashKey(streetNames)
    locationInfo.myHeading = GetEntityHeading(PlayerPedId())
    local streetName2 = GetStreetNameFromHashKey(crossingRoad)

    locationInfo.zone = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)
    locationInfo.zoneLabel = GetLabelText(locationInfo.zone)

    if streetName2 ~= nil and streetName2 ~= '' then
        locationInfo.street1 = streetName1
        locationInfo.street2 = streetName2
    else
        if streetName1 ~= nil and streetName1 ~= '' then
            locationInfo.street1 = streetName1
            locationInfo.street2 = ''
        else
            locationInfo.street1 = ''
            locationInfo.street2 = ''
        end
    end

    if IsWaypointActive() then
        local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
        local heading = GetHeadingFromVector_2d(waypointCoords.x - playerCoords.x, waypointCoords.y - playerCoords.y)

        locationInfo.waypointActive = true
        locationInfo.distanceToWaypoint = CalculateTravelDistanceBetweenPoints(playerCoords.x, playerCoords.y, playerCoords.z, waypointCoords.x, waypointCoords.y, waypointCoords.z) * 0.000625
        locationInfo.waypointHeading = heading
    else
        locationInfo.waypointActive = false
        locationInfo.distanceToWaypoint = 0
        locationInfo.waypointHeading = 0
    end 
    return locationInfo
end


local inside = false
local inside2 = false

CreateThread(function()
    while FW == nil do Wait(500) end
	while true do
        local ms = Config.WaitTime
        local person = PlayerPedId()
        local car = GetVehiclePedIsUsing(person)
        local plate = GetVehicleNumberPlateText(car)
		if IsPedInAnyVehicle(person) then
            TriggerCallback('0r-carcontrol:getvehmode', function(gelenmode)
                mode = gelenmode
            end, plate)
            Wait(500)
            inside = true


            local fuel = (GetVehicleFuelLevel(car)*1.4)
            local hasar = (GetVehicleBodyHealth(car))
            local blip = GetFirstBlipInfoId(8)
            local blipCoords = nil
            local metre = 0
            if (blip ~= 0) then
                blipCoords = GetBlipCoords(blip)
                local pedCoords = GetEntityCoords(person)
                local data = getLocationInfo(blipCoords)
                metre = data.distanceToWaypoint
                currentStreetName = data.street1
                zone = data.street2
            end
            
            dooropened = false
            for i = 0, 3 do
                local doorsangle = GetVehicleDoorAngleRatio(car, i)
                if doorsangle ~= 0.0 then
                    dooropened = true
                end
            end

            if Config.Mileage then
                TriggerCallback('0r-carcontrol:GetMileage', function(mil)
                    mileage = mil
                end, plate)
            end

            if not inside2 then 
                inside2 = true
                SendNUIMessage({
                    action = 'updatemode',
                    mode = mode
                })
            end

            if mileage == nil then mileage = 0 end
            local currentWeather = GetWeatherTypeTransition()
            local weatherName = GetDisplayNameFromWeather(currentWeather)
            SendNUIMessage({
                action = 'thick';
                street = currentStreetName;
                area = area;
                fuel = fuel;
                motor = hasar;
                mesafe = metre;
                class = Config.VehClass[GetVehicleClass(car)];
                displayName = GetDisplayNameFromVehicleModel(GetEntityModel(car));
                body = GetVehicleBodyHealth(car);
                engine = GetVehicleEngineHealth(car);
                tyre = GetTyreHealth(car, 1);
                petrol = GetVehiclePetrolTankHealth(car);
                hava = weatherName;
                mileage = mileage;
                driver = isDriver();
                vehdata = GetVehicleData();

            })

            if Config.Mileage then
                local currentCoords = GetEntityCoords(car)
                Wait(1000)
                local updatedCoords = GetEntityCoords(car)

                local traveled = #(updatedCoords - currentCoords) / 100

                if traveled > 0 then 
                    TriggerServerEvent("0r-carcontrol:AddMileage", plate, traveled)
                end
            end
        else
            if inside then
                inside = false
                SendNUIMessage({
                    action = 'close3'
                })
                inside2 = false
            end
        end
        Wait(ms)
	end
end)

function GetDisplayNameFromWeather(weatherType)
    local weatherNames = {
        [GetHashKey("CLEAR")] = "CLEAR",
        [GetHashKey("CLOUDS")] = "CLOUDS",
        [GetHashKey("RAIN")] = "RAIN",
        [GetHashKey("THUNDER")] = "THUNDER",
        [GetHashKey("SNOW")] = "SNOW",
        [GetHashKey("FOGGY")] = "FOGGY",
        [GetHashKey("EXTRASUNNY")] = "EXTRASUNNY",
        [GetHashKey("OVERCAST")] = "OVERCAST",
        [GetHashKey("XMAS")] = "XMAS",
    }

    return weatherNames[weatherType] or "Unknown"
end

function isDriver()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local driverPed = GetPedInVehicleSeat(vehicle, -1)
        if driverPed == playerPed then
            return true
        else
            return false
        end
    else
        return false
    end
end

function GetVehicleData()
    local ped = PlayerPedId()
    local vehicle2 = GetVehiclePedIsIn(ped)
    local plate = GetVehicleNumberPlateText(vehicle2)
    return {
        door1 = GetVehicleDoorAngleRatio(vehicle2, 0),
        door2 = GetVehicleDoorAngleRatio(vehicle2, 2),
        door3 = GetVehicleDoorAngleRatio(vehicle2, 1),
        door4 = GetVehicleDoorAngleRatio(vehicle2, 3),
        hood = GetVehicleDoorAngleRatio(vehicle2, 4),
        trunk = GetVehicleDoorAngleRatio(vehicle2, 5),
        window = IsVehicleWindowIntact(vehicle2, 0)
    }
end