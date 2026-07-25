local Core = {}

Core.Posao = function()
    if ESX ~= nil then
        local data = ESX.GetPlayerData()
        return data and data.job and data.job.name or nil
    elseif QBX ~= nil then
        local data = exports.qbx_core:GetPlayerData()
        return data and data.job and data.job.name or nil
    elseif QBCore ~= nil then
        local data = QBCore.GetPlayerData()
        return data and data.job and data.job.name or nil
    end
end

Core.Notifikacija = function(text)
    if ESX ~= nil then 
        return ESX.ShowNotification(text)
    elseif QBX ~= nil then 
        return exports.qbx_core:Notify(text)
    elseif QBCore ~= nil then 
        return QBCore.Functions.Notify(text)
    end
end

RegisterNetEvent('jamaica-dispatch:client:SendajNotify', function(text)
    Core.Notifikacija(text)
end)

return Core 