AddCSLuaFile()

//Module starts here...
module("pk_pills",package.seeall)
version="#160426"

//
//Load files
//

file.CreateDir("pill_config")

local restrictions= ("\n"):Explode(file.Read("pill_config/restrictions.txt") or "")

local locked_perma={}
local locked_game={}

for k,v in pairs(util.KeyValuesToTable(file.Read("pill_config/permalocked.txt") or "")) do
	locked_perma[string.upper(k)] = v
end

//
//Pack Registration
//

local packString = ""
local packs={}
local currentPack

function packStart(name,id,icon)
	currentPack={}
	currentPack.name=name
	currentPack.icon=icon||"icon16/pill.png"
	currentPack.headers={}
	currentPack.items={}
	table.insert(packs,currentPack)

	packString=packString..id.." "
	if SERVER then RunConsoleCommand("pk_pill_packs",packString) end
end


function packEpisodicMigration()
	currentPack.ep_migrate=true
end

/*
if SERVER then var_downloads= CreateConVar("pk_pill_downloader","",{FCVAR_ARCHIVE}) end
function packFinalize()
	if CLIENT then return end

	if var_downloads:GetString()=="fastdl" or var_downloads:GetString()=="fastdl-icons" then
		for _,p in pairs(currentPack.items) do
			resource.AddFile("materials/pills/"..p.name..".png")
		end
	end
end

function addFiles(files)
	if CLIENT then return end

	if var_downloads:GetString()=="fastdl" or var_downloads:GetString()=="fastdl-noicons" then
		for _,f in pairs(files) do
			resource.AddFile(f)
		end
	end
end

function addIcons(icons)
	if CLIENT then return end

	if var_downloads:GetString()=="fastdl" or var_downloads:GetString()=="fastdl-icons" then
		for _,i in pairs(icons) do
			resource.AddFile("materials/entities/"..i..".png")
		end
	end
end

function addWorkshop(id)
	if CLIENT then return end

	if var_downloads:GetString()=="workshop" then
		resource.AddWorkshop(id)
	end
end
*/
function hasPack(name)
	return table.HasValue(string.Explode(" ",packString), name)
end

//
//PILL TABLE REGISTRATION
//

local forms={}

function register(name,t)
	if (t.sounds) then
		for _,s in pairs(t.sounds) do
			if (isstring(s)) then
				util.PrecacheSound(s)
			elseif (istable(s)) then
				for k,s2 in pairs(s) do
					if s2==false then
						s[k]=nil
					else
						util.PrecacheSound(s2)
					end
				end
			end
		end
	end

	forms[name]=t
end

local function fixParent(name)
	local t = forms[name]
	local t_parent = forms[t.parent]
	if t_parent.parent then
		fixParent(t.parent)
	end
	t_parent = forms[t.parent]
	if t_parent then
		t_parent = table.Copy(t_parent)
		forms[name]=table.Merge(t_parent,t)
		t.parent=nil
	else
		print("Tried to inherit pill from non-existant '"..t.parent.."'. Make sure you register the parent first.")
	end
end

function getPillTable(typ)
	return forms[typ]
end

function getFormCount()
	return table.Count( forms )
end

function getPacks()
	return packString
end

hook.Add("Initialize","pk_pill_finalize",function()
	for n,t in pairs(forms) do
		if t.parent then
			fixParent(n)
		end
	end
end)

//
//Player to Pill Entity Mapping
//

//local playerMap={}

function mapEnt(ply,ent)
	//playerMap[ply]=ent
	ply.pk_pill_ent=ent
	//print("m",ply.pk_pill_ent)
end

function unmapEnt(ply,ent)
	/*if playerMap[ply]==ent then
		playerMap[ply]=nil
	elseif IsValid(playerMap[ply]) then
		return playerMap[ply].formTable.type
	end*/
	//print("u",ply.pk_pill_ent)

	if ply.pk_pill_ent==ent then
		ply.pk_pill_ent=nil
		ply:SetNWEntity("pk_pill_ent",nil)
	elseif IsValid(ply.pk_pill_ent) then
		return ply.pk_pill_ent.formTable.type
	end
end

function getMappedEnt(ply)
	//print("g",ply.pk_pill_ent)
	//return playerMap[ply]
	return ply.pk_pill_ent
end

//
//Concommands, Convars, etc.
//

//
//NW Strings
//

