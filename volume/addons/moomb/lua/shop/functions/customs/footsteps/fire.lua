local FOOTSTEP = {}

FOOTSTEP.ID = 'firefootstep'
FOOTSTEP.Run = function(self, pos, ply)
	-- print(pos)
	ParticleEffect( "halloween_boss_foot_impact", pos, Angle( 0, 0, 0 ) )
  -- print(pos, ply)
  -- for i = 1, 3 do
    -- local randvec = Vector(math.random(-15, 15), math.random(-15, 15), 0)
    -- local vel = -ply:GetVelocity()/3 + randvec
    -- SpawnParticle(
      -- math.random(7, 13) / 10,
      -- 6,
      -- 0,
      -- 'icon16/star.png',
      -- color_white,
      -- pos + randvec/5,
      -- vel,
      -- -vel + Vector(0, 0, 15),
      -- 0,
      -- math.random(-100, 100)
    -- )
  -- end
end
-- FOOTSTEP.Name = "TT-Shop"

TTS.Shop.effects.Register( FOOTSTEP )