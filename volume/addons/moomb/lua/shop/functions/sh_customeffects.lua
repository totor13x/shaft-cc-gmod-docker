local footstepsInclude = {
  'rainbow',
  'star',
  'fire'
}
local hatsInclude = {
  'musicorb',
}
local bodiesInclude = {
  -- 'lina_dress',
  -- 'spectre_immortal'
}

TTS.LoadSH('customs/spawnfunction.lua')
-- TTS.LoadCL('footsteps/spawnfunction.lua')

TTS.Shop.effects = {
	list = {}
}

local EFFECT = {}

EFFECT.__index = EFFECT

function TTS.Shop.effects.Register( mod )
	local out = setmetatable(mod, EFFECT)
	
	TTS.Shop.effects.Delete( mod.ID )
	TTS.Shop.effects.list[mod.ID] = out
	
	hook.Run('TTS.Shop::RegisterEffect', mod)
end

function TTS.Shop.effects.Delete( id ) 
	TTS.Shop.effects.list[id] = nil
end

function TTS.Shop.effects.GetList() 
	return TTS.Shop.effects.list
end

function TTS.Shop.effects.Get( id ) 
	return TTS.Shop.effects.list[id]
end

function EFFECT:Run(pos, ply)
	return self.Run(pos, ply)
end
for i, v in pairs(footstepsInclude) do
  TTS.LoadCL('customs/footsteps/' .. v .. '.lua')
end
for i, v in pairs(hatsInclude) do
  TTS.LoadCL('customs/hats/' .. v .. '.lua')
end
for i, v in pairs(bodiesInclude) do
  TTS.LoadCL('customs/bodies/' .. v .. '.lua')
end
-- print('123') 
hook.Add('PlayerFootstep', 'PS.Footsteps', function(ply, pos, foot)
	if ply:GetNWBool('ls_hidden') then return end
  
	local eqpd = ply:GetNWBool('footstep')
	local eqpdString = ply:GetNWString('footstepstring')
  
	if not eqpd then return end

  local footstep = TTS.Shop.effects.Get( eqpdString ) 
  if not footstep then return end

  local bone = ply:LookupBone(foot == 0 and 'ValveBiped.Bip01_L_Foot' or 'ValveBiped.Bip01_R_Foot')
  if bone then pos = ply:GetBonePosition(bone) end

  footstep:Run(pos, ply)
end)

