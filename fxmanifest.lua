fx_version 'cerulean'
game 'gta5'

name "A Simple Redzone Script"
author "Made with love by Samuel#0008"
Version "1.0.0"

client_scripts {
	'client/main.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    'bridge/server.lua',
	'server/main.lua',
}

lua54 'yes'