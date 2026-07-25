local function openAdminStash(stashId, registerEvent, failOpenText, failMissingText)
    local success, result = pcall(function() 
        return exports.ox_inventory:openInventory('stash', {id = stashId})
    end)
    
    if not success then
        lib.notify({
            title = 'Greška',
            description = failOpenText,
            type = 'error',
            position = 'top-center',
            duration = 5000
        })
    elseif result == false then
        TriggerServerEvent(GetCurrentResourceName() .. registerEvent, stashId)
        Wait(1000)
        
        local reopenSuccess = exports.ox_inventory:openInventory('stash', {id = stashId})
        if not reopenSuccess then
            lib.notify({
                title = 'Greška',
                description = failMissingText,
                type = 'error',
                position = 'top-center',
                duration = 5000
            })
        end
    end
end

RegisterNetEvent(GetCurrentResourceName() .. ":command")
AddEventHandler(GetCurrentResourceName() .. ":command", function(stashId)
    openAdminStash(
        stashId,
        ":registerAdminStash",
        'Neuspjelo otvaranje stasha. Pokušaj ponovno.',
        'Stash ne postoji ili ga nije moguće otvoriti.'
    )
end)

RegisterCommand('aptdebug', function(source, args)
    if args[1] == "refresh" then
        RefreshTargetInteractions()
        lib.notify({
            title = 'Apartment Debug',
            description = 'Target interactions refreshed',
            type = 'inform',
            position = 'top-center',
            duration = 5000
        })
    else
        lib.notify({
            title = 'Apartment Debug',
            description = 'ID: ' .. tostring(apartmentIn) .. ' | Owner: ' .. tostring(isOwner) .. ' | Locked: ' .. tostring(isApartmentLocked),
            type = 'inform',
            position = 'top-center',
            duration = 5000
        })
    end
end, false)

RegisterCommand('wardrobetest', function()
    OpenWardrobe()
end, false)