gameevent.Listen( "player_connect" ) 

local times = 0

hook.Add( "player_connect", "TTS.CheckConnection", function( data )
	times = CurTime()
	-- PrintTable(data)
	WS.Bus.AdminController:emit('banned', data.networkid)


	-- http.Fetch('https://shaft.cc/mecha/discord/validateTester?v=v2&s32=' .. data.networkid, function(dat)
	-- 	if dat ~= 'true' then
	-- 		game.KickID( data.networkid, 'Нет доступа к тестированию. Если Вы считаете это ошибкой, обратитесь к администрации shaft.cc' )
	-- 	end
	-- end)
end )
do
	WS.Bus.AdminController:on('banned', function(data) -- Проверка на бан 
		-- PrintTable(data)
		if data.steamid and (data.locks and data.locks.ban) then
			local reason = [[
			Вы заблокированы
			
			Подробнее можно узнать на https://shaft.cc]]
			game.KickID( data.steamid, reason ) 
		end 
		-- PrintTable(data) 
	end)
end

local Player = FindMetaTable( 'Player' )
function Player:Ban(length, nilval, reason)
	TTS.Admin.Methods.GiveLock('ban', '1', self, length, {'9.99'}, reason)
end

hook.Add('TTS.Admin::RefreshLocks', 'TTS.Admin.Locks::ReceiveBan', function(ply, locks)
	if locks and locks.ban then
	
		local reason = [[
		Вы заблокированы
		
		Подробнее можно узнать на https://shaft.cc]]
		
		ply:Kick(reason)
	end 
end)
--[[
TTS.HTTP('/api/server/admin/lock/create', {
  user_id = 12, 
  type = 'ban',  
  reason = {'1.1'},  
  comment = 'Comment', 
  executor_user_id = 12, 
  length = 120*60 
}, function(data)
  print(data)               
end) 
]]--