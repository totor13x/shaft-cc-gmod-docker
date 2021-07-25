--[[ Copyright (C) Edgaras Fiodorovas - All Rights Reserved
   - Unauthorized copying of this file, via any medium is strictly prohibited
   - Proprietary and confidential
   - Written by Edgaras Fiodorovas <edgarasf123@gmail.com>, November 2017
   -]]
   
--------------------------------------------------------------------------------

MsgN( "[MapPatcher] Version 2.4.0" )
MsgN( "[MapPatcher] Written by H3xCat (STEAM_0:0:20178582)")
MsgN( "[MapPatcher] Purchased by 76561197960381939" )
MsgN( "[MapPatcher] Purchase Verification: 1676186c88e8250f075a74642de4827894ce49df518b76c600e0057d3637309b" )

if SERVER then
    AddCSLuaFile( "skins/mappatcher.lua" )

    AddCSLuaFile( "mappatcher/libraries/luabsp.lua" )
    AddCSLuaFile( "mappatcher/libraries/quickhull.lua" )
    AddCSLuaFile( "mappatcher/libraries/bufferinterface.lua" )
    AddCSLuaFile( "mappatcher/libraries/stream.lua" )

    AddCSLuaFile( "mappatcher/editor/screen.lua" )
    AddCSLuaFile( "mappatcher/editor/menu.lua" )
    
    AddCSLuaFile( "mappatcher/config.lua" )
    AddCSLuaFile( "mappatcher/shared.lua" )
    AddCSLuaFile( "mappatcher/cl_init.lua" )
    AddCSLuaFile( "mappatcher/cl_editor.lua" )
    
    include( "mappatcher/shared.lua" )
    include( "mappatcher/datafile.lua" )
    include( "mappatcher/init.lua" )
elseif CLIENT then
    timer.Simple( 0, function() include( "skins/mappatcher.lua" ) end )

    include( "mappatcher/editor/screen.lua" )
    include( "mappatcher/editor/menu.lua" )

    include( "mappatcher/shared.lua" )
    include( "mappatcher/cl_init.lua" )
    include( "mappatcher/cl_editor.lua" )
end