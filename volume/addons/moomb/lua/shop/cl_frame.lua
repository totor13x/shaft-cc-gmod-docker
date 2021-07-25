local cccc = 0                                  
                                 
local function AddItemInTopBar(mod)   
	if !IsValid(m_pnlPointshop) then return end 
	local pnl = m_pnlPointshop.m_pnlTopBar
	local count = pnl.grid and pnl.grid.count or 1  
	local w,h = pnl:GetSize()       
	if !IsValid(pnl.grid) then  
		pnl.grid = vgui.Create( "DGrid", pnl )   
		pnl.grid:Dock( FILL )
		pnl.grid:SetRowHeight( h )
		pnl.grid.count = 1   
	end
	pnl.grid:SetCols( count ) 
	pnl.grid:SetColWide( w/count )
		   
	pnl.grid.count = pnl.grid.count + 1
	local m_button = vgui.Create(".CCButton", pnl) 
	m_button.Font = "S_Regular_25"     
	m_button.ID = mod:GetID()
	m_button:SetSize( 20,40 )   
	m_button.Text = mod:GetName() 
	m_button:SetBorders(false)  
	m_button.Think = function(s)  
		if s.ID == m_pnlPointshop.TabActive then
			s.Active = true
		else
			s.Active = false 
		end  
	end    
	m_button.DoClick = function(s) 
		m_pnlPointshop.TabActive = s.ID   
		m_pnlPointshop.m_pnlSidebar:OnSizeChanged()
		m_pnlPointshop.m_pnlContent:OnSizeChanged()
	end
	pnl.grid:AddItem( m_button )
	for i,v in pairs(pnl.grid:GetItems()) do 
		v:SetSize(w/count+1, h)  
	end 
end   
local ccc = 0   
local function AddItemInSidebar(name, data) 
	if !IsValid(m_pnlPointshop) then return end 
	local pnl = m_pnlPointshop.m_pnlSidebar
	if !IsValid(pnl.grid) then
		local w,h = pnl:GetSize()
		pnl.grid = vgui.Create( "DScrollPanel", pnl )  
		pnl.grid:Dock( FILL )
	end  
			 
	local m_button = vgui.Create(".CCButton", pnl)
	m_button.Font = "S_Regular_20"
	m_button.TextAlignX = TEXT_ALIGN_LEFT
	m_button.XPos = 10
	m_button.ID = name
	m_button.Text = name
	m_button:SetSize( 20,40 )
	m_button:Dock( TOP )  
	m_button:SetBorders(SINGLE) 
	m_button:SetBordersType(BORDER_LEFT) 
	m_button:SetDarkBackground(true) 
	m_button.Think = function(s)  
		if s.ID == m_pnlPointshop.m_pnlSidebar.ActiveID then 
			s.Active = true 
		else     
			s.Active = false 
		end 
	end   
	m_button.DoClick = function(s)
		m_pnlPointshop.m_pnlSidebar.ActiveID = s.ID  
		m_pnlPointshop.m_pnlContent:OnSizeChanged() 
	end

	TTS.Shop.modules.Get( m_pnlPointshop.TabActive ) 
		:SidebarClearButton(m_button, name) 
	
	pnl.grid:AddItem( m_button )
	return m_button
end


hook.Remove("CreateMove", "TTSShop/F2")
hook.Add("CreateMove",'TTSShop/F2', function()		
	if input.WasKeyPressed(KEY_F2) and not (vgui.GetKeyboardFocus() or gui.IsGameUIVisible()) then
		RunConsoleCommand('tts_shop')
		return false
	end
end)

