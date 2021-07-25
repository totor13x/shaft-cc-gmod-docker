Notify.DefaultDispatchers = { }
Notify_SIDE_LEFT = 1
Notify_SIDE_RIGHT = 2
Notify_POS_TOP = 3
Notify_POS_BOTTOM = 4
Notify.newLines = function(str)
  if str == nil then
    str = ''
  end
  return string.Explode('\n', str)
end
Notify.allowedOrigin = function(enum)
  return enum == TEXT_ALIGN_LEFT or enum == TEXT_ALIGN_RIGHT or enum == TEXT_ALIGN_CENTER
end
Notify.Clear = function()
  for i, obj in pairs(Notify.DefaultDispatchers) do
    obj:Clear()
  end
end
Notify.CreateSlide = function(...)
  if not Notify.DefaultDispatchers or not IsValid(Notify.DefaultDispatchers.slide) then
    Notify.CreateDefaultDispatchers()
  end
  return Notify.DefaultDispatchers.slide:Create(...)
end
Notify.CreateCentered = function(...)
  if not Notify.DefaultDispatchers or not IsValid(Notify.DefaultDispatchers.center) then
    Notify.CreateDefaultDispatchers()
  end
  return Notify.DefaultDispatchers.center:Create(...)
end
Notify.CreateBadge = function(...)
  if not Notify.DefaultDispatchers or not IsValid(Notify.DefaultDispatchers.badges) then
    Notify.CreateDefaultDispatchers()
  end
  return Notify.DefaultDispatchers.badges:Create(...)
end
Notify.CreateLegacy = function(...)
  if not Notify.DefaultDispatchers or not IsValid(Notify.DefaultDispatchers.legacy) then
    Notify.CreateDefaultDispatchers()
  end
  return Notify.DefaultDispatchers.legacy:Create(...)
end
local flipPos
flipPos = function(input)
  local x, y = input()
  return y
end
Notify.CreateDefaultDispatchers = function()
  Notify.DefaultDispatchers = { }
  local SLIDE_POS = DLib.HUDCommons.DefinePosition('notify_main', 0, 30)
  local CENTER_POS = DLib.HUDCommons.DefinePosition('notify_center', 0, 0)
  local BADGE_POS = DLib.HUDCommons.DefinePosition('notify_badge', 0, 0.2)
  local LEGACY_POS = DLib.HUDCommons.DefinePosition('notify_legacy', 50, 0.55)
  local slideData = {
    x = SLIDE_POS(),
    getx = SLIDE_POS,
    y = flipPos(SLIDE_POS),
    gety = function(self)
      return flipPos(SLIDE_POS)
    end,
    width = ScrWL(),
    height = ScrHL(),
    getheight = ScrHL,
    getwidth = ScrWL
  }
  local centerData = {
    x = CENTER_POS(),
    getx = CENTER_POS,
    y = flipPos(CENTER_POS),
    gety = function(self)
      return flipPos(CENTER_POS)
    end,
    width = ScrWL(),
    height = ScrHL(),
    getheight = ScrHL,
    getwidth = ScrWL
  }
  local badgeData = {
    x = BADGE_POS(),
    getx = BADGE_POS,
    y = flipPos(BADGE_POS),
    gety = function(self)
      return flipPos(BADGE_POS)
    end,
    width = ScrWL(),
    height = ScrHL(),
    getheight = function(self)
      return ScrHL() * 0.6
    end,
    getwidth = ScrWL
  }
  local legacyData = {
    x = LEGACY_POS(),
    getx = LEGACY_POS,
    y = flipPos(LEGACY_POS),
    gety = function(self)
      return flipPos(LEGACY_POS)
    end,
    width = ScrWL() - 50,
    getwidth = function(self)
      return ScrWL() - 50
    end,
    height = ScrHL() * 0.45,
    getheight = function(self)
      return ScrHL() * 0.45
    end
  }
  Notify.DefaultDispatchers.slide = Notify.SlideNotifyDispatcher(slideData)
  Notify.DefaultDispatchers.center = Notify.CentereNotifyDispatcher(centerData)
  Notify.DefaultDispatchers.badges = Notify.BadgeNotifyDispatcher(badgeData)
  Notify.DefaultDispatchers.legacy = Notify.LegacyNotifyDispatcher(legacyData)
end
local HUDPaint
HUDPaint = function()
  if not Notify.DefaultDispatchers then
    return 
  end
  for i, dsp in pairs(Notify.DefaultDispatchers) do
    dsp:Draw()
  end
end
local Think
Think = function()
  if not Notify.DefaultDispatchers then
    return 
  end
  for i, dsp in pairs(Notify.DefaultDispatchers) do
    dsp:Think()
  end
end
local NetHook
NetHook = function()
  local mode = net.ReadUInt(4)
  local mes = net.ReadString()
  if mode == HUD_PRINTCENTER then
    local notif = Notify.CreateCentered({
      color_white,
      mes
    })
    return notif:Start()
  elseif mode == HUD_PRINTTALK then
    print(mes)
    return chat.AddText(mes)
  elseif mode == HUD_PRINTCONSOLE or mode == HUD_PRINTNOTIFY then
    return print(mes)
  end
end
local legacyColors = {
  [NOTIFY_GENERIC] = color_white,
  [NOTIFY_ERROR] = Color(200, 120, 120),
  [NOTIFY_UNDO] = Color(108, 166, 247),
  [NOTIFY_HINT] = Color(147, 247, 108),
  [NOTIFY_CLEANUP] = Color(108, 219, 247)
}
if false then
  notification.AddLegacy = function(text, type, time)
    time = math.Clamp(time or 4, 4, 60)
    type = type or NOTIFY_GENERIC
    local notif = Notify.CreateLegacy({
      legacyColors[type],
      text
    })
    notif:SetLength(time)
    notif:SetNotifyInConsole(false)
    return notif:Start()
  end
end
hook.Add('HUDPaint', 'DLib.Notify', HUDPaint)
net.Receive('DLib.Notify.PrintMessage', NetHook)
hook.Add('Think', 'DLib.Notify', Think)
local include_ = include
local include
include = function(fil)
  return include_('dlib/modules/notify/client/' .. fil)
end
include('font_obj.lua')
include('base_class.lua')
include('templates.lua')
include('animated_base.lua')
include('slide_class.lua')
include('centered_class.lua')
include('badges.lua')
include('legacy.lua')
timer.Simple(0, Notify.CreateDefaultDispatchers)
return Notify
