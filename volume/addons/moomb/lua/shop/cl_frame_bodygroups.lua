                                          
if IsValid(m_pnlCallQuery) then
	m_pnlCallQuery:Remove() 
end    

      
-- m_pnlCallQuery:CreateButton('Text3')      
-- m_pnlCallQuery:CreateButton('Text4')       
-- m_pnlCallQuery:CreateButton('Text5')      

-- if true then return end 


local TempSets = {
	{
		Name = 'Set #1',
		-- CanUse = true,
		items = {
			-- 1,2,3,4,5
		}
	},
	-- {
		-- Name = 'Set #1',
		-- CanUse = true,
		-- items = {
			-- 1,2,3,4,5 
		-- }
	-- },
}

TempSets = {
}

function savedata() 
  netstream.Start('TTS.Shop:SaveBodyGroups', TempSets)
end

netstream.Hook('TTS.LoadingTTSBodygroups', function(data)
  TempSets = data
  if !istable(TempSets) then
	TempSets = {}
  end
end)


concommand.Add("tts_bodygroup_frame", function()
  -- TempSets = util.JSONToTable(file.Read('tts_bodygroups.json') or '[]')
if IsValid(m_pnlPointshopBodyGroups) then 
	m_pnlPointshopBodyGroups:Remove()
end

local _w,_h = ScrW(), ScrH()
local limit_w, limit_h = 800, 600
limit_w, limit_h = 1280, 720
//limit_w, limit_h = 1024, 600
limit_w, limit_h = 800, 600
//limit_w, limit_h = 640, 480

_w, _h = math.Clamp( limit_w, 0, ScrW() ), math.Clamp( limit_h, 0, ScrH() ) 




local SetSelected = false

m_pnlPointshopBodyGroups = vgui.Create('.CCFrame')
m_pnlPointshopBodyGroups:SetSize(_w,_h)
m_pnlPointshopBodyGroups:SetPos(0,100)
m_pnlPointshopBodyGroups:Center()
m_pnlPointshopBodyGroups:SetTitle('Бодигруппы и сеты')
m_pnlPointshopBodyGroups:MakePopup()
m_pnlPointshopBodyGroups.OnRemove = function(s)
		
	if IsValid(m_pnlPointshop) then
		m_pnlPointshop:SetVisible(true)
	end

end

local m_pnlPanel -- 
local m_pnlPreview = vgui.Create(".CCPanel", m_pnlPointshopBodyGroups)
m_pnlPreview:SetSize(_w/3.5, 0) 
m_pnlPreview:Dock(RIGHT) 
m_pnlPreview:DockMargin(0, 0, 0, 0)  
m_pnlPreview:DockPadding(0, 0, 0, 0)
m_pnlPreview.Paint = function( s, w, h ) end


local AA_temporary = {}
local AA_add = {}
local AA_last = false 
local AA_last_model = false 
-- local AA_last = false

local m_pnlPreviewVGUI = vgui.Create('DShopPreview', m_pnlPreview)
m_pnlPreviewVGUI:Dock(FILL)
m_pnlPreviewVGUI:DockMargin(0, 0, 0, 5)  

local model = m_pnlPreviewVGUI.Entity


local m_pnlButtonsAnim = vgui.Create(".CCPanel", m_pnlPreview)
m_pnlButtonsAnim:SetSize(_w/3, 40)
m_pnlButtonsAnim:Dock(BOTTOM)
-- m_pnlButtonsAnim.Paint = function( s, w, h )
	-- draw.RoundedBox( 0, 0, 0, w, h, Color(215, 35, 35,230)) 
-- end
 
	local stay = false
	
	local m_buttonIdle = vgui.Create(".CCButton", m_pnlButtonsAnim)
	m_buttonIdle.Font = "S_Regular_15"
	m_buttonIdle:SetSize( (_w/3.5)/3,25 ) 
	m_buttonIdle:Dock( LEFT )
	m_buttonIdle.Text = ''
	m_buttonIdle:SetBorders(false)
	m_buttonIdle.DoClick = function( s )
		stay = false
		local model = m_pnlPreviewVGUI.Entity
		if IsValid(model) then
			model:ResetSequenceInfo()
			local iSeq = model:LookupSequence( 'idle_all_01' )
			if ( iSeq > 0 ) then model:ResetSequence( iSeq ) end
		end
	end
	m_buttonIdle.Think = function(s)
		local model = m_pnlPreviewVGUI.Entity
		if stay and IsValid(model) then
			model:FrameAdvance( 0 )
		end
	end
	
	local HTMLIcon = vgui.Create( "DHTML" , m_buttonIdle ) 
	-- HTMLIcon:SetZPos( 100 )
	HTMLIcon:Dock( FILL )
	HTMLIcon:SetAllowLua( true )
	HTMLIcon:SetVisible(true)
	HTMLIcon:AddFunction("button", "back", function()
		m_buttonIdle:DoClick()
	end)
	HTMLIcon.OnCursorEntered = function(s)
		m_buttonIdle:OnCursorEntered()
	end
	HTMLIcon.OnCursorExited = function(s)
		m_buttonIdle:OnCursorExited()
	end
	HTMLIcon:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 4px;
		-webkit-user-select: none;
		}
	</style>
	<body onclick='button.back()' >
		<img style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgOTIuMDA4IDkyLjAwOCIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgOTIuMDA4IDkyLjAwODsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiBjbGFzcz0iIj48Zz48Zz4KCTxwYXRoIGQ9Ik00Ni4wMDQsMjEuNjcyYzUuOTc1LDAsMTAuODM2LTQuODYxLDEwLjgzNi0xMC44MzZTNTEuOTc5LDAsNDYuMDA0LDBjLTUuOTc1LDAtMTAuODM1LDQuODYxLTEwLjgzNSwxMC44MzYgICBTNDAuMDI5LDIxLjY3Miw0Ni4wMDQsMjEuNjcyeiIgZGF0YS1vcmlnaW5hbD0iIzAwMDAwMCIgY2xhc3M9ImFjdGl2ZS1wYXRoIiBzdHlsZT0iZmlsbDojRkZGRkZGIiBkYXRhLW9sZF9jb2xvcj0iIzAwMDAwMCI+PC9wYXRoPgoJPHBhdGggZD0iTTY4LjA3NCw1NC4wMDhMNTkuMjk2LDI2LjgxYy0wLjQ3LTEuNDU2LTIuMDM2LTIuNTk2LTMuNTY2LTIuNTk2aC0xLjMxMkg1My40OEgzOC41MjZoLTAuOTM4aC0xLjMxMiAgIGMtMS41MywwLTMuMDk2LDEuMTQtMy41NjYsMi41OTZsLTguNzc2LDI3LjE5OGMtMC4yNiwwLjgwNy0wLjE1MiwxLjYyMywwLjI5NywyLjI0czEuMTkzLDAuOTcxLDIuMDQxLDAuOTcxaDIuMjUgICBjMS41MywwLDMuMDk2LTEuMTQsMy41NjYtMi41OTZsMi41LTcuNzV2MTAuNDY2djAuNTAzdjI5LjE2NmMwLDIuNzU3LDIuMjQzLDUsNSw1aDAuMzUyYzIuNzU3LDAsNS0yLjI0Myw1LTVWNjAuODQyaDIuMTI3djI2LjE2NiAgIGMwLDIuNzU3LDIuMjQzLDUsNSw1aDAuMzUyYzIuNzU3LDAsNS0yLjI0Myw1LTVWNTcuODQydi0wLjUwM3YtMTAuNDdsMi41MDIsNy43NTRjMC40NywxLjQ1NiwyLjAzNiwyLjU5NiwzLjU2NiwyLjU5NmgyLjI1ICAgYzAuODQ4LDAsMS41OTEtMC4zNTQsMi4wNDEtMC45NzFTNjguMzM0LDU0LjgxNSw2OC4wNzQsNTQuMDA4eiIgZGF0YS1vcmlnaW5hbD0iIzAwMDAwMCIgY2xhc3M9ImFjdGl2ZS1wYXRoIiBzdHlsZT0iZmlsbDojRkZGRkZGIiBkYXRhLW9sZF9jb2xvcj0iIzAwMDAwMCI+PC9wYXRoPgo8L2c+PC9nPiA8L3N2Zz4=" />
</body>
	]] ) 
	
	
	local m_buttonWalk = vgui.Create(".CCButton", m_pnlButtonsAnim)
	m_buttonWalk.Font = "S_Regular_15"
	m_buttonWalk:SetSize( (_w/3.5)/3,25 ) 
	m_buttonWalk:Dock( FILL )
	m_buttonWalk.Text = ''
	m_buttonWalk:SetBorders(false)
	m_buttonWalk.DoClick = function( s )
		stay = true
		local model = m_pnlPreviewVGUI.Entity
		if IsValid(model) then
			model:ResetSequenceInfo()
			local iSeq = model:LookupSequence( 'walk_all' )
			if ( iSeq > 0 ) then model:ResetSequence( iSeq ) end
			model:SetPoseParameter("move_x", 1)
		end
	end
	local HTMLIcon = vgui.Create( "DHTML" , m_buttonWalk )
	HTMLIcon:Dock( FILL ) 
	HTMLIcon:SetAllowLua( true )
	HTMLIcon:SetVisible(true)
	HTMLIcon:AddFunction("button", "back", function()
		m_buttonWalk:DoClick()
	end)
	HTMLIcon.OnCursorEntered = function(s)
		m_buttonWalk:OnCursorEntered()
	end
	HTMLIcon.OnCursorExited = function(s)
		m_buttonWalk:OnCursorExited()
	end
	HTMLIcon:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 4px;
		-webkit-user-select: none;
		}
	</style>
	<body onclick='button.back()' >
		<img style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgOTMuNjQ2IDkzLjY0NiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgOTMuNjQ2IDkzLjY0NjsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiBjbGFzcz0iIj48Zz48Zz4KCTxwYXRoIGQ9Ik02Ny45NzEsNDkuNzc4bC05LjM3OC0xMC4zNDVjLTAuNTg0LTAuNjQ0LTEuMTIxLTEuOTcxLTEuMTQ4LTIuODQxTDU3LjEsMjUuODU4di0wLjMxMWMwLTEuNjU0LTEuMzQ2LTMtMy0zaC05LjE4aC0zLjY0OCAgIGMtMS40NzgsMC0zLjEyNywxLjA0Ny0zLjc1NiwyLjM4NGwtMTIuMzU4LDI2LjI1Yy0wLjM0MiwwLjcyOC0wLjM3NiwxLjU0MS0wLjA5NiwyLjI5MmMwLjI4LDAuNzUsMC44NCwxLjM0MiwxLjU3NSwxLjY2NiAgIGwxLjgyMSwwLjgwM2MwLjM4OCwwLjE3MSwwLjgwMiwwLjI1OCwxLjIzMSwwLjI1OGgwYzEuMTc3LDAsMi4yNzMtMC42NjksMi43OTQtMS43MDRsNS43ODktMTEuNTE3djExLjU3NiAgIGMtMC4wMjQsMC4wNjctMC4wNTksMC4xMjgtMC4wODEsMC4xOTZsLTkuNzgzLDMwLjYzOGMtMC40MDcsMS4yNzYtMC4yODMsMi42MTksMC4zNSwzLjc4MXMxLjY5MywxLjk5NCwyLjk4NywyLjM0M2wwLjY1NCwwLjE3NyAgIGMwLjQyOCwwLjExNiwwLjg3MiwwLjE3NSwxLjMxOCwwLjE3NWMyLjI1MSwwLDQuMjk2LTEuNDgxLDQuOTc0LTMuNjAzbDkuMTQxLTI4LjYyOGwzLjI0Miw3Ljk0MSAgIGMwLjc5MSwxLjkzNywxLjY0NSw1LjMyOSwxLjg2NSw3LjQwOWwxLjU1MSwxNC42MjFjMC4yNDksMi4zNDEsMi4xLDQuMDQsNC40MDIsNC4wNGMwLjM3NywwLDAuNzYtMC4wNDYsMS4xMzctMC4xMzdsMC42NTktMC4xNiAgIGMyLjYyNC0wLjYzNSw0LjQ3OC0zLjMzMSw0LjEzMy02LjAwOGwtMi4yOTctMTcuODI4Yy0wLjI5Mi0yLjI2NS0xLjI2OS01LjgxMi0yLjE3OC03LjkwN2wtMy4xMDItNy4xNDQgICBjLTAuMDQtMC4wOTMtMC4wOTctMC4xNzctMC4xNDMtMC4yNjd2LTQuODQxbDUuNTksNS44MzZjMC41NTYsMC41ODEsMS4zLDAuOTAxLDIuMDk0LDAuOTAxYzAuODAzLDAsMS41NTMtMC4zMjYsMi4xMTEtMC45MTggICBsMS4wMzQtMS4wOThDNjkuMDM2LDUyLjg5OSw2OS4wNTUsNTAuOTczLDY3Ljk3MSw0OS43Nzh6IiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBjbGFzcz0iYWN0aXZlLXBhdGgiIGRhdGEtb2xkX2NvbG9yPSIjMDAwMDAwIiBzdHlsZT0iZmlsbDojRkZGRkZGIj48L3BhdGg+Cgk8cGF0aCBkPSJNNDguNTIsMjAuMDA1YzUuNTE2LDAsMTAuMDAzLTQuNDg3LDEwLjAwMy0xMC4wMDNDNTguNTIzLDQuNDg3LDU0LjAzNiwwLDQ4LjUyLDBjLTUuNTE1LDAtMTAuMDAxLDQuNDg3LTEwLjAwMSwxMC4wMDIgICBDMzguNTE4LDE1LjUxOCw0My4wMDUsMjAuMDA1LDQ4LjUyLDIwLjAwNXoiIGRhdGEtb3JpZ2luYWw9IiMwMDAwMDAiIGNsYXNzPSJhY3RpdmUtcGF0aCIgZGF0YS1vbGRfY29sb3I9IiMwMDAwMDAiIHN0eWxlPSJmaWxsOiNGRkZGRkYiPjwvcGF0aD4KPC9nPjwvZz4gPC9zdmc+" />
