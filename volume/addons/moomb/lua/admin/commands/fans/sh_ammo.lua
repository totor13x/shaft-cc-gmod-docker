
local infiniteAmmo = 999999
TTS.Admin.commands.Register( 'ammo' )
:SetDescription('ammo')
:SetRequiredAttrs({ 'players', 'number' })
:SetLogType('ammo', ':user_id-0 пополнил боезапас :user_ids на :number')
:SetPermissions({ 'ammo' })
:SetSingleTarget( false )
:SetDeclinatio({ 
  {
    '%str',
    ' пополнил боезапас ',
    '%str',
    ' на ',
    '%str'
  },{
    '%str',
    ' пополнила боезапас ',
    '%str',
    ' на ',
    '%str'
  }
})
:Execute(function(caller, targets, ammoAmount)
  if (ammoAmount < 1) then ammoAmount = infiniteAmmo end
  
  for _, target in pairs(targets) do
    for _, weapon in pairs(target:GetWeapons()) do
      target:GiveAmmo(ammoAmount, weapon:GetPrimaryAmmoType())
      target:GiveAmmo(ammoAmount, weapon:GetSecondaryAmmoType())
    end
  end
  
  return true
end)