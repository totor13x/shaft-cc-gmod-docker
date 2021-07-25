TTS = {}
TTS.Config = {} 
TTS.Player = {} 
TTS.DEBUG = false
TTS.URL = CLIENT and "shaft.cc" or 'shaft.cc'
TTS.URL_API = 'api.shaft.cc'
TTS.URL_WS = "shaft.cc"
 

 
if TTS.DEBUG then
  TTS.URL = "app.local"
  TTS.URL_API = 'api.app.local'
  TTS.URL_WS = "app.local"
end

// TTS.URL = "app.local:8000"

TTS.LoadCL = function (file)  
	if SERVER then AddCSLuaFile(file) end 
	if CLIENT then include(file) end 
end
TTS.LoadSH = function (file) 
	if SERVER then AddCSLuaFile(file); end 
	include(file)
end
TTS.LoadSV = function (file)
	if SERVER then include(file) end 
end

local function include_dir(folder)
	local files, subfolder = file.Find(folder.."*", "LUA")
	for k, filename in pairs(files) do
		if filename:sub(1,3) == "ob_" then
			continue
		end
		if filename:sub(1,3) == "cl_" then
			TTS.LoadCL(folder..filename)
		elseif filename:sub(1,3) == "sv_"  then
			TTS.LoadSV(folder..filename) 
		else
			TTS.LoadSH(folder..filename)
		end
	end
end 
TTS.IncludeDir = include_dir

TTS.LoadSV('sv_config.lua')

include_dir("libs/") 
include_dir("core/")
include_dir("vgui_panels/")
include_dir("modules/")
include_dir("admin/")
include_dir("shop/")
include_dir("defend/")
