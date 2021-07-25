TTS.Tags = TTS.Tags or {
    Cache = {},
	Owned = {},
}

hook.Add("TTS.PlayerInitialSpawn", "TTS:DownloadTags", function()
    TTS.HTTP('/api/cache/tags/gmod', {}, function(data)
        TTS.Tags.Cache = {}
        -- PrintTable(data)
        for id, tag in pairs(data) do
            TTS.Tags.Cache[id] = TTS.Tags.Cache[id] or {}
            for _, dat in pairs(tag) do
                table.insert(TTS.Tags.Cache[id], {
                    color = Color(dat[1].r, dat[1].g, dat[1].b),
                    text = dat[2]
                })
            end
        end
    end)
end) 

function TTS.Tags:GetTag(id) 
    local tag = TTS.Tags.Cache[id]

    return tag or false
end

netstream.Hook('TTS:TagsPly', function(tags)
	TTS.Tags.Owned = tags
end)

local function OnPlayerChat( ply, strText, bTeamOnly, bPlayerIsDead )
	local tab = {}
	
	local defcol = Color( 0, 201, 0 ) 
	 
	if GAMEMODE.round_state and ply:IsSpec() and not bPlayerIsDead then
		bPlayerIsDead = true
	end
	
	if ( bPlayerIsDead ) then
		table.insert( tab, Color( 255, 30, 40 ) ) 
		table.insert( tab, "*DEAD* " ) 
	end	
	
	if ( bTeamOnly ) then
		if not GAMEMODE.round_state then
			table.insert( tab, Color( 30, 160, 40 ) )
			table.insert( tab, "(TEAM) " )
		end
	end

	local is_tag = false
	local tag = ply:GetNWString("tag_id")
	if tag ~= '' then
		local essence_tag = TTS.Tags:GetTag(tag)
		
		if essence_tag then
			-- PrintTable(essence_tag)
			for i,v in pairs(essence_tag) do
				table.insert( tab, v.color )
				table.insert( tab, v.text )
			end
		is_tag = true
		end
		-- local tag = TTS.Tags[i]
		-- if tag and tag.gmod then
			-- for i,v in pairs(tag.gmod) do
				-- table.insert( tab, v[1] )
				-- table.insert( tab, v[2] )
			-- end
		-- end
	end
	if is_tag then
		table.insert( tab, ' ' )
	end
	
	if ( IsValid( ply ) ) then
		table.insert( tab, defcol )
		table.insert( tab, ply )
	else
		table.insert( tab, Color( 0, 0, 0 ) )
		table.insert( tab, "(Console)" )
	end
	
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..string.Trim(strText))
	
	chat.AddText( unpack( tab ) )
 
	return true	
end
hook.Add( "OnPlayerChat", "Shaft.Tags", OnPlayerChat )
