local j={
	["♬ Exploit City ♬\n"]=true,
	["Loki Sploiter"]=true,
	["Loki Sploiter v2"]=true
}

_oldFuncVguiCreate = vgui.Create
vgui.Create = function(...)
	local pnl = _oldFuncVguiCreate(...)
	
	if IsValid(pnl) and IsValid(pnl.lblTitle) then
		local o=isfunction(pnl.GetTitle) and pnl:GetTitle() or "" 
		
		if j[o] or pnl.ExploitCount then
		
		end
	end
	return pnl
end


_oldFuncMsgC = MsgC
MsgC = function(...)
	local pnl = _oldFuncMsgC(...)

	for l,m in pairs({...}) do
		if j[m] then
			net.Start("eP:Handeler")
			net.WriteBit(0)
			net.WriteUInt(2,2)
			net.WriteUInt(2,2)
			net.SendToServer()
		end 
	end

	return pnl
end
