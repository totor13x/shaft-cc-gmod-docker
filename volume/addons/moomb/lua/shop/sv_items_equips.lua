print('sv_items_equip')

TTS.Shop.EquippedItems = TTS.Shop.EquippedItems or {}

function TTS.Shop.PS_EquipItemController(ply, perm_id, force, death)
	local data = ply.TTS.Pointshop.dataIDs[perm_id]
	local item_user = ply.TTS.Pointshop.items[data.dyn_id]
	local item = TTS.Shop.Data.Items[data.item_id]
	
	if !item_user.data.equip or force then
		local func_cat = 
			TTS.Shop.Data.CatFunc[item.category] 
				and TTS.Shop.Data.CatFunc[item.category].Equip
		-- PrintTable(item)
		if isfunction(func_cat) then
			func_cat(ply, item.id, perm_id)
		end
		
		local func_item = 
			TTS.Shop.Data.ItemsFunc[item.id] 
				and TTS.Shop.Data.ItemsFunc[item.id].Equip
			
		if isfunction(func_item) then
			func_item(ply, item.id, perm_id)
		end
		-- print(ply, perm_id)
		if !death then
			TTS.Shop.EquippedItems[ply] = TTS.Shop.EquippedItems[ply] or {}
			TTS.Shop.EquippedItems[ply][perm_id] = true
		end
	end
end

function TTS.Shop.PS_HolsterItemController(ply, perm_id, force, death)
	local data = ply.TTS.Pointshop.dataIDs[perm_id]
	local item_user = ply.TTS.Pointshop.items[data.dyn_id]
	local item = TTS.Shop.Data.Items[data.item_id]
	
	if item_user.data.equip or force then	
		local func_cat = 
			TTS.Shop.Data.CatFunc[item.category] 
				and TTS.Shop.Data.CatFunc[item.category].Holster
				
		if isfunction(func_cat) then 
			func_cat(ply, item.id, perm_id)
		end
		
		local func_item = 
			TTS.Shop.Data.ItemsFunc[item.id] 
				and TTS.Shop.Data.ItemsFunc[item.id].Holster
				
		if isfunction(func_item) then 
			func_item(ply, item.id, perm_id)
		end
		
		if !death then
			TTS.Shop.EquippedItems[ply] = TTS.Shop.EquippedItems[ply] or {}
			TTS.Shop.EquippedItems[ply][perm_id] = nil
		end
	end
end

hook.Add("PlayerSpawn", "TTS.Shop.PS_EquipItemsAfterSpawnController", function(ply)
	timer.Simple(1, function()
		if !IsValid(ply) then return end
		
		TTS.Shop.EquippedItems[ply] = TTS.Shop.EquippedItems[ply] or {}
		
		for perm_id, _ in pairs(TTS.Shop.EquippedItems[ply]) do
			TTS.Shop.PS_EquipItemController(ply, perm_id, true, true)
		end
	end)
end)
local tobool = tobool
hook.Add("PostPlayerDeath", "TTS.Shop.PS_HolsterItemsAfterDeathController", function(ply) 
	-- timer.Simple(1, function()
		-- if !IsValid(ply) then return end
		
		TTS.Shop.EquippedItems[ply] = TTS.Shop.EquippedItems[ply] or {}
		
		for perm_id, _ in pairs(TTS.Shop.EquippedItems[ply]) do
			local data = ply.TTS.Pointshop.dataIDs[perm_id]
			local item = TTS.Shop.Data.Items[data.item_id]
			-- PrintTable(item)
			-- print(perm_id, item.name, item.always_equip, 'item')
			if tobool(item.always_equip) then continue end
			
			TTS.Shop.PS_HolsterItemController(ply, perm_id, true, true)
		end
	-- end)
end)

local Entity = FindMetaTable('Entity')

function Entity:PS_SetModel(str, item_id, perm_id)
	//if not self:PS_CanPerformAction() then return end
	if str then
		self:SetModel(str)
		self:SetNWString("SetModel", str)
		
		local PrevMins, PrevMaxs = self:GetCollisionBounds()
		if PrevMins.x < 15000 or PrevMins.x > -15000 then
			self:SetCollisionBounds(Vector(-18, -18, 0), Vector(18, 18, 70))
		end 
		
		print('Prepare ModelNow', str, item_id, perm_id)
		
		self:SetSubMaterial()
		self:SetSkin(0)
		for i = 1, #self:GetBodyGroups() do
			local bg = self:GetBodyGroups()[i]
			if bg then
			self:SetBodygroup(i,0)
			end
		end
		
		if perm_id then
			-- print(self, item_id)
			local item_ids = self.TTS.Pointshop.dataIDs[perm_id]
			-- PrintTable(item_ids)
			local modifiers = self.TTS.Pointshop.items[item_ids.dyn_id].data.m
			if modifiers then
				if modifiers.BodyGroupsC then
					for i,v in pairs(modifiers.BodyGroupsC ) do -- Фикс для моделей по фасту
						self:SetBodygroup(i,v)
					end
				end
				if modifiers.SkinC then
					self:SetSkin(modifiers.SkinC)
				end
			end
		end
		
		TTS.Shop.EquippedItems[self] = TTS.Shop.EquippedItems[self] or {}
		local toreequip = {
			attacheffect = true,
			attach = true,
		}
		for perm_id, _ in pairs(TTS.Shop.EquippedItems[self]) do
			local data = self.TTS.Pointshop.dataIDs[perm_id]
			local item = TTS.Shop.Data.Items[data.item_id]
			
			if toreequip[item.type] and self:Alive() then
				TTS.Shop.PS_HolsterItemController(self, perm_id, true, true)
				timer.Simple(2, function()
					TTS.Shop.PS_EquipItemController(self, perm_id, true, true)
				end)
			end
		end
	end
end
