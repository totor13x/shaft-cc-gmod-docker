local playerSend = function(from, to, force)
  if not to:IsInWorld() and not force then return end;

	if (IsValid(from) and from:IsPlayer() and from:InVehicle()) then
		from:ExitVehicle();
	end;

	local traceTable = {};
	traceTable.start = to:GetPos();
	traceTable.filter = {to, from};
		
	for i = 1, 4, 1 do
		traceTable.endpos = to:GetPos() + Angle(0, to:EyeAngles().yaw - 180 + 90 * (i - 1), 0):Forward() * 47;
		tr = util.TraceEntity(traceTable, from);
		if !tr.Hit then
			break;
		end;
		if i == 4 and tr.Hit and !force then
			return false;
		end;
	end;
	
	local result = tr.HitPos or (force and to:GetPos()) or false;
	
	if (result and IsValid(from) and from:IsPlayer()) then
		from.sg_LastPosition = from:GetPos();
		from.sg_LastAngles = from:EyeAngles();
	end;
	
	return result;
end
TTS.Admin.playerSend = playerSend

TTS.Admin.commands.Register( 'bring' )
:SetDescription('Bring')
:SetRequiredAttrs({ 'player' })
:SetLogType('bring', ':user_id-0 телепортировал к себе :user_id-1')
:SetPermissions({ 'bring' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' телепортировал к себе ',
    '%str',
  },{
    '%str',
    ' телепортировала к себе ',
    '%str',
  }
})
:Execute(function(caller, target)
  if not target:Alive() then
    TTS.Admin:Msg(caller, {  
      { 'Этот игрок мертв' },
    })
  
		return false
  end
  if caller == target then
    TTS.Admin:Msg(caller, {  
      { 'Ты не можешь себя телепортировать к себе' },
    })
    return false
  end

  local position = playerSend(target, caller, false);
	
	if position then
		target.sg_LastPosition = target:GetPos()
		target.sg_LastAngles = target:EyeAngles()
		target:SetPos(position)

		return true
	end
end)

TTS.Admin.commands.Register( 'send' )
:SetDescription('send')
:SetRequiredAttrs({'player','player' }) 
:SetLogType('send', ':user_id-0 телепортировал :user_id-1 к :user_id-2')
:SetPermissions({ 'send' })
:SetSingleTarget({ true, true })
:SetDeclinatio({ 
  {
    '%str',
    ' телепортировал ',
    '%str',
    ' к ',
    '%str',
  },{
    '%str',
    ' телепортировала ',
    '%str',
    ' к ',
    '%str',
  }
})
:Execute(function(caller, target, targetSend)
  if targetSend == target then
    TTS.Admin:Msg(caller, {  
      { 'Ты не можешь себя телепортировать к себе' },
    })
    return false
  end

  if not target:Alive() then
    TTS.Admin:Msg(caller, {  
      { 'Игрок ' },
      { target:Nick(), Color(94, 130, 158) },
      { ' мертв' },
    })
  
		return false
	end
	
  if not targetSend:Alive() then
    TTS.Admin:Msg(caller, {  
      { 'Игрок ' },
      { targetSend:Nick(), Color(94, 130, 158) },
      { ' мертв' },
    })
  
		return false
  end
  
  local position = playerSend(target, targetSend, target:GetMoveType() == MOVETYPE_NOCLIP);
	
	if position then
		target.sg_LastPosition = target:GetPos()
		target.sg_LastAngles = target:EyeAngles()
		target:SetPos(position)

		return true
	end
end)


