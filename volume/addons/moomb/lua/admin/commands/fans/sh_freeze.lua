
TTS.Admin.commands.Register( 'freeze' )
:SetDescription('freeze')
:SetRequiredAttrs({ 'players' })
:SetLogType('freeze', ':user_id-0 наложил эффект заморозки :user_ids')
:SetPermissions({ 'freeze' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' наложил эффект заморозки ',
    '%str',
  },{
    '%str',
    ' наложила эффект заморозки ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if not target:Alive() then continue end

    target.sg_isFrozen = true
		target:Freeze(true)
  end

  return true
end)

TTS.Admin.commands.Register( 'unfreeze' )
:SetDescription('unfreeze')
:SetRequiredAttrs({ 'players' })
:SetLogType('unfreeze', ':user_id-0 cнял эффект заморозки :user_ids')
:SetPermissions({ 'freeze' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' cнял эффект заморозки ',
    '%str',
  },{
    '%str',
    ' cняла эффект заморозки ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for _, target in pairs(targets) do
    if not target:Alive() then continue end

    target.sg_isFrozen = false
    target:Freeze(false)

    if (target:GetMoveType() == MOVETYPE_NONE) then
      target:SetMoveType(MOVETYPE_WALK)
    end
  end

  return true
end)

local function FreezeBlock(player)
  if (player.sg_isFrozen) then
      return false
  end
end
local function FreezeHookHelper(...)
  for i = 1, select("#", ...) do
      local name = select(i, ...)
      hook.Add(name, "serverguard.freeze."..name, FreezeBlock)
  end
end
FreezeHookHelper(
  "PlayerSpawnEffect",
  "PlayerSpawnNPC",
  "PlayerSpawnObject",
  "PlayerSpawnProp",
  "PlayerSpawnRagdoll",
  "PlayerSpawnSENT",
  "PlayerSpawnSWEP",
  "PlayerSpawnVehicle"
)
