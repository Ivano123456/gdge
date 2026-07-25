Config = {}

-- CLIENT CONFIGURATION
Config.JoinProximity = 25.0           -- Proximity to draw text and join race (meters)
Config.JoinKeybind = 'E'              -- Keybind to join race
Config.JoinDuration = 30000           -- Duration to allow players to join (ms)
Config.FreezeDuration = 5000          -- Countdown freeze duration (ms, 0 to disable)
Config.CheckpointProximity = 25.0     -- Distance to trigger checkpoint (meters)
Config.CheckpointRadius = 25.0        -- Radius of 3D checkpoints (0 to disable)
Config.CheckpointHeight = 10.0        -- Height of 3D checkpoints (meters)
Config.CheckpointBlipColor = 5        -- Checkpoint blip color

-- Start location marker
Config.StartMarkerEnabled = true      -- Show marker at race start location
Config.StartMarkerRadius = 15.0       -- Radius of start marker
Config.StartMarkerHeight = 10.0       -- Height of start marker
Config.StartMarkerBlipEnabled = true  -- Show blip on map for start location
Config.StartMarkerBlipSprite = 38     -- Blip sprite (38 = race flag)
Config.StartMarkerBlipColor = 2       -- Blip color (2 = green)
Config.HudEnabled = true              -- Enable racing HUD
Config.HudPosition = vec(0.015, 0.725) -- HUD screen position

-- Notification settings
Config.NotificationPosition = 'top' -- ox_lib notification position (top center)
Config.NotificationDuration = 5000    -- Default notification duration (ms)

-- Menu settings
Config.MenuPosition = 'top-right'     -- ox_lib menu position
Config.UseTextUI = true               -- Use ox_lib TextUI for race prompts

-- SERVER CONFIGURATION
Config.FinishTimeout = 180000         -- Timeout after winner finishes (ms)
Config.NotifyOfWinner = true          -- Notify all players of winner
Config.UseESX = true                  -- Use ESX framework for money
Config.UseBankAccount = true          -- Use bank account (true) or cash (false)

-- Item requirement
Config.RequireItem = true             -- Require item to create races
Config.RequiredItemName = 'racechip'  -- Item name required to create races

-- Race recording settings
Config.MinCheckpoints = 1             -- Minimum checkpoints required
Config.MaxCheckpoints = 50            -- Maximum checkpoints allowed
Config.MinBuyIn = 100                 -- Minimum race buy-in
Config.MaxBuyIn = 1000000             -- Maximum race buy-in

-- Commands (set to false to disable)
Config.Commands = {
    openMenu = 'race',                -- Main menu command
    quickStart = false,               -- Quick start command (disabled, use menu)
    quickRecord = false               -- Quick record command (disabled, use menu)
}

-- Locale (Croatian)
Config.Locale = {
    -- Menu headers
    menuTitle = 'Ulične Utrke',
    menuSubtitle = 'Upravljaj svojim utkama',

    -- Menu options
    startRace = 'Započni Utrku',
    joinRace = 'Pridruži se Utrci',
    recordRace = 'Snimi Novu Utrku',
    saveRace = 'Spremi Utrku',
    loadRace = 'Učitaj Spremljenu Utrku',
    deleteRace = 'Obriši Spremljenu Utrku',
    listRaces = 'Moje Spremljene Utrke',
    leaveRace = 'Napusti Trenutnu Utrku',
    cancelRace = 'Odustani od Moje Utrke',

    -- Descriptions
    startRaceDesc = 'Započni utrku s prilagođenim kontrolnim točkama ili waypoint-om',
    recordRaceDesc = 'Počni snimati kontrolne točke za novu utrku',
    saveRaceDesc = 'Spremi trenutno snimljene kontrolne točke',
    loadRaceDesc = 'Učitaj prethodno spremljenu utrku',
    deleteRaceDesc = 'Obriši spremljenu utrku',
    listRacesDesc = 'Pregledaj sve svoje spremljene utrke',
    leaveRaceDesc = 'Napusti utrku kojoj si se pridružio',
    cancelRaceDesc = 'Odustani od utrke koju si kreirao',

    -- Prompts
    enterRaceName = 'Unesi ime utrke',
    enterRaceNameDesc = 'Unesi jedinstveno ime za ovu utrku',
    enterBuyIn = 'Unesi iznos ulaza ($)',
    enterBuyInDesc = 'Iznos ulaza ($%d - $%d)',
    enterStartDelay = 'Odgoda početka (sekunde)',
    enterStartDelayDesc = 'Vrijeme prije početka utrke',
    selectRace = 'Odaberi utrku',

    -- Notifications
    raceCreated = 'Utrka kreirana! Čekanje igrača...',
    raceSaved = 'Utrka "%s" uspješno spremljena',
    raceLoaded = 'Utrka "%s" učitana - sada je možeš započeti',
    raceDeleted = 'Utrka "%s" obrisana',
    raceJoined = 'Pridružio si se utrci!',
    raceStarting = 'Utrka počinje za %d sekundi',
    raceWon = 'POBIJEDIO SI! Nagrada: $%d | Vrijeme: %02d:%06.3f',
    raceLost = 'Završio si! Vrijeme: %02d:%06.3f',
    raceCanceled = 'Utrka otkazana',
    raceCanceledSuccess = 'Utrka uspješno otkazana',
    raceTimeout = 'DNF (istek vremena)',
    playerWon = '🏆 %s JE POBIJEDIO! Vrijeme: %02d:%06.3f',
    recordingStarted = 'Snimanje započeto! Postavi waypoint-ove za kreiranje kontrolnih točaka',
    leftRace = 'Napustio si utrku',
    checkpointAdded = 'Kontrolna točka dodana (#%d)',
    checkpointRemoved = 'Kontrolna točka uklonjena',
    loadRaceForEdit = 'Učitaj ovu utrku za uređivanje ili pokretanje',
    permanentlyDelete = 'Trajno obriši ovu utrku',
    deleteRaceConfirm = 'Obriši Utrku',
    deleteRaceQuestion = 'Jesi li siguran da želiš obrisati "%s"?',

    -- Errors
    noMoney = 'Nedovoljno sredstava (Potrebno: $%d)',
    noCheckpoints = 'Nema snimljenih kontrolnih točaka',
    noRaceFound = 'Utrka "%s" nije pronađena',
    raceNotFound = 'Utrka nije pronađena',
    noRaces = 'Nema spremljenih utrka',
    notInRace = 'Nisi u utrci',
    notRaceOwner = 'Nisi kreirao ovu utrku',
    alreadyInRace = 'Već si u utrci',
    invalidAmount = 'Nevažeći iznos ulaza ($%d - $%d)',
    invalidName = 'Nevažeće ime utrke',
    tooManyCheckpoints = 'Previše kontrolnih točaka (Max: %d)',
    tooFewCheckpoints = 'Potrebno najmanje %d kontrolnih točaka',
    failedToSave = 'Neuspješno spremanje utrke',
    failedToDelete = 'Neuspješno brisanje utrke',
    noRaceChip = 'Trebaš Race Chip da bi kreirao utrku!',

    -- TextUI
    pressToJoin = 'Pritisni [E] za pridruživanje\nUtrka: $%d | Počinje za: %ds',
    recording = 'Snimanje: Postavi waypoint za dodavanje kontrolne točke\nKontrolne točke: %d',
    joined = 'Pridružen Utrci\nPočinje za: %ds',

    -- HUD
    checkpoint = 'KONTROLNA TOČKA %d/%d (%dm)',

    -- Map blip
    raceStartBlip = 'Start Utrke ($%d)',
}
