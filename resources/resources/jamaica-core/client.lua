exports('OpenJobWardrobe', function()
    if GetResourceState('illenium-appearance') ~= 'started' then
        lib.notify({ description = 'Garderoba trenutno nije dostupna.', type = 'error' })
        return
    end
    TriggerEvent('illenium-apearance:client:outfitsCommand', true)
end)
