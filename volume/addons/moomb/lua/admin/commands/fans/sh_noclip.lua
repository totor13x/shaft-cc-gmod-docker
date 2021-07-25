
TTS.Admin.commands.Register( 'noclip' )
:SetDescription('noclip')
:SetRequiredAttrs({ 'players' })
:SetLogType('noclip', ':user_id-0 переключил состояние noclip :user_ids')
:SetPermissions({ 'noclip' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' переключил состояние noclip ',
    '%str',
  },{
    '%str',
    ' переключила состояние noclip ',
    '%str',
  }
})
:Execute(function(caller, targets)
  for i, target in pairs(targets) do
    if (target:GetMoveType() != MOVETYPE_NOCLIP) then
      target:SetMoveType(MOVETYPE_NOCLIP)
    else
      target:SetMoveType(MOVETYPE_WALK)
    end
  end

	return true
end)

hook.Add("PlayerNoClip", "serverguard.PlayerNoClip", function(player)
	if (player.sg_jail or player:GetNetworkedBool("serverguard_jailed", false)) then
		return false
	end;

	if (player:hasPerm(player, "noclip")) then
		return true
	end
end)