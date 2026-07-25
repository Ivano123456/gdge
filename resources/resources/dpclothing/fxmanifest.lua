client_script '@jamaica-pedovi/src/include/client.lua'


client_script '@obelix-crafting/src/include/client.lua'
fx_version 'bodacious'
game 'gta5'
author 'dullpear'
version '1.0.3'
description 'dpClothing+'

client_scripts {
	'Client/Functions.lua', 		-- Global Functions / Events / Debug and Locale start.
	'Locale/*.lua', 				-- Locales.
	'Client/Config.lua',			-- Configuration.
	'Client/Variations.lua',		-- Variants, this is where you wanan change stuff around most likely.
	'Client/Clothing.lua',
	'Client/GUI.lua',				-- The GUI.
}
