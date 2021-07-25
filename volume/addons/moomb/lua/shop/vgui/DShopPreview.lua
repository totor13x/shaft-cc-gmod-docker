local PANEL = {}

function PANEL:Init()
	self.ent = "models/player/alyx.mdl"
	self:SetModel(self.ent) 
	
	self:SetLookAt( Vector(0,0,72/2) )
	self:SetCamPos( Vector(25,0,72/2))
	-- self:MouseCapture( true )
	self.EntAngle = -25
	self.EntPos = Vector(0,0,-20)
	
end

function PANEL:Paint()
	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = (self.vLookatPos-self.vCamPos):Angle()
	end
	local w, h = self:GetSize()
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, 4096 )
	-- cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )

	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end
	if not self.Entity.DisableDraw then
		self.Entity:DrawModel()
	end
	self.Entity:SetAngles( Angle( 0, self.EntAngle, 0) )
	-- print(self.EntAngle)
	self.Entity:SetPos(self.EntPos)
	
	self:DrawOtherModels()
	// self:DrawOtherModels()
			
	render.SuppressEngineLighting( false )
	-- cam.IgnoreZ( false )
	cam.End3D()

	self.LastPaint = RealTime()
end

function PANEL:OnCursorEntered()
	self.Scrolled = true
end

function PANEL:OnCursorExited()
	self.Scrolled = false
end
-- local IsMouseCaptured = false
-- Because the built in panel was too funky
function PANEL:Think()
  -- IsMouseCaptured = self.Scrolled
	if input.IsMouseDown(MOUSE_LEFT) and self.Scrolled then
		local x, y = input.GetCursorPos()
		local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
		
		if (self.SnapToCenter or 0) <= CurTime() then
			input.SetCursorPos( centerx, centery )
			self.SnapToCenter = CurTime()+0.001
			self.dx, self.dy  = input.GetCursorPos()
		end
		-- print(self.dx)
		self.EntAngle = self.EntAngle + (x-self.dx)/20
    self.EntPos = self.EntPos + Vector(0,0,((y-self.dy)/50)*-1)
    -- print(self.EntPos, )
	end
	if input.IsMouseDown(MOUSE_RIGHT) and self.Scrolled then
		local x, y = input.GetCursorPos()
		local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
		
		if (self.SnapToCenter or 0) <= CurTime() then
			input.SetCursorPos( centerx, centery )
			self.SnapToCenter = CurTime()+0.001
			self.dxx, self.dxy  = input.GetCursorPos()
		end
		self.EntPos = self.EntPos + Vector(((y-self.dxy)/50)*-1,0,0)
		if (self.EntPos.x > 10) then self.EntPos.x = 10 end
		if (self.EntPos.x < -15) then self.EntPos.x = -15 end
	end
	self.EntPos = self.EntPos + Vector(0,0,0.0001)
	-- self.Entity:SetAngles( Angle( 0, self.EntAngle, 0) )
	-- self.Entity:SetPos( self.EntPos )
end

function PANEL:DrawOtherModels()
end

function PANEL:LayoutEntity( ent )
	-- Override
end

vgui.Register('DShopPreview', PANEL, 'DModelPanel')

-- hook.Add( "InputMouseApply", "TTShop/MouseCapture", function( cmd )
--   print(IsMouseCaptured)
--   if IsMouseCaptured then
--     cmd:SetMouseX( 0 )
--     cmd:SetMouseY( 0 )

--     return true
--   end
-- end )