local sv_core = {}

sv_core.nadjiPoId = function(source)
    if not source or source == 0 then return end
    if ESX ~= nil then
        return ESX.GetPlayerFromId(source)
    elseif QBX ~= nil then
        return exports.qbx_core:GetPlayer(source)
    elseif QBCore ~= nil then
        return QBCore.Functions.GetPlayer(source)
    end
end

return sv_core 