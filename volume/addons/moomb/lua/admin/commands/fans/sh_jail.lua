
local jail = {
	{Vector(0, 0, 5), Angle(90, 0, 0)}, 	-- Bottom
	{Vector(0, 0, 100), Angle(90, 0, 0)}, 	-- Top
	{Vector(0, 40, 50), Angle(0, 90, 0)}, 	-- Side
	{Vector(0, -40, 50), Angle(0, 90, 0)}, 	-- Side
	{Vector(40, 0, 50), Angle(0, 0, 0)}, 	-- Side
	{Vector(-40, 0, 50), Angle(0, 0, 0)} 	-- Side
};

local pieceModel = "models/props_c17/fence01b.mdl";

local JailPlayer = function(player, duration)
	if (IsValid(player) and isnumber(duration)) then
		local pieces = {};

		if (player:InVehicle()) then
			player:ExitVehicle();
		end;

		player:SetMoveType(MOVETYPE_WALK);
		player:SetLocalVelocity(Vector(0, 0, 0));

		for k, v in pairs(jail) do
			local piece = ents.Create("prop_physics");

			piece:SetModel(pieceModel);
			piece:SetPos(player:GetPos() + v[1]);
			piece:SetAngles(v[2]);
			piece:Spawn();
			piece:SetMoveType(MOVETYPE_NONE);
			piece:GetPhysicsObject():EnableMotion(false);
			piece.sg_jail = true;

			table.insert(pieces, piece);
		end;

		-- If one piece gets removed, remove them all.
		for i = 1, #pieces do
			local piece = pieces[i];
			local otherPiece = pieces[i - 1] or pieces[i + 1];

			piece:DeleteOnRemove(otherPiece);
			otherPiece:DeleteOnRemove(piece);
		end;

		player:SetPos(player:GetPos() + Vector(0, 0, 8));
		player:SetNetworkedBool("serverguard_jailed", true);

		player.sg_jail = pieces;
		player.sg_jailLocation = player:GetPos();
		
		if duration > 0 then
			local timerID = "serverguard.jail.timer_" .. player:UniqueID();
			player.sg_jailTime = duration;
			timer.Create(timerID, duration, 1, function()
				TTS.Admin.UnjailPlayer(player);
			end);
		end;
	end;
end;
TTS.Admin.JailPlayer = JailPlayer


local UnjailPlayer = function(player)
	if (IsValid(player) and player.sg_jail) then
		for k, v in pairs(player.sg_jail) do
			if (IsValid(v)) then
				v:Remove();
			end;
		end;

		player.sg_jail = nil;
		player.sg_jailLocation = nil;
		player.sg_jailTime = nil;
		
		local timerID = "serverguard.jail.timer_" .. player:UniqueID()
		
		if timer.Exists(timerID) then
			timer.Remove(timerID)
		end
		
		
		player:SetNetworkedBool("serverguard_jailed", false);
	else
		return false;
	end;
end;
TTS.Admin.UnjailPlayer = UnjailPlayer

TTS.Admin.commands.Register( 'jail' )
-- :SetAlias('jailbox') 
:SetDescription('123')
:SetRequiredAttrs({ 'players' })
:SetOptionalAttrs({ 'length' })
-- :SetImmunity(TI.LESSOREQUAL)
:SetLogType('jail', ':user_id-0 отправил в тюрьму :user_ids на :length')
:SetPermissions({ 'jail' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' отправил в тюрьму ',
    '%str',
    ' на ',
    '%length'
  },{
    '%str',
    ' отправила в тюрьму ',
    '%str',
    ' на ',
    '%length'
  }
})
:Execute(function(caller, targets, length)
  for _, target in pairs(targets) do
    if (!target.sg_jail) then
      local duration = length or 0
    
      TTS.Admin.JailPlayer(target, duration)
    end
  end
  
  return true
end)

