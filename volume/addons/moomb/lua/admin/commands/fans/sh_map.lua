-- TODO: NEDOPISANO
TTS.Admin.commands.Register( 'map' )
:SetDescription('map')
:SetRequiredAttrs({ 'text' })
:SetLogType('map', ':user_id-0 cменил карту на :text')
:SetPermissions({ 'map' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' сменил карту на ',
    '%str',
  },{
    '%str',
    ' сменил карту на ',
    '%str',
  }
})
:Execute(function(caller, map)
  RunConsoleCommand('changelevel', string.lower(map))

  timer.Simple(0.2, function()
    if IsValid(caller) then
      TTS.Admin:Msg(caller, {  
        { 'Карта ' },
        { map, Color(94, 130, 158) },
        { ' не найдена' },
      })
    end
  end)
  -- print(target)
  -- PrintTable(second_target)
  -- print(caller, target, length, reason)
  return true
end)

local timerInterval
local secsOld
TTS.Admin.commands.Register( 'maprestart' )
:SetDescription('maprestart')
:SetOptionalAttrs({ 'number' })
:SetLogType('maprestart', ':user_id-0 перезапустил карту (:number)')
:SetPermissions({ 'map' })
:SetDeclinatio({ 
  {
    '%str',
    ' перезапустил карту ',
    '%reason',
  },{
    '%str',
    ' перезапустила карту ',
    '%reason',
  }
})
:Execute(function(caller, secs)
  secs = secs or 0
  secsOld = secs
  if secs == 0 then
		RunConsoleCommand("changelevel", game.GetMap());
  else
    timer.Create("MaprestartBb", 1, secs, function()
      secsOld = secsOld - 1

      TTS.Admin:Msg(_, {  
        { 'Перезапуск карты через ' },
        { TTS.Libs.Interface.sec2MinNearTo(secsOld, true), Color(94, 130, 158) },
        { '.' }, 
      })
      
      if secsOld == 0 then
        RunConsoleCommand("changelevel", game.GetMap());
      end
    end)
  end
  
  return true
end)

-- TTS.Admin.commands.Register( 'stopmaprestart' )
-- :SetDescription('stopmaprestart')
-- :SetLogType('maprestart', ':user_id-0 остановил перезапуск карты')
-- :SetPermissions({ 'ban' })
-- :SetDeclinatio({ 
--   {
--     '%str',
--     ' остановил перезапуск карты',
--   },{
--     '%str',
--     ' остановила перезапуск карты',
--   }
-- })
-- :Execute(function(caller, secs)
  
-- end)