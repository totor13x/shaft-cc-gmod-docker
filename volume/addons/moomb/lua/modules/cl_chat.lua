local size_w, size_h = 400, 200
local max_size_w, max_size_h = 200, 100
local title = "Глобальный чат"

local XChatX = CreateClientConVar("chatpos_x", -1, true, false)
local XChatY = CreateClientConVar("chatpos_y", -1, true, false)

local XChatWidth = CreateClientConVar("chatsize_w", -1, true, false)
local XChatHeight = CreateClientConVar("chatsize_h", -1, true, false)

qpC = qpC or {
  List = {},
  Panel = 255,
  Visible = false,
}

-- qpCWS = qpCWS or false  
	-- timer.Simple(1, function()      
-- print( WSBUS:getSubscription('client/roulette'), '--')   

hook.Add("TTS.InitialWS", "WS:Chat/qpC", function(data) 
  qpC.buildBox()
  
  netstream.Start('Chat:Load')
  -- qpCWS = WSBUS:subscribe('chat')  
  
	-- qpCWS:on('load', function(data)
  --   for i, v in SortedPairs( data, true ) do
  --     qpC:AddText(v)
  --   end
  -- end)
  
	-- qpCWS:on('message', function(data)
  --   qpC:AddText(data)
  --   qpC.Panel = 255
  -- end)


	-- qpCWS:emit('crateList', data.server) 
end)  

netstream.Hook('Chat:Load', function(data)
  for i, v in SortedPairs( data, true ) do
    qpC:AddText(v)
  end
end)
netstream.Hook('Chat:Message', function(data)
  qpC:AddText(data)
  qpC.Panel = 255
end)

hook.Remove("CreateMove", "Chat/qpCWS")
hook.Add("CreateMove",'Chat/qpCWS', function()		
  if input.WasKeyPressed(KEY_P) and not (vgui.GetKeyboardFocus() or gui.IsGameUIVisible()) then
    if IsValid( qpC.frame ) then
      qpC.showBox()
    else
      qpC.buildBox()
      qpC.showBox()
    end
  end
end)

function qpC.buildBox()
	if IsValid(qpC.frame) then
		qpC.frame:Remove()
  end
  
  local x = ScrW() - size_w - 10
  local y = ScrH() / 2 - size_h / 2

  if XChatX:GetInt() == -1 then
    XChatX:SetInt( x )
  end

  if XChatY:GetInt() == -1 then
    XChatY:SetInt( y )
  end

  x = XChatX:GetInt()
  y = XChatY:GetInt()

  if XChatWidth:GetInt() == -1 then
    XChatWidth:SetInt( size_w )
  end
  if XChatHeight:GetInt() == -1 then
    XChatHeight:SetInt( size_h )
  end
  -- if then
  --   RunConsoleCommand(self.convarname, self:GetValue())
  -- end
  -- local ss = ScreenScale( x )
  -- local ssw = ScreenScale( ScrW() )
  -- print(ss, x)
  -- print( ssw / ss )
	qpC.frame = vgui.Create(".CCFrame")
	qpC.frame:SetSize( XChatWidth:GetInt(), XChatHeight:GetInt() )
	qpC.frame:SetTitle(title)
	-- qpC.frame:ShowCloseButton( false )       
	qpC.frame.btnMinim:SetVisible( false ) 
	qpC.frame.btnMaxim:SetVisible( false )     
  qpC.frame.btnClose.DoClick = function ( button ) 
    qpC.hideBox()
  end 
	qpC.frame:SetDraggable( true )
  qpC.frame:MakePopup()
  qpC.frame:SetSizable( true )
  qpC.frame:SetScreenLock( true )
  qpC.frame:SetMinWidth( max_size_w )
  qpC.frame:SetMinHeight( max_size_h )
	-- qpC.frame:DockPadding( 5,5,5,5 )
  qpC.frame:SetPos( XChatX:GetInt(), XChatY:GetInt() )
  
  _oldThink = qpC.frame.Think
  _oldPaint = qpC.frame.Paint
  qpC.frame.Paint = function(s, w, h)
    if qpC.Visible then
      _oldPaint(s, w, h)
    end
  end

  qpC.frame.Think = function(s)
    local sizew, sizeh = s:GetSize()
    local posx, posy = s:GetPos()

    if sizew ~= size_w then
      XChatWidth:SetInt( sizew )
    end
    if sizeh ~= size_h then
      XChatHeight:SetInt( sizeh )
    end
    if posx ~= x then
      XChatX:SetInt( posx )
    end
    if posy ~= y then
      XChatY:SetInt( posy )
    end

    if qpC.Visible then
      s._b:SetVisible(true)
      s.btnClose:SetVisible( true )     
      _oldThink(s)
      s:SetTitle(title)
      qpC.Panel = 255+1
    else
      s._b:SetVisible(false)
      s.btnClose:SetVisible( false )     
      s:SetTitle('')
      qpC.Panel = qpC.Panel - 1

      if qpC.Panel < 1 then
        qpC.Panel = 0
      end
    end

    if IsValid(s.chatLog) then
      s.chatLog:SetAlpha(qpC.Panel)
    end
  end
  -- qpC.frame.Paint = function( self, w, h )
	-- 	-- draw.RoundedBox( 0, 0, 0, w, h, Color( 130, 30, 30, 100 ) )
  -- end
  
  local chatBlock = vgui.Create("RichText", qpC.frame) 
  chatBlock:Dock( FILL )
	chatBlock.Paint = function( self, w, h )
		-- draw.RoundedBox( 0, 0, 0, w, h, Color( 130, 30, 30, 100 ) )
  end
	function chatBlock:PerformLayout()
		self:SetFontInternal("S_Light_15")
		self:SetFGColor( color_white )
	end
  qpC.frame.chatLog = chatBlock

  local _b = vgui.Create("DPanel", qpC.frame) 
  _b:Dock( BOTTOM )
  _b:SetSize(0, 25)
  _b:DockMargin(0, 5, 0, 0)
  _b.Paint = function() end
  qpC.frame._b = _b
  
  local text = vgui.Create(".CCTextEntry", _b)
  text:DockMargin(0, 0, 5, 0)
  text:Dock(FILL)
  text:SetPlaceholderText('Отправить текст')
  text.Font = "S_Light_15"
  text.XPos = 10
  text.TextAlignX = TEXT_ALIGN_LEFT
  text.TextAlignY = TEXT_ALIGN_CENTER
	text.OnKeyCodeTyped = function( self, code )
		if code == KEY_ENTER then
      if string.Trim( self:GetText() ) != "" then
        netstream.Start('Chat:Message', self:GetText())
        -- qpCWS:emit('message', self:GetText())

        self:SetText('')
      end
      
			-- qpC.hideBox()
		elseif code == KEY_ESCAPE then
			qpC.hideBox()
		end
  end
  qpC.frame.input = text

  local m_button = vgui.Create(".CCButton", _b)
  m_button.Font = "S_Light_15"
  m_button:Dock(RIGHT)
  m_button.FakeActivated = true
  m_button:DockMargin(0,0,0,0)
  m_button.Text = 'Отправить'
  m_button.DoClick = function(s)
    netstream.Start('Chat:Message', text:GetText())
    -- qpCWS:emit('message', text:GetText())

    text:SetText('')
  end

  qpC.hideBox()
end

function qpC.showBox()
  qpC.Visible = true
  
  qpC.frame:MakePopup( true )
	qpC.frame.chatLog:SetVerticalScrollbarEnabled( true )
  qpC.frame.input:RequestFocus()
  gui.EnableScreenClicker( true )
end
function qpC.hideBox()
  qpC.Visible = false
  qpC.Panel = 0
	qpC.frame:SetMouseInputEnabled( false )
	qpC.frame:SetKeyboardInputEnabled( false )
  qpC.frame.chatLog:SetVerticalScrollbarEnabled( false )
  
	gui.EnableScreenClicker( false )
  gui.HideGameUI()
end

function qpC:AddText(data)
	-- if not qpC.chatLog then
	-- 	qpC.buildBox()
	-- end
	-- PrintTable(data)
	local msg = {}
	qpC.frame.chatLog:AppendText("\n")
	-- qpC.frame.chatLog:AppendText('[')
	-- qpC.frame.chatLog:InsertColorChange(r, g, b, 255 )
	-- qpC.frame.chatLog:AppendText(sid)
	-- qpC.frame.chatLog:InsertColorChange( 255, 255, 255, 255 )
	-- qpC.frame.chatLog:AppendText(']')  
  -- print(data.tag_id)
  -- PrintTable(TTS.Tags.Cache[id])
  if data.tag_id then
    local tag = TTS.Tags:GetTag(data.tag_id) 

    -- print(#tag)
    -- PrintTable(tag)
	if tag then
		if #tag > 0 then
		  for i, dat in pairs(tag) do
			-- print(dat.color)
			qpC.frame.chatLog:InsertColorChange(dat.color.r, dat.color.g, dat.color.b, 255) 
			qpC.frame.chatLog:AppendText(dat.text) 
		  end
		  qpC.frame.chatLog:AppendText(' ') 
		end
    end
  end
	qpC.frame.chatLog:InsertColorChange( 255, 255, 255, 255 )
	-- if tag and TTS.Tags and TTS.Tags[tag] then
	-- 	local tag = TTS.Tags[tag]
	-- 	for i,v in pairs(tag['gmod']) do
	-- 		qpC.chatLog:InsertColorChange( v[1]['r'],v[1]['g'],v[1]['b'], 255 )
	-- 		qpC.chatLog:AppendText(v[2])
	-- 	end
	-- end 
	-- qpC.frame.chatLog:InsertColorChange( 255, 255, 255, 255 )
	qpC.frame.chatLog:AppendText(data.user.username) 
	qpC.frame.chatLog:AppendText(': ') 
	
	-- qpC.frame.chatLog:InsertColorChange( 255, 255, 255, 255 )
	qpC.frame.chatLog:AppendText(data.message) 
	
	qpC.frame.chatLog:SetVisible( true )
	-- qpC.lastMessage = os.time()
end