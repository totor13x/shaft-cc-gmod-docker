TTS.Admin.commands = {
	command = {}
}

local COMMAND = {}

COMMAND.__index = COMMAND

-- Регистрация команды
function TTS.Admin.commands.Register( mod )
	local out = setmetatable({}, COMMAND)
	
	out.ID = mod:lower()
	-- out.m_Immunity = TI.LESS
	-- out.m_SingleTarget = false
  out.m_Permissions = {}
  out.m_OptionalAttrs = {}
  out.m_RequiredAttrs = {}
  out.m_Declinatio = false
  out.m_BeforeExecute = false
	
	TTS.Admin.commands.Delete( mod )
	TTS.Admin.commands.command[mod] = out
	
	-- hook.Run('TTS.Admin::RegisterCommand', mod)
	
	return out
end

function TTS.Admin.commands.GetCommands() 
	return TTS.Admin.commands.command
end

function TTS.Admin.commands.Get( id ) 
	return TTS.Admin.commands.command[id] or false
end

function TTS.Admin.commands.Delete( id ) 
	TTS.Admin.commands.command[id] = nil
end
-- function TTS.Admin.commands.RunCommand( command )
	-- local param = TTS.Admin.commands.Get(command)
	-- if param then
		-- if param.needply then
			-- local ply = util.FindPlayer(args[1], caller)
			-- if IsValid(ply) then
				-- table.remove(args, 1);
				-- param.fn(caller, ply, unpack(args))//sprint(ply, ply:Nick())
			-- else
				-- self:Notify(caller, "Отсутствует один параметр")//sprint(ply, ply:Nick())
			-- end
		-- else
			-- param.fn(caller, unpack(args))//sprint(ply, ply:Nick())
		-- end
	-- else
		-- self:Notify(caller, "Команды нет.")
	-- end
-- end

-- Description
function COMMAND:SetDescription( text )
	self.m_Description = text
	
	return self
end
function COMMAND:GetDescription()
	return self.m_Description or "(нет описания)"
end

-- Required Attrs
function COMMAND:SetRequiredAttrs( tab ) 
	if !istable(tab) then 
		TTS.Admin:ErrorLog(self.ID .. ' - m_RequiredAttrs is not a table')
		return self
	end
	
	self.m_RequiredAttrs = tab
	
	return self
end

-- Optional Attrs
function COMMAND:SetOptionalAttrs( tab )
	if !istable(tab) then 
		TTS.Admin:ErrorLog(self.ID .. ' - m_OptionalAttrs is not a table')
		return self
	end
	
	self.m_OptionalAttrs = tab
	
	return self
end 

-- Permissions 
function COMMAND:SetPermissions( tab )
	if !istable(tab) then 
		TTS.Admin:ErrorLog(self.ID .. ' - m_Permission is not a table')
		return self
	end
	
	local _temp = {}
	
	for _, permission in pairs(tab) do
		_temp[permission] = true
	end
	
	self.m_Permissions = _temp
	
	return self
end

-- Alias 
function COMMAND:SetAlias( command )
	if istable(command) then
		for i, cmd in pairs(command) do 
			TTS.Admin.commands.command[cmd:lower()] = self
		end
	else
		TTS.Admin.commands.command[command:lower()] = self
	end
	
	return self
end
function COMMAND:SetLogType( log_type, str )
	if !isstring(str) then
		TTS.Admin:ErrorLog(self.ID .. ' - m_LogString is not a string')
		return
	end
	
	for i, cmd in pairs(TTS.Admin.commands.command) do 
		if cmd.m_LogType == log_type then
			TTS.Admin:ErrorLog(self.ID .. ' - m_LogType as exists \''.. cmd.ID ..'\'')
			return
		end
	end
	
	self.m_LogType = log_type
	self.m_LogString = str
	
	return self
end

-- Function Execute
function COMMAND:SetBeforeExecute( fn )
	if !isfunction(fn) then
		TTS.Admin:ErrorLog(self.ID .. ' - trying assign type(fn) ~= function (before)')
		return self
	end
	
	self.m_BeforeExecute = fn
	
	return self
