function TTS.Functions.ItemPreview(item)
 
	-- if IsValid(m_pnlFillingPoints.preview) then m_pnlFillingPoints.preview:Remove() end 
	if IsValid(m_pnlFillingPoints) then m_pnlFillingPoints:Remove() end 
	m_pnlFillingPoints = vgui.Create('.CCFrame') 
	m_pnlFillingPoints:SetSize(300,400)
	m_pnlFillingPoints:Center() 
	m_pnlFillingPoints:SetZPos( 2 )
	m_pnlFillingPoints:SetTitle("Превью предмета")
	m_pnlFillingPoints:MakePopup()
	m_pnlFillingPoints.OnFocusChanged = function(s, b)
		timer.Simple(0, function()
			if IsValid(s) then
				if !b and (s.preview && !s.preview:HasFocus()) then
				-- if !b then
					if IsValid(m_pnlFillingPoints.preview.attached) then
						m_pnlFillingPoints.preview.attached:Remove()
					end
					s:Remove()
				end
			end
		end)
	end
	
	if LocalPlayer():SteamID() == 'STEAM_0:1:48023335' then
		m_pnlFillingPoints:SetSize(1000,1000)
		m_pnlFillingPoints:Center() 
	end
	if item.type == 'taunt' then
		
		m_pnlFillingPoints.cpanscroll = vgui.Create("DScrollPanel", m_pnlFillingPoints)
		m_pnlFillingPoints.cpanscroll:Dock(FILL)
		m_pnlFillingPoints.cpanscroll.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,150))
		end
		
		local model = vgui.Create('DButton', m_pnlFillingPoints.cpanscroll)
		model:SetSize(0, 40)
		model:Dock(TOP)
		model:DockMargin(0,0,0,5)
		model:SetText("")
		model.ID = i
		model.LerpedColor = Vector(0,0,0)
		model.LerpedColorA = 0
		model.s = false
		model.bulbul = 0
		model.Paint = function(s2,w,h)			
			local col = Color(35, 35, 35,0)
			local text = 'Позитивное'
			
			if s2.s then
				col.a = 50
			end
			local max = 1
			
			local per = CurTime()-s2.bulbul
			if per <= max then 
			  s2.LerpedColor = Vector(100/255,100/255,253/255) 
			  s2.LerpedColorA = 255
			end
			-- if s2.data.id == id then					
			if per > max then
				per = max 
				s2.LerpedColor = LerpVector(FrameTime()*7, s2.LerpedColor, Vector(0,0,0) )
				s2.LerpedColorA = Lerp(FrameTime()*9, s2.LerpedColorA, 0 )
			end
			
			local a = s2.LerpedColor:ToColor()
			a.a = s2.LerpedColorA
			draw.RoundedBox( 0, 0+((w/2)-((w/(max*2))*per)), 0, (w/(max))*per, 50, a )
			-- end
			
			draw.RoundedBox(0, 0, 0, w, h, col)
			
			draw.SimpleText(text, 'S_Regular_20', w/2, (h/2), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		model.OnCursorEntered = function(s) s.s = true end
		model.OnCursorExited = function(s) s.s = false end
		model.DoClick = function(s2)
			if (CurTime()-s2.bulbul) <= 1 then return end
			s2.bulbul = CurTime()
			netstream.Start('TTS::TauntPreview', item.data.taunt, 'positive')
			-- RunConsoleCommand('ph_taunt', v.id)
		end
		m_pnlFillingPoints.cpanscroll:AddItem(model)
		local model = vgui.Create('DButton', m_pnlFillingPoints.cpanscroll)
		model:SetSize(0, 40)
		model:Dock(TOP)
		model:DockMargin(0,0,0,5)
		model:SetText("")
		model.ID = i
		model.LerpedColor = Vector(0,0,0)
		model.LerpedColorA = 0
		model.s = false
		model.bulbul = 0
		model.Paint = function(s2,w,h)			
			local col = Color(35, 35, 35,0)
			local text = 'Негативное'
			
			if s2.s then
				col.a = 50
			end
			local max = 1
			
			local per = CurTime()-s2.bulbul
			if per <= max then 
			  s2.LerpedColor = Vector(100/255,100/255,253/255) 
			  s2.LerpedColorA = 255
			end
			-- if s2.data.id == id then					
			if per > max then
				per = max 
				s2.LerpedColor = LerpVector(FrameTime()*7, s2.LerpedColor, Vector(0,0,0) )
				s2.LerpedColorA = Lerp(FrameTime()*9, s2.LerpedColorA, 0 )
			end
			
			local a = s2.LerpedColor:ToColor()
			a.a = s2.LerpedColorA
			draw.RoundedBox( 0, 0+((w/2)-((w/(max*2))*per)), 0, (w/(max))*per, 50, a )
			-- end
			
			draw.RoundedBox(0, 0, 0, w, h, col)
			
			draw.SimpleText(text, 'S_Regular_20', w/2, (h/2), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		model.OnCursorEntered = function(s) s.s = true end
		model.OnCursorExited = function(s) s.s = false end
		model.DoClick = function(s2)
			if (CurTime()-s2.bulbul) <= 1 then return end
			s2.bulbul = CurTime()
			netstream.Start('TTS::TauntPreview', item.data.taunt, 'death')
			-- RunConsoleCommand('ph_taunt', v.id)
		end
		m_pnlFillingPoints.cpanscroll:AddItem(model)
		local model = vgui.Create('DButton', m_pnlFillingPoints.cpanscroll)
		model:SetSize(0, 40)
		model:Dock(TOP)
		model:DockMargin(0,0,0,5)
		model:SetText("")
		model.ID = i
		model.LerpedColor = Vector(0,0,0)
		model.LerpedColorA = 0
		model.s = false
		model.bulbul = 0
		model.Paint = function(s2,w,h)			
			local col = Color(35, 35, 35,0)
			local text = 'При убийстве'
			
			if s2.s then
				col.a = 50
			end
			local max = 1
			
			local per = CurTime()-s2.bulbul
			if per <= max then 
			  s2.LerpedColor = Vector(100/255,100/255,253/255) 
			  s2.LerpedColorA = 255
			end
			-- if s2.data.id == id then					
			if per > max then
				per = max 
				s2.LerpedColor = LerpVector(FrameTime()*7, s2.LerpedColor, Vector(0,0,0) )
				s2.LerpedColorA = Lerp(FrameTime()*9, s2.LerpedColorA, 0 )
			end
			
			local a = s2.LerpedColor:ToColor()
			a.a = s2.LerpedColorA
			draw.RoundedBox( 0, 0+((w/2)-((w/(max*2))*per)), 0, (w/(max))*per, 50, a )
			-- end
			
			draw.RoundedBox(0, 0, 0, w, h, col)
			
			draw.SimpleText(text, 'S_Regular_20', w/2, (h/2), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		model.OnCursorEntered = function(s) s.s = true end
		model.OnCursorExited = function(s) s.s = false end
		model.DoClick = function(s2)
			if (CurTime()-s2.bulbul) <= 1 then return end
			s2.bulbul = CurTime()
			netstream.Start('TTS::TauntPreview', item.data.taunt, 'kill')
			-- RunConsoleCommand('ph_taunt', v.id)
		end
		m_pnlFillingPoints.cpanscroll:AddItem(model)

	elseif item.type == 'attacheffect' then
		
		
		m_pnlFillingPoints.preview = vgui.Create("DShopPreview", m_pnlFillingPoints)
		m_pnlFillingPoints.preview:Dock(FILL)
		
		m_pnlFillingPoints.preview.DrawOtherModels = function( s, ent )
			local ent = s.Entity
			if !ent.Particle then
				-- PrintTable(item)
				-- local c_Model = ClientsideModel("models/props_junk/PlasticCrate01a.mdl", RENDERGROUP_OPAQUE)
				-- c_Model:SetNoDraw(true)
				-- c_Model:SetParent(ent)
				
				-- ParticleEffectAttach('superrare_circling_heart', PATTACH_ABSORIGIN_FOLLOW, c_Model, 1)
				-- ent.Particle = c_Model
				-- PrintTable(ent:GetAttachment(ent:LookupAttachment('eyes')))
				local obj = ent:LookupAttachment(item.data.attach)
				local pos = ent:GetAttachment( obj ).Pos
				-- print(pos, s.EntPos)
				local finalpos = pos + s.EntPos * -1
				-- print(finalpos)
				if item.data.lua then
					local effect = TTS.Shop.effects.Get( item.data.effect )
					if effect then
						ent.Particle = effect:Run(Vector(0,0,0), ent)
					end
				else
					ent.Particle = CreateParticleSystem( ent, item.data.effect, PATTACH_ABSORIGIN_FOLLOW, obj, finalpos + Vector(item.data.pos.x or 0,item.data.pos.y or 0,item.data.pos.z or 0) )
					ent.Particle:SetShouldDraw( false )
				end
				-- ent.Particle = CreateParticleSystem( ent, item.data.effect, PATTACH_ABSORIGIN_FOLLOW, obj, finalpos + Vector(item.data.pos.x or 0,item.data.pos.y or 0,item.data.pos.z or 0) )
			end
			-- ent.Particle:DrawModel()
			-- ent.Particle:Render()
			if item.data.lua then
				ent.DisableDraw = true
				ent.Particle:think()
				ent.Particle:SetPos(Vector(0,0,32))
			else
				ent.Particle:Render()
			end
		end

	end

	if item.type == 'model' then
		m_pnlFillingPoints:SetSize(500,400)
		
		m_pnlFillingPoints.preview = vgui.Create("DShopPreview", m_pnlFillingPoints)
		m_pnlFillingPoints.preview:SetZPos( 100 )
		m_pnlFillingPoints.preview.ent = item.data.mdl
		m_pnlFillingPoints.preview:SetModel(item.data.mdl)
		m_pnlFillingPoints.preview:Dock(FILL)
		local Ent = m_pnlFillingPoints.preview.Entity
		
		
		m_pnlFillingPoints.cpanscroll = vgui.Create("DScrollPanel", m_pnlFillingPoints)
		m_pnlFillingPoints.cpanscroll:SetSize( 200, 400 )
		m_pnlFillingPoints.cpanscroll:Dock(RIGHT)
		m_pnlFillingPoints.cpanscroll.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,150))
		end
		
		local allowedbodygroups = {} 
		for i = 1, #Ent:GetBodyGroups() do
			local bg = Ent:GetBodyGroups()[i]
			if bg then
				for k,v in pairs( bg ) do
					if k == "id" then
						allowedbodygroups[v] = {}
						for k2, v2 in pairs( bg["submodels"] ) do
							table.insert( allowedbodygroups[v], k2 )
						end
					end
				end	
			end
		end
		local createdDlabel
		local count = 0
		if allowedbodygroups ~= {} then
			for k,v in pairs( allowedbodygroups ) do
				if table.Count(v) == 1 then continue end
				
				count = count + 1
				if !createdDlabel then
					createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
					createdDlabel:Dock( TOP )
					createdDlabel:SetFont( "S_Light_15" )
					createdDlabel:SetText( 'Доступные бодигруппы' )
					createdDlabel:DockMargin(5, 5, 0, 0)
					m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
				end
				-- local DLabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
				-- DLabel:Dock( TOP )
				-- DLabel:SetText( Ent:GetBodygroupName( k ) )
				-- m_pnlFillingPoints.cpanscroll:AddItem(DLabel)
				
				local DComboBox = vgui.Create( ".CCDropDown", m_pnlFillingPoints.cpanscroll )
				DComboBox.Text = Ent:GetBodygroupName( k )
				DComboBox.AnotherText = true
				DComboBox:Dock( TOP )
				DComboBox:DockMargin(0, 5, 0, 0)
				DComboBox:SetSize( 100, 40 )
				for k2,v2 in pairs( v ) do
					DComboBox:AddChoice( v2, k )
				end
				DComboBox.OnSelect = function( panel, index, aa )
					local data, sec = panel:GetSelected()
					
					Ent:SetBodygroup(sec, data)
				end
				m_pnlFillingPoints.cpanscroll:AddItem(DComboBox)
			end
		end
		if count == 0 then
			createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
			createdDlabel:Dock( TOP )
			createdDlabel:SetFont( "S_Light_15" )
			createdDlabel:SetText( 'Нет доступных бодигрупп' )
			createdDlabel:DockMargin(5, 5, 0, 0)
			m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
		end
		local createdDlabel
		if ( Ent:SkinCount() > 1 ) then
		
			if !createdDlabel then
				createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Доступные скины' )
				createdDlabel:DockMargin(5, 5, 0, 0)
				m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
			end
			
			local combo = vgui.Create( ".CCDropDown", m_pnlFillingPoints.cpanscroll )
			combo.Text = 'Выбор скина'
			combo:Dock( TOP )
			combo:SetSize( 100, 40 )

			for l = 0, Ent:SkinCount() - 1 do
				combo:AddChoice( "Скин " .. l, function()
					Ent:SetSkin(l)
				end )
			end
			
			combo.OnSelect = function( pnl, index, value, data ) data()	end
			m_pnlFillingPoints.cpanscroll:AddItem(combo)

		else
			createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
			createdDlabel:Dock( TOP )
			createdDlabel:SetFont( "S_Light_15" )
			createdDlabel:SetText( 'Нет доступных скинов' )
			createdDlabel:DockMargin(5, 5, 0, 0)
			m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
		end
	end
	
	if item.type == 'swep' then
		-- PrintTable(item)
		-- print(item.data.swep)
		local swep = table.Copy(weapons.Get(item.data.swep))
	
		-- PrintTable(swep)
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
			m_pnlFillingPoints.preview = vgui.Create("DShopPreview", m_pnlFillingPoints)
			m_pnlFillingPoints.preview:SetZPos( 100 )
			m_pnlFillingPoints.preview.ent = mdl
			m_pnlFillingPoints.preview:SetModel(mdl)
			m_pnlFillingPoints.preview:Dock(FILL)
			m_pnlFillingPoints.preview.EntAngle = -90
			m_pnlFillingPoints.preview.EntPos = Vector(0,0,30)
			
			local skin = swep.w_skin
			if skin ~= nil and skin ~= 'none' then
				if skin == '!' then
					local niceid = TFA.CSGO.Skins[swep.tfabase][swep.tfaname]['id']
					skin = niceid
					TFA.CSGO.LoadCachedVMT( string.sub(niceid, 2, -1) )
				end
								
				m_pnlFillingPoints.preview.LayoutEntity = function()
					render.MaterialOverride( Material(skin) ) 
				end
			end
		end
	end
	
	if item.type == 'attach' then
		m_pnlFillingPoints:SetSize(500,400)
		
		m_pnlFillingPoints.preview = vgui.Create("DShopPreview", m_pnlFillingPoints)
		m_pnlFillingPoints.preview:SetZPos( 100 )
		m_pnlFillingPoints.preview:Dock(FILL)
		m_pnlFillingPoints.preview.DrawOtherModels = function()
			local model = m_pnlFillingPoints.preview.attached
			if IsValid(model) and model.ToDrawning then
				model:DrawModel()
				return
			end
			model = ClientsideModel(item.data.mdl, RENDERGROUP_TRANSLUCENT)
			model:SetNoDraw(true)
			
			local pos = Vector()
			local ang = Angle()
			
			if item.data.attach then
				local attach_id = m_pnlFillingPoints.preview.Entity:LookupAttachment(item.data.attach)
				if not attach_id then return end
				
				local attach = m_pnlFillingPoints.preview.Entity:GetAttachment(attach_id)
				
				if not attach then return end
				
				model:SetMoveType( MOVETYPE_NONE )
				model:SetParent( m_pnlFillingPoints.preview.Entity, attach_id )
				
				-- pos = attach.Pos
				-- ang = attach.Ang
			else
				local bone_id = m_pnlFillingPoints.preview.Entity:LookupBone(item.data.bone)
				if not bone_id then return end
				-- m_pnlFillingPoints.preview.Entity:AddEffects( EF_FOLLOWBONE )
				-- model:SetMoveType( MOVETYPE_NONE )
				-- model:SetParent( m_pnlFillingPoints.preview.Entity, bone_id )
				
				model:SetMoveType( MOVETYPE_NONE )
				-- model:SetParent( preview.Entity, bone_id )
				model:FollowBone(m_pnlFillingPoints.preview.Entity, bone_id)
				-- pos, ang = m_pnlFillingPoints.preview.Entity:GetBonePosition(bone_id)
			end
			
			if item.data.scale then
				model:SetModelScale(item.data.scale or 1, 0)
			end
			if item.data.pos.x then
				pos = pos + (ang:Forward() * item.data.pos.x) 
			end
			if item.data.pos.y then
				pos = pos + (ang:Right() * item.data.pos.y) 
			end
			if item.data.pos.z then
				pos = pos + (ang:Up() * item.data.pos.z) 
			end
			
			if item.data.ang.p then
				ang:RotateAroundAxis(ang:Up(), item.data.ang.p)
			end
			if item.data.ang.y then
				ang:RotateAroundAxis(ang:Right(), item.data.ang.y)
			end
			if item.data.ang.r then
				ang:RotateAroundAxis(ang:Forward(), item.data.ang.r)
			end
			
			model:SetLocalPos(pos)
			model:SetLocalAngles(ang)
			model.ToDrawning = true
			m_pnlFillingPoints.preview.attached = model
			-- model:SetPos(pos)
			-- model:SetAngles(ang)
			
			local Ent = model
		
			m_pnlFillingPoints.cpanscroll = vgui.Create("DScrollPanel", m_pnlFillingPoints)
			m_pnlFillingPoints.cpanscroll:SetSize( 200, 400 )
			m_pnlFillingPoints.cpanscroll:Dock(RIGHT)
			m_pnlFillingPoints.cpanscroll.Paint = function( s, w, h ) end
			
			local allowedbodygroups = {}
			for i = 1, #Ent:GetBodyGroups() do
				local bg = Ent:GetBodyGroups()[i]
				if bg then
					for k,v in pairs( bg ) do
						if k == "id" then
							allowedbodygroups[v] = {}
							for k2, v2 in pairs( bg["submodels"] ) do
								table.insert( allowedbodygroups[v], k2 )
							end
						end
					end	
				end
			end
			local createdDlabel
			local count = 0
			if allowedbodygroups ~= {} then
				for k,v in pairs( allowedbodygroups ) do
					if table.Count(v) == 1 then continue end
					
					count = count + 1
					if !createdDlabel then
						createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
						createdDlabel:Dock( TOP )
						createdDlabel:SetFont( "S_Light_15" )
						createdDlabel:SetText( 'Доступные бодигруппы' )
						createdDlabel:DockMargin(5, 5, 0, 0)
						m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
					end
					-- local DLabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
					-- DLabel:Dock( TOP )
					-- DLabel:SetText( Ent:GetBodygroupName( k ) )
					-- m_pnlFillingPoints.cpanscroll:AddItem(DLabel)
					
					local DComboBox = vgui.Create( ".CCDropDown", m_pnlFillingPoints.cpanscroll )
					DComboBox.Text = Ent:GetBodygroupName( k )
					DComboBox.AnotherText = true
					DComboBox:Dock( TOP )
					DComboBox:DockMargin(0, 5, 0, 0)
					DComboBox:SetSize( 100, 40 )
					for k2,v2 in pairs( v ) do
						DComboBox:AddChoice( v2, k )
					end
					DComboBox.OnSelect = function( panel, index, aa )
						local data, sec = panel:GetSelected()
						
						Ent:SetBodygroup(sec, data)
					end
					m_pnlFillingPoints.cpanscroll:AddItem(DComboBox)
				end
			end
			if count == 0 then
				createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Нет доступных бодигрупп' )
				createdDlabel:DockMargin(5, 5, 0, 0)
				m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
			end
			local createdDlabel
			if ( Ent:SkinCount() > 1 ) then
			
				if !createdDlabel then
					createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
					createdDlabel:Dock( TOP )
					createdDlabel:SetFont( "S_Light_15" )
					createdDlabel:SetText( 'Доступные скины' )
					createdDlabel:DockMargin(5, 5, 0, 0)
					m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
				end
				
				local combo = vgui.Create( ".CCDropDown", m_pnlFillingPoints.cpanscroll )
				combo.Text = 'Выбор скина'
				combo:Dock( TOP )
				combo:SetSize( 100, 40 )

				for l = 0, Ent:SkinCount() - 1 do
					combo:AddChoice( "Скин " .. l, function()
						Ent:SetSkin(l)
					end )
				end
				
				combo.OnSelect = function( pnl, index, value, data ) data()	end
				m_pnlFillingPoints.cpanscroll:AddItem(combo)

			else
				createdDlabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Нет доступных скинов' )
				createdDlabel:DockMargin(5, 5, 0, 0)
				m_pnlFillingPoints.cpanscroll:AddItem(createdDlabel)
			end
		end
	end
end