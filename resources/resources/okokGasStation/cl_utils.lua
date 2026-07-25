ESX = exports.es_extended:getSharedObject()

RegisterNetEvent(Config.EventPrefix..":notification")
AddEventHandler(Config.EventPrefix..":notification", function(title, text, type, time)
	if Config.UseOkokNotify then
		exports['okokNotify']:Alert(title, text, time, type)
	else
		ESX.ShowNotification(text)
	end
end)

RegisterNetEvent(Config.EventPrefix..":giveKeys")
AddEventHandler(Config.EventPrefix..":giveKeys", function(vehicle)

	-- Set here your key system
	
end)

RegisterNetEvent(Config.EventPrefix..":removeKeys")
AddEventHandler(Config.EventPrefix..":removeKeys", function(vehicle)

	-- Set here your key removal after the mission
	
end)

-- Don't touch since we have our own fuel system
RegisterNetEvent(Config.EventPrefix..":setFuel")
AddEventHandler(Config.EventPrefix..":setFuel", function(vehicle)
	SetFuel(vehicle, 100.0)
end)

function TextUI(text, time, side)
	if Config.UseOkokTextUI then
		if text ~= nil then
			exports['okokTextUI']:Open(text, time, side)
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

RegisterNetEvent(Config.EventPrefix..':ProgressBar')
AddEventHandler(Config.EventPrefix..':ProgressBar', function(fuelTime)

    exports["esx_progressbar"]:Progressbar(_okok('refueling_vehicle').text, fuelTime,{
        FreezePlayer = false, 
        onFinish = function()
    end})

end)

RegisterNetEvent(Config.EventPrefix..':setFuelAmmoMetadata')
AddEventHandler(Config.EventPrefix..':setFuelAmmoMetadata', function(fuelToVehicle, slot)
	if Config.MetadataInventory == 'qs-inventory' then

		local jerrycan = exports['qs-inventory']:GetCurrentWeapon()
		if not jerrycan.info.ammo then jerrycan.info.ammo = 0 end
		newAmmo = Config.MaxFuelOnPetrolcan - fuelToVehicle
		local fuel = jerrycan.info.ammo

		fuel = fuel + fuelToVehicle

		TriggerServerEvent(Config.EventPrefix..':UpdateWeaponAmmoMetadata', fuel, slot)

	elseif Config.MetadataInventory == 'ox_inventory' then
		local jerrycan = exports.ox_inventory:getCurrentWeapon()
		if not jerrycan.metadata.ammo then jerrycan.metadata.ammo = 0 end
		newAmmo = Config.MaxFuelOnPetrolcan - fuelToVehicle
		local fuel = jerrycan.metadata.ammo

		fuel = fuel + fuelToVehicle

		TriggerServerEvent(Config.EventPrefix..':UpdateWeaponAmmoMetadata', fuel, slot)

	elseif Config.MetadataInventory == 'origen_inventory' then

		local jerrycan, serial, slot = exports.origen_inventory:GetCurrentWeapon(true)

		if not jerrycan.metadata.ammo then jerrycan.metadata.ammo = 0 end
		newAmmo = Config.MaxFuelOnPetrolcan - fuelToVehicle
		local fuel = jerrycan.metadata.ammo

		fuel = fuel + fuelToVehicle

		TriggerServerEvent(Config.EventPrefix..':UpdateWeaponAmmoMetadata', fuel, slot)

	else
		-- Add your own ammo metadata system here
	end

end)

function getFuelAmmoMetadata()
    local jerryFuel = 0

	if Config.MetadataInventory == 'qs-inventory' then

		local weapon = exports['qs-inventory']:GetCurrentWeapon()
		if not weapon.info.ammo then weapon.info.ammo = 0 end
		jerryFuel = weapon.info.ammo
		jerrycanSlot = weapon.slot

	elseif Config.MetadataInventory == 'ox_inventory' then
		local weapon = exports.ox_inventory:getCurrentWeapon()
		if not weapon.metadata.ammo then weapon.metadata.ammo = 0 end
		jerryFuel = weapon.metadata.ammo
		jerrycanSlot = weapon.slot

	elseif Config.MetadataInventory == 'origen_inventory' then

		local weapon, serial, slot = exports.origen_inventory:GetCurrentWeapon(true)
		if not weapon.metadata.ammo then weapon.metadata.ammo = 0 end
		jerryFuel = weapon.metadata.ammo
		jerrycanSlot = slot
	else
		-- Add your own ammo metadata system here
	end

    return jerryFuel, jerrycanSlot
end