

lua54 'yes'

fx_version 'cerulean'
game 'gta5'
author 'Gabz'
description 'Prison'
version '1.0.0'
lua54 'yes'
this_is_a_map 'yes'

dependencies {
    '/server:4960',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 4960.
    '/gameBuild:2545',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2545.
}

escrow_ignore {
    'stream/**/*.ytd',
    'prison.lua',
}
dependency '/assetpacks'