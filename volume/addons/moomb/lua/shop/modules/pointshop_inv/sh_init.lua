local MOD = {}

MOD.ID = MOD_INV
MOD.Name = "Инвентарь"


local sort_mod, sortActive, stack = 0, false, false

MOD.TopFillButton = function ( self, pnl )
	local m_pnlTopPayButton = pnl
	if IsValid(m_pnlTopPayButton.m_button) then m_pnlTopPayButton.m_button:Remove() end
	local m_button = vgui.Create(".CCButton", m_pnlTopPayButton)
	m_button.Font = "S_Light_25"
	m_button:Dock(FILL)
	m_button.Text = ''
	m_button.XPos = 10
	m_button.TextAlignX = TEXT_ALIGN_LEFT
	local _oldPaint = m_button.Paint
	m_button.Paint = function(s,w,h)
		-- s.rotAngle = (s.rotAngle or 0) + 100 * FrameTime();

		-- local distsize  = math.sqrt( w*w + h*h );
		-- local alphamult   = (s._alpha or 0)/ 255;       
		-- DLib.HUDCommons.Stencil.Start()
		_oldPaint(s,w,h)
		-- DLib.HUDCommons.Stencil.StopDrawMask()
		-- surface.SetMaterial( matGradient );
		-- surface.SetDrawColor( Color( 94, 130, 158, s.TextColorLerped ) );
		-- surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (s.rotAngle or 0) );

    -- DLib.HUDCommons.Stencil.Stop()
    local inv = TTS.Inventory.Counts.Max - TTS.Inventory.Counts.Count
    local shop = TTS.Shop.Limits.Max - TTS.Shop.Limits.Count
		draw.SimpleText( "Инвентарь сервера (свободно " .. shop .. ")", "S_Light_25", s.XPos, s.YPos, self.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Хранилище (свободно " .. inv .. ")", "S_Light_15", s.XPos, h-20, self.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	end
	m_button.DoClick = function(s)
    m_pnlPointshop:SetVisible(false)
    RunConsoleCommand("tts_inventory_frame")
		-- if IsValid(m_pnlInventory) then m_pnlInventory:Remove() end 
		-- m_pnlInventory = vgui.Create('DInventory') 
		-- m_pnlInventory:SetSize(300,150)
		-- m_pnlInventory:Center() 
		-- m_pnlInventory:SetZPos( 2 )
		-- m_pnlInventory:MakePopup()
		-- m_pnlInventory.OnFocusChanged = function(s, b)
			-- timer.Simple(0, function()
			-- 	if IsValid(s) then
			-- 		if !b and !s.pselector:HasFocus() then
			-- 			s:Remove()
			-- 		end
			-- 	end
			-- end)
    -- end
  end
	m_pnlTopPayButton.m_button = m_button
end
local function AddItemToSort(pnl, mod, pnl_parent, id, fnc, bool) 
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
	m_button.Font = "S_Regular_15"   
	m_button.ID = count
	m_button:SetSize( 20,40 )  
	m_button.Text = mod
	m_button:SetBorders(false)
	m_button.Think = function(s) 
		if s.ID == sortActive || (bool && stack) then
			s.Active = true 
		else  
			s.Active = false 
		end  
	end    
	m_button.DoClick = function(s) 
		if !bool then
			if s.ID == sortActive then 
				sortActive = false
				fnc = nil
			end
			sortActive = s.ID
			for i, v in pairs(pnl_parent:GetChildren()) do
				v:Remove()
			end
			MOD.CategoryItemsFill(MOD, pnl_parent, id, fnc)
		else
			stack = !stack
			for i, v in pairs(pnl_parent:GetChildren()) do
				v:Remove()
			end
			MOD.CategoryItemsFill(MOD, pnl_parent, id, fnc)
		end
	end
	pnl.grid:AddItem( m_button )
	for i,v in pairs(pnl.grid:GetItems()) do 
		v:SetSize(w/count+1, h)  
	end 
end 

MOD.CategoryItemsFill = function ( self, pnl, id, fnc )
	if !fnc then
		sort_mod, sortActive = 0, false
	end
	local w, h = pnl:GetSize()
	local count = 3
	local inner_width, item_width, item_height = w/count, 130, 120 
	
	
	local DScrollPanel = vgui.Create( "DScrollPanel", pnl )
	DScrollPanel:SetSize( w,h )
	DScrollPanel:Dock( FILL ) 
	 
	local m_pnlContentGrid = vgui.Create( "DGrid", DScrollPanel )
	m_pnlContentGrid:SetSize( w,h )
	m_pnlContentGrid:SetRowHeight( item_height )
	m_pnlContentGrid:SetCols( count ) 
	m_pnlContentGrid:SetColWide( w/count ) 
		
	local last_button 
	local count_items = 0
	if !TTS.Shop.Data.Categories[id] || !TTS.Shop.Data.Categories[id].Items then return end
	-- if !GlobalParamPurchase || !GlobalParamPurchase[id] then return end
	-- local _tempTab = table.Copy(GlobalParamPurchase[id])
	if !TTS.Shop.UserCategory || !TTS.Shop.UserCategory[id] then return end
	local _tempTab = table.Copy(TTS.Shop.UserCategory[id])
	local clearKeys = {}
	for i,v in pairs(_tempTab) do
		table.insert(clearKeys, {perm_id = i, item_id = v})
	end
	
	_tempTab = clearKeys
	
	if stack then
		clearKeys = {}
		for i,v in pairs(_tempTab) do
			clearKeys[v.item_id] = clearKeys[v.item_id] or {
				item_id = v.item_id,
				perm_id = v.perm_id,
				items = {}
			}
			table.insert(clearKeys[v.item_id].items, {perm_id = v.perm_id, item_id = v.item_id})
		end
		
		_tempTab = table.ClearKeys(clearKeys)
	end
	
	if isfunction(fnc) then
		table.sort(_tempTab, fnc)
	end
	
	for i,v in pairs(_tempTab) do
		-- print('-------------')
		-- PrintTable(v)
		-- print('-------------')
		count_items = count_items + 1
		
		local item = TTS.Shop.Data.Items[v.item_id]
		-- PrintTable(item)
		-- print(TTS.Shop.Data.CDN_URL)
		local DButton = vgui.Create('DShopItem', m_pnlContentGrid) 
		DButton:SetSize( w/count, item_height ) 
		DButton:SetData({
			data = item,
			name = item.name .. " - " .. v.perm_id .. " | " .. v.item_id,
			points = TTS.Shop:ComputedSell(item),
			Color = Color(33,33,33,233)
		})
		DButton.MinusItemText = "Предмет продан"
		DButton.MinusItem = function( s, w, h )
			if !stack then
				-- TTS.Shop.UserItems = TTS.Shop.UserItems or {}
				-- TTS.Shop.UserItems[id][v.perm_id] = nil
				count_items = count_items - 1
				s.DP:Remove()
				s.PaintOver = function(s,w,h) end
				s.Paint = function(s,w,h)
					surface.SetDrawColor(s.MainColor)
					surface.DrawRect(0,0, w, h)
					draw.SimpleText(s.MinusItemText, "S_Light_17", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			else 

				if (#v.items == 0) then
					s.DP:Remove()
					s.PaintOver = function(s,w,h) end
					s.Paint = function(s,w,h)
						surface.SetDrawColor(s.MainColor)
						surface.DrawRect(0,0, w, h)
						draw.SimpleText(s.MinusItemText, "S_Light_17", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
					count_items = count_items - 1
				end						
			end
			if count_items == 0 then
				m_pnlPointshop.m_pnlSidebar:OnSizeChanged()
			end
		end
		if stack then
			DButton.Think = function( s, w, h )
				s.Stacked = #v.items
				s.equip = false
				for i,v in pairs(v.items) do
					local data = TTS.Shop.UserIDs[v.perm_id]
					if data then
						if TTS.Shop.UserItems[data.dyn_id].data and TTS.Shop.UserItems[data.dyn_id].data.equip or false then
							s.equip = v.perm_id
						end
					else
						s.equip = false
					end
				end
			end
		else
			DButton.Think = function( s, w, h )
				local data = TTS.Shop.UserIDs[v.perm_id]
				-- PrintTable(v)
				-- PrintTable(data)
				-- PrintTable(TTS.Shop.UserItems)
				if data then
					-- PrintTable(TTS.Shop.UserItems)
					s.equip = TTS.Shop.UserItems[data.dyn_id].data and TTS.Shop.UserItems[data.dyn_id].data.equip or false
				else
					s.equip = false
				end
			end
		end
		DButton.DoClick = function(s)    
				local menu = DermaMenu(s)
				if tobool(TTS.Shop.Data.Categories[id].have_preview) then
					menu:AddOption('Превью предмета', function() 
						TTS.Functions.ItemPreview(item)
					end)
				end
				if !s.equip then
					menu:AddOption('Надеть', function()
						if !stack then
							TTS.Shop:EquipItem(v.perm_id)
							-- if (tobool(item.once)) then
								-- s:MinusItem()
							-- end
						else
							local key_acc = #v.items
							local item_data = v.items[key_acc]
							-- TTS.Shop.UserItems = TTS.Shop.UserItems or {}
							-- TTS.Shop.UserItems[id][item_data.perm_id] = nil
							TTS.Shop:EquipItem(item_data.perm_id)
              -- TTS.Shop:EquipItem(v.perm_id)
              
              if tobool(item.once) then
                v.items[key_acc] = nil
              end
            end
            
            if tobool(item.once) then
              s.MinusItemText = 'Предмет израсходован'
              s:MinusItem()
            end
					end)
				else
					menu:AddOption('Снять', function()
						-- print(s.equip)
						if !stack then
							TTS.Shop:HolsterItem(v.perm_id)
						else
							TTS.Shop:HolsterItem(s.equip)
						end
					end)
				end
        
				menu:AddOption('В хранилище', function() 
          DButton.MinusItemText = "Предмет перенесен"
          
					if !stack then
						TTS.Inventory:ToInventory(v.perm_id)
					else 
						local key_acc = #v.items
						local item_data = v.items[key_acc]
						-- TTS.Shop.UserItems = TTS.Shop.UserItems or {}
						-- TTS.Shop.UserItems[id][item_data.perm_id] = nil

						TTS.Inventory:ToInventory(item_data.perm_id)
						v.items[key_acc] = nil
					end
					s:MinusItem()
				end)
				menu:AddSpacer()
				menu:AddOption('Продать', function() 
						
				Derma_Query(
					'Вы уверены, что хотите продать ' .. item.name .. '?',
					'Продать вещь',
					'Да', function() 
							if !stack then
								TTS.Shop:SellItem(v.perm_id)
							else 
								local key_acc = #v.items
								local item_data = v.items[key_acc]
								-- TTS.Shop.UserItems = TTS.Shop.UserItems or {}
								-- TTS.Shop.UserItems[id][item_data.perm_id] = nil

								TTS.Shop:SellItem(item_data.perm_id)
								v.items[key_acc] = nil
							end
							s:MinusItem()
					end,
					'Нет', function() end
				)
        end)
				menu:Open()
		end 
		m_pnlContentGrid:AddItem( DButton )
		
			
		DScrollPanel:AddItem( DButton )
	end 
	local width_for_resize = 64
	function DScrollPanel:Think() 
		if width_for_resize == self:InnerWidth() || (width_for_resize+1) == self:InnerWidth() then return end
		h = self:GetTall()
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
	
	local m_sortButton = vgui.Create( "DPanel", pnl )
	m_sortButton:Dock(TOP)  
	m_sortButton:SetSize( 1,30 )
	m_sortButton.Paint = function( ss, w, h ) 
		//draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,230))
	end
	function m_sortButton:OnSizeChanged()
		AddItemToSort(self, "По имени", pnl, id, function(a, b) return TTS.Shop.Data.Items[a.item_id]['name'] < TTS.Shop.Data.Items[b.item_id]['name'] end ) 
		AddItemToSort(self, "По цене", pnl, id, function(a, b) return TTS.Shop.Data.Items[a.item_id]['price'] > TTS.Shop.Data.Items[b.item_id]['price'] end ) 
		AddItemToSort(self, "Стак", pnl, id, "_", true ) 
	end
end

MOD.SidebarRemoveButton = function ( self, pnl, category_id )
	if TTS.Shop.UserCategory && TTS.Shop.UserCategory[category_id] then
		
		if table.Count(TTS.Shop.UserCategory[category_id]) == 0 then
			pnl:Remove()
			return 
		end
	else
		pnl:Remove()
	end
end

TTS.Shop.modules.Register( MOD )