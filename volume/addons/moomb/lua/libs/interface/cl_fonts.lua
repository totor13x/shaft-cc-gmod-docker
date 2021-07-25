function CreateOpenSansFonts(name, font, size)
	local params = {}
	params['font'] = font
	params['size'] = size
	params['antialias'] = true
	params['extended'] = true
	if string.find(name, "Italic") then
		params['italic'] = true
	end
	if string.find(name, "Light") then
		params['weight'] = 100
	end
	surface.CreateFont( name.."_"..size, params )
end

local sizes = {10,15,17,20,23,25,30,35,40,50,60,70,80,90,100,110,120,125,130,140,145,150}
local fonts = {}
fonts['OpenSans-BoldItalic-ShaftIM'] = "S_BoldItalic"
fonts['OpenSans-Bold-ShaftIM'] = "S_Bold"
fonts['OpenSans-ExtraBI-ShaftIM'] = "S_ExtraBoldItalic"
fonts['OpenSans-ExtraBold-ShaftIM'] = "S_ExtraBold"
fonts['OpenSans-Italic-ShaftIM'] = "S_Italic"
fonts['OpenSans-LightItalic-ShaftIM'] = "S_LightItalic"
fonts['OpenSans-Light-ShaftIM'] = "S_Light"
fonts['OpenSans-Regular-ShaftIM'] = "S_Regular"
fonts['OpenSans-SemiBI-ShaftIM'] = "S_SemiBoldItalic"
fonts['OpenSans-SemiBold-ShaftIM'] = "S_SemiBold"

for i,size in pairs(sizes) do
	for font, name in pairs(fonts) do
		CreateOpenSansFonts(name, font, size)
	end
end