TTS.Libs = {
	Interface = {},
	Fixes = {},
	Bridges = {},
	Utils = {},
}

TTS.IncludeDir("libs/utils/") 		-- Что-то вспомогательное
TTS.IncludeDir("libs/bridges/") 	-- Мосты и интеграторы
TTS.IncludeDir("libs/data_lists/") 	-- Генераторы и разные списки (партикли, руки у моделей, етц)
TTS.IncludeDir("libs/fixes/") 		-- Фиксы, когда GLua дает сбои
TTS.IncludeDir("libs/interface/") 	-- VGUI и прочее, что относится к визуалу 
TTS.IncludeDir("libs/additionals/") -- Перезапись функций для каких-то костылей (да, костылей, потому что по другому никак)
