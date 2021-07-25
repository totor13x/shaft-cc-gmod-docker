local Player = FindMetaTable( "Player" )

User_IDs = User_IDs or {}

function Player:SetUserID(uid)
	self:SetNWInt('user_id', uid)
	User_IDs[uid] = self
end

function Player:GetUserID()
	return self:GetNWInt('user_id')
end

function RemoveUserID(uid)
	User_IDs[uid] = nil
end

function UserIDToPlayer(uid)
  -- print('-----')
  -- print(uid)
  -- PrintTable(User_IDs)
	return User_IDs[uid] or false
end