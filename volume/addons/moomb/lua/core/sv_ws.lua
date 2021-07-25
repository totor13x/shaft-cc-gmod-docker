CurBlock = CurBlock or 0

if CurBlock > CurTime() then return end

CurBlock = CurTime() + 0.1

require("gwsockets")

local topicMeta = {}
topicMeta.__index = topicMeta

if WS then 
	WS:close()
end
-- print('123')
WS = GWSockets.createWebSocket("wss://" .. TTS.URL_WS .. "/ws" , false)
WS:setHeader( "Authorization", TTS.Token )
WS.Types = {
    OPEN = 0,
    JOIN = 1,
    LEAVE = 2,
    JOIN_ACK = 3,
    JOIN_ERROR = 4,
    LEAVE_ACK = 5,
    LEAVE_ERROR = 6,
    EVENT = 7,
    PING = 8,
    PONG = 9
}
local lostConnections = 0
WS.Config = {
	clientAttempts = 3,
	clientInterval = 25000,
	reconnectionDelay = 1,
	reconnectionAttempts = 10,
}

WS.JoinedChannels = {} -- Для реджоина
WS.Callbacks = {}
WS.Bus = {}

function WS:onMessage(txt)
	local packet = util.JSONToTable(txt)
	
	if TTS.DEBUG then
		print("Received: ", string.len(txt))
		
		print(txt)
	end
	if self.Types.OPEN == packet.t then
		WS.Emitter._handleOpen(packet)
	end
	if self.Types.PONG == packet.t then
		WS.Emitter._pingTimer()
	end
	if self.Types.JOIN_ACK == packet.t then
		WS.Emitter._handleJoinAck(packet)
	end
	if self.Types.LEAVE_ACK == packet.t then
		WS.Emitter._handleLeaveAck(packet)
	end
	if self.Types.EVENT == packet.t then
		WS.Emitter._handleEvent(packet)
	end
	if self.Types.JOIN_ERROR == packet.t then 
		// TODO: Реализовать запись логов
	end
end 

function WS:onError(txt, data) 
	print("Error: ", txt, data)
end

function WS:onConnected()
	print("Connected to echo server")
	
end

function WS:onDisconnected()
	print("WebSocket disconnected")
	lostConnections = lostConnections + 1
	
	if lostConnections > WS.Config.reconnectionAttempts then
		return
	end
	-- print(lostConnections  * WS.Config.reconnectionDelay, 'data')
	timer.Simple(lostConnections * WS.Config.reconnectionDelay, function()
		WS:open()
	end)
end
function WS:subscribe(topic)
	local t = {}
	t.topic = topic
	-- t.msgs = msgs or {}
	setmetatable(t, topicMeta)
	-- print(topic, 'subscribe')
	-- WS.Callbacks
	WS.Callbacks[topic] = {}
	do
		WS.Emitter._emit( self.Types.JOIN, { topic = topic } )
	end
	return t
end
function WS:unsubscribe(topic)
	WS.Callbacks[topic] = nil

	do
		WS.Emitter._emit( self.Types.LEAVE, { topic = topic } )
	end
	return t
end 

function WS:ontopic(topic)
	return WS.Callbacks[topic]
end

