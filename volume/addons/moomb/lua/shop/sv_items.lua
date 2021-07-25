TTS.Shop.Data = {} 
TTS.Shop.Data.CDN = ''
TTS.Shop.Data.Original = {} 
TTS.Shop.Data.Categories = {}
TTS.Shop.Data.CatFunc = {}
TTS.Shop.Data.Items = {}
TTS.Shop.Data.ItemsFunc = {}

TTS.Shop.Data.Commissions = {}

// Динамичные переменные и лучше их не чистить
TTS.Shop.Data.ItemsModified = {}  
 
local Player = FindMetaTable( "Player" )  
 
TTS.HTTP('/api/server/pointshop', {}, function(data) 
	-- print(util.TableToJSON(data))          
	TTS.Shop.Data = {}  
	TTS.Shop.Data.Original = {}  
	TTS.Shop.Data.Categories = {} 
	TTS.Shop.Data.CatFunc = {}  
	TTS.Shop.Data.Items = {}
	TTS.Shop.Data.ItemsFunc = {}

	TTS.Shop.Data.Commissions = {}
	
	TTS.Shop.Data.ItemsEquipped = {}
	TTS.Shop.Data.ItemsModified = {}

	TTS.Shop.Data.Original = data.items
	TTS.Shop.Data.CDN = data.cdn_url
	for i,v in pairs(data.items) do  
		TTS.Shop.Data.Categories[v.category] 
			= TTS.Shop.Data.Categories[v.category] or {}

		TTS.Shop.Data.Categories[v.category].Items
			= TTS.Shop.Data.Categories[v.category].Items or {}
		
		table.insert(TTS.Shop.Data.Categories[v.category].Items, v.id) 
		TTS.Shop.Data.Categories[v.category].Name = v.category
		TTS.Shop.Data.Items[v.id] = v

		TTS.Shop.Data.ItemsFunc[v.id] = {}
		if (v.compile_string_equip) then
			TTS.Shop.Data.ItemsFunc[v.id].Equip = CompileString( v.compile_string_equip, v.id.."_PS_Items_Equip")
		end 
		if (v.compile_string_holster) then
			TTS.Shop.Data.ItemsFunc[v.id].Holster = CompileString( v.compile_string_holster, v.id.."_PS_Items_Holster") 
		end
	end
	 
	for i,v in pairs(data.categories) do
		-- PrintTable(v)
		-- print(i) 
		-- TTS.Shop.Data.Categories[v.name].Name = v.name
		-- TTS.Shop.Data.Categories[v.name].CompileStringEquip = v.compile_string
		TTS.Shop.Data.Categories[v.name] = TTS.Shop.Data.Categories[v.name] or {}
		TTS.Shop.Data.Categories[v.name].id = v.id
		TTS.Shop.Data.Categories[v.name].max = v.max_items
		TTS.Shop.Data.Categories[v.name].have_preview = v.have_preview
		
		TTS.Shop.Data.CatFunc[v.name] = {}
		if (v.compile_string_equip) then
			-- PrintTable( v ) 
			-- print(TTS.Shop.Data.CatFunc)
			-- local func = CompileString( v.compile_string_equip, v.id.."_PS_Category")
			TTS.Shop.Data.CatFunc[v.name].Equip = CompileString( v.compile_string_equip, v.id.."_PS_Category_Equip")
			-- func(v.id)
		end 
		if (v.compile_string_holster) then
			-- PrintTable( v ) 
			-- print(TTS.Shop.Data.CatFunc)
			-- local func = CompileString( v.compile_string_equip, v.id.."_PS_Category")
			TTS.Shop.Data.CatFunc[v.name].Holster = CompileString( v.compile_string_holster, v.id.."_PS_Category_Holster")
			-- func(v.id)
		end
	end

	if data.commissions then
		TTS.Shop.Data.Commissions = data.commissions
	else
		TTS.Shop.Data.Commissions = {
			default = 0.25 
		}
	end
  -- print(Entity(1).TTS.Data.id)     
  -- PrintTable(TTS.Shop.Data.Items) 
  
	local ply = player.GetBySteamID('STEAM_0:1:58105')
	if IsValid(ply) then
		netstream.Heavy(ply, "TTS.LoadingShopItems", TTS.Shop.Data.Categories, util.TableToJSON(TTS.Shop.Data.Items), TTS.Shop.Data.Commissions, TTS.Shop.Data.CDN)
	end
end) 
 
