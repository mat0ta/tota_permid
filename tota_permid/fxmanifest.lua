fx_version 'bodacious'
game 'gta5'

client_scripts {
  'client.lua'
}

server_scripts {
  'server.lua',
  '@mysql-async/lib/MySQL.lua'
}

shared_scripts {
  'config.lua'
}