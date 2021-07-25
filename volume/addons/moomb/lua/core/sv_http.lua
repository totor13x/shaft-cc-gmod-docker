local function fetch(url, params, callback, callback_false)
	params = params or {}
	params['srv_token'] = TTS.Token
	
  for i,v in pairs(params) do
    if istable(v) then
      v = util.TableToJSON(v)
    end
		params[i] = tostring(v)
	end
	
	local url_ = "https://".. TTS.URL_API ..""..url
	print(url_)
	timer.Simple(0, function()  
		http.Post( url_, params, callback and function( result ) 
			local d = util.JSONToTable(result)
			if !d or d.e == 'error' then
				local err = !d and ("BROKEN JSON. Body: " .. tostring(result)) or d
				local sparams = "\n"
				for k,v in pairs(params) do
					sparams = sparams .. ("\t%s = %s\n"):format(k,v)
				end

				local split = string.rep("-",50)
				local err_log =
					os.date("%Y-%m-%d %H:%M\n") ..
					split ..
					"\nURL: " .. url_ ..
					"\nMethod: " .. url ..
					"\nError: "  .. tostring(err) ..
					"\nParams: " .. sparams ..
					split .. "\n\n\n"

				print(err_log)
				file.Append("tts_errors.txt",err_log)

				callback( false )
			elseif d.e == 'success' then 
				callback( d.d )
			elseif d.errors or d.message then
				if callback_false then
					callback_false(d.message, d.errors)
				end
			end
		end,
		function (err, data)
			print(err, data)
			if callback_false then
				callback_false(err, data)
			end
		end)
	end)
end

TTS.HTTP = fetch