hook.Add("PlayerInitialSpawn", "LoadingShopItems", function(ply)
	netstream.Heavy(ply, "TTS.LoadingShopItems", TTS.Shop.Data.Categories, util.TableToJSON(TTS.Shop.Data.Items), TTS.Shop.Data.Commissions, TTS.Shop.Data.CDN)
end)


if WS.Bus.PointshopController then 
	WS:unsubscribe('server/pointshop') 
end

WS.Bus.PointshopController = WS:subscribe('server/pointshop')
			-- if WS:ontopic('server/poitshop') then
				-- WS:unsubscribe('server/poitshop')
			-- end
			
			-- local channel2 = WS:subscribe('server/poitshop')
			-- timer.Simple(0.5, function()
			
			-- channel2:emit('delItem', {
				-- user_id = 1,
				-- server_id = 'gm_murder',
				-- id = 72
			-- })  
			
			-- channel2:emit('delItem', {
				-- user_id = 1,
				-- server_id = 'gm_murder', 
				-- id = 72
			-- })  
				-- timer.Simple(0.5, function()
					-- channel2:emit('check')   
				-- end) 
			-- end) 
 
hook.Add("TTS.PlayerInitialSpawn", "TTS.Shop::SetItems", function(ply)
	-- print('ply')
	if ply.TTS then
		-- print('ply.TTS')
			
		WS.Bus.PointshopController:emit('getItems', ply.TTS.Data.id)
		-- WS:emit('server/pointshop/get_items', ply.TTS.Data.id)
	end
end)

WS.Bus.PointshopController:on('forceGetItems', function(data)
	for i,v in pairs(data) do
		local ply = UserIDToPlayer(v)      
		if IsValid(ply) then
			if ply.TTS then
				WS.Bus.PointshopController:emit('getItems', ply.TTS.Data.id)
			end
		end
	end
end)


-- WS:emit('server/pointshop/get_items', 1)  
                
-- WS:destroy('server/pointshop/get_items')   
timer.Simple(1, function()
	-- WS.Bus.PointshopController:emit('addItem', {
		-- user_id = 1,
		-- item_id = 1 
	-- }) 
	
	WS.Bus.PointshopController:emit('getItems', 450)
	print('emit') 
end)
WS.Bus.PointshopController:on('getItems', function(data)
	local ply = UserIDToPlayer(data.user_id)           
	-- PrintTable(User_IDs)   
	-- print(ply) 
	if IsValid(ply) then
		ply.TTS.Pointshop = data.items 
		ply.TTS.Pointshop.items = ply.TTS.Pointshop.items or {}
		ply.TTS.Pointshop.points = ply.TTS.Pointshop.points or 0

		ply.TTS.Pointshop.dataIDs = {} 
		for i,v in pairs(ply.TTS.Pointshop.items) do
			local itm = TTS.Shop.Data.Items[v.item_id]
			-- print(itm, v.item_id)
			if !itm then 
				-- PrintTable(ply.TTS.Pointshop.items[i])
				data.items.items[i] = nil 
				ply.TTS.Pointshop.items[i] = nil 
				continue
			end
			ply.TTS.Pointshop.dataIDs[v.id] = {
				dyn_id = i, -- Динамический ID
				perm_id = v.id, -- ID в таблице
				item_id = v.item_id -- ID предмета
			}
			if !v.data.equip then continue end
			timer.Simple(5, function()
				if !IsValid(ply) then return end
				TTS.Shop.PS_EquipItemController(ply, v.id, true)
			end)
		end 
		-- PrintTable(data)
		-- ply:UpdatePointshopPoints()
		netstream.Heavy(ply, "TTS.Shop::SetItems", {
      count = data.count,
      max = data.max,
      items = data.items
    })
	end
end)

