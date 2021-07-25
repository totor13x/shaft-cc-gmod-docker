-- TODO: Sdelat invisible, a toka vikluchil
if true then
  return
end

TTS.Admin.commands.Register( 'invisible' )
:SetDescription('invisible')
:SetRequiredAttrs({ 'players' })
:SetLogType('invisible', ':user_id-0 наложил эффект невидимости :user_ids')
:SetPermissions({ 'invisible' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' наложил эффект невидимости ',
    '%str',
  },{
    '%str',
    ' наложила эффект невидимости ',
    '%str',
  }
})
:Execute(function(caller, target, length, reason)
  -- print(target)
  -- PrintTable(second_target)
  print(caller, target, length, reason)
end)

TTS.Admin.commands.Register( 'uninvisible' )
:SetDescription('uninvisible')
:SetRequiredAttrs({ 'players' })
:SetLogType('uninvisible', ':user_id-0 снял эффект невидимости :user_ids')
:SetPermissions({ 'invisible' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' снял эффект невидимости ',
    '%str',
  },{
    '%str',
    ' сняла эффект невидимости ',
    '%str',
  }
})
:Execute(function(caller, target, length, reason)
  -- print(target)
  -- PrintTable(second_target)
  print(caller, target, length, reason)
end)