WS.Emitter = {
	_handleOpen = function(packet)
		-- PrintTable(packet)
		-- print(lostConnections)
		if lostConnections != 0 then
			if table.Count(WS.JoinedChannels) != 0 then
				for topic,v in pairs(WS.JoinedChannels) do
					WS.Emitter._emit( WS.Types.JOIN, { topic = topic } )
				end
			end
		end
		WS.Config.clientAttempts = packet.d.clientAttempts
		WS.Config.clientInterval = packet.d.clientInterval
		lostConnections = 0
		timer.Destroy("WS::Reconnect")
		WS.Emitter._pingTimer()


		if WS:ontopic('server/global') then
			WS:unsubscribe('server/global')
		end
		local channel = WS:subscribe('server/global')
		
		channel:on('open', function()
			channel:emit('auth')
		end)
		channel:on('auth', function(data)
			TTS.Config.Server = data 
			hook.Run('TTS:AuthServer')
		end)
		channel:on('onlinePlayers', function(data)
			-- print(#player.GetAll())
			-- print(game.MaxPlayers())
			-- print(game.GetIPAddress())
			channel:emit('onlinePlayers', {
				players = #player.GetAll(),
				max_players = game.MaxPlayers(),
				ip = game.GetIPAddress()
			})
			-- TTS.Config.Server = data 
			-- hook.Run('TTS:AuthServer')
		end)
		channel:on('notifyUser', function(data)
		  if TTS.DEBUG then
			PrintTable(data)
		  end
			local ply = UserIDToPlayer(data.user_id)
      print(data.user_id, ply)
			if IsValid(ply) then
				ply:Notify(data.message, data.type, data.length)
        -- netstream.Start(ply, 'TTS::Notification', {
        --   text = data.message or '',
        --   type = data.type or NOTIFY_GENERIC, 
        --   length = data.length or 8
        -- })
			end
		end)
		-- do
			-- local channel = WS:subscribe('test')
			-- channel:on('topic', function(data)
				-- channel:emit('messag1e', data .. "4")
			-- end)
			-- PrintTable(channel)
		-- end
	end,
	_handleJoinAck = function(packet)
		if !WS.JoinedChannels[packet.d.topic] then
			WS.JoinedChannels[packet.d.topic] = true
		end
		print('joined', packet.d.topic) 
		WS.Callbacks[packet.d.topic] = WS.Callbacks[packet.d.topic] or {}
	end,
	_handleLeaveAck = function(packet)
		if WS.JoinedChannels[packet.d.topic] then
			WS.JoinedChannels[packet.d.topic] = nil
		end
	end,
	_handleEvent = function(packet)
		if WS.Callbacks[packet.d.topic] then
			if WS.Callbacks[packet.d.topic][packet.d.event] then
				WS.Callbacks[packet.d.topic][packet.d.event](packet.d.data)
			end
		end
		-- PrintTable(packet)
		-- print('handle event')
	end,
	_pingTimer = function()
		timer.Create("WS::Reconnect", WS.Config.clientInterval/1000, 1, function()
			WS.Emitter._emit(WS.Types.PING)
			-- WS:emit('ping')
		end)
		-- timer.Create(WS.Config.clientInterval, function()
	end,
	_emit = function( event, data )
		WS:write(util.TableToJSON(
			WS.Emitter._makePacket(
				event,
				data
			)
		))
	end,
	_makePacket = function(event, data)
		return {
			t = event,
			d = data
		}
	end
}

--[[		topicMeta		]]--
function topicMeta:on(event, cb)
	-- print(self.topic)
	-- print(WS.Callbacks[self.topic])
	if !istable(WS.Callbacks[self.topic]) then
		MsgC(Color(255,0,0), "[TTS:WS] Not join topic.\n")
		return
	end
	if !isfunction(cb) then
		MsgC(Color(255,0,0), "[TTS:WS] event " .. event .. " on " .. self.topic .. " topic must be a function.\n")
		return
	end
	WS.Callbacks[self.topic][event] = cb
	
	-- print(topic)
	-- print(cb)
end
function topicMeta:off(event)
	-- print(self.topic)
	-- print(WS.Callbacks[self.topic])
	if !istable(WS.Callbacks[self.topic]) then
		MsgC(Color(255,0,0), "[TTS:WS] Not joined topic.\n")
		return
	end
	-- if !isfunction(cb) then
		-- MsgC(Color(255,0,0), "[TTS:WS] event " .. event .. " on " .. self.topic .. " topic must be a function.\n")
		-- return
	-- end
	WS.Callbacks[self.topic][event] = nil
	
	-- print(topic)
	-- print(cb)
end
function topicMeta:emit(event, data)
	WS.Emitter._emit(WS.Types.EVENT, {
		topic = self.topic,
		event = event,
		data = data
	})
end

do
	WS:open() 
end
TTS.WS = WS

