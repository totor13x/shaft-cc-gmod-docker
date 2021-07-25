
local blur = Material( "pp/blurscreen" )
local PANEL = {}
-- function PANEL:SetTitle(text)
	-- self.m_Title = text
-- end
function PANEL:Init()
	-- self.lblTitle:SetText( '' )
end

function PANEL:Paint(w,h)

	surface.SetDrawColor( 35, 35, 35, 230 )
	surface.DrawRect( 0, 0, w, h )
	
	local x, y = self:LocalToScreen(0, 0)

	surface.SetMaterial( blur )

	-- for i = 1, 10 do
		blur:SetFloat( "$blur", ( 1 / 10 ) * 20 )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	-- end
	
	surface.SetDrawColor( 35, 35, 35, 230/2 )
	surface.DrawRect( 0, 0, w, h )
	if self.m_Title then
		draw.SimpleText(self.m_Title, "S_Regular_20", 10, 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end

	if self:GetSizable() then
		local triangle1 = {
			{ x = w-5, y = h-1 }, { x = w-1, y = h-5 }, { x = w-1, y = h-1 }	
		}
		surface.SetDrawColor( Color(255, 255, 255, 150) )
		draw.NoTexture()
		surface.DrawPoly( triangle1 )
	end
end 

vgui.Register( ".CCFrame", PANEL, "DFrame" )