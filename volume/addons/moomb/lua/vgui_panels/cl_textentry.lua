local PANEL = {}

function PANEL:Init()
	self.LerpedColor = Color(94, 130, 158)
	self.LerpedColorAlphaBorders = 0
	self.LerpedColorAlphaBlock = 0
	self:SetTall( 35 )
	self.entered = false
	self.special = false
	self.onclick = false
	self.isborder = true
	self.FakeActivated = false
	self.Font = "S_Light_15"
	self.TextAlignX = TEXT_ALIGN_CENTER
	self.TextAlignY = TEXT_ALIGN_CENTER
	self:SetFont( self.Font )
end

function PANEL:Paint(w,h)
	local panel = self
	if !self.XPos then self.XPos = w/2 end	
	if !self.YPos then self.YPos = h/2 end	
	
	if IsValid(panel) and panel:HasFocus() then
		self.LerpedColorAlphaBlock = 255
	end
	
	if (self.LerpedColorAlphaBlock != 0) then
		self.LerpedColorAlphaBlock = Lerp(FrameTime()*20, self.LerpedColorAlphaBlock, 0 )
		if self.LerpedColorAlphaBorders > 120 then
			self.LerpedColorAlphaBorders = self.LerpedColorAlphaBlock
		end
	end
	if (!self.entered && self.LerpedColorAlphaBorders != 0) then
		self.LerpedColorAlphaBorders = Lerp(FrameTime()*17, self.LerpedColorAlphaBorders, 0 )
	end
	if self.FakeActivated && self.LerpedColorAlphaBorders < 70 then
		self.LerpedColorAlphaBorders = 70
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
	 
	if IsValid(panel) and panel:HasFocus() then temptext.a = 255 tempblock.a = 255 end
	
	draw.RoundedBox( 0, 0, 0, w, h, tempblock )
	if self.isborder then
		draw.RoundedBox( 0, 2, 0, w-4, 2, tempborders )
		draw.RoundedBox( 0, 0, 0, 2, h, tempborders )
		draw.RoundedBox( 0, w-2, 0, 2, h, tempborders )
		draw.RoundedBox( 0, 2, h-2, w-4, 2, tempborders )
	else
		draw.RoundedBox( 0, 0, 0, w, h, tempborders )
	end
	-- Hack on a hack, but this produces the most close appearance to what it will actually look if text was actually there
	panel.m_colText = temptext
	panel.m_colCursor = temptext
	
	if ( panel.GetPlaceholderText && panel.GetPlaceholderColor && panel:GetPlaceholderText() && panel:GetPlaceholderText():Trim() != "" && panel:GetPlaceholderColor() && ( !panel:GetText() || panel:GetText() == "" ) ) then

		local oldText = panel:GetText()

		local str = panel:GetPlaceholderText()
		if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
		str = language.GetPhrase( str )

		panel:SetText( str )
		panel:DrawTextEntryText( panel:GetPlaceholderColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
		panel:SetText( oldText )

		return
	end
	panel:DrawTextEntryText( panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
	//draw.SimpleText( panel:GetText(), self.Font, self.XPos, self.YPos, temptext, self.TextAlignX, self.TextAlignY )

end

function PANEL:OnCursorEntered()
	self.LerpedColorAlphaBorders = 120 
	self.entered = true 
end

function PANEL:SetBorders(bool)
	self.isborder = bool
end

function PANEL:OnCursorExited()
	self.entered = false 
end
vgui.Register( ".CCTextEntry", PANEL, "DTextEntry" )