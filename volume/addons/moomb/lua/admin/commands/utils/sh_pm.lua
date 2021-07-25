if true then return end
TTS.Admin.commands.Register( 'pm' )
:SetDescription('Private message')
:SetRequiredAttrs({ 'player', 'text' })
:SetLogType('pm', ':user_id-0 pm to :user_id-1: :text')
:SetSingleTarget( true )
:SetBeforeExecute(function(caller, target, text)
  if caller == target then
    return true, 'Нельзя отправить сообщение самому себе'
  end
end)
:Execute(function(caller, target, text)
	  -- print(...)
	local essence = ChatMsg()
	  :Add('[')
	  :Add('PM ', Color(94, 130, 158))
	  :Add(caller:Nick(), Color(94, 130, 158) )
	  :Add('] ')
	  :Add(text)
	  -- PrintTable(msg) 
	  -- for i, v in pairs(msg) do
	  --   essence:Add(v[1], v[2])
	  -- end

	  :Send({caller,target})
	  -- print(target)
	  -- PrintTable(second_target)
	  -- print(caller, target, length, reason)
end)
