util.AddNetworkString("ChatPrintTotor")

local meta = {}
meta.__index = meta

function meta:Add(string, color)
	local t = {}
	t.text = string
	t.color = color or self.default_color or color_white
	table.insert(self.msgs, t)
	return self
end

function meta:NetConstructMsg()
	net.Start("ChatPrintTotor")
	for k, msg in pairs(self.msgs) do
		net.WriteUInt(1,8)
		net.WriteString(msg.text)
		if !msg.color then
			msg.color = self.default_color or color_white
		end
		net.WriteVector(Vector(msg.color.r, msg.color.g, msg.color.b))
	end
	net.WriteUInt(0,8)
	return self
end
function meta:Broadcast()
	self:NetConstructMsg()
	net.Broadcast()
	return self
end

function meta:Send(players)
	self:NetConstructMsg()
	if players == nil then
		net.Broadcast()
	else
		net.Send(players)
	end
	return self
end

function ChatMsg(msgs)
	local t = {}
	t.msgs = msgs or {}
	setmetatable(t, meta)
	return t
end 
