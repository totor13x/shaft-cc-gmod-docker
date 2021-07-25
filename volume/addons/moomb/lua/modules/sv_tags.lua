hook.Add("TTS.PlayerInitialSpawn", "TTS:InitTag", function(ply)
	if ply.TTS then
		local data = ply.TTS.Data
		if data.tag_id then
			ply:SetNWString('tag_id', data.tag_id)
		end
		netstream.Start(ply, 'TTS:TagsPly', data.tags)
	end
end)
-- print('asd')
netstream.Hook('TTS.ChangeTag', function(ply, tagId)
	if ply.TTS then
		print(ply, tagId)
		WS.Bus.UserController:emit('changeTag', {
			user_id = ply:GetUserID(),
			tag_id = tagId,
		})
	end
end)

WS.Bus.UserController:on('refreshTag', function(data)
	local ply = UserIDToPlayer(data.user_id)           
	if IsValid(ply) then
		-- local data = ply.TTS.Data
		-- if data.tag_id then
		ply:SetNWString('tag_id', data.tag_id)
		-- end
	end
end)