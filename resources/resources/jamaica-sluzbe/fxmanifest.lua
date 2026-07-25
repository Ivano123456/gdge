server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'




fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared.lua'
}

client_scripts {
    'client/nui.lua',
    'client/f6.lua',
    'client/main.lua',
    'client/gps.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/discord_config.lua',
    'server/discord.lua',
    'server/dispatch.lua',
    'server/main.lua',
    'server/gps.lua',
    'server/vehicles.lua',
    'server/nui.lua',
}

dependencies {
    'es_extended',
    'esx_society',
    'esx_addonaccount',
    'oxmysql',
    'ox_lib',
    'ox_target',
    'okokBossMenu',
}
