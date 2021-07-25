TTS.Shop.Data = TTS.Shop.Data or {}
TTS.Shop.Data.CDN_URL = TTS.Shop.Data.CDN_URL or ''
TTS.Shop.UserPoints = TTS.Shop.UserPoints or 0
TTS.Shop.UserItems = TTS.Shop.UserItems or {}
TTS.Shop.UserCategory = TTS.Shop.UserCategory or {}
TTS.Shop.UserIDs = TTS.Shop.UserIDs or {}
TTS.Shop.Limits = {
  Count = 0,
  Max = 0
}
TTS.Shop.Data.Categories = TTS.Shop.Data.Categories or {}
TTS.Shop.Data.Items = TTS.Shop.Data.Items or {}
TTS.Shop.Data.Commissions = TTS.Shop.Data.Commissions or {}

netstream.Hook("TTS.LoadingShopItems", function(categories, items, commissions, cdn_url)
	TTS.Shop.Data.Categories = categories
	TTS.Shop.Data.Items = util.JSONToTable(items)
	-- for i,v in pairs(TTS.Shop.Data.Items) do
		-- print(i, v.name)
	-- end
	TTS.Shop.Data.Commissions = commissions
	TTS.Shop.Data.CDN_URL = cdn_url
end)

netstream.Hook("TTS.Shop::SetItems", function(data)
  
  TTS.Shop.Limits.Count = data.count
  TTS.Shop.Limits.Max = data.max

  data = data.items

	TTS.Shop.UserIDs = {}
	TTS.Shop.UserCategory = {}
	-- PrintTable(data.items) 
	for i,v in pairs(data.items) do
		-- print(v.item_id)
		local item = TTS.Shop.Data.Items[v.item_id]
		-- PrintTable(TTS.Shop.Data.Items) 
		-- print(item) 
		-- Реверсивная таблица
		TTS.Shop.UserIDs[v.id] = {
			dyn_id = i, -- Динамический ID 
			perm_id = v.id, -- ID в таблице
			item_id = v.item_id
		}
		
		-- Таблица, для категорий 
		-- PrintTable(item)
		TTS.Shop.UserCategory[item.category] = TTS.Shop.UserCategory[item.category] or {}
		TTS.Shop.UserCategory[item.category][v.id] = v.item_id
	end

	TTS.Shop.UserPoints = data.points
	TTS.Shop.UserItems = data.items
end)
netstream.Hook("TTS.Shop::ChangeItems", function(data)
	-- print(data)
	for i,v in pairs(data) do
		local item_ids = TTS.Shop.UserIDs[v.id]
		for i,v in pairs(v.item_data) do
			TTS.Shop.UserItems[item_ids.dyn_id].data[i] = v
		end
	end
	-- PrintTable(data)
	-- PrintTable(TTS.Shop.UserItems)
end)

netstream.Hook("TTS.Shop:BuyItem", function(data)

  TTS.Shop.Limits.Count = data.count

	-- Нужно, чтобы вытянуть данные об итеме и изменить подгруженную категорию
	local item = TTS.Shop.Data.Items[data.item_id]
	-- PrintTable(data)
	TTS.Shop.UserCategory[item.category] = TTS.Shop.UserCategory[item.category] or {}
	TTS.Shop.UserCategory[item.category][data.perm_id] = data.item_id
	
	-- Реверсивная таблица
	TTS.Shop.UserIDs[data.perm_id] = {
		dyn_id = data.dyn_id, -- Динамический ID
		perm_id = data.perm_id, -- ID в таблице
		item_id = data.item_id
	}
	
	TTS.Shop.UserItems[data.dyn_id] = {
		id = data.perm_id,
		item_id = data.item_id,
		data = data.data
	}
end)
function TTS.Shop:BuyItem(item_id)
	netstream.Start("TTS.Shop:BuyItem", item_id)
end


function TTS.Shop:ComputedSell(item) 
	local finalPrice = item.price 
	local commission = 1 - TTS.Shop.Data.Commissions['default']
	if commission <= 0 then
		return finalPrice
	end
	return finalPrice * (1 - commission)
end

netstream.Hook("TTS.Shop:SellItem", function(data)
  TTS.Shop.Limits.Count = data.count

  local perm_id = data.perm_id
	local item_ids = TTS.Shop.UserIDs[perm_id]
	-- Нужно, чтобы вытянуть данные об итеме и изменить подгруженную категорию
	local item = TTS.Shop.Data.Items[item_ids.item_id]
	
	TTS.Shop.UserCategory[item.category] = TTS.Shop.UserCategory[item.category] or {}
	TTS.Shop.UserCategory[item.category][perm_id] = nil
	
	TTS.Shop.UserItems[item_ids.dyn_id] = nil
	TTS.Shop.UserIDs[perm_id] = nil
end) 

function TTS.Shop:SellItem(perm_id)
	netstream.Start("TTS.Shop:SellItem", perm_id)
end


function TTS.Shop:EquipItem(perm_id)
	netstream.Start("TTS.Shop:EquipItem", perm_id)
end
function TTS.Shop:HolsterItem(perm_id)
	netstream.Start("TTS.Shop:HolsterItem", perm_id)
end
netstream.Hook("TTS.Shop::UpdatePointshopPoints", function(data)
	TTS.Shop.UserPoints = data
end)