if SERVER then
	util.AddNetworkString("pk_pill_filtercam")
	util.AddNetworkString("pk_pill_restrict")
	util.AddNetworkString("pk_pill_morphsound")
	util.AddNetworkString("pk_pill_init_darkrp")
else
	net.Receive( "pk_pill_filtercam", function( len, pl )
		local pill = net.ReadEntity()
		local filtered = net.ReadEntity()

		if IsValid(pill) and IsValid(filtered) then
			table.insert(pill.camTraceFilter,filtered)
		end
	end)
	
	net.Receive( "pk_pill_restrict", function( len, pl )
		restrictions = net.ReadTable()
	end)
	
	local snd_pillSet=Sound("Friends/friend_online.wav")
	local snd_pillFail=Sound("buttons/button2.wav")
	
	net.Receive("pk_pill_morphsound", function( len, pl )
		local success = net.ReadBit()
		if success==1 then
			//LocalPlayer():GetViewEntity():EmitSound(snd_pillSet)
			surface.PlaySound(snd_pillSet)
		else
			//LocalPlayer():GetViewEntity():EmitSound(snd_pillFail)
			surface.PlaySound(snd_pillFail)
		end
	end)
end

//
//Apply/Restore
//

if SERVER then
	--[[
		Modes:
		DEFAULT - Force, but don't change locking settings
		user - Obey restrictions
		force - force, change locking settings
		lock-life - force until death
		lock-map - force until map restart
		lock-perma - force forever
	]]
	
	function apply(ply,name,mode,option)
		if CLIENT then return end
		--restrict
		--[[if !ply:IsAdmin() then
			ply:ChatPrint("Pills are temporarily restricted.")
			return
		end]]--
		t =forms[name]

		if !t and name!="me" then
			print("Player '"..ply:Name().."' attempted to use nonexistent pill '"..name.."'.")
			ply:PrintMessage(HUD_PRINTCONSOLE,"Attempted to use nonexistent pill '"..name.."'.")
			return
		end

		local old = getMappedEnt(ply)
		
		if !ply:Alive() and !IsValid(old) then
			ply:ChatPrint("You are DEAD! Dead people can't use pills!")
			return
		end
		
		local locked
		local overridePos
		local overrideAng
		
		if mode=="user" then --restriction logic
			local success=true
			
			if !t.printName then
				ply:ChatPrint("You cannot use this pill directly.")
				success=false
			end

			
			if success then
				if table.HasValue(restrictions,name) then
					if not ply:IsAdmin() then
						ply:ChatPrint("You must be an Admin to use this pill.")
						success=false
					end
				end
			end
			
			if IsValid(old) and old.locked then
				if locked_perma[ply:SteamID()] then
					ply:ChatPrint("You are locked in your current pill -- FOREVER!")
				elseif locked_game[ply:SteamID()] then
					ply:ChatPrint("You are locked in your current pill until the map changes.")
				else
					ply:ChatPrint("You are locked in your current pill until you die.")
				end
				success=false
			end

			if t.type == "phys" and t.userSpawn then
				local tr
				if IsValid(old)&&old.formTable.type=="phys" then
					tr = util.QuickTrace(old:GetPos(),ply:EyeAngles():Forward()*99999,old)
				else
					tr = ply:GetEyeTrace()
				end

				if t.userSpawn.type=="ceiling" then
					if tr.HitNormal.z<-.8 and !tr.HitSky then
						overridePos = tr.HitPos+tr.HitNormal*(t.userSpawn.offset or 0)
					else
						success=false
						ply:ChatPrint("You need to be looking at a ceiling to use this pill.")
					end
				elseif t.userSpawn.type=="wall" then
					if !tr.HitSky then
						overridePos = tr.HitPos+tr.HitNormal*(t.userSpawn.offset or 0)
						overrideAng = tr.HitNormal:Angle()
						if t.userSpawn.ang then
							overrideAng=overrideAng+t.userSpawn.ang
						end
					else
						success=false
						ply:ChatPrint("You need to be looking at a wall to use this pill.")
					end
				end
			end
			
			net.Start("pk_pill_morphsound")
			net.WriteBit(success)
			net.Send(ply)
			
			if not success then return end
		elseif mode!=nil then --anything that can change locks
			if mode=="lock-map" then
				locked_game[ply:SteamID()]=name
			else
				locked_game[ply:SteamID()]=nil
			end
			
			if mode=="lock-perma" then
				locked_perma[ply:SteamID()]=name
			else
				locked_perma[ply:SteamID()]=nil
			end
			file.Write("pill_config/permalocked.txt",util.TableToKeyValues(locked_perma,"permalocked"))
			
			if mode != "force" then locked=true end
		end
		
		local e

		if t.type == "phys" then
			e = ents.Create("pill_ent_phys")
			if overridePos then
				e:SetPos(overridePos)
			elseif old&&old.formTable&&old.formTable.type=="phys" then
				e:SetPos(old:LocalToWorld(t.spawnOffset||Vector(0,0,60)))
			else
				e:SetPos(ply:LocalToWorld(t.spawnOffset||Vector(0,0,60)))
			end

			if overrideAng then
				e:SetAngles(overrideAng)
			else
				local angs=ply:EyeAngles()
				angs.p=0
				e:SetAngles(angs)
			end
		elseif t.type == "ply" then
			e = ents.Create("pill_ent_costume")
			if old&&old.formTable.type=="phys" then
				local angs = ply:EyeAngles()
				ply:Spawn()
				ply:SetEyeAngles(angs)
				
				ply:SetPos(old:GetPos())
			end
		else
			ply:ChatPrint("WARNING: Attempted to use invalid pill type.")
			return
		end
		
		local oldvel
		if IsValid(old) and old.formTable.type=="phys" then
			local phys = old:GetPhysicsObject()
			oldvel= IsValid(phys) and phys:GetVelocity() or Vector(0,0,0)
		else
			oldvel=ply:GetVelocity()
		end

		--Remove old AFTER we had a chance to set the new
		if IsValid(old) then
			old:Remove()
		//else
		//	old=nil
		end

		//if IsValid(e) then

		e:SetPillForm(name)
		e:SetPillUser(ply)
		e.locked=locked
		e.option=option
		
		e:Spawn()
		e:Activate()
		/*
		if !ply.pill_oldplayerclass then
			ply.pill_oldplayerclass = player_manager.GetPlayerClass(ply)
		end
		player_manager.SetPlayerClass(ply,"player_pill")
		*/
		if mode=="user" then
			if t.type=="ply" then
				ply:SetLocalVelocity(oldvel)
			else
				local phys = e:GetPhysicsObject()
				if IsValid(phys) then phys:SetVelocity(oldvel) end
			end
		end
		
		if mode!="user" or t.type!="ply" then
			ply:SetLocalVelocity(Vector(0,0,0))
		end

		/*if !IsValid(ply.pill_cam) then
			ply.pill_cam = ents.Create("pill_cam")
			ply.pill_cam:SetOwner(ply)
			ply.pill_cam:Spawn()
		end*/

		return e
		//end
	end

	local driveModes={}

	function getDrive(typ)
		return driveModes[typ]
	end
	
	function registerDrive(name,t)
		driveModes[name]=t
	end
