local Maps = {}
local pnlForFun = nil
local PnlFunction = function(pnl)
	for i, v in pairs(pnl:GetChildren()) do
		v:Remove()
	end
	
	for i, v in pairs(Maps.maps) do
		local btn = pnl:GetParent().AddItemInSidebar(v)
		local _oThink = btn.Think
		btn.Think = function(s)
			_oThink(s)
			if s.Active then
				s:SetBorders(false)
			else
				s:SetBorders(BORDER_LEFT)
			end
		end
		btn.FakeActivated = true
		if Maps.block[v] then
			btn.LerpedColor = Color(230, 130, 130)
		end
		if btn.ID == pnl.ActiveID then
			btn:DoClick()
		end
	end
end
if CLIENT then 
	-- hook.Add('InitPostEntity', 'HookTTSMaps', function()
		netstream.Hook('tts_get_maps', function(maps)
			-- PrintTable(maps)
			Maps = maps
			-- print(pnlForFun)
			if IsValid(pnlForFun) then
				PnlFunction(pnlForFun)
			end
		end)
	-- end)
end
local TAB = {}
-- print(TAB_MAPS, 'TAB_MAPS')
TAB.ID = TAB_MAPS 
TAB.Name = "Карты"
TAB.Perms = {
	edit_maplist = true
}

TAB.CategoryItemsFill = function ( self, pnl, category_id )
	-- print(category_id, category_id == '', 'checkout')
	if !Maps.block then return end
	if category_id == '' then return end
	local l1 = vgui.Create("DLabel", pnl)
	l1:SetText("Название карты")
	l1:Dock(TOP) 
	l1:DockMargin(4, 0, 4, 4)
	l1:SizeToContents()
	local l1 = vgui.Create("DLabel", pnl)
	l1:SetText(category_id)
	l1:Dock(TOP) 
	l1:DockMargin(4, 0, 4, 14)
	l1:SizeToContents()
	-- print(category_id)
	if Maps.block[category_id] then
		local l1 = vgui.Create("DLabel", pnl)
		l1:SetColor( Color(230, 130, 130))
		l1:SetText("Отключен")
		l1:Dock(TOP)
		l1:DockMargin(4, 0, 4, 4)
		l1:SizeToContents()
	else
		local l1 = vgui.Create("DLabel", pnl)
		l1:SetColor( Color(130, 230, 130))
		l1:SetText("Включен")
		l1:Dock(TOP)
		l1:DockMargin(4, 0, 4, 4)
		l1:SizeToContents()
	end
	
	local m_button = vgui.Create(".CCButton", pnl)
	m_button.Font = "S_Regular_20"
	m_button.TextAlignX = TEXT_ALIGN_LEFT
	m_button.XPos = 10
	m_button.Text = 'Переключить состояние'
	m_button:SetSize( 20,40 )
	m_button:DockMargin(4, 0, 4, 4)
	m_button:Dock( TOP )   
	m_button.DoClick = function(s)
		netstream.Start('tts_get_maps_trigger', category_id, !Maps.block[category_id])
	end
end

TAB.SidebarAddButton = function ( self, pnl, category_id )
	pnlForFun = pnl
	netstream.Start('tts_get_maps')
	
	-- pnl:GetParent().AddItemInSidebar('Все')
end
TAB.SidebarRemoveButton = function ( self, pnl, category_id )
end
-- print('asd') 
TTS.Admin.tabs.Register( TAB )
