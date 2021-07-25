
TTS.Inventory = {}
TTS.Inventory.Counts = {
  Max = 0,
  Count = 0
}
function TTS.Inventory:ToInventory ( perm_id )
  netstream.Start('TTSInventory/toInventory', perm_id)
end
function TTS.Inventory:FromInventory ( inv_item_id )
  netstream.Start('TTSInventory/fromInventory', inv_item_id)
end
function TTS.Inventory:OpenInventory ( page, type )
  netstream.Start('TTSInventory/openInventory', {
    page = page,
    type = type
  })
  -- netstream.Start('TTSInventory/toInventory', perm_id)
end

netstream.Hook('TTSInventory/openInventory', function(data)
  hook.Run('InvOpenInventory', data)
end)
netstream.Hook('TTSInventory/countInventory', function(data)
  TTS.Inventory.Counts.Max = data.max
  TTS.Inventory.Counts.Count = data.count
end)