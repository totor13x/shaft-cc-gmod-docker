-- print('13 - rainbow')
local FOOTSTEP = {}

FOOTSTEP.ID = 'rainbowfootstep'
FOOTSTEP.Run = function(self, pos, ply)
  for i = 1, 3 do
    local randvec = Vector(math.random(-15, 15), math.random(-15, 15), 0)
    local vel = -ply:GetVelocity()/3 + randvec
    SpawnParticle(
      math.random(7, 13) / 10,
      20,
      0,
      'sprites/light_glow02_add',
      HSVToColor((SysTime() * 30) % 360, 1, 1),
      pos + randvec/5,
      vel,
      -vel + Vector(0, 0, 15)
    )
  end
end
-- FOOTSTEP.Name = "TT-Shop"

TTS.Shop.effects.Register( FOOTSTEP )