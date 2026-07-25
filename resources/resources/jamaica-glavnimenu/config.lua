Config = {}

Config.Framework = 'esx'
Config.OpenKey = 'L'
Config.Command = 'jamaica'
Config.ServerName = 'JAMAICA'
Config.ServerTagline = 'ROLEPLAY'

Config.AdminGroups = { 'vlasnik', 'suvlasnik' }
Config.PremiumGroups = { 'vlasnik', 'suvlasnik' }

Config.DiscordLink = 'https://discord.com/channels/1331004435379519509/1354478916680683682'
Config.ShopDiscordLink = Config.DiscordLink
Config.TicketDiscordLink = Config.DiscordLink
Config.ImagePath = 'nui://ox_inventory/web/images/%s.png'
Config.NuiImageBase = 'img/'
Config.PlaceholderImages = {
    vehicle = Config.NuiImageBase .. 'vehicle.svg',
    money = Config.NuiImageBase .. 'money.svg',
    coin = Config.NuiImageBase .. 'coin.svg',
    coinSc = Config.NuiImageBase .. 'coin-sc.svg',
    package = Config.NuiImageBase .. 'package.svg',
    case = Config.NuiImageBase .. 'case.svg',
    weapon = Config.NuiImageBase .. 'weapon.svg',
    default = Config.NuiImageBase .. 'placeholder.svg',
}

Config.XPPerMinute = 1
Config.MinutesCheckInterval = 10
Config.PremiumDuration = 30

Config.PlayTimeStandardInterval = 60
Config.PlayTimeStandardReward = 3

Config.WeaponsAreItem = true

Config.CoinLabel = 'GC'
Config.CoinEuroRate = 1

Config.SellCoins = {
    { coinCount = 10,  realPrice = 10,  directLink = Config.ShopDiscordLink },
    { coinCount = 20,  realPrice = 20,  directLink = Config.ShopDiscordLink },
    { coinCount = 40,  realPrice = 40,  directLink = Config.ShopDiscordLink },
    { coinCount = 50,  realPrice = 50,  directLink = Config.ShopDiscordLink },
    { coinCount = 100, realPrice = 100, directLink = Config.ShopDiscordLink },
    { coinCount = 200, realPrice = 200, directLink = Config.ShopDiscordLink },
}

Config.ShopSpins = {
    { id = 'brza_isplata', label = 'BRZA ISPLATA',   price = 20,  tag = '',     hot = false, image = 'money',     desc = 'Brza isplata novca — spin do 2.000.000$.', caseUniqueId = 1, caseType = 'premium', priceType = 'GC' },
    { id = 'fatalna',      label = 'FATALNA KUTIJA', price = 20,  tag = '',     hot = false, image = 'armor',     desc = 'Oruzje i panciri — od pistolja do snajpera.', caseUniqueId = 2, caseType = 'premium', priceType = 'GC' },
    { id = 'bmw',          label = 'BMW SPIN',       price = 30, tag = '',     hot = false, image = 'manhartx7', desc = 'BMW M linija — brzina i stil.', caseUniqueId = 6, caseType = 'premium', priceType = 'GC' },
    { id = 'lambo',        label = 'LAMBO SPIN',     price = 50, tag = 'NOVO', hot = false, image = 'ttsto',     desc = 'Lamborghini supercar kolekcija.', caseUniqueId = 7, caseType = 'premium', priceType = 'GC' },
    { id = 'mecka',        label = 'MECKA SPIN',     price = 30, tag = 'NOVO', hot = true,  image = 'dl_g900',   desc = 'Ekskluzivni Mercedes spin sa premium vozilima.', caseUniqueId = 8, caseType = 'premium', priceType = 'GC' },
}

Config.ShopStandardSpins = {
    { id = 'standard1', label = 'STANDARD KUTIJA',   price = 30, tag = 'NOVO', hot = false, image = 'lockpick', desc = 'Itemi, novac i retka vozila — kupovina za SC.', caseUniqueId = 1, caseType = 'standard', priceType = 'SC' },
    { id = 'standard2', label = 'STANDARD KUTIJA 2', price = 80, tag = 'NOVO', hot = false, image = 'money',    desc = 'Vece nagrade — novac, vozila i retki itemi za SC.', caseUniqueId = 2, caseType = 'standard', priceType = 'SC' },
}