</body>
	]] ) 
	
	local m_buttonWalk = vgui.Create(".CCButton", m_pnlButtonsAnim)
	m_buttonWalk.Font = "S_Regular_15"
	m_buttonWalk:SetSize( (_w/3.5)/3,25 ) 
	m_buttonWalk:Dock( RIGHT )
	m_buttonWalk.Text = ''
	m_buttonWalk:SetBorders(false)
	m_buttonWalk.DoClick = function( s )
		stay = true
		local model = m_pnlPreviewVGUI.Entity
		if IsValid(model) then
			model:ResetSequenceInfo()
			local iSeq = model:LookupSequence( 'cidle_all' )
			if ( iSeq > 0 ) then model:ResetSequence( iSeq ) end
		end
	end
	
	local HTMLIcon = vgui.Create( "DHTML" , m_buttonWalk ) 
	HTMLIcon:Dock( FILL )
	HTMLIcon:SetAllowLua( true )
	HTMLIcon:SetVisible(true)
	HTMLIcon:AddFunction("button", "back", function()
		m_buttonWalk:DoClick()
	end)
	HTMLIcon.OnCursorEntered = function(s)
		m_buttonWalk:OnCursorEntered()
	end
	HTMLIcon.OnCursorExited = function(s)
		m_buttonWalk:OnCursorExited()
	end
	HTMLIcon:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 4px;
		-webkit-user-select: none;
		}
	</style>
	<body onclick='button.back()' >
		<img style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgODkuNTEzIDg5LjUxMyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgODkuNTEzIDg5LjUxMzsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiBjbGFzcz0iIj48Zz48Zz4KCTxwYXRoIGQ9Ik02My42NjksNDEuNzg2Yy0wLjU2NC0wLjU3MS0xLjMxNS0wLjg4Ny0yLjExNi0wLjg4OWwtMTAtMC4wMzFjLTAuNjU3LTAuMDAyLTEuNDI0LTAuNTc3LTEuNjExLTEuMjA4bC00LjAxMS0xMy41NiAgIGMtMC4wMDctMC4wMjMtMC4wMTktMC4wMzgtMC4wMjYtMC4wNjFjLTAuMjQzLTEuNDEyLTEuNDY5LTIuNDkxLTIuOTQ5LTIuNDkxaC02LjM4NWMtMS42NTQsMC0zLDEuMzQ2LTMsM3YzMC44NiAgIGMwLDEuNjU0LDEuMzQ2LDMsMywzaDEuMjkxYzAuMDQyLDAuMDAxLDAuMDc5LDAuMDEzLDAuMTIyLDAuMDEzbDEyLjQyMS0wLjAxMWMwLjg4MSwwLDEuNTk4LDAuNzE3LDEuNTk4LDEuNTk4djE4LjIwOSAgIGMwLDEuOTg1LDEuNjE1LDMuNiwzLjYsMy42aDIuNDFjMC45NiwwLDEuODYyLTAuMzc2LDIuNTQtMS4wNmMwLjY3Ny0wLjY4NCwxLjA0NS0xLjU4OSwxLjAzNi0yLjU0OWwtMC4yNDQtMjUuODk1ICAgYy0wLjAxOS0xLjk3OS0xLjY0NS0zLjU5LTMuNjI1LTMuNTlINDUuOTU2di0zLjAxOWMwLjU0NSwwLjMyMSwxLjE2LDAuNTE2LDEuNzgxLDAuNTE2aDEzLjc3YzEuNjQ5LDAsMy4wMDItMS4zNDIsMy4wMTYtMi45OTIgICBsMC4wMS0xLjMxNUM2NC41NDEsNDMuMTEyLDY0LjIzNCw0Mi4zNTcsNjMuNjY5LDQxLjc4NnoiIGRhdGEtb3JpZ2luYWw9IiMwMDAwMDAiIGNsYXNzPSJhY3RpdmUtcGF0aCIgZGF0YS1vbGRfY29sb3I9IiMwMDAwMDAiIHN0eWxlPSJmaWxsOiNGRkZGRkYiPjwvcGF0aD4KCTxwYXRoIGQ9Ik0zOS43NjQsMjAuMzM4YzUuNjA3LDAsMTAuMTY5LTQuNTYyLDEwLjE2OS0xMC4xNjlTNDUuMzcxLDAsMzkuNzY0LDBTMjkuNTk1LDQuNTYyLDI5LjU5NSwxMC4xNjkgICBTMzQuMTU2LDIwLjMzOCwzOS43NjQsMjAuMzM4eiIgZGF0YS1vcmlnaW5hbD0iIzAwMDAwMCIgY2xhc3M9ImFjdGl2ZS1wYXRoIiBkYXRhLW9sZF9jb2xvcj0iIzAwMDAwMCIgc3R5bGU9ImZpbGw6I0ZGRkZGRiI+PC9wYXRoPgoJPHBhdGggZD0iTTQ2LjE2LDYyLjQ4MkgyOC45Nzl2LTYuMDY0VjIyLjUwMmMwLTEuMTA0LTAuODk2LTItMi0ycy0yLDAuODk2LTIsMnYzMy45MTZ2Ni4wNjR2MjUuMDNjMCwxLjEwNCwwLjg5NiwyLDIsMnMyLTAuODk2LDItMiAgIHYtMjEuMDNINDYuMTZ2MjEuMDNjMCwxLjEwNCwwLjg5NiwyLDIsMnMyLTAuODk2LDItMnYtMjEuMDNDNTAuMTYsNjQuMjc3LDQ4LjM2Niw2Mi40ODIsNDYuMTYsNjIuNDgyeiIgZGF0YS1vcmlnaW5hbD0iIzAwMDAwMCIgY2xhc3M9ImFjdGl2ZS1wYXRoIiBkYXRhLW9sZF9jb2xvcj0iIzAwMDAwMCIgc3R5bGU9ImZpbGw6I0ZGRkZGRiI+PC9wYXRoPgo8L2c+PC9nPiA8L3N2Zz4=" />
</body>
	]] ) 
	
	
local CallSetVisible, CallSetsGridVisible, FillCleaner 