TTS.Admin.commands.Register( 'jailtp' )
-- :SetAlias('jailbox') 
:SetDescription('123')
:SetRequiredAttrs({ 'players' })
:SetOptionalAttrs({ 'length' })
-- :SetImmunity(TI.LESSOREQUAL)
:SetLogType('jailtp', ':user_id-0 телепортировал и отправил в тюрьму :user_ids на :length')
:SetPermissions({ 'jailtp' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' телепортировал и отправил в тюрьму ',
    '%str',
    ' на ',
    '%length'
  },{
    '%str',
    ' телепортировала и отправила в тюрьму ',
    '%str',
    ' на ',
    '%length'
  }
})
:Execute(function(caller, targets, length)
  PrintTable(targets)
  for _, target in pairs(targets) do
    if (!target.sg_jail) then
      local duration = length or 0

      target.sg_LastPosition = target:GetPos()
      target.sg_LastAngles = target:EyeAngles()
    
      target:SetPos(caller:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 5))
      
      TTS.Admin.JailPlayer(target, duration)
    end
  end
  
  return true
end)

TTS.Admin.commands.Register( 'unjail' )
-- :SetAlias('jailbox') 
:SetDescription('unjail')
:SetRequiredAttrs({ 'player' })
-- :SetImmunity(TI.LESSOREQUAL)
:SetLogType('unjail', ':user_id-0 освободил из тюрьмы :user_ids')
:SetPermissions({ 'jail', 'jailtp' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' освободил из тюрьмы ',
    '%str',
  },{
    '%str',
    ' освободила из тюрьмы ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if (target.sg_jail) then
      TTS.Admin.UnjailPlayer(target)
    end
  end
  
  return true
end)

hook.Add("PlayerDisconnected", "serverguard.jail.PlayerDisconnected", function(player)
	if (player.sg_jail) then
    TTS.Admin.UnjailPlayer(player)
	end;
end);

hook.Add("CanPlayerSuicide", "serverguard.jail.CanPlayerSuicide", function(player)
	if (player.sg_jail) then
		-- serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You can't suicide because you're jailed!");

		return false;
	end;
end);

hook.Add("PhysgunPickup", "serverguard.jail.PhysgunPickup", function(player, entity)
	if (IsValid(entity) and entity.sg_jail or player.sg_jail) then
		return false;
	end;
end);

-- This should be late enough to prevent conflicts
hook.Add("InitPostEntity", "serverguard.jail.InitPostEntity", function()
	local playerSpawnHook = GAMEMODE.PlayerSpawn or function() end;
	function GAMEMODE:PlayerSpawn(player)
		playerSpawnHook(self, player);
		if (player.sg_jail) then
			player:SetPos(player.sg_jailLocation);
			player:SetMoveType(MOVETYPE_WALK);
		end;
	end;
end);

hook.Add("EntityTakeDamage", "serverguard.jail.EntityTakeDamage", function(target, dmgInfo)
	local attacker = dmgInfo:GetAttacker();

	if (IsValid(attacker) and attacker.sg_jail) then
		return true;
	end;
end);

local function JailBlock(player)
	if (IsValid(player) and player.sg_jail) then
		return false;
	end;
end;

hook.Add("PlayerSpawnProp", 		"serverguard.jail.PlayerSpawnProp", 		JailBlock);
hook.Add("PlayerSpawnRagdoll", 		"serverguard.jail.PlayerSpawnRagdoll", 		JailBlock);
hook.Add("PlayerSpawnVehicle", 		"serverguard.jail.PlayerSpawnVehicle", 		JailBlock);
hook.Add("PlayerSpawnSENT", 		"serverguard.jail.PlayerSpawnSENT", 		JailBlock);
hook.Add("PlayerSpawnSWEP", 		"serverguard.jail.PlayerSpawnSWEP", 		JailBlock);
hook.Add("PlayerSpawnEffect", 		"serverguard.jail.PlayerSpawnEffect", 		JailBlock);
hook.Add("PlayerSpawnNPC", 			"serverguard.jail.PlayerSpawnNPC", 			JailBlock);
hook.Add("PlayerSpawnObject", 		"serverguard.jail.PlayerSpawnObject", 		JailBlock);
hook.Add("GravGunPickupAllowed",	"serverguard.jail.GravGunPickupAllowed", 	JailBlock);
hook.Add("GravGunPunt", 			"serverguard.jail.GravGunPunt", 			JailBlock);
hook.Add("OnPhysgunReload",			"serverguard.jail.OnPhysgunReload", 		JailBlock);
