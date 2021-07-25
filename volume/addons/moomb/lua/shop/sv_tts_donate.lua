-- print('f')

if not WS.Bus.UserController then
	WS.Bus.UserController = WS:subscribe('users')
end

local Player = FindMetaTable('Player')

function Player:RefreshTTSBalance()
	WS.Bus.UserController:emit('ttsBalance', {
		steamid = self:SteamID64()
	})
end

function Player:SetTTSBalance(balance)
	self.TTSBalance = balance
	netstream.Start(self, 'tts_balance', balance)
end

hook.Add('PlayerInitialSpawn', "TTS.StartDefaultBalance", function(ply)
	ply:SetTTSBalance(0)
	ply:RefreshTTSBalance()
end)

WS.Bus.UserController:on('ttsBalance', function(data)
	PrintTable(data)
	if data.steamid then
		local ply = player.GetBySteamID64(data.steamid)
		if ply then
			ply:SetTTSBalance(data.balance)
		end
	end
end)
