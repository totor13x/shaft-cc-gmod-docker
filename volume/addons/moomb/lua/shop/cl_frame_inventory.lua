
concommand.Add("tts_inventory_frame", function()
  if IsValid(m_pnlInventory) then 
    m_pnlInventory:Remove()
  end

  local _w,_h = ScrW(), ScrH()
  local limit_w, limit_h = 800, 600
  limit_w, limit_h = 1280, 720
  //limit_w, limit_h = 1024, 600
  limit_w, limit_h = 800, 600
  -- limit_w, limit_h = 640, 480

  _w, _h = math.Clamp( limit_w, 0, ScrW() ), math.Clamp( limit_h, 0, ScrH() ) 


  local SetSelected = false

  m_pnlInventory = vgui.Create('.CCFrame')
  m_pnlInventory:SetSize(_w,_h)
  m_pnlInventory:SetPos(0,100)
  m_pnlInventory:Center()
  m_pnlInventory:SetTitle('Хранилище')
  m_pnlInventory:MakePopup()
  m_pnlInventory.OnRemove = function(s)
    if IsValid(m_pnlPointshop) then
      m_pnlPointshop:SetVisible(true)
    end
  end
  m_pnlInventory.Refresh = function (data)
    if IsValid(m_pnlInventory._a) then
      m_pnlInventory._a:Remove()
    end
    if IsValid(m_pnlInventory._b) then
      m_pnlInventory._b:Remove()
    end
    if IsValid(m_pnlInventory._z) then
      m_pnlInventory._z:Remove()
    end
    
    -- Sidebar filters 

    local DScrollPanel = vgui.Create( "DScrollPanel", m_pnlInventory )
    DScrollPanel:Dock( LEFT ) 
    DScrollPanel:SetSize(200, 0)

    local m_button = vgui.Create(".CCButton", DScrollPanel)
    m_button.Font = "S_Light_20"
    m_button:Dock(TOP)
    m_button:SetSize(200, 35)
    m_button.Text = 'Все'
    m_button.XPos = 10
    m_button.TextAlignX = TEXT_ALIGN_LEFT
    m_button.Active = m_pnlInventory.FilterCategory == 'all'
    -- m_button:SetBorders( m_pnlInventory.FilterCategory == 'all' and NONE or FULL )
    m_button.DoClick = function(s)
      m_pnlInventory.CurrentPage = 1
      m_pnlInventory.FilterCategory = 'all'
  
      TTS.Inventory:OpenInventory ( m_pnlInventory.CurrentPage, m_pnlInventory.FilterCategory )
    end

    local m_button = vgui.Create(".CCButton", DScrollPanel)
    m_button.Font = "S_Light_20"
    m_button:Dock(TOP)
    m_button:SetSize(200, 35)
    m_button:DockMargin(0,5,0,0)
    m_button.Text = 'Pointshop'
    m_button.XPos = 10
    m_button.TextAlignX = TEXT_ALIGN_LEFT
    m_button.Active = m_pnlInventory.FilterCategory == 'ps'
    -- m_button.Active = true
    m_button.DoClick = function(s)
      m_pnlInventory.CurrentPage = 1
      m_pnlInventory.FilterCategory = 'ps'
  
      TTS.Inventory:OpenInventory ( m_pnlInventory.CurrentPage, m_pnlInventory.FilterCategory )
    end

    m_pnlInventory._z = DScrollPanel

    -- End sidebar filters


    -- Start items -------------------------
  local w, h = _w
	local count = 4
	local inner_width, item_width, item_height = w/count, 180, 60 
	local DScrollPanel = vgui.Create( "DScrollPanel", m_pnlInventory )
	DScrollPanel:Dock( FILL ) 
  DScrollPanel:DockMargin(5,0,0,0)
	 
	local m_pnlContentGrid = vgui.Create( "DGrid", DScrollPanel )
	m_pnlContentGrid:SetSize( w,h )
	m_pnlContentGrid:SetRowHeight( item_height )
	m_pnlContentGrid:SetCols( count ) 
	m_pnlContentGrid:SetColWide( w/count ) 
		
	local last_button 
	local count_items = 0
	-- if !TTS.Shop.Data.Categories[id] || !TTS.Shop.Data.Categories[id].Items then return end
	
  for i,v in pairs(data.json.data) do
    -- print(v)
		-- //if GlobalParamPurchase && GlobalParamPurchase[v] then continue end
		//count_items = count_items + 1
		local item = table.Copy(TTS.Shop.Data.Items[v.item_id])
		local DButton = vgui.Create('DShopItem', m_pnlContentGrid) 
		DButton:SetSize( w/count, item_height ) 
		DButton:SetData({
			data = item,
			name = item.name,
			points = item.price,
			Color = Color(33,33,33)
		})
		DButton.MinusItemText = "Предмет перенесен"
		DButton.MinusItem = function( s, w, h )
				s.DP:Remove()
				s.PaintOver = function(s,w,h) end
				s.Paint = function(s,w,h)
					surface.SetDrawColor(s.MainColor)
					surface.DrawRect(0,0, w, h)
					draw.SimpleText(s.MinusItemText, "S_Light_17", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
		end
		DButton.DoClick = function(s)    
				local menu = DermaMenu(s)
				-- menu:AddOption('Купить', function() 
					-- TTS.Shop:BuyItem(v)
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
				-- end)
				-- if tobool(TTS.Shop.Data.Categories[id].have_preview) then
				-- 	menu:AddOption('Превью предмета', function() 
				-- 		TTS.Functions.ItemPreview(item)
				-- 	end)
        -- end
        menu:AddOption('В инвентарь поинтшопа', function() 
          TTS.Inventory:FromInventory ( v.id )
          
          -- TODO: Reload page after load item
          if IsValid(m_pnlPointshop) then
            for i, pnl in pairs(m_pnlPointshop.m_pnlSidebar:GetChildren()) do
              if pnl.Active then
                pnl:DoClick()
              end
            end
            -- m_pnlPointshop.m_pnlTopBar:OnSizeChanged()
          end 

          s:MinusItem()
        end)
				menu:Open()
		end 
		m_pnlContentGrid:AddItem( DButton )
		DScrollPanel:AddItem( DButton )
	end 
	local width_for_resize = 64 
	function DScrollPanel:Think() 
	if width_for_resize == self:InnerWidth() || (width_for_resize+1) == self:InnerWidth() then return end
		width_for_resize = self:InnerWidth()
		count = width_for_resize/item_width
		count = math.floor(count)
		inner_width = math.floor(width_for_resize/count) 
		
		m_pnlContentGrid:SetSize( width_for_resize, h )
		m_pnlContentGrid:SetCols( count )
		m_pnlContentGrid:SetColWide( inner_width ) 
		
		for i,v in pairs(m_pnlContentGrid:GetItems()) do
			v:SetSize( inner_width-1, item_height-1 ) 
		end
  end
  m_pnlInventory._a = DScrollPanel
  -- End items -------------------------


    -- Paginator
    local _b = vgui.Create('DPanel', m_pnlInventory)
    _b:Dock(BOTTOM)
    _b:SetSize(0, 20)
    _b.Paint = function() end
    m_pnlInventory._b = _b

    local m_button = vgui.Create(".CCButton", _b)
    m_button.Font = "S_Regular_15"   
    m_button:SetSize( 40, 20 )
    m_button:SetEnabled(1 != data.json.page)
    m_button.Text = 'Пред'
    m_button:SetBorders(false)
    m_button:Dock(LEFT)
    m_button.DoClick = function(s)
      m_pnlInventory.CurrentPage = m_pnlInventory._c:GetValue() - 1
      TTS.Inventory:OpenInventory ( m_pnlInventory.CurrentPage, m_pnlInventory.FilterCategory )
      -- m_pnlInventory.HTTP()
      -- OpenCasesStore(v.id) 
    end
    m_pnlInventory._c1 = m_button
    local m_button = vgui.Create(".CCButton", _b)
    m_button.Font = "S_Regular_15"   
    m_button:SetSize( 40, 20 )  
    m_button:SetEnabled(data.json.lastPage != data.json.page)
    m_button.Text = 'След'
    m_button:SetBorders(false)
    m_button:Dock(RIGHT)
    m_button.DoClick = function(s)
      m_pnlInventory.CurrentPage = m_pnlInventory._c:GetValue() + 1
      -- m_pnlInventory.HTTP()
      TTS.Inventory:OpenInventory ( m_pnlInventory.CurrentPage, m_pnlInventory.FilterCategory )
    end
    m_pnlInventory._c2 = m_button

    local _b = vgui.Create('.CCNumSlider', _b)
    _b:Dock(FILL)
    _b:SetSize(0, 20)
    _b:SetDecimals( 0 )
    _b:SetText( 'Страница' )
    _b.Disabled = false
    _b:SetValue( data.json.page ) 
    _b:SetMinMax( 1, data.json.lastPage )
    _c = _b.Slider.OnMouseReleased
    _b.Slider.OnMouseReleased = function(self, mcode)
      --   return 
      -- end
      -- print('released')
      if (data.json.page != _b:GetValue()) then
        if _b.Disabled then 
          return
        end

        m_pnlInventory.CurrentPage = _b:GetValue() 
        -- m_pnlInventory.HTTP()
        TTS.Inventory:OpenInventory ( m_pnlInventory.CurrentPage, m_pnlInventory.FilterCategory )
        _b.Disabled = true
        -- print('value changed')
      end
      _c(self, mcode)
    end
    m_pnlInventory._c = _b
  end
  m_pnlInventory.CurrentPage = 1
  m_pnlInventory.FilterCategory = 'all'

  -- m_pnlInventory.Refresh()
  TTS.Inventory:OpenInventory ( m_pnlInventory.CurrentPage, m_pnlInventory.FilterCategory )
end)

hook.Add('InvOpenInventory', 'inventoryFrameUpdate', function(data)
  if IsValid(m_pnlInventory) then
    PrintTable(data)
    m_pnlInventory.Refresh(data)
  end
end)