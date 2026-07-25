server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.6.8'
use_experimental_fxv2_oal 'yes'
escrow_ignore {
    'client/*.lua',
    'server/*.lua',
    'shared/*.lua',
    'locales/*.lua',
    'client/core.lua',
    'server/core.lua',
    'customs/*.lua',
    'stream/**'
}
shared_scripts {
    'shared/cores.lua',
    'shared/config.lua',
    'shared/animation-list-ar.lua',
    'shared/animation-list-br.lua',
    'shared/animation-list-cs.lua',
	'shared/animation-list-de.lua',
    'shared/animation-list-en.lua',
    'shared/animation-list-es.lua',
    'shared/animation-list-fr.lua',
    'shared/animation-list-it.lua',
    'shared/animation-list-pt.lua',
    'shared/animation-list-tr.lua',
    'customs/*.lua',
    'locales/*.lua',
}
client_scripts {
	'client/*.lua'
}
server_scripts {
    'server/main.js',
    'server/*.lua'
}
ui_page 'html/index.html'
files {'html/**', 'assets/**/*.png'}
dependency '/assetpacks'