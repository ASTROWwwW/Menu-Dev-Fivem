fx_version 'adamant'
game 'gta5'

description 'devtool'

client_scripts {
    '@NativeUI/NativeUI.lua',
    '@es_extended/locale.lua',
    'dev_menu.lua',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server.lua'
}


