local matGradient = Material( "gui/gradient" )

local MOD = {}
local AmountTTSBalance = nil
MOD.ID = MOD_TTSHOP
MOD.Name = "TT-Shop"
MOD.TopFillButton = function (self, pnl )
	local m_pnlTopPayButton = pnl
	if IsValid(m_pnlTopPayButton.m_button) then m_pnlTopPayButton.m_button:Remove() end
	local pnl_x, pnl_y = pnl:GetSize()
	local m_button = vgui.Create(".CCButton", m_pnlTopPayButton)
	m_button.Font = "S_Light_25"
	m_button:Dock(FILL)
	m_button.FakeActivated = true
	m_button:SetBorders(false)
	m_button.Text = ''
	m_button.XPos = 10
	m_button.YPos = (pnl_y/2)-5
	m_button.TextAlignX = TEXT_ALIGN_LEFT
	local _oldPaint = m_button.Paint
	m_button.Paint = function(s,w,h)
		s.rotAngle = (s.rotAngle or 0) + 100 * FrameTime();

		local distsize  = math.sqrt( w*w + h*h );
		local alphamult   = (s._alpha or 0)/ 255;       
		DLib.HUDCommons.Stencil.Start()
		_oldPaint(s,w,h)
		DLib.HUDCommons.Stencil.StopDrawMask()
		surface.SetMaterial( matGradient );
		surface.SetDrawColor( Color( 94, 130, 158, s.TextColorLerped ) );
		surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (s.rotAngle or 0) );

		DLib.HUDCommons.Stencil.Stop()
		draw.SimpleText( "Твои плюшки: " .. (TTSBalance or 0), "S_Light_25", s.XPos, s.YPos, self.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Нажмите, чтобы пополнить", "S_Light_15", s.XPos, h-20, self.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	end
	m_button.DoClick = function(s)
		if IsValid(m_pnlFillingPoints) then m_pnlFillingPoints:Remove() end 
		m_pnlFillingPoints = vgui.Create('.CCFrame') 
		m_pnlFillingPoints:SetSize(300,150)
		m_pnlFillingPoints:Center() 
		m_pnlFillingPoints:MakePopup()
		m_pnlFillingPoints:SetTitle('Пополнение плюшек')
		m_pnlFillingPoints.OnRemove = function(s, b)
			AmountTTSBalance = nil
		end
		m_pnlFillingPoints.OnFocusChanged = function(s, b)
			timer.Simple(0, function()
				if IsValid(s) then
					if !b and !s.pselector:HasFocus() and !s.emailselector:HasFocus() then
						s:Remove()
					end
				end
			end)
		end
		
		local pointsselector = vgui.Create(".CCNumberWang", m_pnlFillingPoints)
		pointsselector:SetTextColor( Color(0, 0, 0, 255) )
		pointsselector:SetTall(40)
		pointsselector:DockMargin(0, 5, 0, 5)
		pointsselector:Dock(TOP)
		pointsselector:SetValue( 5 )
		pointsselector:SetMin( 5 )
		pointsselector:SetMax( 99999 )
		pointsselector:SetPlaceholderText( 'Количество плюшек' )
		pointsselector.Font = "S_Light_30"
		-- pointsselector.XPos = 10
		pointsselector.FakeActivated = true
		pointsselector.TextAlignX = TEXT_ALIGN_CENTER
		pointsselector.TextAlignY = TEXT_ALIGN_CENTER
		m_pnlFillingPoints.pselector = pointsselector
		pointsselector.OnFocusChanged = function(s, b)
			timer.Simple(0, function()
				if IsValid(s) then
					if !b and !m_pnlFillingPoints:HasFocus() and !m_pnlFillingPoints.emailselector:HasFocus() then
						m_pnlFillingPoints:Remove()
					end
				end
			end)
		end
		if AmountTTSBalance then
			if AmountTTSBalance < 5 then
				AmountTTSBalance = 5
			end
			pointsselector:SetValue(AmountTTSBalance)
		end
		local emailselector = vgui.Create(".CCTextEntry", m_pnlFillingPoints)
		emailselector:SetTextColor( Color(0, 0, 0, 255) )
		emailselector:SetTall(30)
		emailselector:DockMargin(0, 0, 0, 5)
		emailselector:Dock(TOP)
		emailselector:SetPlaceholderText( 'Твоя почта' )
		emailselector.Font = "S_Light_25"
		-- pointsselector.XPos = 10
		emailselector.FakeActivated = true
		emailselector.TextAlignX = TEXT_ALIGN_CENTER
		emailselector.TextAlignY = TEXT_ALIGN_CENTER
		m_pnlFillingPoints.emailselector = emailselector
		emailselector.OnFocusChanged = function(s, b)
			timer.Simple(0, function()
				if IsValid(s) then
					if !b and !m_pnlFillingPoints:HasFocus() and !m_pnlFillingPoints.pselector:HasFocus() then
						m_pnlFillingPoints:Remove()
					end
				end
			end)
		end
		local m_button = vgui.Create(".CCButton", m_pnlFillingPoints)
		m_button.Font = "S_Light_25"
		m_button:Dock(TOP)
		m_button.FakeActivated = true
		m_button:SetBorders(false)
		m_button.Text = ''
		-- m_button.XPos = 10
		-- m_button.YPos = 20
		m_button:DockMargin(0, 0, 0, 5)
		m_button:SetSize( 20,40 )
		m_button.DoClick = function(s)
			TTS.HTTP(
				'/api/tts/fill_account', 
				{
				  server_id = HoolDon.server,
				  amount = pointsselector:GetValue(),
				  email = emailselector:GetValue(),
				},
				function(data)   
					gui.OpenURL( data )
				end,
				function(message, data)
					for i,v in pairs(data) do 
						for _, mess in pairs(v) do 
							TTS:AddNote( mess, NOTIFY_ERROR, 4 )
						end
					end
				end
			)
		end
		local _oldPaint = m_button.Paint
		m_button.Paint = function(s,w,h)
			s.rotAngle = (s.rotAngle or 0) + 100 * FrameTime();

			local distsize  = math.sqrt( w*w + h*h );
			local alphamult   = 100;       
			DLib.HUDCommons.Stencil.Start()
			_oldPaint(s,w,h)
			DLib.HUDCommons.Stencil.StopDrawMask()
			surface.SetMaterial( matGradient );
			surface.SetDrawColor( Color( 94, 130, 158, s.TextColorLerped ) );
			surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (s.rotAngle or 0) );

			DLib.HUDCommons.Stencil.Stop()
			draw.SimpleText( 'Пополнить баланс', "S_Light_25", s.XPos, s.YPos, self.TextColorLerped, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		function m_button:OnSizeChanged()
			m_pnlFillingPoints:SizeToChildren( false, true )
		end
	end
	m_pnlTopPayButton.m_button = m_button
end
MOD.CategoryItemsFill = function ( self, pnl, id )
	pnl.IsInventory = pnl.IsInventory or false
	TTS.HTTP(
		pnl.IsInventory and '/api/inventory/tts_items' or '/api/tts/items', 
		{
		  server_id = HoolDon.server,
		},
		function(data)   
			local categories = {}
			-- PrintTable(data)
			for i,v in pairs(data) do
				local item_cat = v.category
				local item = v
				if pnl.IsInventory then
					item_cat = v.item.category
					item = v.item
					item.id = v.id
					item.created_at = v.created_at
				end
				-- print(item_cat)
				categories[item_cat] = categories[item_cat] or {}
				table.insert(categories[item_cat], item)
			end
			
			-- PrintTable(categories)  
			
			local lm_pnlPointshop = pnl:GetParent()
			local sbPnl = lm_pnlPointshop.m_pnlSidebar
			
			for i,v in pairs(sbPnl:GetChildren()) do
				v:Remove()
			end

			for i,v in pairs(pnl:GetChildren()) do
				v:Remove()
			end
			
			local w,h = sbPnl:GetSize()
			sbPnl.grid = vgui.Create( "DScrollPanel", sbPnl )  
			sbPnl.grid:Dock( FILL )
			
			local m_button = vgui.Create(".CCButton", sbPnl)
			m_button.Font = "S_Regular_20"
			m_button.TextAlignX = TEXT_ALIGN_LEFT
			m_button.XPos = 10
			m_button.ID = data.id
			m_button.Text = 'Инвентарь ТТС'
			m_button:SetSize( 20,40 )
			m_button:Dock( BOTTOM )  
			m_button:SetBorders(false) 
			m_button:SetDarkBackground(true) 
			m_button.DoClick = function(s)
				pnl.IsInventory = not pnl.IsInventory
				self:CategoryItemsFill(pnl, id)
			end
			m_button.Think = function(s)
				if pnl.IsInventory then
					s.FakeActivated = true
					s.Text = 'Обратно в магазин ТТС'
				else
					s.FakeActivated = false
					s.Text = 'В инвентарь ТТС'
				end
			end
			
			for name,items in pairs(categories) do
				local createdDlabel = vgui.Create( "DLabel", sbPnl )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Bold_20" )
				createdDlabel:SetText( name )
				createdDlabel:DockMargin(5, 5, 0, 0)
				sbPnl.grid:AddItem(createdDlabel)
				
				for _, data in pairs(items) do
					local m_button = vgui.Create(".CCButton", sbPnl)
					m_button.Font = "S_Regular_20"
					m_button.TextAlignX = TEXT_ALIGN_LEFT
					m_button.XPos = 10
					m_button.ID = data.id
					m_button.Text = ''
					m_button.TextEx = data.name
					m_button.TextTTSPluh = pnl.IsInventory and 'Покупка совершена ' .. data.created_at or data.price_format
					m_button:SetSize( 20,40 )
					m_button:Dock( TOP )  
					m_button:SetBorders(SINGLE) 
					m_button:SetBordersType(BORDER_LEFT) 
					m_button:SetDarkBackground(true) 
					local _oPaintm_button = m_button.Paint
					m_button.Paint = function(s,w,h)
						_oPaintm_button(s,w,h)
						draw.SimpleText( s.TextEx, "S_Light_20", s.XPos, 15, self.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						draw.SimpleText( s.TextTTSPluh, "S_Light_15", s.XPos, h-20, self.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
					end
					
					m_button.DoClick = function(s)
						for i,v in pairs(pnl:GetChildren()) do
							v:Remove()
						end
						
						local createdDlabel = vgui.Create( "DLabel", pnl )
						createdDlabel:Dock( TOP )
						createdDlabel:SetFont( "S_Bold_35" )
						createdDlabel:SetText( data.name )
						createdDlabel:DockMargin(10, 10, 0, 0)
						
						local createdDlabel = vgui.Create( "DLabel", pnl )
						createdDlabel:Dock( TOP )
						createdDlabel:SetFont( "S_Light_25" )
						createdDlabel:SetText( data.price_format )
						createdDlabel:DockMargin(10, 10, 0, 0)
						-- data.description = 'aaaaaaaaa aaaaaaaa ddddddddddddd ddddddddddddddddd ddda aaaaaaaaaaaaaaaaaaaaa '
						if data.description then
							local createdDlabel = vgui.Create( "RichText", pnl )
							createdDlabel:Dock( TOP )
								-- createdDlabel:SetAutoStretchVertical( true )
							createdDlabel:SetText( 'Описание: ' .. data.description )
							createdDlabel:DockMargin(10, 20, 10, 10)
							function createdDlabel:PerformLayout()
								createdDlabel:SetFGColor(Color(255,255,255))
								createdDlabel:SetFontInternal("S_Regular_25")
								createdDlabel:SizeToChildren( false, true )
								createdDlabel:SetVerticalScrollbarEnabled( false )
							end
							-- function m_pnlTopBar:OnSizeChanged()
							-- timer.Simple(1, function()
								-- createdDlabel:SizeToContentsY()
							-- end)
						else
							local createdDlabel = vgui.Create( "DLabel", pnl )
							createdDlabel:Dock( TOP )
							createdDlabel:SetFont( "S_Italic_25" )
							createdDlabel:SetText( 'У предмета пока отсутствует описание :c' )
							createdDlabel:DockMargin(10, 20, 10, 10)

						end
						local m_buttonBuy = vgui.Create(".CCButton", pnl)
						m_buttonBuy:SetSize( 20,40 )
						m_buttonBuy:DockMargin(10, 20, 10, 10)
						m_buttonBuy:Dock( TOP )  
						m_buttonBuy.Font = "S_Regular_20"
						m_buttonBuy.Text = pnl.IsInventory and 'Активировать' or 'Купить'
						m_buttonBuy.DoClick = function(s)
							if pnl.IsInventory then
								TTS.HTTP(
									'/api/tts/item/' .. data.id .. '/activate', 
									{
										on_server = true,
										server_id = HoolDon.server,
									},
									function(data)
										TTS:AddNote( data, NOTIFY_GENERIC, 5 )
										self:CategoryItemsFill(pnl, id)
									end,
									function(data)
										TTS:AddNote( data, NOTIFY_ERROR, 4 )
									end
								)
								return
							end
							if (TTSBalance or 0) < data.price then
								local plu = TTS.Libs.Interface.Plural(
									data.price - TTSBalance,
									{'плюшек', 'плюшки', 'плюшек'}
								)
								Derma_Query(
									'У тебя не хватает '.. data.price - TTSBalance .. ' ' .. plu .. ', хочешь пополнить баланс на эту сумму?',
									'Покупка ' .. data.name,
									'Да', function()
										AmountTTSBalance = data.price - TTSBalance
										m_pnlPointshop.m_pnlTopPayButton.m_button:DoClick()
									end,
									'Нет', function() end
								)
							else
								TTS.HTTP(
									'/api/tts/item/' .. data.id .. '/buy', 
									{
										on_server = true,
										server_id = HoolDon.server,
									},
									function(data)
										TTS:AddNote( data, NOTIFY_GENERIC, 5 )
									end,
									function(data)
										TTS:AddNote( data, NOTIFY_ERROR, 4 )
									end
								)
							end
						end
					end
					-- m_button.Think = function(s)  
						-- if s.ID == m_pnlPointshop.m_pnlSidebar.ActiveID then 
							-- s.Active = true 
						-- else     
							-- s.Active = false 
						-- end 
					-- end   
					-- m_button.DoClick = function(s)
						-- m_pnlPointshop.m_pnlSidebar.ActiveID = s.ID  
						-- m_pnlPointshop.m_pnlContent:OnSizeChanged() 
					-- end
					sbPnl.grid:AddItem(m_button)
				end
			end
			
			 local DLabel = vgui.Create( "DPanel", pnl )
			  DLabel:Dock(FILL)
			  -- DLabel.OnRemove = function(s)
				-- if IsValid(lm_pnlPointshop) then
					-- lm_pnlPointshop.m_pnlSidebar:Show()
				-- end
			  -- end
			  DLabel.Paint = function(s, w, h)
				draw.SimpleText(
				  "Выбери предмет",
				  "S_Light_30",
				  w/2,
				  (h/2)-20,
				  Color(255,255,255),
				  TEXT_ALIGN_CENTER,
				  TEXT_ALIGN_CENTER
				)
				draw.SimpleText(
				  "на панели слева",
				  "S_Light_30",
				  w/2,
				  (h/2)+20,
				  Color(255,255,255),
				  TEXT_ALIGN_CENTER,
				  TEXT_ALIGN_CENTER
				)
			  end
		end
	)
end
TTS.Shop.modules.Register( MOD )