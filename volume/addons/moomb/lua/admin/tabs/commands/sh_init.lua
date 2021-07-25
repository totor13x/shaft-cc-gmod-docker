local TAB = {}

TAB.ID = TAB_COMMANDS
TAB.Name = "Команды"

TTS.Admin.GlobalPanel = function(self, command, data, ply)
	local pnl = self
	if !IsValid(self) then
		if IsValid(m_pnlAdminFrame) then
			m_pnlAdminFrame:Remove()
		end
		
		m_pnlAdminFrame = vgui.Create('.CCFrame') 
		m_pnlAdminFrame:SetSize(250,300)
		m_pnlAdminFrame:SetPos(0,100) 
		m_pnlAdminFrame:SetTitle('')
		m_pnlAdminFrame:Center()
		m_pnlAdminFrame:MakePopup()
		
		m_pnlAdminFrame.sp = vgui.Create("DScrollPanel", m_pnlAdminFrame)
		m_pnlAdminFrame.sp:SetSize( 200, 400 )
		m_pnlAdminFrame.sp:Dock(FILL)
		m_pnlAdminFrame.sp.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,150))
		end
		
		pnl = m_pnlAdminFrame
	else 
		pnl = self:CreateFrame()
	end
	local fr = pnl
	
	fr.args = {}
	
	local createdDlabel = vgui.Create( "DLabel", fr.sp )
	createdDlabel:Dock( TOP )
	createdDlabel:SetFont( "S_Bold_20" )
	createdDlabel:SetText( 'Команда ' .. data.ID )
	createdDlabel:DockMargin(5, 5, 0, 0)
	fr.sp:AddItem(createdDlabel)
	local attrs = {}
	local attrsInputs = {}
	if data.m_RequiredAttrs then
		for id, attr in pairs(data.m_RequiredAttrs) do
			table.insert(attrs, {
				opt = 'required',
						attr = attr
					})
				end
			end
			if data.m_OptionalAttrs then
				for id, attr in pairs(data.m_OptionalAttrs) do
					table.insert(attrs, {
						opt = 'optional',
						attr = attr
					})
				end
			end
			for id, data in pairs(attrs) do
				local attr = data.attr
				local req = data.opt == 'required'
				local createdDlabel = vgui.Create( "DLabel", fr.sp )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_17" )
				createdDlabel:SetText( 'Аргумент #' .. id .. (req and (' <' .. attr .. '>') or (' [' .. attr .. ']')) )
				createdDlabel:DockMargin(5, 5, 0, 0)
				fr.sp:AddItem(createdDlabel)
				if attr == 'player' then
					local DComboBox = vgui.Create( ".CCDropDown", fr.sp )
					DComboBox.Text = 'Выбор одного игрока'
					DComboBox:Dock( TOP )
					DComboBox.FakeActivated = true
					DComboBox:DockMargin(0, 5, 0, 0)
					DComboBox.OnSelect = function( panel, index, aa )
						local data, sec = panel:GetSelected()
						
						fr.args[id] = sec
					end

					local targets = TTS.Admin.GetTargets(LocalPlayer(), '*')
					
					for _, target in pairs(targets) do
						DComboBox:AddChoice( 
							target:Nick() .. ' (' .. target:SteamID() .. ')',
							target:SteamID() ~= 'NULL'
								and target:SteamID()
								or target:Nick(),
							target == ply
						)
					end
					fr.sp:AddItem(DComboBox)
					attrsInputs[id] = DComboBox
				elseif attr == 'idrule' then
				
					fr:SetSize(450,350)
					fr:Center()
					local DComboBox = vgui.Create( ".CCListView", fr.sp )
					DComboBox:DockMargin(0, 5, 0, 0)
					DComboBox:SetSize( 0,150 )  
					DComboBox:Dock( TOP )
					DComboBox:SetMultiSelect( true )
					DComboBox:AddColumn( "Правило" )
					DComboBox:AddColumn( "Описание" )

			
					DComboBox.OnRowSelected = function( panel, rowIndex, row )
						local args = {}
						for i,v in pairs(panel:GetSelected()) do
							table.insert(args, v:GetValue( 1 ) )
						end
						
						fr.args[id] = table.concat(args, ',')
					end
					
					fr.sp:AddItem(DComboBox)
					attrsInputs[id] = DComboBox
					TTS.HTTP(
						'/api/rules', 
						{
							on_server = true,
							server_id = HoolDon.server,
						},
						function(data)
							for _, rule in pairs(data) do
								DComboBox:AddLine( 
									rule.slug,
									rule.description
								)
							end
						end,
						function(data)
						end
					)
				elseif attr == 'players' then
				
				
					local PlayerList = vgui.Create( ".CCListView", fr.sp )
					PlayerList:DockMargin(0, 5, 0, 0)
					PlayerList:SetSize( 0,150 )  
					PlayerList:Dock( TOP )
					PlayerList:SetMultiSelect( true )
					PlayerList:AddColumn( "Ник" )
					PlayerList:AddColumn( "SteamID" )

					local targets = TTS.Admin.GetTargets(LocalPlayer(), '*')
					
					PlayerList.OnRowSelected = function( panel, rowIndex, row )
						local args = {}
						for i,v in pairs(panel:GetSelected()) do
							table.insert(args, v:GetValue( 2 ) )
						end
						
						fr.args[id] = table.concat(args, ',')
					end
					for _, target in pairs(targets) do
						local pnl = PlayerList:AddLine( 
							target:Nick(), 
							target:SteamID() ~= 'NULL'
								and target:SteamID()
								or target:Nick() 
						)
						if target == ply then
							PlayerList:SelectItem(pnl)
						end
					end
					fr.sp:AddItem(PlayerList)
					attrsInputs[id] = PlayerList
				elseif attr == 'length' then
					local typ = 'seconds'
					local dp = vgui.Create("DPanel", fr.sp)
					dp:SetTall( 35 )
					dp:Dock(TOP)
					dp.Paint = function() end
					fr.sp:AddItem(dp)
					
					local ps = vgui.Create(".CCNumberWang", dp)
					ps:SetTextColor( Color(0, 0, 0, 255) )
					ps:SetWide( (250+10)/2 )
					ps:SetValue(1)
					ps:SetDecimals(0)
					ps.Font = "S_Light_15"
					ps:SetMin(0)
					ps:SetMax(365)
					-- ps:SetTall(32)
					ps.FakeActivated = true
					-- ps:DockMargin(0, 5, 0, 0)
					ps:Dock(LEFT)
					ps.Font = "S_Light_15"
					ps.XPos = 10
					ps.TextAlignX = TEXT_ALIGN_LEFT
					ps.TextAlignY = TEXT_ALIGN_CENTER
					ps.OnValueChanged = function (val)
						local scal = 1
						if typ == 'seconds' then
							scal = 1
						elseif typ == 'minutes' then
							scal = 60
						elseif typ == 'hours' then
							scal = 60*60
						elseif typ == 'days' then
							scal = 60*60*24
						end
						
						fr.args[id] = tostring(val:GetValue() * scal)
						-- print(val:GetValue() * scal)
					end
					attrsInputs[id] = ps
					local DComboBox = vgui.Create( ".CCDropDown", dp )
					-- DComboBox.Text = 'секунд'
					-- DComboBox:SetWide( (250-30)/2 )
					DComboBox:DockMargin(5, 0, 0, 0)
					-- DComboBox:SetTall(30)
					-- DComboBox.AnotherText = true
					DComboBox:Dock( FILL )
					DComboBox:SetBorders( false )
					DComboBox:SetSortItems( false )
					DComboBox.FakeActivated = true
					local aid = DComboBox:AddChoice( 'секунд', 'seconds' )
					DComboBox:AddChoice( 'минут', 'minutes' )
					DComboBox:AddChoice( 'часов', 'hours' )
					DComboBox:AddChoice( 'дней', 'days' )
					DComboBox:ChooseOptionID( aid )
					DComboBox.OnSelect = function( panel, index, aa )
						local data, sec = panel:GetSelected()
            typ = sec
            local _old = ps:GetValue() 
            ps:SetValue(0)
						ps:SetValue(_old)
					end
					-- DComboBox:DockMargin(0, 5, 0, 0)
					-- DComboBox:SetSize( 100, 40 )
				elseif attr == 'reason' then
					local reason = vgui.Create(".CCTextEntry", fr.sp)
					reason:SetTextColor( Color(0, 0, 0, 255) ) 
					-- reason:SetTall(24)
					-- reason:DockMargin(0, 0, 0, 0)
					reason:Dock(TOP)
					reason.Font = "S_Light_15"
					reason.XPos = 10
					reason.TextAlignX = TEXT_ALIGN_LEFT
					reason.TextAlignY = TEXT_ALIGN_CENTER
					reason:SetPlaceholderText( "Причина" )
					reason.FakeActivated = true
					
					reason.OnChange = function (val)
						fr.args[id] = "\"" .. val:GetValue() .. "\""
					end
          attrsInputs[id] = reason
          
        
        elseif attr == 'text' then
          local reason = vgui.Create(".CCTextEntry", fr.sp)
          reason:SetTextColor( Color(0, 0, 0, 255) ) 
          -- reason:SetTall(24)
          -- reason:DockMargin(0, 0, 0, 0)
          reason:Dock(TOP)
          reason.Font = "S_Light_15"
          reason.XPos = 10
          reason.TextAlignX = TEXT_ALIGN_LEFT
          reason.TextAlignY = TEXT_ALIGN_CENTER
          reason:SetPlaceholderText( "Текст" )
          reason.FakeActivated = true
          
          reason.OnChange = function (val)
            fr.args[id] = "\"" .. val:GetValue() .. "\""
          end  
          attrsInputs[id] = reason
        elseif attr == 'number' then
          local reason = vgui.Create(".CCNumberWang", fr.sp)
          reason:SetTextColor( Color(0, 0, 0, 255) ) 
          -- reason:SetTall(24)
          -- reason:DockMargin(0, 0, 0, 0)
          reason:Dock(TOP)
					reason:SetDecimals(0)
          reason.Font = "S_Light_15"
          reason.XPos = 10
          reason.TextAlignX = TEXT_ALIGN_LEFT
          reason.TextAlignY = TEXT_ALIGN_CENTER
          reason:SetPlaceholderText( "Число" )
          reason.FakeActivated = true
          
          -- local _old = ps:GetValue() 
          -- ps:SetValue(0)
          -- ps:SetValue(_old)
          reason.OnValueChanged = function (val)
          -- reason.OnChange = function (val)
            -- print(val)
            fr.args[id] = "\"" .. val:GetValue() .. "\""
          end  
          attrsInputs[id] = reason
				end
			end
			
			local m_button = vgui.Create(".CCButton", fr.sp)
			m_button.Font = "S_Regular_15"
			m_button:SetSize( 0,35 )  
			m_button:DockMargin(0, 5, 0, 0)
			m_button:Dock( TOP )
			m_button.Text = 'Выполнить'
			m_button:SetBorders(false)
			m_button.DoClick = function( s )
				-- PrintTable(attrs)
				local block = false
				for i, opt in pairs(attrs) do
					if opt.opt == 'required' then
						if fr.args[i] == nil then
							block = true
							
							local inp = attrsInputs[i]
							inp.Think = function(s)
								s.LerpedColorRewrite = s.LerpedColorRewrite - 3
								if s.LerpedColorRewrite < 1 then
									s.Think = nil
									s.LerpedColorRewrite = nil
									s:SetDisabled(false)
								end
							end
							inp.LerpedColorRewrite = 255
							inp:SetDisabled(true)
							-- inp.LerpedColor = Color(255, 50, 50)
						end
					end
				end
				if !block then
					print('app', command, unpack(fr.args))
					RunConsoleCommand('app', command, unpack(fr.args))
				end
			end	