netstream.Hook("TTS.Shop:BuyItem", function(ply, item_id)
	if ply.TTS then
		WS.Bus.PointshopController:emit('addItem', {
			user_id = ply.TTS.Data.id,
			item_id = item_id 
		})
	end 
end)    
WS.Bus.PointshopController:on('addItem', function(data)
	local ply = UserIDToPlayer(data.user_id)
	if IsValid(ply) then
		-- PrintTable(data)
		
		local lastItemId = ply.TTS.Pointshop.items[#ply.TTS.Pointshop.items]
		lastItemId = lastItemId and #ply.TTS.Pointshop.items + 1 or 1
		
		ply.TTS.Pointshop.dataIDs[data.item.id] = {
			dyn_id = lastItemId,	-- Динамический ID
			perm_id = data.item.id,	-- ID в таблице
			item_id = data.item.item_id	-- ID предмета
		}
		
		ply.TTS.Pointshop.items[lastItemId] = {
			id = data.item.id,
			item_id = data.item.item_id,
			data = data
		}
        
		-- PrintTable(ply.TTS.Pointshop.inv)
		netstream.Start(ply, "TTS.Shop:BuyItem", {
			count = data.count,

			dyn_id = lastItemId, -- Динамический ID
			perm_id = data.item.id, -- ID в таблице
			item_id = data.item.item_id, -- ID предмета
			data = data
		})
	end
end)

netstream.Hook("TTS.Shop:SellItem", function(ply, perm_id) 
	if ply.TTS then
		WS.Bus.PointshopController:emit('delItem', {
			user_id = ply.TTS.Data.id,
			perm_id = perm_id 
		})
		-- WS:emit('server/pointshop/del_item', {
			-- user_id = ply.TTS.Data.id, 
			-- id = perm_id 
		-- })  
	end 
end) 
WS.Bus.PointshopController:on('delItem', function(data)
  local ply = UserIDToPlayer(data.user_id)  
  local count = data.count
	if IsValid(ply) then
		local data = ply.TTS.Pointshop.dataIDs[data.perm_id]
		
		TTS.Shop.PS_HolsterItemController(ply, data.perm_id, true)
		
		ply.TTS.Pointshop.items[data.dyn_id] = nil
		ply.TTS.Pointshop.dataIDs[data.perm_id] = nil
		
		netstream.Start(ply, "TTS.Shop:SellItem", {
		  count = count,
		  perm_id = data.perm_id
		}) 
	end 
end)

function Player:UpdatePointshopPoints()
	local points = self.TTS.Pointshop.points or 0
	netstream.Start(self, "TTS.Shop::UpdatePointshopPoints", points)  
end

WS.Bus.PointshopController:on('points', function(data)
	local ply = UserIDToPlayer(data.user_id)
	if IsValid(ply) then
		if ply.TTS then
			ply.TTS.Pointshop.points = data.points
			ply:UpdatePointshopPoints()
		end
	end 
end)


-- data = {
	-- selected = {
		-- #key = 1,
		-- #value = 2 -- item_id
	-- },
	
-- }


netstream.Hook("TTS.Shop:ValidateEquipItem", function(ply, item_id, data) 
	print('item_id', item_id)
	-- PrintTable(data)
	local item = TTS.Shop.Data.Items[item_id]
	local equpped = {}
	local holster = {}
	for i,v in pairs(data.selected) do
		-- PrintTable(v)
		local item_temp = TTS.Shop.Data.Items[v]
		if item_temp.category == item.category then
			table.insert(equpped, v)
		end
	end

	local max = TTS.Shop.Data.Categories[item.category] and TTS.Shop.Data.Categories[item.category].max
	

	local counting = 0
	for i,v in pairs(equpped) do
		local do_holster = true
		counting = counting + 1
		
		-- Ограничения по количеству
		if (max and max != 0) and (max > counting) then do_holster = false end
		
		-- Если ограничения нет, то ничего не снимаем
		if max and max == 0 then do_holster = false end
		
		-- По любому надо снимать, если hoe = hoe
		local item_temp = TTS.Shop.Data.Items[v]
		if (item.hoe && item.hoe != '') && item.hoe == item_temp.hoe then do_holster = true end
		
		if !do_holster then 
			continue
		end

		holster[item_temp.id] = true
		print(item_temp.name)
		-- print(do_holster)
		-- local item_temp = TTS.Shop.Data.Items[v.item.item_id]
		-- if item_temp.category == item.category then
		-- local holtered = TTS.Shop.PS_HolsterItem(ply, v.id)
		-- if holtered then
			-- holster[item_id] = true
		-- end
	end
	
	netstream.Start(ply, "TTS.Shop:ValidateEquipItem", holster, {
		only = data.only, 
		save = data.save
	}) 
	-- print(table.Count(holster))
end)
local equipItem = function(ply, perm_id, force)
	if ply.TTS then
		local changes = {}
		local data = ply.TTS.Pointshop.dataIDs[perm_id]
		
		local item = TTS.Shop.Data.Items[data.item_id]
		local equpped = {}
		-- PrintTable(item) 
		for i,v in pairs(ply.TTS.Pointshop.items) do
			-- PrintTable(v)
			if v.data.equip then
				local item_temp = TTS.Shop.Data.Items[v.item_id]
				if item_temp.category == item.category then
					table.insert(equpped, v)
				end
			end
		end
		
		local max = TTS.Shop.Data.Categories[item.category] and TTS.Shop.Data.Categories[item.category].max
		
		local counting = 0
		for i,v in pairs(equpped) do
			local do_holster = true
			counting = counting + 1
			
			-- Ограничения по количеству
			if (max and max != 0) and (max > counting) then do_holster = false end
			
			-- Если ограничения нет, то ничего не снимаем
			if max and max == 0 then do_holster = false end
			
			-- По любому надо снимать, если hoe = hoe
			local item_temp = TTS.Shop.Data.Items[v.item_id]
			if (item.hoe && item.hoe != '') && item.hoe == item_temp.hoe then do_holster = true end
			
			if !do_holster then 
				continue
			end

			-- local item_temp = TTS.Shop.Data.Items[v.item.item_id]
			-- if item_temp.category == item.category then
			local holtered = TTS.Shop.PS_HolsterItem(ply, v.id)
			if holtered then
				changes[#changes+1] = {
					id = holtered,
					item_data = {
						equip = false
					}
				}
			end
		end
		
		
		local equipp = TTS.Shop.PS_EquipItem(ply, perm_id, force)
		if equipp then
			changes[#changes+1] = {
				id = equipp,
				item_data = {
					equip = true
				}
			}
			-- if modifiers then
				-- changes[#changes].item_data.m = modifiers
			-- end
		end
		
		for i,change in pairs(changes) do
			local item_ids = ply.TTS.Pointshop.dataIDs[change.id]
			
			for i,v in pairs(change.item_data) do
				ply.TTS.Pointshop.items[item_ids.dyn_id].data[i] = v
			end
			-- local desc = table.Copy(ply.TTS.Pointshop.inv[data.dyn_id].item)
			
			-- table.Merge(desc, change.item_data)
			
			-- ply.TTS.Pointshop.inv[data.dyn_id] = {
				-- id = change.id,
				-- item = desc
			-- }
		end
		
		return changes
		-- if #changes > 0 then
		-- WS:emit('server/pointshop/get_items/dont_sent', ply.TTS.Data.id)
		-- end
	end
end
local holsterItem = function(ply, perm_id)
	if ply.TTS then
		local changes = {}
		local holtered = TTS.Shop.PS_HolsterItem(ply, perm_id)
		if holtered then
			changes[#changes+1] = {
				id = holtered,
				item_data = {
					equip = false
				}
			}
		end
		
		for i,change in pairs(changes) do
			local item_ids = ply.TTS.Pointshop.dataIDs[change.id]
			
			for i,v in pairs(change.item_data) do
				ply.TTS.Pointshop.items[item_ids.dyn_id].data[i] = v
			end
		end
		
		return changes
		-- netstream.Start(ply, "TTS.Shop::ChangeItems", changes)
		-- if #changes > 0 then
			-- WS:emit('server/pointshop/get_items/dont_sent', ply.TTS.Data.id)
		-- end
	end
end


hook.Add("TTS.PlayerInitialSpawn", "TTS.Shop::SetBodyGroups", function(ply)
  ply.BodyGroupsTTS = ply.BodyGroupsTTS or {}
	if ply.TTS then
		WS.Bus.PointshopController:emit('getInfoBodyGroups', ply.TTS.Data.id)
	end
end)

WS.Bus.PointshopController:on('getInfoBodyGroup', function(data)
	local ply = UserIDToPlayer(data.user_id)          
  if IsValid(ply) then
    netstream.Start(ply, 'TTS.LoadingTTSBodygroups', data.bodygroups)
	end
end)

WS.Bus.PointshopController:on('holsterItem', function(data)
	local ply = UserIDToPlayer(data.user_id)
	if IsValid(ply) then
		TTS.Shop.PS_HolsterItemController(ply, data.perm_id, true)
	end
end)

netstream.Hook('TTS.Shop:SaveBodyGroups', function(ply, data)
	if ply.TTS then
    print(ply, data)
    PrintTable(data)
    WS.Bus.PointshopController:emit('saveBodyGroups', {
      user_id = ply.TTS.Data.id,
      bodygroups = data
    })
  end
end)

netstream.Hook("TTS.Shop:EquipSetWithClear", function(ply, data)
	if ply.TTS then
    local changes = {}
    PrintTable(data)
		-- PrintTable(ply.TTS.Pointshop.items)
		for i,v in pairs(ply.TTS.Pointshop.items) do
			if v.data.equip then
				local mergeChanges = holsterItem(ply, v.id)
				-- local mergeChanges = equipItem(ply, item)
				table.Add( changes, mergeChanges )
				-- if holtered then
					-- changes[#changes+1] = {
						-- id = holtered,
						-- item_data = {
							-- equip = false
						-- }
					-- }
				-- end
			end
		end
		for item_id, modifiers in pairs(data) do
			local item 
			for dyn_id, data_item in pairs(ply.TTS.Pointshop.items) do
				if data_item.item_id == item_id then
					item = data_item.id
					break
				end
			end
			 
			if item then
				local mergeChanges = equipItem(ply, item, nil, table.Count(modifiers) ~= 0 and modifiers or nil)
				 
				if table.Count(modifiers) ~= 0 then
					 
					local item_ids = ply.TTS.Pointshop.dataIDs[item]
					
					-- for i,v in pairs(change.item_data) do
						ply.TTS.Pointshop.items[item_ids.dyn_id].data.m = modifiers
					-- end
					
					WS.Bus.PointshopController:emit('changeItem', {
						user_id = ply.TTS.Data.id,
						item_id = item,
						item_data = { 
							equip = true,
							m = modifiers 
						}
					})
					-- PrintTable(mergeChanges)
					-- ,
    -- [4] = {
        -- ["id"] = 104,
        -- ["item_data"] = { 
            -- ["equip"] = true, 
            -- ["m"] = {
                -- ["BodyGroupsC"] = {
                    -- [3] = 1,
                -- },
                -- ["SkinC"] = 1,
            -- },
        -- },
					for i,v in pairs(mergeChanges) do
						if v.id == item and v.item_data.equip then
							mergeChanges[i].item_data.m = modifiers
							TTS.Shop.PS_EquipItemController(ply, item, true, true)
						end
					end
				end
				table.Add( changes, mergeChanges )
				-- PrintTable(modifiers)
			end
		end
		-- PrintTable(changes)
		netstream.Start(ply, "TTS.Shop::ChangeItems", changes)
	end
end)
netstream.Hook("TTS.Shop:EquipItem", function(ply, perm_id)
	netstream.Start(ply, "TTS.Shop::ChangeItems", equipItem(ply, perm_id))
end) 


netstream.Hook("TTS.Shop:HolsterItem", function(ply, perm_id) 
	netstream.Start(ply, "TTS.Shop::ChangeItems", holsterItem(ply, perm_id))
end) 
function TTS.Shop.PS_EquipItem(ply, perm_id, force)
	if ply.TTS then
		local data = ply.TTS.Pointshop.dataIDs[perm_id]
		local item_user = ply.TTS.Pointshop.items[data.dyn_id]
		local item = TTS.Shop.Data.Items[data.item_id]
		
		if !item_user.data.equip or force then
			TTS.Shop.PS_EquipItemController(ply, perm_id, force)
			
			if tobool(item.once) then
				WS.Bus.PointshopController:emit('delItem', {
					user_id = ply.TTS.Data.id,
          perm_id = perm_id,
          once = true
				})
				-- WS:emit('server/pointshop/del_item', {
					-- user_id = ply.TTS.Data.id,
					-- id = perm_id
				-- })
		
				-- netstream.Start(ply, "TTS.Shop:SellItem", perm_id)
				
				return false
			end
			
			WS.Bus.PointshopController:emit('changeItem', {
				user_id = ply.TTS.Data.id,
				item_id = perm_id,
				item_data = { 
					equip = true  
				}
			})
			return perm_id
		end
	end
	return false
end

function TTS.Shop.PS_HolsterItem(ply, perm_id, force) 
	if ply.TTS then
		local data = ply.TTS.Pointshop.dataIDs[perm_id]
		local item_user = ply.TTS.Pointshop.items[data.dyn_id]
		local item = TTS.Shop.Data.Items[data.item_id]
		
		if item_user.data.equip or force then
		
			TTS.Shop.PS_HolsterItemController(ply, perm_id, force)
			
			WS.Bus.PointshopController:emit('changeItem', {
				user_id = ply.TTS.Data.id,
				item_id = perm_id,
				item_data = { 
					equip = false,
					m = false
				}
			})
			-- WS:emit('server/pointshop/set_item', { 
				-- user_id = ply.TTS.Data.id,
				-- id = perm_id,
				-- item_data = { 
					-- equip = false 
				-- }
			-- })
			return perm_id
		end
	end
	return false
end

function TTS.Shop.PS_MinusPoints(ply, points)
	if ply.TTS then
		WS.Bus.PointshopController:emit('points', {
			user_id = ply.TTS.Data.id,
			points = points * -1,
		})
	end
end

function TTS.Shop.PS_PlusPoints(ply, points)
	if ply.TTS then
		WS.Bus.PointshopController:emit('points', {
			user_id = ply.TTS.Data.id,
			points = points,
		})
	end
end

function TTS.Shop.PS_HasPoints(ply, points)
	if ply.TTS then
		if ply.TTS.Pointshop.points < points then
			return false, 'Не хватает поинтов'
		end
		
		return true
	end
	return false
end

-- timer.Simple(1 , function()
-- 	if WS.Bus.TestController then 
-- 		WS:unsubscribe('test')  
-- 	end

-- 	WS.Bus.TestController = WS:subscribe('test')
-- 	do
-- 		WS.Bus.TestController:emit('userPrm', {
-- 			id = 12, 
-- 			server_id = 1
-- 		})
-- 		WS.Bus.TestController:on('userPrm', function(data)
-- 			PrintTable(data)   
-- 		end)
-- 	end    
-- end) 