TTSBalance = 0

netstream.Hook('tts_balance', function(balance)
	TTSBalance = balance
end)