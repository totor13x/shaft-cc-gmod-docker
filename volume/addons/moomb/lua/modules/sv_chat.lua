Chat = {}
Chat.List = {}

if WS.Bus.ChatController then 
	WS:unsubscribe('chat') 
end
   
WS.Bus.ChatController = WS:subscribe('chat')

WS.Bus.ChatController:on('load', function(data)
  Chat.List = data

  if TTS.DEBUG then
    netstream.Start(Entity(1), 'Chat:Load', Chat.List)
  end
end)

netstream.Hook('Chat:Load', function(ply)
  netstream.Start(ply, 'Chat:Load', Chat.List)
end) 

WS.Bus.ChatController:on('message', function(data)
  -- PrintTable(data)
  if #Chat.List >= 20 then
    table.remove(Chat.List)
  end

  table.insert(Chat.List, 1, data)
  netstream.Start(_, 'Chat:Message', data)
end)

netstream.Hook('Chat:Message', function(ply, message)
  WS.Bus.ChatController:emit('serverMessage', {
    user_id = ply:GetUserID(),
    message = message
  }) 
end)