local function isUltraJobAllowed()
    if not ESX.PlayerLoaded then return false end
    local job = ESX.PlayerData.job
    return job and Config.UltraJobs[job.name] == true
end

local function useStressTablet(data, reliefAmount, notifyText)
    exports['jamaica-stress']:BeginStressRelief(3500)

    exports.ox_inventory:useItem(data, function(result)
        if not result then return end
        TriggerEvent('esx_status:remove', 'stress', reliefAmount)
        lib.notify({
            title = 'Stress',
            description = notifyText,
            type = 'success',
        })
    end)
end

exports('useRedXTablet', function(data)
    useStressTablet(data, 100000, 'Popio/la si RedX tabletu. Stress smanjen za 10%.')
end)

exports('useUltraTablet', function(data)
    if not isUltraJobAllowed() then
        lib.notify({
            title = 'Stress',
            description = 'Ultra stress tabletu mogu koristiti samo sluzbe.',
            type = 'error',
        })
        return
    end

    useStressTablet(data, Config.Relief.Ultra, 'Stress je potpuno smanjen.')
end)
