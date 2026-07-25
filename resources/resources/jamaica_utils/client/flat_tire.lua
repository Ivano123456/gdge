local maxSpeedMs = (Config.FlatTireMaxSpeed or 40) / 3.6
local limitedVehicle = 0

local function hasBurstTyre(vehicle)
    for i = 0, 7 do
        if IsVehicleTyreBurst(vehicle, i, false) then
            return true
        end
    end
    return false
end

local function resetVehicleSpeed(vehicle)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetEntityMaxSpeed(vehicle, -1.0)
    end
end

CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            if hasBurstTyre(vehicle) then
                sleep = 250
                SetEntityMaxSpeed(vehicle, maxSpeedMs)
                limitedVehicle = vehicle
            else
                sleep = 500
                SetEntityMaxSpeed(vehicle, -1.0)
                if limitedVehicle == vehicle then
                    limitedVehicle = 0
                end
            end
        elseif limitedVehicle ~= 0 then
            resetVehicleSpeed(limitedVehicle)
            limitedVehicle = 0
        end

        Wait(sleep)
    end
end)
