AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then return end
    CloseMehanicarF6()
    CancelMehanicarRepair()
    CleanupMehanicarSefProp()
end)
