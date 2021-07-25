TTS.Taunts = {}

TTS.HTTP('/api/server/taunts', {}, function(data)
	TTS.Taunts = {}
	for i, v in pairs(data) do
		TTS.Taunts[v.slug] = TTS.Taunts[v.slug] or {}
		
		for name_id, array in pairs(v.data) do
			TTS.Taunts[v.slug][name_id] = TTS.Taunts[v.slug][name_id] or {}
			for _, taunt in pairs(array) do
				table.insert(TTS.Taunts[v.slug][name_id], {
					cdn = v.cdn .. '/' .. taunt.s3,
					length = taunt.length
				})
			end
		end
	end
	-- PrintTable(TTS.Taunts)
end)

local Player = FindMetaTable( "Player" )

function Player:PlayTaunt(typ, is_random)
	if is_random == nil then
		if math.random(1,4) != 2 then 
			return false
		end 
	end
	if (self.LastTauntPlayer or 0) > CurTime() then
		return false
	end
	
	if not self:GetNWBool('taunt') then return false end
	
	local taunt = self:GetNWString('tauntstring')
	
	if not TTS.Taunts[taunt] then return false end
	if not TTS.Taunts[taunt][typ] then return false end
	
	local data = table.Random(TTS.Taunts[taunt][typ])
	
	self.LastTauntPlayer = CurTime() + data.length + 1
	netstream.Start(_, "TTS::PlayTaunt", self, data.cdn)
	
	return data.cdn 
end

netstream.Hook('TTS::TauntPreview', function(ply, taunt, typ)
	if (ply.LastTauntPlayerPreview or 0) > CurTime() then
		return false
	end
	
	-- if not self:GetNWBool('taunt') then return false end
	
	-- local taunt = self:GetNWString('tauntstring')
	
	if not TTS.Taunts[taunt] then return false end
	if not TTS.Taunts[taunt][typ] then return false end
	
	local data = table.Random(TTS.Taunts[taunt][typ])
	
	ply.LastTauntPlayerPreview = CurTime() + 1
	netstream.Start(ply, "TTS::PlayTaunt", ply, data.cdn)
end)