end

--set breakout to true to break out of any locks
--returns true if the player was using a pill
--shared because it goes in the noclip function, I guess

function restore(ply,breakout)
	local ent = getMappedEnt(ply)
	if IsValid(ent) then
		if SERVER then
			if ent.locked and not breakout then
				if locked_perma[ply:SteamID()] then
					ply:ChatPrint("You are locked in your current pill -- FOREVER!")
				elseif locked_game[ply:SteamID()] then
					ply:ChatPrint("You are locked in your current pill until the map changes.")
				else
					ply:ChatPrint("You are locked in your current pill until you die.")
				end
			else
				/*if ply.pill_oldplayerclass then
					player_manager.SetPlayerClass(ply,ply.pill_oldplayerclass)
					ply.pill_oldplayerclass=nil
				end*/
			
				ent.notDead=true
				ent:Remove()
			end
			
			if not breakout then
				net.Start("pk_pill_morphsound")
				net.WriteBit(ent.notDead)
				net.Send(ply)
			else
				locked_game[ply:SteamID()]=nil
				locked_perma[ply:SteamID()]=nil
				file.Write("pill_config/permalocked.txt",util.TableToKeyValues(locked_perma,"permalocked"))
			end
		end
		return true
	//else
	//	return false
	end
end

//
//DAS HOOKS
//

