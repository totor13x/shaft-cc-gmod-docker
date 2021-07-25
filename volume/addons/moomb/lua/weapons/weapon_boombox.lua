if IsValid(BoomBoxFrameVertel) then
	BoomBoxFrameVertel:Remove()
end

SWEP.PrintName = "BoomBox"			
SWEP.Author = "Totor"
SWEP.Slot      = 5
SWEP.SlotPos		= 1

SWEP.ViewModel				="models/weapons/c_rpg.mdl"
SWEP.WorldModel				="models/props_lab/citizenradio.mdl"


SWEP.VElements = {
	["firstperson_boombox"] = { 
    type = "Model",
    model = "models/props_lab/citizenradio.mdl",
    bone = "base",
    rel = "", 
    pos = Vector(-5.561, 7.835, -2.845), 
    angle = Angle(15, 0, -90), 
    size = Vector(1, 1, 1), 
    color = Color(255, 255, 255, 255), 
    surpresslightning = false, 
    material = "", 
    skin = SWEP.SkinType, 
    bodygroup = {} 
  },
	["hud"] = {
    type = "Quad", 
    bone = "base", 
    rel = "firstperson_boombox", 
    pos = Vector(8.55, 11.835, 0), 
    angle = Angle(90, 0, 90), 
    size = 0.02, 
	  draw_func = function() 
	    local bands = {}
	    local realBands = {}
	    local bandThickness = 7
	    local bandMaxHeight = 150
	    local amp = 5000
	    local dext = 2
	    local offset = 0
	    local parts = {}
		  local ply = LocalPlayer()
      
      if ply:GetObserverMode() ~= OBS_MODE_NONE then
			  if IsValid( ply:GetObserverTarget() ) then
  				ply = ply:GetObserverTarget()
			  end
		  end
      
      if !IsValid(Boomboxes[ply]) then return end
      
      Boomboxes[ply]:FFT(bands , FFT_8192)

		  for i = 1 , 64 do  
		    bands[i+offset] = bands[i+offset] or 0
        
        if bands[i + offset] * amp > bandMaxHeight then
				  bands[i + offset] = bandMaxHeight / amp
        end   

        if bands[i + offset] * amp < 2 then
          bands[i + offset] = 2
        else
          bands[i + offset] = bands[i + offset] * amp
        end
        
        realBands[i] = realBands[i] or 0
        realBands[i] = Lerp(30*FrameTime(),realBands[i],bands[i + offset])

			  if i < 63  and i > 2 then 
				  local a = realBands[i]
				  local b = realBands[i + 1] or 0
				  local c = realBands[i - 1] or 0
          
          realBands[i] = (a+b+c) / 3
        elseif i < 3 then
          local a = realBands[i] or 0
				  local b = realBands[i + 1] or 0
				  local c = 0
          
          realBands[i] = (a+b+c) / 3
        end
      end

		  local w = (640)

		  local xPos = 110


		  for k , v  in pairs(parts) do
			  surface.DrawTexturedRect(v.x , v.y , v.size , v.size)
			  parts[k].x = parts[k].x + (v.speed * FrameTime())

			  if parts[k].x > ScrW() then
				  parts[k].x = 0
        end
      end

      for i = 1 , 64 do
        draw.RoundedBox(0,xPos, 5 , bandThickness , realBands[i],Color(255,255,255))
        xPos = xPos + (w/64)
      end
  	end
	},
	
	["hud2"] = { 
    type = "Quad",
    bone = "base",
    rel = "firstperson_boombox",
    pos = Vector(13, 4.835, 11),
    angle = Angle(180, -50, -90),
    size = 0.02, 
	  draw_func = function() 
		  local ply = LocalPlayer()
		  if ply:GetObserverMode() ~= OBS_MODE_NONE then
  			if IsValid( ply:GetObserverTarget() ) then
				  ply = ply:GetObserverTarget()
			  end
		  end
      
      if !IsValid(Boomboxes[ply]) then return end
      
      surface.SetFont( "S_Bold_40" )
      
      if Boomboxes[ply]:GetState() == GMOD_CHANNEL_PAUSED then
        draw.SimpleText( '[ПКМ] Now paused', "S_Bold_40", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      elseif Boomboxes[ply]:GetState() == GMOD_CHANNEL_PLAYING then
        draw.SimpleText( '[ПКМ] Now played', "S_Bold_40", 0, 0, Color(94, 130, 158, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        -- netstream.Start('TTS:Boombox.Pause')
      end

      local rvolum = ply:GetNWFloat('TTS::BoomboxVolume')
      local rvolum_t = "[R] VOLUME: " .. rvolum * 100 .. "%"

      draw.SimpleText( rvolum_t, "S_Bold_40", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      
      surface.SetDrawColor(255,255,255,255)
      
      local widt = surface.GetTextSize( "[R] VOLUME: 100%" )
      -- 140 - (100 - 140 / 4) = 
      local remapp = math.Remap( rvolum, 0, 1, 0, widt ) 
		  surface.DrawRect(0,80, remapp, 10)
		
		  draw.SimpleText( ply:GetNWString("TTS::BoomboxAuthor"), "S_Bold_30", 0, 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		  draw.SimpleText( "by "..ply:GetNWString("TTS::BoomboxPly"), "S_Bold_20", 0, 130, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	  end
	}
}


SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
Boomboxes = Boomboxes or {}

function SWEP:Initialize()
	self.reloadon = CurTime()
	self:SetHoldType("rpg")
	if CLIENT then
    self.VElements = table.FullCopy( self.VElements )
    self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
    self:CreateModels(self.VElements) // create viewmodels
    if IsValid(self.Owner) then
      local vm = self.Owner:GetViewModel()
      if IsValid(vm) then
        self:ResetBonePositions(vm)
        
        if (self.ShowViewModel == nil or self.ShowViewModel) then
          vm:SetColor(Color(255,255,255,255))
        else
          vm:SetColor(Color(255,255,255,1))
          vm:SetMaterial("Debug/hsv")			
        end
      end
    end
	end
end

function SWEP:PreDrawPlayerHands( vm, Player, Weapon )
	return
end

function SWEP:PostDrawPlayerHands( hands, vm, pl )
	return
end

function SWEP:PreDrawViewModel( vm, Player, Weapon )
render.SetBlend(0)
	return
end

function SWEP:PostDrawViewModel( vm, Player, Weapon )
render.SetBlend(1)
	return
end

function SWEP:PrimaryAttack()
  if CLIENT then
    RunConsoleCommand('tts_boombox_run')
		-- net.Start('TotorBoombox.frame')
		-- net.SendToServer()
	end
end

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() then return end
	if self.reloadon+0.5 < CurTime() then
    if CLIENT then
      if IsValid(Boomboxes[LocalPlayer()]) then
        self.reloadon = CurTime()
        if Boomboxes[LocalPlayer()]:GetState() == GMOD_CHANNEL_PAUSED then
          netstream.Start('TTS:Boombox.Resume')
        elseif Boomboxes[LocalPlayer()]:GetState() == GMOD_CHANNEL_PLAYING then
          netstream.Start('TTS:Boombox.Pause')
        end
      end
      -- net.Start('TotorBoombox.stop')
      -- net.SendToServer()
    end
  end
end

-- local Volumes

function SWEP:Reload()
	if !IsFirstTimePredicted() then return end
	if self.reloadon+0.5 < CurTime() then
		if CLIENT then
			self.reloadon = CurTime()
      netstream.Start('TTS:Boombox.Volume')
			-- net.Start('TotorBoombox.volume')
			-- net.SendToServer()
		end
	end
end

-- DrawlerBoombox = {
--   forward = 0,
--   right = 0,
--   up = 0,

--   pos_forward = 0,
--   pos_right = 0,
--   pos_up = 0,
-- }
function SWEP:DrawWorldModel()
	if GetViewEntity():GetClass() == 'player' and LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE then return end
  if IsValid(self.Owner) then
    local bone = self.Owner:LookupBone( 'ValveBiped.Bip01_R_Hand' )
    if bone then
		  local pos,ang=self.Owner:GetBonePosition(bone)
      ang:RotateAroundAxis(ang:Right(),DrawlerBoombox.right)
      ang:RotateAroundAxis(ang:Up(),DrawlerBoombox.up)
      ang:RotateAroundAxis(ang:Forward(),DrawlerBoombox.forward)
      pos = pos + ang:Forward() * DrawlerBoombox.pos_forward
      pos = pos + ang:Right() * DrawlerBoombox.pos_right
      pos = pos + ang:Up() * DrawlerBoombox.pos_up
      render.Model({
        model="models/props_lab/citizenradio.mdl";
        pos=pos;
        angle=ang;
      })
    end
	else
		self:DrawModel()
	end
end


if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end


	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we cant do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end
