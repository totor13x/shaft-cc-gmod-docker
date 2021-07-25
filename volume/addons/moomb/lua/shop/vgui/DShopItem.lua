local PANEL = {}

local adminicon = Material("icon16/shield.png")
local equippedicon = Material("icon16/eye.png")
local canshareicon = Material("icon16/user_go.png")
local privateicon = Material("icon16/key.png")
local groupicon = Material("icon16/group.png")
local onceicon = Material("icon16/tag_red.png")
local premiumicon = Material("icon16/rosette.png")

local color_text = Color(230,45,45)
TableInsertIcons = {}
LoadIconsInternally = function( )
	-- if #TableInsertIcons == 0 then
	if not next( TableInsertIcons ) then
		coroutine.yield()
	else
		for i, icon in ipairs( TableInsertIcons ) do
			coroutine.yield()
			coroutine.wait(0.1)
			-- PrintTable(icon)
			if IsValid(icon.self) then
				icon.self.Image = vgui.Create('HTML', icon.self)
				icon.self.Image:SetSize(icon.self:GetWide(), icon.self:GetTall())
				icon.self.Image:SetPos(0,0)
				icon.self.Image:MouseCapture( false )
				icon.self.Image:SetZPos(-1)
				-- self.Image:MoveAbove( self )
				icon.self.Image:SetHTML( [[
				<style>
					* {
					margin: 0px;
					padding: 0px;
					overflow: hidden;
					}
					</style>
				<div style="
					background-image: url(]] .. TTS.Shop.Data.CDN_URL .. icon.self.data.icon .. [[);
					width: 100%;
					height: 100%;
					background-size: cover;
					background-repeat: no-repeat;
					background-position: 0% 50%;
					display: block;
				"></div>
				-->
					<!--<img style="" src="]] .. TTS.Shop.Data.CDN_URL .. icon.self.data.icon .. [[" />-->
				]] )
			end
			table.remove(TableInsertIcons, i)
		end
	end
	-- end
end

IconCo = nil
hook.Add( "Think", "DisplayPlayersLocation", function()
	if not IconCo or not coroutine.resume( IconCo ) then
		IconCo = coroutine.create( LoadIconsInternally )
		coroutine.resume( IconCo )
	end
end )

function PANEL:Init()
	self.Info = ""
	self.InfoHeight = 30
	self:SetText("")
	self.MainColor = color_text
	self.SecondColor = Color(214, 139, 139, 0)
	self.DataName = ""
	self.DataPoints = 0
end

function PANEL:OnCursorEntered()
	self.Info = '+' .. self.DataPoints
end

function PANEL:OnCursorExited()
	self.Info = self.DataName
end

function PANEL:DoClick()
	-- print('aaa')
end
function PANEL:SetData(data)
	self.DataName = "Рандомный итем #"..math.random(0,100000)
	self.DataPoints = 0
	self.data = {}
	if data then
		self.data = data.data
		self.DataName = data.name or self.DataName
		self.DataPoints = data.points or self.DataPoints
    self.MainColor = data.Color or self.MainColor 
    self.SecondColor = data.SecondColor or self.SecondColor
	end
	if IsValid(self.DP) then
		self.DP:Remove()
	end
	if IsValid(self.Image) then
		self.Image:Remove()
	end
	self.Info = self.DataName
	if self.data.icon then
		table.insert(TableInsertIcons, {
			icon = self.data.icon,
			self = self,
		})
	end
	-- self.DP.Paint = function(s,w,h)
		-- surface.SetDrawColor(self.MainColor)
		-- surface.DrawRect(0,0, w, h)
		-- draw.SimpleText(self.Info, "S_Light_17", 5, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	-- end
	-- print(self:GetZPos())
	self.PanelFIx = vgui.Create('DButton', self)
	self.PanelFIx:Dock(FILL)
	self.PanelFIx:SetText("")
	self.PanelFIx.Paint = function(s,w,h) end
	function self.PanelFIx:DoClick()
		self:GetParent():DoClick()
	end
	
	function self.PanelFIx:OnCursorEntered()
		self:GetParent():OnCursorEntered()
	end
	
	function self.PanelFIx:OnCursorExited()
		self:GetParent():OnCursorExited()
	end
	
	self.DP = vgui.Create('DButton', self)
	self.DP:SetSize(self:GetWide(), self.InfoHeight)
	self.DP:Dock(BOTTOM)
	self.DP:SetText("")
	self.DP.OnRemove = function(s)
		if IsValid(self.Image) then
			self.Image:Remove()
		end
	end
	self.DP.Paint = function(s,w,h)
		surface.SetDrawColor(self.MainColor)
		surface.DrawRect(0,0, w, h)
		draw.SimpleText(self.Info, "S_Light_17", 5, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	function self.DP:DoClick()
		self:GetParent():DoClick()
	end
	
	function self.DP:OnCursorEntered()
		self:GetParent():OnCursorEntered()
	end
	
	function self.DP:OnCursorExited()
		self:GetParent():OnCursorExited()
	end
end

function PANEL:Paint()
	for k = 0, 10 do
		surface.SetMaterial(Material("vgui/white"))
		surface.SetDrawColor(self.SecondColor)
		surface.DrawTexturedRectRotated(k*20, k*20, 400, 15, 45)
	end
end
function PANEL:PaintOver()
	local mx, mw = 5, 16
	
  -- Для определенных групп
  -- PrintTable(self.data)
  if #self.data.roles > 0 then
		surface.SetMaterial(groupicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(mx, 15-8, 16, 16)
		mx = mx + 16+5
  end
		-- surface.SetMaterial(groupicon)
		-- surface.SetDrawColor(Color(255, 255, 255, 255))
		-- surface.DrawTexturedRect(mx, 15-8, 16, 16)
		-- mx = mx + 16+5
	if tobool(self.data.is_tradable) then // Для передаваемых
		surface.SetMaterial(canshareicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(mx, 15-8, 16, 16)
		mx = mx + 16+5
	end
	if tobool(self.data.is_hidden) then // Для приватных
		surface.SetMaterial(privateicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(mx, 15-8, 16, 16)
		mx = mx + 16+5
	end	
	if tobool(self.data.once) then // Для одноразовых
		surface.SetMaterial(onceicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(mx, 15-8, 16, 16)
		mx = mx + 16+5
	end	
	if tobool(self.data.is_premium) then // Для премиума
		surface.SetMaterial(premiumicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(mx, 15-8, 16, 16)
		mx = mx + 16+5
	end	
	
	if self.equip then
	// Для надетых
		surface.SetMaterial(equippedicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(self:GetWide() - 5 - mw, 15-8, 16, 16)
		mw = mw + 16
	end
	if self.Stacked then
		surface.SetFont( "S_Light_15" )
		local text = "("..self.Stacked..")"
		local width, height = surface.GetTextSize(text)
		surface.SetTextColor( 0, 0, 0 )
		surface.SetTextPos( self:GetWide() - 4 - mw - width+10, 15-8 ) 
		surface.DrawText( text )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( self:GetWide() - 5 - mw - width+10, 15-9 ) 
		surface.DrawText( text )
	end
end

vgui.Register('DShopItem', PANEL, 'DButton')
