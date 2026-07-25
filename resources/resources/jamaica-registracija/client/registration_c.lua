ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Registration.Config.esxobject, function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
    while ESX.GetPlayerData().job == nil do Wait(500) end
	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    if Registration.Config.Blip.enabled then
        local blip = AddBlipForCoord(Registration.Config.Blip.coords)
        SetBlipSprite(blip, Registration.Config.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Registration.Config.Blip.scale)
        SetBlipColour(blip, Registration.Config.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Registration.Config.Blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

local markerData = nil
local insuranceMarkerData = nil
local showHelper = false
local showInsuranceHelper = false
local blocked = false
local insuranceBlocked = false

RegisterNetEvent(Registration.Config.esxsetjob)
AddEventHandler(Registration.Config.esxsetjob, function(job)
    PlayerData.job = job
end)

RegisterNetEvent(Registration.Config.esxplayerloaded, function(xPlayer)
	PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())

        if markerData == nil then
            for _,v in pairs(Registration.Config.Zones) do
                local distance = #(coords - v.pos)
                if distance < v.size then
                    markerData = v
                    showHelper = true
                end
            end
        else
            local distance = #(coords - markerData.pos)
            if distance >= markerData.size then
                markerData = nil
                showHelper = false
                blocked = false
            end
        end

        if insuranceMarkerData == nil then
            for _,v in pairs(Registration.Config.InsuranceZones) do
                local distance = #(coords - v.pos)
                if distance < v.size then
                    insuranceMarkerData = v
                    showInsuranceHelper = true
                end
            end
        else
            local distance = #(coords - insuranceMarkerData.pos)
            if distance >= insuranceMarkerData.size then
                insuranceMarkerData = nil
                showInsuranceHelper = false
                insuranceBlocked = false
            end
        end

        Citizen.Wait(500)
    end
end)

local function getNilVector()
    return vector3(0.0,0.0,0.0)
end

