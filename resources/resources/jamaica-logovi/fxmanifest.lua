





fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jamaica-logovi'
description 'Discord bot logovi — kanali, queue, ESX događaji'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
}

server_scripts {
    'server/discord_config.lua',
    'server/discord.lua',
    'server/players.lua',
    'server/channels.lua',
    'server/queue.lua',
    'server/main.lua',
    'server/setup.lua',
    'server/bot_launcher.lua',
    'server/listeners/connection.lua',
    'server/listeners/death.lua',
    'server/listeners/droga.lua',
    'server/listeners/organizacije.lua',
    'server/listeners/sluzbe.lua',
    'server/listeners/pranje.lua',
    'server/listeners/babica.lua',
    'server/listeners/pljacke.lua',
    'server/listeners/inventar.lua',
    'server/listeners/supply_drop.lua',
    'server/listeners/automafija.lua',
    'server/listeners/autopijaca.lua',
}

dependencies {
    'es_extended',
}

exports {
    'Send',
    'SendDetailed',
    'SetupChannels',
}
