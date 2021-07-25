hook.Add('TTS.PlayerInitialSpawn', 'TTS.GagLocksPlayerSpawn', function(ply)
  if ply.TTS then
    local data = ply.TTS.Data
    
    for _, lock in pairs(data.locks) do
      if lock.type == 'gag' then
        ply.m_is_gag = true
        if lock.length == 0 then continue end
        local cooldown = tonumber(lock.locked_at_unix) + lock.length
        -- print(, os.time())
        -- print(tonumber(lock.locked_at_unix) + lock.length - os.time())
        if (cooldown - os.time()) < 60*24 then
          timer.Simple(cooldown - os.time(), function()
            if IsValid(ply) then
              ply.m_is_gag = false
            end
          end)
        end
      end
    end
  end
end)

hook.Add("PlayerCanHearPlayersVoice", "TTS.GagLocksPlayerSay", function( listener, talker )
  if talker.m_is_gag then
    return false
  end
end, 10)


hook.Add('TTS.Admin::RefreshLocks', 'TTS.Admin.Locks::ReceiveGag', function(ply, locks)
	if locks and locks.gag then
		ply.m_is_gag = true
        if locks.gag.length == 0 then return end
		
		local cooldown = tonumber(locks.gag.locked_at_unix) + locks.gag.length
		if (cooldown - os.time()) < 60*24 then
          timer.Simple(cooldown - os.time(), function()
            if IsValid(ply) then
              ply.m_is_gag = false
            end
          end)
        end
	end 
end)