local Player = FindMetaTable( 'Player' )

function Player:IsPremium()
	return self:GetNWBool('is_premium')
end