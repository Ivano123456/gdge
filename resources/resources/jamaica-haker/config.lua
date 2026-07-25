Config = {}

Config.TrajanjeHakera = 30

Config.AdminGroups = {
    ['suvlasnik'] = true,
    ['vlasnik'] = true,
}

Config.Commands = {
    give_hacker = 'dajhakera',
    give_hacker_offline = 'dajoffhakera',
    extend_hacker = 'produzihakera',
    hacker_menu = 'haker',
}

Config.Cene = {
    dosje = 15000,
    potjernica = 25000,
}

Config.PonudaTrajanje = 60

Config.Messages = {
    no_permission = 'Nemate dozvolu za ovu komandu!',
    invalid_player_id = 'Nevažeći ID igrača!',
    player_not_found = 'Igrač nije pronađen!',
    player_offline = 'Igrač mora biti online da bi prihvatio brisanje.',
    hacker_given = 'Haker pristup dat igraču ID %s na %s dana.',
    hacker_received = 'Dobili ste haker pristup na %s dana. Koristite /haker',
    invalid_uuid = 'Nevažeći UUID!',
    uuid_not_found = 'UUID nije pronađen u bazi!',
    offline_hacker_given = 'Offline haker pristup dat UUID %s na %s dana.',
    hacker_extended = 'Haker pristup produžen igraču ID %s za %s dana.',
    hacker_extension_received = 'Vaš haker pristup je produžen za %s dana.',
    not_hacker = 'Niste haker!',
    hacker_expired = 'Vaš haker pristup je istekao.',
    no_records = 'Nema dosijea ni poternica za ovog igrača.',
    offer_sent = 'Ponuda poslata igraču — čeka se F4 potvrda.',
    offer_pending = 'Igrač već ima aktivnu ponudu.',
    offer_expired = 'Ponuda je istekla.',
    no_money = 'Nemate dovoljno novca! Potrebno: %s$',
    delete_failed = 'Brisanje nije uspelo.',
    deleted_target = 'Obrisano: %s za %s$.',
    deleted_hacker = 'Igrač je prihvatio brisanje — zaradili ste %s$.',
    offer_cancelled = 'Ponuda je otkazana.',
}
