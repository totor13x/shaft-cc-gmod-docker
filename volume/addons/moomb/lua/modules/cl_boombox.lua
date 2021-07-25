Boomboxes = {}

LastPlayed = {}

netstream.Hook('TTS:Boombox.Play', function(data)
  local url, ply = data.url, data.ply
print(url, ply)
  sound.PlayURL ( url, "3d", function( station )
    if ( IsValid( station ) ) then
      if IsValid(Boomboxes[ply]) then
        Boomboxes[ply]:Stop()
      end

	  station:SetPos( ply:GetPos() )
      station:Set3DFadeDistance( 200, 750 )
      station:Play()

      Boomboxes[ply] = station
    end
  end)
end)

DrawlerBoombox = {
  forward = 180,
  right = 0,
  up = -90,

  pos_forward = -5,
  pos_right = 7,
  pos_up = 0,
}

netstream.Hook('TTS:Boombox.Pause', function(ply)
  if IsValid(Boomboxes[ply]) then
    Boomboxes[ply]:Pause()
  end
end)

netstream.Hook('TTS:Boombox.Resume', function(ply)
  if IsValid(Boomboxes[ply]) then
    Boomboxes[ply]:Play()
  end
end)


hook.Add("Think", "TTS:Boombox.Think", function()
  for ply, station in pairs(Boomboxes) do
    if IsValid(ply) and IsValid(station) then
      if !ply:Alive() then
        station:Pause()
        continue
      end

	  local eyepos = ply:EyePos()
	  local EyePosLocal = LocalPlayer() == ply and eyepos or LocalPlayer():EyePos()
      local pos = station:GetPos()
		  local in3D = LocalPlayer() == ply and ply:ShouldDrawLocalPlayer() or true
--[[
      if ply == LocalPlayer() then
        if in3D then
          if !station:Get3DEnabled() then
            station:Set3DEnabled( true )
          end
        else
          if station:Get3DEnabled() then
            station:Set3DEnabled( false )
          end
        end
      end
]]
      if in3D then
        if !station:Get3DEnabled() then
          station:Set3DEnabled( true )
        end
        if EyePosLocal:DistToSqr( eyepos ) < 100 then
          station:Set3DEnabled( false )
        end
      else
        if station:Get3DEnabled() then
          station:Set3DEnabled( false )  
        end
      end

      station:SetPos(eyepos)

      if EyePosLocal:DistToSqr( eyepos ) > 750*750 then
        if station:GetVolume() ~= 0 then
          station:SetVolume(0)
        end
      else
        if station:GetVolume() ~= 1 then
          station:SetVolume(1)
        end
        if station:GetVolume() ~= ply:GetNWFloat('TTS::BoomboxVolume') then
          station:SetVolume(ply:GetNWFloat('TTS::BoomboxVolume'))
        end
						
		if GetConVar( "tts_avoid_boombox_play_self_only" ):GetBool() && LocalPlayer():IsPremium() then
			if LocalPlayer() != ply then
				station:SetVolume(0)
			end
		end
      end
    else
      Boomboxes[ply] = nil
      station:Stop()
    end
  end
end)

if IsValid(TrackList) then
  TrackList:Remove()
end

