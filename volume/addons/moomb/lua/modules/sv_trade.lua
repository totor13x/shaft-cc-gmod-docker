
if WS.Bus.TradeController then 
	WS:unsubscribe('server/trade') 
end
 
WS.Bus.TradeController = WS:subscribe('server/trade')

netstream.Hook('TTS:TradeRequest', function(ply, req)
	print(ply, req)
  if IsValid(req) and ply ~= req then
    if !req.TradeHash and !ply.TradeHash then
	print(ply:GetUserID(), req:GetUserID())
      WS.Bus.TradeController:emit('requestSend', {
        request_id = ply:GetUserID(),
        respond_id = req:GetUserID()
      })
    end
  end
end)

WS.Bus.TradeController:on('errors', function(data)
print(data)
end)
WS.Bus.TradeController:on('requestSend', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)
  print(request, respond)
  -- local ply = UserIDToPlayer(data.user_id)
  if IsValid(request) and IsValid(respond) then
    request.TradeHash = data.hash
    respond.TradeHash = data.hash
    netstream.Start(respond, 'TTSTrade/RespondFrame', request:Nick())
  end
end)

netstream.Hook('TTSTrade/AcceptRequest', function(ply) 
  WS.Bus.TradeController:emit('requestAccept', ply:GetUserID())
end)
WS.Bus.TradeController:on('requestAccept', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)
  -- print(request, respond)
  -- local ply = UserIDToPlayer(data.user_id)
  if IsValid(request) and IsValid(respond) then
    netstream.Start({ request, respond }, 'TTSTrade/AcceptRequest', data.trade)
  end
end)

netstream.Hook('TTS:TradeCancel', function(ply)
  if ply.TradeHash then
    WS.Bus.TradeController:emit('requestCancel', ply:GetUserID())
  end
end)

WS.Bus.TradeController:on('removeHash', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)

  if IsValid(request) then
    request.TradeHash = nil
  end
  if IsValid(respond) then
    respond.TradeHash = nil
  end
end)

for i, v in pairs(player.GetAll()) do
  v.TradeHash = nil
end

netstream.Hook('TTSTrade/Close', function(ply, id)
  WS.Bus.TradeController:emit('close', {
    user_id = ply:GetUserID(),
    id = ply.TradeHash
  })
end)

WS.Bus.TradeController:on('close', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)

  if IsValid(request) and IsValid(respond) then
    netstream.Start({ request, respond }, 'TTSTrade/Close')
  end
end)

netstream.Hook('TTSTrade/MoveItem', function(ply, data)
  WS.Bus.TradeController:emit('moveItem', {
    id = ply.TradeHash,
    user_id = ply:GetUserID(),
    perm_id = data.perm_id,
    type = data.type
  })
end)
WS.Bus.TradeController:on('moveItem', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)

  if IsValid(request) and IsValid(respond) then
    netstream.Start({ request, respond }, 'TTSTrade/MoveItem', {
      user_id = data.user_id,
      item_id = data.item_id,
      perm_id = data.perm_id,
      type = data.type
    })
  end
end)


WS.Bus.TradeController:on('notify', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)

  if IsValid(request) and IsValid(respond) then
    netstream.Start({ request, respond }, 'TTSTrade/notify', {
      text = data.text,
      type = data.type
    })
  end
end)

netstream.Hook('TTSTrade/Chat', function(ply, data)
  WS.Bus.TradeController:emit('chat', { 
    id = ply.TradeHash,
    user_id = ply:GetUserID(),
    text = data.text
  })
end)
WS.Bus.TradeController:on('chat', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)

  if IsValid(request) and IsValid(respond) then
    netstream.Start({ request, respond }, 'TTSTrade/Chat', {
      username = data.username,
      text = data.text
    })
  end
end)
WS.Bus.TradeController:on('updateStatus', function(data)
  local request = UserIDToPlayer(data.request_id)
  local respond = UserIDToPlayer(data.respond_id)

  if IsValid(request) and IsValid(respond) then
    netstream.Start({ request, respond }, 'TTSTrade/UpdateStatus', data.trade)
  end
end)
netstream.Hook('TTSTrade/ChangeStatus', function(ply, status)
  WS.Bus.TradeController:emit('changeStatus', {
    id = ply.TradeHash,
    user_id = ply:GetUserID(), 
    status = status,
  })
end)
netstream.Hook('TTSTrade/Ready', function(ply, status)
  WS.Bus.TradeController:emit('ready', {
    id = ply.TradeHash,
    user_id = ply:GetUserID(), 
    status = status,
  })
end)