server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
author 'pScripts [tebex.pscripts.store]'
description 'Most Advanced DOJ MDT System'
version '1.1.2'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/config.citizens.lua',
    'shared/config.reports.lua',
    'shared/config.courts.lua',
    'shared/config.employees.lua',
    'shared/config.taxes.lua',
}

client_scripts {
    'client/*.lua',
    'client/pages/*.lua',
    'client/bridge/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/pages/*.lua',
    'server/bridge/*.lua',
    'server/banking/*.lua',
    'shared/config.logs.lua',
}

ui_page 'web/build/index.html'

files {
    'locales/*.json',
	'web/build/index.html',
	'web/build/**/*',
    'web/assets/**/*',
}

escrow_ignore {
    'server/pages/finances.lua',
    'shared/config.lua',
    'shared/config.citizens.lua',
    'shared/config.reports.lua',
    'shared/config.courts.lua',
    'shared/config.employees.lua',
    'shared/config.taxes.lua',
    'shared/config.logs.lua',
    'server/editable_functions.lua',
    'client/editable_functions.lua',
    'client/bridge/esx.lua',
    'client/bridge/qb.lua',
    'client/bridge/qbox.lua',
    'server/bridge/esx.lua',
    'server/bridge/qb.lua',
    'server/bridge/qbox.lua',
    'server/banking/*.lua',
}
dependency '/assetpacks'