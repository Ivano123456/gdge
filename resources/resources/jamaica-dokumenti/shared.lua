config = {}

config.Kategorije = {
    { autoskolaId = 'bike',  letter = 'A', dokumentiKey = 'd_a_prava', esxType = 'drive_bike',  label = 'Kategorija A' },
    { autoskolaId = 'car',   letter = 'B', dokumentiKey = 'd_b_prava', esxType = 'drive',       label = 'Kategorija B' },
    { autoskolaId = 'truck', letter = 'C', dokumentiKey = 'd_c_prava', esxType = 'drive_truck', label = 'Kategorija C' },
}

config.AutoskolaIdPoDokumentu = {}
config.DokumentKeyPoAutoskolaId = {}
config.LetterPoAutoskolaId = {}

for i = 1, #config.Kategorije do
    local k = config.Kategorije[i]
    config.AutoskolaIdPoDokumentu[k.dokumentiKey] = k.autoskolaId
    config.DokumentKeyPoAutoskolaId[k.autoskolaId] = k.dokumentiKey
    config.LetterPoAutoskolaId[k.autoskolaId] = k.letter
end

config.SluzbeneZnacke = {
    jobs = { police = true },
    poJobu = {
        police = {
            tip = 'police',
            sluzba = 'POLICIJSKA UPRAVA',
            naslov = 'POLICE',
            podnaslov = 'OFFICIAL BADGE',
            seal = 'Police<br>Authority',
            prefiks = 'PU',
        },
    },
}

return config