concommand.Add('tts_boombox_run', function()
  if IsValid(TrackList) then
    TrackList:SetVisible(true)
    return
  end
  TrackList = vgui.Create( ".CCFrame" )
  TrackList:SetSize( 300, 400 )
  -- TrackList:SetPos(0,100)
  TrackList:Center()
  TrackList:SetTitle( "Трек-лист" )  
  TrackList:MakePopup()
    
  TrackList.btnClose.DoClick = function ( button ) 
    TrackList:SetVisible(false)
  end 
  -- TrackList:SetDeleteOnClose(true)
  TrackList.SearchText = nil
  TrackList.CurrentPage = 1
  TrackList.Type = 'public'
  TrackList.HTTP = function(url, ajax)
    if IsValid(TrackList) then
      if !ajax then
        if IsValid(TrackList._DScrollPanel) then
          TrackList._DScrollPanel:Remove()
        end
        if IsValid(TrackList._c2) then
          TrackList._c2:SetEnabled( false )
        end
        if IsValid(TrackList._c1) then
          TrackList._c1:SetEnabled( false )
        end
        if IsValid(TrackList._c) then
          TrackList._c:SetEnabled( false )
        end
      end
      
      TTS.HTTP(
        url or '/api/tracks/list', 
        {
          search = TrackList.SearchText,
          page = TrackList.CurrentPage,
          type = TrackList.Type
        },
        function(data)   
          if IsValid(TrackList) then
            if !ajax then
              TrackList.loadItems(data) 
            end
            -- PrintTable(data)   
          end
        end
      )
    end
  end
  local loadItems = function (data)
    if !IsValid(TrackList) then return end

    if IsValid(TrackList._a) then
      TrackList._a:Remove() 
    end 
    if IsValid(TrackList._b) then
      TrackList._b:Remove()
    end 
    if IsValid(TrackList._g) then
      TrackList._g:Remove()
    end


    local _b = vgui.Create('DPanel', TrackList)
    _b:Dock(TOP)
    _b:SetSize(0, 45)
    _b.Paint = function() end
    TrackList._a = _b


    local _hh = vgui.Create('DPanel', _b)
    _hh:Dock(TOP)
    _hh:SetSize(0, 20)
    _hh.Paint = function() end

    local _jj = vgui.Create('DPanel', _b)
    _jj:DockMargin(0, 5, 0, 0)
    _jj:Dock(BOTTOM)
    _jj:SetSize(0, 20)
    _jj.Paint = function() end

    function _hh:OnSizeChanged()
      local m_button = vgui.Create(".CCButton", _hh)
      m_button.Font = "S_Regular_15"   
      m_button:SetSize( _hh:GetWide()/4, 20 )  
      m_button.FakeActivated = TrackList.Type == 'public'
      m_button.Text = 'Общие'
      m_button:SetBorders(false)
      m_button:Dock(LEFT)
      m_button.DoClick = function(s)
        TrackList.Type = 'public'
        TrackList.SearchText = nil
        TrackList.CurrentPage = 1
        TrackList.HTTP()
      end
      local m_button = vgui.Create(".CCButton", _hh)
      m_button.Font = "S_Regular_15"   
      m_button:SetSize( _hh:GetWide()/4, 20 )  
      m_button.FakeActivated = TrackList.Type == 'shared'
      m_button.Text = 'Поделились'
      m_button:SetBorders(false)
      m_button:Dock(FILL)
      m_button.DoClick = function(s)
        TrackList.Type = 'shared'
        TrackList.SearchText = nil
        TrackList.CurrentPage = 1
        TrackList.HTTP()
      end
      local m_button = vgui.Create(".CCButton", _hh)
      m_button.Font = "S_Regular_15"   
      m_button:SetSize( _hh:GetWide()/4, 20 )  
      m_button.FakeActivated = TrackList.Type == 'mytracks'
      m_button.Text = 'Мои'
      m_button:SetBorders(false)
      m_button:Dock(RIGHT)
      m_button.DoClick = function(s)
        TrackList.Type = 'mytracks'
        TrackList.SearchText = nil
        TrackList.CurrentPage = 1
        TrackList.HTTP()
      end
      local m_button = vgui.Create(".CCButton", _hh)
      m_button.Font = "S_Regular_15"   
      m_button:SetSize( _hh:GetWide()/4, 20 )  
      m_button.FakeActivated = TrackList.Type == 'favorite'
      m_button.Text = 'Избранное'
      m_button:SetBorders(false)
      m_button:Dock(RIGHT)
      m_button.DoClick = function(s)
        TrackList.Type = 'favorite'
        TrackList.SearchText = nil
        TrackList.CurrentPage = 1
        TrackList.HTTP()
      end
    end

    function _jj:OnSizeChanged()
      local text = vgui.Create(".CCTextEntry", _jj)
      text:DockMargin(0, 0, 5, 0)
      text:Dock(FILL)
      text:SetPlaceholderText('Название или автор')
      text.Font = "S_Light_15"
      text.XPos = 10
      text:SetText(TrackList.SearchText or '')
      text.TextAlignX = TEXT_ALIGN_LEFT
      text.TextAlignY = TEXT_ALIGN_CENTER

      local m_abutton = vgui.Create(".CCButton", _jj)
      m_abutton.Font = "S_Light_15"
      m_abutton:SetSize(50, 20)
      m_abutton:Dock(RIGHT)
      m_abutton.FakeActivated = true
      m_abutton:DockMargin(0,0,0,0)
      m_abutton.Text = 'Поиск'
      m_abutton.DoClick = function(s)
        TrackList.CurrentPage = 1
        TrackList.SearchText = text:GetText()
        TrackList.HTTP()
      end
    end

    local _b = vgui.Create('DPanel', TrackList)
    _b:Dock(BOTTOM)
    _b:SetSize(0, 20)
    _b.Paint = function() end
    TrackList._b = _b

    local m_button = vgui.Create(".CCButton", _b)
    m_button.Font = "S_Regular_15"   
    m_button:SetSize( 40, 20 )
    m_button:SetEnabled(1 != data.meta.current_page)
    m_button.Text = 'Пред'
    m_button:SetBorders(false)
    m_button:Dock(LEFT)
    m_button.DoClick = function(s)
      TrackList.CurrentPage = TrackList._c:GetValue() - 1
      TrackList.HTTP()
      -- OpenCasesStore(v.id) 
    end
    TrackList._c1 = m_button
    local m_button = vgui.Create(".CCButton", _b)
    m_button.Font = "S_Regular_15"   
    m_button:SetSize( 40, 20 )  
    m_button:SetEnabled(data.meta.last_page != data.meta.current_page)
    m_button.Text = 'След'
    m_button:SetBorders(false)
    m_button:Dock(RIGHT)
    m_button.DoClick = function(s)
      TrackList.CurrentPage = TrackList._c:GetValue() + 1
      TrackList.HTTP()
    end
    TrackList._c2 = m_button

    local _b = vgui.Create('.CCNumSlider', _b)
    _b:Dock(FILL)
    _b:SetSize(0, 20)
    _b:SetDecimals( 0 )
    _b:SetText( 'Страница' )
    _b.Disabled = false
    _b:SetValue( data.meta.current_page ) 
    _b:SetMinMax( 1, data.meta.last_page )
    _c = _b.Slider.OnMouseReleased
    _b.Slider.OnMouseReleased = function(self, mcode)
      --   return 
      -- end
      -- print('released')
      if (data.meta.current_page != _b:GetValue()) then
        if _b.Disabled then 
          return
        end

        TrackList.CurrentPage = _b:GetValue() 
        TrackList.HTTP()
        _b.Disabled = true
        -- print('value changed')
      end
      _c(self, mcode)
    end
    TrackList._c = _b

    local DScrollPanel = vgui.Create( "DScrollPanel", TrackList)
    DScrollPanel:Dock( FILL ) 
    DScrollPanel:DockMargin(0, 5, 0, 5)
    TrackList._DScrollPanel = DScrollPanel

    TrackList._g = DScrollPanel
    -- DScrollPanel:SetFraction( 1 ) 
    -- DScrollPanel:SetDecimals( 0 )
    -- DScrollPanel:SetValue( data.meta.current_page )
    -- DScrollPanel:SetMinMax( data.meta.from, data.meta.last_page )
    -- print(data.meta.from, data.meta.last_page )
    if #data.data == 0 then
      local m_button = vgui.Create(".CCButton", DScrollPanel)
      m_button.Font = "S_Regular_15"    
      m_button:SetSize( 0 , 25 )  
      m_button.Text = 'Cписок пуст'

      m_button:SetBorders(false)
      m_button:Dock(TOP)
      m_button:SetEnabled(false)
      m_button.DoClick = function(s)
        -- OpenCasesStore(v.id) 
      end
      DScrollPanel:AddItem(m_button)
    end

    for i, track in pairs(data.data) do
      
      local m_button = vgui.Create(".CCButton", DScrollPanel)
      m_button.Font = "S_Regular_15"    
      m_button:SetSize( 0 , 25 )  
      m_button.Text = 
        (track.track_author or 'No') 
        .. ' - ' ..
        (track.track_name or 'No')
        .. ' ( ' ..
        track.user.username
        .. ' )'
  
      m_button:SetBorders(false)
      m_button:Dock(TOP)
      m_button.DoClick = function(s)
        netstream.Start('TTS:Boombox.Play', track.id)
        -- OpenCasesStore(v.id) 
      end
      m_button.DoRightClick = function(s)
        local menu = DermaMenu()
        if TrackList.Type != 'favorite' then
          menu:AddOption( "В избранное", function()
            TrackList.HTTP('/api/tracks/' .. track.id .. '/favorite', true) 
          end )
        else
          menu:AddOption( "Из избранного", function()
            TrackList.HTTP('/api/tracks/' .. track.id .. '/favorite', true) 
          end )
        end
        -- menu:AddOption( "Close", function() print( "Close pressed" ) end )
        menu:Open()
      end
      DScrollPanel:AddItem(m_button)
    end
  end
  TrackList.loadItems = loadItems
  TrackList.HTTP()
end)