fx_version "cerulean"
game "gta5"
lua54 "yes"
this_is_a_map 'yes'

author "17movement"
description "Multiplayer scrapyard job script for FiveM"
version "1.0.5"

server_scripts {
    "server/main.lua",
     "server/conflictFinder.js",
}

client_scripts {
    "shared/locale.lua",
    "shared/lang.lua",
    "locale/*.lua",
    "Config.lua",
    "shared/VehicleConfig.lua",
    "shared/core.lua",
    "shared/PolyZone.lua",
    "client/core.lua",
    "client/Vehicle.lua",
    "client/Lift.lua",
    "client/main.lua",
    "client/functions.lua",
    "client/target.lua",
    "client/crusher.lua",
    "client/PathFind.lua",
}

escrow_ignore {
    "Config.lua",
    "locale/*.lua",
    "server/functions.lua",
    "client/functions.lua",
    "client/target.lua",
    "server/main.lua"
}

ui_page "web/index.html"

files {
    "web/index.html",
    "web/assets/**/*.*",
    "stream/vehicles/**/**.meta",
    'data/17mov_scrapyard.dat54.rel',
    'audiodirectory/17mov_scrapyard.awc',
}

data_file 'HANDLING_FILE'            'stream/vehicles/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE'    'stream/vehicles/**/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE'   'stream/vehicles/**/carvariations.meta'

data_file 'AUDIO_WAVEPACK'  'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/17mov_scrapyard.dat'

data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_scrapyard_ytyp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_scrapyard_hq_ytyp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_scrapyard_garage_ytyp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_scrapyard_cars.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_rebel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_tornado.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_emperor.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_weevil.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/YTYP/17mov_cheburek.ytyp'

dependency '/assetpacks'
