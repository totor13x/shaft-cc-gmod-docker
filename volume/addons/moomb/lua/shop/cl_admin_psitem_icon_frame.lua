
concommand.Add("ps_items_icons", function()
local material = Material( 'color/white' )

if IsValid(PSItemEdit) then
	PSItemEdit:Remove()
end

local material = CreateMaterial( CurTime() .. "3", "UnlitGeneric", {
  ["$basetexture"] = "color/black",
  -- ["$translucent"] = "1",
  -- ["$model"] = "1",
  -- ["$vertexalpha"] = "1",
  -- ["$vertexcolor"] = "1",
  -- ["$ignorez"] = "1",
} )
 
GLOBALPOS = GLOBALPOS or { 
-- GLOBALPOS = { 
	campos = Vector( -90, 0, 0 ),
	camlookang = Angle( 0, 0, 0 ),
	ffov = 70,
	bgcolor = Color(255,255,255),
	model = false
}

GLOBALPOSSTORE = GLOBALPOSSTORE or {}

PSItemEdit = vgui.Create( "DFrame" ) -- Container for the SpawnIcon

PSItemEdit:SetSize( 1280, 720)
PSItemEdit:Center()
PSItemEdit:SetTitle( "Icon Editor" )
PSItemEdit:MakePopup()
PSItemEdit.ShowModel = GLOBALPOS.model
PSItemEdit.Item = false
-- function PSItemEdit:OnSizeChanged()
	local DScrollPanel = vgui.Create( "DScrollPanel", PSItemEdit )
	DScrollPanel:SetSize(400,0)
	DScrollPanel:Dock( LEFT )

	local DGrid = vgui.Create( "DGrid", DScrollPanel)
	DGrid:SetPos( 0, 0 )
	DGrid:SetCols( 2 )
	DGrid:SetColWide( 200 )
	DGrid:SetRowHeight( 20 )
	DGrid:Dock( FILL )

	-- PrintTable(TTS.Shop.Data.Items)
	--[[
	["data"] = {
        ["ang"] = {
            ["p"] = 0,
            ["r"] = 0,
            ["y"] = 0,
        },
        ["attach"] = "eyes",
        ["mdl"] = "models/props_splatoon/gear/headgear/unique/warrior_headdress/warrior_headdress.mdl",
        ["pos"] = {
            ["x"] = -1.5,
            ["y"] = 0,
            ["z"] = -2.5,
        },
        ["scale"] = 0.4,
    },
	]]--
	timer.Simple(0, function()
		-- for i=0, 100 do
		for i,v in pairs(TTS.Shop.Data.Items) do
			local DButton = vgui.Create( "DButton" )
			DButton:SetText( v.name )
			-- DButton:Dock(TOP)
			DButton:SetSize(200,20)
			local _drawModel = PSItemEdit._previewModel.DrawModel
			DButton.DoClick = function(s)
				PSItemEdit.Item = v
				-- PrintTable(v)
				PSItemEdit.IDItemLabel:SetText( "ID: " .. (PSItemEdit.Item and PSItemEdit.Item.id or 'NULL') )
						
			local path = "icon_" .. (PSItemEdit.Item and PSItemEdit.Item.id or 0) .. ".jpg";
			RunConsoleCommand("mat_reloadmaterial", "../data/"..path:StripExtension());
			
			-- local image = vgui.Create( "DImage", Preview );
			-- image:Dock(FILL);
			-- print("../data/"..path)
			PSItemEdit.image:SetImage("../data/"..path);
				
				if IsValid(PSItemEdit._previewModel.attached) then
					PSItemEdit._previewModel.attached:Remove()
				end
				if IsValid(PSItemEdit._previewModel.Particle) then
					if PSItemEdit._previewModel.ParticleOrig then
						PSItemEdit._previewModel.Particle:StopEmissionAndDestroyImmediately()
					end
					PSItemEdit._previewModel.ParticleOrig = nil
					PSItemEdit._previewModel.Particle:Remove()
				end
				PSItemEdit._previewModel.LayoutEntity = function() end 
				
				-- if IsValid(PSItemEdit._previewModel.Entity) then
					-- PSItemEdit._previewModel.Entity:Remove()
					-- PSItemEdit._previewModel.DrawModel = nil
				-- end
				
				if PSItemEdit.ShowModel then
					if PSItemEdit._previewModel:GetModel() ~= 'models/player/group02/male_02.mdl' then
						PSItemEdit._previewModel:SetModel('models/player/group02/male_02.mdl')
					end
					
					PSItemEdit._previewModel.DrawModel = function(s)
						local posi = s.Entity:GetPos()
						s.Entity:SetPos(Vector(posi.x, posi.y, posi.z + 0.000001)) 
						-- print(x, y, z )
						
						-- s.Entity:SetMaterial(material)
						
						local model = s.attached
						if IsValid(model) and model.ToDrawning then
							
							
							render.SetStencilWriteMask( 0xFF )
							render.SetStencilTestMask( 0xFF )
							render.SetStencilReferenceValue( 0 )
							render.SetStencilCompareFunction( STENCIL_ALWAYS )
							render.SetStencilPassOperation( STENCIL_KEEP )
							render.SetStencilFailOperation( STENCIL_KEEP )
							render.SetStencilZFailOperation( STENCIL_KEEP )
							render.ClearStencil()

							render.SetStencilEnable( true )
							render.SetStencilReferenceValue( 1 )
							render.SetStencilCompareFunction( STENCIL_EQUAL )
							render.SetStencilFailOperation( STENCIL_REPLACE )
							_drawModel(s) 
							
							render.ClearBuffersObeyStencil( 33,33,33,255, false )

							model:DrawModel()
							for i = 0, 6 do
								local col = PSItemEdit._previewModel.DirectionalLight[ i ]
								-- print(col)
								if ( col ) then
									render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
								end
							end
							render.SetStencilEnable( false )
							
							return
						end
						-- render.Clear(33,33,33,255,true,true)
						local item = v
						
						if item.type == 'attach' then
						model = ClientsideModel(item.data.mdl, RENDERGROUP_TRANSLUCENT)
						model:SetNoDraw(true)
						model.OPos = {
							x = 0,
							y = 0,
							z = 0,
						}
						model.OAng = {
							p = 0,
							y = 0,
							r = 0,
						}
						model.ReloadPos = function(s, x, y, z)
							local pos = Vector()
							local ang = Angle()
							
							pos = pos + (ang:Forward() * x) 
							pos = pos + (ang:Right() * y) 
							pos = pos + (ang:Up() * z) 
							model.OPos = {
								x = x,
								y = y,
								z = z,
							}
							ang:RotateAroundAxis(ang:Up(), model.OAng.p)
							ang:RotateAroundAxis(ang:Right(), model.OAng.y)
							ang:RotateAroundAxis(ang:Forward(), model.OAng.r)
							
							model:SetLocalPos(pos)
							model:SetLocalAngles(ang)
						end
						model.ReloadAng = function(s, p, y, r)
							local pos = Vector()
							local ang = Angle()
							
							pos = pos + (ang:Forward() * model.OPos.x) 
							pos = pos + (ang:Right() * model.OPos.y) 
							pos = pos + (ang:Up() * model.OPos.z) 
							
							ang:RotateAroundAxis(ang:Up(), p)
							ang:RotateAroundAxis(ang:Right(), y)
							ang:RotateAroundAxis(ang:Forward(), r)
							
							model.OAng = {
								p = p,
								y = y,
								r = r,
							}
							model:SetLocalPos(pos)
							model:SetLocalAngles(ang)
						end
						
						if item.data.attach then
							local attach_id = s.Entity:LookupAttachment(item.data.attach)
							if not attach_id then return end
							
							local attach = s.Entity:GetAttachment(attach_id)
							
							if not attach then return end
							-- print(s.Entity, attach_id)
							model:SetMoveType( MOVETYPE_NONE )
							model:SetParent( s.Entity, attach_id )
							
							-- pos = attach.Pos
							-- ang = attach.Ang
						else
							local bone_id = s.Entity:LookupBone(item.data.bone)
							if not bone_id then return end
							s.Entity:AddEffects( EF_FOLLOWBONE )
							model:SetMoveType( MOVETYPE_NONE )
							model:SetParent( s.Entity, bone_id )
							
							-- pos, ang = m_pnlFillingPoints.preview.Entity:GetBonePosition(bone_id)
						end
						
						-- model:SetLocalPos(pos)
						-- model:SetLocalAngles(ang)
						model.ToDrawning = true
						s.attached = model
						model:SetModelScale(item.data.scale or 1, 0)
						model:ReloadAng(item.data.ang.p or 0, item.data.ang.y or 0, item.data.ang.r or 0)
						model:ReloadPos(item.data.pos.x or 0, item.data.pos.y or 0, item.data.pos.z or 0)
						end
					end
					return
				end
				
				PSItemEdit._previewModel.DrawModel = function(s)
					_drawModel(s)
				end
				if v.type == 'model' or v.type == 'attach' then
					PSItemEdit._previewModel:SetModel(v.data.mdl)
				end
				
				if v.type == 'attacheffect' then
						local item = v
					PSItemEdit._previewModel:SetModel('models/player/kleiner.mdl')
					PSItemEdit._previewModel.DrawModel = function(s)
						if IsValid(s) and IsValid(s.Entity) and IsValid(s.Entity.Particle) and s.Drawning then
							local ent = s.Entity
										
							if item.data.lua then
								-- ent.DisableDraw = true
								ent.Particle:think()
								ent.Particle:SetPos(Vector(0,0,32))
							else
								ent.Particle:Render()
							end
							return 
						end
					
						local ent = PSItemEdit._previewModel.Entity
						local obj = ent:LookupAttachment(item.data.attach)
						-- print(obj, item.data.attach)
						local pos = ent:GetAttachment( obj ).Pos
						-- print(pos, s.EntPos) 
						local EntPos = ent:GetPos()
						local finalpos = pos + EntPos * -1
						-- print(finalpos)
						if item.data.lua then
							local effect = TTS.Shop.effects.Get( item.data.effect )
							if effect then
								ent.Particle = effect:Run(Vector(0,0,0), ent)
							end
						else
							ent.Particle = CreateParticleSystem( ent, item.data.effect, PATTACH_ABSORIGIN_FOLLOW, obj, finalpos + Vector(item.data.pos.x or 0,item.data.pos.y or 0,item.data.pos.z or 0) )
							ent.Particle:SetShouldDraw( false )
							PSItemEdit._previewModel.ParticleOrig = true
						end
						s.Drawning = true
						
						-- _drawModel(s)
					end
				end
				
				if v.type == 'swep' then
					local swep = table.Copy(weapons.Get(v.data.swep))
					if swep then
						local mdl = swep.WorldModel
						if swep.WElements then
							for i, v in pairs(swep.WElements) do
								 if v.model then
									mdl = v.model 
									break
								end
							end
						end
						local skin = swep.w_skin
						PSItemEdit._previewModel:SetModel(mdl)
						
						if swep.Skin then
						-- print(swep.Skin)
							PSItemEdit._previewModel.LayoutEntity = function()
								render.MaterialOverride( Material(swep.Skin) ) 
							end
						elseif skin ~= nil and skin ~= 'none' then
							if skin == '!' then
								local niceid = TFA.CSGO.Skins[swep.tfabase][swep.tfaname]['id']
								skin = niceid
								TFA.CSGO.LoadCachedVMT( string.sub(niceid, 2, -1) )
							end
							PSItemEdit._previewModel.LayoutEntity = function()
								render.MaterialOverride( Material(skin) ) 
							end
						end
					end
				end
				-- s._previewModel:SetModel()
			end
			-- DButton:Dock( TOP )
			-- DButton:DockMargin( 0, 0, 0, 5 )
			DGrid:AddItem(DButton)
			DScrollPanel:AddItem( DButton )
		end
	end)

	local Preview = vgui.Create( "DPanel", PSItemEdit )
	-- Preview:SetSize(390,0)
	Preview:Dock( FILL )
	Preview.Paint = function(s,w,h) end
	
	local AdjustableModelPanel = vgui.Create( "DAdjustableModelPanel", Preview )
	AdjustableModelPanel:SetPos( 20, 0 )
	AdjustableModelPanel:Dock( 20, 0 )
	AdjustableModelPanel:SetSize( 350, 350 ) 
	-- AdjustableModelPanel:CenterHorizontal(1) 
	
	AdjustableModelPanel:SetCamPos( GLOBALPOS.campos )  
	AdjustableModelPanel:SetLookAng( GLOBALPOS.camlookang )
	AdjustableModelPanel.fFOV = GLOBALPOS.ffov
	AdjustableModelPanel.BGColor = GLOBALPOS.bgcolor
	
	AdjustableModelPanel:SetDirectionalLight( BOX_LEFT, Color(255,255,255) )
	AdjustableModelPanel:SetModel( "models/props_borealis/bluebarrel001.mdl" )
	AdjustableModelPanel.LayoutEntity = function() end
	local _oPaint = AdjustableModelPanel.Paint
	AdjustableModelPanel.Paint = function(s,w,h)
	
		GLOBALPOS.campos = s:GetCamPos()
		GLOBALPOS.camlookang = s:GetLookAng()  
		GLOBALPOS.ffov = s.fFOV
	
		draw.RoundedBox( 0, 0, 0, w, h, GLOBALPOS.bgcolor) 
		
		_oPaint(s,w,h)
	end
	PSItemEdit._previewModel = AdjustableModelPanel

	local DermaButton = vgui.Create( "DButton", Preview )
	DermaButton:SetText( "RENDER" )
	DermaButton:SetPos( 20, 350+20 )
	-- DermaButton:Dock(TOP)
	DermaButton:SetSize( 350, 30 )
	DermaButton.DoClick = function()
		
		local x,y = AdjustableModelPanel:LocalToScreen()
		hook.Add( "PostRender", "make_icon_render", function()
			-- if ( !ScreenshotRequested ) then return end
			-- ScreenshotRequested = false

			local data = render.Capture( {
				format = "jpg",
				quality = 90,
				x = x,
				y = y,
				w = 350,
				h = 350
			} )

			local path = "icon_render.jpg";
			file.Write( path, data )
			file.Write( "icon_" .. (PSItemEdit.Item.id or 0) .. ".jpg", data )
			
			RunConsoleCommand("mat_reloadmaterial", "../data/"..path:StripExtension());
			PSItemEdit.image:SetImage("../data/"..path)
			 
			hook.Remove( "PostRender", "make_icon_render")
		end )
		-- RunConsoleCommand( "say", "Hi" )
	end
	
	
	local path = "icon_" .. (PSItemEdit.Item and PSItemEdit.Item.id or 0) .. ".jpg";
	RunConsoleCommand("mat_reloadmaterial", "../data/"..path:StripExtension());
	
	local image = vgui.Create( "DImage", Preview );
	-- image:Dock(FILL);
	-- print("../data/"..path)
	image:SetImage("../data/"..path);
	image:SetPos( 20, 350+20+20+20 )
	-- DermaButton:Dock(TOP)
	-- image:SetSize( 350, 30 ) 
	image:SetSize( 200, 200) 
	PSItemEdit.image = image
	
	
	local DermaButton = vgui.Create( "DButton", Preview )
	DermaButton:SetText( "SEND" )
	DermaButton:SetPos( 20, 350+20+20+20+20+200 )
	-- DermaButton:Dock(TOP)
	DermaButton:SetSize( 350, 30 )
	DermaButton.DoClick = function()
		local icon = file.Read("icon_" .. (PSItemEdit.Item and PSItemEdit.Item.id or 0) .. ".jpg")
		if icon and PSItemEdit.Item then
			netstream.Heavy('TTS::ItemIconSave', {
				id = PSItemEdit.Item.id,
				icon = util.Base64Encode( icon )
			})
		end
	end
	
	local ButtonsList = vgui.Create( "DScrollPanel", PSItemEdit )
	ButtonsList:SetSize(390,0)
	ButtonsList:Dock( RIGHT )
	ButtonsList.Paint = function(s,w,h) end
	
	local DLabel = vgui.Create( "DLabel", ButtonsList )
	DLabel:SetText( "ID: " .. (PSItemEdit.Item and PSItemEdit.Item.id or 'NULL') )
	DLabel:Dock( TOP )
	PSItemEdit.IDItemLabel = DLabel
	
	local DLabel = vgui.Create( "DLabel", ButtonsList )
	DLabel:SetText( "" )
	DLabel:Dock( TOP )
	DLabel.Think = function(s)
		local x, y, z = AdjustableModelPanel:GetCamPos():Unpack()
		s:SetText( 'CamPos: ' .. math.Round(x,2) .. ' ' .. math.Round(y, 2) .. ' ' .. math.Round(z, 2))
	end
	
	local DLabel = vgui.Create( "DLabel", ButtonsList )
	DLabel:SetText( "" )
	DLabel:Dock( TOP )
	DLabel.Think = function(s)
		local p, y, r = AdjustableModelPanel:GetLookAng():Unpack()
		s:SetText( 'CamLookAt: ' .. math.Round(p,2) .. ' ' .. math.Round(y,2) .. ' ' .. math.Round(r,2))  
	end
	
	local DLabel = vgui.Create( "DLabel", ButtonsList )
	DLabel:SetText( "" )
	DLabel:Dock( TOP )
	DLabel.Think = function(s)
		local p = AdjustableModelPanel.fFOV
		s:SetText( 'CamFOV: ' .. p)  
	end
	
	local checkbox = vgui.Create( "DCheckBoxLabel", ButtonsList )
	checkbox:Dock( TOP )
	checkbox:DockMargin( 0,0,0,5 )
	checkbox:SetValue( true ) 
	checkbox:SetText( 'Включить локальные источники света' )
	checkbox.OnChange = function(s, val)
		if val then 
			PSItemEdit._previewModel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
			PSItemEdit._previewModel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
			PSItemEdit._previewModel:SetDirectionalLight( BOX_LEFT, Color(255, 255, 255) )
		else
			for i = 0, 6 do
				PSItemEdit._previewModel.DirectionalLight[ i ] = nil
			end
		end
	end
	
	
	local checkbox = vgui.Create( "DCheckBoxLabel", ButtonsList )
	checkbox:Dock( TOP )
	checkbox:DockMargin( 0,0,0,5 ) 
	checkbox:SetValue( GLOBALPOS.model ) 
	checkbox:SetText( 'Показывать модель игрока' )
	checkbox.OnChange = function( s, bVal)
		PSItemEdit.ShowModel = bVal
		GLOBALPOS.model = bVal
	end
	
	
	local grid = vgui.Create( "DGrid", ButtonsList )
	-- grid:SetPos( 10, 30 )
	grid:SetCols( 8 )
	grid:SetColWide( 36 )
	grid:Dock( TOP )
	
	local but = vgui.Create( "DButton" )
	but:SetText( 'R' )
	but:SetSize( 30, 20 )
	but.DoClick = function(s)
		local tab = { 
		-- GLOBALPOS = { 
			campos = Vector( -90, 0, 0 ),
			camlookang = Angle( 0, 0, 0 ),
			ffov = 70,
			bgcolor = Color(255,255,255),
			model = false
		}
		PSItemEdit._previewModel:SetCamPos( tab.campos )  
		PSItemEdit._previewModel:SetLookAng( tab.camlookang )
		PSItemEdit._previewModel.fFOV = tab.ffov
		-- PSItemEdit._previewModel.bgcolor = tab.bgcolor
		
		GLOBALPOS = tab
	end
	grid:AddItem( but )
	local but = vgui.Create( "DButton" )
	but:SetText( '+' )
	but:SetSize( 30, 20 )
	but.DoClick = function(s)
		local tab = table.Copy(GLOBALPOS)
		table.insert(GLOBALPOSSTORE, tab)
		local but = vgui.Create( "DButton" )
		but:SetText( #GLOBALPOSSTORE )
		but:SetSize( 30, 20 )
		but.DoClick = function(s)
			
			PSItemEdit._previewModel:SetCamPos( tab.campos )  
			PSItemEdit._previewModel:SetLookAng( tab.camlookang )
			PSItemEdit._previewModel.fFOV = tab.ffov
			-- PSItemEdit._previewModel.bgcolor = tab.bgcolor
			
			GLOBALPOS = tab
		end
		grid:AddItem( but )
	end
	grid:AddItem( but )
	
	for i,v in pairs(GLOBALPOSSTORE) do
		local tab = table.Copy(v)
		local but = vgui.Create( "DButton" )
		but:SetText( i )
		but:SetSize( 30, 20 )
		but.DoClick = function(s)
			
			PSItemEdit._previewModel:SetCamPos( tab.campos )  
			PSItemEdit._previewModel:SetLookAng( tab.camlookang )
			PSItemEdit._previewModel.fFOV = tab.ffov
			PSItemEdit._previewModel.BGColor = tab.bgcolor
			
			GLOBALPOS = tab
		end
		grid:AddItem( but )
	end
	
	local Mixer = vgui.Create("DColorMixer", ButtonsList)
	Mixer:SetSize(267,186)
	Mixer:Dock(TOP)
	Mixer:SetPalette(true)
	Mixer:SetAlphaBar(false)
	Mixer:SetWangs(true)
	Mixer:SetColor( GLOBALPOS.bgcolor )
	Mixer.ValueChanged = function(s, color)
		GLOBALPOS.bgcolor = color 
	end

end)