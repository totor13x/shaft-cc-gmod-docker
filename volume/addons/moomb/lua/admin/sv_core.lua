print('sv')


function TTS.Admin:Msg(ply, msg)
	local essence = ChatMsg()
		:Add('[')
		:Add('TTS:ADM', Color(94, 130, 158))
		:Add('] ')

	-- PrintTable(msg) 
	for i, v in pairs(msg) do
		essence:Add(v[1], v[2])
	end

	essence:Send(ply)
	-- MsgC(Color(255,0,0), '[TTS.Admin] ' .. msg .. '\n')
end


hook.Add("TTS.PlayerInitialSpawn", "WS:Permissions/List", function(ply)
	ply.m_Permissions = {}
	ply.m_Roles = {}
	
	local data = ply.TTS.Data
	
  for _, userrole in pairs(data.roles) do
    if userrole.role then
      ply.m_Roles[userrole.role.slug] = true

      for _, permission in pairs(userrole.role.permissions) do
        ply.m_Permissions[permission.slug] = true
      end
    end
	end
	for _, userpermission in pairs(data.permissions) do
    if userpermission.permission then
      ply.m_Permissions[userpermission.permission.slug] = true
    end
	end

  for _, userrole in pairs(data.roles) do
    if userrole.role then
      if istable(userrole.role.data) then
        if userrole.role.data[TTS.Config.Server.id] then
          for slug, bool in pairs(userrole.role.data[TTS.Config.Server.id]) do
            -- print(slug, v)
            ply.m_Permissions[slug] = bool
          end
        end
      end
    end
  end

	netstream.Start(ply, 'WS:Permissions/List', ply.m_Permissions)
	netstream.Start(ply, 'WS:Roles/List', ply.m_Roles)
end)

-- local data = Entity(1).TTS.Data

-- for _, userrole in pairs(data.roles) do
--   if userrole.role then
--     if istable(userrole.role.data) then
--       if userrole.role.data[TTS.Config.Server.id] then
--         for slug, bool in pairs(userrole.role.data[TTS.Config.Server.id]) do
--           -- print(slug, v)
--           Entity(1).m_Permissions[slug] = bool
--         end
--       end
--     end
--   end
-- end
if WS.Bus.AdminController then
	WS:unsubscribe('server/admin') 
end
 
WS.Bus.AdminController = WS:subscribe('server/admin')

if TTS.DEBUG then
  concommand.Add('run_com', function(ply, cmd, args)
    -- table.remove(args, 1)
    -- PrintTable(args)
    RunConsoleCommand(unpack(args))
  end)
end
-- {
-- ["api_token"] = "27fa2c309c97e6c14a29758cce2be0e1cc98200f03f171c0c8733cc6e88f",
-- ["id"] = 12,
-- ["locks"] = { --[[ empty ]] },
-- ["permissions"] = { --[[ empty ]] },
-- ["roles"] = {
--     [1] = {
--         ["created_at"] = "2020-06-22 22:05:59",
--         ["id"] = 1,
--         ["immunity"] = 40,
--         ["name"] = "клоака",
--         ["permissions"] = {
--             [1] = {
--                 ["created_at"] = "2020-06-22 22:04:26",
--                 ["id"] = 1,
--                 ["name"] = "мут чата",
--                 ["pivot"] = {
--                     ["permission_id"] = 1,
--                     ["role_id"] = 1,
--                 },
--                 ["slug"] = "chat-mute",
--                 ["updated_at"] = "2020-06-22 22:05:30",
--             },
--         },
--         ["pivot"] = {
--             ["role_id"] = 1,
--             ["user_id"] = 12,
--         },
--         ["slug"] = "cloaca",
--         ["updated_at"] = "2020-10-16 17:31:21",
--     },
-- },
-- ["steamid"] = "7656119796