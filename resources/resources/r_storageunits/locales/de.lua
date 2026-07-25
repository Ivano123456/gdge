Language = Language or {}
Language['de'] = { -- German

    -- Blip Labels
    facility_blip = 'Vinewood Lager',
    unit_blip = 'Lagereinheit %s',

    -- Target Options
    office_target = 'Lager Büro',
    enter_unit = 'Einheit %s betreten',
    exit_unit = 'Einheit verlassen',
    manage_items = 'Gegenstände verwalten',
    raid_unit = 'Einheit %s durchsuchen',

    -- Progress Bars
    cutting_lock = 'Schloss aufschneiden...',

    -- Notifications
    notify_title = 'Lagereinheiten',
    insufficient_funds = 'Sie haben nicht genug Geld dabei, um das zu tun.',
    unit_rented = 'Sie haben Lagereinheit %s für %s Tage gemietet.',
    rent_paid = 'Sie haben die Miete für Einheit %s bezahlt. %s Tage verbleibend.',
    password_changed = 'Sie haben das Passwort für Einheit %s geändert.',
    incorrect_password = 'Das eingegebene Passwort ist falsch.',
    unit_overdue = 'Ihre Einheit ist %s Tag(e) überfällig. Bitte bezahlen Sie Ihre Miete, um auf die Einheit zuzugreifen.',
    item_added = 'Sie haben %sx %s zu Ihrer Einheit hinzugefügt.',
    item_removed = 'Sie haben %sx %s aus Ihrer Einheit entfernt.',
    unit_full = 'Die Einheit hat nicht genug Platz für diesen Gegenstand.',
    need_raid_item = 'Sie benötigen einen Bolzenschneider, um eine Einheit zu durchsuchen.',
    inventory_full = 'Sie haben nicht genug Platz in Ihrem Inventar, um diesen Gegenstand zu tragen.',

    -- UI Elements
    facility = 'Vinewood Lager',
    office = 'Lager Büro',
    your_units = 'Ihre Einheiten',
    available = 'Verfügbare Einheiten',
    no_available = 'Keine verfügbaren Einheiten',
    max_rented = 'Max. Einheiten gemietet',
    rent_unit = 'Einheit mieten',
    no_owned = 'Keine gemieteten Einheiten',
    unit_no = 'Einheit Nummer %s',
    unit_weight = 'Einheitsgewicht',
    days_remain = '%s Tage verbleibend',
    days_over = '%s Tage überfällig',
    set_password = 'Passwort festlegen',
    change_password = 'Passwort ändern',
    extend_lease = 'Mietvertrag verlängern',
    make_payment = 'Zahlung vornehmen',
    your_items = 'Ihre Gegenstände',
    unit_items = 'Einheitsgegenstände',
    no_items = 'Keine Gegenstände',
    cancel = 'Abbrechen',
    confirm = 'Bestätigen',
    search = 'Suchen',
    sort = 'Sortieren',
    ascend = 'Aufsteigend',
    descend = 'Absteigend',
    name = 'Name',
    count = 'Anzahl',
    weight = 'Gewicht',

    rent_confirm = 'Möchten Sie die nächste verfügbare Einheit für %s Tage für $%s mieten?',
    pay_confirm = 'Möchten Sie Ihren Mietvertrag für %s Tage für $%s verlängern?',

    add_item_confirm = 'Sind Sie sicher, dass Sie %sx %s lagern möchten?',
    remove_item_confirm = 'Sind Sie sicher, dass Sie %sx %s abholen möchten?',

    disabled_for_raid = 'Beim Durchsuchen einer Einheit deaktiviert.',

    password_specs = 'Nur Zahlen, 4-8 Zeichen.',

    -- Logging
    player_id = 'Spieler-ID',
    username = 'Benutzername',
    identifier = 'Kennung',
    rented_unit = 'Gemietete Einheit',
    paid_rent = 'Miete bezahlt',
    unit_evicted = 'Einheit geräumt',
    added_item = 'Gegenstand hinzugefügt',
    removed_item = 'Gegenstand entfernt',
    unit_number = 'Einheitsnummer',
    lease_period = 'Mietdauer',
    item = 'Gegenstand',
    quantity = 'Menge',

    -- Console
    resource_version = '%s | v%s',
    bridge_detected = '^2Brücke erkannt und geladen.^0',
    bridge_not_detected = '^1Brücke nicht erkannt, bitte stellen Sie sicher, dass sie läuft.^0',
    cheater_print = 'Sie haben versucht, das System zu überlisten. Das System hat Sie überlistet.',
    debug_enabled = '^1Debug-Modus ist EIN! Verwenden Sie dies NICHT in der Produktion!^0',
}