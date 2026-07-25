local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX						= nil
local CurrentAction		= nil
local PlayerData		= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local tinky = TriggerServerEvent

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- Popravljanje vozila event i funkcija
function FixVehicle(IzvrsioMehanicar)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle
        
        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end
        
        if DoesEntityExist(vehicle) then
			tinky('esx_repairkit:removeKit')
            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
            local oldEngineHealth = GetVehicleEngineHealth(vehicle)
            local oldBodyHealth = GetVehicleBodyHealth(vehicle)
            if oldEngineHealth < 0.0 then
                oldEngineHealth = 0.0
            end
            if oldBodyHealth < 0.0 then
                oldBodyHealth = 0.0
            end
            Citizen.CreateThread(function()
                Citizen.Wait(5000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleEngineOn(vehicle, true, true)
                SetVehicleTyreFixed(vehicle, 0)
                SetVehicleTyreFixed(vehicle, 1)
                SetVehicleTyreFixed(vehicle, 4)
                SetVehicleTyreFixed(vehicle, 5)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification('Vozilo je popravljeno!')
                if not IzvrsioMehanicar and not (GetVehicleClass(vehicle) == 15) then
                    local newBodyHealth = oldBodyHealth + 800.0
                    local newEngineHealth = oldEngineHealth + 800.0
                    
                    if newBodyHealth > 1000.0 then
                        newBodyHealth = 1000.0
                    end

                    if newEngineHealth > 1000.0 then
                        newEngineHealth = 1000.0
                    end
                    SetVehicleBodyHealth(vehicle, newBodyHealth)
                    SetVehicleEngineHealth(vehicle, newEngineHealth)
                else
                    SetVehicleBodyHealth(vehicle, 1000.0)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                end
            end)
        end
    end
end

RegisterNetEvent('esx_repairkit:onUse')
AddEventHandler('esx_repairkit:onUse', function()
    FixVehicle(false)
end)

