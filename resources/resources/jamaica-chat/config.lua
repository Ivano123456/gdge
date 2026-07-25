Config = {}

--------------------------------
-- [Date Format]

Config.DateFormat = '%H:%M' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- [Staff Groups]

Config.StaffGroups = {
	'helper',
	'admin',
	'roleplayadmin',
	'eventadmin',
	'superadmin',
	'headadmin',
	'vodja_eventa',
	'vodja_lidera',
	'vodja_admina',
	'menadzer',
	'asistent',
	'suvlasnik',
	'vlasnik',
}

Config.StaffPermisije = {
	["helper"] = { staffonly = true },
	["admin"] = { staffonly = true },
	["roleplayadmin"] = { staffonly = true },
	["eventadmin"] = { staffonly = true },
	["superadmin"] = { staffonly = true },
	["headadmin"] = { staffonly = true },
	["vodja_eventa"] = { staffonly = true },
	["vodja_lidera"] = { staffonly = true },
	["vodja_admina"] = { staffonly = true },
	["menadzer"] = { staffonly = true },
	["asistent"] = { staffonly = true },
	["suvlasnik"] = { staffonly = true },
	["vlasnik"] = { staffonly = true },
}

--------------------------------
-- [Clear Player Chat]

Config.AllowPlayersToClearTheirChat = true

Config.ClearChatCommand = 'clear'

--------------------------------
-- [Staff]

Config.EnableStaffCommand = false

Config.StaffCommand = 'sc'

Config.AllowStaffsToClearEveryonesChat = true

Config.ClearEveryonesChatCommand = 'clearall'

-- [Staff Only Chat]

Config.EnableStaffOnlyCommand = true

Config.StaffOnlyCommand = 'a'

--------------------------------
-- [Advertisements]

Config.EnableAdvertisementCommand = false

Config.AdvertisementCommand = 'ad'

Config.AdvertisementPrice = 250

Config.AdvertisementCooldown = 0 -- in minutes

--------------------------------
-- [Twitch]

Config.EnableTwitchCommand = false

Config.TwitchCommand = 'twitch'

-- Types of identifiers: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.TwitchList = {
	'steam:110000118a12j8a' -- Example, change this
}

--------------------------------
-- [Youtube]

Config.EnableYoutubeCommand = false

Config.YoutubeCommand = 'youtube'

-- Types of identifiers: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.YoutubeList = {
	'steam:110000118a12j8a' -- Example, change this
}

--------------------------------
-- [Twitter]

Config.EnableTwitterCommand = false

Config.TwitterCommand = 'twitter'

Config.TwitterPrice = 150

--------------------------------
-- [Police]

Config.EnablePoliceCommand = true

Config.PoliceCommand = 'pol'

Config.PoliceJobName = 'police'

-- Samo ovi grade-ovi mogu slati policijsko obaveštenje (vidi ga ceo server)
Config.PoliceAllowedGrades = {
	[10] = true,
	[11] = true,
}

Config.PoliceObavestenjeCooldownSeconds = 15

--------------------------------
-- [Ambulance]

Config.EnableAmbulanceCommand = false

Config.AmbulanceCommand = 'ambulance'

Config.AmbulanceJobName = 'ambulance'

--------------------------------
-- [Haker chat — samo aktivni haker iz jamaica-haker; ID vidi samo staff grupa]

Config.EnableHakerChatCommand = false

Config.HakerChatCommand = 'haker'

--------------------------------
-- [Staff obaveštenje — vlasnik, suvlasnik, menadžer, asistent, vodja admina, vodja lidera]

Config.EnableStaffObavestenjeCommand = true

Config.StaffObavestenjeCommand = 'obavestenje'

Config.StaffObavestenjeAltCommand = 'oa'

Config.StaffObavestenjeCooldownSeconds = 15

Config.StaffObavestenjeGroups = {
	vlasnik = true,
	suvlasnik = true,
	menadzer = true,
	asistent = true,
	vodja_admina = true,
	vodja_lidera = true,
}

Config.StaffObavestenjeLabels = {
	vlasnik = 'VLASNIK',
	suvlasnik = 'SU-VLASNIK',
	menadzer = 'MENADŽER',
	asistent = 'ASISTENT',
	vodja_admina = 'VODJA ADMINA',
	vodja_lidera = 'VODJA LIDERA',
}

--------------------------------
-- [Staff PM — privatna poruka igraču]

Config.EnableStaffPmCommand = true

Config.StaffPmCommand = 'pm'

Config.StaffPmLabels = {
	helper = 'HELPER',
	admin = 'ADMIN',
	roleplayadmin = 'RP ADMIN',
	eventadmin = 'EVENT ADMIN',
	superadmin = 'SUPER ADMIN',
	headadmin = 'HEAD ADMIN',
	vodja_eventa = 'VODJA EVENTA',
	vodja_lidera = 'VODJA LIDERA',
	vodja_admina = 'VODJA ADMINA',
	menadzer = 'MENADŽER',
	asistent = 'ASISTENT',
	suvlasnik = 'SU-VLASNIK',
	vlasnik = 'VLASNIK',
}

--------------------------------
-- [Chat mute]

Config.MuteCommand = 'mute'

Config.UnmuteCommand = 'unmute'

Config.MaxMuteMinutes = 1440

--------------------------------
-- [Filter zabranjenih reči]

Config.ChatFilter = {
	Enabled = true,
	StaffBypass = true,
	NotifyMessage = 'Ova poruka sadrži zabranjen sadržaj.',
	Words = {
		'discord',
		'disc',
		'.gg',
		'gg',
		'picka',
		'jebem',
		'kurac',
		'kurva',
		'sisa',
		'majku',
		'majka',
		'vortex',
		'asterix',
		'glory',
		'banjola',
		'revolucija',
		'mamba',
		'mozzart',
		'http',
		'https',
		'www',
	},
}

--------------------------------
