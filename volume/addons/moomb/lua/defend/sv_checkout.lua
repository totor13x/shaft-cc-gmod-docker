
hook.Add("TTS.PlayerInitialSpawn", "TTS::CheckFamilySharing", function(ply)
	if ply:IsBot() then return end
	-- print(ply:GetPData("notfamilysharing"))
	-- if ply:GetPData("notfamilysharing") == "true" then return end

	local ply64 = ply:SteamID64()
	local RadioUrlStreams = "https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v1?key=70449E6E69DAA578D83622AA05A8CD29&steamid="..ply64.."&appid_playing=4000"
	http.Fetch(RadioUrlStreams,
	function( body, len, headers, code )
		if IsValid(ply) then
		local listofskyp = util.JSONToTable(body)
		local owner = listofskyp["response"]["lender_steamid"] 
		-- print(owner)
		if owner ~= '0' then
			-- TTS.Fetch("bans.ImportQuoteData", {
				-- sid = ply:SteamID(),
				-- type = '1',
				-- data = util.TableToJSON({[owner] = true}),
			-- })
			
			ply.IsFamilySharing = true
			return
		end
		ply:SetPData("notfamilysharing","true")
		end
	end)
end)

netstream.Hook("TTS::SendQuoteTime", function(ply, data)

	-- TTS.Fetch("bans.ImportQuoteData", {
		-- sid = ply:SteamID(),
		-- type = '2',
		-- data = util.TableToJSON(array),
	-- })
	if ply.IsFamilySharing then
		local text =[[Доступ к серверу аккаунтам с не купленным Garry`s mod ограничен]]
		ply:Kick(text)
	end
	-- //end
	-- //print("------------------")
	-- //print(ply)
	-- //PrintTable(data)
end)
