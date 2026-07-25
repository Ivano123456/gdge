local obijanjeUToku = false
local dragStatus = { isDragged = false, CopId = nil }

local function serverIdFromPed(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) or not IsPedAPlayer(entity) then return nil end
    local idx = NetworkGetPlayerIndexFromPed(entity)
    if not idx or idx == -1 then return nil end
    return GetPlayerServerId(idx)
end

local function resolvePlayerTarget(targetEntity)
    if targetEntity then
        local targetId = serverIdFromPed(targetEntity)
        if not targetId then
            ESX.ShowNotification('Nema igraca u blizini!', 'error')
            return nil, nil
        end
        return targetId, targetEntity
    end

    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 3.0 then
        ESX.ShowNotification('Nema igraca u blizini!', 'error')
        return nil, nil
    end

    return GetPlayerServerId(closestPlayer), GetPlayerPed(closestPlayer)
end

local function najblizeVozilo(maxDist)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, maxDist or 5.0, 0, 71)
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        return nil
    end
    return vehicle
end

local function pokreniObijanje()
    if obijanjeUToku then return end

    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification('Ne mozes obiti vozilo dok si unutra!', 'error')
        return
    end

    local vozilo = najblizeVozilo(5.0)
    if not vozilo then
        ESX.ShowNotification('Nema vozila u blizini!', 'error')
        return
    end

    local lockStatus = GetVehicleDoorLockStatus(vozilo)
    if not (lockStatus > 1 and lockStatus ~= 8) then
        ESX.ShowNotification('Vozilo nije zakljucano!', 'error')
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(vozilo)

    ESX.TriggerServerCallback('jamaica-sluzbe:obijVozilo', function(ok, msg)
        if not ok then
            ESX.ShowNotification(msg or 'Obijanje nije uspelo.', 'error')
            return
        end

        obijanjeUToku = true
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, false)
        FreezeEntityPosition(ped, true)

        lib.progressBar({
            duration = 15000,
            label = 'Pokusavas da obijes vozilo...',
            position = 'bottom',
            useWhileDead = false,
            disable = {
                car = true,
            },
        })

        SetVehicleDoorsLocked(vozilo, 1)
        SetVehicleDoorsLockedForAllPlayers(vozilo, false)

        FreezeEntityPosition(ped, false)
        ClearPedTasksImmediately(ped)
        obijanjeUToku = false

        ESX.ShowNotification('Uspesno si obio vozilo!', 'success')
    end, netId)
end

RegisterNetEvent('jamaica-sluzbe:client:toggleDrag')
AddEventHandler('jamaica-sluzbe:client:toggleDrag', function(copId)
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)

CreateThread(function()
    local wasDragged = false
    while true do
        if dragStatus.isDragged and dragStatus.CopId then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                if not wasDragged then
                    AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    wasDragged = true
                end
                Wait(500)
            else
                wasDragged = false
                dragStatus.isDragged = false
                DetachEntity(PlayerPedId(), true, false)
                Wait(500)
            end
        else
            if wasDragged then
                wasDragged = false
                DetachEntity(PlayerPedId(), true, false)
            end
            Wait(1000)
        end
    end
end)

RegisterNetEvent('jamaica-sluzbe:f6Action')
AddEventHandler('jamaica-sluzbe:f6Action', function(action, targetEntity)
    if not ProveriDuznost() then return end
    if action == 'pretrazi' then
        local targetId, targetPed = resolvePlayerTarget(targetEntity)
        if not targetId then return end
        local targetState = Player(targetId).state
        if targetState.aduznost or targetState.sakrivenaduznost then
            ESX.ShowNotification('Ne mozes pretrazivati clana staff-a!')
            return
        end
        TriggerEvent('jamaica-sluzbe:client:PretraziINV', { targetId, targetPed })
    elseif action == 'vezilice' then
        local targetId = resolvePlayerTarget(targetEntity)
        if not targetId then return end
        TriggerServerEvent('jamaica-sluzbe:server:handcuff', targetId)
    elseif action == 'odvezi' then
        local targetId = resolvePlayerTarget(targetEntity)
        if not targetId then return end
        TriggerEvent('jamaica-sluzbe:client:odvezujga', targetId)
    elseif action == 'vuci' then
        local targetId = resolvePlayerTarget(targetEntity)
        if not targetId then return end
        TriggerServerEvent('jamaica-sluzbe:server:vuci', targetId)
    elseif action == 'staviUVozilo' then
        local targetId = resolvePlayerTarget(targetEntity)
        if not targetId then return end
        TriggerServerEvent('jamaica-sluzbe:server:staviUVozilo', targetId)
    elseif action == 'izvadi' then
        local targetId = resolvePlayerTarget(targetEntity)
        if not targetId then return end
        TriggerEvent('jamaica-sluzbe:client:izvadiNewVozila', targetId)
    elseif action == 'obij' then
        pokreniObijanje()
    elseif action == 'gps' then
        TriggerEvent('jamaica-sluzbe:client:openGpsMenu')
    end
end)
