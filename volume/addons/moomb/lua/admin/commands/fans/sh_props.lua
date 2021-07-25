
TTS.Admin.commands.Register( 'freezeprops' )
:SetDescription('freezeprops')
:SetLogType('freezeprops', ':user_id-0 заморозил все пропы')
:SetPermissions({ 'freezeprops' })
:SetDeclinatio({ 
  {
    '%str',
    ' заморозил все пропы',
  },{
    '%str',
    ' заморозила все пропы',
  }
})
:Execute(function(caller)
  for k, v in ipairs(ents.FindByClass("prop_physics")) do
		local physicsObject = v:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
		end
  end
  
  return true
end)

TTS.Admin.commands.Register( 'unfreezeprops' )
:SetDescription('unfreezeprops')
:SetLogType('unfreezeprops', ':user_id-0 разморозил все пропы')
:SetPermissions({ 'freezeprops' })
:SetDeclinatio({ 
  {
    '%str',
    ' разморозил все пропы',
  },{
    '%str',
    ' разморозила все пропы',
  }
})
:Execute(function(caller)
  for k, v in ipairs(ents.FindByClass("prop_physics")) do
		local physicsObject = v:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(true)
		end
  end
  
  return true
end)
