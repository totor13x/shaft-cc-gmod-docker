TTS.Shop.modules = {
	module = {}
}
 
local MODULE = {}

MODULE.__index = MODULE

function TTS.Shop.modules.Register( mod )
	local out = setmetatable(mod, MODULE)
	
	TTS.Shop.modules.Delete( mod.ID )
	TTS.Shop.modules.module[mod.ID] = out
	
	hook.Run('TTS.Shop::RegisterModule', mod)
end

function TTS.Shop.modules.Delete( id ) 
	TTS.Shop.modules.module[id] = nil
end

function TTS.Shop.modules.GetList() 
	return TTS.Shop.modules.module
end

function TTS.Shop.modules.Get( id ) 
	return TTS.Shop.modules.module[id]
end

function MODULE:GetID()
	return self.ID
end
function MODULE:GetName()
	return self.Name
end
function MODULE:TopButton( pnl )
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

function MODULE:SidebarButton( pnl, category_id ) 
	if pnl then 
		for i, v in pairs(pnl:GetChildren()) do
			v:Remove()
		end
		if self.CategoryItemsFill then
			self:CategoryItemsFill( pnl, category_id )
		end
	end
end
function MODULE:SidebarClearButton( pnl, category_id ) 
	if pnl then
		if self.SidebarRemoveButton then
			self:SidebarRemoveButton( pnl, category_id )
		else 
			pnl:Remove()
		end
		
	end
end

MOD_POINTSHOP = 1
MOD_TTSHOP = 2
MOD_INV = 3

TTS.LoadSH('pointshop_inv/sh_init.lua')  
TTS.LoadSH('pointshop_shop/sh_init.lua')   
TTS.LoadSH('ttshop/sh_init.lua') 
