TTS.Admin.LocalPerms = {}
TTS.Admin.LocalRoles = {}

netstream.Hook('WS:Permissions/List', function(perms) 
  TTS.Admin.LocalPerms = perms
end)
netstream.Hook('WS:Roles/List', function(roles) 
  TTS.Admin.LocalRoles = roles
end)