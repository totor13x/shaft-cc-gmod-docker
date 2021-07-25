hook.Add('TTS.PlayerInitialSpawn', 'TTS.MuteLocksPlayerSpawn', function(ply)
  if ply.TTS then
    local data = ply.TTS.Data
    
    for _, lock in pairs(data.locks) do
      if lock.type == 'mute' then
        ply.m_is_muted = true
        if lock.length == 0 then continue end
        local cooldown = tonumber(lock.locked_at_unix) + lock.length
        -- print(, os.time())
        print(tonumber(lock.locked_at_unix) + lock.length - os.time())
        if (cooldown - os.time()) < 60*24 then
          timer.Simple(cooldown - os.time(), function()
            if IsValid(ply) then
              ply.m_is_muted = false
            end
          end)
        end
      end
    end
  end
end)

hook.Add("PlayerSay", "TTS.MuteLocksPlayerSay", function( ply, text )
  if ply.m_is_muted then
    return ""
  end
end, 10)
-- print('123')


hook.Add('TTS.Admin::RefreshLocks', 'TTS.Admin.Locks::ReceiveMute', function(ply, locks)
	print('mute', ply, locks)
	if locks and locks.mute then
		ply.m_is_muted = true
        if locks.mute.length == 0 then return end
		
		local cooldown = tonumber(locks.mute.locked_at_unix) + locks.mute.length
		if (cooldown - os.time()) < 60*24 then
          timer.Simple(cooldown - os.time(), function()
            if IsValid(ply) then
              ply.m_is_muted = false
            end
          end)
        end
	end 
end)