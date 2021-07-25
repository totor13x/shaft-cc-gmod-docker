
local visiblePlayers = {}
local allowedViewCS = {}

equippedCS = equippedCS or {}
toDrawItem = toDrawItem or {}
itemStore = itemStore or {}

local function hideItem (ply)
	allowedViewCS[ply] = nil
end

local function removeItem (ent, item_id, item_data)
	if IsValid(toDrawItem[ent][item_id]) then
		if item_data.type == 'attacheffect' then
			if !item_data.data.lua then
				toDrawItem[ent][item_id].Particle:StopEmissionAndDestroyImmediately()
				toDrawItem[ent][item_id]:Remove()
			end
		elseif item_data.type == 'attach' then
			toDrawItem[ent][item_id]:Remove()
		end
	end
end

local function addItemsToDraw(ent, item_data, item_id)
	if not IsValid(ent) or not ent:Alive() then return end
	-- print('asdasd', IsValid(toDrawItem[ent][item_id]))
	local item = item_data.item
	local modifiers = item_data.modifiers
	
	removeItem(ent, item_id, item)
	-- PrintTable(item)
	-- PrintTable(item)
	if item.type == 'attacheffect' then
		-- print(item.data.attach)
		
		local obj = ent:LookupAttachment(item.data.attach)
		if obj == 0 then
			obj = ent:LookupAttachment('eyes')
		end
		local wpos = ent:GetAttachment( obj ).Pos
		local ang = ent:GetAttachment( obj ).Ang 
		
		local pos = ent:WorldToLocal( wpos )
		if item.data.pos.x then
			pos = pos + (ang:Forward() * item.data.pos.x) 
		end
		if item.data.pos.y then
			pos = pos + (ang:Right() * item.data.pos.y) 
		end
		if item.data.pos.z then
			pos = pos + (ang:Up() * item.data.pos.z) 
		end
		-- local finalpos = pos + s.EntPos * -1
		if item.data.lua then
			local effect = TTS.Shop.effects.Get( item.data.effect )
			if effect then
				toDrawItem[ent][item_id] = effect:Run(pos, ent)
			end
		else
			local orb = ClientsideModel('models/hunter/misc/sphere025x025.mdl', RENDERGROUP_OTHER)
			orb:SetMaterial('models/shiny')
			orb:SetRenderMode(RENDERMODE_TRANSALPHA)
			orb:SetMoveType( MOVETYPE_NONE )
			orb:SetPos( ent:GetPos() )
			orb:SetAngles( ent:GetAngles() )
			orb.Ent = ent
			-- orb:SetAngles( Angle(0,0,0) )
			-- PrintTable(orb:GetAttachments())
			-- print(item.data.attach)
			if item.data.attach == 'chest' then
				local bone_id = ent:LookupBone('ValveBiped.Bip01_Spine')
				if not bone_id then return end
				-- orb:SetMoveType( MOVETYPE_NONE )
				-- model:SetParent( preview.Entity, bone_id )
				orb:FollowBone(ent, bone_id)
			else
				orb:SetParent( ent, obj )
			end
			orb:SetNoDraw(true)
			orb.RenderOverride = function(s)
				-- if IsValid(s.Ent) then
					-- s:SetAngles(s.Ent:EyeAngles())
					-- s:SetPos(s.Ent:GetPos())
				-- end
			end
			
			orb.Particle = CreateParticleSystem( orb, item.data.effect, PATTACH_POINT_FOLLOW, 0, Vector(0,0,0) )
			orb.Particle:SetShouldDraw( false )
			
			toDrawItem[ent][item_id] = orb
		end
	elseif item.type == 'attach' then
		local model = ClientsideModel(item.data.mdl, RENDERGROUP_TRANSLUCENT)
		model:SetNoDraw(true)
		
		local pos = Vector(0,0,0)
		local ang = Angle(0,0,0)
		
		if item.data.attach and item.data.attach ~= 'chest' then
			local attach_id = ent:LookupAttachment(item.data.attach)
			if not attach_id then return end
			
			local attach = ent:GetAttachment(attach_id)
			
			if not attach then return end
			
			model:SetMoveType( MOVETYPE_NONE )
			model:SetParent( ent, attach_id )
		else
			local bone = item.data.bone
			if item.data.attach and item.data.attach == 'chest' then
				bone = 'ValveBiped.Bip01_Spine4'
				-- for i = 0, ent:GetBoneCount() - 1 do
					-- print( ent, i, ent:GetBoneName( i ) )
				-- end
			end
			local bone_id = ent:LookupBone(bone)
			if not bone_id then return end
			model:SetMoveType( MOVETYPE_NONE )
			-- model:SetParent( preview.Entity, bone_id )
			model:FollowBone(ent, bone_id)
		end
		if item.data.scale then
			model:SetModelScale(item.data.scale, 0)
		end
		-- if item.data.pos.x then
			pos = pos + (ang:Forward() * item.data.pos.x or 0) 
		-- end
		-- if item.data.pos.y then
			pos = pos + (ang:Right() * item.data.pos.y or 0) 
		-- end
		-- if item.data.pos.z then
			pos = pos + (ang:Up() * item.data.pos.z or 0) 
		-- end
		
		-- if item.data.ang.p then
			ang:RotateAroundAxis(ang:Up(), item.data.ang.p or 0)
		-- end
		-- if item.data.ang.y then
			ang:RotateAroundAxis(ang:Right(), item.data.ang.y or 0)
		-- end
		-- if item.data.ang.r then
			ang:RotateAroundAxis(ang:Forward(), item.data.ang.r or 0)
		-- end
		-- print(ang, pos)
		
		
		-- local pos = model.ModifyPos
		-- local ang = Angle(0,0,0)
		-- model.ModifyAngles:Set(ang)

		-- local scale = modifiers.ModifyScale
		
		if modifiers.ScaleC then
			model:SetModelScale(modifiers.ScaleC, 0)
		end
		if modifiers.PosCX then
			pos = pos + (ang:Forward() * modifiers.PosCX) 
		end
		if modifiers.PosCY then
			pos = pos + (ang:Right() * modifiers.PosCY) 
		end
		if modifiers.PosCZ then
			pos = pos + (ang:Up() * modifiers.PosCZ) 
		end
		if modifiers.AngCX then
			ang:RotateAroundAxis(ang:Up(), modifiers.AngCX)
		end
		if modifiers.AngCY then
			ang:RotateAroundAxis(ang:Right(), modifiers.AngCY)
		end
		if modifiers.AngCZ then
			ang:RotateAroundAxis(ang:Forward(), modifiers.AngCZ)
		end

		if modifiers.BodyGroupsC then
		  for i,v in pairs(modifiers.BodyGroupsC) do
			model:SetBodygroup(i,v)
		  end
		end
		if modifiers.SkinC then
			model:SetSkin(modifiers.SkinC)
		end

		model:SetLocalPos(pos)
		model:SetLocalAngles(ang)
		
		-- TODO: место для вноса кастомизаций
		toDrawItem[ent][item_id] = model
	end
