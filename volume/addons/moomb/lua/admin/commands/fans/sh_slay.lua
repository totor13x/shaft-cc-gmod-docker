
TTS.Admin.commands.Register( 'slay' )
:SetDescription('slay')
:SetRequiredAttrs({ 'players' })
:SetLogType('slay', ':user_id-0 убил :user_ids')
:SetPermissions({ 'slay' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' убил ',
    '%str',
  },{
    '%str',
    ' убила ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if target:Alive() then
      target:Kill()
    end
  end

  return true
end)