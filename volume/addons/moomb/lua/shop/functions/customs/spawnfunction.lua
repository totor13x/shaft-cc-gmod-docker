if CLIENT then
  local _ = {}

  local function Render(self, normal)
    render.SetMaterial(self.Mat)
    if normal then
      render.DrawQuadEasy(self.Pos, normal, self.Size, self.Size, ColorAlpha(self.Color, self.Alpha), self.Pitch + self.RollDelta * (self.Duration - self.Life)/self.Duration)
    else
      render.DrawSprite(self.Pos, self.Size, self.Size, ColorAlpha(self.Color, self.Alpha))
    end
  end

  function SpawnParticle(Duration, StartSize, EndSize, Mat, RGB, Position, Velocity, Gravity, Pitch, RollDelta, StartAlpha, EndAlpha, NoDraw, parentE, parentAtt)
    local p = {
      Duration = Duration,
      Life = Duration,
      Size = StartSize,
      StartSize = StartSize,
      EndSize = EndSize,
      Mat = Material(Mat),
      Color = isvector(RGB) and Color(RGB.x, RGB.y, RGB.z) or RGB,
      Pos = Position,
      Vel = Velocity or Vector(0, 0, 0),
      Gravity = Gravity,
      Pitch = Pitch,
      RollDelta = RollDelta,
      Alpha = StartAlpha or 255, 
      StartAlpha = StartAlpha or 255,
      EndAlpha = EndAlpha or 255,
      NoDraw = NoDraw,
      Render = Render,
      IsValid = function() return true end,
      parent = parentE,
      parentAtt = parentAtt,
      normal = RollDelta and RollDelta ~= 0
    }
    
    local i = table.insert(_, p)
    return p, i
  end

  hook.Add('Think', 'LS_UpdateParticles', function()
    for i, p in pairs(_) do
      p.Life = p.Life - FrameTime()
      if p.Life <= 0 then 
        table.Empty(_[i]) 
        _[i] = nil 
        continue 
      end
      p.Size = p.Size + (p.EndSize - p.StartSize) * FrameTime() / p.Duration
      p.Vel = p.Vel + p.Gravity * FrameTime()
      p.Pos = p.Pos + p.Vel * FrameTime()
      p.Alpha = p.Alpha + (p.EndAlpha - p.StartAlpha) * FrameTime() / p.Duration

      if p.parent and IsValid(p.parent) then 
        if p.parentAtt then
          p.Pos = p.parent:GetAttachment(p.parentAtt).Pos
        else
          p.Pos = p.parent:GetPos()
        end
      end
    end
  end)

  hook.Add('PostDrawTranslucentRenderables', 'LS_RenderParticles', function()
    for i, p in pairs(_) do
      if not p.NoDraw and p.Pos:DistToSqr(EyePos()) < 562500 then
        p:Render(p.normal and (EyePos() - p.Pos):GetNormalized() or nil)
      end
    end
  end)

  usermessage.Hook("ls_create_particle", function(message)
    local RollDelta = message:ReadChar()
    local StartAlpha= message:ReadShort()
    local EndAlpha  = message:ReadShort()
    local StartSize = message:ReadShort()
    local Duration  = message:ReadFloat()
    local EndSize   = message:ReadShort()
    local Pitch     = message:ReadFloat()
    
    local centr    = message:ReadVector()
    local Color    = message:ReadVector()
    local Vel      = message:ReadVector()
    local Grav      = message:ReadVector()
    
    local PartType = message:ReadString()	
    local parentE = message:ReadShort()	
    local parentAtt = message:ReadShort()
      
    SpawnParticle(Duration, StartSize, EndSize, PartType, Color, centr, Vel, Grav, Pitch, RollDelta, StartAlpha, EndAlpha, nil, parentE != 0 and Entity(parentE) or nil, parentAtt != 0 and parentAtt or nil)
  end)
else
  local function message(Duration, StartSize, EndSize, RGB, Position, Velocity, Gravity, String, Pitch, RollDelta, StartAlpha, EndAlpha, parentE, parentAtt)
    umsg.Start("ls_create_particle",player.GetAll())
      umsg.Char(RollDelta)
      umsg.Short(StartAlpha)
      umsg.Short(EndAlpha)
      umsg.Short(StartSize)
      umsg.Float(Duration)
      umsg.Short(EndSize)
      umsg.Float(Pitch)
      umsg.Vector(Position)
      umsg.Vector(RGB)
      umsg.Vector(Velocity)
      umsg.Vector(Gravity)
      umsg.String(String)
      umsg.Short(parentE)
      umsg.Short(parentAtt)
    umsg.End()
  end
  
  function SpawnParticle(Duration, StartSize, EndSize, Mat, RGB, Position, Velocity, Gravity, Pitch, RollDelta, StartAlpha, EndAlpha, parentE, parentAtt)
    message(Duration, StartSize, EndSize, isvector(RGB) and RGB or Vector(RGB.r, RGB.g, RGB.b), Position, Velocity, Gravity, Mat, Pitch or 0, RollDelta or 0, StartAlpha and StartAlpha or 255, EndAlpha and EndAlpha or 255, parentE and parentE:EntIndex() or 0, parentAtt or 0)
  end
end