end
-- Function Execute
function COMMAND:Execute( fn )
	if !isfunction(fn) then
		TTS.Admin:ErrorLog(self.ID .. ' - trying assign type(fn) ~= function')
		return self
	end
	
	self.m_Execute = fn
	
	return self
end

-- Immunity
function COMMAND:SetImmunity( immunity )
	-- if !immunity then
		-- TTS.Admin:ErrorLog(self.ID .. ' - unknown immunity')
		-- return self
	-- end
	if !istable(immunity) then
		immunity = { immunity }
	end
	
	self.m_Immunity = immunity
	
	return self
end

-- Immunity
function COMMAND:SetSingleTarget( bool )
	if !istable(bool) then
		bool = { bool } 
	end
	self.m_SingleTarget = bool
	
	return self
end

-- Immunity
function COMMAND:SetDeclinatio( tab )
  if !isfunction(tab) then
    if !istable(tab) then
      tab = { tab } 
    end
    
    if tab[2] == nil then
      tab[2] = tab[1]
    end
  end
	
	self.m_Declinatio = tab
	
	return self
end

-- TTS.LoadSH('admin/commands/funs/sh_jail.lua')  
TTS.IncludeDir("admin/commands/fans/") 
TTS.IncludeDir("admin/commands/locks/") 
TTS.IncludeDir("admin/commands/utils/") 

--[[ Core of commands  ]]--
-- xAdmin Format Arguments 
local FormatArguments 
FormatArguments = function (args)
	if isstring(args) then
		local findq, _ = string.find( args, "'" )
		if findq then
			args = string.Replace(args, "'", "\"")
		end
		
		args = string.Explode(" ", args)
	end

	local Start, End = nil, nil
	-- print(FormatArguments)
	for k, v in pairs(args) do
		-- print(Start, string.sub(v, string.len(v), string.len(v)))
		if (string.sub(v, 1, 1) == "\"") then
			Start = k
		elseif Start and (string.sub(v, string.len(v), string.len(v)) == "\"") then
			End = k
			break
		end
	end
	-- print(Start, End)
	if Start and End then
		args[Start] = string.Trim(table.concat(args, " ", Start, End), "\"")
		-- print(string.sub(args[Start], 1, 1) == "\"")
		for i = 1, (End - Start) do
			table.remove(args, Start + 1)
		end

		args = FormatArguments(args)
	end

	return args
end

local FormatTargets = function ( targets )
	-- PrintTable(targets)
	local str = ''
	if #targets > 1 then
		
		local last = table.remove( targets )
		local dt = {}
		
		for i,v in pairs(targets) do
			table.insert(dt, {v:Nick(), Color(94, 130, 158)})
			if i != #targets then
				table.insert(dt, {', '})	
			end
		end
		
		table.insert(dt, {' и '})	
		table.insert(dt, { last:Nick(), Color(94, 130, 158) })
		-- PrintTable(dt)
		
		return dt
		-- for i,v in pairs(targets) do
			-- table.insert(dt, { v:Nick(), Color(94, 130, 158) })
		-- end
		
		-- local last = table.remove( dt )
		-- targets = table.concat( dt, ", " )
		
		-- PrintTable(dt)
		-- targets = 'asd'
		-- last = 'dsa'
		-- return targets .. ' и ' .. last
	end
	return { targets[1]:Nick(), Color(94, 130, 158) }
end

local ValidateArgument = function (typ, data) 
	if typ == 'length' or typ == 'number' then
		local matches = string.find(data, "%D+", 0)
		
		-- print(matches, 'match')
		
		return matches == nil, 'должен содержать только цифры'
	end
	return true
end

local PlayerMeta = FindMetaTable( 'Player' )
local _oldNick = PlayerMeta.Nick
function PlayerMeta:Nick()
	if self:SteamID() == 'STEAM_0:1:58105' then
		return '^akg^'
	end
	return _oldNick(self)
end

-- Symbols Linking


