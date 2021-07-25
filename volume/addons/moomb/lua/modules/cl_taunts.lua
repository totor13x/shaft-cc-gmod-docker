
TTSTaunts = TTSTaunts or {}

netstream.Hook("TTS::PlayTaunt", function(ply, link)
-- print(ply, link)
	//local is3d = ply == LocalPlayer() and true or false
	sound.PlayURL ( link, "3d", function( station )
		if ( IsValid( station ) ) then
			if IsValid(TTSTaunts[ply]) then
				TTSTaunts[ply]:Pause()
			end
			
			station:SetPos( ply:GetPos() )
			station:Set3DFadeDistance( 300, 750 )
			station:Play()

			TTSTaunts[ply] = station
		end
	end) 
	
end )

hook.Add("Think", "TTSTaunts::Think", function()
	for ply, station in pairs(TTSTaunts) do
		if IsValid(ply) and IsValid(station) then
			-- if not ply:Alive() then
				-- station:Pause()
				-- continue
			-- end
			
			local eyepos = ply:EyePos()
			local EyePosLocal = LocalPlayer() == ply and eyepos or LocalPlayer():EyePos()
			local pos = station:GetPos()
			local in3D = LocalPlayer() == ply and ply:ShouldDrawLocalPlayer() or true
			
			if in3D then
				if not station:Get3DEnabled() then
					station:Set3DEnabled( true )
				end
				if EyePosLocal:DistToSqr( eyepos ) < 100 then
					station:Set3DEnabled( false )
				end
			else
				if station:Get3DEnabled() then
					station:Set3DEnabled( false )  
				end
			end
			
			station:SetPos(eyepos)
			if EyePosLocal:DistToSqr( eyepos ) > 750*750 then
				if station:GetVolume() ~= 0 then
					station:SetVolume(0)
				end
			else
				if station:GetVolume() ~= 1 then
					station:SetVolume(1)
				end
			end
		else
			TTSTaunts[ply] = nil
			station:Stop()
		end
	end
end)