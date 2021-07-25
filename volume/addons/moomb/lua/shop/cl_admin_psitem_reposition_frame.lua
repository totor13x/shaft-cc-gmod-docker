
concommand.Add("ps_items_reposition", function()

if IsValid(PSItemEdit) then
	PSItemEdit:Remove()
end

-- GLOBALPOS = GLOBALPOS or { 
GLOBALPOS = { 
	campos = Vector( -90, 0, 0 ),
	camlookang = Angle( 0, 0, 0 ),
	ffov = 70,
	bgcolor = Color(255,255,255)
}

PSItemEdit = vgui.Create( ".CCFrame" )
PSItemEdit:SetSize( 1280, 720)
PSItemEdit:Center()
PSItemEdit:SetTitle( "Item Editor" )
PSItemEdit:MakePopup()

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
			DButton.DoClick = function(s)
				-- PSItemEdit._previewModel.LayoutEntity = function() end
				if IsValid(PSItemEdit.preview) then
					PSItemEdit.preview:Remove()
				end
				if IsValid(PSItemEdit.cpanscroll) then
					PSItemEdit.cpanscroll:Remove()
				end
				local item = v
				if v.type == 'attach' then
					local preview = vgui.Create("DShopPreview", PSItemEdit)
					preview:SetZPos( 100 )
					preview:Dock(FILL)
					preview.Entity:SetModel('models/player/kleiner.mdl') 
					PSItemEdit.preview = preview
					preview.DrawOtherModels = function()
						local model = preview.attached
						if IsValid(model) and model.ToDrawning then
							model:DrawModel()
							return
						end
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
						if item.data.attach and item.data.attach ~= 'chest' then
							local attach_id = preview.Entity:LookupAttachment(item.data.attach)
							if not attach_id then return end
							
							local attach = preview.Entity:GetAttachment(attach_id)
							
							if not attach then return end
							
							model:SetMoveType( MOVETYPE_NONE )
							model:SetParent( preview.Entity, attach_id )
							
							-- pos = attach.Pos
							-- ang = attach.Ang
						else
							local bone = item.data.bone
							if item.data.attach and item.data.attach == 'chest' then
								bone = 'ValveBiped.Bip01_Spine4'
								-- for i = 0, ent:GetBoneCount() - 1 do
									-- print( ent, i, ent:GetBoneName( i ) )
								-- end
							end
							local bone_id = preview.Entity:LookupBone(bone)
							if not bone_id then return end
							-- preview.Entity:AddEffects( EF_FOLLOWBONE )
							model:SetMoveType( MOVETYPE_NONE )
							-- model:SetParent( preview.Entity, bone_id )
							model:FollowBone(preview.Entity, bone_id)
							
							-- pos, ang = m_pnlFillingPoints.preview.Entity:GetBonePosition(bone_id)
						end
						
						-- model:SetLocalPos(pos)
						-- model:SetLocalAngles(ang)
						model.ToDrawning = true
						preview.attached = model
						-- model:SetPos(pos)
						-- model:SetAngles(ang)
						
						local Ent = model
						
						cpanscroll = vgui.Create("DScrollPanel", PSItemEdit)
						cpanscroll:SetSize( 400, 400 )
						cpanscroll:Dock(RIGHT)
						cpanscroll.Paint = function( s, w, h ) end
						
						local PosRes = vgui.Create(".CCButton", cpanscroll)
						PosRes:Dock( TOP )
						PosRes:SetSize(40, 40)
						PosRes.Text =  "Save" 
						PosRes.Font =  "S_Light_15" 
						PosRes.FakeActivated =  true
						PosRes:SetBorders(false)
						PosRes.DoClick = function(s)
							netstream.Start('TTS::ItemDataSave', {
								id = item.id,
								name = cpanscroll.Name:GetText(),
								scale = math.Round(model:GetModelScale(), 2),
								pos = model.OPos,
								ang = model.OAng,
							})
						end 
						
						local TextEntry = vgui.Create( ".CCTextEntry", cpanscroll )
						TextEntry:Dock(TOP)
						TextEntry:DockMargin( 0, 5, 0, 5 )
						TextEntry:SetSize( 200, 35 )
						TextEntry:SetText( item.name )
						TextEntry.Font = "S_Light_20"
						TextEntry.FakeActivated =  true
						TextEntry:SetPlaceholderText( "Название" )
						TextEntry:SetTextColor( Color(255,255,255) )
						cpanscroll.Name = TextEntry
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'MDL: ' .. item.data.mdl )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Scale: ' .. item.data.scale )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Pos X: ' .. item.data.pos.x )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Pos Y: ' .. item.data.pos.y )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Pos Z: ' .. item.data.pos.z )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Ang P: ' .. item.data.ang.p )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Ang Y: ' .. item.data.ang.y )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
						local clcl = vgui.Create( "DLabel", cpanscroll )
						clcl:Dock( TOP )
						clcl:SetFont( "S_Bold_15" )
						clcl:SetText( 'Ang R: ' .. item.data.ang.r )
						-- clcl:DockMargin(5, 5, 0, 0)
						cpanscroll:AddItem(clcl)
						
		-- Scale  
		local div =  vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end
		
		local Scale = vgui.Create(".CCNumSlider", div)
		-- Scale:SetPos( 5, y ) 
		Scale:Dock( FILL )
		Scale:SetSize( 0, 40 )
		-- Scale:SetSize(self.cpanscroll:GetWide()-40-10, 40) 
		Scale:SetText( "Размер пропа" )
		Scale:SetMinMax( 0, 3 )
		Scale:SetDecimals( 3 )
		Scale:SetValue( item.data.scale )
		Scale.OnValueChanged = function(s, num)
			model:SetModelScale(num, 0)
		end
		Scale:OnValueChanged(Scale:GetValue())

		local ScaleRes = vgui.Create(".CCButton", div)
		ScaleRes:Dock( RIGHT )
		ScaleRes:SetSize(40, 40)
		ScaleRes.Text =  "RESET" 
		ScaleRes.Font =  "S_Light_15" 
		ScaleRes.FakeActivated =  true 
		ScaleRes:SetBorders(false)
		ScaleRes.DoClick = function(s)
			Scale:SetValue( item.data.scale )
		end
		
		local ScaleRes = vgui.Create(".CCButton", div)
		ScaleRes:Dock( RIGHT )
		ScaleRes:SetSize(40, 40)
		ScaleRes.Text =  "1" 
		ScaleRes.Font =  "S_Light_15"
		ScaleRes.FakeActivated = true
		ScaleRes:SetBorders(false)
		ScaleRes.DoClick = function(s)
			Scale:SetValue( 1 )
		end
		
		-- PosX 
		local div = vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local Pos = vgui.Create(".CCNumSlider", div)
		Pos:Dock( FILL )
		Pos:SetSize( 0, 40 )
		Pos:SetText( "Pos X" )
		Pos:SetMinMax( -20, 20 )
		Pos:SetDecimals( 3 )
		Pos:SetValue( item.data.pos.x )
		Pos.OnValueChanged = function(s, num)
			model:ReloadPos(num, model.OPos.y, model.OPos.z) 
		end
		Pos:OnValueChanged(Pos:GetValue())

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "RESET" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue( item.data.pos.x )
		end 
		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "0" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue( 0 )
		end 
		
		-- PosY 
		local div = vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local Pos = vgui.Create(".CCNumSlider", div)
		Pos:Dock( FILL )
		Pos:SetSize( 0, 40 )
		Pos:SetText( "Pos Y" )
		Pos:SetMinMax( -20, 20 )
		Pos:SetDecimals( 3 )
		Pos:SetValue( item.data.pos.y )
		Pos.OnValueChanged = function(s, num)
			model:ReloadPos(model.OPos.x, num, model.OPos.z) 
		end
		Pos:OnValueChanged(Pos:GetValue())

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "RESET" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue(item.data.pos.y)
		end 

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "0" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue( 0 )
		end 

		
		-- PosZ 
		local div = vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local Pos = vgui.Create(".CCNumSlider", div)
		Pos:Dock( FILL )
		Pos:SetSize( 0, 40 )
		Pos:SetText( "Pos Z" )
		Pos:SetMinMax( -20, 20 )
		Pos:SetDecimals( 3 )
		Pos:SetValue( item.data.pos.z )
		Pos.OnValueChanged = function(s, num)
			model:ReloadPos(model.OPos.x, model.OPos.y, num) 
		end
		Pos:OnValueChanged(Pos:GetValue())

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "RESET" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue(item.data.pos.z)
		end 
		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "0" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue( 0 )
		end 

		-- AngX 
		local div = vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
	
		local Ang = vgui.Create(".CCNumSlider", div)
		Ang:Dock( FILL )
		Ang:SetSize( 0, 40 )
		Ang:SetText( "Ang X" )
		Ang:SetMinMax( -180, 180 )
		Ang:SetDecimals( 0 )
		Ang:SetValue( item.data.ang.p )
		Ang.OnValueChanged = function(s, num)
			model:ReloadAng(num, model.OAng.y, model.OAng.r)
		end
		Ang:OnValueChanged(Ang:GetValue())

		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "RESET" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue( item.data.ang.p )
		end 
		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "0" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue( 0 )
		end 
		
		
		-- AngY  
		local div = vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
				
		local Ang = vgui.Create(".CCNumSlider", div)
		Ang:Dock( FILL )
		Ang:SetSize( 0, 40 )
		Ang:SetText( "Ang Y" )
		Ang:SetMinMax( -180, 180 )
		Ang:SetDecimals( 0 )
		Ang:SetValue( item.data.ang.y )
		Ang.OnValueChanged = function(s, num)
			model:ReloadAng(model.OAng.p, num, model.OAng.r)
		end
		Ang:OnValueChanged(Ang:GetValue())

		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "RESET" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue( item.data.ang.y )
		end 
		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "0" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue( 0 )
		end 
		
		-- AngZ
		local div = vgui.Create('DPanel', cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local Ang = vgui.Create(".CCNumSlider", div)
		Ang:Dock( FILL )
		Ang:SetSize( 0, 40 )
		Ang:SetText( "Ang R" )
		Ang:SetMinMax( -180, 180 )
		Ang:SetDecimals( 0 )
		Ang:SetValue( item.data.ang.r )
		Ang.OnValueChanged = function(s, num)
			model:ReloadAng(model.OAng.p, model.OAng.y, num)
		end
		Ang:OnValueChanged(Ang:GetValue())

		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "RESET" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue( item.data.ang.r )
		end 
		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "0" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue( 0 )
		end 
		
						PSItemEdit.cpanscroll = cpanscroll
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
									createdDlabel = vgui.Create( "DLabel", cpanscroll )
									createdDlabel:Dock( TOP )
									createdDlabel:SetFont( "S_Light_15" )
									createdDlabel:SetText( 'Доступные бодигруппы' )
									createdDlabel:DockMargin(5, 5, 0, 0)
									cpanscroll:AddItem(createdDlabel)
								end
								-- local DLabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
								-- DLabel:Dock( TOP )
								-- DLabel:SetText( Ent:GetBodygroupName( k ) )
								-- m_pnlFillingPoints.cpanscroll:AddItem(DLabel)
								
								local DComboBox = vgui.Create( ".CCDropDown", cpanscroll )
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
								cpanscroll:AddItem(DComboBox)
							end
						end
						if count == 0 then
							createdDlabel = vgui.Create( "DLabel", cpanscroll )
							createdDlabel:Dock( TOP )
							createdDlabel:SetFont( "S_Light_15" )
							createdDlabel:SetText( 'Нет доступных бодигрупп' )
							createdDlabel:DockMargin(5, 5, 0, 0)
							cpanscroll:AddItem(createdDlabel)
						end
						local createdDlabel
						if ( Ent:SkinCount() > 1 ) then
						
							if !createdDlabel then
								createdDlabel = vgui.Create( "DLabel", cpanscroll )
								createdDlabel:Dock( TOP )
								createdDlabel:SetFont( "S_Light_15" )
								createdDlabel:SetText( 'Доступные скины' )
								createdDlabel:DockMargin(5, 5, 0, 0)
								cpanscroll:AddItem(createdDlabel)
							end
							
							local combo = vgui.Create( ".CCDropDown", cpanscroll )
							combo.Text = 'Выбор скина'
							combo:Dock( TOP )
							combo:SetSize( 100, 40 )

							for l = 0, Ent:SkinCount() - 1 do
								combo:AddChoice( "Скин " .. l, function()
									Ent:SetSkin(l)
								end )
							end
							
							combo.OnSelect = function( pnl, index, value, data ) data()	end
							cpanscroll:AddItem(combo)

						else
							createdDlabel = vgui.Create( "DLabel", cpanscroll )
							createdDlabel:Dock( TOP )
							createdDlabel:SetFont( "S_Light_15" )
							createdDlabel:SetText( 'Нет доступных скинов' )
							createdDlabel:DockMargin(5, 5, 0, 0)
							cpanscroll:AddItem(createdDlabel)
						end
					end
					
					
					
				end
			end
			DGrid:AddItem(DButton)
			DScrollPanel:AddItem( DButton )
		end
	end)
end)