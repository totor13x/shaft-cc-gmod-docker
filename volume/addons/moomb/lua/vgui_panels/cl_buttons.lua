SINGLE = 1
FULL = 2

BORDER_LEFT = 1
BORDER_TOP = 2
BORDER_RIGHT = 3
BORDER_BOTTOM = 4

local lastSlot = lastSlot or 1
local lifeTime = lifeTime or 0
local deathTime = deathTime or 0
local font_hud_weapon = 'S_Light_20'
local textcolor_pulsed = Vector(1,1,1)

surface.CreateFont( "TextNumbers", { size = 40, weight = 100 } )
surface.CreateFont( "TextFr", { font = "default", size = 40 } )

local PANEL = {}

function PANEL:Init()
	self.LerpedColor = Color(94, 130, 158)
	self.TextColorLerped = Color(0,0,0)
	self.LerpedColorAlphaBorders = 0
	self.LerpedColorAlphaBlock = 0
	self.Text = ""
	self:SetText("")
	self.Font = "TextNumbers"
	self.TextAlignX = TEXT_ALIGN_CENTER
	self.TextAlignY = TEXT_ALIGN_CENTER
	self.LastClick = CurTime()
	self.entered = false
	self.special = false
	self.onclick = false
	self.isborder = FULL
	self.isbordertype = BORDER_LEFT
	self.FakeActivated = false
	self.Active = false
	self.isdarken = false
end


function PANEL:Paint(w,h)
	if !self.XPos then self.XPos = w/2 end	
	if !self.YPos then self.YPos = h/2 end	
	if ( self.Depressed || self:IsSelected() || self:GetToggle() ) then
		self.LerpedColorAlphaBlock = 255
	end
	if self.Active then
		self.LerpedColorAlphaBorders = 255
		self.LerpedColorAlphaBlock = 255
	end
	if !self.onclick and !self.Depressed and !self.Active then
	if (self.LerpedColorAlphaBlock != 0) then
		self.LerpedColorAlphaBlock = Lerp(FrameTime()*20, self.LerpedColorAlphaBlock, 0 )
		if self.LerpedColorAlphaBorders > 120 then
			self.LerpedColorAlphaBorders = self.LerpedColorAlphaBlock
		end
	end
	end
	if (!self.entered && self.LerpedColorAlphaBorders != 0) then
		self.LerpedColorAlphaBorders = Lerp(FrameTime()*17, self.LerpedColorAlphaBorders, 0 )
	end
	if self.FakeActivated && self.LerpedColorAlphaBorders < 70 then
		self.LerpedColorAlphaBorders = 70
	end
	if self.Active then
		self.LerpedColorAlphaBorders = 255
	end
	if self._LerpedColor then
		self.LerpedColor = self._LerpedColor
		self._LerpedColor = nil
	end
	if self:GetDisabled() then
		self._LerpedColor = self.LerpedColor
		self.LerpedColor = Color(120, 120, 120)
		self.LerpedColorAlphaBorders = 40
	end
	if self.LerpedColorRewrite then
		self.LerpedColorAlphaBorders = self.LerpedColorRewrite
	end
	local tempborders = table.Copy(self.LerpedColor) //Для блока
	tempborders.a = self.LerpedColorAlphaBorders//Для блока
	
	local tempblock = table.Copy(self.LerpedColor) //Для блока
	tempblock.a = self.LerpedColorAlphaBlock//Для блока
	
	local temptext = Color(255,255,255)
	temptext.a = 255 - (120-self.LerpedColorAlphaBorders)
	
	if self.onclick or self.Depressed then temptext.a = 255 end
	if self.isborder == SINGLE then
		tempblock.a = 0
	end
	if self.Active && self.isdarken then
		draw.RoundedBox( 0, 0, 0, w, h, Color(33,33,33,(self.LerpedColorAlphaBorders-120)))
	end
	draw.RoundedBox( 0, 0, 0, w, h, tempblock )
	if self.isborder == FULL then
		draw.RoundedBox( 0, 2, 0, w-4, 2, tempborders )
		draw.RoundedBox( 0, 0, 0, 2, h, tempborders )
		draw.RoundedBox( 0, w-2, 0, 2, h, tempborders )
		draw.RoundedBox( 0, 2, h-2, w-4, 2, tempborders ) 
	elseif self.isborder == SINGLE then
		if self.isbordertype == BORDER_LEFT then
			draw.RoundedBox( 0, 0, 0, 3, h, tempborders )
		elseif self.isbordertype == BORDER_TOP then
			draw.RoundedBox( 0, 0, 0, w, 3, tempborders )
		elseif self.isbordertype == BORDER_RIGHT then
			draw.RoundedBox( 0, w-3, 0, 3, h, tempborders )
		elseif self.isbordertype == BORDER_BOTTOM then
			draw.RoundedBox( 0, 0, h-3, w, 3, tempborders )
		end
	else
		draw.RoundedBox( 0, 0, 0, w, h, tempborders )
	end
	self.TextColorLerped = temptext
	draw.SimpleText( self.Text, self.Font, self.XPos, self.YPos, temptext, self.TextAlignX, self.TextAlignY )
end

function PANEL:OnCursorEntered()
	self.LerpedColorAlphaBorders = 120 
	self.entered = true 
end

function PANEL:SetBorders(bool)
	self.isborder = bool
end
function PANEL:SetBordersType(bool)
	self.isbordertype = bool
end
function PANEL:SetDarkBackground(bool)
	self.isdarken = bool
end

function PANEL:OnCursorExited()
	self.entered = false 
end

function PANEL:DoClick()
end

vgui.Register( ".CCButton", PANEL, "DButton" )