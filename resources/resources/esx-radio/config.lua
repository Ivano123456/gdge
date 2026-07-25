Config = {}

Config.Item = {
    Require = true,
    name = "radio"
}
--[[
Config.KeyMappings = {
    Enabled = false, 
    Key = "UP"
}]]

Config.ClientNotification = function(msg, type)
    ESX.ShowNotification(msg, type)
end
  
Config.ServerNotification = function(msg, type, player)
    TriggerClientEvent('esx:showNotification', player, msg, type)
end


--- Resticts in index order
Config.RestrictedChannels = {
    SluzbeRadioAccess,
    SluzbeRadioAccess,
    { -- 3 — hitna
        hitna = true,
    },
    { -- 4 — hitna
        hitna = true,
    },
    { -- 5 — sud
        sud = true,
    },
    { -- 6 — sud
        sud = true,
    },
}

Config.MaxFrequency = 500

Config.messages = {
    ["not on radio"] = "Niste povezani na kanal!",
    ["on radio"] = "Vec ste povezani na ovom kanalu",
    ["joined to radio"] = "Povezani ste: ",
    ["restricted channel error"] = "Kanal je zaključan!",
    ["invalid radio"] = "Ova frekvencija nije dostupna.",
    ["you on radio"] = "Vec ste povezani na ovom kanalu",
    ["you leave"] = "Napustili ste kanal.",
    ['volume radio'] = 'Jacina zvuka ',
    ['decrease radio volume'] = 'Vec je podesen na max',
    ['increase radio volume'] = 'Vec je podesen na min',
    ['increase decrease radio channel'] = 'Kanal ',
}
