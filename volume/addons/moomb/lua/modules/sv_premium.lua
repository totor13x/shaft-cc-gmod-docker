hook.Add("TTS.PlayerInitialSpawn", "InitPremium", function(ply)
	if ply.TTS then
		local data = ply.TTS.Data
		-- print('premium_at', data.premium_at)
		-- print('is_premium', data.is_premium)
		ply:SetNWBool('is_premium', data.is_premium)
		
		if data.is_premium then
			local cooldown = tonumber(data.premium_at)
		-- print('is_premium',type(cooldown), os.time(), (cooldown - os.time()))
			if (cooldown - os.time()) < 60*24 then
				timer.Simple(cooldown - os.time(), function()
					if IsValid(ply) then
						ply:SetNWBool('is_premium', false)
					end
				end)
			end
		end
	end
end)

WS.Bus.UserController:on('refreshPremium', function(data)
	local ply = UserIDToPlayer(data.user_id)           
	if IsValid(ply) then
		ply:SetNWBool('is_premium', data.is_premium)
		
		if data.is_premium then
			local cooldown = tonumber(data.premium_at)
			if (cooldown - os.time()) < 60*24 then
				timer.Simple(cooldown - os.time(), function()
					if IsValid(ply) then
						ply:SetNWBool('is_premium', false)
					end
				end)
			end
		end
	end
end)