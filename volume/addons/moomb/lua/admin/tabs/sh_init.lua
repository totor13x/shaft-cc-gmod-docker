TTS.Admin.tabs = {
	tab = {}
}
 
local TAB = {}

TAB.__index = TAB

function TTS.Admin.tabs.Register( mod )
	local out = setmetatable(mod, TAB)
	
	TTS.Admin.tabs.Delete( mod.ID )
	TTS.Admin.tabs.tab[mod.ID] = out
	-- PrintTable(mod)  
	hook.Run('TTS.Admin::RegisterTab', mod)
end

function TTS.Admin.tabs.Delete( id ) 
	TTS.Admin.tabs.tab[id] = nil
end

function TTS.Admin.tabs.GetList() 
	return TTS.Admin.tabs.tab 
end

function TTS.Admin.tabs.Get( id ) 
	return TTS.Admin.tabs.tab[id]
end

function TAB:GetID()
	return self.ID
end
function TAB:GetName()
	return self.Name
end
function TAB:TopButton( pnl )
	if pnl then 
		pnl:SetVisible( false )
		pnl:InvalidateParent()
		if IsValid( pnl.m_button ) then 
			pnl.m_button:Remove()
		end
		if self.TopFillButton then
			pnl:SetVisible(true)
			self:TopFillButton( pnl )
		end
	end
	//return self.TopButton and self.TopButton( pnl ) or false
end

function TAB:SidebarButton( pnl, category_id ) 
	if pnl then 
		for i, v in pairs(pnl:GetChildren()) do
			v:Remove()
		end
		if self.CategoryItemsFill then
			self:CategoryItemsFill( pnl, category_id )
		end
	end
end
function TAB:SidebarAddButton( pnl, category_id ) 
	if pnl then 
		for i, v in pairs(pnl:GetChildren()) do
			v:Remove()
		end
		if self.SidebarAddButton then
			self:SidebarAddButton( pnl, category_id )
		end
	end
end
function TAB:SidebarClearButton( pnl, category_id ) 
	if pnl then
		if self.SidebarRemoveButton then
			self:SidebarRemoveButton( pnl, category_id )
		else 
			pnl:Remove()
		end
		
	end
end
function TAB:CreateFrame( ) 
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
	
	return m_pnlAdminFrame
	-- if pnl then
		-- if self.SidebarRemoveButton then
			-- self:SidebarRemoveButton( pnl, category_id )
		-- else 
			-- pnl:Remove()
		-- end
		
	-- end
end

TAB_COMMANDS = 1
TAB_MAPS = 2
-- print(TAB_MAPS, 'TAB_MAPS')
-- MOD_TTSHOP = 2 
-- MOD_INV = 3

TTS.LoadSH('commands/sh_init.lua')  

TTS.LoadSH('maps/sh_init.lua')  
TTS.LoadSV('maps/sv_init.lua')

-- TTS.LoadSH('pointshop_shop/sh_init.lua')   
-- TTS.LoadSH('ttshop/sh_init.lua') 
