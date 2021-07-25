Roulette = {}
Roulette.List = {}

if WS.Bus.RouletteController then 
	WS:unsubscribe('server/roulette')  
end

WS.Bus.RouletteController = WS:subscribe('server/roulette')

WS.Bus.RouletteController:on('crateList', function(data)
  -- PrintTable(data)
  Roulette.List = data 

  if TTS.DEBUG then
    netstream.Start(Entity(1), "CrateList::Sync", Roulette.List)  
  end
end)

timer.Simple(20, function()
  WS.Bus.RouletteController:emit('crateList') 
end)

hook.Add("TTS.PlayerInitialSpawn", "CrateList::Sync", function(ply)
  netstream.Start(ply, "CrateList::Sync", Roulette.List)
end)


netstream.Hook("crateOpen", function(ply, id)
  WS.Bus.RouletteController:emit('crateOpen', {  
    id = id,
    limit = 25,    
    user_id = ply:GetUserID()
  }) 
end)
WS.Bus.RouletteController:on('crateOpen', function(data) 
  if !TTS.DEBUG then
    data.mctime = nil
  end
  -- PrintTable(data)
  local ply = UserIDToPlayer(data.user_id)
  if IsValid(ply) then
    netstream.Start(ply, 'crateOpen', data)
  end
end)   
netstream.Hook("CrateBuy", function(ply, data)  
  WS.Bus.RouletteController:emit('buy', {     
    id = data.id,
    user_id = ply:GetUserID(), 
    type = data.type,
    count = data.count
  })  
end)  
netstream.Hook("CrateSell", function(ply, data)
  WS.Bus.RouletteController:emit('sell', {   
    id = data.id,
    user_id = ply:GetUserID(), 
    type = data.type
  })  
end)  
WS.Bus.RouletteController:on('updateData', function(data) 
  if !TTS.DEBUG then
    data.mctime = nil  
  end

  local ply = UserIDToPlayer(data.user_id)
  if IsValid(ply) then
    netstream.Start(ply, 'crateUpdate', data)
  end
  PrintTable(data)         
end)  

netstream.Hook('CrateSpin', function(ply, data)
  WS.Bus.RouletteController:emit('crateSpin', {   
    id = data.id,
    user_id = ply:GetUserID(),   
  })    
end)
netstream.Hook('CrateSpinAll', function(ply, data)
  WS.Bus.RouletteController:emit('crateSpinAll', {   
    id = data.id,
    user_id = ply:GetUserID(),
    max = data.max
  })
end)
-- local mctime = SysTime() 
WS.Bus.RouletteController:on('crateSpin', function(data)  
  if !TTS.DEBUG then 
    data.mctime = nil
  end           

  local ply = UserIDToPlayer(data.user_id)
  if IsValid(ply) then
    netstream.Start(ply, 'CrateSpin', data)
  end
  -- netstream.Start(ply, 'CrateSpin', data)
  -- print(data.mctime)   
  -- print(SysTime()-mctime)  
  -- PrintTable(data)         
end) 
WS.Bus.RouletteController:on('crateSpinAll', function(data)
  if !TTS.DEBUG then
    data.mctime = nil  
  end
  print(data.user_id, '--------')
  local ply = UserIDToPlayer(data.user_id)
  if IsValid(ply) then
    netstream.Start(ply, 'CrateSpinAll', data)
  end
end)