TTS.Admin.commands.Register( 'goto' )
:SetDescription('goto')
:SetRequiredAttrs({ 'player' })
:SetLogType('goto', ':user_id-0 телепортировался к :user_id-1')
:SetPermissions({ 'goto' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' телепортировался к ',
    '%str',
  },{
    '%str',
    ' телепортировалаcь к ',
    '%str',
  }
})
:Execute(function(caller, target)
  if not target:Alive() then
    TTS.Admin:Msg(caller, {  
      { 'Игрок ' },
      { target:Nick(), Color(94, 130, 158) },
      { ' мертв' },
    })
  
		return false
	end

  local position = playerSend(caller, target, true);
  -- print(position)
  if position then
		caller:SetPos(position);
		caller:SetEyeAngles(Angle(target:EyeAngles().pitch, target:EyeAngles().yaw, 0));
		
    return true
  else
    if caller:hasPerm('noclip') then
      caller:SetMoveType(MOVETYPE_NOCLIP)

			position = playerSend(caller, target, true);

			caller:SetPos(position);
      caller:SetEyeAngles(Angle(target:EyeAngles().pitch, target:EyeAngles().yaw, 0));

      return true
    end
  end
  -- print(target)
  -- PrintTable(second_target)
  -- print(caller, target, length, reason)
end)


TTS.Admin.commands.Register( 'tp' )
:SetDescription('tp')
:SetOptionalAttrs({ 'player' })
:SetLogType('tp', ':user_id-0 телепортировал/-cя :user_id-1')
:SetPermissions({ 'tp' })
:SetSingleTarget( true )
:SetDeclinatio(function(caller, target)
  -- print(caller, target, '-declianto')
  if target ~= nil then
    return { 
      {
        '%str',
        ' телепортировал ',
        '%str',
      },{
        '%str',
        ' телепортировала ',
        '%str',
      }
    }
  else
    return { 
      {
        '%str',
        ' телепортировался',
      },{
        '%str',
        ' телепортировалаcь',
      }
    }
  end
end)
:Execute(function(caller, target, length, reason)
  if !IsValid(target) then
    target = caller
  end

  if not target:Alive() then
    TTS.Admin:Msg(caller, {  
      { 'Игрок ' },
      { target:Nick(), Color(94, 130, 158) },
      { ' мертв' },
    })
  
		return false
	end

	local t = {}
	t.start = caller:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
	t.endpos = caller:GetPos() + caller:EyeAngles():Forward() * 16384
	t.filter = target
	if target ~= caller then
		t.filter = { target, caller }
	end
	local tr = util.TraceEntity( t, target )

	local pos = tr.HitPos

	if target == caller and pos:Distance( target:GetPos() ) < 64 then -- Laughable distance
		return false
  end
  
	target.sg_LastPosition = target:GetPos()
  target.sg_LastAngles = target:EyeAngles()
  
	if target:InVehicle() then
		target:ExitVehicle()
	end

	target:SetPos( pos )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
  
  return true
end)


TTS.Admin.commands.Register( 'return' )
:SetDescription('Return')
:SetRequiredAttrs({ 'player' })
:SetLogType('return', ':user_id-0 возвратил обратно :user_id-1')
:SetPermissions({ 'return', 'bring', 'send', 'goto', 'tp' })
:SetSingleTarget( true )
:SetDeclinatio({ 
  {
    '%str',
    ' возвратил обратно ',
    '%str',
  },{
    '%str',
    ' возвратил обратно ',
    '%str',
  }
})
:Execute(function(caller, target, length, reason)
  if !IsValid(target) then
    target = caller
  end

  if not target:Alive() then
    TTS.Admin:Msg(caller, {  
      { 'Игрок ' },
      { target:Nick(), Color(94, 130, 158) },
      { ' мертв' },
    })
  
		return false
  end
  
  
  if target.sg_LastPosition and target.sg_LastAngles then
    if target.sg_jail then
      TTS.Admin.UnjailPlayer(target)
    end;

    target:SetPos(target.sg_LastPosition)
    target:SetEyeAngles(Angle(target.sg_LastAngles.pitch, target.sg_LastAngles.yaw, 0))

    target.sg_LastPosition = nil
    target.sg_LastAngles = nil

    return true
  else
    TTS.Admin:Msg(caller, {  
      { 'Игрок ' },
      { target:Nick(), Color(94, 130, 158) },
      { ' не имеет предыдущей позиции' },
    })
    return false
  end
end)
