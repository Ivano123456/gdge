local trenutnoBere = false 
local searchedDumpsters = {}

exports.ox_target:addModel(Config.Kontejneri , {
    {
        name = 'pretrazi_kontejner',
        icon = 'fas fa-dumpster',
        label = "Pretrazi kontejner",
        onSelect = function(data) 
            local entity = data.entity
            if not entity or searchedDumpsters[entity] then return end
            
            local playerPed = PlayerPedId()
            trenutnoBere = true 
            local dict = "mini@repair"
            local animation = "fixing_a_ped"
            
            lib.requestAnimDict(dict)
            TaskPlayAnim(playerPed, dict, animation, 8.0, -8.0, -1, 1, 0, false, false, false)
            FreezeEntityPosition(playerPed, true)
            if lib.progressBar({
                duration = 15000,
                label = "Pretrazujes Kontejner...",
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = false
                },
                anim = {
                    dict = dict,
                    clip = animation
                }
            }) then
                FreezeEntityPosition(playerPed, false)
                ClearPedTasks(playerPed)
                trenutnoBere = false 
                
                searchedDumpsters[entity] = true
                
                TriggerServerEvent("vule_dumpsters:server:DajKontejner", entity)
            else
                FreezeEntityPosition(playerPed, false)
                ClearPedTasks(playerPed)
                trenutnoBere = false 
            end
        end,
        canInteract = function(entity, distance, coords, name, data)
            return not searchedDumpsters[entity] and not trenutnoBere
        end,
        distance = 2.0
    }
})

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        searchedDumpsters = {}
    end
end)

AddEventHandler('playerSpawned', function()
    searchedDumpsters = {}
end)

RegisterNetEvent('vule_dumpsters:client:syncDumpsterState')
AddEventHandler('vule_dumpsters:client:syncDumpsterState', function(netId, state)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if entity and entity ~= 0 then
        searchedDumpsters[entity] = state
    end
end)

RegisterNetEvent('vule_dumpsters:client:setInitialDumpsterStates')
AddEventHandler('vule_dumpsters:client:setInitialDumpsterStates', function(dumpsterStates)
    for netId, state in pairs(dumpsterStates) do
        local entity = NetworkGetEntityFromNetworkId(netId)
        if entity and entity ~= 0 then
            searchedDumpsters[entity] = state
        end
    end
end)

CreateThread(function()
    Wait(1000) 
    TriggerServerEvent('vule_dumpsters:server:requestDumpsterStates')
end)

