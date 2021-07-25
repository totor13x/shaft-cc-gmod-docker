
TTS.Admin.commands.Register( 'god' )
:SetDescription('god')
:SetOptionalAttrs({ 'players' })
:SetLogType('god', ':user_id-0 установил режим бога :user_ids')
:SetPermissions({ 'god' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' установил режим бога ',
    '%str',
  },{
    '%str',
    ' установила режим бога ',
    '%str',
  }
})
:Execute(function(caller, targets)
  if targets and #targets > 0 then
    for _, target in pairs(targets) do
      target:GodEnable()
    end
  else 
    caller:GodEnable()
  end

  return true
  -- print(target)
  -- PrintTable(second_target)
  -- print(caller, target, length, reason)
end)

TTS.Admin.commands.Register( 'ungod' )
:SetDescription('ungod')
:SetOptionalAttrs({ 'players' })
:SetLogType('ungod', ':user_id-0 выключил режим бога :user_ids')
:SetPermissions({ 'god' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' выключил режим бога ',
    '%str',
  },{
    '%str',
    ' выключила режим бога ',
    '%str',
  }
})
:Execute(function(caller, targets)
  -- print(targets, targets and #targets, caller)
  if targets and #targets > 0 then
    for _, target in pairs(targets) do
      target:GodEnable()
    end
  else 
    caller:GodEnable()
  end

  return true
  -- print(target)
  -- PrintTable(second_target)
  -- print(caller, target, length, reason)
end)
