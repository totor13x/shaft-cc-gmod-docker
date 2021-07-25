TTS.Maps = { 
	mapList = {},
	mapListAllow = {},
	mapListBlock = {},
}

function refreshMapList()
	local data = file.Read("frog/maplistblock.txt", "DATA")
	TTS.Maps.mapListBlock = util.JSONToTable(data or '[]') or {}
	
	local mapfiles = file.Find("maps/*.bsp", "GAME", "nameasc")
	TTS.Maps.mapList = {}
	-- print(mapfiles)
	for i,v in pairs(mapfiles) do
		table.insert(TTS.Maps.mapList, v)
		if (!TTS.Maps.mapListBlock[v]) then
			table.insert(TTS.Maps.mapListAllow, v)
		end
	end
end
hook.Add("InitPostEntity", "maplist.Initialize", refreshMapList)
refreshMapList()
netstream.Hook('tts_get_maps', function(ply)
	if ply:hasPerm('edit_maplist') then
		netstream.Start(ply, "tts_get_maps", { maps = TTS.Maps.mapList, block = TTS.Maps.mapListBlock })
	end
end)

netstream.Hook("tts_get_maps_trigger", function(ply, map, data)
	if ply:hasPerm('edit_maplist') then
		TTS.Maps.mapListBlock[map] = (data == true and true or nil)
		file.Write("frog/maplistblock.txt", util.TableToJSON(TTS.Maps.mapListBlock))
		refreshMapList()
		netstream.Start(ply, "tts_get_maps", { maps = TTS.Maps.mapList, block = TTS.Maps.mapListBlock })
	end
end)