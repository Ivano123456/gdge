--[[ /dajauto — iskljuceno
local NumberCharset = {}
local Charset = {}
RegisterCommand("dajauto", function()
	ESX.TriggerServerCallback("jamaica-utils:JelImaPerme", function(jel)
		if jel then 
			local input = lib.inputDialog('Setanje Automobila', {
				{ type = "input", label = "ID Igraca", placeholder = "420" },
				{ type = "input", label = "Model Automobila", placeholder = "rmodrs6" },
			})
			if not input then return end
				ESX.Game.SpawnVehicle(input[2], GetEntityCoords(PlayerPedId()), 69.300827, function (vehicle)
					local newPlate = generisitablice()
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
					SetVehicleNumberPlateText(vehicle, newPlate)
					TriggerServerEvent('jamaica-utils:InsertajVozilo', tonumber(input[1]), vehicleProps)
					DeleteVehicle(vehicle)
				end)
		else
			ESX.ShowNotification("Nemate permisije za ovu komandu")
		end 
	end)
end)
]]

--[[
for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function generisitablice()
	local generisanaTablica
	local daPrekine = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generisanaTablica = string.upper(GetRandomLetter(Config.SlovaTablice) ..
				' ' .. GetRandomNumber(Config.SlovaTablice))
		else
			generisanaTablica = string.upper(GetRandomLetter(Config.SlovaTablice) .. GetRandomNumber(Config.BrojeviTablice))
		end

		ESX.TriggerServerCallback('jamaica-utils:jelImaTablicu', function(jeltablicauzeta)
			if not jeltablicauzeta then
				daPrekine = true
			end
		end, generisanaTablica)

		if daPrekine then
			break
		end
	end

	return generisanaTablica
end

exports("generisi", generisitablice)

function jeltablicauzeta(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('jamaica-utils:jelImaTablicu', function(jeltablicauzeta)
		callback = jeltablicauzeta
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(10)
	end

	return callback
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
]]