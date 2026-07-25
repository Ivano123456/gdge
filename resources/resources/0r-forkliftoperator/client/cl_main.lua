lib.locale()

local Config <const> = require "config.main"
EmployerPed = nil
EmployerBlip = nil
PlayerData = {}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if NetworkIsPlayerActive(PlayerId()) then
            FetchNui()
            local myData = lib.callback.await(Event('callback:getPlayerData'), false)
            if myData and next(myData) then
                PlayerData = myData
                NuiMessage('player/update-info', myData)
            else
                Debug('error', 'Failed to retrieve player data on load')
                return
            end

            EmployerPed, EmployerBlip = InitEmployer()

            if Target and Config.UseTarget then
                InitEmployerTarget()
            else
                InitEmployerPoint()
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        HelpText.HideHelpText()
        if EmployerPed and DoesEntityExist(EmployerPed) then
            DeleteEntity(EmployerPed)
        end

        if EmployerBlip and DoesBlipExist(EmployerBlip) then
            RemoveBlip(EmployerBlip)
        end

        if CurrentMultiplayerData and next(CurrentMultiplayerData) then
            if CurrentMultiplayerData.settings then
                for _, ped in pairs(CurrentMultiplayerData.settings.peds or {}) do
                    local netId = ped.netId
                    if netId then
                        local pedEntity = NetworkGetEntityFromNetworkId(netId)
                        if pedEntity and DoesEntityExist(pedEntity) then
                            DeleteEntity(pedEntity)
                        end
                    end
                end

                for _, vehicle in pairs(CurrentMultiplayerData.settings.vehicles or {}) do
                    local netId = vehicle.netId
                    if netId then
                        local veh = NetworkGetEntityFromNetworkId(netId)
                        if veh and DoesEntityExist(veh) then
                            DeleteEntity(veh)
                        end
                    end
                end
            end

            if CurrentMultiplayerData.settings.task.started then
                SetEntityCoords(PlayerPedId(), 1244.85, -3247.3, 5.03, false, false, false, true)
                SetEntityHeading(PlayerPedId(), 254.57)
            end
        end
    end
end)

RegisterNetEvent(Event('client:onPlayerLoaded'), function()
    FetchNui()
    local myData = lib.callback.await(Event('callback:getPlayerData'), false)
    if myData and next(myData) then
        PlayerData = myData
        NuiMessage('player/update-info', myData)
    else
        Debug('error', 'Failed to retrieve player data on load')
        return
    end

    EmployerPed, EmployerBlip = InitEmployer()

    if Target and Config.UseTarget then
        InitEmployerTarget()
    else
        InitEmployerPoint()
    end
end)

RegisterNetEvent(Event('client:onPlayerUnload'), function()
    if EmployerPed and DoesEntityExist(EmployerPed) then
        DeleteEntity(EmployerPed)
    end

    if EmployerBlip and DoesBlipExist(EmployerBlip) then
        RemoveBlip(EmployerBlip)
    end
end)

RegisterNetEvent('baseevents:onPlayerDied', function()
    NuiMessage('nui/toggle', {
        show = false,
    })
    SetNuiFocus(false, false)
    HelpText.HideHelpText()
end)

RegisterNetEvent(Event('client:updatePlayerXP'), function(xp)
    PlayerData = PlayerData or {}
    PlayerData.xp = PlayerData.xp and PlayerData.xp + xp or xp
    NuiMessage('player/update-info', PlayerData)
end)