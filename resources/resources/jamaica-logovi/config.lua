Config = {}

Config.AutoSetupChannels = true
Config.StartDiscordBot = true

Config.BotName = 'Jamaica Logovi'
Config.FooterText = 'Balkan Jamaica RP'
Config.CategoryName = 'Jamaica Logovi'
Config.CategoryNames = {
    'Jamaica Logovi',
    'Jamaica Logovi 2',
}
Config.MaxCategoryChannels = 50

Config.QueueIntervalMs = 800
Config.QueueBatchSize = 4
Config.ChannelReloadMs = 30000
Config.PlayerCacheMs = 60000

Config.Colors = {
    green = 3066993,
    red = 15158332,
    blue = 3447003,
    orange = 15105570,
    purple = 10181046,
    yellow = 16776960,
    grey = 9807270,
    pink = 16761035,
}

Config.LogChannels = {
    { key = 'ulazak', name = 'ulazak', topic = 'Ulazak na server' },
    { key = 'izlazak', name = 'izlazak', topic = 'Izlazak sa servera' },
    { key = 'ubistvo', name = 'ubistvo', topic = 'Ubistvo od strane igrača' },
    { key = 'smrt', name = 'smrt', topic = 'Prirodna smrt / NPC' },
    { key = 'cannabis_sakupljanje', name = 'cannabis-sakupljanje', topic = 'Cannabis — sakupljanje' },
    { key = 'cannabis_prodaja', name = 'cannabis-prodaja', topic = 'Cannabis — prodaja kod dilera' },
    { key = 'cannabis_trade', name = 'cannabis-trade-oruzje', topic = 'Cannabis — trade oružje kod dilera' },
    { key = 'cocaine_list_sakupljanje', name = 'cocaine-list-sakupljanje', topic = 'Cocaine List — sakupljanje' },
    { key = 'cocaine_list_prodaja', name = 'cocaine-list-prodaja', topic = 'Cocaine List — prodaja kod dilera' },
    { key = 'cocaine_list_trade', name = 'cocaine-list-trade-oruzje', topic = 'Cocaine List — trade oružje kod dilera' },
    { key = 'meth_sakupljanje', name = 'meth-sakupljanje', topic = 'Meth — sakupljanje' },
    { key = 'meth_prodaja', name = 'meth-prodaja', topic = 'Meth — prodaja kod dilera' },
    { key = 'meth_trade', name = 'meth-trade-oruzje', topic = 'Meth — trade oružje kod dilera' },
    { key = 'koks_prerada', name = 'koks-prerada', topic = 'Prerada droge' },
    { key = 'droga_ostalo', name = 'droga-ostalo', topic = 'Ostala droga' },
    { key = 'sef_uzimanje', name = 'sef-uzimanje', topic = 'Uzimanje iz sefa organizacije' },
    { key = 'sef_stavljanje', name = 'sef-stavljanje', topic = 'Stavljanje u sef organizacije' },
    { key = 'sluzbe_vezivanje', name = 'sluzbe-vezivanje', topic = 'Službe — vezivanje' },
    { key = 'sluzbe_odvezivanje', name = 'sluzbe-odvezivanje', topic = 'Službe — odvezivanje' },
    { key = 'sluzbe_oruzarnica', name = 'sluzbe-oruzarnica', topic = 'Službe — oružarnica' },
    { key = 'sluzbe_kazna', name = 'sluzbe-kazna', topic = 'Službe — kazna' },
    { key = 'sluzbe_dozvola', name = 'sluzbe-dozvola', topic = 'PD — dozvola za oružje' },
    { key = 'sluzbe_dokaz', name = 'sluzbe-dokaz', topic = 'Službe — novi dokaz' },
    { key = 'sluzbe_evidencija_uzimanje', name = 'sluzbe-evidencija-uzimanje', topic = 'Službe — uzimanje iz evidencije' },
    { key = 'sluzbe_evidencija_stavljanje', name = 'sluzbe-evidencija-stavljanje', topic = 'Službe — stavljanje u evidenciju' },
    { key = 'mafija_vezivanje', name = 'mafija-vezivanje', topic = 'Mafija — vezivanje' },
    { key = 'mafija_reket_vezan', name = 'mafija-reket-vezan', topic = 'Mafija — reket vezan' },
    { key = 'society_podizanje', name = 'society-podizanje', topic = 'Boss menu — podizanje novca' },
    { key = 'society_uplata', name = 'society-uplata', topic = 'Boss menu — uplata novca' },
    { key = 'babica_ozivljavanje', name = 'babica-ozivljavanje', topic = 'Babica — oživljavanje igrača' },
    { key = 'pljacka_jahta_pocetak', name = 'pljacka-jahta-pocetak', topic = 'Pljačka jahte — početak' },
    { key = 'pljacka_jahta_loot', name = 'pljacka-jahta-loot', topic = 'Pljačka jahte — plijen po tački' },
    { key = 'pljacka_jahta_zavrsetak', name = 'pljacka-jahta-zavrsetak', topic = 'Pljačka jahte — završeno' },
    { key = 'pljacka_jahta_prekid', name = 'pljacka-jahta-prekid', topic = 'Pljačka jahte — prekinuto' },
    { key = 'pljacka_prodavnica_pocetak', name = 'pljacka-prodavnica-pocetak', topic = 'Pljačka prodavnice — početak' },
    { key = 'pljacka_prodavnica_zavrsetak', name = 'pljacka-prodavnica-zavrsetak', topic = 'Pljačka prodavnice — uspešno' },
    { key = 'pranje_masina_start', name = 'pranje-masina-start', topic = 'Praonica — pokretanje pranja novca' },
    { key = 'pranje_masina_zavrsetak', name = 'pranje-masina-zavrsetak', topic = 'Praonica — završeno pranje novca' },
    { key = 'inventar_bacanje', name = 'inventar-bacanje-pod', topic = 'Inventar — bacanje predmeta na pod' },
    { key = 'inventar_podizanje', name = 'inventar-podizanje-pod', topic = 'Inventar — podizanje predmeta sa poda' },
    { key = 'inventar_davanje', name = 'inventar-davanje', topic = 'Inventar — davanje predmeta igraču' },
    { key = 'inventar_oduzimanje', name = 'inventar-oduzimanje', topic = 'Inventar — oduzimanje predmeta od igrača' },
    { key = 'supply_drop_pocetak', name = 'supply-drop-pocetak', topic = 'Supply drop — pojava na mapi' },
    { key = 'supply_drop_capture', name = 'supply-drop-capture', topic = 'Supply drop — početak preuzimanja' },
    { key = 'supply_drop_zavrsetak', name = 'supply-drop-zavrsetak', topic = 'Supply drop — uspešno osvojen' },
    { key = 'automafija_obio', name = 'automafija-obio', topic = 'Auto mafija — obijanje vozila' },
    { key = 'automafija_zaplena', name = 'automafija-zaplena', topic = 'Auto mafija — zaplena vozila' },
    { key = 'automafija_parkirano', name = 'automafija-parkirano', topic = 'Auto mafija — parkiranje u garazu' },
    { key = 'automafija_izvadeno', name = 'automafija-izvadeno', topic = 'Auto mafija — izvadenje iz garaze' },
    { key = 'automafija_rastavljeno', name = 'automafija-rastavljeno', topic = 'Auto mafija — rastavljanje vozila' },
    { key = 'automafija_otkup_ponuda', name = 'automafija-otkup-ponuda', topic = 'Auto mafija — ponuda otkupa' },
    { key = 'automafija_otkup_prihvacen', name = 'automafija-otkup-prihvacen', topic = 'Auto mafija — prihvacen otkup' },
    { key = 'autopijaca_postavljanje', name = 'autopijaca-postavljanje', topic = 'Auto pijaca — postavljanje vozila na prodaju' },
    { key = 'autopijaca_kupovina', name = 'autopijaca-kupovina', topic = 'Auto pijaca — kupovina vozila' },
    { key = 'chat_staff_pm', name = 'chat-staff-pm', topic = 'Staff — privatna poruka igraču' },
    { key = 'admin_duznost_nedelja', name = 'admin-duznost-nedelja', topic = 'Admin — nedeljni sati na dužnosti' },
}

Config.OrgStashPatterns = {
    '^society_',
    '^Bolnica',
    '^skladiste%-',
    '^priv%-ormaric%-',
    '^police$',
}