end

TAB.CategoryItemsFill = function ( self, pnl, category_id )
	local w, h = pnl:GetSize()
	local count = 2
	local inner_width, item_width, item_height = w/count, 200, 50 
	local DScrollPanel = vgui.Create( "DScrollPanel", pnl )
	DScrollPanel:Dock( FILL ) 
	 
	local m_pnlContentGrid = vgui.Create( "DGrid", DScrollPanel )
	m_pnlContentGrid:SetSize( w,h )
	m_pnlContentGrid:SetRowHeight( item_height )
	m_pnlContentGrid:SetCols( count ) 
	m_pnlContentGrid:SetColWide( w/count ) 
	
	local count_items = 0
  for i,data in SortedPairsByMemberValue(TTS.Admin.commands.GetCommands(), 'ID' ) do
		local command = data.ID
		
		local can = true
		-- PrintTable(data)
		for i,v in pairs(data.m_Permissions) do
			if not hasPerm(i) then
				can = false
				break
			end
		end 
	
		if not can then
			continue
		end
		local m_btn = vgui.Create(".CCButton", m_pnlContentGrid)
		m_btn.Font = "S_Light_20"  
		m_btn:SetSize( w/count, item_height )  
		m_btn.Text = ""
		m_btn:SetBorders(false)
		m_btn.DoClick = function(s)
			TTS.Admin.GlobalPanel(self, command, data)
		end
		-- m_btn.FakeActivated = true
		local _oldPaint = m_btn.Paint
		m_btn.Paint = function(s, w, h)
			_oldPaint(s, w, h)
			
			draw.SimpleText(data.ID:upper(), "S_Bold_20", 5, 15, s.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(data:GetDescription(), "S_Light_17", 5, h-15, s.TextColorLerped, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		m_pnlContentGrid:AddItem( m_btn )
		DScrollPanel:AddItem( m_btn )
	end
	
	 
	local width_for_resize = item_width 
	function DScrollPanel:Think() 
		if width_for_resize == self:InnerWidth() 
			|| (width_for_resize+1) == self:InnerWidth() 
		then 
			return 
		end

		width_for_resize = self:InnerWidth()
		count = width_for_resize/item_width
		count = math.floor(count)
		-- print(width_for_resize/count, count)
		inner_width = math.floor(width_for_resize/count) 
		
		m_pnlContentGrid:SetSize( width_for_resize, h )
		m_pnlContentGrid:SetCols( count )
		m_pnlContentGrid:SetColWide( inner_width ) 
		
		for i,v in pairs(m_pnlContentGrid:GetItems()) do
			v:SetSize( inner_width, item_height ) 
		end
	end
end
TAB.SidebarAddButton = function ( self, pnl, category_id )
	pnl:GetParent().AddItemInSidebar('Все')
	-- pnl:GetParent().AddItemInSidebar('Фановые')
end
TAB.SidebarRemoveButton = function ( self, pnl, category_id )
	
end

TTS.Admin.tabs.Register( TAB )