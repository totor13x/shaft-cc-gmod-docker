if !file.Exists("tts_data", "DATA") then
	file.mkdir('tts_data')
end

if WS.Bus.OnlineController then 
	WS:unsubscribe('server/online') 
end
 
WS.Bus.OnlineController = WS:subscribe('server/online')
 
local ipairs = ipairs
local UsersInOnline = {}


local ticks = math.floor( 1 / engine.TickInterval() )
local second_wrap = math.ceil(game.MaxPlayers()/ticks)
timer.Create( "TTS:UsersOnlineCounter", second_wrap, 0, function() 
	local os_time = os.time()
	os_time = os.date( "%Y-%m-%d %H:%M:%S" , os_time )
	local players = player.GetAll()
	co.wrap(function()
		for i, ply in ipairs(players) do
			co.waittick()
			local uid = ply:GetUserID()

			if !IsValid(ply) then continue end

			UsersInOnline[uid] = UsersInOnline[uid] or {
				sec = {
					on = 0,
					off = 0
				},
				start = os_time,
				last = os_time,
				timeout = 0
			}

			if ply:Alive() then
				UsersInOnline[uid].sec.on = UsersInOnline[uid].sec.on + second_wrap
			else
				UsersInOnline[uid].sec.off = UsersInOnline[uid].sec.off + second_wrap
			end
			UsersInOnline[uid].last = os_time
		end
	end)()
end )
local UpdateFile = 10 -- minutes
local MaxTimeout = 3 -- minutes
timer.Create( "TTS:UsersOnlineResolve", UpdateFile, 0, function() 
	local users = file.Read("users_online.json")
	users = util.JSONToTable(users or '[]') or {}
	co.wrap(function()
		for uid, data in pairs(users) do 
			co.waittick()
			local ply = UserIDToPlayer(uid)
			if IsValid(ply) then
				if data.timeout ~= 0 then
					UsersInOnline[uid].sec.on =
						UsersInOnline[uid].sec.on + data.sec.on
					UsersInOnline[uid].sec.off =
						UsersInOnline[uid].sec.off + data.sec.off
					
					UsersInOnline[uid].timeout = 0
				end
			else
				UsersInOnline[uid] = nil

				if users[uid].timeout >= MaxTimeout then
					WS.Bus.OnlineController:emit('save', {
						user_id = uid,
						zone = os.date('%z', os.time()),
						data = users[uid]
					})
					users[uid] = nil
				else
					users[uid].timeout = users[uid].timeout + 1
				end
			end
		end
		
		for uid, data in pairs(UsersInOnline) do 
			co.waittick()
			users[uid] = data
			--
		end
		co.waittick()
		file.Write('users_online.json', util.TableToJSON(users))	
	end)()
	

end)

hook.Add("ShutDown", "TTS:UsersOnlineSaveData", function()
	local users = file.Read("users_online.json")
	users = util.JSONToTable(users or '[]')
	

	for uid, data in pairs(UsersInOnline) do 
		users[uid] = data
	end

	file.Write('users_online.json', util.TableToJSON(users))
end) 

if WS.Bus.LogsController then 
	WS:unsubscribe('server/logs') 
end
 
WS.Bus.LogsController = WS:subscribe('server/logs')