local ugepeku = false

function auticispred()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

exports.qtarget:AddTargetBone({'boot'},{
	options = {
		{
            icon = "fas fa-car-side",
            label = "Udji u gepek",
            canInteract = function(aftic)
				if not ugepeku and GetVehicleDoorLockStatus(aftic) ~= 4 then return true else return false end
            end,
            action = function()
                local igrac = ESX.Game.GetClosestPlayer()
                local pedDrugog = GetPlayerPed(igrac)
                local vozilica = auticispred()
                if DoesEntityExist(pedDrugog) then
                    if not ugepeku then
                        if not IsEntityAttached(pedDrugog) or GetDistanceBetweenCoords(GetEntityCoords(pedDrugog), GetEntityCoords(PlayerPedId()), true) >= 5.0 then
                            if GetVehicleClass(vozilica) ~= 8 and GetVehicleClass(vozilica) ~= 13 and GetVehicleClass(vozilica) ~= 14 and GetVehicleClass(vozilica) ~= 15 and GetVehicleClass(vozilica) ~= 16 and GetVehicleClass(vozilica) ~= 20 and GetVehicleClass(vozilica) ~= 21 then
                                SetCarBootOpen(vozilica)
                                Wait(350)
                                AttachEntityToEntity(PlayerPedId(), vozilica, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                while not HasAnimDictLoaded('timetable@floyd@cryingonbed@base') do Wait(0) RequestAnimDict('timetable@floyd@cryingonbed@base') end
                                TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                                Wait(50)
                                ugepeku = true
                                Wait(1500)
                                SetVehicleDoorShut(vozilica, 5)
                                while ugepeku do
                                    Wait(0)
                                    local autic = GetEntityAttachedTo(PlayerPedId())
                                    DisableControlAction(0, 23, true)
                                    TriggerEvent("bfunkcije:ticknotif", true, true, "Stisni [ E ] da izadjete iz gepeka")
                                    if DoesEntityExist(autic) or not IsPedDeadOrDying(PlayerPedId()) or not IsPedFatallyInjured(PlayerPedId()) then
                                        SetEntityCollision(PlayerPedId(), false, false)

                                        if GetVehicleDoorAngleRatio(autic, 5) < 0.9 then
                                            SetEntityVisible(PlayerPedId(), false, false)
                                        else
                                            if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
                                                while not HasAnimDictLoaded('timetable@floyd@cryingonbed@base') do Wait(0) RequestAnimDict('timetable@floyd@cryingonbed@base') end
                                                TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                                                SetEntityVisible(PlayerPedId(), true, false)
                                            end
                                        end
                                        if IsControlJustPressed(0, 38) then
                                            lib.hideTextUI()
                                            ugepeku = false
                                            DisableControlAction(0, 23, false)
                                            SetCarBootOpen(autic)
                                            SetEntityCollision(PlayerPedId(), true, true)
                                            Wait(750)
                                            DetachEntity(PlayerPedId(), true, true)
                                            SetEntityVisible(PlayerPedId(), true, false)
                                            ClearPedTasks(PlayerPedId())
                                            SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
                                            Wait(250)
                                            SetVehicleDoorShut(autic, 5)
                                        end
                                    else
                                        SetEntityCollision(PlayerPedId(), true, true)
                                        DetachEntity(PlayerPedId(), true, true)
                                        SetEntityVisible(PlayerPedId(), true, false)
                                        ClearPedTasks(PlayerPedId())
                                        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
                                    end
                                end
                            else
                                ESX.ShowNotification('Ne mozete uci u ovaj gepek.')
                            end
                        else
                            ESX.ShowNotification('Neko je vec u gepeku ili u vozilu.')
                        end
                    end
                end
            end
        }
	},
	distance = 1.0

})