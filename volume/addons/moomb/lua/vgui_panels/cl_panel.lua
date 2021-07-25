local PANEL = {}

function PANEL:Init()
	
end

function PANEL:Paint(w,h)
	surface.SetDrawColor( 35, 35, 35, 230 )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
end

vgui.Register( ".CCPanel", PANEL, "DPanel" )