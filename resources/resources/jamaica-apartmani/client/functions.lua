local FunctionTranslations = {
    apartments = "Apartmani",
    apartment_list = "Lista Apartmana"
}

Notify = function(text, tip)
    lib.notify({
        title = FunctionTranslations.apartments,
        description = text,
        type = tip,
        position = 'top-center',
        duration = 5000
    })
end

ToggleApartmentLock = function()
    lib.callback('jamaica_apartmani:toggleLock', false, function(lockStatus)
        if type(lockStatus) ~= "boolean" then
            return
        end

        isApartmentLocked = lockStatus
        local statusText = lockStatus and Config.Strings['apartment_locked'] or Config.Strings['apartment_unlocked']
        Notify(statusText, lockStatus and "error" or "success")
    end)
end

EnterOwnApartment = function()
    TriggerServerCallback(GetCurrentResourceName() .. ":canEnterApartment", function(canEnter)
        if not canEnter then
            return
        end

        DoScreenFadeOut(2000)
        while not IsScreenFadedOut() do
            Wait(100)
        end
        DoScreenFadeIn(2000)
        SetEntityCoords(PlayerPedId(), Config.Apartment['enter']['spawnCoords'])
        lib.callback('jamaica_apartmani:newApartment', false, function(success) end)

    end)
end

OpenApartmentList = function()
    TriggerServerCallback(GetCurrentResourceName() .. ":getAparrtmentList", function(apt)
        local options = {}
        if next(apt) or #apt > 0 then
            for k,v in pairs(apt) do
                options[#options + 1] = {
                    title = v.ownerName,
                    onSelect = function()
                        lib.callback('jamaica_apartmani:knockDoor', false, function(success) end, k)
                    end
                }
            end
        end

        lib.registerContext({
            id = 'apartment_meni',
            title = FunctionTranslations.apartment_list,
            menu = 'apartment_meni',
            options = options
        })

        lib.showContext('apartment_meni')
    end)
end

LeaveApartment = function()
    DoScreenFadeOut(2000)
    while not IsScreenFadedOut() do
        Wait(100)
    end
    DoScreenFadeIn(2000)
    SetEntityCoords(PlayerPedId(), Config.Apartment['leave']['spawnCoords'])
    lib.callback('jamaica_apartmani:leaveApartment', false, function(success) end)
    Notify(Config.Strings['left_apartment'], "error")

end

OpenWardrobe = function()
    TriggerEvent('fivem-appearance:clothingShop')
end
