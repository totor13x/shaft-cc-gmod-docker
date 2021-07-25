local Player = FindMetaTable( "Player" )  

function Player:hasPerm(permission)
    local perms = self.m_Permissions

    if CLIENT then
        perms = TTS.Admin.LocalPerms
    end
    -- print(self.m_Permissions, LocalPlayer().m_Permissions)
	return perms and perms[permission] or false
end

if CLIENT then
    function hasPerm(permission)
        return LocalPlayer():hasPerm(permission)
    end
end


function Player:hasRole(role)
  local roles = self.m_Roles

  if CLIENT then
    roles = TTS.Admin.LocalRoles
  end
  -- print(self.m_Permissions, LocalPlayer().m_Permissions)
return roles and roles[role] or false
end

if CLIENT then
  function hasRole(role)
      return LocalPlayer():hasRole(role)
  end
end


function Player:IsSuperAdmin()
  return self:hasRole('founder')
end