local slapSounds = {
	Sound("physics/body/body_medium_impact_hard1.wav"),
	Sound("physics/body/body_medium_impact_hard2.wav"),
	Sound("physics/body/body_medium_impact_hard3.wav"),
	Sound("physics/body/body_medium_impact_hard5.wav"),
	Sound("physics/body/body_medium_impact_hard6.wav"),
	Sound("physics/body/body_medium_impact_soft5.wav"),
	Sound("physics/body/body_medium_impact_soft6.wav"),
	Sound("physics/body/body_medium_impact_soft7.wav")
};

TTS.Admin.commands.Register( 'slap' )
:SetDescription('slap')
:SetRequiredAttrs({ 'players' })
:SetOptionalAttrs({ 'number' })
:SetLogType('slap', ':user_id-0 пнул :user_ids на :number')
:SetPermissions({ 'slap' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' пнул ',
    '%str',
    '%reason'
  },{
    '%str',
    ' пнула ',
    '%str',
    '%reason'
  }
})
:Execute(function(caller, targets, hp)
	local multipler = (hp or 3)/10
	if multipler > 5 then multipler = 5 end
	if multipler <= 0 then multipler = 1 end

  for _, target in pairs(targets) do
    if not target:Alive() then continue end
    
    target:SetVelocity(Vector(math.random(-225, 225)*(multipler), math.random(-225, 225)*(multipler), 10));
    target:EmitSound(slapSounds[math.random(1, #slapSounds)]);

    if hp then
      target:SetHealth(target:Health() -hp);
      if target:Health() <= 0 then
        target:Kill()
      end
    end
  end
  
  return true
end)