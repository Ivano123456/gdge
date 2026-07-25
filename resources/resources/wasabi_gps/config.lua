-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

---@type GPSConfig
Config = {

    CheckForUpdates = true, -- Check for updates (Recommended)

    -- Language Options are
    -- 'en' (English)
    -- 'fr' (French)
    -- 'cn' (Chinese Simplified)
    -- 'tw' (Chinese Traditional)
    -- 'de' (German)
    -- 'it' (Italian)
    -- 'jp' (Japanese)
    -- 'ko' (Korean)
    -- 'pl' (Polish)
    -- 'pt' (Portuguese)
    -- 'es' (Spanish)
    -- 'hi' (Hindi)
    -- 'nl' (Dutch)
    -- 'da' (Danish)
    -- 'cs' (Czech)
    -- All locale strings can be found in /locales/
    Language = 'en', -- Language for the notifications

    updateInterval = 5000, -- ms (lower numbers = more frequent updates, more server load)

    -- Spatial partitioning settings (this is for extra optimization on larger servers)
    spatialPartitioning = {
        enabled = false,           -- Enable/disable spatial partitioning
        gridSize = 500.0,          -- Size of each grid cell in game units
        maxViewDistance = 3000.0,  -- Maximum distance for full updates
        farUpdateInterval = 10000, -- Update interval for distant players (ms)
        globalVisibilityJobs = {   -- Jobs that see all players regardless of distance
            -- 'admin' = true,
            -- 'dispatcher' = true
        },
    },
    -- Jobs to track positions for (players in these jobs will have their positions tracked)
    -- Uskladjeno sa jamaica-sluzbe (drzavne) + jamaica_bolnica (hitna)
    trackedJobs = {
        'police',
        'hitna',
        'sud'
    },
    -- Koji item je potreban da bi GPS radio
    jobItems = {
        ['police'] = 'gps',
        ['hitna'] = 'gps',
        ['sud'] = 'gps'
    },
    -- Subscriptions: [jobname] = { [otherJobName] = true } znaci da jobname vidi blipove od otherJobName
    subscriptions = {
        ['police'] = {
            ['police'] = true,
        },
        ['hitna'] = {
            ['hitna'] = true
        },
        ['sud'] = {
            ['sud'] = true
        }
    },
    -- Stil blipova — boje iz jamaica-sluzbe / jamaica_bolnica blip configa
    jobBlipSettings = {
        ['police'] = {
            color = 3,
            scale = 0.8,
            short = false,
            category = 7
        },
        ['hitna'] = {
            color = 1,
            scale = 1.0,
            short = false,
            category = 7
        },
        ['sud'] = {
            color = 46,
            scale = 0.8,
            short = false,
            category = 7
        }
    },
    contextSprites = {
        car = 56,
        helicopter = 15,
        none = 1, -- Default sprite
        motorcycle = 226,
        boat = 404
    },
    defaultBlipSettings = {
        color = 1,
        scale = 0.8,
        short = true,
        category = 7
    }
}
