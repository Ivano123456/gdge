server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Flashbang Script using Addon Weapon'
author 'RPWorks'
version '1.0.0'

escrow_ignore 'config.lua'

client_scripts {
    'client/main.lua',
}

shared_scripts {
    'config.lua'
}

server_scripts {
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/flashbang.mp3',
    'html/flashbang_nine.mp3',
    'html/distant.mp3',
    'html/index.html',
    "data/loadouts.meta",
    "data/weaponarchetypes.meta",
	"data/weaponanimations.meta",
	"data/pedpersonality.meta",
	"data/weapons.meta"
}

data_file "WEAPON_METADATA_FILE" "data/weaponarchetypes.meta"
data_file "WEAPON_ANIMATIONS_FILE" "data/weaponanimations.meta"
data_file "LOADOUTS_FILE" "data/loadouts.meta"
data_file "WEAPONINFO_FILE" "data/weapons.meta"
data_file "PED_PERSONALITY_FILE" "data/pedpersonality.meta"
dependency '/assetpacks'