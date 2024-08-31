fx_version 'cerulean'
game 'gta5'

author 'chriis'
description 'Spectate Menu by Atlanta Scripts'
version '1.0.0'
lua54 'yes'
shared_scripts {
	"@es_extended/imports.lua",
    '@ox_lib/init.lua',
	"config.lua",
}

client_script 'client.lua'
server_script 'server.lua'


ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/img/*',
}
