
TTS.Admin.commands.Register( 'announce' )
:SetDescription('announce')
:SetRequiredAttrs({ 'text' })
:SetLogType('announce', ':user_id-0 анонсит :text')
:SetPermissions({ 'announce' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' анонсит ',
    '%str',
  },{
    '%str',
    ' анонсит ',
    '%str',
  }
})
:Execute(function(caller, targets)
  return true
end)