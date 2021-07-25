
TTS.Admin.commands.Register( 'give' )
:SetDescription('give')
:SetRequiredAttrs({ 'players', 'text' })
:SetLogType('give', ':user_id-0 выдал :user_ids :text')
:SetPermissions({ 'give' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' выдал ',
    '%str',
    ' ',
    '%str',
  },{
    '%str',
    ' выдала ',
    '%str',
    ' ',
    '%str',
  }
})
:Execute(function(caller, targets, wep)
  for _, target in pairs(targets) do
    if not target:Alive() then continue end

    target:Give(wep)
  end

  return true
end)

TTS.Admin.commands.Register( 'strip' )
:SetDescription('strip')
:SetRequiredAttrs({ 'players' })
:SetLogType('strip', ':user_id-0 отобрал все оружия :user_ids')
:SetPermissions({ 'strip' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' отобрал все оружия ',
    '%str',
  },{
    '%str',
    ' отобрала все оружия ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if not target:Alive() then continue end

    target:StripWeapons()
  end

  return true
end)