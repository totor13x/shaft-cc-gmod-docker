local scrW = 1280 
local scrH = 720
local items = {}
local UnboxWindowOpen = false
local isSpinning = false 
local IsUnboxingItems = false  
local matGradient = Material( "gui/gradient" )
local AllowFastAll = true
CrateInfo = {        
	List = {},    
	ServerID = nil 
}

CrateWS = CrateWS or false  

netstream.Hook("CrateList::Sync", function(data) 
		CrateInfo.List = data 
	hook.Remove("CreateMove", "Roulette/F4")
	hook.Add("CreateMove",'Roulette/F4', function()		
		if input.WasKeyPressed(KEY_F4) and not (vgui.GetKeyboardFocus() or gui.IsGameUIVisible()) then
			OpenListKeys()
    end
    if IsValid(CaseFrame) then
      if input.WasKeyPressed(KEY_ESCAPE) and gui.IsGameUIVisible() then
        if !isSpinning then
          CaseFrame.btnClose:DoClick()
          gui.HideGameUI()
        end
      end
    end
	end)
end)  

local cases = 0
local keys = 0

netstream.Hook('crateUpdate', function(data)
  if IsValid(CaseFrame) and CaseFrame.ID == data.crate_id then
    CaseFrame.Cases = data.data.cases
    CaseFrame.Keys = data.data.keys
    CaseFrame.McTime = data.mctime
  end
end)

