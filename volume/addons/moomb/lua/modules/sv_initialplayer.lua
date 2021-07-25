if WS.Bus.UserController then
	WS:unsubscribe('users') 
end
 
WS.Bus.UserController = WS:subscribe('users')
WS.Bus.UserController:on('getInfo', function(data)
	PrintTable(data) 
	if data.steamid then
		local ply = player.GetBySteamID64(data.steamid)

		ply.TTS = {}
		ply.TTS.Data = data

		ply:SetUserID(data.id)

		netstream.Start(ply, '/auth/client', {
			ply = data,
			server = TTS.Config.Server.id,
			server_name = TTS.Config.Server.beautiful_name
		})
		
		hook.Run("TTS.PlayerInitialSpawn", ply)
	end
end)   

hook.Add('PlayerDisconnected', "TTS.PlayerDisconnectedUser", function(ply)
	RemoveUserID(ply:GetUserID())
end)

hook.Add('PlayerInitialSpawn', "TTS.InitializeUser", function(ply)
	WS.Bus.UserController:emit('getInfo', {
		steamid = ply:SteamID64(),
		username = ply:Nick()
	})
end)
if TTS.DEBUG then
  timer.Simple(1, function()
    local ply = Entity(1)   
    WS.Bus.UserController:emit('getInfo', { 
      steamid = ply:SteamID64(),
      username = ply:Nick()
    })
  end) 
end 