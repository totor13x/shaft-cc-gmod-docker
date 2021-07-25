
TTS.Admin.commands.Register( 'kick' )
:SetDescription('Kick')
:SetRequiredAttrs({ 'player' })
:SetOptionalAttrs({ 'reason' })
:SetLogType('kick', ':user_id-0 кикнул :user_id-1 (:reason)')
:SetPermissions({ 'ap-locks', 'kick' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' кикнул ',
    '%str',
    '%reason'
  },{
    '%str',
    ' кикнула ',
    '%str',
    '%reason'
  }
})
:Execute(function(caller, target, reason)
  if IsValid(target) then
    if string.Trim(reason) == '' then
      reason = 'Причина не задана'
    end

    RunConsoleCommand('kickid', target:UserID(), reason)
  end
end)