function OpenListKeys()
	if IsValid(ListMenuKeys) then
		ListMenuKeys:Remove()
	end
	if IsValid(CaseFrame) then 
		CaseFrame:Remove()
	end
	ListMenuKeys = vgui.Create( ".CCFrame" )
	ListMenuKeys:SetSize( 800, 500 )
	ListMenuKeys:SetPos(0,100)
	ListMenuKeys:Center()
	ListMenuKeys:SetTitle( "Кейсы" )  
	ListMenuKeys:MakePopup()
	ListMenuKeys:SetDeleteOnClose(true)
	
	ListMenuKeyspanel2 = vgui.Create("DScrollPanel",ListMenuKeys)
	ListMenuKeyspanel2:Dock(FILL)
	PrintTable(CrateInfo.List)
	for i, v in pairs(CrateInfo.List) do
		local DPanl = ListMenuKeyspanel2:Add( "DPanel" )
		DPanl:SetSize(0, 40) 
		DPanl:Dock( TOP )
		
		local text = 'PREMIUM'
		local color1 = Vector(94, 130, 158)
		local color2 = Vector(143, 217, 234)
		DPanl.textPrem = text
		DPanl.LerpPrem = 0
		DPanl.Paint = function( s, w, h )
			local width = 0
			surface.SetFont( "S_Bold_20" )
			if tobool(v.is_premium) then
				DPanl.LerpPrem = LerpVector(math.abs( math.sin(CurTime() * 3) ), color1, color2)
				local color = Color(NormalizeColor(unpack(DPanl.LerpPrem:ToTable())))

				local text = s.textPrem
				width = surface.GetTextSize( text ) 
				width = width + 5
				draw.SimpleText(text, "S_Bold_20", 10, (h/2)-1, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
			end
			draw.SimpleText("КЕЙС: " .. v.name, "S_Bold_20", 10 + width, (h/2)-1, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
		local m_button = vgui.Create(".CCButton", DPanl)
		m_button.Font = "S_Regular_25"   
		m_button:SetSize( 200 , 40 )  
		m_button.Text = "ОТКРЫТЬ МЕНЮ"
		m_button:SetBorders(false)
		m_button:Dock(RIGHT)
    m_button.DoClick = function(s)
      netstream.Start('crateOpen', v.id)
		end
	end
end
netstream.Hook('crateOpen', function(data)
  if IsValid(ListMenuKeys) then
    ListMenuKeys:SetVisible(false)
  end
  if IsValid(CaseFrame) then
    CaseFrame:Remove()
  end
  
  
  
  CaseFrame = vgui.Create( ".CCFrame" )
  CaseFrame.Cases = 0
  CaseFrame.Keys = 0
  CaseFrame.ID = data.crate.id
  CaseFrame.McTime = data.mctime
  CaseFrame:SetSize( 1280, 720)
  CaseFrame:Center()
  CaseFrame:SetTitle( 'Кейс: ' .. data.crate.name )  
  CaseFrame:MakePopup()
  CaseFrame:SetDeleteOnClose(true)
  CaseFrame.Think = function(s)
    if isSpinning then
      s.btnClose:SetDisabled(true)
      return
    end
    s.btnClose:SetDisabled(false)

    if TTS.DEBUG then
      local text = data.crate.name

      -- if TTS.DEBUG then
      text = text .. ' | ' .. CaseFrame.McTime
      -- end

      s:SetTitle( 'Кейс: ' .. text )  
    end
  end

  
  if data.data then
    CaseFrame.Cases = data.data.cases or 0
    CaseFrame.Keys = data.data.keys or 0
  end

  CaseFrameHistoryPanel = vgui.Create("DScrollPanel",CaseFrame)
  -- CaseFrameHistoryPanel = vgui.Create("DPanelList",CaseFrame)
  CaseFrameHistoryPanel:SetSize(255, 0)
  CaseFrameHistoryPanel:Dock(LEFT)
  -- CaseFrameHistoryPanel:EnableHorizontal( false ) 
  -- CaseFrameHistoryPanel:EnableVerticalScrollbar( true )
  
  CaseFrameHistoryPanel.Paint = function( s, w, h )
    -- draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 150, 200, 200) )
  end
  CaseFrameHistoryPanel.AddItemList = function(s, name, tim)
    s.List = s.List or {}
    table.insert(s.List, {
      name = name,
      time = tim
    })
    if #s.List > 25 then
    table.remove( s.List, 1 ) 
    end
    s:Clear()
    for i,v in SortedPairs(s.List, true) do
      s:AddItemPanel(v.name, v.time)
    end
  end
  CaseFrameHistoryPanel.AddItemPanel = function(s, name, tim)
    local Dbutus = s:Add( "DPanel" )
    Dbutus:SetSize(s:GetWide(),30 + 2)
    Dbutus:SetText("")
    Dbutus:Dock( TOP )
    Dbutus.Paint = function( s, w, h )
      draw.SimpleText(name, "S_Light_15", 10, 8, Color(235,190,190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
      -- if v.time ~= nil then
      draw.SimpleText(tim, "S_Light_15", 10, 20, Color(190,190,190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
      -- end
    end	
  end
  function CaseFrameHistoryPanel:OnSizeChanged()
    for i,v in SortedPairs(data.history, true) do
      CaseFrameHistoryPanel:AddItemList(v.name, v.created_at)
    end
  end
  
  local DPCaseFrameRight = vgui.Create("DPanel",CaseFrame)
  DPCaseFrameRight:SetSize(255+200, 0)
  DPCaseFrameRight:Dock(RIGHT)
  DPCaseFrameRight.Paint = function() end
  
  CaseFrameDropListPanel = vgui.Create("DScrollPanel",DPCaseFrameRight)
  CaseFrameDropListPanel:SetSize(255, 0)
  CaseFrameDropListPanel:Dock(LEFT)
  
  CaseFrameDropListPanel.Paint = function( s, w, h )
    -- draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 200, 200, 200) )
  end
  local changes = 0
  -- CaseFrameDropListPanel.AddItemList = function(s, name, tim)
    -- s.List = s.List or {}
    -- table.insert(s.List, {
      -- name = name,
      -- time = tim
    -- })
    -- s:Clear()
    -- for i,v in SortedPairs(s.List, true) do
      -- s:AddItemPanel(v.name, v.time)
    -- end
  -- end
  CaseFrameDropListPanel.AddItemPanel = function(s, name, tim)
    local Dbutus = s:Add( "DPanel" )
    Dbutus:SetSize(s:GetWide(),30 + 2)
    Dbutus:SetText("")
    Dbutus:Dock( TOP )
    Dbutus.Paint = function( s, w, h )
      draw.SimpleText(name, "S_Light_15", 10, 8, Color(235,190,190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
      -- if v.time ~= nil then
      draw.SimpleText( math.Round((tim / changes) * 100, 3) .. '%', "S_Light_15", 10, 20, Color(190,190,190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
      -- end
    end	
  end
  function CaseFrameDropListPanel:OnSizeChanged()
    for i,v in SortedPairsByMemberValue(data.crate.items, "change", true) do
    -- SortedPairs(data.crate.items, true) do
      CaseFrameDropListPanel:AddItemPanel(v.name, v.change)
      changes = changes + v.change
      -- print(i)
      -- CaseFrameHistoryPanel:AddItemPanel(v.item.itemable.name, v.created_at)
    end
    -- timer.Simple(2, function()
      -- CaseFrameHistoryPanel:AddItemList('1', '3123')
      -- CaseFrameHistoryPanel:AddItemList('2', '3123')
      -- CaseFrameHistoryPanel:AddItemPanel('3', '3123')
    -- end)
  end
  
  SpinPanel = vgui.Create("DPanel", DPCaseFrameRight)
  SpinPanel:Dock(FILL)
  -- SpinPanel:SetSize(255, 0)
  SpinPanel:DockMargin(5, 0, 0, 0)
  -- SpinPanel:SetPos(Frame150, 25)
  -- SpinPanel:SetSize(150 , Frame:GetTall()-25)
  SpinPanel.Paint = function(s, w ,h)
    -- draw.RoundedBox(0,0,0,w,h,Color(0,255,0,255)) 
  end
    
  function SpinPanel:OnSizeChanged()
    CaseHiddenPanel = vgui.Create("DPanel", SpinPanel)
    CaseHiddenPanel:SetSize(SpinPanel:GetWide() , SpinPanel:GetTall())
    CaseHiddenPanel:SetPos( 0, 0 )
    CaseHiddenPanel:SetZPos( 2 )
    CaseHiddenPanel.Wide = SpinPanel:GetWide()
    CaseHiddenPanel.Paint = function(self , w , h)
      draw.RoundedBox( 0, 0, 0, self.Wide, h, Color(50,50,50)) 
    end
    
    Line = vgui.Create("DPanel" , SpinPanel) 
    Line:SetSize(SpinPanel:GetWide() , SpinPanel:GetTall()) 
    Line:SetPos(0, 0) 
    Line:SetZPos( 1 )
    Line.Paint = function(self , w , h)
      draw.RoundedBox(0, 0 , (h/2)-1 , w , 2 , Color(0,129,0, 150))
    end
  end
  
  local DPCaseFrameFill = vgui.Create("DPanel", CaseFrame)
  DPCaseFrameFill:Dock(FILL)
  -- SpinPanel:SetSize(255, 0)
  DPCaseFrameFill:DockMargin(5, 0, 5, 0)
  -- SpinPanel:SetPos(Frame150, 25)
  -- SpinPanel:SetSize(150 , Frame:GetTall()-25)
  DPCaseFrameFill.Paint = function(s, w ,h)
    -- draw.RoundedBox(0,0,0,w,h,Color(200,200,150,255))
  end
  
  
  local PointsBlock = vgui.Create("DPanel", DPCaseFrameFill)
  PointsBlock:Dock(TOP)
  PointsBlock:SetSize(0, 25)
  PointsBlock:DockMargin(0, 0, 0, 5)
  PointsBlock.Paint = function(s, w ,h)
    draw.RoundedBox(0,0,0,w,h,Color( 35, 35, 35, 200 ))
    draw.SimpleText('Твои поинты: ' .. TTS.Shop.UserPoints, "S_Light_20", w/2, h/2 -1, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
  
  local CaseKeyBlock = vgui.Create("DPanel", DPCaseFrameFill)
  CaseKeyBlock:Dock(TOP)
  CaseKeyBlock:SetSize(0, 170)
  CaseKeyBlock:DockMargin(0, 0, 0, 5)
  CaseKeyBlock.Paint = function(s, w ,h)
    -- draw.RoundedBox(0,0,0,w,h,Color( 35, 35, 35, 200 ))
    local half_w = (w/2)/2
    local h2 = (h/2)
    
    local count = CaseFrame.Keys
    draw.SimpleText(count, "S_Bold_80", w/2 - half_w, h2-30, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(TTS.Libs.Interface.Plural(count, {"ключей", "ключ", "ключа"}), "S_Light_30", w/2 - half_w, h2+30, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    local count = CaseFrame.Cases
    draw.SimpleText(count, "S_Bold_80", w/2 + half_w, h2-30, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(TTS.Libs.Interface.Plural(count, {"кейсов", "кейс", "кейса"}), "S_Light_30", w/2 + half_w, h2+30, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
  end
  
  local CaseKeyBuy = vgui.Create("DPanel", DPCaseFrameFill)
  CaseKeyBuy:Dock(TOP)
  CaseKeyBuy:SetSize(0, 60)
  CaseKeyBuy:DockMargin(0, 0, 0, 5)
  CaseKeyBuy.Paint = function(s, w ,h) end
  
  function CaseKeyBuy:OnSizeChanged()
    local m_buttonC = vgui.Create(".CCButton", CaseKeyBuy)
    m_buttonC.Font = "S_Bold_20"   
    m_buttonC:SetSize( (CaseKeyBuy:GetWide() / 2) - 2.5, 60 )  
    m_buttonC.Text = ""
    m_buttonC:SetBorders(false)
    m_buttonC:Dock(LEFT)

    local _oldPaint = m_buttonC.Paint 
    m_buttonC.Paint = function(s,w,h)
      _oldPaint(s,w,h)
      draw.SimpleText( "КУПИТЬ КЛЮЧ (".. data.crate.buy_key ..")", "S_Bold_20", s.XPos, s.YPos-7, s.TextColorLerped, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      draw.SimpleText( "Нажми ПКМ, чтобы купить 5 ключей (" .. data.crate.buy_key * 5 .. ")", "S_Light_15", s.XPos, s.YPos+7, s.TextColorLerped, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    m_buttonC.DoClick = function(s)   
      netstream.Start('CrateBuy', {
        id = data.crate.id, 
        count = 1,
        type = 'keys'
      })
      -- CrateWS:emit('buy', {
      --   id = id, 
      --   type = 'keys',
      --   server_id = CrateInfo.ServerID 
      -- })
    end 
    m_buttonC.DoRightClick = function(s)   
      netstream.Start('CrateBuy', {
        id = data.crate.id, 
        count = 5,
        type = 'keys'
      })
      -- CrateWS:emit('buy', {
      --   id = id, 
      --   type = 'keys',
      --   server_id = CrateInfo.ServerID,
      --   count = 5
      -- })
    end
    
    local m_buttonC = vgui.Create(".CCButton", CaseKeyBuy)
    m_buttonC.Font = "S_Bold_20"    
    m_buttonC:SetSize( (CaseKeyBuy:GetWide() / 2) - 2.5, 60 )  
    m_buttonC.Text = ""
    m_buttonC:SetBorders(false)
    m_buttonC:Dock(RIGHT)
    
    local _oldPaint = m_buttonC.Paint
    m_buttonC.Paint = function(s,w,h)
      _oldPaint(s,w,h)
      draw.SimpleText( "КУПИТЬ КЕЙС (".. data.crate.buy_case ..")", "S_Bold_20", s.XPos, s.YPos-7, s.TextColorLerped, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      draw.SimpleText( "Нажми ПКМ, чтобы купить 5 кейсов (" .. data.crate.buy_case * 5 .. ")", "S_Light_15", s.XPos, s.YPos+7, s.TextColorLerped, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    m_buttonC.DoClick = function(s)     
      netstream.Start('CrateBuy', {
        id = data.crate.id, 
        count = 1,
        type = 'cases'
      })
      -- CrateWS:emit('buy', {
      --   id = id,    
      --   type = 'cases',
      --   server_id = CrateInfo.ServerID 
      -- })
    end 
    m_buttonC.DoRightClick = function(s)   
      netstream.Start('CrateBuy', {
        id = data.crate.id, 
        count = 5,
        type = 'cases'
      })
      -- CrateWS:emit('buy', {
      --   id = id, 
      --   type = 'cases',
      --   server_id = CrateInfo.ServerID,
      --   count = 5
      -- })
    end
  end
  
  local CaseKeySell = vgui.Create("DPanel", DPCaseFrameFill)
  CaseKeySell:Dock(TOP)
  CaseKeySell:SetSize(0, 60)
  CaseKeySell:DockMargin(0, 0, 0, 5)
  CaseKeySell.Paint = function(s, w ,h) end
  
  function CaseKeySell:OnSizeChanged()
    local m_buttonC = vgui.Create(".CCButton", CaseKeySell) 
    m_buttonC.Font = "S_Bold_20"   
    m_buttonC:SetSize( (CaseKeySell:GetWide() / 2) - 2.5, 60 )  
    -- m_buttonC:DockMargin(0, 0, 2.5, 0)
    m_buttonC.Text = "ПРОДАТЬ КЛЮЧ (".. data.crate.sell_key ..")"
    m_buttonC:SetBorders(false)
    m_buttonC:Dock(LEFT)
    m_buttonC.DoClick = function(s)      
      netstream.Start('CrateSell', {
        id = data.crate.id, 
        type = 'keys'
      })
    end
    
    local m_buttonC = vgui.Create(".CCButton", CaseKeySell)
    m_buttonC.Font = "S_Bold_20"    
    -- m_buttonC:DockMargin(2.5, 0, 0, 0, )
    m_buttonC:SetSize( (CaseKeySell:GetWide() / 2) - 2.5, 60 )   
    m_buttonC.Text = "ПРОДАТЬ КЕЙС (".. data.crate.sell_case ..")"
    m_buttonC:SetBorders(false)
    m_buttonC:Dock(RIGHT)
    m_buttonC.DoClick = function(s)    
      netstream.Start('CrateSell', {
        id = data.crate.id, 
        type = 'cases'
      })     
      -- CrateWS:emit('sell', {
      --   id = id, 
      --   type = 'cases',
      --   server_id = CrateInfo.ServerID 
      -- })
    end
  end
  
  local CaseKeyGift = vgui.Create("DPanel", DPCaseFrameFill)
  CaseKeyGift:Dock(TOP)
  CaseKeyGift:SetSize(0, 60)
  CaseKeyGift:DockMargin(0, 0, 0, 5)
  CaseKeyGift.Paint = function(s, w ,h) end
  
  function CaseKeyGift:OnSizeChanged()
    local m_buttonC = vgui.Create(".CCButton", CaseKeyGift)
    m_buttonC.Font = "S_Bold_20"   
    m_buttonC:SetSize( (CaseKeyGift:GetWide() / 2) - 2.5, 60 )  
    -- m_buttonC:DockMargin(0, 0, 2.5, 0)
    m_buttonC.Text = "ПОДАРИТЬ КЛЮЧ"
    m_buttonC:SetBorders(false)
    m_buttonC:Dock(LEFT)
    m_buttonC.DoClick = function(s)   
      -- print(data.crate.id)
      -- CrateWS:emit('crateSpin', tostring(data.crate.id))
    end
    
    local m_buttonC = vgui.Create(".CCButton", CaseKeyGift)
    m_buttonC.Font = "S_Bold_20"    
    -- m_buttonC:DockMargin(2.5, 0, 0, 0, )
    m_buttonC:SetSize( (CaseKeyGift:GetWide() / 2) - 2.5, 60 )   
    m_buttonC.Text = "ПОДАРИТЬ КЕЙС"
    m_buttonC:SetBorders(false)
    m_buttonC:Dock(RIGHT)
    m_buttonC.DoClick = function(s)   
      -- print(data.crate.id)
      -- CrateWS:emit('crateSpin', tostring(data.crate.id))
    end
  end

  local m_buttonC = vgui.Create(".CCButton", DPCaseFrameFill)
  m_buttonC.Font = "S_Bold_80"    
  -- m_buttonC:DockMargin(2.5, 0, 0, 0, )  
  m_buttonC.Text = "ОТКРЫТЬ"
  m_buttonC.FakeActivated = true
  m_buttonC:SetBorders(false)
  m_buttonC:Dock(TOP)
  m_buttonC:SetSize(0, 120)
  m_buttonC:DockMargin(0, 0, 0, 5)
  m_buttonC.DoClick = function(s)   
    -- print(data.crate.id)
    netstream.Start('CrateSpin', {
      id = data.crate.id,
    }) 
    -- CrateWS:emit('crateSpin', {
    --   id = tostring(data.crate.id),
    --   server_id = CrateInfo.ServerID 
    -- })
  end 
  m_buttonC.Think = function(s)
    if isSpinning then
      s:SetDisabled(true)
      return 
    end
    if CaseFrame.Cases == 0 || CaseFrame.Keys == 0 then
      s:SetDisabled(true)
      return
    end
    s:SetDisabled(false)
  end
  
  local _oldPaint = m_buttonC.Paint         
  m_buttonC.LerpLeav = table.Copy(m_buttonC.LerpedColor)
  m_buttonC.LerpLeav.a = 0   
  m_buttonC.Paint = function(s,w,h)
  
    if isSpinning then
      s.LerpLeav.a = Lerp(12*FrameTime() , s.LerpLeav.a, 255)
    else
      s.LerpLeav.a = Lerp(12*FrameTime() , s.LerpLeav.a, 0)
    end
    
    s.rotAngle = (s.rotAngle or 0) + 100 * FrameTime();
    -- if isSpinning then
    local distsize  = math.sqrt( w*w + h*h );
    -- local alphamult   = (s._alpha or 0)/ 255;       
    -- DLib.HUDCommons.Stencil.Start()

    -- DLib.HUDCommons.Stencil.StopDrawMask()
    surface.SetMaterial( matGradient );
    -- print(s.LerpLeav)
    surface.SetDrawColor( s.LerpLeav );
    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (s.rotAngle or 0) );

      -- DLib.HUDCommons.Stencil.Stop()
    -- end
    _oldPaint(s,w,h)
  end
       
  
  local m_buttonC = vgui.Create(".CCButton", DPCaseFrameFill)
  m_buttonC.Font = "S_Bold_60"    
  -- m_buttonC:DockMargin(2.5, 0, 0, 0, )  
  m_buttonC.Text = "ОТКРЫТЬ"
  m_buttonC.FakeActivated = true
  m_buttonC:SetBorders(false)
  m_buttonC:Dock(TOP)
  m_buttonC:SetSize(0, 80)
  m_buttonC:DockMargin(0, 0, 0, 5)
  m_buttonC.DoClick = function(s)   
    local max = CaseFrame.Cases >= CaseFrame.Keys and CaseFrame.Keys or CaseFrame.Cases
    if max > 50 then
      max = 50
    end
	AllowFastAll = false
    -- print(data.crate.id)
    netstream.Start('CrateSpinAll', {
      id = data.crate.id,
      max = max
    }) 
    -- CrateWS:emit('crateSpin', {
    --   id = tostring(data.crate.id),
    --   server_id = CrateInfo.ServerID 
    -- })
  end 
  m_buttonC.Think = function(s)
    local max = CaseFrame.Cases >= CaseFrame.Keys and CaseFrame.Keys or CaseFrame.Cases
    if max > 50 then
      max = 50
    end
    s.Text = "FAST ALL (" .. max ..")"
	if not AllowFastAll then
      s:SetDisabled(true)
      return 
	end
    if isSpinning then
      s:SetDisabled(true)
      return 
    end
    if CaseFrame.Cases == 0 || CaseFrame.Keys == 0 then
      s:SetDisabled(true)
      return
    end
    s:SetDisabled(false)
  end
 
  -- CrateInfo.List = data
end)


local Speed = 100*50
local EndPoint = 0 
local RandomStop = 0 
local Dropped 
-- CrateWS:off('crateSpin')  
-- CrateWS:on('updateData', function(data)
--   PrintTable(data)
--   keys = data.data.keys
--   cases = data.data.cases
  
--   for i,v in pairs(CrateInfo.List) do
--     if v.id == id then
--       CrateInfo.List[i].data = data.data   
--     end
--   end
-- end)
netstream.Hook('CrateSpin', function(data)
  if IsValid(CaseFrame) then
    CaseFrame.McTime = data.mctime
    CaseFrame.Keys = data.data.keys
    CaseFrame.Cases = data.data.cases
    -- local ITEM = PS.Items[randomItems[i].psid]
    
	local itemsLocal = {}
	for i,v in pairs(data.items_names) do
		itemsLocal[tostring(i)] = v
	end
	PrintTable(data)
	
    Dropped = data.select
    for k ,v in pairs(items) do
      v.panel:Remove()
    end 
    items = {} 
    Speed = #data.items * 40 
    local ii = 1
    for i,v in pairs(data.items) do
      if (ii == 10) then
        local r =  math.random(-9, 35)
        EndPoint = ii * 50 - SpinPanel:GetTall() / 2
        EndPoint = EndPoint + r
        RandomStop = 10
        -- RandomStop = 10+49
        items[ii] = {}
        items[ii].xPos = (50) * ii

        items[ii].panel = vgui.Create("DPanel" , SpinPanel)
        items[ii].panel.id = ii
        -- items[i].panel.item = randomItems[i]
        items[ii].panel:SetPos(0, (50 * i) )
        items[ii].panel:SetSize(SpinPanel:GetWide() , 50)
        items[ii].panel.Paint = function(self , w , h)
          -- local name = ITEM and ITEM.Name or randomItems[i].psid.." "..PS.Config.PointsName
          
          h = h - 1 
        draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50)) 
          -- if !ITEM then
            -- draw.RoundedBox( 0, 0, 19, w, h-19, self.item.c`olor) 
          -- end
          -- draw.RoundedBox( 0, 0, 0, w, 19, Color(50,50,50)) 
          
          draw.SimpleText(data.select.name, "S_Light_15", 5, 7, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText('Поле для состояния', "S_Light_15", 5, h-7-15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        ii = ii + 1
      end

      local item = itemsLocal[v]

      items[ii] = {}
      items[ii].xPos = (50) * ii

      items[ii].panel = vgui.Create("DPanel" , SpinPanel)
      items[ii].panel.id = ii
      -- items[i].panel.item = randomItems[i]
      items[ii].panel:SetPos(0, (50 * i) )
      -- items[ii].panel.Name = 
      items[ii].panel:SetSize(SpinPanel:GetWide() , 50)
      items[ii].panel.Paint = function(self , w , h)
        -- local name = ITEM and ITEM.Name or randomItems[i].psid.." "..PS.Config.PointsName
        
        h = h - 1 
        -- draw.RoundedBox(0,0,0,w,h, Color(200,200,200))
        -- if !ITEM then
          -- draw.RoundedBox( 0, 0, 19, w, h-19, self.item.color) 
        -- end
        draw.RoundedBox( 0, 0, 0, w, h, Color(50,50,50)) 
        
        draw.SimpleText(item, "S_Light_15", 5, 7, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        draw.SimpleText('Поле для состояния', "S_Light_15", 5, h-7-15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
      end
      ii = ii + 1
    end
    isSpinning = true 
  end
  -- PrintTable(data)
  -- print(os.time(), '------')
end) 
netstream.Hook('CrateSpinAll', function(data)
  PrintTable(data)
  if IsValid(CrateOpenAll) then
    CrateOpenAll:Remove()
  end
	AllowFastAll = true
  CrateOpenAll = vgui.Create('.CCFrame')
  CrateOpenAll:SetSize(300, 400)
  CrateOpenAll:SetTitle('Результат')
  CrateOpenAll:Center()
  CrateOpenAll:MakePopup()

  local _list = vgui.Create('DScrollPanel', CrateOpenAll)
  _list:Dock(FILL)
  _list.Paint = function( s, w, h ) end
  local grouped = {}
  
  
  for i,v in pairs(data.dropped) do
    CaseFrameHistoryPanel:AddItemList(v.name, v.time)
	grouped[v.name] = grouped[v.name] or 0
	grouped[v.name] = grouped[v.name] + 1
   
  end
  
  for i,v in pairs(grouped) do
   local _bb = vgui.Create('DPanel', _list)
	_bb:SetSize(0, 40)
	_bb:Dock(TOP)
	_bb.Text = i
	_bb.Paint = function ( s, w, h )
	  draw.SimpleText(s.Text .. ' - x' .. v , "S_Light_20", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	_list:AddItem(_bb)
  end
  
  if IsValid(CaseFrame) then
    CaseFrame.McTime = data.mctime
    CaseFrame.Keys = data.data.keys
    CaseFrame.Cases = data.data.cases
  end
end)

local prevItemValue = 0 
-- local WideLerp = CaseHiddenPanel.Wide
function SpinItems()
  Speed = Lerp(0.8*FrameTime() , Speed , EndPoint )
  CaseHiddenPanel.Wide = Lerp(1.2*FrameTime() , CaseHiddenPanel.Wide , 0 ) 
  -- print(Speed, EndPoint)
  if math.floor((Speed-20+354)/ 160) ~= prevItemValue then
    -- LocalPlayer():EmitSound("unboxing/next_item.wav")
  end
  
  for k ,v in pairs(items) do
    v.panel:SetPos(0 , v.xPos - Speed)
  end
  
  if Speed < EndPoint + RandomStop then	
    isSpinning = false
    
    PrintTable(Dropped)
    CaseFrameHistoryPanel:AddItemList(Dropped.name, Dropped.time)
    -- net.Start("FinishedUnbox")
      -- net.WriteInt(math.floor((EndPoint+354)/160) , 16)
    -- net.SendToServer()

    -- surface.PlaySound("buttons/lever6.wav")

    IsUnboxingItems = false
    IsUnboxingItemsTime = CurTime()
  end
  
  prevItemValue = math.floor((Speed-20+354)/ 160)
end

function spinUpdate()
  if IsValid(CaseFrame) then
    if isSpinning then
      SpinItems()
    end 
  end 
end

hook.Add("Think" , "Spin The Items" , spinUpdate)








	-- CrateWS:on('err', function(data)
		-- PrintTable(data)
		-- CrateInfo.List = data
	-- end)
	-- if IsValid(ListMenuKeys) then
		-- ListMenuKeys:SetVisible(false)
	-- end
	
	-- CaseFrame = vgui.Create( "DFrame" )
	-- CaseFrame:SetSize( 1280, 720)
	-- CaseFrame:Center()
	-- CaseFrame:SetTitle( "Кейсы" )  
	-- CaseFrame:MakePopup()
	-- CaseFrame:SetDeleteOnClose(true)
-- end