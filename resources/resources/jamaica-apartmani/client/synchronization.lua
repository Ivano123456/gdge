RegisterNetEvent(GetCurrentResourceName() .. ":notify")
AddEventHandler(GetCurrentResourceName() .. ":notify", function(text, tip)
    Notify(text, tip)
end)

RegisterNetEvent(GetCurrentResourceName() .. ":syncApartmentId")
AddEventHandler(GetCurrentResourceName() .. ":syncApartmentId", function(aptId, lockStatus)
    apartmentIn = aptId
    isOwner = true
    isApartmentLocked = lockStatus or false
end)

RegisterNetEvent(GetCurrentResourceName() .. ":knockDoor")
AddEventHandler(GetCurrentResourceName() .. ":knockDoor", function(player, aptId)
    local alert = lib.alertDialog({
        header = 'Apartmani',
        content = 'Na vrata ti kuca igrac ' .. player.name .. " da li zelis da ga pustis u apartman?",
        centered = true,
        cancel = true
    })

    if alert == "confirm" then
        lib.callback('jamaica_apartmani:accepted', false, function(success) end, player.id, aptId)
    end
end)

RegisterNetEvent(GetCurrentResourceName() .. ":setCoords")
AddEventHandler(GetCurrentResourceName() .. ":setCoords", function(aptId)
    DoScreenFadeOut(2000)
    while not IsScreenFadedOut() do
    Wait(100)
    end
    DoScreenFadeIn(2000)
    SetEntityCoords(PlayerPedId(), Config.Apartment['enter']['spawnCoords'])
    apartmentIn = aptId
    isOwner = false
end)

RegisterNetEvent(GetCurrentResourceName() .. ":forceLeaveApartment")
AddEventHandler(GetCurrentResourceName() .. ":forceLeaveApartment", function()
    DoScreenFadeOut(2000)
    while not IsScreenFadedOut() do
    Wait(100)
    end
    DoScreenFadeIn(2000)
    SetEntityCoords(PlayerPedId(), Config.Apartment['leave']['spawnCoords'])
end)

RegisterNetEvent(GetCurrentResourceName() .. ":lockStatusChanged")
AddEventHandler(GetCurrentResourceName() .. ":lockStatusChanged", function(lockStatus)
    isApartmentLocked = lockStatus
end)

CreateThread(function()
    Wait(3000)
    TriggerServerCallback(GetCurrentResourceName() .. ":getOwnerLockStatus", function(lockStatus)
        if type(lockStatus) == "boolean" then
            isApartmentLocked = lockStatus
        end
    end)
end)
