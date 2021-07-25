local cccc = 0                             
                                        
local function AddItemInTopBar(mod)  
	if !IsValid(m_pnlAdmin) then return end 
	local pnl = m_pnlAdmin.m_pnlTopBar
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
	m_button.Font = "S_Regular_20"   
	m_button.ID = mod:GetID()
	m_button:SetSize( 20,30 )   
	m_button.Text = mod:GetName() 
	m_button:SetBorders(SINGLE) 
	m_button:SetBordersType(BORDER_BOTTOM)  
	m_button.Think = function(s)  
		if s.ID == m_pnlAdmin.TabActive then
			s.Active = true 
		else
			s.Active = false 
		end  
	end    
	m_button.DoClick = function(s) 
		m_pnlAdmin.TabActive = s.ID   
		m_pnlAdmin.m_pnlSidebar:OnSizeChanged()
		m_pnlAdmin.m_pnlContent:OnSizeChanged() 
	end
	pnl.grid:AddItem( m_button )
	for i,v in pairs(pnl.grid:GetItems()) do  
		v:SetSize(w/count+1, h)  
	end 
end
local ccc = 0   
local function AddItemInSidebar(name, data)  
	if !IsValid(m_pnlAdmin) then return end 
	local pnl = m_pnlAdmin.m_pnlSidebar
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
		if s.ID == m_pnlAdmin.m_pnlSidebar.ActiveID then 
			s.Active = true 
		else     
			s.Active = false 
		end 
	end   
	m_button.DoClick = function(s)
		m_pnlAdmin.m_pnlSidebar.ActiveID = s.ID   
		m_pnlAdmin.m_pnlContent:OnSizeChanged() 
	end

	TTS.Admin.tabs.Get( m_pnlAdmin.TabActive ) 
		:SidebarClearButton(m_button, name)   
	
	pnl.grid:AddItem( m_button )
	
	return m_button
end

netstream.Hook('TTS:Admin/Open', function()
  if IsValid(m_pnlAdmin) then  
    m_pnlAdmin:Remove() 
  end

  local _w,_h = ScrW(), ScrH()
  local limit_w, limit_h = 800, 600
  limit_w, limit_h = 1280, 720
  //limit_w, limit_h = 1024, 600
  -- limit_w, limit_h = 800, 600
  limit_w, limit_h = 640, 480 

  _w, _h = math.Clamp( limit_w, 0, ScrW() ), math.Clamp( limit_h, 0, ScrH() ) 
  
  m_pnlAdmin = vgui.Create('.CCFrame') 
  m_pnlAdmin:SetSize(_w,_h)
  -- m_pnlAdmin:SetPos(0,100)
  m_pnlAdmin:Center()
  m_pnlAdmin:MakePopup()
  m_pnlAdmin.TabActive = 1
  m_pnlAdmin.AddItemInSidebar = AddItemInSidebar


  local m_pnlTopPanel = vgui.Create("Panel", m_pnlAdmin)
  m_pnlTopPanel:SetSize(0, _h/12)   
  m_pnlTopPanel:Dock(TOP)   
  m_pnlTopPanel:DockMargin(1, 0, 1, 1) 
  m_pnlTopPanel:DockPadding(0, 0, 0, 0) 
  m_pnlTopPanel.Paint = function () end
    
  local m_pnlTopPayButton = vgui.Create(".CCPanel", m_pnlTopPanel)
  m_pnlTopPayButton:SetSize(_w/3.5, 0)
  m_pnlTopPayButton:Dock(LEFT) 
  m_pnlTopPayButton:SetVisible( false ) 
  m_pnlTopPayButton:DockMargin(0, 0, 10, 0)
  m_pnlTopPayButton:DockPadding(0, 0, 0, 0)
  m_pnlTopPayButton.OnSizeChanged = function()
    TTS.Admin.tabs.Get( m_pnlAdmin.TabActive ):TopButton(self)  
  end
  m_pnlAdmin.m_pnlTopPayButton = m_pnlTopPayButton

  local m_pnlTopBar = vgui.Create(".CCPanel", m_pnlTopPanel) 
  m_pnlTopBar:SetSize(0, 0)
  m_pnlTopBar:Dock(FILL) 
  m_pnlTopBar:DockMargin(0, 0, 0, 0)
  m_pnlTopBar:DockPadding(0, 0, 0, 0)
  m_pnlAdmin.m_pnlTopBar = m_pnlTopBar
  function m_pnlTopBar:OnSizeChanged()
    if IsValid(self.grid) then  
      self.grid:Remove()
    end   
    for i,v in pairs(TTS.Admin.tabs.GetList()) do 
		local allow = false
		if v.Perms and istable(v.Perms) then
			for perm, _ in pairs(v.Perms) do
				-- print(perm, hasPerm(perm))
				if hasPerm(perm) then
					allow = true
				end
			end
		else
			allow = true
		end
		-- print(mod.ID, allow)
		-- if not allow then return end
		AddItemInTopBar(v)  
    end
  end
    
  hook.Add('TTS.Admin::RegisterTab', 'TTS.Admin::UpdateTopBarInFrame', function()
    if IsValid(m_pnlTopBar) then
      m_pnlTopBar:OnSizeChanged()
    end 
  end) 

  local m_pnlSidebar = vgui.Create(".CCPanel", m_pnlAdmin) 
  m_pnlSidebar:SetSize(_w/3.5, 0) 
  m_pnlSidebar:Dock(LEFT) 
  m_pnlSidebar.ActiveID = ""
  m_pnlSidebar:DockMargin(1, 1, 1, 1)  
  m_pnlSidebar:DockPadding(0, 0, 0, 0)
  m_pnlAdmin.m_pnlSidebar = m_pnlSidebar
  function m_pnlSidebar:OnSizeChanged() 

    for i, v in pairs(self:GetChildren()) do 
      v:Remove()
    end
    
    TTS.Admin.tabs.Get( m_pnlAdmin.TabActive )
      :SidebarAddButton(self, m_pnlAdmin.m_pnlSidebar.ActiveID)
  end

  local m_pnlContent = vgui.Create(".CCPanel", m_pnlAdmin)
  m_pnlContent:Dock(FILL) 
  m_pnlContent:DockMargin(1, 1, 1, 1)
  m_pnlContent:DockPadding(0, 0, 0, 0)
  m_pnlAdmin.m_pnlContent = m_pnlContent 
  
  local cached_active_tab = 0
  m_pnlAdmin.Think = function()
    -- print(m_pnlAdmin.TabActive)
    if cached_active_tab != m_pnlAdmin.TabActive then
      TTS.Admin.tabs.Get( m_pnlAdmin.TabActive ):TopButton(m_pnlAdmin.m_pnlTopPayButton)
      cached_active_tab = m_pnlAdmin.TabActive
    end 
  end

  function m_pnlContent:OnSizeChanged() 
    TTS.Admin.tabs.Get( m_pnlAdmin.TabActive )
      :SidebarButton(self, m_pnlAdmin.m_pnlSidebar.ActiveID)
  end
end)