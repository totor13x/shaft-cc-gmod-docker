

TTS.Admin.commands.Register( 'gag' )
:SetDescription('Gag')
:SetRequiredAttrs({ 'player', 'length', 'idrule' })
:SetOptionalAttrs({ 'reason' })
:SetLogType('gag', ':user_id-0 выдал гаг :user_id-1 на :length :idrule (:reason)')
:SetPermissions({ 'ap-locks', 'gag' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' выдал гаг ',
    '%str',
    ' на ',
    '%length',
	' ',
    '%idrule',
	' ',
    '%reason'
  },{
    '%str',
    ' выдала гаг ',
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
  -- PrintTable(second_target)
  -- print(caller, target, length, reason)
  TTS.Admin.Methods.GiveLock('gag', caller, target, length, idrule, reason)
  return true
end)

if true then return end

TTS.Admin.commands.Register( 'ungag' )
:SetDescription('Ungag')
:SetRequiredAttrs({ 'player' })
:SetOptionalAttrs({ 'reason' })
:SetLogType('ungag', ':user_id-0 cнял гаг с :user_id-1 (:reason)')
:SetPermissions({ 'ap-locks', 'gag' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' cнял гаг с ',
    '%str',
    '%reason'
  },{
    '%str',
    ' cняла гаг с ',
    '%str',
    '%reason'
  }
})
:Execute(function(caller, target, length, reason)
  -- print(target)
  -- PrintTable(second_target)
  print(caller, target, length, reason)
end)
