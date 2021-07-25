TTS.Admin.commands.Register( 'ban' )
:SetDescription('Ban')
:SetRequiredAttrs({ 'player', 'length', 'idrule' })
:SetOptionalAttrs({ 'reason' })
:SetLogType('ban', ':user_id-0 выдал бан :user_id-1 на :length :idrule (:reason)')
:SetPermissions({ 'ap-locks', 'ban' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' выдал бан ',
    '%str',
    ' на ',
    '%length',
	' ',
    '%idrule',
	' ',
    '%reason'
  },{
    '%str',
    ' выдала бан ',
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
    TTS.Admin.Methods.GiveLock('ban', caller, target, length, idrule, reason)
	return true
end)
