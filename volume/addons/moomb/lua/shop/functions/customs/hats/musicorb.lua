-- print('13 - rainbow')
local glowMat = Material('particle/particle_glow_04_additive')

local HAT = {}

HAT.ID = 'musicorb'
HAT.Run = function(self, pos, ply)
  local isplayer = IsEntity(ply) and ply:IsPlayer()
		
  -- local orb = ply.musorb
  
  -- if not IsValid(orb) then
  orb = ClientsideModel('models/hunter/misc/sphere025x025.mdl', RENDERGROUP_OTHER)
  orb:SetMaterial('models/shiny')
  orb:SetRenderMode(RENDERMODE_TRANSALPHA)
  orb:SetPos(isplayer and (ply:GetPos() + Vector(0, 0, 85)) or vector_origin)
  orb:SetNoDraw(true)
  orb.particles = {}
  orb.clr = color_white
  orb.maxvol = 0
  orb.size = 0
  orb.ply = ply
  orb.isplayer = isplayer
  orb.think = function(self)  
    local ply = self.ply
    local pos = self.isplayer and (ply:GetShootPos() + Vector(0, 0, 25)) or (IsEntity(ply) and Vector(0, 0, 85) or Vector(0, 0, 5))
    self:SetPos(self:GetPos() + (pos - self:GetPos())*FrameTime() * 5)
    
    self.clr = HSVToColor(math.Clamp(self.size * 4, 0, 360), 1, 1)
    
    local vol = isplayer and math.min(ply:VoiceVolume() * 2, 1) or math.Rand(0, 1)
    if vol > self.maxvol then self.maxvol = vol end
    self.maxvol = math.Clamp(self.maxvol - FrameTime(), 0.15, 1)
    
    if vol > self.maxvol - 0.1 and (not self.particlecooldown or self.particlecooldown < SysTime()) then
      local p = SpawnParticle(
        4,
        20,
        0,
        'particle/particle_glow_04',
        Vector(self.clr.r, self.clr.g, self.clr.b),
        self:GetPos(),
        VectorRand() * 20,
        Vector(0, 0, -10),
        0,
        0,
        255,
        128,
        true
      )
      table.insert(self.particles, p)
      self.particlecooldown = SysTime() + 0.2
    end
    
    local i = 1
    while i <= #self.particles do
      local v = self.particles[i]
      if IsValid(v) then
        v:Render()
        i = i + 1
      else
        table.remove(self.particles, i)
      end
    end

    render.SetMaterial(glowMat)
    local size = 20 + vol * 100
    self.size = Lerp(FrameTime()*2, self.size, size)
    render.DrawSprite(self:GetPos(), self.size, self.size, self.clr)
    render.DrawSprite(self:GetPos(), -self.size, -self.size, self.clr)

    render.OverrideDepthEnable(true, true)
    
    render.SetColorMaterial()
    render.DrawSphere(self:GetPos(), 6, 16, 16, self.clr)

    render.OverrideDepthEnable(false, false)
  end

  return orb
end
-- FOOTSTEP.Name = "TT-Shop"

TTS.Shop.effects.Register( HAT )