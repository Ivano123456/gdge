Config, Locales = {}, {}

Config.Locale = 'en' -- en / pt / es (not yet) / fr (not yet) / de (not yet)

Config.Debug = false -- true = Debug mode, it will show the debug messages on the console

Config.AutoAddDatabaseTables = true -- true = Auto add the database tables | false = You need to add the database tables manually

Config.AutoCreateSociety = true -- true = Auto create the society on the database tables | false = You need to create the society manually

Config.UseOkokNotify = false -- true = okokNotify | false = esx-notify (You can change the notification system on cl_utils.lua)

Config.UseOkokTextUI = true -- true = okokTextUI | false = esx-textui

Config.UseOkokRequests = true -- true = okokRequests | false = right away

Config.UseOkokBanking = false -- true = okokBanking | false = qb-banking ( For transactions )

Config.UseJobBlip = true -- true = marker or target | false = open with a command

Config.UseJobBlipAndCommand = false -- true = marker or target and command | false = only marker or target

Config.UseTarget = false -- true = Target | false = textUI

Config.EventPrefix = "okokBossMenu"  -- This will change the prefix of the events name so if Config.EventPrefix = "example" the events will be "example:event"

Config.SocietySystem = "addon-account" -- addon-account / okokBanking / custom (you need to implement it on sv_utils.lua)

Config.TargetSystem = "ox-target" -- The target system you are using ( ox-target )

Config.InventorySystem = "ox-inventory" -- The inventory system you are using ( ox-inventory / qs-inventory )

Config.ClothingSystem = "illenium-appearance" -- The clothing system you are using ( esx_skin / illenium-appearance )

Config.OpenBossMenuCommand = "openbossmenu" -- The command to open the boss menu if Config.UseJobBlip = false

Config.OpenGangMenuCommand = "opengangmenu" -- The command to open the gang menu if Config.UseJobBlip = false

Config.OpenDutyCommand = "openduty" -- The command to open the duty menu if Config.UseJobBlip = false

Config.BossGrades = { "boss", "nacelnik", "komandir_jedinice", "sef" }

Config.Currency = "$"

Config.DefaultPaymentAfterFire = 50 -- The default payment after being fired

Config.HireDistance = 3.0 -- The distance that the player needs to be to hire someone

Config.MarkerDistance = 10 -- The distance that the player needs to be to see the marker

Config.MarkerID = 21 -- The marker ID for the job locations

Config.MarkerColors = { r = 31, g = 94, b = 255, a = 90 } -- The marker colors for the job locations

Config.UseOffDutyPrefix = false -- true = It will set the players with the job with the prefix set below (it must exist on the database)

Config.OffDutyPrefix = "off_" -- The prefix for the off duty jobs

Config.UseNewESXDutySystem = false -- true = It will use the new ESX duty system | false = It will use the old ESX duty system

Config.JobLocations = {
	['police'] = { bossCoords = { vector3(-568.1845, -418.8559, 39.6326) }, dutyCoords = { vector3(-586.1968, -421.3154, 35.1721) } },
	['ballas'] = { bossCoords = { vector3(123.7552, -1945.4767, 15.2248) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['bratva'] = { bossCoords = { vector3(-112.9606, 986.0143, 235.7541) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['cartel'] = { bossCoords = { vector3(-658.4692, 886.5168, 229.2506) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['casablanca'] = { bossCoords = { vector3(-1520.3446, 849.1136, 181.5948) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['crips'] = { bossCoords = { vector3(-343.6540, 70.2432, 54.4226) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['ghost'] = { bossCoords = { vector3(-10.3604, 530.8649, 170.6171) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['gsf'] = { bossCoords = { vector3(-18.3491, -1438.6615, 31.1015) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['lasveles'] = { bossCoords = { vector3(1367.1208, -606.2709, 74.7109) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['narcos'] = { bossCoords = { vector3(1408.4633, 1160.0927, 114.3339) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['nostra'] = { bossCoords = { vector3(-971.2881, 122.2534, 57.0486) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['omerta'] = { bossCoords = { vector3(-1536.9426, 130.5551, 57.3713) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['pink'] = { bossCoords = { vector3(-1565.8419, 19.1904, 64.4431) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['sicilia'] = { bossCoords = { vector3(-806.3162, 167.7657, 76.7408) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['skyloft'] = { bossCoords = { vector3(188.6966, 1713.5571, 231.0917) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['vagos'] = { bossCoords = { vector3(473.1223, -1297.5754, 30.3189) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['vipers'] = { bossCoords = { vector3(-3232.9583, 813.1467, 14.0782) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['autoumro'] = { bossCoords = { vector3(1070.6227, -885.0640, 55.6627) }, dutyCoords = { vector3(-565.1845, -412.8559, 39.6326) } },
	['hitna'] = { bossCoords = { vector3(-817.1052, -1222.9845, 11.3143) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['sombra'] = { bossCoords = { vector3(-1893.5326, 2075.5938, 140.9977) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['automafija'] = { bossCoords = { vector3(726.2280, -1032.0940, 5.2556) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['vpburgershot'] = { bossCoords = { vector3(-1185.3297, -901.9291, 13.9878) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['beanmachine'] = { bossCoords = { vector3(118.4955, -1045.4022, 29.3050) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['glodari'] = { bossCoords = { vector3(645.7830, 1253.9586, 367.2819) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['vipers'] = { bossCoords = { vector3(-2588.0078, 1910.9368, 167.4988) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['sud'] = { bossCoords = { vector3(-1665.0231, 149.4897, 70.7250) }, dutyCoords = { vector3(-1582.0085, 191.8928, 58.8536) } },
	['autofuseraj'] = { bossCoords = { vector3(-349.5180, -1334.9753, 36.2903) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['camorra'] = { bossCoords = { vector3(-1940.4362, 389.6186, 101.8357) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['peaky'] = { bossCoords = { vector3(-1804.9469, 436.5003, 128.8346) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
	['kavacki'] = { bossCoords = { vector3(-1175.4871, 302.4678, 73.6628) }, dutyCoords = { vector3(-813.6456, -1231.8682, 6.7260) } },
}

-------------------------- DISCORD LOGS

Config.BotName = 'ServerName' -- Write the desired bot name

Config.ServerName = 'ServerName' -- Write your server's name

Config.IconURL = '' -- Insert your desired image link

Config.DateFormat = '%d/%m/%Y [%X]' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html

Config.DepositWebhook = true
Config.DepositWebhookColor = '65280'

Config.WithdrawWebhook = true
Config.WithdrawWebhookColor = '16711680'

Config.HireWebhook = true
Config.HireWebhookColor = '65280'

Config.FireWebhook = true
Config.FireWebhookColor = '16711680'

Config.EditEmployeeRankWebhook = true
Config.EditEmployeeRankWebhookColor = '65280'

Config.OnDutyWebhook = true
Config.OnDutyWebhookColor = '65280'

Config.OffDutyWebhook = true
Config.OffDutyWebhookColor = '16711680'

Config.GivenBonusWebhook = true
Config.GivenBonusWebhookColor = '65280'

-------------------------- LOCALES (DON'T TOUCH)

function _okok(id)
	if Locales[Config.Locale][id] then
		return Locales[Config.Locale][id]
	else
		print("The locale '"..id.."' doesn't exist!")
	end
end