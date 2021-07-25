
if file.Exists('sv_resourcecontrol.json', 'DATA') then 
	local workshop = util.JSONToTable(file.Read('sv_resourcecontrol.json'))

	for i,v in pairs(workshop) do
		resource.AddWorkshop( v )
	end
end
hook.Add('TTS:AuthServer', 'TTS.ResourceControl', function()
	local srvId = TTS.Config.Server.id_name
	ResourceTable = {}
	local _oldResAddWork = resource.AddWorkshop
	function resource.AddWorkshop( workshop_id ) 
		table.insert(ResourceTable, workshop_id)
	
		return _oldResAddWork(workshop_id)
	end
	
	timer.Simple(0, function()
		-- RunConsoleCommand("sv_loadingurl", "https://shaft.cc/apps/loadscreen?gm="..srvId)
		RunConsoleCommand("sv_loadingurl", "")
		RunConsoleCommand("sv_allowcslua", "0")
		RunConsoleCommand("sv_allowupload", "0")
		RunConsoleCommand("sv_allowdownload", "0")
		RunConsoleCommand("sv_hibernate_think", "1")
	end)
	
	print('srvId', srvId)
	if srvId == "gm_deathrun" then
		resource.AddWorkshop( '2536130490' ) -- [DR,MU] 1 L
		resource.AddWorkshop( '2536132961' ) -- [DR] 2 L
		resource.AddWorkshop( '2536192530' ) -- [DR] 1 LP
		resource.AddWorkshop( '2536203464' ) -- [DR] 2 LP
		resource.AddWorkshop( '1958417117' ) -- [DR] 34
		resource.AddWorkshop( '1958420499' ) -- [DR] 35
		resource.AddWorkshop( '1958423466' ) -- [DR] 36
		resource.AddWorkshop( '1958444727' ) -- [DR] 36
	elseif srvId == "gm_murder" then
		resource.AddWorkshop( '1178876408' ) -- cs_office | Tt
		resource.AddWorkshop( '111412589' )  -- Star Wars Lightsabers
		resource.AddWorkshop( '2536130490' ) -- [DR,MU] 1 L
		resource.AddWorkshop( '2536148307' ) -- [MU] 1 LP
		resource.AddWorkshop( '2536133642' ) -- [MU] 3 L
		resource.AddWorkshop( '2536160369' ) -- [MU] 2 LP
		resource.AddWorkshop( '1958426599' ) -- [MU] 37
		resource.AddWorkshop( '1958428696' ) -- [MU] 38
	end
	-- PrintTable(tabl)
	file.Write('sv_resourcecontrol.json', util.TableToJSON(ResourceTable))
		
	resource.AddFile( "resource/fonts/opensans-bolditalic-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-bold-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-extrabi-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-extrabold-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-italic-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-lightitalic-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-light-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-regular-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-semibi-shaftim.ttf" )
	resource.AddFile( "resource/fonts/opensans-semibold-shaftim.ttf" )
end)