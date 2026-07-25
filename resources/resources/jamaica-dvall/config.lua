Config = {}

Config.DeleteDelaySeconds = 30

-- NUI traka odbrojava DeleteDelaySeconds sekundi (poruka u AnnounceMessage)

Config.ScanYieldEvery = 40
Config.DeleteBatchSize = 12
Config.DeleteBatchWaitMs = 75

Config.AnnounceTitle = 'DVALL'

Config.AnnounceMessage = 'Za 30 sekundi biće obrisana sva prazna vozila kako biste imali bolji FPS.'

Config.AdminGroups = {
    ['superadmin'] = true,
    ['headadmin'] = true,
    ['vodja_eventa'] = true,
    ['vodja_lidera'] = true,
    ['vodja_admina'] = true,
    ['menadzer'] = true,
    ['asistent'] = true,
    ['suvlasnik'] = true,
    ['vlasnik'] = true,
}