end

local function holsterCS(ply, item_id)
	local item_data = TTS.Shop.Data.Items[item_id]
	equippedCS[ply] = equippedCS[ply] or {}
	
	if equippedCS[ply][item_id] then
		removeItem(ply, item_id, item_data)
		equippedCS[ply][item_id] = nil
	end
end
netstream.Hook("TTS.HolsterCS", function(ply, item_id)
	-- print('HolsterCS')
	toDrawItem[ply] = toDrawItem[ply] or {}
	equippedCS[ply] = equippedCS[ply] or {}
	holsterCS(ply, item_id)
end)

netstream.Hook("TTS.EquipCS", function(ply, item_id, modifiers)
	-- print('equippedCS')
	toDrawItem[ply] = toDrawItem[ply] or {}
	equippedCS[ply] = equippedCS[ply] or {}
	
	-- if equippedCS[ply][item_id] then
	-- holsterCS(ply, item_id)
	-- end
	-- timer.Simple(0, function()
	equippedCS[ply][item_id] = equippedCS[ply][item_id] or {}
	equippedCS[ply][item_id].item = TTS.Shop.Data.Items[item_id]
	equippedCS[ply][item_id].modifiers = modifiers
	
	addItemsToDraw(ply, equippedCS[ply][item_id], item_id)
	-- end)
end)

hook.Add('PostPlayerDraw', 'TTS::DrawningItems.CheckVisiblePlayer', function(ply)
	-- print(ply)
	if not IsValid(ply) or not ply:Alive() then return end
	
	
	visiblePlayers[ply] = true
end, 10)

hook.Add('PostPlayerDraw', 'TTS::DrawningItems.PostPlayerDraw', function(ply)
	if !equippedCS[ply] then return end
	if !allowedViewCS[ply] then return end
	
	for i,item_data in pairs(equippedCS[ply]) do
		toDrawItem[ply] = toDrawItem[ply] or {}
		
		if toDrawItem[ply][i] then
			if allowedViewCS[ply] then
				if item_data.item.type == 'attacheffect' then
					  if item_data.item.data.lua then
							toDrawItem[ply][i]:think()
					  else
							if not IsValid(toDrawItem[ply][i]) then
								addItemsToDraw(ply, equippedCS[ply][i], i)
								return
							end
							local parent = toDrawItem[ply][i]:GetParent()
							if not IsValid(parent) then	
								addItemsToDraw(ply, equippedCS[ply][i], i)
								return
							end
							toDrawItem[ply][i].Particle:Render()
					  end
				elseif item_data.item.type == 'attach' then
					if not IsValid(toDrawItem[ply][i]) then
						addItemsToDraw(ply, equippedCS[ply][i], i)
						return
					end
					local parent = toDrawItem[ply][i]:GetParent()
					if not IsValid(parent) then	
						addItemsToDraw(ply, equippedCS[ply][i], i)
						return
					end
					toDrawItem[ply][i]:DrawModel()
				end
			end
		end
	end
end, 11)

hook.Add("Think", "TTS::DrawningItems.Think", function()
	for _, ply in pairs(player.GetAll()) do
		
		if !IsValid(ply) then
			equippedCS[ply] = nil
			continue
		end
		
		if !visiblePlayers[ply] and allowedViewCS[ply] then
			hideItem(ply)
			continue
		elseif ply == LocalPlayer() then 
			if not hook.Run("ShouldDrawLocalPlayer", LocalPlayer()) then
				hideItem(ply)
				continue
			end
		elseif LocalPlayer():GetPos():Distance( ply:GetPos() ) >= 1048 then
			hideItem(ply)
			continue
		end
		
		if not ply:Alive() then 
			hideItem(ply)
			continue 
		end
		
		allowedViewCS[ply] = true
	end
	visiblePlayers = {}
end, 10)