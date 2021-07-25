TTS.Libs.Utils.QuadLerp = function ( frac, p1, p2 )

    local y = (p1-p2) * (frac -1)^2 + p2
    return y

end

TTS.Libs.Utils.InverseLerp = function ( pos, p1, p2 )

	local range = 0
	range = p2-p1

	if range == 0 then return 1 end

	return ((pos - p1)/range)

end