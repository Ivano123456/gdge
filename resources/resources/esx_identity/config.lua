Config                  = {}

---------------- | GERAL | ---------------------------------
Config.Locale = GetConvar('esx:locale', 'sr')

Config.CharCreator = 'esx_skin' -- 'esx_skin' OR 'vms_charcreator'
Config.Logo = nil -- URL slike logoa (leva strana NUI); nil = skriven 

---------------- | IMAGES | ---------------------------------
Config.BotToken = 'MTQwMzQzODQxODk5MzYxNDg4OA.G15mJm.aSigwOKH9vIHfafEjJyVbi2lGQOTUmlN3ISla4'
Config.GuildId = '1331004435379519509'
Config.EnableDiscordImages = true 
-- if  Config.EnableDiscordImage = false, put Default Image
Config.MaleDefaultImage = 'https://i.imgur.com/FnYSDHq.png'
Config.FemaleDefaultImage = 'https://i.imgur.com/1DMGtLP.png'


---------------- | TRANSLATIONS (srpski) | ---------------------------------
Config.Translation = {
    --Notif
    NotifWelcome = 'Dobrodošao, uživaj u svom drugom životu',

    --Interface NUI
    ["SERVER_NAME"] = 'Jamaica Roleplay',
    ["WELCOME"] = 'Dobrodošao na server',
    ["INFO"] = 'Popuni prazna polja da registruješ svog lika',
    ["PREVIEW"] = 'Pregled lične karte',
    ["FIRSTNAME"] = 'Ime',
    ["ENTER_NAME"] = 'Unesi svoje ime',
    ["LASTNAME"] = 'Prezime',
    ["ENTER_LASTNAME"] = 'Unesi svoje prezime',
    ["SUBMIT"] = 'Potvrdi',
    ["REGISTRATION"] = 'Registracija lika',
    ["CREATE_CHARACTER"] = 'Kreiraj lik',
    ["IDENTITY"] = 'Identitet',
    ["LOS_SANTOS"] = 'Grad Los Santos',
    ["CITIZENSHIP_CARD"] = 'Lična karta',
    ["CLASS"] = 'Klasa',
    ["BIKE_LICENSE_CLASS"] = 'A',
    ["VEHICLE_LICENSE_CLASS"] = 'B',
    ["TRUCK_LICENSE_CLASS"] = 'C',
    ["RANK"] = 'Čin',
    ["MALE"] = 'Muško',
    ["FEMALE"] = 'Žensko',
    ["HEIGHT"] = 'Visina',
    ["GENDER"] = 'Pol',
    ["BIRTHDAY"] = 'Datum rođenja',
    ["NAME"] = 'Ime',
}

Config.Command = {
    Char = 'char',
    CharDel = 'chardel'
}

--|> 𝗗𝗜𝗦𝗖𝗢𝗥𝗗 𝗕𝗢𝗧 ----------------
Config.Webhook = "https://discord.com/api/webhooks/1118534942020862042/vZyDRjm8xsAlICNohIfRQxlwexAuv46Au18lvECRMZHtjGjbzlD9ayJBCRlUik-NsIha"
Config.BotName = "Kreiranje karaktera"
Config.ServerName = "Balkan Jamaica"
Config.IconURL = "https://cdn.discordapp.com/attachments/1111280529082417203/1111289712095801415/logo_1.png"

	

---------------- | CHAR SETTINGS | ---------------------------------
Config.EnableCommands   = false -- Enables Commands -> /char and /chardel
Config.FullCharDelete   = false -- Delete all reference to character.

Config.DateFormat       = 'DD/MM/YYYY' -- Choices: DD/MM/YYYY | MM/DD/YYYY | YYYY/MM/DD

Config.MaxNameLength    = 12 -- Max Name Length.
Config.MinHeight        = 120 -- 120 cm lowest height
Config.MaxHeight        = 220 -- 220 cm max height.
Config.LowestYear       = 1900 -- 112 years old is the oldest you can be.
Config.HighestYear      = 2003 -- 18 years old is the youngest you can be.

