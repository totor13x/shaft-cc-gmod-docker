_G.NOTIFY_GENERIC = 0
_G.NOTIFY_ERROR = 1
_G.NOTIFY_UNDO = 2
_G.NOTIFY_HINT = 3
_G.NOTIFY_CLEANUP = 4
net.pool('DLib.Notify.PrintMessage')
PrintMessage = function(mode, message)
  if message:sub(#message) == '\n' then
    message = message:sub(1, #message - 1)
  end
  net.Start('DLib.Notify.PrintMessage')
  net.WriteUInt(mode, 4)
  net.WriteString(message)
  return net.Broadcast()
end
local plyMeta = FindMetaTable('Player')
plyMeta.PrintMessage = function(self, mode, message)
  if message:sub(#message) == '\n' then
    message = message:sub(1, #message - 1)
  end
  net.Start('DLib.Notify.PrintMessage')
  net.WriteUInt(mode, 4)
  net.WriteString(message)
  return net.Send(self)
end
