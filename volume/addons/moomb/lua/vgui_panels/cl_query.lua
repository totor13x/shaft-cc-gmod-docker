local PANEL = {}

function PANEL:Init()
	self:SetDeleteOnClose(true)
	self:MakePopup()
	self:SetTitle( "" )
	self:SetSize(200,200)
	self:DockPadding(0,20,0,5)
	self:Center()
	-- self:InvalidateChildren(  )
	-- FrameAFK3:SetVisible( true ) 
	-- self.LerpedColor = Color(94, 130, 158)
	-- self.LerpedColorAlphaBorders = 0
	-- self.LerpedColorAlphaBlock = 0
	-- self:SetTall( 35 )
	-- self.entered = false
	-- self.special = false
	-- self.onclick = false
	-- self.isborder = true
	-- self.FakeActivated = false
	-- self.Font = "S_Light_15"
	-- self.TextAlignX = TEXT_ALIGN_CENTER
	-- self.TextAlignY = TEXT_ALIGN_CENTER
	-- self:SetFont( self.Font )
	
	local m_notifAlt = vgui.Create( "DFrame", self )
	m_notifAlt:SetDraggable( false )
	-- m_notifAlt.StartTime = SysTime()
	-- m_notifAlt.Length = delay and delay or 8
	m_notifAlt:Dock( TOP )
	-- m_notifAlt.fx = 0
	-- m_notifAlt.fy = 0
	-- m_notifAlt.AX = 0
	-- m_notifAlt.AY = 0
	m_notifAlt:ShowCloseButton(false)
	m_notifAlt:DockMargin(0, 0, 0, 0)
	m_notifAlt:SetTitle("")
	m_notifAlt.Text = "НОВОЕ УВЕДОМЛЕНИЕ"
	m_notifAlt.Paint = function(s,w,h)
		-- draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35,200))
		draw.SimpleText(s.Text, "S_Bold_20", w/2, 30/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.Title = m_notifAlt

	-- local x,y = m_notifAlt:GetSize()

	-- Rich Text panel
	local richtext = vgui.Create( "DLabel", self )
	-- richtext:SetPos(5,35)
	-- richtext:SetSize( x-10, y-35-40 )
	richtext:Dock(TOP)
	richtext:DockMargin(5, 10, 5, 5)
	richtext:SetText( '' )
	richtext:SetFont(  "S_Regular_20" )
	richtext:SetWrap( true )
	richtext:SetAutoStretchVertical(true)
	richtext.Paint = function(s,w,h)
		//draw.RoundedBox(0, 0, 0, w, h, Color(155,35,35,200))
	end
	self.Description = richtext
	
	-- self:InvalidateLayout( true )
	-- self:SizeToChildren( false, true )
	print(self) 
	local selff = self
	function richtext:OnSizeChanged()
		-- print('richtext')
		selff:SizeToChildren( false, true )
	end
end
function PANEL:SetTextTitle(text)
	self.Title.Text = text
end
function PANEL:SetTextDescription(text)
	self.Description:SetText( text )
	local selff = self
	timer.Simple(0,function()
		if !IsValid(selff) then return end
		selff.Description:InvalidateLayout( true )
		timer.Simple(0.1,function()
			if !IsValid(selff) then return end
			-- print(text)
			-- do
				selff:SizeToChildren( false, true )
			-- end
		end)
		-- 
	end)
	-- self:SizeToChildren( false, true )
end
function PANEL:CreateButton(text, callback)
	local m_button = vgui.Create(".CCButton", self) 
	m_button.Font = "S_Regular_15"
	m_button:SetSize( 0,25 )  
	m_button:Dock( TOP ) 
	m_button:DockMargin(5, 5, 5, 0)
	m_button.Text = text
	m_button:SetBorders(false)
	m_button.DoClick = function( s ) 
		if callback then
			callback(self)
		end		
	end
	self.Description:InvalidateLayout( true )
	local selff = self
	function m_button:OnSizeChanged()
		timer.Simple(0,function()
			if !IsValid(selff) then return end
			selff:SizeToChildren( false, true )
		end)
	end
	return m_button
end

function PANEL:CreateDropDown(text)

	local m_button = vgui.Create(".CCDropDown", self)
	m_button.Text = text
	m_button.Font = "S_Regular_15"
	m_button:SetSortItems( false )
	m_button:SetSize( 0,25 ) 
	m_button:DockMargin(5, 5, 5, 0)
	m_button:Dock(TOP)
	-- for	i,v in SortedPairs(komm) do
		-- pselect:AddChoice(i..' плшк = '..v..' поинтов', i)
	-- end
			
	-- local m_button = vgui.Create(".CCButton", self) 
	-- m_button.Font = "S_Regular_15"
	-- m_button:SetSize( 0,25 )  
	-- m_button:Dock( TOP ) 
	-- m_button:DockMargin(5, 5, 5, 0)
	-- m_button.Text = text
	-- m_button:SetBorders(false)
	-- m_button.DoClick = function( s ) 
		-- if callback then
			-- callback(self)
		-- end		
	-- end
	self.Description:InvalidateLayout( true )
	local selff = self
	function m_button:OnSizeChanged()
		timer.Simple(0,function()
			if !IsValid(selff) then return end
			selff:SizeToChildren( false, true )
		end)
	end
	return m_button
end

function PANEL:OnSizeChanged()
	-- print('check')
	self:Center()
end

PANEL.Paint = function( s, w, h )
	-- TTS.Libs.Interface.Blur( FrameAFK3, 10, 20, 255 )
	draw.RoundedBox( 0, 0, 0, w, h,Color( 35, 35, 35, 230 ) )
end
vgui.Register( ".CCQuery", PANEL, "DFrame" )