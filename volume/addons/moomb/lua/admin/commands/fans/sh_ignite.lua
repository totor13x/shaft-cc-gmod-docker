
TTS.Admin.commands.Register( 'ignite' )
:SetDescription('ignite')
:SetRequiredAttrs({ 'players' })
:SetLogType('ignite', ':user_id-0 поджег :user_ids')
:SetPermissions({ 'ignite' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' поджег ',
    '%str',
  },{
    '%str',
    ' подожгла ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if not target:Alive() then continue end

    target:Ignite(99999999)
  end
  
  return true
end)

TTS.Admin.commands.Register( 'unignite' )
:SetDescription('unignite')
:SetRequiredAttrs({ 'players' })
:SetLogType('unignite', ':user_id-0 потушил огонь :user_ids')
:SetPermissions({ 'ignite' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' потушил огонь ',
    '%str',
  },{
    '%str',
    ' потушила огонь ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if not target:Alive() then continue end

    target:Extinguish()
  end

  return true
end)