server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean' 
game 'gta5'
lua54 'yes'

author "d3MBA & Doki"
discord "discord.gg/d3MBA"

version "1.1.0"

shared_scripts {
    'config/items.lua',
    'config/config.lua',
    'translations.lua',
}

client_scripts {
    'client/target/target.lua',
    'client/*.lua',
    'client/locked/*.lua',
    'client/menu/*.lua',
    'minigame/*.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
}

server_scripts {
    'server/*.lua',
    'server/locked/*.lua',
    'version-check.lua'
} 

ui_page 'minigame/miniGame.html'

files {
    'minigame/miniGame.html',
    'minigame/style.css',
    'minigame/script.js',
    'minigame/image/*.png',
}

escrow_ignore {
    'config/*.lua',
    'translations.lua',
    'client/*.lua',
    'server/*.lua',
    'client/menu/*.lua',
    'client/target/target.lua',
    'minigame/*.lua',
    
    'version-check.lua',
    'items/*.lua',
    'README/*.lua',
}


dependency '/assetpacks'
dependency '/assetpacks'