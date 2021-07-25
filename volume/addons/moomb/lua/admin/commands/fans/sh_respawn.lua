
TTS.Admin.commands.Register( 'respawn' )
:SetDescription('Respawn')
:SetOptionalAttrs({ 'player' })
:SetLogType('respawn', ':user_id-0 возродил/-cя :user_id-1')
:SetPermissions({ 'respawn' })
:SetSingleTarget( true )
:SetDeclinatio(function(caller, target)
  -- print(caller, target, '-declianto')
  if target ~= nil then
    return { 
      {
        '%str',
        ' возродил ',
        '%str',
      },{
        '%str',
        ' возродила ',
        '%str',
      }
    }
  else
    return { 
      {
        '%str',
        ' возродилcя',
      },{
        '%str',
        ' возродилаcь',
      }
    }
  end
end)
:Execute(function(caller, target)
  if !IsValid(target) then
    target = caller
  end

  target:Spawn();

	-- Needed for TTT.
	if (target.SpawnForRound) then
		target:SpawnForRound()

		if (IsValid(target.server_ragdoll)) then
			target.server_ragdoll:Remove()
		end
	end

	return true
end)