if SERVER then
	hook.Add("KeyPress","pk_pill_keypress",function(ply,key)
		local ent = getMappedEnt(ply)
		if IsValid(ent) then
			ent:DoKeyPress(ply,key)
		end
	end)

	hook.Add("SetupPlayerVisibility","pk_pill_pvs",function(ply)
		if IsValid(getMappedEnt(ply))&&getMappedEnt(ply).formTable.type=="phys" then
			AddOriginToPVS(getMappedEnt(ply):GetPos())
		end
	end)

	hook.Add("PlayerDeathThink","pk_pill_nospawn",function(ply)
		if getMappedEnt(ply) then return false end
	end)

	hook.Add("DoAnimationEvent","pk_pill_triggerAnims",function(ply,event,data)
		if IsValid(getMappedEnt(ply)) && getMappedEnt(ply).formTable.type=="ply" then
			if event==PLAYERANIMEVENT_JUMP then
				getMappedEnt(ply):PillAnim("jump")
				getMappedEnt(ply):DoJump()
			end
			if event==PLAYERANIMEVENT_ATTACK_PRIMARY then
				getMappedEnt(ply):PillGesture("attack")
			end
			if event==PLAYERANIMEVENT_ATTACK_SECONDARY then
				getMappedEnt(ply):PillGesture("attack2")
			end
			if event==PLAYERANIMEVENT_RELOAD then
				getMappedEnt(ply):PillGesture("reload")
			end
		end
	end)

	hook.Add("OnPlayerHitGround","pk_pill_hitground",function(ply)
		local ent = getMappedEnt(ply)
		if IsValid(ent) then
			if ent.formTable.land then
				ent.formTable.land(ply,ent)
				ent:PillSound("land")
			end
			if ent.formTable.noFallDamage or ent.formTable.type=="phys" then
				return true
			end
		end
	end)

	hook.Add("DoPlayerDeath","pk_pill_death",function(ply)
		if IsValid(getMappedEnt(ply)) then
			if SERVER then getMappedEnt(ply):PillDie() end
			return false
		end
	end)

	hook.Add("PlayerFootstep", "pk_pill_step", function(ply,pos,foot,snd,vol,filter)
		local ent = getMappedEnt(ply)
		if IsValid(ent) then
			if ent.formTable.type=="phys" or ent.formTable.muteSteps then
				return true
			else
				return ent:PillSound("step",pos)
			end
		end
	end)
	
	hook.Add("PlayerInitialSpawn", "pk_pill_transmit_restrictions", function(ply)
		net.Start("pk_pill_restrict")
		net.WriteTable(restrictions)
		net.Send(ply)

	end)
	
	hook.Add("PlayerSpawn", "pk_pill_force_on_spawn", function(ply)
		local forcedType = locked_perma[ply:SteamID()] or locked_game[ply:SteamID()]
		if forcedType then
			local e = apply(ply,forcedType)
			if IsValid(e) then e.locked=true end
			return
		end
	end)

	//For compatibility with player resizer and God knows what else
	/*hook.Add("SetPlayerSpeed", "pk_pill_speed_enforcer", function(ply,walk,run)
		if IsValid(getMappedEnt(ply)) then
			return false
		end
	end)*/

	/*hook.Add("PlayerStepSoundTime", "pk_pill_step_time", function(ply,type,walking)    MEH!!
		local ent = playerMap[ply]
		if IsValid(ent) then
			//if ent.formTable.stepSize then
				
			//end
			return 100
		end
	end)*/
else //CLIENT HOOKS
	
end

hook.Add("SetupMove","pk_pill_movemod", function(ply,mv,cmd)
	local ent = getMappedEnt(ply)
	if IsValid(ent) then
		if ent.formTable.moveMod then
			ent.formTable.moveMod(ply,ent,mv,cmd)
		end
		if ent.GetChargeTime and ent:GetChargeTime()!=0 then
			local charge = ent.formTable.charge

			//check if we should continue
			local vel = mv:GetVelocity()
			if ent:GetChargeTime()+.1<CurTime() and vel:Length()<charge.vel*.8 then
				ent:SetChargeTime(0)
				ent:PillLoopStop("charge")
			else
				local angs= ent:GetChargeAngs()
				ply:SetEyeAngles(angs)
				mv:SetVelocity(angs:Forward()*charge.vel)
			end
		end
	end
end)

//Includes
if SERVER then include("i/sv_ai.lua") end
include("i/vox.lua")
include("i/util.lua")

//DONE!
print("PILL CORE LOADED")
