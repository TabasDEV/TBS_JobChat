fx_version 'cerulean'

game 'gta5'

description 'QbCore alert system by tbs'

version '1.0.0'

files {
}

server_script "server.lua"
client_script "client.lua"

server_scripts {

    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
  
  }