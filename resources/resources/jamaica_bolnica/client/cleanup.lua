AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then return end
    CleanupBolnica()
end)
