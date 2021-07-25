

TTS.Admin.commands.Register( 'cleardecals' )
:SetDescription('cleardecals')
:SetLogType('cleardecals', ':user_id-0 убрал все декали')
:SetPermissions({ 'cleardecals' })
:SetDeclinatio({ 
  {
    '%str',
    ' убрал все декали',
  },{
    '%str',
    ' убрал все декали',
  }
})
:Execute(function(caller)
  -- print(target)
  -- PrintTable(second_target)
  -- print(caller, target, length, reason)
  netstream.Start(nil, "sgClearDecals", 1)
  
  return true
end)

if (CLIENT) then
	netstream.Hook("sgClearDecals", function(data)
		LocalPlayer():ConCommand("r_cleardecals", true)
	end)
end