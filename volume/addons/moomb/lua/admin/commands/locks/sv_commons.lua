
TTS.Admin.Methods.GiveLock = function(typ, caller, target, length, idrule, comment)
	if typ == nil then
		typ = 'ban'
	end
	TTS.HTTP(
		'/api/admin/locks/create', 
		{
			on_server = TTS.Config.Server.id,
			is_accepted = true,
			executor = isstring(caller) and caller or caller:GetUserID(),
			steamid = target:SteamID(),
			type = typ,
			reason = idrule,
			comment = comment,
			length = length / 60, -- Конвертация в минуты
			api_token = caller.TTS.Data.api_token
		},
		function(data)
			-- print(data)
			if IsValid(caller) then
				caller:Notify(data) 
			end
			-- TTS:AddNote( data, NOTIFY_GENERIC, 5 )
			-- self:CategoryItemsFill(pnl, id)
		end,
		function(data)
			if IsValid(caller) then
				caller:Notify(data, NOTIFY_ERROR, 4) 
			end
			-- print('error', data)
			-- TTS:AddNote( data, NOTIFY_ERROR, 4 )
		end
	)
end

do
	WS.Bus.AdminController:on('refreshLocks', function(data)
		local ply = UserIDToPlayer(data.user_id)           
	-- PrintTable(data)
	-- print(ply)
		if IsValid(ply) then
			hook.Run(
				"TTS.Admin::RefreshLocks",
				ply,
				data.locks
			)
		end
	end)
end
