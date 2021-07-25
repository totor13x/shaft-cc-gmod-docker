-- Count - 5
-- Data - {'поинтов','поинт','поинта'}

function TTS.Libs.Interface.Plural( count, data )
	clear = count;
	local explod = string.sub(clear, -1)
		  explod = tonumber(explod)

		if(explod == 0) then
			tetd = data[1];
		elseif ((clear == 11) or (clear == 12) or (clear == 13) or (clear == 14)) then
			tetd = data[1];
		elseif (explod == 1) then
			tetd = data[2];
		elseif (explod < 5) then
			tetd = data[3];
		else 
			tetd = data[1];
		end
	
	return tetd
end
local tonumber = tonumber
function TTS.Libs.Interface.sec2Min(secs, withtime, withost)
	secs = tonumber(secs)
	local timeout
	local ostalost = "Осталось"

	if (secs < 60) then
		timeout = secs;
		tetd = TTS.Libs.Interface.Plural( timeout , {"секунд", "секунда", "секунды"} )
		if tetd == "секунда" then ostalost = "Осталась" end
	elseif (secs < 3600) then
		timeout = math.Round(secs / 60);
		tetd = TTS.Libs.Interface.Plural( timeout , {"минут", "минута", "минуты"} )
		if tetd == "минута" then ostalost = "Осталась" end
	elseif (secs < 86400) then
		timeout = math.Round(secs / 3600);
		tetd = TTS.Libs.Interface.Plural( timeout , {"часов", "час", "часа"} )
		if tetd == "час" then ostalost = "Остался" end
	elseif (secs < 2629743) then
		timeout = math.Round(secs / 86400);
		tetd = TTS.Libs.Interface.Plural( timeout , {"дней", "день", "дня"} )
		if tetd == "день" then ostalost = "Остался" end
	elseif (secs < 31556926) then
		timeout = math.Round(secs / 2629743);
		tetd = TTS.Libs.Interface.Plural( timeout , {"месяцев", "месяц", "месяца"} )
		if tetd == "месяц" then ostalost = "Остался" end
	else
		timeout = math.Round(secs / 31556926);
		tetd = Plural( timeout , {"лет", "год", "года"} )
		if tetd == "год" then ostalost = "Остался" end
	end
	
	local out = ""
	if withost then
		out = ostalost.." "
	end
	if withtime then
		out = out..timeout.." "
	end
	
	out = out..tetd
	return out

end
function TTS.Libs.Interface.sec2MinNearTo(secs, withtime, withost)
	secs = tonumber(secs)
	local timeout
	local ostalost = "Осталось"

	if (secs < 60) then
		timeout = secs;
		tetd = TTS.Libs.Interface.Plural( timeout , {"секунд", "секунду", "секунды"} )
		if tetd == "секунда" then ostalost = "Осталась" end
	elseif (secs < 3600) then
		timeout = math.Round(secs / 60);
		tetd = TTS.Libs.Interface.Plural( timeout , {"минут", "минуту", "минуты"} )
		if tetd == "минута" then ostalost = "Осталась" end
	elseif (secs < 86400) then
		timeout = math.Round(secs / 3600);
		tetd = TTS.Libs.Interface.Plural( timeout , {"часов", "час", "часа"} )
		if tetd == "час" then ostalost = "Остался" end
	elseif (secs < 2629743) then
		timeout = math.Round(secs / 86400);
		tetd = TTS.Libs.Interface.Plural( timeout , {"дней", "день", "дня"} )
		if tetd == "день" then ostalost = "Остался" end
	elseif (secs < 31556926) then
		timeout = math.Round(secs / 2629743);
		tetd = TTS.Libs.Interface.Plural( timeout , {"месяцев", "месяц", "месяца"} )
		if tetd == "месяц" then ostalost = "Остался" end
	else
		timeout = math.Round(secs / 31556926);
		tetd = Plural( timeout , {"лет", "год", "года"} )
		if tetd == "год" then ostalost = "Остался" end
	end
	
	local out = ""
	if withost then
		out = ostalost.." "
	end
	if withtime then
		out = out..timeout.." "
	end
	
	out = out..tetd
	return out

end


function TTS.Libs.Interface.rgbToHex(rgb)
	local hexadecimal = ''

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end