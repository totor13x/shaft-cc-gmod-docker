
 
HoolDon = HoolDon or {}                                                                                                                  
timer.Simple(2, function()
	hook.Remove('PlayerTick', 'TickWidgets')
end)    
  
netstream.Hook('/auth/client', function(data)       
	HoolDon = data   
	TTS.User = data
  hook.Run("TTS.InitialWS", HoolDon)   
	hook.Run("TTS.PlayerInitialSpawn")   
end)  