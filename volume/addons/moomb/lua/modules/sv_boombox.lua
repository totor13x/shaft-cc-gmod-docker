netstream.Hook('TTS:Boombox.Play', function(ply, track_id)
  TTS.HTTP(
    '/api/server/track/' .. track_id .. '/play',
    {
      user_id = ply:GetUserID()
    },
    function(data)
	-- PrintTable(data)
	  local uri = {}
      ply:SetNWString("TTS::BoomboxAuthor", 
        (data.info.track_author or 'No') 
        .. ' - ' ..
        (data.info.track_name or 'No')
      )
      ply:SetNWString("TTS::BoomboxPly", data.info.user.username .. ' (' .. data.info.user.steamid32 ..')')
	  
	  if ply:GetInfoNum("avoid_boombox_play", 0) != 0 then return false end
	  
	  for i,v in pairs(player.GetAll()) do
		  if v:GetInfoNum("avoid_boombox_play", 0) == 0  then
			table.insert(uri, v)
		  end
	  end
	  
      netstream.Start(uri, 'TTS:Boombox.Play', {
        url = data.url,
        ply = ply
      })
      ply:SetNWFloat('TTS::BoomboxVolume', 1)
    end
    )
end)

netstream.Hook('TTS:Boombox.Pause', function(ply, track_id)
  netstream.Start(_, 'TTS:Boombox.Pause', ply)
end)
netstream.Hook('TTS:Boombox.Resume', function(ply, track_id)
  netstream.Start(_, 'TTS:Boombox.Resume', ply)
end)

local volumes = {
  [1] = 1,
  [2] = 0.75,
  [3] = 0.50,
  [4] = 0.25
}

netstream.Hook('TTS:Boombox.Volume', function(ply)
  local volume_now = ply:GetNWFloat('TTS::BoomboxVolume')
  local updated = false
  for i, v in pairs(volumes) do
    -- print(volume_now, v)
    if volume_now > v then
      ply:SetNWFloat('TTS::BoomboxVolume', v)
      updated = true
      break
    end
  end

  if !updated then
    ply:SetNWFloat('TTS::BoomboxVolume', 1)
  end
end)
-- netstream.Start('TTS:Boombox.Volume')
if TTS.DEBUG then
	concommand.Add('test_boombox', function(ply)
	  ply:Give('weapon_boombox')
	end)
end
-- RunConsoleCommand('sv_cheats', 1)