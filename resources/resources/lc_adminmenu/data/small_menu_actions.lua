local Bridge <const> = require 'bridge.import'

local SmallMenuActions = {}

-- Player Options
SmallMenuActions.set_health = function(values)
    local health = tonumber(values[1])+99
    if not health then return end

    SetEntityHealth(cache.ped, health)
end

SmallMenuActions.set_armor = function(values)
    local armor = tonumber(values[1])
    if not armor then return end

    SetPedArmour(cache.ped, armor)
end

SmallMenuActions.revive = function()
    TriggerServerEvent('lc_admin:player_actions:revive', cache.serverId)
end

SmallMenuActions.admin_crosshair = function(value)
    ToggleAdminCrosshair(value)
end

SmallMenuActions.player_names = function(value)
    TogglePlayerNames(value)
end

SmallMenuActions.esp = function(value)
    ToggleEsp(value)
end

SmallMenuActions.noclip = function(value)
    ToggleNoclip(value)
end

SmallMenuActions.freecam = function(value)
    ToggleFreecam(value)
end

SmallMenuActions.invisibility = function(value)
    ToggleInvisibility(value)
end

SmallMenuActions.godmode = function(value)
    ToggleGodmode(value)
end

SmallMenuActions.set_ped = function(values)
    local ped = values[1]
    if not ped or type(ped) ~= 'string' then return end

    local hash = joaat(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(0)
	end

	SetPlayerModel(PlayerId(), hash)
	SetPedDefaultComponentVariation(cache.ped)
	ClearAllPedProps(cache.ped)
	ClearPedDecorations(cache.ped)
	ClearPedFacialDecorations(cache.ped)
	SetPedComponentVariation(cache.ped, 0, 0, 0, 0)
	SetModelAsNoLongerNeeded(hash)
end

-- Vehicle Options
SmallMenuActions.spawn_vehicle = function(values)
    local model = values[1]
    if not model then return end
    if not IsModelValid(model) then return end

    lib.callback.await('lc_admin:small_menu:spawnOnesyncVehicle', false, model)
end

SmallMenuActions.repair_vehicle = function()
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if not vehicle then return end
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
end

SmallMenuActions.set_dirt_level = function(values)
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if not vehicle then return end

    local dirt_level = tonumber(values[1])
    if not dirt_level then return end
    if dirt_level > 10 or dirt_level < 0 then return end

    SetVehicleDirtLevel(vehicle, (dirt_level / 2) * 2)
end

SmallMenuActions.wash_vehicle = function()
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if not vehicle then return end
    SetVehicleDirtLevel(vehicle, 0.0)
end

SmallMenuActions.delete_vehicle = function()
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if vehicle ~= 0 then
        DeleteEntity(vehicle)
    end
end

SmallMenuActions.change_plate = function(values)
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if not vehicle or vehicle == 0 then return end

    local plate = tostring(values[1])
    if not plate then return end
    if #plate > 8 then return end

    lib.setVehicleProperties(vehicle, {
        plate = plate
    })
end

SmallMenuActions.max_tuning = function()
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if not vehicle or vehicle == 0 then return end

    lib.setVehicleProperties(vehicle, {
        windowTint = 2,
        color1 = 0,
        color2 = 0,
        modEngine = 3,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 1,
        modTurbo = true
    })
end

-- Teleport Options
SmallMenuActions.teleport_to_marker = function()
    local marker = GetFirstBlipInfoId(8)
    if not DoesBlipExist(marker) then
        Bridge.FailNotify(nil, 'No marker found', 'no_marker_found')
        return
    end

    local entity = cache.vehicle and cache.vehicle or cache.ped
    local coords = GetBlipInfoIdCoord(marker)

    FreezeEntityPosition(entity, true)
    SetEntityCoords(entity, coords.x, coords.y, coords.z+2.0, false, false, false, false)
    local max_tries = 10
    for i = 1, max_tries do
        local found, ground_z = GetGroundZFor_3dCoord(coords.x, coords.y, 2000.0, true)
        if found then
            SetEntityCoords(entity, coords.x, coords.y, ground_z, false, false, false, false)
            break
        end
        Wait(100)
    end
    FreezeEntityPosition(entity, false)
    Bridge.SuccessNotify(nil, 'Teleported to marker', 'teleported_to_marker')
end

SmallMenuActions.teleport_to_coords = function(values)
    local coords = values[1]
    if not coords or not coords.x or not coords.y or not coords.z then return print('invalid coords format') end

    local entity = cache.vehicle and cache.vehicle or cache.ped
    FreezeEntityPosition(entity, true)
    SetEntityCoords(entity, coords.x+0.0, coords.y+0.0, coords.z+0.0, false, false, false, false)
    FreezeEntityPosition(entity, false)
    Bridge.SuccessNotify(nil, 'Teleported to coords', 'teleported_to_coords')
end

SmallMenuActions.teleport_to_player = function(values)
    local player = values[1]
    TriggerServerEvent('lc_admin:teleportToPlayer', player.server_id)
end

return SmallMenuActions