local Player = FindMetaTable( "Player" )

function TTS.Libs.Interface.Notification(s64, data, bool)
	local ply = s64
	if bool or !ply:IsPlayer() then
		ply = player.GetBySteamID64(s64)
  end
  -- print('Notify ready')
	if ply then
		local send = {}
		send.text, send.type, send.length = data.message, data.type, data.length
		netstream.Start( ply, "TTS::Notification", send )
	end
end

function Player:Notify(text, typ, length )
  -- print(self, "Notify")
	TTS.Libs.Interface.Notification(self, {
		message = text,
		type = typ or NOTIFY_GENERIC,
		length = length or 4
	})
end