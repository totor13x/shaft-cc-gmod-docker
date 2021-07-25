-- Blur
local blur = Material( "pp/blurscreen" )
function TTS.Libs.Interface.Blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	if IsValid(panel) then
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
	end
end