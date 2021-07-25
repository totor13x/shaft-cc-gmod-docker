TTS.Admin = {}  
TTS.Admin._index = {} 
TTS.Admin.Methods = {}
TTS.Admin.prefix = '!'

-- Error msg 
function TTS.Admin:ErrorLog(msg)
	MsgC(Color(255,0,0), '[TTS.Admin] ' .. msg .. '\n')
end
 
-- ServerGuard Immunity
TI = {}
TI.EQUAL = 1 -- рейт равен твоему
TI.LESS = 2 -- меньше чем твой рейт
TI.LESSOREQUAL = 3 -- меньше или равно твоему рейту
TI.ANY = 4 -- любой

-- Register functions after load core methods
timer.Simple(0, function()
  TTS.LoadSH('admin/tabs/sh_init.lua')  
  TTS.LoadSH('admin/commands/sh_commands.lua')  

  TTS.IncludeDir("admin/logs/")
end)
-- TTS.LoadCL('shop/vgui/dshoppreview.lua')
-- TTS.LoadCL('shop/vgui/dshopitem.lua')

-- TTS.Functions = {}
-- TTS.LoadCL('shop/functions/cl_previewitem.lua')