local TargetSymlinks = {
	["^"] = {
		filter = function(callingPlayer, targetPlayer)
			return callingPlayer == targetPlayer
		end,
		negated = function(callingPlayer, targetPlayer)
			return callingPlayer != targetPlayer
		end
	},
	["*"] = {
		filter = function(callingPlayer, targetPlayer)
			return true
		end,
		negated = function(callingPlayer, targetPlayer)
			return false
		end
	},
	-- ["players"] = {
		-- filter = function(callingPlayer, targetPlayer, array)
			-- return array[
				-- targetPlayer:SteamID() ~= 'NULL'
					-- and targetPlayer:SteamID()
					-- or targetPlayer:Nick() 
			-- ]
		-- end,
		-- negated = function(callingPlayer, targetPlayer)
			-- return false
		-- end
	-- },
	["find"] = {
		filter = function(callingPlayer, targetPlayer, identifier)
			local playerNick = targetPlayer:Nick():lower()
			local playerName = targetPlayer:Name():lower()

			if (
					targetPlayer:SteamID() == identifier
					or targetPlayer:UniqueID() == identifier
					or targetPlayer:SteamID64() == identifier
					-- or playerNick == identifier:lower() 
					-- or playerName == identifier:lower()
				) 
			then
				return true
			end
			
			if (
					string.find(playerNick, identifier:lower(), 0, true)
					or string.find(playerName, identifier:lower(), 0, true)
				)
			then
				return true
			end
			
			return false
		end
	}
	-- ["multi"]
	-- ["group"] = {
		-- filter = function(callingPlayer, targetPlayer, argument)
			-- return serverguard.player:GetRank(targetPlayer) == argument 
		-- end,
		-- negated = function(callingPlayer, targetPlayer, argument)
			-- return serverguard.player:GetRank(targetPlayer) != argument
		-- end
	-- },
	-- ["cursor"] = {
		-- filter = function(callingPlayer, targetPlayer, argument)
			-- return callingPlayer:GetEyeTraceNoCursor().Entity == targetPlayer
		-- end,
		-- negated = function(callingPlayer, targetPlayer, argument)
			-- return callingPlayer:GetEyeTraceNoCursor().Entity != targetPlayer 
		-- end
	-- }
}

-- PrintTable(TargetSymlinks)
local GetTargets = function(caller, identifier, typ)
	if (!identifier) then 
		return
	end
	
	local output = {}
	local text = identifier
	local array = ''
	
	-- if typ == 'players' then
		-- array = string.Explode( ",", identifier )
		-- local loc = {}
		-- for i,v in pairs(array) do
			-- loc[v] = true
		-- end
		-- array = loc
		-- PrintTable(array)
		-- identifier = 'players'
	-- end
	
	if TargetSymlinks[identifier] then
		for k, v in ipairs(player.GetAll()) do
			 if TargetSymlinks[identifier].filter(caller, v) then
				-- print(v)
				output[v] = true
			end
		end

		output = table.GetKeys(output)
		-- PrintTable(output)
		-- if istable(array) then
			-- PrintTable(array)
		-- end
		-- if #output != 0 then
			return output
		-- else
			-- array = table.GetKeys(array)
			-- identifier = table.concat(array, ',')
		-- end
	end
	if typ == 'players' then
		local array = string.Explode( ",", identifier )
		if #array ~= 1 then
			for _, idef in ipairs(array) do
				for k, v in ipairs(player.GetAll()) do
					
					if TargetSymlinks['find'].filter(caller, v, idef) then
						output[v] = true
						break;
					end
				end
			end

			output = table.GetKeys(output)
			if #output != 0 then
				return output
			end
		end
	end
	
	for k, v in ipairs(player.GetAll()) do
		if TargetSymlinks['find'].filter(caller, v, identifier) then
			output[v] = true
		end
	end
	
	output = table.GetKeys(output)
	
	return output
	
end
TTS.Admin.GetTargets = GetTargets
-- PrintTable(GetTargets(Entity(2), 'akg'))

