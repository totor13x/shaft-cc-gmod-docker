netstream.Hook('TTS::ItemDataSave', function(ply, data)
	if ply:hasPerm('ap-mng-ps-items') then
		TTS.HTTP(
			'/api/server/pointshop/save_item_data', 
			{
				item_id = data.id,
				pos = data.pos,
				ang = data.ang,
				name = data.name,
				scale = data.scale,
			},
			function(data)
				ply:Notify( data, NOTIFY_GENERIC, 3 )
			end
		)
	end
end)

netstream.Hook('TTS::ItemIconSave', function(ply, data)
	if ply:hasPerm('ap-mng-ps-items') then
		TTS.HTTP(
			'/api/server/pointshop/save_icon_data', 
			{
				item_id = data.id,
				icon = data.icon,
			},
			function(data)
				ply:Notify( data, NOTIFY_GENERIC, 3 )
			end
		)
	end
end)