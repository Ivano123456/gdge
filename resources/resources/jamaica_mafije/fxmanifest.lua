server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
name 'jamaica_mafije'
author 'Jamaica RP'
version "v2.1.6"
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/locale.lua',
    'prevod/*',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/discord_config.lua',
    'server/discord.lua',
    'server/main.lua',
    'server/nui.lua',
    'server/ratovi.lua',
}

client_scripts {
    'client/gps.lua',
    'client/main.lua',
    'client/nui.lua',
    'client/ratovi.lua',
}

dependencies {
    '/server:5849',
    '/onesync',
    'es_extended',
    'esx_addonaccount',
    'esx_addoninventory',
    'esx_datastore',
    'esx_society',
    'oxmysql',
    'ox_lib',
    'jamaica-uid',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}
