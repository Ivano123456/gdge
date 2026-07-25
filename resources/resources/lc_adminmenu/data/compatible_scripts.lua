local Bridge = require 'bridge.import'

return {
  server = {
    AddVehicle = {
      ['mVehicle'] = function(source, targetId, plate, vehicle)
        local Vehicles = exports.mVehicle:vehicle()

        local bridge_identifier = Bridge.GetBridgeIdentifier(targetId)
        local model_label = json.decode(vehicle).model_label
        local ped = GetPlayerPed(targetId)
        local coords = GetEntityCoords(ped)

        local CreateVehicleData = {
          temporary = false,
          setOwner = true,
          owner = bridge_identifier,
          coords = vector4(coords.x, coords.y, coords.z, 0.0),
          type = 'automobile',
          plate = plate,
          parking = '',
          vehicle = {
            model = model_label,
            plate = Vehicles.GeneratePlate(),
            fuelLevel = 100,
            color1 = {0,0,0},
            color2 = {0,0,0},
          },
        }

        local data = Vehicles.CreateVehicle(CreateVehicleData)
        if DoesEntityExist(data.entity) then
          TaskWarpPedIntoVehicle(ped, data.entity, -1)
          Vehicles.ItemCarKeys(tonumber(targetId), 'add', data.plate)
        end

        return true
      end
    }
  },
  client = {
    AddVehicle = {
      ['tgiann-hotwire'] = function(plate, vehicle)
        exports["tgiann-hotwire"]:GiveKeyPlate(plate, false)
      end,
      ['qb-vehiclekeys'] = function(plate, vehicle)
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
      end
    }
  }
}