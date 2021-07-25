
if scoreboard and IsValid(scoreboard.Frame) then
	scoreboard.Frame:Remove()
end

scoreboard = {}
CreateClientConVar("scoreboard_rightclick", 0, true, false)

function scoreboard:show()
	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetSize( math.Clamp( 1280, 0, ScrW() ), math.Clamp( 720, 0, ScrH() )) 

	self.Frame:SetPos((ScrW() / 2) - (self.Frame:GetWide() / 2), (ScrH() / 2) - (self.Frame:GetTall() / 2))
	self.Frame:SetTitle( "" )
	self.Frame:SetVisible( true )
	self.Frame:SetDraggable( false )
	self.Frame:ShowCloseButton( false )
	self.Frame.Paint = function( s, w, h )
    DLib.blur.DrawPanel(w, h, s:LocalToScreen(0, 0))
		-- TTS.Blur( self.Frame, 10, 20, 255 )
		draw.RoundedBox( 0, 0, 0, self.Frame:GetWide(), self.Frame:GetTall(), Color( 35, 35, 35,200) )		
		//draw.RoundedBox( 0, 0, 0, self.Frame:GetWide(), 25, Color( 5, 5, 5,255) )
		-- print(TTS.User.server_name)
		draw.SimpleText(TTS.User.server_name, "S_Bold_20", 10, 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)		

	end	
	self.Frame.Think = function()
		if not scoreboard.RightClicked then
			if input.IsMouseDown(MOUSE_RIGHT) or GetConVar("scoreboard_rightclick"):GetBool() then
				scoreboard.RightClicked = true
				gui.EnableScreenClicker( true )
			end
		end
	end	
	self.Sidebar = vgui.Create( "DScrollPanel", self.Frame )
	self.Sidebar:SetSize( 300-5, self.Frame:GetTall()-35 ) 
	self.Sidebar:SetPos((self.Frame:GetWide() - 300), 25+5 )
	self.Sidebar.Paint = function( s, w, h )
		//draw.RoundedBox( 0, 0, 0, self.Sidebar:GetWide(), self.Sidebar:GetTall(), Color( 255, 0, 255, 255) )		
		//draw.RoundedBox( 0, 0, 0, w, h, Color( 5, 5, 5,200) )	
	end
	self.SidebarPosY = 0
	
	self.SidebarDown = vgui.Create( "DScrollPanel", self.Frame )
	self.SidebarDown:SetSize( 300-5, 0 ) 
	self.SidebarDown:SetPos((self.Frame:GetWide() - 300), 25+5 )
	self.SidebarDown.Paint = function( s, w, h ) end
	self.SidebarDownPosY = 0


	local stand = scoreboard:AddPanel({
		vgui = "DScrollPanel",
		parent = self.Frame,
		type = "",
	})
	stand:SetPos(5, 30)
	stand:SetSize(self.Frame:GetWide()-10-300, self.Frame:GetTall()-35)
	stand.Paint = function( s, w, h )
		//draw.RoundedBox( 0, 0, 0, w,h, Color( 0, 0, 255, 255) )	
	end
	self.contentwrap = not ((40*(#player.GetAll())+ 26+26+26)>=(self.Frame:GetTall()-35))
	self.ContentPanel = stand

	hook.Run('TTS::Load', self)
end

function scoreboard:PerformLayout()
	if self.SidebarDownPosY > 0 then
		if self.SidebarDownPosY > 400 then self.SidebarDownPosY = 400 end
		self.SidebarDown:SetSize(self.SidebarDown:GetWide(), self.SidebarDownPosY)
		self.SidebarDown:SetPos((self.Frame:GetWide() - 300), self.Frame:GetTall()-self.SidebarDownPosY-5 )
		self.Sidebar:SetSize(self.Sidebar:GetWide(), self.Frame:GetTall()-35-self.SidebarDown:GetTall() )
	end
end

function scoreboard:hide()
	if IsValid(self.Frame) then
		self.Frame:Remove()
	end
end

function scoreboard:AddPanel(data)
	data.type = data.type or "Sidebar"
	data.borders = data.borders or false
	data.Font = data.Font or "S_Light_20"
	data.Text = data.Text or "Text not set"
	data.FakeActivated = data.FakeActivated or false
	data.vgui = data.vgui or ".CCButton"
	
	data.parent = data.parent or self.Sidebar
	if data.type =="DownSidebar" then
		data.parent = self.SidebarDown
	end
	
	if !IsValid(data.parent) then return end
	data.tall = data.tall or 40
	data.wide = data.wide or data.parent:GetWide()
	data.PaddingY = 0
	
	if data.type == "Sidebar" then
		data.PaddingY = self.SidebarPosY
	elseif data.type == "DownSidebar" then
		data.PaddingY = self.SidebarDownPosY
	end
	local buttonchange = vgui.Create( data.vgui, data.parent )
	buttonchange:SetPos( 0, 0+data.PaddingY )
	buttonchange:SetSize(data.wide,data.tall)
	if buttonchange.SetBorders then
		buttonchange:SetBorders(data.borders)
	end
	if IsValid(data.ply) and data.type == "ply" then
		buttonchange.Player = data.ply
		local a_ = buttonchange.Think
		buttonchange.Think = function(s)
			if !IsValid(s.Player) then s:Remove() end
			a_(s)
		end
	-- end
		buttonchange.DoRightClick = function(s)
	-- 		local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(s.Player))
	-- 		local commands = serverguard.command:GetTable()
			
			local menu = DermaMenu();
				menu:SetSkin("serverguard");

				menu:AddOption("Скопировать Steam ID", function()
					if (IsValid(s) and IsValid(s.Player)) then
						SetClipboardText(s.Player:SteamID());
					end
				end):SetIcon("icon16/page_copy.png");
				menu:AddOption("Открыть профиль Steam", function()
					if (IsValid(s) and IsValid(s.Player)) then
						-- SetClipboardText(s.Player:SteamID());
						s.Player:ShowProfile()
					end
				end):SetIcon("icon16/user.png");
				local hasSpacer = false
				local parentmenu
				for i,data in SortedPairsByMemberValue(TTS.Admin.commands.GetCommands(), 'ID' ) do
					local command = data.ID
					
					local can = true
					-- PrintTable(data)
					for i,v in pairs(data.m_Permissions) do
						if not hasPerm(i) then
							can = false
							break
						end
					end 
				
					if not can then
						continue
					end
					
					if not table.HasValue(data.m_RequiredAttrs, "player") and not table.HasValue(data.m_RequiredAttrs, "players") then
						continue
					end
					if not hasSpacer then
						menu:AddSpacer()
						parentmenu = menu:AddSubMenu('Админ-команды')
						hasSpacer = true
					end
					parentmenu:AddOption('!' .. command, function()
						if (IsValid(s) and IsValid(s.Player)) then
							-- SetClipboardText(s.Player:SteamID());
							TTS.Admin.GlobalPanel(nil, command, data, s.Player)
						end
					end);
					
				end
			menu:Open();
		end
	end
	buttonchange.Font = data.Font
	buttonchange.Text = data.Text
	buttonchange.FakeActivated = data.FakeActivated
		
	if data.type == "Sidebar" then
		self.SidebarPosY = self.SidebarPosY + buttonchange:GetTall()
	end

	if data.type == "DownSidebar" then
		self.SidebarDownPosY = self.SidebarDownPosY + buttonchange:GetTall()
		scoreboard:PerformLayout()
	end
	
	return buttonchange
end

	hook.Add("ScoreboardHide", "TTS_Scoreboard", function()
		scoreboard.RightClicked = false
		scoreboard:hide()
		gui.EnableScreenClicker( false )
		return true
	end)

	hook.Add("ScoreboardShow", "TTS_Scoreboard", function()
		scoreboard.RightClicked = false
		scoreboard:show()
		return true
	end)
