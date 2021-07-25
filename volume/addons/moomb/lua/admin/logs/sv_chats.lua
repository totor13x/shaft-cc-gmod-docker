hook.Add('PlayerSay', 'TTS.ChatLog', function(ply, text, team)
    WS.Bus.LogsController:emit('test', {                             
        type = 'game_chat',  
        attrs = {
            user_ids = ply:GetUserID(),
            text = text,
            team = team and '[TEAM]' or ' '
        }
	})
end)