concommand.Add('tts_shop', function()
if IsValid(m_pnlPointshop) then
	m_pnlPointshop:Remove()
end

local _w,_h = ScrW(), ScrH()
local limit_w, limit_h = 800, 600
limit_w, limit_h = 1280, 720
-- limit_w, limit_h = 1024, 600
-- limit_w, limit_h = 800, 600
-- limit_w, limit_h = 640, 480

_w, _h = math.Clamp( limit_w, 0, ScrW() ), math.Clamp( limit_h, 0, ScrH() ) 
 
m_pnlPointshop = vgui.Create('.CCFrame') 
m_pnlPointshop:SetSize(_w,_h)
m_pnlPointshop:SetPos(0,100)
m_pnlPointshop:SetTitle('[F2] Магазин разных штучек')
m_pnlPointshop:Center()
m_pnlPointshop:MakePopup()
m_pnlPointshop.TabActive = 1


local m_pnlTopPanel = vgui.Create("Panel", m_pnlPointshop)
m_pnlTopPanel:SetSize(0, _h/12)   
m_pnlTopPanel:Dock(TOP)   
m_pnlTopPanel:DockMargin(1, 0, 1, 1) 
m_pnlTopPanel:DockPadding(0, 0, 0, 0) 
m_pnlTopPanel.Paint = function () end
  
local m_pnlTopPayButton = vgui.Create(".CCPanel", m_pnlTopPanel)
m_pnlTopPayButton:SetSize(_w/3.5, 0)
m_pnlTopPayButton:Dock(LEFT) 
m_pnlTopPayButton:DockMargin(0, 0, 1, 0)
m_pnlTopPayButton:DockPadding(0, 0, 0, 0)
m_pnlTopPayButton.OnSizeChanged = function()
	TTS.Shop.modules.Get( m_pnlPointshop.TabActive ):TopButton(self)  
end
m_pnlPointshop.m_pnlTopPayButton = m_pnlTopPayButton

local m_pnlTopBar = vgui.Create(".CCPanel", m_pnlTopPanel) 
m_pnlTopBar:SetSize(0, 0)
m_pnlTopBar:Dock(FILL) 
m_pnlTopBar:DockMargin(1, 0, 0, 0)
m_pnlTopBar:DockPadding(0, 0, 0, 0)
m_pnlPointshop.m_pnlTopBar = m_pnlTopBar
function m_pnlTopBar:OnSizeChanged()
	if IsValid(self.grid) then  
		self.grid:Remove()
	end   
	for i,v in pairs(TTS.Shop.modules.GetList()) do 
		-- PrintTable(v) 
		AddItemInTopBar(v)  
	end
end
  
hook.Add('TTS.Shop::RegisterModule', 'TTS.Shop::UpdateTopBarInFrame', function()
	if IsValid(m_pnlTopBar) then
		m_pnlTopBar:OnSizeChanged()
	end 
end) 

local m_pnlSidebar = vgui.Create(".CCPanel", m_pnlPointshop) 
m_pnlSidebar:SetSize(_w/3.5, 0) 
m_pnlSidebar:Dock(LEFT) 
m_pnlSidebar.ActiveID = ""
m_pnlSidebar:DockMargin(1, 1, 1, 1)  
m_pnlSidebar:DockPadding(0, 0, 0, 0)
m_pnlPointshop.m_pnlSidebar = m_pnlSidebar
function m_pnlSidebar:OnSizeChanged() 

	for i, v in pairs(self:GetChildren()) do 
		v:Remove()
	end
	
	for i,v in pairs(TTS.Shop.Data.Categories) do
		AddItemInSidebar(i,v)  
	end
end

local m_pnlPreview = vgui.Create(".CCPanel", m_pnlPointshop)
m_pnlPreview:SetSize(_w/3.5, 0)
m_pnlPreview:Dock(RIGHT) 
m_pnlPreview:DockMargin(1, 1, 1, 1)  
m_pnlPreview:DockPadding(0, 0, 0, 0)
m_pnlPreview.Paint = function( s, w, h ) end

local m_pnlContent = vgui.Create(".CCPanel", m_pnlPointshop)
m_pnlContent:Dock(FILL) 
m_pnlContent:DockMargin(1, 1, 1, 1)
m_pnlContent:DockPadding(0, 0, 0, 0)
m_pnlPointshop.m_pnlContent = m_pnlContent
 
local cached_active_tab = 0
m_pnlPointshop.Think = function()
	
	if cached_active_tab != m_pnlPointshop.TabActive then
		TTS.Shop.modules.Get( m_pnlPointshop.TabActive ):TopButton(m_pnlPointshop.m_pnlTopPayButton)
		cached_active_tab = m_pnlPointshop.TabActive
	end 
end

local m_pnlPreviewVGUI = vgui.Create('DShopPreview', m_pnlPreview)
m_pnlPreviewVGUI:SetSize( 200, _w/3.5 )
m_pnlPreviewVGUI:Dock(TOP)  
local _oldpaint = m_pnlPreviewVGUI.Paint
m_pnlPreviewVGUI.Paint = function( s, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
	_oldpaint( s, w, h )
end  

local m_btnPreviewBodyGroupEdit = vgui.Create(".CCButton", m_pnlPreview)
m_btnPreviewBodyGroupEdit.Font = "S_Light_20"   
m_btnPreviewBodyGroupEdit:SetSize( 200, 40 )
m_btnPreviewBodyGroupEdit:DockMargin(0, 1, 0, 0)
m_btnPreviewBodyGroupEdit:Dock(TOP)  
m_btnPreviewBodyGroupEdit:SetDisabled(true)  
m_btnPreviewBodyGroupEdit.Text = "Бодигруппы и сеты"
m_btnPreviewBodyGroupEdit:SetBorders(false)
local _oldpaint = m_btnPreviewBodyGroupEdit.Paint
m_btnPreviewBodyGroupEdit.Paint = function( s, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
	_oldpaint( s, w, h )
end   
m_btnPreviewBodyGroupEdit.DoClick = function( s )
	m_pnlPointshop:SetVisible(false)
	RunConsoleCommand("tts_bodygroup_frame")
end


local m_btnTrade = vgui.Create(".CCDropDown", m_pnlPreview)
m_btnTrade.Font = "S_Light_20"   
m_btnTrade:SetSize( 200, 40 )
m_btnTrade:DockMargin(0, 1, 0, 0)
m_btnTrade:Dock(TOP)  
m_btnTrade.Text = "Предложить трейд"
m_btnTrade:SetBorders(false)
local _oldpaint = m_btnTrade.Paint
m_btnTrade.Paint = function( s, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
	_oldpaint( s, w, h )
end   
m_btnTrade.ChooseOption = function( s, val, ind )
  local ply = s:GetOptionData(ind)
  if IsValid(ply) then
    netstream.Start('TTS:TradeRequest', ply)
  end
	-- m_pnlPointshop:SetVisible(false)
	-- RunConsoleCommand("tts_bodygroup_frame")
end

for i,v in pairs(player.GetAll()) do
  if v == LocalPlayer() then continue end
  m_btnTrade:AddChoice(v:Nick(), v)
end
-- local pselect = vgui.Create(".CCDropDown", m_pnlFillingPoints)
-- pselect.Text = 'Выберите бандл поинтов'
-- pselect:SetSortItems( false )
-- pselect:SetSize(200,40) 
-- pselect:DockMargin(0, 1, 0, 0)
-- pselect:Dock(TOP)
-- for	i,v in SortedPairs(komm) do
  -- pselect:AddChoice(i..' плшк = '..v..' поинтов', i)
-- end
  
  
if hasPerm('ap-mng-ps-items') then
	local BPBP = vgui.Create("DPanel", m_pnlPreview)
	BPBP:SetSize( 200, 40 )
	BPBP:DockMargin(0, 1, 0, 0)
	BPBP:Dock(TOP)  
	BPBP.Paint = function( s, w, h ) end  
	
		
	function BPBP:OnSizeChanged() 
		local width = self:GetWide()
		local m_btnEditIcon = vgui.Create(".CCButton", BPBP)
		m_btnEditIcon.Font = "S_Light_20"   
		m_btnEditIcon:SetSize( width / 2 , 40 )
		m_btnEditIcon:DockMargin(0, 0, 0, 0)
		m_btnEditIcon:Dock(LEFT)  
		-- m_btnEditIcon:SetDisabled(true)  
		m_btnEditIcon.Text = "Иконки"
		m_btnEditIcon:SetBorders(false)
		m_btnEditIcon.DoClick = function( s )
			-- m_pnlPointshop:SetVisible(false)
			RunConsoleCommand("ps_items_icons")
		end
		local m_btnEditPos = vgui.Create(".CCButton", BPBP)
		m_btnEditPos.Font = "S_Light_20"   
		m_btnEditPos:SetSize( width / 2, 40 )
		m_btnEditPos:DockMargin(0, 0, 0, 0)
		m_btnEditPos:Dock(RIGHT)  
		-- m_btnEditPos:SetDisabled(true)  
		m_btnEditPos.Text = "Pos/Ang"
		m_btnEditPos:SetBorders(false)
		m_btnEditPos.DoClick = function( s )
			-- m_pnlPointshop:SetVisible(false)
			RunConsoleCommand("ps_items_reposition")
		end
	end  
end  


   
local equippedicon = Material("icon16/eye.png")
local canshareicon = Material("icon16/user_go.png")
local privateicon = Material("icon16/key.png")   
local groupicon = Material("icon16/group.png")
local onceicon = Material("icon16/tag_red.png")
local premiumicon = Material("icon16/rosette.png")

local m_pnlInfoIcon = vgui.Create('DPanel', m_pnlPreview) 
m_pnlInfoIcon:SetText('')
m_pnlInfoIcon:SetSize(200, 5+7+5+16+5+16+16+5+16+5+16+5+16+5+16)
m_pnlInfoIcon:Dock(BOTTOM)  
m_pnlInfoIcon.Paint = function( ss, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
	 
	draw.SimpleText('Памятка по иконкам PointShop', 'S_Regular_17', 5, 5, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	
	surface.SetMaterial(equippedicon) 
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(5, 5+16+5, 16, 16)
	draw.SimpleText('- предмет экипирован', 'S_Light_17', 20+5, 5+7+5+16, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(groupicon)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(5, 5+16+5+5+16, 16, 16)
	
	draw.SimpleText('- предмет для групп', 'S_Light_17', 20+5, 5+7+5+16+5+16, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(canshareicon)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(5, 5+16+5+16+5+5+16, 16, 16)
	
	draw.SimpleText('- предмет передаваемый', 'S_Light_17', 20+5, 5+7+5+16+5+16+5+16, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(privateicon)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(5, 5+16+5+16+5+16+5+5+16, 16, 16)
	
	draw.SimpleText('- запрещенный предмет', 'S_Light_17', 20+5, 5+7+5+16+5+16+16+5+5+16, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(onceicon)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(5, 5+16+5+16+5+16+5+5+16+16+5, 16, 16)
	
	draw.SimpleText('- одноразовый предмет', 'S_Light_17', 20+5, 5+7+5+16+5+16+16+5+5+16+16+5, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(premiumicon)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(5, 5+16+5+16+5+16+5+5+16+16+5+16+5, 16, 16)
	
	draw.SimpleText('- предмет для премиума', 'S_Light_17', 20+5, 5+7+5+16+5+16+16+5+5+16+16+5+16+5, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
          
function m_pnlContent:OnSizeChanged() 
	TTS.Shop.modules.Get( m_pnlPointshop.TabActive )
		:SidebarButton(self, m_pnlPointshop.m_pnlSidebar.ActiveID)
end
end)