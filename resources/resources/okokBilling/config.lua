Config, Locales = {}, {}

Config.Debug = false -- This help find the source of a problem 

Config.OnlyUnpaidCityInvoices = false

Config.OnlyUnpaidSocietyInvoices = false

Config.EventPrefix = 'okokBilling'

Config.Locale = 'en'

Config.DatabaseTable = 'okokbilling'

Config.ReferencePrefix = 'OK'

Config.OpenMenuKey = 168 -- Default 168 (F7)

Config.OpenMenuCommand = 'racuni' -- Command to open the menu

Config.InvoiceDistance = 15

Config.AllowPlayersInvoice = false -- if players can create Player to Player invoices

Config.okokRequests = true -- Player to Player invoices only, to avoid abuse

Config.UseOKOKBankingTransactions = false -- If set to true it will register the bills to okokBanking transactions

Config.AuthorReceivesAPercentage = true -- When sending a society invoice

Config.AuthorPercentage = 10 -- Percentage that the invoice author receives

Config.VATPercentage = 23

Config.SocietyReceivesLessWithVAT = false

Config.AddonAccount = true -- If set to true it will use the addon_account_data table in the database, if set to false it will use the okokBanking tables

Config.SocietyHasSocietyPrefix = true -- *Do not touch this if the resource is working correctly* If set to true it'll search for `society_police` (example) when paying a society invoice

Config.AutoDeletePaidInvoices = true -- true: Deletes paid invoices (to reduce lag) | false: Doesn't delete paid invoices.

Config.DeletePaidInvoicesEvery = 30 -- How often it should delete the paid invoices (in minutes)

Config.AuthorReceiveNotification = false -- If set to true it will send a notification to the author when the invoice is paid

-- Autopay

Config.UseAutoPay = true

Config.AllowMoneyToGoNegative = false -- If set to true it will allow the player to go negative

Config.DefaultLimitDate = 1 -- Days for limit pay date

Config.CheckForUnpaidInvoicesEvery = 30 -- minutes

Config.FeeAfterEachDay = true

Config.FeeAfterEachDayPercentage = 5

-- Autopay

Config.JobsWithCityInvoices = { -- Which jobs have City Invoices (They will be allowed to delete any invoice) | Admins will have access by default
	'sud'
}

Config.CityInvoicesAccessRanks = { -- Which jobs have City Invoices (They will be allowed to delete any invoice)
	'' -- All of them have access
}

Config.AllowedSocieties = { -- Which societies can access the Society Invoices
	'police',
	'hitna',
	'autoumro',
	'sud'
}

Config.InspectCitizenSocieties = { -- Which societies can access the Society Invoices
	'police'
}

Config.SocietyAccessRanks = { -- Which ranks of the society have access to Society Invoices and City Invoices
	'boss',
	'sef',
	'nacelnik',
}

Config.BillsList = {
	['police'] = {
		{'Prekoracenje brzine', 5000},
		{'Prolazak kroz crveno', 8000},
		{'Voznja u suprotnom smeru', 15000},
		{'Bezanje od policije', 25000},
		{'Ilegalno oruzje', 50000},
		{'Posedovanje droge', 30000},
		{'Napad na sluzbeno lice', 40000},
		{'Ranavanje sluzbenog lica', 80000},
		{'Ometanje sluzbenog lica', 20000},
		{'Vredanje sluzbenog lica', 20000},
		{'Pokusaj podmicivanja sluzbenog lica', 20000},
		{'Pokusaj ubistva sluzbenog lica', 50000},
		{'Pokusaj ubistva civila', 40000},
		{'Ubistvo civila', 60000},
		{'Kidnapovanje civila', 50000},
		{'Kidnapovanje sluzbenog lica', 70000},
		{'Posedovanje ilegalnih stvari', 20000},
		{'Pljacka galerije', 80000},
		{'Pljacka jahte', 50000},
		{'Pljacka oli rig', 100000},
		{'Pljacka Male Banke', 150000},
		{'Pljacka Zlatare', 100000},
		{'Open-Fire', 200000},
		{'Pljacka prodavnice', 20000},
		{'Pljacka ormarica', 20000},
		{'Custom'},
	},
	['hitna'] = {
		{'Medicinska voznja', 3500},
		{'Medicinski tretman 1', 1500},
		{'Medicinski tretman 2', 2000},
		{'Medicinski tretman 3', 1000},
		{'Medicinski tretman 4', 700},
		{'Custom'}, -- If set without a price it'll let the players create a custom invoice (custom price)
	},
	['autoumro'] = {
		{'Popravka vozila', 2000},
		{'Promena felne', 20000},
		{'Custom'}, -- If set without a price it'll let the players create a custom invoice (custom price)
	},
	['sud'] = {
		{'Advokatske usluge', 80000},
		{'Nepostovanje suda', 50000},
		{'Custom'},
	},
	['autofuseraj'] = {
		{'Popravka vozila', 2000},
		{'Promena felne', 20000},
		{'Custom'}, -- If set without a price it'll let the players create a custom invoice (custom price)
	},
}

Config.AdminGroups = {
	'vlasnik',
	'suvlasnik',
}

-------------------------- DISCORD LOGS

-- To set your Discord Webhook URL go to sv_utils.lua, line 5

Config.BotName = 'ServerName' -- Write the desired bot name

Config.ServerName = 'ServerName' -- Write your server's name

Config.IconURL = '' -- Insert your desired image link

Config.DateFormat = '%d/%m/%Y [%X]' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html

Config.CreatePersonalInvoiceWebhookColor = '65535'

Config.CreateJobInvoiceWebhookColor = '16776960'

Config.CancelInvoiceWebhookColor = '16711680'

Config.PayInvoiceWebhookColor = '65280'

-------------------------- LOCALES (DON'T TOUCH)

function _L(id) 
	if Locales[Config.Locale][id] then 
		return Locales[Config.Locale][id] 
	else 
		print('Locale '..id..' doesn\'t exist') 
	end 
end