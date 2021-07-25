print('asd')

if WS.Bus.InventoryController then 
	WS:unsubscribe('server/inventory') 
end
 
WS.Bus.InventoryController = WS:subscribe('server/inventory')

netstream.Hook('TTSInventory/toInventory', function(ply, perm_id)
  WS.Bus.InventoryController:emit('toInventory', {
    user_id = ply:GetUserID(),
    type = 'ps',
    perm_id = perm_id,
  })
end)

netstream.Hook('TTSInventory/fromInventory', function(ply, inv_item_id)
  -- print(inv_item_id)
  WS.Bus.InventoryController:emit('fromInventory', {     
    user_id = ply:GetUserID(), 
    inv_item_id = inv_item_id
  })
end)

netstream.Hook('TTSInventory/openInventory', function(ply, data)
  WS.Bus.InventoryController:emit('openInventory', {     
    user_id = ply:GetUserID(), 
    page = data.page or 1,       
    type = data.type or 'all'
  })
end)
WS.Bus.InventoryController:on('openInventory', function(data)
  PrintTable(data)
  local ply = UserIDToPlayer(data.user_id)
  -- local respond = UserIDToPlayer(data.respond_id)

  if IsValid(ply) then
    netstream.Start(ply, 'TTSInventory/openInventory', data)
  end
end)

hook.Add('TTS.PlayerInitialSpawn', 'TTS/InventoryInit', function(ply)
  WS.Bus.InventoryController:emit('countInventory', {     
    user_id = ply:GetUserID(),
  })
end)
WS.Bus.InventoryController:on('countInventory', function(data)
  local ply = UserIDToPlayer(data.user_id)
  if IsValid(ply) then
    netstream.Start(ply, 'TTSInventory/countInventory', {
      max = data.max,
      count = data.count
    })
  end
end)
-- do
-- end