if true then return end
-- timer.Simple(10, function()
  require "voicehook"
  require 'vlog'

  local WhoSaying = {}

  hook.Add('BroadcastVoiceData', 'TTS.Logs::VoiceHook/Broadcast', function(userid, len)
    if !WhoSaying[userid] then


      local pl = Entity(userid + 1)
      -- print(pl.m_is_gag)
      if pl.m_is_gag then
        return
      end

      voicehook.Start(pl)

      WhoSaying[userid] = {
        count = 0,
        time = os.time()
      }
    end
    
    WhoSaying[userid].count = 0
  end)


  hook.Add('VoiceHookFile', 'TTS.Logs::VoiceHook/File', function(userid, steamid)
    local pl = Entity(userid)
    local tim = pl.VoiceHookTime or os.time()

    local saveFile = 'voicehook/' .. steamid .. '-' .. tim .. '.dat' 

    local fi = file.Rename(
      'voicehook/' .. userid .. '.dat',
      saveFile
    )
    
    TTS.HTTP('/api/server/voice/receive', {
      data = util.Base64Encode(file.Read( saveFile, "DATA" )),
      steamid = steamid,
      time = tim
    }, function(data) 
      print(data)
    end)

  end)

  hook.Add('Tick', 'TTS.Logs::VoiceHook/Tick', function()
    for i, v in pairs(WhoSaying) do
      if v.count > 60 then
        local pl = Entity(i + 1)

        pl.VoiceHookTime = v.time
        voicehook.End(pl)
        
        WhoSaying[i] = nil
        
        return
      end
    
      WhoSaying[i].count = WhoSaying[i].count + 1
    end
  end)
-- end)