local function showMarker(data, isInsurance)
    local settings = isInsurance and Registration.Config.InsuranceMarkerSettings or Registration.Config.MarkerSettings
    DrawMarker(settings.type, data.pos, getNilVector(), getNilVector(), data.size, data.size, 1.0, settings.r, settings.g, settings.b, settings.a, false, false, 2, settings.rotate, false, false, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local spavanje = true
        local coords = GetEntityCoords(PlayerPedId())

        if showHelper and not blocked then
            spavanje = false
            DrawText3D(markerData.pos.x, markerData.pos.y, markerData.pos.z + 1.0, Strings["press_buttom"])
        end
        for k,v in pairs(Registration.Config.Zones) do
            local distance = #(coords - v.pos)
            if distance < Registration.Config.DrawDistance then
                spavanje = false
                showMarker(v)
            end
        end

        if showInsuranceHelper and not insuranceBlocked then
            spavanje = false
            DrawText3D(insuranceMarkerData.pos.x, insuranceMarkerData.pos.y, insuranceMarkerData.pos.z + 1.0, Strings["press_button_insurance"])
        end
        for k,v in pairs(Registration.Config.InsuranceZones) do
            local distance = #(coords - v.pos)
            if distance < Registration.Config.DrawDistance then
                spavanje = false
                showMarker(v, true)
            end
        end

        if spavanje then Wait(1000) end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function Registration:OpenMenu()
    blocked = true
    ESX.TriggerServerCallback('_registracija:GetOwnedVehicles', function(vehicles)
        if #vehicles > 0 then
            local options = {}
            for k,v in ipairs(vehicles) do
                local regStatus = '❌ Neregistrirano'
                local buttonText = 'Registriraj'

                if v.registration.valid then
                    regStatus = '✅ Registrirano (' .. v.registration.daysLeft .. ' dana)'
                    if v.registration.daysLeft <= 1 then
                        buttonText = 'Produži registraciju'
                    else
                        buttonText = 'Registrirano'
                    end
                end

                table.insert(options, {
                    title = string.upper(v.plate) .. ' - ' .. v.model,
                    description = regStatus,
                    icon = v.registration.valid and 'circle-check' or 'circle-xmark',
                    iconColor = v.registration.valid and 'green' or 'red',
                    onSelect = function()
                        TriggerServerEvent('_registracija:Register', v.plate)
                    end
                })
            end

            lib.registerContext({
                id = 'vehicle_registration_select',
                title = 'Registracija vozila',
                options = options
            })

            lib.showContext('vehicle_registration_select')
        else
            lib.notify({
                title = 'Registracija',
                description = 'Nemate vozila',
                type = 'error',
                position = 'right-center'
            })
            blocked = false
        end
    end)
end

function Registration:OpenInsuranceMenu()
    insuranceBlocked = true
    ESX.TriggerServerCallback('_registracija:GetOwnedVehicles', function(vehicles)
        if #vehicles > 0 then
            local options = {}
            for k,v in ipairs(vehicles) do
                local insStatus = '❌ Neosigurano'
                local buttonText = 'Osiguraj'

                if v.insurance.valid then
                    insStatus = '✅ Osigurano (' .. v.insurance.daysLeft .. ' dana)'
                    if v.insurance.daysLeft <= 1 then
                        buttonText = 'Produži osiguranje'
                    else
                        buttonText = 'Osigurano'
                    end
                end

                table.insert(options, {
                    title = string.upper(v.plate) .. ' - ' .. v.model,
                    description = insStatus,
                    icon = v.insurance.valid and 'shield-check' or 'shield-xmark',
                    iconColor = v.insurance.valid and 'green' or 'red',
                    onSelect = function()
                        TriggerServerEvent('_registracija:BuyInsurance', v.plate)
                    end
                })
            end

            lib.registerContext({
                id = 'vehicle_insurance_select',
                title = 'Osiguranje vozila',
                options = options
            })

            lib.showContext('vehicle_insurance_select')
        else
            lib.notify({
                title = 'Osiguranje',
                description = 'Nemate vozila',
                type = 'error',
                position = 'right-center'
            })
            insuranceBlocked = false
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if markerData then
            if not blocked then
                if IsControlJustReleased(1, 51) then
                    Registration:OpenMenu()
                end
            else
                Wait(500)
            end
        elseif insuranceMarkerData then
            if not insuranceBlocked then
                if IsControlJustReleased(1, 51) then
                    Registration:OpenInsuranceMenu()
                end
            else
                Wait(500)
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent('_registracija:unblock')
AddEventHandler('_registracija:unblock', function()
    blocked = false
    insuranceBlocked = false
end)

RegisterCommand(Registration.Config.CommandCheck, function()
    for _,v in pairs(Registration.Config.JobChecks) do
        if PlayerData.job.name == v then
            local vehicle, distance = ESX.Game.GetClosestVehicle()
                if vehicle and distance < 5 and DoesEntityExist(vehicle) then
                    otvoriMeniRegistracije()
            else
                lib.notify({
                    title = 'Registracija',
                    description = Strings["no_vehicle_nearby"],
                    type = 'error',
                    position = 'right-center'
                })
            end
        end
    end
end, false)

local cooldown = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if cooldown and cooldown > 0 then
            cooldown = cooldown - 1
        end
    end
end)

function otvoriMeniRegistracije()
	if not cooldown or cooldown == 0 then
		lib.registerContext({
			id = 'police_check_menu',
			title = 'Provjera vozila',
			options = {
				{
					title = 'Provjera registracije',
					description = 'Provjeri registraciju vozila',
					icon = 'file-lines',
					onSelect = function()
						CheckRegistration()
					end
				},
				{
					title = 'Provjera osiguranja',
					description = 'Provjeri osiguranje vozila',
					icon = 'shield',
					onSelect = function()
						CheckInsurance()
					end
				}
			}
		})
		lib.showContext('police_check_menu')
	else
		lib.notify({
			title = 'Provjera vozila',
			description = Strings["cooldown"],
			type = 'error',
			position = 'right-center'
		})
	end
end

function CheckRegistration()
	local vehicle, distance = ESX.Game.GetClosestVehicle()
	if vehicle and distance < 5 and DoesEntityExist(vehicle) then
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		cooldown = 5
		ESX.TriggerServerCallback('_registracija:GetRegistrationData', function(data)
			local datum_isteka = ''
			if data.expires then
				datum_isteka = string.format(Strings["expiration_date"], data.expires)
			end

			if not data.hasOwner then
				lib.notify({
					title = 'Registracija - ' .. plate,
					description = Strings["rented_vehicle"],
					type = 'info',
					position = 'right-center'
				})
			elseif data.valid then
				lib.notify({
					title = 'Registracija - ' .. plate,
					description = string.format(Strings["registration_valid"], datum_isteka),
					type = 'success',
					position = 'right-center'
				})
			else
				lib.notify({
					title = 'Registracija - ' .. plate,
					description = Strings["vehicle_not_registered"],
					type = 'error',
					position = 'right-center'
				})
			end
		end, plate)
	else
		lib.notify({
			title = 'Registracija',
			description = Strings["no_vehicle_nearby"],
			type = 'error',
			position = 'right-center'
		})
	end
end

function CheckInsurance()
	local vehicle, distance = ESX.Game.GetClosestVehicle()
	if vehicle and distance < 5 and DoesEntityExist(vehicle) then
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		cooldown = 5
		ESX.TriggerServerCallback('_registracija:GetInsuranceData', function(data)
			local datum_isteka = ''
			if data.expires then
				datum_isteka = string.format(Strings["expiration_date"], data.expires)
			end

			if not data.hasOwner then
				lib.notify({
					title = 'Osiguranje - ' .. plate,
					description = Strings["rented_vehicle"],
					type = 'info',
					position = 'right-center'
				})
			elseif data.valid then
				lib.notify({
					title = 'Osiguranje - ' .. plate,
					description = string.format(Strings["insurance_valid"], datum_isteka),
					type = 'success',
					position = 'right-center'
				})
			else
				lib.notify({
					title = 'Osiguranje - ' .. plate,
					description = Strings["vehicle_not_insured"],
					type = 'error',
					position = 'right-center'
				})
			end
		end, plate)
	else
		lib.notify({
			title = 'Osiguranje',
			description = Strings["no_vehicle_nearby"],
			type = 'error',
			position = 'right-center'
		})
	end
end
