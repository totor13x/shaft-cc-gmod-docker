local MOD = {}

MOD.ID = MOD_POINTSHOP
MOD.Name = "Поинтшоп"
MOD.TopFillButton = function ( self, pnl )
	local m_pnlTopPayButton = pnl
	if IsValid(m_pnlTopPayButton.m_button) then m_pnlTopPayButton.m_button:Remove() end
	local m_button = vgui.Create(".CCButton", m_pnlTopPayButton)
	m_button.Font = "S_Light_25"
	m_button:Dock(FILL)
	m_button.Text = 'Твои поинты: ' .. TTS.Shop.UserPoints
	m_button.XPos = 10
	m_button.TextAlignX = TEXT_ALIGN_LEFT
	m_button.Think = function(s)
		m_button.Text = 'Твои поинты: ' .. TTS.Shop.UserPoints
	end
	m_button.DoClick = function(s)
		if IsValid(m_pnlFillingPoints) then m_pnlFillingPoints:Remove() end 
		m_pnlFillingPoints = vgui.Create('.CCFrame') 
		m_pnlFillingPoints:SetSize(300,150)
		m_pnlFillingPoints:Center() 
		m_pnlFillingPoints:SetZPos( 2 )
		m_pnlFillingPoints:MakePopup()
		m_pnlFillingPoints.OnFocusChanged = function(s, b)
			timer.Simple(0, function()
				if IsValid(s) then
					if !b and !s.pselector:HasFocus() then
						s:Remove()
					end
				end
			end)
		end
		
		
		local l1 = vgui.Create("DLabel", m_pnlFillingPoints)
		l1:SetText("Передача поинтов")
		l1:Dock(TOP)
		l1:DockMargin(4, 0, 4, 4)
		l1:SizeToContents()

		local pselect = vgui.Create(".CCDropDown", m_pnlFillingPoints)
		pselect.Text = "Выберите A игрока"
		pselect:SetTall(24)
		pselect:DockMargin(4, 2, 4, 4)
		pselect:Dock(TOP)
		
		
		
		local pointsselector = vgui.Create(".CCNumberWang", m_pnlFillingPoints)
		pointsselector:SetTextColor( Color(0, 0, 0, 255) )
		pointsselector:SetTall(24)
		pointsselector:DockMargin(4, 2, 4, 0)
		pointsselector:Dock(TOP)
		pointsselector.Font = "S_Light_15"
		pointsselector.XPos = 10
		pointsselector.TextAlignX = TEXT_ALIGN_LEFT
		pointsselector.TextAlignY = TEXT_ALIGN_CENTER
		m_pnlFillingPoints.pselector = pointsselector
		pointsselector.OnFocusChanged = function(s, b)
			timer.Simple(0, function()
				if IsValid(s) then
					if !b and !m_pnlFillingPoints:HasFocus() then
						m_pnlFillingPoints:Remove()
					end
				end
			end)
		end
		
		local l2 = vgui.Create("DLabel", m_pnlFillingPoints)
		l2:SetText("")
		l2:Dock(TOP)
		l2:DockMargin(4, 0, 4, 4)
		l2:SizeToContents()
		l2.Paint = function( s, w, h )
			draw.SimpleText("Будет передано: "..math.Round(m_pnlFillingPoints.pselector:GetValue() * 0.80), "Default", 0, 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)										
		end
		local m_button = vgui.Create(".CCButton", m_pnlFillingPoints)
		m_button.Font = "S_Light_15"
		m_button:Dock(TOP)
		// m_button.FakeActivated = true // на будушее
		m_button:SetTall(30) 
		m_button:DockMargin(4, 2, 4, 4)
		m_button.Text = 'Передать поинты'
		m_button.DoClick = function(s)
		end
		
		
		// Divider
		local l1 = vgui.Create("DPanel", m_pnlFillingPoints)
		l1:Dock(TOP)
		l1:SetTall(2) 
		l1:DockMargin(4, 4, 4, 4)
		l1.Paint = function(s,w,h)
			surface.SetDrawColor( 255, 255, 255, 230 )
			surface.DrawRect( 0, h/2, w, 1 )
		end
		
		
		
		
		local l1 = vgui.Create("DLabel", m_pnlFillingPoints)
		l1:SetText("Пополнение поинтов плюшками")
		l1:Dock(TOP)
		l1:DockMargin(4, 2, 4, 4)
		l1:SizeToContents()

		local komm = {
			[7] = 10000,
			[10] = 25000,
			[15] = 50000,
			[25] = 100000, 
			[100] = 500000,
			[175] = 1000000,
		}

		local pselect = vgui.Create(".CCDropDown", m_pnlFillingPoints)
		pselect.Text = 'Выберите бандл поинтов'
		pselect:SetSortItems( false )
		pselect:SetTall(24) 
		pselect:DockMargin(4, 2, 4, 0)
		pselect:Dock(TOP)
		for	i,v in SortedPairs(komm) do
			pselect:AddChoice(i..' плшк = '..v..' поинтов', i)
		end
			
		local l2 = vgui.Create("DLabel", m_pnlFillingPoints)
		l2:SetText("")
		l2:Dock(TOP)
		l2:DockMargin(4, 0, 4, 4)
		l2:SizeToContents()
		l2.Paint = function( s, w, h )
			local _, data = pselect:GetSelected()
			local text = "Бандл не выбран"
			if data then
				text = data.." плюшек в обмен на: "..komm[data]..' поинтов'
			end
			draw.SimpleText(text, "Default", 0, 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
		local m_button = vgui.Create(".CCButton", m_pnlFillingPoints)
		m_button.Font = "S_Light_15"
		m_button:Dock(TOP)
		m_button:SetTall(30) 
		m_button:DockMargin(4, 2, 4, 4)
		m_button.Text = 'Приобрести'
		m_button.DoClick = function(s)
		end
		m_pnlFillingPoints:InvalidateLayout( true )
		m_pnlFillingPoints:SizeToChildren(false, true)
		m_pnlFillingPoints:Center()
		
	end
	m_pnlTopPayButton.m_button = m_button
end
MOD.CategoryItemsFill = function ( self, pnl, id )
	local w, h = pnl:GetSize()
	local count = 3
	if LocalPlayer():SteamID() == 'STEAM_0:1:174292386' then
	 count = 2
	end
	local inner_width, item_width, item_height = w/count, 130, 120 
	if LocalPlayer():SteamID() == 'STEAM_0:1:174292386' then
	 inner_width, item_width = 200, 200
	end
	local DScrollPanel = vgui.Create( "DScrollPanel", pnl )
	DScrollPanel:Dock( FILL ) 
	 
	local m_pnlContentGrid = vgui.Create( "DGrid", DScrollPanel )
	m_pnlContentGrid:SetSize( w,h )
	m_pnlContentGrid:SetRowHeight( item_height )
	m_pnlContentGrid:SetCols( count ) 
	m_pnlContentGrid:SetColWide( w/count ) 
		
	local last_button 
	local count_items = 0
	if !TTS.Shop.Data.Categories[id] || !TTS.Shop.Data.Categories[id].Items then return end
	
	local otems = TTS.Shop.Data.Categories[id].Items
	if LocalPlayer():SteamID() == 'STEAM_0:1:174292386' then
		otems = table.Copy(TTS.Shop.Data.Categories[id].Items)
		table.sort(otems, function(a, b)
			return TTS.Shop.Data.Items[a]['name'] < TTS.Shop.Data.Items[b]['name'] 
		end)
		
	end
	for i,v in pairs(otems) do
		-- //if GlobalParamPurchase && GlobalParamPurchase[v] then continue end
		//count_items = count_items + 1
		local item = TTS.Shop.Data.Items[v]
		if item.is_hidden == 1 and LocalPlayer():SteamID() ~= 'STEAM_0:1:174292386' then continue end
		if string.find(item.name:lower(), 'private') then continue end
		local DButton = vgui.Create('DShopItem', m_pnlContentGrid) 
    DButton:SetSize( w/count, item_height ) 
    DButton.ColorRetangle = Color(94, 130, 158, 5)
    DButton.BlockRoles = false
    
    if #item.roles > 0 then
      local can = false
      for i,v in pairs(item.roles) do
        if hasRole(v.slug) then
          can = true
          break
        end
      end
      if not can then
        DButton.BlockRoles = true
        DButton.ColorRetangle = Color(214, 139, 139, 5)
      end
    end


		DButton:SetData({
			data = item,
			name = item.name,
			points = item.price,
      Color = Color(33,33,33, 233),
      SecondColor = DButton.ColorRetangle
		})
    DButton.DoClick = function(s)
      if s.BlockRoles then
        local roles = {}
        for i,v in pairs(item.roles) do
          table.insert(roles, v.name)
        end

        local text = ''
        if #roles > 1 then
          text = 'Для покупки необходимо быть в одной из групп: ' 
          text = text .. table.concat(roles, ', ')
        else
          text = 'Для покупки необходимо быть в группе: ' 
          text = text .. table.concat(roles, ', ')
        end

        TTS:AddNote( text, NOTIFY_ERROR, 5 )
        return
      end
      local menu = DermaMenu(s)
      if tobool(TTS.Shop.Data.Categories[id].have_preview) then
        menu:AddOption('Превью предмета', function() 
          TTS.Functions.ItemPreview(item)
        end)
      end
      menu:AddOption('Купить', function() 
		Derma_Query(
			'Вы уверены, что хотите купить ' .. item.name .. '?',
			'Купить вещь',
			'Да', function() TTS.Shop:BuyItem(v) end,
			'Нет', function() end
		)
			
			
        
        -- GlobalParamPurchase = GlobalParamPurchase or {}
        -- GlobalParamPurchase[id] = GlobalParamPurchase[id] or {}
        
        -- local item_id = os.time().."-"..math.random(0,999)
        -- GlobalParamPurchase[id][item_id] = v
        
        -- /*
        -- //s.DP:Remove()
        -- s.PaintOver = function(s,w,h) end
        -- s.Paint = function(s,w,h)
          -- surface.SetDrawColor(s.MainColor)
          -- surface.DrawRect(0,0, w, h)
          -- draw.SimpleText("Предмет куплен", "S_Light_17", 5, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        -- end
        -- if count_items == 0 then
        -- m_pnlPointshop.m_pnlSidebar:OnSizeChanged()
        -- end
        -- */
      end)
      
      menu:Open()
    end 
    
        
    if DButton.BlockRoles then
      _oldOnCursorEntered = DButton.OnCursorEntered
      function DButton:OnCursorEntered()
        _oldOnCursorEntered(self)

        if not IsValid(self.DTooltip) then
          local roles = {}
          for i,v in pairs(item.roles) do
            table.insert(roles, v.name)
          end

          local DTooltip = vgui.Create( "DTooltip" )
          DTooltip:SetPos( 0, 0 )
          DTooltip:SetSize( 250, 50 )
          DTooltip:SetText( 'Роли: ' .. table.concat(roles, ', ') )
          DTooltip.OpenForPanel = function( self, panel )
            self.TargetPanel = panel
            self:PositionTooltip()
          
            self:SetSkin( panel:GetSkin().Name )
          
            self:SetVisible( true )
          end
          DTooltip:OpenForPanel( self )
          -- DTooltip:SetContents( self, true)
          DTooltip:PositionTooltip()
          DTooltip.Paint = function()
            draw.RoundedBox( 5, 0, 0, 250, 50, Color( 255, 255, 255, 255 ) )
          end

          self.DTooltip = DTooltip
        end
        -- self.Info = '+' .. self.DataPoints
      end
          
      _oldOnCursorExited = DButton.OnCursorExited
      function DButton:OnCursorExited()
        _oldOnCursorExited(self)

        if IsValid(self.DTooltip) then
          self.DTooltip:Close()
        end
        -- self.Info = '+' .. self.DataPoints
      end
      function DButton:Think()
        if IsValid(self.DTooltip) then
          self.DTooltip:PositionTooltip()
        end
      end
    end


    -- function DButton:OnCursorExited()
    --   self.Info = self.DataName
    -- end
		m_pnlContentGrid:AddItem( DButton )
		DScrollPanel:AddItem( DButton )
	end 
	local width_for_resize = 64 
	local changed = false
	function DScrollPanel:Think() 
		-- print(width_for_resize, self:InnerWidth())
	if width_for_resize == self:InnerWidth() || (width_for_resize+1) == self:InnerWidth() then return end
		if changed then return end
		width_for_resize = self:InnerWidth()
		count = width_for_resize/item_width
		count = math.floor(count)
		inner_width = math.floor(width_for_resize/count) 
		-- print(width_for_resize, count)
		m_pnlContentGrid:SetSize( width_for_resize, h )
		m_pnlContentGrid:SetCols( count )
		m_pnlContentGrid:SetColWide( inner_width ) 
		
		for i,v in pairs(m_pnlContentGrid:GetItems()) do
			v:SetSize( inner_width-1, item_height-1 ) 
		end
		
		changed = true
	end
end
MOD.SidebarRemoveButton = function ( self, pnl, category_id )
	-- print(category_id)
	local counter = table.Copy(TTS.Shop.Data.Categories[category_id].Items)
	-- if GlobalParamPurchase then
		-- for i,v in pairs(GlobalParamPurchase) do 
			-- table.RemoveByValue( counter, i )
		-- end
	if counter then
		local count = 0
		for i,v in pairs(counter) do
			local item = TTS.Shop.Data.Items[v]
			
			if item.is_hidden == 1 and LocalPlayer():SteamID() ~= 'STEAM_0:1:174292386' then continue end
			if string.find(item.name:lower(), 'private') then continue end
			count = count + 1
		end
		if count == 0 then
			pnl:Remove()
			return 
		end
	else 
		pnl:Remove()
	end
end

TTS.Shop.modules.Register( MOD ) 