-- netstream.Hook("TTS.Shop:ValidateEquipItem", function(ply, item_id, data) 
-- local anims = {
	-- 'reference',
	-- //'pose_ducking_01',
	-- 'pose_standing_01',
	-- 'pose_standing_02',
-- }
-- local iSeq = model:LookupSequence( 'reference' )
-- if ( iSeq > 0 ) then model:ResetSequence( iSeq ) end
-- PrintTable( table.Reverse( model:GetSequenceList() ) )
m_pnlPreviewVGUI.ToRender = {} 
local _oldpaint = m_pnlPreviewVGUI.Paint 
m_pnlPreviewVGUI.Paint = function( s, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
	_oldpaint( s, w, h )
end   
m_pnlPreviewVGUI.DrawOtherModels = function()
	-- local pos = m_pnlPreviewVGUI.Entity:GetPos()
	-- m_pnlPreviewVGUI.Entity:SetPos(pos) 
	-- cam.IgnoreZ( true )
	for item_id, model in pairs( m_pnlPreviewVGUI.ToRender) do
		if IsValid(model) and model.ToDrawning then
			local parent = m_pnlPreviewVGUI
			-- print(model:GetParent(), parent:GetModel())
			if !IsValid(model:GetParent()) || model:GetParent():GetModel() ~= parent:GetModel() then
				model:Remove()
				local item = TTS.Shop.Data.Items[item_id]
				
				local data
				if SetSelected then 
					-- TempSets[SetSelected].items[AA_last] = true
					data = TempSets[SetSelected].items[item_id]
					-- for item_id, data in pairs(TempSets[SetSelected].items) do
						-- local item = TTS.Shop.Data.Items[item_id]
						-- if type(data) == 'table' then
							-- PrintTable(data)
							-- print(item.name)
						-- end
						-- m_pnlPanel:ItemLoad(item, false, type(data) == 'table' and data or false)
					-- end
					if data then
						m_pnlPanel:ItemLoad(item, true, type(data) == 'table' and data or false)
					end
				end
				-- if TempSets[SetSelected].items then
				-- end
				
				continue
			end
			
			parent.EntPos = parent.EntPos + Vector(0,0,0.0001)
			
			
			-- model:GetRenderOrigin()
			-- print(model:GetParent():GetModel())
			-- model.LocalPos = pos
			-- model.LocalAngles = ang
		
			local pos = model.ModifyPos
			local ang = Angle(0,0,0)
			model.ModifyAngles:Set(ang)

			local scale = model.ModifyScale
			
			if model.ScaleC then
				scale = model.ScaleC
			end
			if model.PosCX then
				pos = pos + (ang:Forward() * model.PosCX) 
			end
			if model.PosCY then
				pos = pos + (ang:Right() * model.PosCY) 
			end
			if model.PosCZ then
				pos = pos + (ang:Up() * model.PosCZ) 
			end
			if model.AngCX then
				ang:RotateAroundAxis(ang:Up(), model.AngCX)
			end
			if model.AngCY then
				ang:RotateAroundAxis(ang:Right(), model.AngCY)
			end
			if model.AngCZ then 
				ang:RotateAroundAxis(ang:Forward(), model.AngCZ)
			end
			-- if model.AngleX then
				-- ang:RotateAroundAxis(ang:Up(), model.AngleX)
			-- end
			-- if model.AngleY then
				-- ang:RotateAroundAxis(ang:Right(), model.AngleY)
			-- end
			-- if model.AngleZ then
				-- ang:RotateAroundAxis(ang:Forward(), model.AngleZ)
			-- end
			-- if model.PosX then
				-- pos = pos + (ang:Forward() * model.PosX) 
			-- end
			-- if model.PosY then
				-- pos = pos + (ang:Right() * model.PosY) 
			-- end
			-- if model.PosZ then
				-- pos = pos + (ang:Up() * model.PosZ) 
			-- end
			
			-- if model.ScaleC then
				-- model:SetModelScale(model.ScaleC, 0)
			-- else
				-- model:SetModelScale(model.ScaleC, 0)
			-- end
			
			model:DrawModel()
			-- model:SetParent( parent.Entity, model.Attached )
			-- model:SetLocalPos(model.LocalPos)
			-- model:SetLocalAngles(model.LocalAngles)
			-- model:SetParent( s.Entity, model.Attached )
			model:SetLocalPos(model.LocalPos + pos)
			model:SetLocalAngles(model.LocalAngles + ang)
			model:SetModelScale(scale, 0)
			-- local pos = util.LocalToWorld( m_pnlPreviewVGUI.Entity, model.LocalPos, model.Attached )
			-- local pos = model:GetPos()
			-- print(pos)
			-- model:SetPos(pos)
			-- model:SetAngles(model.LocalAngles)
		end 
	end
	-- cam.IgnoreZ( false )
		-- local model = m_pnlPreviewVGUI.ToRender[item.id]
		-- if IsValid(model) and model.ToDrawning then
			-- model:DrawModel()
			-- return
		-- end
end



local m_pnlParent = vgui.Create(".CCPanel", m_pnlPointshopBodyGroups)
m_pnlParent:SetSize(_w/3, 0) 
m_pnlParent:Dock(FILL) 
m_pnlParent:DockMargin(5, 0, 5, 0)  
m_pnlParent:DockPadding(0, 0, 0, 0)
m_pnlParent.Paint = function( s, w, h ) end

local m_pnlButtons = vgui.Create(".CCPanel", m_pnlParent)
m_pnlButtons:SetSize(_w/3, 40)
m_pnlButtons:Dock(BOTTOM)
-- m_pnlButtons.Paint = function( s, w, h )
	-- draw.RoundedBox( 0, 0, 0, w, h, Color(215, 35, 35,230)) 
-- end

m_pnlPanel = vgui.Create(".CCPanel", m_pnlParent)
m_pnlPanel:Dock(FILL)

	
local CallSetVisible, CallSetsGridVisible, FillCleaner 

-- netstream.Hook("TTS.Shop:ValidateEquipItem", function(ply, item_id, data)  
--[[
	local m_button2 = vgui.Create(".CCButton", m_pnlButtons)
	m_button2.Font = "S_Regular_15"
	m_button2:SetSize( 50,25 )  
	m_button2:Dock( LEFT )
	m_button2.Text = 'ADD'
	m_button2:SetBorders(false)
	m_button2.DoClick = function( s )
		TempSets[SetSelected].items[AA_last] = true
		AA_last = false
		AA_last_model = false
		CallSetVisible()
		-- AA_temporary[AA_last] = true
		-- AA_temporary
		-- PrintTable(AA_add)
		-- netstream.Start("TTS.Shop:ValidateEquipItem", AA_last, {
			-- selected = AA_add
		-- })
		-- IsSeeInventory = false
		-- CategorySelected = Name
		-- CallCategoryVisible()
		
	end
]]--
	netstream.Hook("TTS.Shop:ValidateEquipItem", function(check, data)
		local func = function(self)
			for item_id, _ in pairs(check) do
				TempSets[SetSelected].items[item_id] = nil
			end
			
			TempSets[SetSelected].items[AA_last] = true

			local model = AA_last_model 
			if AA_last_model and IsValid(AA_last_model) || data.only then
				model = data.only and data.only or model
				TempSets[SetSelected].items[AA_last] = {
					ScaleC = model.ScaleC,
					PosCX = model.PosCX,
					PosCY = model.PosCY,
					PosCZ = model.PosCZ,
					AngCX = model.AngCX,
					AngCY = model.AngCY,
					AngCZ = model.AngCZ,
					BodyGroupsC = model.BodyGroupsC,
					SkinC = model.SkinC,
				}
			end
			-- print(AA_last)
			AA_last = false
			AA_last_model = false
			if !data.only then
				CallSetVisible()
			end
			if IsValid(self) then
				self:Remove()
			end
      hook.Run("FBG:ValidateFinish")
      savedata()
		end
		-- PrintTable(check)
		if table.Count(check) == 0 then
			func()
			return 
		end
		print(check, data.only, data.save)
		if data.save then
			func()
			return
		end
		
		local tb = {}
		
		for item_id, _ in pairs(check) do
			local item = TTS.Shop.Data.Items[item_id]
			table.insert(tb, item.name)
		end
	
		m_pnlCallQuery = vgui.Create(".CCQuery")
		m_pnlCallQuery:SetTextTitle('Проблема')
		m_pnlCallQuery:SetTextDescription('Добавление предмета удалит из сета ' ..table.concat(tb, ', '))
		local btn = m_pnlCallQuery:CreateButton('Я согласен', func)
		btn.FakeActivated = true
		local btn = m_pnlCallQuery:CreateButton('Нет, я подумаю еще', function(self)
			self:Remove()
		end)
		btn.LerpedColor = Color(250, 90, 90)
		-- 
	end)
	local m_button2 = vgui.Create(".CCButton", m_pnlButtons)
	m_button2.Font = "S_Regular_15"
	m_button2:SetSize( 50,25 )  
	m_button2:Dock( FILL )
	m_button2.Text = 'Добавить'
	m_button2:SetBorders(false)
	m_button2.DoClick = function( s )
		netstream.Start("TTS.Shop:ValidateEquipItem", AA_last, {
			selected = table.GetKeys(TempSets[SetSelected].items)
		})
	end
	local _oldThink = m_pnlButtons.Think
	m_pnlButtons.Think = function( s ) 
		if _oldThink then
			_oldThink(s)
		end
		if SetSelected then
			local onset = AA_last and TempSets[SetSelected].items[AA_last]
			if IsValid(AA_last_model) and !onset then
				m_button2:SetVisible(true)
			else
				m_button2:SetVisible(false)
			end
		else 
			m_button2:SetVisible(false)
		end
	end
	local m_buttonAddToSet = m_button2
	local m_button2 = vgui.Create(".CCButton", m_pnlButtons)
	m_button2.Font = "S_Regular_15"
	m_button2:SetSize( 50,25 )  
	m_button2:Dock( FILL )
	m_button2.Text = 'Сохранить'
	m_button2:SetBorders(false)
	m_button2.DoClick = function( s )
		
		netstream.Start("TTS.Shop:ValidateEquipItem", AA_last, {
			selected = table.GetKeys(TempSets[SetSelected].items),
			save = true
    })
    
		_SetSelected = SetSelected
		_AA_last = AA_last
		_AA_last_model = AA_last_model
		
		hook.Add("FBG:ValidateFinish", "RunFunc", function()
			hook.Remove("FBG:ValidateFinish", "RunFunc")
			SetSelected = _SetSelected
			AA_last = _AA_last
			AA_last_model = _AA_last_model
			_SetSelected = nil
			_AA_last = nil
      _AA_last_model = nil
      
      if TempSets[SetSelected].Enabled then
        netstream.Start("TTS.Shop:EquipSetWithClear", TempSets[SetSelected].items)
      end
		end)
	end
	local _oldThink = m_pnlButtons.Think
	m_pnlButtons.Think = function( s ) 
		if _oldThink then
			_oldThink(s)
		end
		local onset = (SetSelected and AA_last) and TempSets[SetSelected].items[AA_last]
		if IsValid(AA_last_model) and onset then
			m_button2:SetVisible(true)
		else
			m_button2:SetVisible(false)
		end
	end
	local m_buttonSaveInSet = m_button2

	local m_button2 = vgui.Create(".CCButton", m_pnlButtons)
	m_button2.Font = "S_Regular_15"
	m_button2:SetSize( 50,25 )  
	m_button2:Dock( FILL )
	m_button2.Text = 'Создать сет'
	m_button2:SetBorders(false)
  m_button2.DoClick = function( s )
    if table.Count(TempSets)+1 > 10 then
      TTS:AddNote( 'Достигнут лимит по созданию сетов', NOTIFY_ERROR, 4 )
      return
    end
		local text = m_pnlPanel.cpanscroll.nameent:GetValue()
		table.insert(TempSets, {
			Name = text,
			items = {}
    })
    savedata()
		m_pnlPanel.cpanscroll:Remove()
		CallSetsGridVisible()
		
	end
	local _oldThink = m_pnlButtons.Think
	m_pnlButtons.Think = function( s ) 
		if _oldThink then
			_oldThink(s)
		end
		local pnl = m_pnlPanel.cpanscroll
		if IsValid(pnl) and pnl.nameent then
			m_button2:SetVisible(true)
		else
			m_button2:SetVisible(false)
		end
	end
	-- local m_button2 = vgui.Create(".CCButton", m_pnlButtons)
	-- m_button2.Font = "S_Regular_15"
	-- m_button2:SetSize( 50,25 )  
	-- m_button2:Dock( RIGHT )
	-- m_button2.Text = 'A3S'
	-- m_button2:SetBorders(false)
	-- m_button2.DoClick = function( s )
	-- 	PrintTable(TempSets)
	-- end
	-- 			-- m_button:DoClick()
			-- end
-- m_pnlParent:DockMargin(5, 0, 5, 0)  
-- m_pnlParent:DockPadding(0, 0, 0, 0)


m_pnlPanel.ItemLoad = function(s, item, noequip, modify)
	if !noequip then
		AA_last = item.id
	end
	if item.type == 'model' then
	
		-- Небольшой фикс причурной ошибки #2
		-- print(item.data.mdl, m_pnlPreviewVGUI:GetModel())
		-- if SetSelected then
		m_pnlPreviewVGUI:SetModel(item.data.mdl)
			-- m_pnlPanel:ItemLoadDefault() 
		-- end
		-- m_pnlFillingPoints:SetSize(500,400)
		
		-- m_pnlFillingPoints.preview = vgui.Create("DShopPreview", m_pnlFillingPoints)
		-- m_pnlFillingPoints.preview:SetZPos( 100 )
		-- m_pnlFillingPoints.preview.ent = item.data.mdl
		-- m_pnlFillingPoints.preview:SetModel(item.data.mdl) 
		-- m_pnlFillingPoints.preview:Dock(FILL)
		-- print(m_pnlPreview)
		local Ent = m_pnlPreviewVGUI.Entity
		
		-- AA_last_model = Ent
		-- PrintTable( table.Reverse( Ent:GetSequenceList() ) )
		-- local iSeq = Ent:LookupSequence("reference")or Ent:LookupSequence("ragdoll")
		-- if ( iSeq > 0 ) then Ent:ResetSequence( iSeq ) end
		-- print('Ent')
		if modify then
			if modify.BodyGroupsC then
				for i,v in pairs(modify.BodyGroupsC) do
					Ent:SetBodygroup(i,v)
				end
			end
			if modify.SkinC then
				Ent:SetSkin(modify.SkinC)
			end
		-- PrintTable(modify)
			-- print('modify Ent')
		end
					-- BodyGroups = model.BodyGroups,
					-- Skin 
		if !noequip then 
			AA_last_model = m_pnlPreviewVGUI
		else 
			return 
		end
		if IsValid(s.cpanscroll) then
			s.cpanscroll:Remove()
		end
		
		s.cpanscroll = vgui.Create("DScrollPanel", s)
		s.cpanscroll:SetSize( 200, 400 )
		s.cpanscroll:Dock(FILL)
		s.cpanscroll.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,150))
		end
		
		local allowedbodygroups = {}
		for i = 1, #Ent:GetBodyGroups() do
			local bg = Ent:GetBodyGroups()[i]
			if bg then
				for k,v in pairs( bg ) do
					if k == "id" then
						allowedbodygroups[v] = {}
						for k2, v2 in pairs( bg["submodels"] ) do
							table.insert( allowedbodygroups[v], k2 )
						end
					end
				end	
			end
		end
		local createdDlabel
		local count = 0
		if allowedbodygroups ~= {} then
			for k,v in pairs( allowedbodygroups ) do
				if table.Count(v) == 1 then continue end
				
				count = count + 1
				if !createdDlabel then
					createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
					createdDlabel:Dock( TOP )
					createdDlabel:SetFont( "S_Light_15" )
					createdDlabel:SetText( 'Доступные бодигруппы' )
					createdDlabel:DockMargin(5, 5, 0, 0)
					s.cpanscroll:AddItem(createdDlabel)
				end 
				
				local DComboBox = vgui.Create( ".CCDropDown", s.cpanscroll )
				DComboBox.Text = Ent:GetBodygroupName( k )
				DComboBox.AnotherText = true
				DComboBox:Dock( TOP )
				DComboBox:DockMargin(0, 5, 0, 0)
				DComboBox:SetSize( 100, 40 )
				DComboBox.OnSelect = function( panel, index, aa )
					local data, sec = panel:GetSelected()
					
					Ent:SetBodygroup(sec, data)
					AA_last_model.BodyGroupsC = AA_last_model.BodyGroupsC or {}
					AA_last_model.BodyGroupsC[sec] = data
				end
				for k2,v2 in pairs( v ) do
					local ind = DComboBox:AddChoice( v2, k )
					if modify and modify.BodyGroupsC and modify.BodyGroupsC[k] == v2 then
						DComboBox:ChooseOptionID( ind )
					end
				end
				s.cpanscroll:AddItem(DComboBox)
			end
		end
		if count == 0 then
			createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
			createdDlabel:Dock( TOP )
			createdDlabel:SetFont( "S_Light_15" )
			createdDlabel:SetText( 'Нет доступных бодигрупп' )
			createdDlabel:DockMargin(5, 5, 0, 0)
			s.cpanscroll:AddItem(createdDlabel)
		end
		local createdDlabel
		if ( Ent:SkinCount() > 1 ) then
		
			if !createdDlabel then
				createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Доступные скины' )
				createdDlabel:DockMargin(5, 5, 0, 0)
				s.cpanscroll:AddItem(createdDlabel)
			end
			
			local combo = vgui.Create( ".CCDropDown", s.cpanscroll )
			combo.Text = 'Выбор скина'
			combo:Dock( TOP )
			combo:SetSize( 100, 40 )
			combo.OnSelect = function( pnl, index, value, data ) data()	end

			for l = 0, Ent:SkinCount() - 1 do
				local ind = combo:AddChoice( "Скин " .. l, function()
					AA_last_model.SkinC = l
					Ent:SetSkin(l)
				end )
				
				if modify and modify.SkinC == l then
					combo:ChooseOptionID( ind )
				end
			end
			
			s.cpanscroll:AddItem(combo)

		else
			createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
			createdDlabel:Dock( TOP )
			createdDlabel:SetFont( "S_Light_15" )
			createdDlabel:SetText( 'Нет доступных скинов' )
			createdDlabel:DockMargin(5, 5, 0, 0) 
			s.cpanscroll:AddItem(createdDlabel)
		end
	elseif item.type == 'attach' then
		-- m_pnlPreviewVGUI.ToRender[item.id] = 
	
		model = ClientsideModel(item.data.mdl, RENDERGROUP_TRANSLUCENT)
		model:SetNoDraw(true)
		
		local pos = Vector()
		local ang = Angle()
		
		local Attached
		if item.data.attach then
			local attach_id = m_pnlPreviewVGUI.Entity:LookupAttachment(item.data.attach)
			if not attach_id then return end
			
			local attach = m_pnlPreviewVGUI.Entity:GetAttachment(attach_id)
			
			if not attach then return end
			
			model:SetMoveType( MOVETYPE_NONE )
			model:SetParent( m_pnlPreviewVGUI.Entity, attach_id )
			Attached = attach_id
			
		else
			local bone_id = m_pnlPreviewVGUI.Entity:LookupBone(item.data.bone)
			if not bone_id then return end
			m_pnlPreviewVGUI.Entity:AddEffects( EF_FOLLOWBONE )
			model:SetMoveType( MOVETYPE_NONE )
			model:SetParent( m_pnlPreviewVGUI.Entity, bone_id )
			Attached = bone_id
			
		end

		
		if item.data.ang.p then 
			ang:RotateAroundAxis(ang:Up(), item.data.ang.p)
		end
		if item.data.ang.y then
			ang:RotateAroundAxis(ang:Right(), item.data.ang.y)
		end
		if item.data.ang.r then
			ang:RotateAroundAxis(ang:Forward(), item.data.ang.r)
		end
		if item.data.pos.x then
			pos = pos + (ang:Forward() * item.data.pos.x) 
		end
		if item.data.pos.y then
			pos = pos + (ang:Right() * item.data.pos.y) 
		end
		if item.data.pos.z then
			pos = pos + (ang:Up() * item.data.pos.z) 
		end
		if item.data.scale then
			model:SetModelScale(item.data.scale, 0)
		end
		
		
		model:SetLocalPos(pos)
		model:SetLocalAngles(ang)
		-- model:SetRenderOrigin( pos )  
		model.LocalPos = pos
		model.LocalAngles = ang
	
		model.ModifyPos = Vector(0,0,0)
		model.ModifyAngles = Angle(0,0,0)
		model.ModifyScale = model:GetModelScale()
		if modify then
			PrintTable(modify)
			model.ScaleC = modify.ScaleC
			model.PosCX = modify.PosCX
			model.PosCY = modify.PosCY
			model.PosCZ = modify.PosCZ
			model.AngCX = modify.AngCX
			model.AngCY = modify.AngCY
			model.AngCZ = modify.AngCZ
			
			if modify.BodyGroupsC then
				for i,v in pairs(modify.BodyGroupsC) do
					model:SetBodygroup(i,v)
				end
				model.BodyGroupsC = modify.BodyGroupsC
			end
			if modify.SkinC then
				model:SetSkin(modify.SkinC)
				model.SkinC = modify.SkinC
			end
		end
		-- if modify then
				
			-- if modify.ScaleC then
				-- model.ModifyScale = modify.ScaleC
			-- end
			-- if modify.PosCX then
				-- model.ModifyPos = model.ModifyPos + (model.ModifyAngles:Forward() * modify.PosCX) 
			-- end
			-- if modify.PosCY then
				-- model.ModifyPos = model.ModifyPos + (model.ModifyAngles:Right() * modify.PosCY) 
			-- end
			-- if modify.PosCZ then
				-- model.ModifyPos = model.ModifyPos + (model.ModifyAngles:Up() * modify.PosCZ) 
			-- end
			-- if modify.AngCX then
				-- model.ModifyAngles:RotateAroundAxis(model.ModifyAngles:Up(), modify.AngCX)
			-- end
			-- if modify.AngCY then
				-- model.ModifyAngles:RotateAroundAxis(model.ModifyAngles:Right(), modify.AngCY)
			-- end
			-- if modify.AngCZ then
				-- model.ModifyAngles:RotateAroundAxis(model.ModifyAngles:Forward(), modify.AngCZ)
			-- end
		-- end

		model.Attached = Attached
		model.ToDrawning = true
		m_pnlPreviewVGUI.ToRender[item.id] = model
		if !noequip then 
			AA_last_model = model
		else 
			return	
		end
		-- if noequip then return end
		local Ent = model
		if IsValid(s.cpanscroll) then
			s.cpanscroll:Remove()
		end
		
		s.cpanscroll = vgui.Create("DScrollPanel", s)
		s.cpanscroll:SetSize( 200, 400 )
		s.cpanscroll:Dock(FILL)
		s.cpanscroll.Paint = function( s, w, h ) end
		
		local allowedbodygroups = {}
		for i = 1, #Ent:GetBodyGroups() do
			local bg = Ent:GetBodyGroups()[i]
			if bg then
				for k,v in pairs( bg ) do
					if k == "id" then
						allowedbodygroups[v] = {}
						for k2, v2 in pairs( bg["submodels"] ) do
							table.insert( allowedbodygroups[v], k2 )
						end
					end
				end
			end
		end
		local createdDlabel
		local count = 0
		if allowedbodygroups ~= {} then
			for k,v in pairs( allowedbodygroups ) do
				if table.Count(v) == 1 then continue end
				
				count = count + 1
				if !createdDlabel then
					createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
					createdDlabel:Dock( TOP )
					createdDlabel:SetFont( "S_Light_15" )
					createdDlabel:SetText( 'Доступные бодигруппы' )
					createdDlabel:DockMargin(5, 5, 0, 0)
					s.cpanscroll:AddItem(createdDlabel)
				end
				-- local DLabel = vgui.Create( "DLabel", m_pnlFillingPoints.cpanscroll )
				-- DLabel:Dock( TOP )
				-- DLabel:SetText( Ent:GetBodygroupName( k ) )
				-- m_pnlFillingPoints.cpanscroll:AddItem(DLabel)
				
				local DComboBox = vgui.Create( ".CCDropDown", s.cpanscroll )
				DComboBox.Text = Ent:GetBodygroupName( k )
				DComboBox.AnotherText = true
				DComboBox:Dock( TOP )
				DComboBox:DockMargin(0, 5, 0, 0)
				DComboBox:SetSize( 100, 40 )
				DComboBox.OnSelect = function( panel, index, aa )
					local data, sec = panel:GetSelected()
					
					Ent:SetBodygroup(sec, data)
					Ent.BodyGroupsC = Ent.BodyGroupsC or {}
					Ent.BodyGroupsC[sec] = data
				end
				for k2,v2 in pairs( v ) do
					local ind = DComboBox:AddChoice( v2, k )
					
					if Ent.BodyGroupsC and Ent.BodyGroupsC[k] == v2 then
						DComboBox:ChooseOptionID( ind )
					end
				end
				s.cpanscroll:AddItem(DComboBox)
			end
		end
		if count == 0 then
			createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
			createdDlabel:Dock( TOP )
			createdDlabel:SetFont( "S_Light_15" )
			createdDlabel:SetText( 'Нет доступных бодигрупп' )
			createdDlabel:DockMargin(5, 5, 0, 0)
			s.cpanscroll:AddItem(createdDlabel)
		end
		local createdDlabel
		if ( Ent:SkinCount() > 1 ) then
		
			if !createdDlabel then
				createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
				createdDlabel:Dock( TOP )
				createdDlabel:SetFont( "S_Light_15" )
				createdDlabel:SetText( 'Доступные скины' )
				createdDlabel:DockMargin(5, 5, 0, 0)
				s.cpanscroll:AddItem(createdDlabel) 
			end
			
			local combo = vgui.Create( ".CCDropDown", s.cpanscroll )
			combo.Text = 'Выбор скина'
			combo:Dock( TOP )
			combo:SetSize( 100, 40 )
			combo.OnSelect = function( pnl, index, value, data ) data()	end

			for l = 0, Ent:SkinCount() - 1 do
				local ind = combo:AddChoice( "Скин " .. l, function()
					Ent.SkinC = l
					Ent:SetSkin(l)
				end )
				if Ent and Ent.SkinC == l then
					combo:ChooseOptionID( ind )
				end
			end
			
			s.cpanscroll:AddItem(combo)

		else
			createdDlabel = vgui.Create( "DLabel", s.cpanscroll )
			createdDlabel:Dock( TOP )
			createdDlabel:SetFont( "S_Light_15" )
			createdDlabel:SetText( 'Нет доступных скинов' )
			createdDlabel:DockMargin(5, 5, 0, 0)
			s.cpanscroll:AddItem(createdDlabel)
		end
		
		
		-- Scale  
		local div =  vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end
		
		local scaled = item.data.scale or 1
		local scalec = scaled
		-- print(scalec, scaled, Ent.ScaleC)
		-- local toview = math.Remap( scaled, 0, scaled, 0, 1 )
		-- local toviewselect = math.Remap( Ent.ScaleC or scalec, 0, scaled, 0, 1 )
		-- print(toview, scalec, 0, scaled, 0, 1)
		local Scale = vgui.Create(".CCNumSlider", div)
		-- Scale:SetPos( 5, y ) 
		Scale:Dock( FILL )
		Scale:SetSize( 0, 40 )
		-- Scale:SetSize(self.cpanscroll:GetWide()-40-10, 40) 
		Scale:SetText( "Размер пропа" )
		Scale:SetMinMax( math.round(scaled-(scaled/4), 3), math.round(scaled+(scaled/4), 3) )
		Scale:SetDecimals( 3 )
		Scale:SetValue( Ent.ScaleC or scalec )
		Scale.OnValueChanged = function(s, num)
			-- local scalec = math.Remap( num, 0, 1, 0, scaled)
			if tonumber(num) == scaled then
				Ent.ScaleC = nil
			else
				Ent.ScaleC = num
			end
		end
		Scale:OnValueChanged(Scale:GetValue())

		local ScaleRes = vgui.Create(".CCButton", div)
		ScaleRes:Dock( RIGHT )
		ScaleRes:SetSize(40, 40)
		ScaleRes.Text =  "RESET" 
		ScaleRes.Font =  "S_Light_15" 
		ScaleRes.FakeActivated =  true
		ScaleRes:SetBorders(false)
		ScaleRes.DoClick = function(s)
			Scale:SetValue(scalec)
		end
		
		-- PosX 
		local div = vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local posd = item.data.pos.x or 0
		local posc = 0
		local Pos = vgui.Create(".CCNumSlider", div)
		Pos:Dock( FILL )
		Pos:SetSize( 0, 40 )
		Pos:SetText( "Pos X" )
		Pos:SetMinMax( -4, 4 )
		Pos:SetDecimals( 3 )
		Pos:SetValue( Ent.PosCX or posc )
		Pos.OnValueChanged = function(s, num)
			if num == posc then
				Ent.PosCX = nil
			else
				Ent.PosCX = num
			end
		end
		Pos:OnValueChanged(Pos:GetValue())

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "RESET" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue(posc)
		end 
		
		-- PosY 
		local div = vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local posd = item.data.pos.y or 0
		local posc = 0
		local Pos = vgui.Create(".CCNumSlider", div)
		Pos:Dock( FILL )
		Pos:SetSize( 0, 40 )
		Pos:SetText( "Pos Y" )
		Pos:SetMinMax( -4, 4 )
		Pos:SetDecimals( 3 )
		Pos:SetValue( Ent.PosCY or posc )
		Pos.OnValueChanged = function(s, num)
			if num == posc then
				Ent.PosCY = nil
			else
				Ent.PosCY = num
			end
		end
		Pos:OnValueChanged(Pos:GetValue())

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "RESET" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue(posc)
		end 

		
		-- PosZ 
		local div = vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local posd = item.data.pos.z or 0
		local posc = 0
		local Pos = vgui.Create(".CCNumSlider", div)
		Pos:Dock( FILL )
		Pos:SetSize( 0, 40 )
		Pos:SetText( "Pos Z" )
		Pos:SetMinMax( -4, 4 )
		Pos:SetDecimals( 3 )
		Pos:SetValue( Ent.PosCZ or posc )
		Pos.OnValueChanged = function(s, num)
			if num == posc then
				Ent.PosCZ = nil
			else
				Ent.PosCZ = num
			end
		end
		Pos:OnValueChanged(Pos:GetValue())

		local PosRes = vgui.Create(".CCButton", div)
		PosRes:Dock( RIGHT )
		PosRes:SetSize(40, 40)
		PosRes.Text =  "RESET" 
		PosRes.Font =  "S_Light_15" 
		PosRes.FakeActivated =  true
		PosRes:SetBorders(false)
		PosRes.DoClick = function(s)
			Pos:SetValue(posc)
		end 

		-- AngX 
		local div = vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local angd = item.data.ang.x or 0
		local angc = 0
		
		local Ang = vgui.Create(".CCNumSlider", div)
		Ang:Dock( FILL )
		Ang:SetSize( 0, 40 )
		Ang:SetText( "Ang X" )
		Ang:SetMinMax( -180, 180 )
		Ang:SetDecimals( 0 )
		Ang:SetValue( Ent.AngCX or angc )
		Ang.OnValueChanged = function(s, num)
			if num == angc then
				Ent.AngCX = nil
			else
				Ent.AngCX = num
			end
		end
		Ang:OnValueChanged(Ang:GetValue())

		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "RESET" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue(angc)
		end 
		
		
		-- AngY  
		local div = vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local angd = item.data.ang.y or 0
		local angc = 0
		
		local Ang = vgui.Create(".CCNumSlider", div)
		Ang:Dock( FILL )
		Ang:SetSize( 0, 40 )
		Ang:SetText( "Ang Y" )
		Ang:SetMinMax( -180, 180 )
		Ang:SetDecimals( 0 )
		Ang:SetValue( Ent.AngCY or angc )
		Ang.OnValueChanged = function(s, num)
			if num == angc then
				Ent.AngCY = nil
			else
				Ent.AngCY = num
			end
		end
		Ang:OnValueChanged(Ang:GetValue())

		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "RESET" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue(angc)
		end 
		
		-- AngZ
		local div = vgui.Create('DPanel', s.cpanscroll)
		div:SetSize(0, 40)
		div:Dock( TOP )
		div.Paint = function() end 
		
		local angd = item.data.ang.z or 0
		local angc = 0
		
		local Ang = vgui.Create(".CCNumSlider", div)
		Ang:Dock( FILL )
		Ang:SetSize( 0, 40 )
		Ang:SetText( "Ang Z" )
		Ang:SetMinMax( -180, 180 )
		Ang:SetDecimals( 0 )
		Ang:SetValue( Ent.AngCZ or angc )
		Ang.OnValueChanged = function(s, num)
			if num == angc then
				Ent.AngCZ = nil
			else
				Ent.AngCZ = num
			end
		end
		Ang:OnValueChanged(Ang:GetValue())

		local AngRes = vgui.Create(".CCButton", div)
		AngRes:Dock( RIGHT )
		AngRes:SetSize(40, 40)
		AngRes.Text =  "RESET" 
		AngRes.Font =  "S_Light_15" 
		AngRes.FakeActivated =  true
		AngRes:SetBorders(false)
		AngRes.DoClick = function(s)
			Ang:SetValue(angc)
		end 
	end
end

m_pnlPanel.ItemLoadDefault = function(s)
	-- table.insert(AA_add, item.id) 
	local mdl = LocalPlayer():GetModel()
	
	-- Небольшой фикс причурной ошибки #1
	-- if item and item.type == 'model' then
		-- mdl = item.data.mdl
	-- end
	-- print(mdl)
	m_pnlPreviewVGUI:SetModel(mdl)
	m_pnlPreviewVGUI.ScaleC = nil
	m_pnlPreviewVGUI.PosCX = nil
	m_pnlPreviewVGUI.PosCY = nil
	m_pnlPreviewVGUI.PosCZ = nil
	m_pnlPreviewVGUI.AngCX = nil
	m_pnlPreviewVGUI.AngCY = nil
	m_pnlPreviewVGUI.AngCZ = nil
	m_pnlPreviewVGUI.BodyGroupsC = nil
	m_pnlPreviewVGUI.SkinC = nil

	for item_id, model in pairs( m_pnlPreviewVGUI.ToRender) do
		print(item_id)
		model:Remove()
	end
	s.ToRender = {}
	if SetSelected then 
		-- TempSets[SetSelected].items[AA_last] = true
		for item_id, data in pairs(TempSets[SetSelected].items) do
			local item = TTS.Shop.Data.Items[item_id]
			if type(data) == 'table' then
				PrintTable(data)
				print(item.name)
			end
			m_pnlPanel:ItemLoad(item, false, type(data) == 'table' and data or false)
		end
	end
	
	if IsValid(s.cpanscroll) then
		s.cpanscroll:Remove()
	end
end
-- local 
m_pnlPanel.Paint = function( s, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
	-- draw.SimpleText('Привет!', 'S_Bold_15', w/2, 10, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('Это временная инструкция.', 'S_Regular_15', w/2, 15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('Это сеты предметов, пока', 'S_Regular_15', w/2, 20+15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('тут скромный функционал', 'S_Regular_15', w/2, 20+15+15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('но, в будущем будет побольше.', 'S_Regular_15', w/2, 20+15+15+15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('Надеть сет можно строго один,', 'S_Regular_15', w/2, 20+15+15+15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('Конфигурировать можно по разному:', 'S_Regular_15', w/2, 20+15+15+15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText('дублировать сеты, ', 'S_Bold_15', w/2, 20+15+15+15+15, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local m_pnlDranNDrop = vgui.Create(".CCPanel", m_pnlPointshopBodyGroups)
m_pnlDranNDrop:SetSize(_w/3, 0) 
m_pnlDranNDrop:Dock(LEFT) 
m_pnlDranNDrop:DockMargin(0, 0, 0, 0)  
m_pnlDranNDrop:DockPadding(0, 0, 0, 0)
m_pnlDranNDrop.Paint = function( s, w, h ) end

function m_pnlDranNDrop:OnSizeChanged()
	local wDragnDrop_w, wDragnDrop_h = m_pnlDranNDrop:GetSize()
	local SetEquipped = vgui.Create('.CCPanel', m_pnlDranNDrop)
	SetEquipped:SetSize(0, (wDragnDrop_h/2)-2.5)
	SetEquipped:Dock(TOP)
	SetEquipped:DockMargin(0, 0, 0, 5) 
	SetEquipped:DockPadding(0, 0, 0, 0)
	-- local _oldpaint = SetEquipped.Paint
	-- SetEquipped.Paint = function( s, w, h )
		-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,130))
		-- _oldpaint( s, w, h )
	-- end
	
	local IsSetsVisible = true
	local BackButton, AddNewSetButton
	
	local TitleSetEquipped = vgui.Create('.CCPanel', SetEquipped)
	TitleSetEquipped:SetSize(0, 20)
	TitleSetEquipped:Dock(TOP)
	-- local _oldpaint = TitleSetEquipped.Paint
	TitleSetEquipped.Paint = function( s, w, h )
		-- draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
		draw.SimpleText(IsSetsVisible and 'Выбор сета' or TempSets[SetSelected].Name, 'S_Regular_15', IsSetsVisible and 5 or 20, 10, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		-- _oldpaint( s, w, h )
	end
	TitleSetEquipped.Think = function( s )
		if IsValid(BackButton) then
			if IsSetsVisible and BackButton:IsVisible() then
				BackButton:SetVisible(false)
				AddNewSetButton:SetVisible(true)
				EditNewSetButton:SetVisible(false)
				
				SelectSetButton:SetVisible(false)
				
				CallSetsGridVisible()
			end
			if !IsSetsVisible and !BackButton:IsVisible() then
				BackButton:SetVisible(true)
				AddNewSetButton:SetVisible(false)
				EditNewSetButton:SetVisible(true)
				
				SelectSetButton:SetVisible(true)
				if TempSets[SetSelected].Enabled then
					SelectSetButton:Enable()
				else
					SelectSetButton:Disable()
				end
				CallSetVisible()
	
			end
		end
	end

	BackButton = vgui.Create( "DHTML" , TitleSetEquipped )
	BackButton:SetPos( 0, 0 )
	BackButton:SetSize( 20, 20 )
	BackButton:SetAllowLua( true )
	BackButton:SetVisible(true)
	BackButton:AddFunction("button", "back", function()
		SetSelected = false
		IsSetsVisible = true
		m_pnlPanel:ItemLoadDefault()
	end)
	BackButton:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 4px;
		-webkit-user-select: none;
		}
	</style>
	<body onclick='button.back()' >
		<img style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgNDQzLjUyIDQ0My41MiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgNDQzLjUyIDQ0My41MjsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiBjbGFzcz0iIj48Zz48Zz4KCTxnPgoJCTxwYXRoIGQ9Ik0xNDMuNDkyLDIyMS44NjNMMzM2LjIyNiwyOS4xMjljNi42NjMtNi42NjQsNi42NjMtMTcuNDY4LDAtMjQuMTMyYy02LjY2NS02LjY2Mi0xNy40NjgtNi42NjItMjQuMTMyLDBsLTIwNC44LDIwNC44ICAgIGMtNi42NjIsNi42NjQtNi42NjIsMTcuNDY4LDAsMjQuMTMybDIwNC44LDIwNC44YzYuNzgsNi41NDgsMTcuNTg0LDYuMzYsMjQuMTMyLTAuNDJjNi4zODctNi42MTQsNi4zODctMTcuMDk5LDAtMjMuNzEyICAgIEwxNDMuNDkyLDIyMS44NjN6IiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBjbGFzcz0iYWN0aXZlLXBhdGgiIGRhdGEtb2xkX2NvbG9yPSIjMDAwMDAwIiBzdHlsZT0iZmlsbDojRkZGRkZGIj48L3BhdGg+Cgk8L2c+CjwvZz48L2c+IDwvc3ZnPg==" />
</body>
	]] )
	
	AddNewSetButton = vgui.Create( "DHTML" , TitleSetEquipped ) 
	AddNewSetButton:SetPos( wDragnDrop_w-1-16, 1 )
	AddNewSetButton:SetSize( 18, 18 )
	AddNewSetButton:SetAllowLua( true ) 
	AddNewSetButton:SetVisible(false) 
	AddNewSetButton:AddFunction("button", "add", function() 
	
	
		if IsValid(m_pnlPanel.cpanscroll) then
			m_pnlPanel.cpanscroll:Remove()
		end
		
		m_pnlPanel.cpanscroll = vgui.Create("DScrollPanel", m_pnlPanel)
		m_pnlPanel.cpanscroll:SetSize( 200, 400 )
		m_pnlPanel.cpanscroll:Dock(FILL)
		m_pnlPanel.cpanscroll.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,150))
		end
		
		local pnl = m_pnlPanel.cpanscroll
		
		local createdDlabel = vgui.Create( "DLabel", pnl )
		createdDlabel:Dock( TOP )
		createdDlabel:SetFont( "S_Light_15" )
		createdDlabel:SetText( 'Создание нового сета' )
		createdDlabel:DockMargin(5, 5, 0, 0)
		pnl:AddItem(createdDlabel)
		
		local nameent = vgui.Create(".CCTextEntry", pnl)
		nameent:SetTextColor( Color(0, 0, 0, 255) ) 
		nameent:SetTall(24)
		nameent:DockMargin(0, 0, 0, 0)
		nameent:Dock(TOP)
		nameent.Font = "S_Light_15"
		nameent.XPos = 10
		nameent.TextAlignX = TEXT_ALIGN_LEFT
		nameent.TextAlignY = TEXT_ALIGN_CENTER
		nameent:SetPlaceholderText( "Название сета" )
		pnl.nameent = nameent
		pnl:AddItem(nameent)

	end)
	AddNewSetButton:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 2px;
		-webkit-user-select: none;
		}
	</style>
		<img onclick='button.add()' style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgNDA5LjYgNDA5LjYiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDQwOS42IDQwOS42OyIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgd2lkdGg9IjUxMiIgaGVpZ2h0PSI1MTIiIGNsYXNzPSIiPjxnPjxnPgoJPGc+CgkJPHBhdGggZD0iTTM5Mi41MzMsMTg3LjczM0gyMjEuODY3VjE3LjA2N0MyMjEuODY3LDcuNjQxLDIxNC4yMjYsMCwyMDQuOCwwcy0xNy4wNjcsNy42NDEtMTcuMDY3LDE3LjA2N3YxNzAuNjY3SDE3LjA2NyAgICBDNy42NDEsMTg3LjczMywwLDE5NS4zNzQsMCwyMDQuOHM3LjY0MSwxNy4wNjcsMTcuMDY3LDE3LjA2N2gxNzAuNjY3djE3MC42NjdjMCw5LjQyNiw3LjY0MSwxNy4wNjcsMTcuMDY3LDE3LjA2NyAgICBzMTcuMDY3LTcuNjQxLDE3LjA2Ny0xNy4wNjdWMjIxLjg2N2gxNzAuNjY3YzkuNDI2LDAsMTcuMDY3LTcuNjQxLDE3LjA2Ny0xNy4wNjdTNDAxLjk1OSwxODcuNzMzLDM5Mi41MzMsMTg3LjczM3oiIGRhdGEtb3JpZ2luYWw9IiMwMDAwMDAiIGNsYXNzPSJhY3RpdmUtcGF0aCIgZGF0YS1vbGRfY29sb3I9IiMwMDAwMDAiIHN0eWxlPSJmaWxsOiNGRkZGRkYiPjwvcGF0aD4KCTwvZz4KPC9nPjwvZz4gPC9zdmc+" />
	]] )
	
	EditNewSetButton = vgui.Create( "DHTML" , TitleSetEquipped ) 
	EditNewSetButton:SetPos( wDragnDrop_w-2-16, 2 )
	EditNewSetButton:SetSize( 16, 16)
	EditNewSetButton:SetAllowLua( true ) 
	EditNewSetButton:SetVisible(false)
	EditNewSetButton:AddFunction("button", "add", function()
	
	
		if IsValid(m_pnlPanel.cpanscroll) then
			m_pnlPanel.cpanscroll:Remove()
		end
		
		m_pnlPanel.cpanscroll = vgui.Create("DScrollPanel", m_pnlPanel)
		m_pnlPanel.cpanscroll:SetSize( 200, 400 )
		m_pnlPanel.cpanscroll:Dock(FILL)
		m_pnlPanel.cpanscroll.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(135, 35, 35,150))
		end
		
		local pnl = m_pnlPanel.cpanscroll
		
		local createdDlabel = vgui.Create( "DLabel", pnl )
		createdDlabel:Dock( TOP )
		createdDlabel:SetFont( "S_Light_15" )
		createdDlabel:SetText( 'Изменение сета ' .. TempSets[SetSelected].Name )
		createdDlabel:DockMargin(5, 5, 0, 0)
		pnl:AddItem(createdDlabel)
		
		local nameedit = vgui.Create(".CCTextEntry", pnl)
		nameedit:SetTextColor( Color(0, 0, 0, 255) ) 
		nameedit:SetTall(24)
		nameedit:DockMargin(0, 0, 0, 0)
		nameedit:Dock(TOP)
		nameedit.Font = "S_Light_15"
		nameedit.XPos = 10
		nameedit.TextAlignX = TEXT_ALIGN_LEFT
		nameedit.TextAlignY = TEXT_ALIGN_CENTER
		nameedit:SetPlaceholderText( "Название сета" )
		nameedit:SetValue( TempSets[SetSelected].Name )
		pnl.nameedit = nameedit
		pnl:AddItem(nameedit)

		local createdDlabel = vgui.Create( "DLabel", pnl )
		createdDlabel:Dock( TOP )
		createdDlabel:SetFont( "S_Light_15" )
		createdDlabel:SetText( 'Действия с предметами из сета' )
		createdDlabel:DockMargin(5, 10, 0, 0)
		pnl:AddItem(createdDlabel)
		
		local items = table.GetKeys(TempSets[SetSelected].items)
		for _,v in pairs(items) do
			local item = TTS.Shop.Data.Items[v]
			
			local m_button = pnl:Add(".CCButton", pnl)
			m_button.Font = "S_Regular_15"
			m_button:SetSize( 0,25 )  
			m_button:Dock( TOP )
			m_button.Text = item.name
			m_button:SetBorders(false)
			m_button.SetSelected = SetSelected
			m_button.Think = function( s ) 
				if s.SetSelected and item.id and !TempSets[s.SetSelected].items[item.id] then
					s:Remove() 
				end
			end
			m_button.DoClick = function( s ) 
				-- local data = TempSets[SetSelected].items[v]
				-- m_pnlPanel:ItemLoadDefault()
				-- m_pnlPanel:ItemLoad(item, false, type(data) == 'table' and data or false)
				local m_pnlCallQuery2
				m_pnlCallQuery = vgui.Create(".CCQuery")
				m_pnlCallQuery:SetSize(250,200)
				m_pnlCallQuery:SetTextTitle('Действие с ' .. item.name)
				m_pnlCallQuery:SetTextDescription('Ты выбрал предмет, что ты хочешь с ним сделать?')
				m_pnlCallQuery2 = m_pnlCallQuery
				local btn1, btn2, btn3
				local btn = m_pnlCallQuery:CreateDropDown('Скопировать в другой сет')
				for i,v in pairs(TempSets) do
					if i ~= SetSelected then 
						btn:AddChoice(v.Name, i)
					end
				end
				btn.OnSelect = function( panel, index, aa )
					local sp, data_id = panel:GetSelected()
					local data = TempSets[data_id]
					btn.Think = function(s)
						s.LerpedColorRewrite = s.LerpedColorRewrite - 1.5
						if s.LerpedColorRewrite < 1 then
							s.Think = nil
							s.LerpedColorRewrite = nil
							s:SetDisabled(false)
							s.Text = 'Скопировать в другой сет'
						end
					end
					btn.LerpedColorRewrite = 255
					btn.Text = 'Скопировано в сет '.. data.Name
					btn:SetDisabled(true)
					
					AA_last = item.id
					
					netstream.Start("TTS.Shop:ValidateEquipItem", AA_last, {
						selected = table.GetKeys(TempSets[data_id].items),
						only = TempSets[SetSelected].items[AA_last]
					})
					_SetSelected = SetSelected
					SetSelected = data_id
					
					hook.Add("FBG:ValidateFinish", "RunFunc", function()
						hook.Remove("FBG:ValidateFinish", "RunFunc")
						AA_last = false
						SetSelected = _SetSelected
						_SetSelected = nil
					end)
				end
				-- , function(self)
					-- self:Remove()
					
					-- m_pnlCallQuery = vgui.Create(".CCQuery")
					-- m_pnlCallQuery:SetSize(250,200)
					-- m_pnlCallQuery:SetTextTitle('Копипаст ' .. item.name)
					-- m_pnlCallQuery:SetTextDescription('В какой сет ты хочешь скопировать предмет?')
				-- end)
				
				
				-- btn.FakeActivated = true
				-- btn.LerpedColor = Color(90, 250, 90)
				-- local btn = m_pnlCallQuery:CreateButton('Переместить в другой сет', function(self)
				btn1 = btn 
				local btn = m_pnlCallQuery:CreateDropDown('Переместить в другой сет')
				for i,v in pairs(TempSets) do
					if i ~= SetSelected then 
						btn:AddChoice(v.Name, i)
					end 
				end
				btn.OnSelect = function( panel, index, aa )
					local sp, data_id = panel:GetSelected()
					local data = TempSets[data_id]
					btn.Think = function(s)
						s.LerpedColorRewrite = s.LerpedColorRewrite - 1.5
						if s.LerpedColorRewrite < 40 then
							s.Think = nil
							s.LerpedColorRewrite = nil 
							-- s:SetDisabled(false)
							-- s.Text = 'Переместить в другой сет'
							-- m_pnlCallQuery:Remove()
						end
					end
					btn.LerpedColorRewrite = 255
					btn.Text = 'Перемещено в сет '.. data.Name
					btn:SetDisabled(true)
					
					_AA_last = item.id 
					
					netstream.Start("TTS.Shop:ValidateEquipItem", _AA_last, {
						selected = table.GetKeys(TempSets[data_id].items),
						only = TempSets[SetSelected].items[_AA_last]
					})
					_SetSelected = SetSelected
					SetSelected = data_id
					AA_last = item.id        
					
					hook.Add("FBG:ValidateFinish", "RunFunc", function()
						hook.Remove("FBG:ValidateFinish", "RunFunc")
						-- print(_SetSelected, _AA_last)
						TempSets[_SetSelected].items[_AA_last] = nil
						SetSelected = _SetSelected
						_AA_last = nil
						_SetSelected = nil
						CallSetVisible()
						m_pnlCallQuery2:SetTextDescription('Предмет ' .. item.name .. ' перенесен в сет ' .. data.Name .. '. Ты можешь закрыть окно.')
						btn1:SetDisabled(true)
						btn2:SetDisabled(true)
						btn2:SetBorders( FULL )
						btn3:SetBorders( false )
						-- btn3:SetDisabled(true)
					end)
				end
					-- SetSelected = i
					-- hook.Add("FBG:ValidateFinish", "RunFunc", function()
						-- func()
					-- end)
					-- m_buttonAddToSet:DoClick()
					-- self:Remove()
				-- end)
				-- btn.FakeActivated = true
				local btn = m_pnlCallQuery:CreateButton('Удалить из выбранного сета', function(self)
          TempSets[SetSelected].items[item.id] = nil
          savedata()
					CallSetVisible()
					self:Remove()
				end)
				btn2 = btn
				btn.LerpedColor = Color(250, 90, 90)
				local btn = m_pnlCallQuery:CreateButton('Закрыть', function(self)
					self:Remove()
				end)
				btn3 = btn
				btn.LerpedColor = Color(75, 150, 75)
				btn:SetBorders( FULL )
				btn.FakeActivated = true
			end
			-- m_button:DoClick()
		end
	end)
	EditNewSetButton:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 2px;
		-webkit-user-select: none;
		}
	</style>
		<img onclick='button.add()' style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgNTEyIDUxMiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgNTEyIDUxMjsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiBjbGFzcz0iIj48Zz48Zz4KCTxnPgoJCTxwb2x5Z29uIHBvaW50cz0iNTEuMiwzNTMuMjggMCw1MTIgMTU4LjcyLDQ2MC44ICAgIiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBjbGFzcz0iYWN0aXZlLXBhdGgiIGRhdGEtb2xkX2NvbG9yPSIjMDAwMDAwIiBzdHlsZT0iZmlsbDojRkZGRkZGIj48L3BvbHlnb24+Cgk8L2c+CjwvZz48Zz4KCTxnPgoJCQoJCQk8cmVjdCB4PSI4OS43MyIgeT0iMTY5LjA5NyIgdHJhbnNmb3JtPSJtYXRyaXgoMC43MDcxIC0wLjcwNzEgMC43MDcxIDAuNzA3MSAtOTUuODU3NSAyNjAuMzcxOSkiIHdpZHRoPSIzNTMuMjc3IiBoZWlnaHQ9IjE1My41OTkiIGRhdGEtb3JpZ2luYWw9IiMwMDAwMDAiIGNsYXNzPSJhY3RpdmUtcGF0aCIgZGF0YS1vbGRfY29sb3I9IiMwMDAwMDAiIHN0eWxlPSJmaWxsOiNGRkZGRkYiPjwvcmVjdD4KCTwvZz4KPC9nPjxnPgoJPGc+CgkJPHBhdGggZD0iTTUwNC4zMiw3OS4zNkw0MzIuNjQsNy42OGMtMTAuMjQtMTAuMjQtMjUuNi0xMC4yNC0zNS44NCwwbC0yMy4wNCwyMy4wNGwxMDcuNTIsMTA3LjUybDIzLjA0LTIzLjA0ICAgIEM1MTQuNTYsMTA0Ljk2LDUxNC41Niw4OS42LDUwNC4zMiw3OS4zNnoiIGRhdGEtb3JpZ2luYWw9IiMwMDAwMDAiIGNsYXNzPSJhY3RpdmUtcGF0aCIgZGF0YS1vbGRfY29sb3I9IiMwMDAwMDAiIHN0eWxlPSJmaWxsOiNGRkZGRkYiPjwvcGF0aD4KCTwvZz4KPC9nPjwvZz4gPC9zdmc+" />
	]] )  
	
	SelectSetButton = vgui.Create( "DHTML" , TitleSetEquipped ) 
	SelectSetButton:SetPos( wDragnDrop_w-2-16-3-16, 1 )
	SelectSetButton:SetSize( 18, 18)
	SelectSetButton:SetAllowLua( true ) 
	SelectSetButton:SetVisible(false) 
	SelectSetButton:AddFunction("button", "add", function()
		for id, _ in pairs(TempSets) do
			TempSets[id].Enabled = false 
		end
		if TempSets[SetSelected].Enabled then
			TempSets[SetSelected].Enabled = nil
			SelectSetButton:Disable()
		else
			TempSets[SetSelected].Enabled = true
			SelectSetButton:Enable()
		end
		
    netstream.Start("TTS.Shop:EquipSetWithClear", TempSets[SetSelected].items)
    savedata()
	end)
	SelectSetButton.Enable = function(s)
		s:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 2px;
		-webkit-user-select: none;
		}
	</style>
		<img onclick='button.add()' style="width:100%;height: 100%" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHN0eWxlPSJ3aWR0aDoyNHB4O2hlaWdodDoyNHB4IiB2aWV3Qm94PSIwIDAgMjQgMjQiPgogICAgPHBhdGggZmlsbD0iI0ZGRkZGRiIgZD0iTTExLjgzLDlMMTUsMTIuMTZDMTUsMTIuMTEgMTUsMTIuMDUgMTUsMTJBMywzIDAgMCwwIDEyLDlDMTEuOTQsOSAxMS44OSw5IDExLjgzLDlNNy41Myw5LjhMOS4wOCwxMS4zNUM5LjAzLDExLjU2IDksMTEuNzcgOSwxMkEzLDMgMCAwLDAgMTIsMTVDMTIuMjIsMTUgMTIuNDQsMTQuOTcgMTIuNjUsMTQuOTJMMTQuMiwxNi40N0MxMy41MywxNi44IDEyLjc5LDE3IDEyLDE3QTUsNSAwIDAsMSA3LDEyQzcsMTEuMjEgNy4yLDEwLjQ3IDcuNTMsOS44TTIsNC4yN0w0LjI4LDYuNTVMNC43Myw3QzMuMDgsOC4zIDEuNzgsMTAgMSwxMkMyLjczLDE2LjM5IDcsMTkuNSAxMiwxOS41QzEzLjU1LDE5LjUgMTUuMDMsMTkuMiAxNi4zOCwxOC42NkwxNi44MSwxOS4wOEwxOS43MywyMkwyMSwyMC43M0wzLjI3LDNNMTIsN0E1LDUgMCAwLDEgMTcsMTJDMTcsMTIuNjQgMTYuODcsMTMuMjYgMTYuNjQsMTMuODJMMTkuNTcsMTYuNzVDMjEuMDcsMTUuNSAyMi4yNywxMy44NiAyMywxMkMyMS4yNyw3LjYxIDE3LDQuNSAxMiw0LjVDMTAuNiw0LjUgOS4yNiw0Ljc1IDgsNS4yTDEwLjE3LDcuMzVDMTAuNzQsNy4xMyAxMS4zNSw3IDEyLDdaIiAvPgo8L3N2Zz4=" />
	]] )
	end
	SelectSetButton.Disable = function(s)
		s:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 2px;
		-webkit-user-select: none;
		}
	</style>
		<img onclick='button.add()' style="width:100%;height: 100%" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHN0eWxlPSJ3aWR0aDoyNHB4O2hlaWdodDoyNHB4IiB2aWV3Qm94PSIwIDAgMjQgMjQiPgogICAgIDxwYXRoIGZpbGw9IiNGRkZGRkYiIGQ9Ik0xMiw5QTMsMyAwIDAsMCA5LDEyQTMsMyAwIDAsMCAxMiwxNUEzLDMgMCAwLDAgMTUsMTJBMywzIDAgMCwwIDEyLDlNMTIsMTdBNSw1IDAgMCwxIDcsMTJBNSw1IDAgMCwxIDEyLDdBNSw1IDAgMCwxIDE3LDEyQTUsNSAwIDAsMSAxMiwxN00xMiw0LjVDNyw0LjUgMi43Myw3LjYxIDEsMTJDMi43MywxNi4zOSA3LDE5LjUgMTIsMTkuNUMxNywxOS41IDIxLjI3LDE2LjM5IDIzLDEyQzIxLjI3LDcuNjEgMTcsNC41IDEyLDQuNVoiIC8+Cjwvc3ZnPg==" />
	]] )
	end
	
	CallSetVisible = function()
		if IsValid(FillCleaner) then 
			FillCleaner:Remove()
		end
		
		FillCleaner = vgui.Create("DScrollPanel", SetEquipped)
		FillCleaner:Dock( FILL )
		
		
		function FillCleaner:OnSizeChanged()
			local _wFC, _hFC = FillCleaner:GetSize()
			local SetsGrid = vgui.Create( "DScrollPanel", FillCleaner ) 
			SetsGrid:SetSize(_wFC, _hFC)
			
			
			local items = table.GetKeys(TempSets[SetSelected].items)
			for _,v in pairs(items) do
				local item = TTS.Shop.Data.Items[v]
				
				local m_button = SetsGrid:Add(".CCButton", SetsGrid)
				m_button.Font = "S_Regular_15"
				m_button:SetSize( 0,25 )  
				m_button:Dock( TOP )
				m_button.Text = item.name
				m_button:SetBorders(false)
				m_button.DoClick = function( s ) 
					-- PrintTable(item)
					
					
					-- TempSets[SetSelected].items) do
					-- local item = TTS.Shop.Data.Items[item_id]
					
					-- m_pnlPanel:ItemLoad(item, false, type(data) == 'table' and data or false)
					
					local data = TempSets[SetSelected].items[v]
					m_pnlPanel:ItemLoadDefault()
					m_pnlPanel:ItemLoad(item, false, type(data) == 'table' and data or false)
					
					-- IsSeeInventory = false
					-- CategorySelected = Name
					-- CallCategoryVisible()
					
				end
				-- m_button:DoClick()
			end
		end
		-- local SetsGrid = vgui.Create( ".CCPanel", FillCleaner ) 
		-- SetsGrid:Dock( FILL )
		
		
	end
	CallSetsGridVisible = function()
		if IsValid(FillCleaner) then 
			FillCleaner:Remove()
		end
		
		FillCleaner = vgui.Create("DScrollPanel", SetEquipped)
		FillCleaner:Dock( FILL )
		
		
		
		
		-- local SetsGrid = vgui.Create( "DScrollPanel", FillCleaner ) 
		-- SetsGrid:Dock( FILL )
		
		
		function FillCleaner:OnSizeChanged()
			local _wFC, _hFC = FillCleaner:GetSize()
			local SetsGrid = vgui.Create( "DScrollPanel", FillCleaner ) 
			SetsGrid:SetSize(_wFC, _hFC)
		
			
			for i,v in pairs(TempSets) do
			
				local SelectSet = SetsGrid:Add(".CCButton", SetsGrid)
				SelectSet.Font = "S_Regular_15"
				SelectSet:SetSize( 0,25 )  
				SelectSet:Dock( TOP )
				SelectSet.Text = v.Name
				SelectSet:SetBorders(false)
				-- local SelectSet = vgui.Create( "DButton" ) // SetEquipped:Add( "DButton" )
				-- SelectSet:SetText( v.Name )
				-- SelectSet:Dock( TOP )
				-- SelectSet:DockMargin( 0, 0, 0, 5 )
				SelectSet.DoClick = function(s)
				
					local func = function()
						IsSetsVisible = false
						SetSelected = i
						CallSetVisible()
						m_pnlPanel:ItemLoadDefault()
						AA_last_model = false
						hook.Remove("FBG:ValidateFinish", "RunFunc")
					end
				
				
					if IsValid(AA_last_model) then
						local model = AA_last_model
						if model.ScaleC
							or model.PosCX 
							or model.PosCY 
							or model.PosCZ 
							or model.AngCX
							or model.AngCY 
							or model.AngCZ 
							or model.BodyGroupsC
							or model.SkinC then

							m_pnlCallQuery = vgui.Create(".CCQuery")
							m_pnlCallQuery:SetTextTitle('Проблема с ' .. TempSets[i].Name)
							m_pnlCallQuery:SetTextDescription('У тебя сейчас выбран предмет и изменена конфигурация. Выбрав сет, ты хочешь:')
							
							local btn = m_pnlCallQuery:CreateButton('Просто хочу открыть сет', function(self)
								func()
								self:Remove()
							end)
							btn.FakeActivated = true
							btn.LerpedColor = Color(90, 250, 90)
							local btn = m_pnlCallQuery:CreateButton('Добавить предмет в сет', function(self)
								SetSelected = i
								hook.Add("FBG:ValidateFinish", "RunFunc", function()
									func()
								end)
								m_buttonAddToSet:DoClick()
								self:Remove()
							end)
							btn.FakeActivated = true
							local btn = m_pnlCallQuery:CreateButton('Ой, я случайно. Отменить', function(self)
								self:Remove()
							end)
							btn.LerpedColor = Color(250, 90, 90)
							-- print('123')
						else
							func()
						end
					else
						func()
					end
				
				end
				
				local _mPaint = SelectSet.Paint
				local equippedicon = Material("icon16/eye.png")
				SelectSet.Paint = function( s, w, h )
					_mPaint(s, w, h)
					
					if v.Enabled then 
						-- if TempSets[SetSelected].items[item.id] then
							surface.SetMaterial(equippedicon)
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(w - 5 - 16, h/2-8, 16, 16)
						-- end
					end
				end
				SetsGrid:AddItem(SelectSet)
			end
		end
	end

	-- for i=0, 100 do
	-- SetsGrid:Rebuild()
	-- end

	local Equipped = vgui.Create('.CCPanel', m_pnlDranNDrop)
	Equipped:SetSize(0, (wDragnDrop_h/2)-2.5)
	Equipped:Dock(BOTTOM)
	Equipped:DockMargin(0, 0, 0, 0)  
	Equipped:DockPadding(0, 0, 0, 0)
	-- local _oldpaint = Equipped.Paint
	-- Equipped.Paint = function( s, w, h )
		-- draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,130))
		-- _oldpaint( s, w, h )
	-- end  
	
	
	local IsSeeInventory, CategorySelected = true, false
	local InvBackButton, AddNewSetButton
	local CallCategoryVisible, CallInvVisible
	local FillCleanerInv
	local TitleEquipped = vgui.Create('.CCPanel', Equipped)
	TitleEquipped:SetSize(0, 20)
	TitleEquipped:Dock(TOP)
	-- local _oldpaint = TitleSetEquipped.Paint
	TitleEquipped.Paint = function( s, w, h )
		-- draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35,230))
		draw.SimpleText(IsSeeInventory and 'Инвентарь - Категории' or 'Инвентарь - Категория "' .. CategorySelected .. '"', 'S_Regular_15', IsSeeInventory and 5 or 20, 10, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		-- _oldpaint( s, w, h )
	end
	TitleEquipped.Think = function( s )
		if IsValid(BackButton) then
			if IsSeeInventory and  InvBackButton:IsVisible() then
				InvBackButton:SetVisible(false)
				-- AddNewSetButton:SetVisible(true)
				CallInvVisible()
			end
			if !IsSeeInventory and !InvBackButton:IsVisible() then
				InvBackButton:SetVisible(true)
				-- AddNewSetButton:SetVisible(false)
				CallCategoryVisible()
	
			end
		end
	end

	InvBackButton = vgui.Create( "DHTML" , TitleEquipped )
	InvBackButton:SetPos( 0, 0 )
	InvBackButton:SetSize( 20, 20 )
	InvBackButton:SetAllowLua( true )
	InvBackButton:SetVisible(true)
	InvBackButton:AddFunction("button", "back", function()
		-- BackButton:SetVisible(false)
		CategorySelected = false
		IsSeeInventory = true
		-- MsgC(color_green, str) -- Print the given string
	end)
	InvBackButton:SetHTML( [[
	<style>
		body {
		margin: 0;
		padding: 4px;
		-webkit-user-select: none;
		}
	</style>
	<body onclick='button.back()' >
		<img style="width:100%;height: 100%" src="data:image/svg+xml;base64,
PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHg9IjBweCIgeT0iMHB4IiB2aWV3Qm94PSIwIDAgNDQzLjUyIDQ0My41MiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgNDQzLjUyIDQ0My41MjsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiBjbGFzcz0iIj48Zz48Zz4KCTxnPgoJCTxwYXRoIGQ9Ik0xNDMuNDkyLDIyMS44NjNMMzM2LjIyNiwyOS4xMjljNi42NjMtNi42NjQsNi42NjMtMTcuNDY4LDAtMjQuMTMyYy02LjY2NS02LjY2Mi0xNy40NjgtNi42NjItMjQuMTMyLDBsLTIwNC44LDIwNC44ICAgIGMtNi42NjIsNi42NjQtNi42NjIsMTcuNDY4LDAsMjQuMTMybDIwNC44LDIwNC44YzYuNzgsNi41NDgsMTcuNTg0LDYuMzYsMjQuMTMyLTAuNDJjNi4zODctNi42MTQsNi4zODctMTcuMDk5LDAtMjMuNzEyICAgIEwxNDMuNDkyLDIyMS44NjN6IiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBjbGFzcz0iYWN0aXZlLXBhdGgiIGRhdGEtb2xkX2NvbG9yPSIjMDAwMDAwIiBzdHlsZT0iZmlsbDojRkZGRkZGIj48L3BhdGg+Cgk8L2c+CjwvZz48L2c+IDwvc3ZnPg==" />
</body>
	]] )
	CallCategoryVisible = function()
		if IsValid(FillCleanerInv) then 
			FillCleanerInv:Remove()
		end
		
		FillCleanerInv = vgui.Create("DScrollPanel", Equipped)
		FillCleanerInv:Dock( FILL )
		
		function FillCleanerInv:OnSizeChanged(_wFC, _hFC)
			-- local _wFC, _hFC = FillCleanerInv:GetSize()
			-- print(_wFC, _hFC)
			local SetsGrid = vgui.Create( "DScrollPanel", FillCleanerInv ) 
			SetsGrid:SetSize(_wFC, _hFC)
		
			local items = {}
			for perm_id,item_id in pairs(TTS.Shop.UserCategory[CategorySelected]) do
				items[item_id] = true
			end
			
			items = table.GetKeys(items)
			for _,v in pairs(items) do
				local item = TTS.Shop.Data.Items[v]
				
				local m_button = SetsGrid:Add(".CCButton", SetsGrid)
				m_button.Font = "S_Regular_15"
				m_button:SetSize( 0,25 )  
				m_button:Dock( TOP )
				m_button.Text = item.name
				m_button:SetBorders(false)
				
				local _mPaint = m_button.Paint
				local equippedicon = Material("icon16/eye.png")
				m_button.Paint = function( s, w, h )
					_mPaint(s, w, h)
					
					if SetSelected then 
						if TempSets[SetSelected].items[item.id] then
							surface.SetMaterial(equippedicon)
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(w - 5 - 16, h/2-8, 16, 16)
						end
					end
				end
				m_button.Think = function(s)
					if IsValid(s) then
						m_button:SetDisabled( SetSelected and TempSets[SetSelected].items[item.id] )
					end
				end
				m_button.DoClick = function( s ) 
					PrintTable(item)
					-- local data = 
					m_pnlPanel:ItemLoadDefault()
					m_pnlPanel:ItemLoad(item)
					
					-- TempSets[SetSelected].items) do
			-- local item = TTS.Shop.Data.Items[item_id]
			
			-- m_pnlPanel:ItemLoad(item, false, type(data) == 'table' and data or false)
					-- IsSeeInventory = false
					-- CategorySelected = Name
					-- CallCategoryVisible()
					
				end
				-- m_button:DoClick()
			end
		end
	end
	
	CallInvVisible = function()
		if IsValid(FillCleanerInv) then 
			FillCleanerInv:Remove() 
		end
		
		FillCleanerInv = vgui.Create("DScrollPanel", Equipped)
		FillCleanerInv:Dock( FILL )
		
		-- FillCleanerInv.Paint = function( s, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color(35, 135, 35,230))
		-- end
			
		
		
		
		function FillCleanerInv:OnSizeChanged()
			local _wFC, _hFC = FillCleanerInv:GetSize()
			local SetsGrid = vgui.Create( "DScrollPanel", FillCleanerInv ) 
			SetsGrid:SetSize(_wFC, _hFC)
		
			-- PrintTable(TTS.Shop.UserCategory)
			for Name,v in pairs(TTS.Shop.UserCategory) do
			-- netstream.Hook("TTS.Shop:ValidateEquipItem", function(ply, item_id, data) 
				local m_button = SetsGrid:Add(".CCButton", SetsGrid)
				m_button.Font = "S_Regular_15"
				m_button:SetSize( 20,25 )  
				m_button:Dock( TOP )
				m_button.Text = Name
				m_button:SetBorders(false)
				m_button.DoClick = function( s )
					IsSeeInventory = false
					CategorySelected = Name
					CallCategoryVisible()
					
				end
				-- m_button:DoClick()
			end
		end
	end
end  

end)
	-- RunConsoleCommand("tts_bodygroup_frame")