Config.ShopPackages = {}

Config.Missions = {
    { id = 'pozdrav',  label = 'Pozdravi server',       desc = 'Ukucaj /pozdrav u chat.', target = 1,   reward = { type = 'money', amount = 2000 } },
    { id = 'play60',   label = 'Aktivno 60 minuta',     desc = 'Ostani online 60 minuta.',                 target = 60,  reward = { type = 'sc', amount = 5 } },
    { id = 'drive20',  label = 'Vozi 20 km',            desc = 'Pređi 20 km u vozilu.',                    target = 20,  reward = { type = 'sc', amount = 3 } },
    { id = 'jobs5',    label = 'Završi 5 poslova',      desc = 'Obavi bilo koji posao 5 puta.',            target = 5,   reward = { type = 'sc', amount = 2 } },
    { id = 'social3',  label = 'Druži se sa igračima',  desc = 'Budi u blizini 3 različita igrača 10 min.', target = 3, reward = { type = 'sc', amount = 2 } },
}

Config.DailyRewardPool = {
    { type = 'money', label = '5.000$',      amount = 5000,  weight = 20, image = 'money.png' },
    { type = 'money', label = '15.000$',     amount = 15000, weight = 15, image = 'money.png' },
    { type = 'money', label = '25.000$',     amount = 25000, weight = 15, image = 'money.png' },
    { type = 'money', label = '50.000$',     amount = 50000, weight = 8,  image = 'money-2.png' },
    { type = 'item',  label = '5x Bandage',  item = 'bandage', amount = 5, weight = 15, image = 'bandage.png' },
    { type = 'item',  label = '10x Bandage', item = 'bandage', amount = 10, weight = 12, image = 'bandage.png' },
    { type = 'item',  label = '3x Pancir',   item = 'armour', amount = 3, weight = 10, image = 'armor.png' },
    { type = 'item',  label = '200x Ammo-9', item = 'ammo-9', amount = 200, weight = 10, image = 'ammo-9.png' },
    { type = 'sc',    label = '3 SC',        amount = 3, weight = 12, image = 'coin-sc.svg' },
    { type = 'sc',    label = '1 SC',        amount = 1, weight = 5,  image = 'coin-sc.svg' },
}

Config.DailyBonusDays = {
    [7]  = { type = 'sc', amount = 5, label = '7. dan — 5 SC' },
    [14] = { type = 'money', amount = 50000, label = '14. dan — 50.000$' },
    [21] = { type = 'sc', amount = 10, label = '21. dan — 10 SC' },
    [30] = { type = 'sc', amount = 25, label = '30. dan — 25 SC + Mega bonus' },
}

