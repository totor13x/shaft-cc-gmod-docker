-- if true then return end
-- !mute Toto 60 1.2 123 123
TTS.Admin.commands.Register( 'mute' )
:SetDescription('Mute')
:SetRequiredAttrs({ 'player', 'length', 'idrule' })
:SetOptionalAttrs({ 'reason' })
:SetLogType('mute', ':user_id-0 выдал мут :user_id-1 на :length :idrule (:reason)')
:SetPermissions({ 'ap-locks', 'mute' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' выдал мут ',
    '%str',
    ' на ',
    '%length',
	' ',
    '%idrule',
	' ',
    '%reason'
  },{
    '%str',
    ' выдала мут ',
    '%str',
    ' на ',
    '%length',
	' ',
    '%idrule',
	' ',
    '%reason'
  }
})
:Execute(function(caller, target, length, idrule, reason)
  -- print(target)
  -- PrintTable(idrule)

  -- print(caller, target, length, idrule, reason)
  TTS.Admin.Methods.GiveLock('mute', caller, target, length, idrule, reason)
  return true
end)

if true then return end

TTS.Admin.commands.Register( 'unmute' )
:SetDescription('Unmute')
:SetRequiredAttrs({ 'player' })
:SetOptionalAttrs({ 'reason' })
:SetLogType('unmute', ':user_id-0 cнял мут с :user_id-1 (:reason)')
:SetPermissions({ 'ap-locks', 'mute' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' cнял мут с ',
    '%str',
    '%reason'
  },{
    '%str',
    ' cняла мут с ',
    '%str',
    '%reason'
  }
})
:Execute(function(caller, target, length, reason)
  -- print(target)
  -- PrintTable(second_target)
  print(caller, target, length, reason)
end)
