fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'BrunX Mods'
description 'BrunX Mods'
version '1.0.0'

this_is_a_map "yes"

data_file 'AUDIO_GAMEDATA' 'audio/brnx_courthouse_int.dat'

files {
    'interiorproxies.meta',
	'audio/brnx_courthouse_int.dat151.rel',
    'stream/*'
}

dependencies {
    'brnx_bridge'
}

escrow_ignore {
    'stream/textures/*.ytd',
	'stream/vanilla/ybn/*.ybn',
	'stream/vanilla/ydr/*.ydr',
    "gift.png",
    "InstallationGuide.pdf",	
	'stream/metadata/*.ymap'
}
dependency '/assetpacks'