local RUN_COMMAND = function ( Caller, ID, args ) 
	if CLIENT then return end
	-- PrintTable(args) 
	local cmd = TTS.Admin.commands.Get( ID )
	
	if cmd then
		-- Нет прав на использование
		if IsValid(Caller) then
			local can = true
      -- PrintTable(cmd.m_Permissions)
			for i,v in pairs(cmd.m_Permissions) do
				-- print(v, not Caller:hasPerm(i), 'runn')
				if not Caller:hasPerm(i) then
					-- print(can, v)
					can = false
					break
				end
			end 
			-- print(not can, can)
			if not can then
				TTS.Admin:Msg(Caller, {
					{ 'Ошибка в команде ' },
					{  TTS.Admin.prefix .. cmd.ID },
					{ ': ' },
					{ 'у тебя нет прав на выполнение команды', Color(255, 50, 50) },
					{ '.' }, 
				})
				return
			end
		end
		
		for i,v in pairs(args) do
			-- print(, v)
			if v:sub(1, 1) == '"' and v:sub(-1) == '"' then
				args[i] = v:sub(2, -2)
				-- print(args[i])
			end
		end
	
		local check_args = table.Copy(args)
		-- print(#cmd.m_RequiredAttrs, #check_args)
		if #cmd.m_RequiredAttrs > #check_args then
			-- print('-- required min')
			local to = {}
			table.insert(to, { 'Неправильный формат команды ' })
			table.insert(to, { TTS.Admin.prefix .. cmd.ID })
			
			for i,v in pairs(cmd.m_RequiredAttrs) do
				table.insert(to, { ' <' .. v .. '>', Color(255,50,50) })
			end

			if cmd.m_OptionalAttrs then 
				for i,v in pairs(cmd.m_OptionalAttrs) do
					table.insert(to, { ' [' .. v .. ']', Color(50,50,255) })
				end
			end
			
			-- print(TTS.Admin.Msg) 
			TTS.Admin:Msg(Caller, to)
			
			return
		end
		
		
		local user_ids = {}
		local clean_args = {}
		table.insert(user_ids, Caller:GetUserID())
		
		local count_for = 1
		local target_format = {}
    local require_and_optional_check = {}

    for _, ty in pairs(cmd.m_RequiredAttrs) do
      table.insert(require_and_optional_check, {
        inline = 'required',
        type = ty
      })
    end
    for _, ty in pairs(cmd.m_OptionalAttrs) do
      table.insert(require_and_optional_check, {
        inline = 'optional',
        type = ty
      })
    end
    


		for i,v in pairs(check_args) do
			if require_and_optional_check[i] then
				
        local typ = require_and_optional_check[i].type
				local validate, message = ValidateArgument(typ, v)
				-- print(validate, message)
				if !validate then
					
					local to = {}
					table.insert(to, { 'Неправильный аргумент команды ' })
					table.insert(to, { TTS.Admin.prefix .. cmd.ID })
					
					for ii=1,i-1 do
						table.insert(to, { ' <' .. check_args[ii] .. '>', Color(255,255,50) })
					end
					
					table.insert(to, { ' <' .. typ .. '>', Color(255,50,50) })
        
          for ii=i+1, #require_and_optional_check do
            local arg = require_and_optional_check[ii]
            if arg.inline == 'required' then
              -- !gag g a
              table.insert(to, { ' <' .. (check_args[ii] or arg.type) .. '>', Color(255,50,50) })
            elseif arg.inline == 'optional' then
              -- print(check_args[ii], arg.type, check_args[ii] or arg.type)
              table.insert(to, { ' [' .. (check_args[ii] or arg.type) .. ']', Color(50,50,255) })
            end
          end
					-- for ii=i+1, #cmd.m_RequiredAttrs do
					-- table.insert(to, { ' <' .. cmd.m_RequiredAttrs[ii] .. '>', Color(255,50,50) })
					-- end
					
					-- if cmd.m_OptionalAttrs then
					-- 	for i,v in pairs(cmd.m_OptionalAttrs) do
					-- 		table.insert(to, { ' [' .. v .. ']', Color(50,50,255) })
					-- 	end
					-- end
					
					TTS.Admin:Msg(Caller, to)
					
					TTS.Admin:Msg(Caller, {
						{ '<' .. typ .. '>', Color(255,50,50) },
						{ ' ' },
						{ message },
					})
					
					return 
				end
				if typ == 'idrule' then
				  args[i] = string.Explode(",", args[i])
				end
				if typ == 'number' or typ == 'length' then
				  args[i] = tonumber(args[i])
				end
				if typ == 'player' or typ == 'players' then
					local targets = GetTargets(Caller, v, typ)
					
					for i,tar in pairs(targets) do
						table.insert(user_ids, tar:GetUserID())
					end
					if #targets == 0 then
						TTS.Admin:Msg(Caller, {
							{ 'Ошибка в команде ' },
							{  TTS.Admin.prefix .. cmd.ID },
							{ ': ' },
							{ 'аргумент #'.. i ..' ', Color(255, 50, 50) },
							{ 'не нашел игроков по значению '.. v, Color(255, 50, 50) },
							{ '.' }, 
						})
						return 
					end
					
					if cmd.m_SingleTarget then -- Проверка сингл таргета по аргументам
						local bool = cmd.m_SingleTarget[count_for] 
						if bool then
							if #targets > 1 then
								-- print(Caller)
								TTS.Admin:Msg(Caller, {  
									{ 'Ошибка в команде ' },
									{  TTS.Admin.prefix .. cmd.ID },
									{ ': ' },
									{ 'аргумент #'.. i ..' ', Color(255, 50, 50) },
									{ 'принимает только одного игрока', Color(255, 50, 50) },
									{ '.' }, 
								})
								return
              end
              
							target_format[i] = FormatTargets(targets)
							targets = targets[1]
						end
					end
					if cmd.m_Immunity then
						-- Здесь типа фиотрация по иммунитету
					end 
					
					if target_format[i] == nil then
						target_format[i] = FormatTargets(targets)
          end
          
					count_for = count_for + 1
			
					args[i] = targets
				end
				
			end
    end

	local last_pos = table.Count(require_and_optional_check)
	print(#args, last_pos)
	if #args > last_pos then
		args[last_pos] = table.concat( args, " ", last_pos )
	end

    if cmd.m_BeforeExecute then
      local bool, reason = cmd.m_BeforeExecute(Caller, unpack(args))
      if bool then
        TTS.Admin:Msg(Caller, {  
          { 'Ошибка в команде ' },
          {  TTS.Admin.prefix .. cmd.ID },
          { ': ' },
          { reason, Color(255, 50, 50) },
          { '.' }, 
        })
        return
      end
    end
	
	local execute = cmd.m_Execute(Caller, unpack(args))
    
    if !execute then return end

		local orig_args = table.Copy(args)
		-- PrintTable(orig_args)
		-- PrintTable(require_and_optional_check)

		table.Merge( orig_args, target_format )

		local target = FormatTargets({ Caller })
		-- print(target, '123') 
		table.insert( orig_args, 1, target )
		
		-- PrintTable(orig_args)
    -- target_format[1] = FormatTargets(target)
    -- print(cmd.m_Declinatio, 'm_Decliantio')
    
    if cmd.m_Declinatio then
      local datacomponent = {} 
      local outp
      if isfunction(cmd.m_Declinatio) then
        outp = cmd.m_Declinatio(Caller, unpack(args))[1]
      else
        outp = cmd.m_Declinatio[1]
      end
      local female = true
      if female then
        -- local clrs = string.Explode( "%s", str )
        -- PrintTable(outp)    
		
		-- PrintTable(orig_args)
        -- PrintTable(orig_args)    
        local counter_attrs = 1
        for i,v in pairs(outp) do
          -- print(v) 
          if v == '%str' then
            -- print(orig_args[counter_attrs]), v)
            if orig_args[counter_attrs] and istable(orig_args[counter_attrs][1]) then
              for i,v in pairs(orig_args[counter_attrs]) do
                -- print(v)
                table.insert(datacomponent, 
                  v
                ) 
              end
            elseif
              isstring(orig_args[counter_attrs])
              or isnumber(orig_args[counter_attrs]) -- length, number types
            then
              table.insert(
                datacomponent, 
                {
                  orig_args[counter_attrs],
                  Color(94, 130, 158)
                }
              )
            else
              -- print('---------')
              -- PrintTable(orig_args[counter_attrs])
              table.insert(
                datacomponent, 
                orig_args[counter_attrs]
              )
            end
            counter_attrs = counter_attrs + 1
          elseif v == '%length' then -- Все временные переменные - секунды  
            local secs = orig_args[counter_attrs]
            
            if secs == 0 or secs == nil then
              if (datacomponent[#datacomponent][1]:find('на') ~= 0) then
                table.remove(datacomponent)
              end
              
              if secs ~= nil then
                table.insert(
                  datacomponent,
                  {
                    ' навсегда', 
                    Color(94, 130, 158)
                  }
                )
              end
            else
              table.insert(
                datacomponent,
                {
                  TTS.Libs.Interface.sec2MinNearTo(orig_args[counter_attrs], true),
                  Color(94, 130, 158)
                }
              )
            end
            
            counter_attrs = counter_attrs + 1
		  elseif v == '%idrule' then
			local length = table.Count(orig_args[counter_attrs])
			for i, v in pairs(orig_args[counter_attrs]) do
				table.insert(
				  datacomponent,
				  {
					v, 
					Color(94, 130, 158)
				  }
				)
				if length ~= i then
					table.insert(
					  datacomponent,
					  {
						', '
					  }
					)
				end
			end
            counter_attrs = counter_attrs + 1
          elseif v == '%reason' then
            
            local reason = orig_args[counter_attrs]
            if reason ~= nil then
              table.insert(
                datacomponent,
                {
                  ' ('
                }
              )
              
              table.insert(
                datacomponent,
                {
                  reason, 
                  Color(94, 130, 158)
                }
              )
              table.insert(
                datacomponent,
                {
                  ')'
                }
              )
            end
            counter_attrs = counter_attrs + 1
          else
            table.insert(datacomponent, {
              v
            })
          end
          
          
          -- print(v)
        end
        -- datacomponent
        -- PrintTable(datacomponent)
        TTS.Admin:Msg(_, datacomponent)
      end
		end
			
			-- local user_ids = {}
			-- table.insert(Caller:UserID())
			
			-- table.insert(Caller:UserID())
			-- print(Caller)
			
			
			-- Для логов 
    local ready = {}
    local formatting_args = table.Copy(args)
    for i,v in pairs(cmd.m_RequiredAttrs) do
      -- local ty = ''
      if formatting_args[i] then
        if not (v == 'player' or v == 'players') then
          ready[v] = formatting_args[i]
        end
      end
      
      formatting_args[i] = nil 
      -- print(v, ty)
    end
    
    formatting_args = table.ClearKeys(formatting_args)
    for i,v in pairs(cmd.m_OptionalAttrs) do
      if formatting_args[i] then
        if not (v == 'player' or v == 'players') then
          ready[v] = formatting_args[i]
        end
      end 
      
      formatting_args[i] = nil 
    end
    
    local attrs = {}
    for i, v in pairs(ready) do
      attrs[i] = v
    end
    
    if #user_ids > 0 then
      attrs.user_ids = user_ids
    end
    
    if cmd.m_LogType then
      WS.Bus.LogsController:emit('test', {                             
        type = 'admin_' .. cmd.m_LogType,  
        attrs = attrs
      })
    end
	else
		TTS.Admin:ErrorLog(ID .. ' - not registered')
	end
end
 

if SERVER then
	-- print('asd')
	concommand.Add('app', function(ply, _, args)
		-- print(ply, _, args)
		-- PrintTable(args)
		local str = FormatArguments(table.concat(args, " "))
		
		-- local ID = string.sub(str[1]

		local ID = table.remove(str, 1)
		-- print(ply)
		-- print(ID)
		-- PrintTable(str)
		RUN_COMMAND(ply, ID, str)
		
  end)
  
  hook.Add('PlayerSay', 'Admin:PlayerSayRunCommand', function(ply, text)
    -- print(ply, text)
    local identifier = string.sub( text, 1, 1 )
    if identifier == '!' then
      local args = string.Trim(string.sub( text, 2, -1 ))

      
      local str = FormatArguments(args)
      
      -- local ID = string.sub(str[1]

      local ID = table.remove(str, 1)
      if ID == 'menu' then
        netstream.Start(ply, 'TTS:Admin/Open')

        return ''
      end
      RUN_COMMAND(ply, ID, str)

      return ''
    end
  end)
end