Config.FAQ = {
    { q = 'Šta su GC (Gold Coins)?', cat = 'igra', latest = true, a = 'GC su premium valuta servera. Koriste se za premium kutije i ostali donatorski sadržaj. 1 GC = 1 EUR. Stanje GC i SC prikazuje se u gornjem desnom uglu menija.' },
    { q = 'Šta su SC (Standard Coin)?', cat = 'igra', a = 'SC je valuta samo za Standard spinove — ne možeš je koristiti za Premium spinove. Dobijaš je automatski dok si online (3 SC svakih 60 minuta, vidi panel Aktivna igra). GC i SC su potpuno odvojene valute.' },
    { q = 'Kako kupujem GC?', cat = 'igra', latest = true, a = 'Klikni dugme „Kupi GC“ u gornjem desnom uglu menija — otvara se Discord kanal za donacije. Paketi: 10, 20, 40, 50, 100 i 200 GC. Nakon uplate, administracija ti doda GC na nalog. Takođe možeš dobiti GC kroz promo kodove, dnevne nagrade, misije i bonus dane u streak-u.' },
    { q = 'Kako koristim promo kod?', cat = 'igra', a = 'U sidebaru izaberi „Promo kodovi“. Unesi kod koji si dobio na Discordu ili od administracije i klikni AKTIVIRAJ. Ako je kod ispravan i nije iskorišćen, GC se odmah dodaje na tvoj nalog. Svaki kod može imati ograničen broj korišćenja.' },
    { q = 'Šta su misije i kako ih završiti?', cat = 'misije', latest = true, a = 'Misije su jednokratni zadaci u sekciji „Misije“ u sidebaru. Trenutno: ukucaj /pozdrav u chat (2.000$), ostani online 60 min (5 SC), pređi 20 km vozilom (3 SC), završi 5 poslova (2 SC), budi u blizini 3 različita igrača po 10 min (2 SC). Napredak se prati automatski — kad ispuniš uslov, nagrada stiže jednom i misija više nije dostupna.' },
    { q = 'Kako funkcionišu dnevne nagrade?', cat = 'nagrade', latest = true, a = 'U sekciji „Dnevne nagrade“ vidiš 30-dnevni kalendar sa nagradama za svaki dan (novac, itemi, SC). Svaki dan možeš preuzeti jednu nagradu klikom na „PREUZMI DANAŠNJU NAGRADU“. Bonus dani (7, 14, 21, 30) donose veće nagrade: 5 SC, 50.000$, 10 SC i 25 SC. Svako polje u kalendaru pokazuje tačno šta dobijaš tog dana.' },
    { q = 'Šta ako propustim dan u streak-u?', cat = 'nagrade', a = 'Ako ne preuzmeš dnevnu nagradu u roku od 48 sati od poslednjeg claima, streak se resetuje na dan 1. Redovno ulazi u meni i preuzmi nagradu da zadržiš napredak ka bonus danima 7, 14, 21 i 30.' },
    { q = 'Šta je panel Aktivna igra?', cat = 'nagrade', a = 'Dok si online na serveru, automatski dobijaš 3 SC svakih 60 minuta — samo za Standard spinove. Panel prikazuje trenutno stanje GC i SC. Takođe, svi online igrači dobijaju Battlepass XP (+10 svakih 10 minuta) bez obzira na aktivnost u meniju.' },
    { q = 'Kako funkcioniše Battlepass?', cat = 'nagrade', a = 'Battlepass ima dve staze: Civilni (besplatan za sve) i Pro (premium). XP dobijaš automatski dok si online na serveru. Svaki level otključava nagradu — klikni PREUZMI kad dostigneš level. Civilni track ima nagrade po levelima za sve igrače. Pro track zahteva Pro pristup (kupovina preko Discord ticketa) i nudi ekskluzivnije nagrade. Koristi strelice ◀ ▶ za listanje levela.' },
    { q = 'Kako funkcionišu spineri (kutije)?', cat = 'igra', latest = true, a = 'U Shop → Kutije biraš Premium (GC) ili Standard (SC) tab. Klikni sliku da vidiš sve nagrade. KUPI ili KORPA — spinovi idu u Moje kutije i otvaraš ih kad hoćeš. Nakon otvaranja: PRIKUPI stavlja nagradu (vozilo u garažu, item u inventar), PRODAJ vraća deo vrednosti u GC/SC.' },
    { q = 'Kako rade spinovi (Premium vs Standard)?', cat = 'igra', a = 'Premium tab — spinovi za GC (Mecka, Lambo, BMW, Brza isplata i ostali). Standard tab — spinovi za SC koje dobijaš dok si online. KUPI ili KORPA — kupljeni spinovi čekaju u Moje kutije. PRIKUPI dodaje nagradu, PRODAJ vraća GC ili SC.' },
    { q = 'Šta su Moje kutije?', cat = 'igra', latest = true, a = 'Kad kupiš jednu ili više kutija (KUPI ili KUPI SVE iz korpe), ne moraš ih odmah otvarati. Sve čekaju u Shop → Moje kutije. Otvori kad god hoćeš — broj kupljenih kutija vidiš u sidebaru pored stavke.' },
    { q = 'Gde idu nagrade iz spinova i kutija?', cat = 'igra', a = 'Vozila idu direktno u tvoju garažu. Novac i itemi idu u inventar. Ako ne želiš nagradu, PRODAJ u modalu vraća deo vrednosti u GC. Retke nagrade (mythical, legendary) mogu biti objavljene na serveru kao obaveštenje.' },
}

Config.LastItemCategories = { 'rare', 'mythical', 'legendary' }
Config.ServerNotifyCategories = { 'mythical', 'legendary' }
