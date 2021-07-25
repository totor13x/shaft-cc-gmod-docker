
local IsHaveTrade = false
hook.Remove("CreateMove", "TTSTrade/9/0")
hook.Add("CreateMove",'TTSTrade/9/0', function()		
  -- print(IsHaveTrade)
  if IsHaveTrade then
	  if input.WasKeyPressed(KEY_9) and not (vgui.GetKeyboardFocus() or gui.IsGameUIVisible()) then
      netstream.Start('TTSTrade/AcceptRequest')
    end
	  if input.WasKeyPressed(KEY_0) and not (vgui.GetKeyboardFocus() or gui.IsGameUIVisible()) then
      netstream.Start('TTSTrade/CancelRequest')
    end
  end
end)

netstream.Hook('TTSTrade/RespondFrame', function(data)
  IsHaveTrade = true
  if IsValid(FrameTradeRespond) then
    FrameTradeRespond:Remove()
  end

  local s = ScrW()/1.5
  FrameTradeRespond = vgui.Create( ".CCPanel" )
  FrameTradeRespond:SetSize( s, 20)
  FrameTradeRespond:SetPos( s/2 - s/2/2, ScrH()-20)  
  FrameTradeRespond.Time = CurTime()
  FrameTradeRespond.Nick = data
  local _p = FrameTradeRespond.Paint 
  FrameTradeRespond.Paint = function(s,w,h)
    _p(s,w,h)
    local rounded = math.Round((s.Time + 9) - CurTime() )
    draw.SimpleText('Тебе пришел запрос на обмен от ' .. s.Nick .. ' (' .. rounded .. '). Принять - 9, Отклонить - 0', 'S_Light_20', w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
  FrameTradeRespond.Think = function(s)
    if FrameTradeRespond.Time + 9 < CurTime() then
      IsHaveTrade = false
      s:Remove()
    end
  end
end)

local updateUsers = function(data)
  local m = LocalPlayer():GetNWInt('user_id') == data.respond.id and data.respond or data.request
  local y = LocalPlayer():GetNWInt('user_id') != data.request.id and data.request or data.respond
  
  return m, y
end

netstream.Hook('TTSTrade/UpdateStatus', function(data)
  if IsValid(FrameTrade) then
		FrameTrade.Data = data
		local me, you = updateUsers(data)
    FrameTrade.me = me
    FrameTrade.you = you
  end
end)

netstream.Hook('TTSTrade/notify', function(data)
  TTS:AddNote( data.text, data.type )
end)

netstream.Hook('TTSTrade/Close', function(data)
  if IsValid(FrameTrade) then
    FrameTrade:Remove()
  end
end)

netstream.Hook('TTSTrade/Chat', function(data)
  if IsValid(FrameTrade) then
    FrameTrade.ChatLog:AddText(data.username, data.text)
  end
end)

netstream.Hook('TTSTrade/MoveItem', function(data)
  if IsValid(FrameTrade) then
    local is_me = data.user_id == FrameTrade.me.id
    -- PrintTable(data)                       
    if data.type == 'sharemyinv' then
      if is_me then
        FrameTrade.MoveToShare(data.perm_id)  
      else 
        FrameTrade.AddYourItem(data)
      end
    elseif data.type == 'myinv' then
      if is_me then
        FrameTrade.MoveToMyInv(data.perm_id)
      else
        FrameTrade.RemoveYourItem(data)
      end
    end
  end
end)

netstream.Hook('TTSTrade/AcceptRequest', function(data)
  OpenTradeWindow(data)
end)

function OpenTradeWindow(data)
	if IsValid(FrameTrade) then 
		FrameTrade:Remove()
  end
  
	-- TradeWS:on('updateStatus', function(data)
	-- 	FrameTrade.Data = data
	-- 	me, you = updateUsers(data)
	-- end) 
	-- TradeWS:on('notify', function(data)
	-- 	TTS:AddNote( data.text, data.type )
	-- end) 
	-- TradeWS:on('close', function(data)
	-- 	if data then
	-- 		FrameTrade:Remove()
	-- 	end
	-- end) 
	
	
	local count = 3
	FrameTrade = vgui.Create( ".CCFrame" )
	FrameTrade:SetSize( 1280, 720)
	FrameTrade:Center()
	FrameTrade.ID = data.id
	FrameTrade.Data = data
	FrameTrade.Accept = false
	FrameTrade.Ready = false
	FrameTrade:SetTitle( "Трейд: #" .. data.id )  
	FrameTrade:MakePopup()
	FrameTrade:SetDeleteOnClose(true)
  FrameTrade.OnClose = function (self, data)
    netstream.Start('TTSTrade/Close', self.ID)
		-- TradeWS:emit('close', self.ID )  
  end
  
	
	local me, you = updateUsers(data)
	FrameTrade.me = me
  FrameTrade.you = you
  

	FrameTrade.AddDraggableItem = function (par, data)
		local pnl = par.m_pnlContentGrid
		local w, h = pnl:GetSize()
		local item = TTS.Shop.Data.Items[data.item_id]
		local DButton = vgui.Create('DShopItem', FrameTrade) 
		DButton:SetSize( w/count, item_height ) 
		DButton.ID = data.perm_id
		DButton.DataItem = data
		DButton.DataName = item.name
		DButton.OnFiltered = 0
		DButton:SetData({
			data = item,
			name = item.name,
			points = item.price,
			Color = Color(33,33,33,50)
		})
		DButton.DP:Remove()
		DButton.PanelFIx:Remove()
		DButton.Paint = function(s,w,h)
		
			if IsValid(s.Image) then
				s.Image:Remove()
			end
			surface.SetDrawColor(s.MainColor)
			surface.DrawRect(0,0, w, h)
			draw.SimpleText(s.DataName, "S_Light_17", 5, h - s.InfoHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(Color(33,33,33,s.OnFiltered))
			surface.DrawRect(0,0, w, h)
		end
		if par.type != 'shareyourinv' then
			DButton:Droppable( "slot" ) 
		end
		
		return DButton
	end
	FrameTrade.UpdateItem = function (pnl, data)
		local DButton = FrameTrade.AddDraggableItem(pnl, data)
		
		pnl.m_pnlContentGrid:AddItem( DButton )
		pnl.DScrollPanel:AddItem( DButton )
		table.insert(pnl.DScrollPanel.list, DButton)
	end
	FrameTrade.MakeDraggable = function(pnl, typ)
		local w, h = pnl:GetSize()
		local inner_width, item_width, item_height = w/count, 130, 60 
		
		local DScrollPanel = vgui.Create( "DScrollPanel", pnl )
		DScrollPanel:Dock( FILL ) 
		DScrollPanel.list = {}
		pnl.list = DScrollPanel.list
		pnl.DScrollPanel = DScrollPanel
		pnl.type = typ
	 
		DScrollPanel.Paint = function(s, w, h) end

		local m_pnlContentGrid = vgui.Create( "DGrid", DScrollPanel )
		m_pnlContentGrid:SetSize( w,h )
		m_pnlContentGrid:SetRowHeight( item_height )
		m_pnlContentGrid:SetCols( count ) 
		m_pnlContentGrid:SetColWide( w/count ) 
		pnl.m_pnlContentGrid = m_pnlContentGrid
		
		m_pnlContentGrid.Paint = function(s, w, h) end
		local clearKeys = {}
		if typ == 'myinv' then
			for cat_name, data in pairs(TTS.Shop.UserCategory) do
				for i,v in pairs(data) do
					local item = TTS.Shop.Data.Items[v]
					
					if tobool(item.is_tradable) then
						table.insert(clearKeys, {perm_id = i, item_id = v})
					end
				end
			end
		end
		
			print('additem')
			for _, data in pairs(clearKeys) do
				FrameTrade.UpdateItem(pnl, data)
			end
		DScrollPanel:Receiver( "slot", function( pnl, tbl, dropped, menu, x, y )
			if ( !dropped ) then return end 
			for i,v in pairs(pnl.list) do
				if tbl[1].ID == v.ID then
					return
				end
			end
			
      if typ == 'sharemyinv' then
        netstream.Start('TTSTrade/MoveItem', {
					perm_id = tbl[1].ID,
					type = typ
        })
				-- TradeWS:emit('moveItem', {
				-- 	id = FrameTrade.ID,
				-- 	perm_id = tbl[1].ID,
				-- 	type = typ
				-- })
			elseif typ == 'myinv' then
        netstream.Start('TTSTrade/MoveItem', {
					perm_id = tbl[1].ID,
					type = typ
        })
				-- TradeWS:emit('moveItem', {
				-- 	id = FrameTrade.ID,
				-- 	perm_id = tbl[1].ID,
				-- 	type = typ
				-- })
			end
		end )
		DScrollPanel.width_for_resize = 64 
		function DScrollPanel:Think() 
			if DScrollPanel.width_for_resize == self:InnerWidth() 
			|| (DScrollPanel.width_for_resize+1) == self:InnerWidth()
			then return end
			
			DScrollPanel.width_for_resize = self:InnerWidth()
			count = DScrollPanel.width_for_resize/item_width
			count = math.floor(count)
			inner_width = math.floor(DScrollPanel.width_for_resize/count) 
			
			m_pnlContentGrid:SetSize( DScrollPanel.width_for_resize, h )
			m_pnlContentGrid:SetCols( count )
			m_pnlContentGrid:SetColWide( inner_width ) 
			
			for i,v in pairs(m_pnlContentGrid:GetItems()) do
				v:SetSize( inner_width-1, item_height-1 ) 
			end
		end
	end
	
	local DPFrameFill = vgui.Create("DPanel",FrameTrade)
	DPFrameFill:SetSize(0, 0)
	DPFrameFill:Dock(FILL)
	DPFrameFill.Paint = function(s, w, h) end
	
	function DPFrameFill:OnSizeChanged()
		-- Здесь блоки с инвентарем и чатом
		local DPL = vgui.Create("DPanel",DPFrameFill)
		DPL:SetSize(DPFrameFill:GetWide()/2 - 2.5, 0)
		DPL:Dock(LEFT)
		DPL.Paint = function(s, w, h) end
		
		function DPL:OnSizeChanged()
			-- Мой инвентарь
			local DPLT = vgui.Create("DPanel",DPL)
			DPLT:SetSize(0, DPL:GetTall()/2 - 2.5)
			DPLT:Dock(TOP)
			DPLT.Paint = function(s, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
			end
			
			function DPLT:OnSizeChanged()
			
				local DPLTT = vgui.Create("DPanel",DPLT)
				DPLTT:SetSize(0, 25)
				DPLTT:Dock(TOP)
				DPLTT.Paint = function(s, w, h) end
				
				function DPLTT:OnSizeChanged()
					local createdDlabel = vgui.Create( "DLabel", DPLTT )
					createdDlabel:Dock( LEFT )
					createdDlabel:SetSize( 200, 25 )
					createdDlabel:SetFont( "S_Light_15" )
					createdDlabel:SetText( 'Мой инвентарь' )
					createdDlabel:DockMargin(5, 5, 0, 0)
					
					local TextEntry = vgui.Create( ".CCTextEntry", DPLTT )
					TextEntry:Dock(RIGHT)
					TextEntry:SetSize( 200, 25 )
					TextEntry:SetText( "" )
					TextEntry:SetPlaceholderText( "Поиск" )
					
					TextEntry:SetTextColor( Color(255,255,255) )
					TextEntry.OnChange = function( self )
						local my = FrameTrade.MyInv
						
						for i,v in pairs(my.list) do
							if string.find( v.DataName:lower(), self:GetValue():lower() ) then
								v:SetVisible(true)
							else
								v:SetVisible(false)
							end
						end
					end	
					FrameTrade.DTextEntry = TextEntry
				end	
				
				local DPLTop = vgui.Create("DPanel",DPLT)
				DPLTop:SetSize(0, DPLT:GetTall()/2 - 2.5)
				DPLTop:Dock(FILL)
				DPLTop.Paint = function(s, w, h) end
				FrameTrade.MyInv = DPLTop
				function DPLTop:OnSizeChanged()
					FrameTrade.MakeDraggable(DPLTop, 'myinv')
				end
			end
			
			-- Локальный чат
			local DPLBot = vgui.Create("DPanel",DPL)
			DPLBot:SetSize(0, DPL:GetTall()/2 - 2.5)
			DPLBot:Dock(BOTTOM)
			DPLBot.Paint = function(s, w, h) 
				draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
			end
			FrameTrade.Chat = DPLBot
			
			function DPLBot:OnSizeChanged()
				local chatLog = vgui.Create("RichText", DPLBot)
				
				chatLog:Dock(FILL)
				chatLog:SetPos( 5, 5 )
				chatLog.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
				end	
				chatLog.PerformLayout = function( self )
					self:SetFontInternal("S_Regular_20")
					self:SetFGColor( color_white )
				end 
				chatLog.AddText = function( self, username, text )		
					self:InsertColorChange( 150, 150, 255, 255 )
					self:AppendText(username) 
					self:InsertColorChange( 255, 255, 255, 255 )
					self:AppendText(": ") 
					self:AppendText(text) 
					self:AppendText("\n") 
				end
				FrameTrade.ChatLog = chatLog
				
				local TextEntry = vgui.Create( ".CCTextEntry", DPLBot )
				TextEntry:Dock(BOTTOM)
				TextEntry:SetSize( 0, 25 )
				TextEntry:SetText( "" )
				TextEntry:SetPlaceholderText( "Введи сообщение" )
				
				TextEntry:SetTextColor( Color(255,255,255) )
        TextEntry.OnEnter = function( self )
          netstream.Start('TTSTrade/Chat', {
            text = self:GetValue()
          })
					-- TradeWS:emit('chat', {
					-- 	id = data.id,
					-- 	text = self:GetValue()
					-- })
					
					self:SetText("")
					self:RequestFocus()
				end	 
			end
    end
    
		-- Здесь блоки с предложениями
		local DPR = vgui.Create("DPanel",DPFrameFill) 
		DPR:SetSize(DPFrameFill:GetWide()/2 - 2.5, 0)
		DPR:Dock(RIGHT)
		DPR.Paint = function(s, w, h) end
		function DPR:OnSizeChanged()
			-- Мой инвентарь 
			local DPRTop = vgui.Create("DPanel",DPR)
			DPRTop:SetSize(0, DPR:GetTall()/2 - 2.5)
			DPRTop:Dock(TOP)
			DPRTop.Paint = function(s, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
			end
			function DPRTop:OnSizeChanged()
				local createdDlabel = vgui.Create( "DLabel", DPRTop )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Мое предложение' )
				createdDlabel:DockMargin(5, 5, 0, 0)
				
				local DPRTop = vgui.Create("DPanel", DPRTop)
				DPRTop:SetSize(0, DPRTop:GetTall()/2 - 2.5)
				DPRTop:Dock(FILL)
				DPRTop.Paint = function(s, w, h) end
				FrameTrade.ShareMyInv = DPRTop
				function DPRTop:OnSizeChanged()
					FrameTrade.MakeDraggable(FrameTrade.ShareMyInv, 'sharemyinv') 
				end
			end
			-- FrameTrade.MakeDraggable(FrameTrade.ShareMyInv, 'sharemyinv')
			-- Инвентарь чей-то
			
			local DPRTop = vgui.Create("DPanel",DPR)
			DPRTop:SetSize(0, DPR:GetTall()/2 - 2.5)
			DPRTop:Dock(BOTTOM)
			DPRTop.Paint = function(s, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
			end
			function DPRTop:OnSizeChanged()
				local createdDlabel = vgui.Create( "DLabel", DPRTop )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Предложение ' .. FrameTrade.you.username )
				createdDlabel:DockMargin(5, 5, 0, 0)
				
				local DPRTop = vgui.Create("DPanel", DPRTop)
				DPRTop:SetSize(0, DPRTop:GetTall()/2 - 2.5)
				DPRTop:Dock(FILL)
				DPRTop.Paint = function(s, w, h) end
				FrameTrade.ShareYourInv = DPRTop
				function DPRTop:OnSizeChanged()
					FrameTrade.MakeDraggable(FrameTrade.ShareYourInv, 'shareyourinv') 
				end
			end
		end
	end
	
	-- Здесь блоки с кнопками
	local DPR = vgui.Create("DPanel",FrameTrade)
	DPR:SetSize(FrameTrade:GetWide()/4, 0)
	DPR:Dock(RIGHT)
	DPR:DockMargin(5,0,0,0)
	DPR.Paint = function(s, w, h) end
	
	function DPR:OnSizeChanged()
		local m_buttonC = vgui.Create(".CCButton", DPR) 
		m_buttonC.Font = "S_Bold_20"   
		m_buttonC:SetSize( DPR:GetWide(), 60 )
		m_buttonC.Text = ""
		m_buttonC:SetBorders(false)
		m_buttonC.FakeActivated = true
		m_buttonC:Dock(TOP)
		m_buttonC:DockMargin(0,0,0,10)
		m_buttonC._CLerpedColor = m_buttonC.LerpedColor
    m_buttonC.DoClick = function(s)
      netstream.Start('TTSTrade/ChangeStatus', !(FrameTrade.me.status == 'accept'))
			-- TradeWS:emit('changeStatus', {
			-- 	id = FrameTrade.ID, 
			-- 	status = 
			-- })
		end
		m_buttonC.Think = function(s)
			if FrameTrade.me.status == 'accept' then
				s:SetDisabled(false)
				s.Text = "Я передумал"
				s.LerpedColor = Color(158,94,94)
			elseif FrameTrade.me.status == false then
				s:SetDisabled(false)
				s.Text = "Я принимаю предложение"
				s.LerpedColor = s._CLerpedColor
			else
				s:SetDisabled(true)
				s.Text = "Ты готов обменяться"
				s.LerpedColor = Color(94,158,94)
			end
		end
		
		local m_buttonC = vgui.Create(".CCButton", DPR) 
		m_buttonC.Font = "S_Bold_20"   
		m_buttonC:SetSize( DPR:GetWide(), 60 )
		m_buttonC.Text = "Обменяться"
		m_buttonC:SetBorders(false)
		m_buttonC.FakeActivated = true
		m_buttonC:Dock(BOTTOM)
		m_buttonC:DockMargin(0,0,0,10)
		m_buttonC._CLerpedColor = m_buttonC.LerpedColor
		m_buttonC.DoClick = function(s)
      netstream.Start('TTSTrade/Ready', !(FrameTrade.me.status == 'ready'))
			-- TradeWS:emit('ready', {
			-- 	id = FrameTrade.ID,
			-- 	status = !(me.status == 'ready')
			-- })
		end
		m_buttonC.Think = function(s) 
			if FrameTrade.me.status == 'ready' then
				s:SetDisabled(false)
				s.Text = "Отменить"
				s.LerpedColor = Color(158,94,94)
			elseif FrameTrade.me.status == 'accept' then
				s:SetDisabled(false)
				s.Text = "Готов обменяться"
				s.LerpedColor = s._CLerpedColor
			else
				s:SetDisabled(true)
				s.Text = "Сначала прими предложение"
				s.LerpedColor = s._CLerpedColor
			end
		end
		
		local m_buttonC = vgui.Create(".CCButton", DPR) 
		m_buttonC.Font = "S_Bold_20"   
		m_buttonC:SetSize( DPR:GetWide(), 60 )
		m_buttonC.Text = ""
		m_buttonC:SetBorders(false)
		m_buttonC:Dock(TOP)
		m_buttonC:DockMargin(0,0,0,5)
		m_buttonC.OnMousePressed = function(s) end
		m_buttonC.DoClick = function(s) end
		
		m_buttonC.Think = function(s)
			if FrameTrade.me.status then
				if FrameTrade.me.status == 'accept' then
					s.Text = FrameTrade.me.username .. " принял предложение"
				elseif FrameTrade.me.status == 'ready' then
					s.Text = FrameTrade.me.username .. " готов обменяться"
				end
				s.LerpedColorRewrite = 75
			else
				s.Text = FrameTrade.me.username .. " не готов"
				s.LerpedColorRewrite = 0
			end
		end
		
		
		local m_buttonC = vgui.Create(".CCButton", DPR) 
		m_buttonC.Font = "S_Bold_15"      
		m_buttonC:SetSize( DPR:GetWide(), 20 )   
		m_buttonC.Text = ""
		m_buttonC:SetBorders(false)
		m_buttonC:Dock(BOTTOM)
		m_buttonC:DockMargin(0,0,0,5)
		m_buttonC.OnMousePressed = function(s) end
		m_buttonC.DoClick = function(s) end
		
		m_buttonC.Think = function(s)
			if FrameTrade.Data.interval_count then
				local count = FrameTrade.Data.interval_count
				s.Text = "Обмен будет завершен через " .. count .. ' ' .. TTS.Libs.Interface.Plural(count, {"секунд", "секунду", "секунды"})
				s.LerpedColorRewrite = 75
			else
				s.Text = "Необходима готовность обоих сторон"   
				s.LerpedColorRewrite = 0
			end
		end
		
		local m_buttonC = vgui.Create(".CCButton", DPR) 
		m_buttonC.Font = "S_Bold_20"   
		m_buttonC:SetSize( DPR:GetWide(), 60 )
		m_buttonC.Text = "" 
		m_buttonC:SetBorders(false)
		m_buttonC:Dock(TOP)
		m_buttonC.OnMousePressed = function(s) end
		m_buttonC.DoClick = function(s) end
		
		m_buttonC.Think = function(s)
			if FrameTrade.you.status then
				if FrameTrade.you.status == 'accept' then
					s.Text = FrameTrade.you.username .. " принял предложение"
				elseif FrameTrade.you.status == 'ready' then
					s.Text = FrameTrade.you.username .. " готов обменяться"
				end
				s.LerpedColorRewrite = 75
			else
				s.Text = FrameTrade.you.username .. " не готов"
				s.LerpedColorRewrite = 0
			end
		end
		
	end
	function MoveToShare(perm_id)
		local my = FrameTrade.MyInv
		local sh = FrameTrade.ShareMyInv
		
		local Item
		
		for i,v in pairs(my.list) do
			if perm_id == v.ID then
				Item = v.DataItem
				
				table.remove(my.list, i)
				my.m_pnlContentGrid:RemoveItem( v, true )
				v:Remove()
				
				break
			end
    end
    
		if Item then
			FrameTrade.DTextEntry:SetText( "" )
			FrameTrade.DTextEntry:OnChange()
			FrameTrade.UpdateItem(sh, Item)
			sh.DScrollPanel.width_for_resize = 64
		end
	end
	function MoveToMyInv(perm_id)
		local my = FrameTrade.MyInv
		local sh = FrameTrade.ShareMyInv
		
		local Item
		
		for i,v in pairs(sh.list) do
			if perm_id == v.ID then
				Item = v.DataItem
				
				table.remove(sh.list, i)
				sh.m_pnlContentGrid:RemoveItem( v, true )
				v:Remove()
				
				
				break
			end
		end
		if Item then
			FrameTrade.UpdateItem(my, Item)
			my.DScrollPanel.width_for_resize = 64
		end
	end
	
	function AddYourItem(data)
		local our = FrameTrade.ShareYourInv
		
		if data then
			FrameTrade.UpdateItem(our, data)
			our.DScrollPanel.width_for_resize = 64
		end
	end
	function RemoveYourItem(data)
		local our = FrameTrade.ShareYourInv
		
		-- local Item
		
		if data then
			for i,v in pairs(our.list) do
				if data.perm_id == v.ID then
					-- Item = v.DataItem
					
					table.remove(our.list, i)
					our.m_pnlContentGrid:RemoveItem( v, true )
					v:Remove()
					
					break
				end
			end
			our.DScrollPanel.width_for_resize = 64
		end
  end
  FrameTrade.MoveToShare = MoveToShare
  FrameTrade.MoveToMyInv = MoveToMyInv
  FrameTrade.AddYourItem = AddYourItem
  FrameTrade.RemoveYourItem = RemoveYourItem

end


