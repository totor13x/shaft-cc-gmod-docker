
TTS.Admin.commands.Register( 'hp' )
:SetDescription('hp')
:SetRequiredAttrs({ 'players', 'number' })
:SetLogType('hp', ':user_id-0 установил HP :user_id-1 на значении :number')
:SetPermissions({ 'hp' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' установил HP ',
    '%str',
    ' на значении ',
    '%str',
  },{
    '%str',
    ' установила HP ',
    '%str',
    ' на значении ',
    '%str',
  }
})
:Execute(function(caller, targets, hp)
  if hp == 0 then
    TTS.Admin:Msg(caller, {  
      { 'Значение HP не должно равняться 0' },
    })
    return false
  end
  for _, target in pairs(targets) do
    target:SetHealth(hp)
  end
  -- if 
  -- print(target)
  -- PrintTable(second_target)
  print(caller, targets, hp)
  return true
end)