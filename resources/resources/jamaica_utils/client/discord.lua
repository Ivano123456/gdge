local richPresenceId

local function updateRichPresence()
    if not richPresenceId then
        richPresenceId = GetPlayerServerId(PlayerId())
    end

    SetRichPresence("ID: " .. richPresenceId .. " | " .. (GlobalState["BrojIgraca"] or 0) .. "/" .. (GlobalState.brojSlotova or 64))
end

CreateThread(function()
    SetDiscordAppId(1403438418993614888)
    SetDiscordRichPresenceAsset('logojam')
    SetDiscordRichPresenceAssetText('Jamaica Roleplay')
    SetDiscordRichPresenceAssetSmall('job')
    SetDiscordRichPresenceAssetSmallText('uzivajte u roleplayu')
    SetDiscordRichPresenceAction(0, "Nas Discord!", "https://discord.gg/jamaicarp")
    richPresenceId = GetPlayerServerId(PlayerId())
    updateRichPresence()

    AddStateBagChangeHandler('BrojIgraca', 'global', updateRichPresence)
    AddStateBagChangeHandler('brojSlotova', 'global', updateRichPresence)
end)

CreateThread(function()
    local textEntries = {
        'PM_PANE_LEAVE', '~y~Izadji sa Servera',
        'PM_PANE_QUIT', '~y~Napusti Fivem',
        'PM_SCR_MAP', '~y~Mapa',
        'PM_SCR_GAM', '~y~Igrica',
        'PM_SCR_INF', '~y~Informacije',
        'PM_SCR_SET', '~y~Podesavanja',
        'PM_SCR_STA', '~y~Statistika',
        'PM_SCR_GAL', '~y~Galerija',
        'PM_SCR_RPL', '~y~Rockstar',
    }

    for i = 1, #textEntries, 2 do
        AddTextEntry(textEntries[i], textEntries[i + 1])
    end
end)

local function SetData()
    local id = GetPlayerServerId(PlayerId())
    local name = GetPlayerName(PlayerId())
    local header = ' ~y~ID: ' .. id .. ' | ~y~Ime~y~: ~y~' .. name .. ' ~y~| discord: discord.gg/jamaicarp'
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', header)
end

CreateThread(function()
    while true do
        Wait(8000)
        SetData()
    end
end)
