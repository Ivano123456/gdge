client_script '@jamaica-pedovi/src/include/client.lua'


fx_version 'cerulean'
lua54 'yes'
game "gta5"

author 'tstudio - turbosaif, johanni'
description 'Pearls Resort by TStudio'
version '1.0.0'

this_is_a_map "yes"

dependencies { 
    '/server:4960',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 4960.
    '/gameBuild:2545',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2545.
    'tstudio_zmapdata',  -- ⚠️PLEASE READ⚠️; Requires to be started before this resource.
}

data_file 'WATER_FILE' 'water.xml'
data_file 'GTXD_PARENTING_DATA' 'data/gtxd.meta'


files {
    'pearls_resort_ext_tc.xml',
    'data/gtxd.meta',
    'water.xml'
}

client_scripts {
  'config.lua',
  'client/*.lua',
}

escrow_ignore {
  'stream/vanilla/*.*',
  'stream/ytd/*.ytd',
  'config.lua',
  'water.xml'
}
dependency '/assetpacks'