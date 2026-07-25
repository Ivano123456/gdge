RegisterNetEvent("0r_idcard:client:showCard", function(data, isJobCard, shown, slot, name)
    openCard(data, isJobCard, shown, slot, name)
end)

RegisterNetEvent("0r_idcard:client:notify", function(message, type)
    Config.Notify(message, type)
end)

RegisterNetEvent("0r_idcard:client:setCardData", function(data)
    PData = data
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if Peds then
            for k, v in pairs(Peds) do
                DeleteEntity(v)
            end
        end 
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end)