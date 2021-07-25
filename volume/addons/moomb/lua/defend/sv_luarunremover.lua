hook.Add( "AcceptInput", "BlockLuaRun", function( ent, name, activator, caller, data )
	if ( ent:GetClass() == "lua_run" ) then
		return true
	end
end )
