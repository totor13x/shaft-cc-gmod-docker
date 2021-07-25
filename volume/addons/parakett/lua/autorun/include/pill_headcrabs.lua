AddCSLuaFile()

local combineMdls = {
	"models/combine_soldier.mdl",
	"models/combine_soldier_prisonguard.mdl",
	"models/combine_super_soldier.mdl",
	"models/police.mdl",
	"models/zombie/zombie_soldier.mdl",

	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/police.mdl",
	"models/player/police_fem.mdl",
	"models/player/zombie_soldier.mdl"
}



pk_pills.register("chicken",{
	printName="Chicken",
	side="harmless",
	type="ply",
	model="models/chicken/chicken.mdl",
	hull=Vector(15,15,15),
	anims={
		default={
			idle="idle01",
			walk="walk01",
			run="run01",
			glide="flap_falling"
		}
	},
	moveSpeed={
		walk=20,
		run=120
	},
	health=30
})

pk_pills.register("headcrab",{
	printName="Headcrab",
	side="hl_zombie",
	zombie="zombie",
	type="ply",
	model="models/headcrabclassic.mdl",
	camera={
		offset=Vector(0,0,5),
		dist=75
	},
	hull=Vector(20,20,10),
	anims={
		default={
			idle="idle01",
			walk="run1",
			jump="jumpattack_broadcast",
			swim="drown",
			burrow_in="burrowin",
			burrow_loop="burrowidle",
			burrow_out="burrowout"
		}
	},
	sounds={
		jump=pk_pills.helpers.makeList("npc/headcrab/attack#.wav",3),
		bite="npc/headcrab/headbite.wav",
		burrow_in="npc/antlion/digdown1.wav",
		burrow_out="npc/antlion/digup1.wav",
		step=pk_pills.helpers.makeList("npc/headcrab_poison/ph_step#.wav",4)
	},
	moveSpeed={
		walk=30,
		run=60
	},
	jumpPower=300,
	jump=function(ply,ent)
	if ent.JumpTime == nil then
		ent.JumpTime = 0
	end
		if ent.JumpTime+1.5> CurTime() then return false end
		v= ply:EyeAngles():Forward()
		v.z=0
		v:Normalize()
		ply:SetVelocity(v*200)
		ent:PillSound("jump")
		ent.canBite=true
		ent.JumpTime = CurTime()
	end,
	glideThink=function(ply,ent)
		if ent.canBite then
		
			ply:LagCompensation(true)
			
			local aim=ply:GetAimVector()
			aim.z=0
			aim:Normalize()

			local tracedata = {}
			tracedata.start = ply:EyePos()
			tracedata.endpos = ply:EyePos()+aim*70+Vector(0,0,-5)
			tracedata.filter = ply
			tracedata.mins = Vector(-8,-8,-8)
			tracedata.maxs = Vector(8,8,8)

			local tr1 = util.TraceLine( tracedata )
			local tr2 = util.TraceHull( tracedata )
			local tr = IsValid(tr2.Entity) and tr2 or tr1
			
			ply:LagCompensation(false) -- Don't forget to disable it!

			local DidHit            = tr.Hit and not tr.HitSky
			local HitEntity         = tr.Entity
			
			if DidHit then
			if HitEntity and IsValid( HitEntity ) then
				local crabbed = HitEntity
				if ply:GetNWBool("cant") and crabbed:IsPlayer() and crabbed:Alive() and crabbed:Health() > 40 then return end
				if crabbed:IsPlayer() and crabbed:GetRole(DRESSIROVSHIK) then return end
				if crabbed:IsNPC() || crabbed:IsPlayer() then
					ent:PillSound("bite")
				end
				if crabbed:Health()<=ent.formTable.biteDmg and not crabbed:IsFlagSet(FL_GODMODE) and crabbed:IsPlayer() then
					
					local crabbed_actual
					if pk_pills.getMappedEnt(crabbed) then
						crabbed_actual= pk_pills.getMappedEnt(crabbed)
					else
						crabbed_actual= crabbed
					end

					if crabbed_actual:LookupBone("ValveBiped.Bip01_Head1") && crabbed_actual:LookupBone("ValveBiped.Bip01_L_Foot") && crabbed_actual:LookupBone("ValveBiped.Bip01_R_Foot") then
						local mdl
						if pk_pills.getMappedEnt(crabbed) then
							local crabbedpill = pk_pills.getMappedEnt(crabbed)
							if crabbedpill.subModel then
								mdl=crabbedpill.subModel --doesnt work
							else
								mdl=crabbedpill:GetPuppet():GetModel()
							end
						else
							mdl=crabbed:GetModel()
						end

						local t = ent.formTable.zombie
						if t=="zombie" and pk_pills.hasPack("ep1") and table.HasValue(combineMdls,mdl) then t="ep1_zombine" end

						local newPill = pk_pills.apply(ply,"zombie_fast")
						
						local dbl=ents.Create("pill_attachment_zed")
												
						if dbl.SetBystanderColor then
							dbl:SetBystanderColor(crabbed:GetBystanderColor())
						end
						
						dbl:SetParent(newPill:GetPuppet())
						dbl:SetModel(mdl)
						dbl:Spawn()
						local pos = crabbed:GetPos()
						newPill.subModel=mdl
						crabbed:SetNWBool("h_hooked", true)
						ply:SetNWBool("hooked", true)
						ply:SetNWInt("hooked_time", CurTime())
						ply:SetNWBool("hooked_troup", false)
						ply:SetNWEntity("hooked_ply", crabbed)
						ply:SetNWEntity("hooked_dbl", dbl)
						ply:SetNWString("hooked_type", "zombie_fast")
						timer.Simple(0, function() crabbed:SpecEntity( ply, OBS_MODE_CHASE ) end)
						
						crabbed:DropWeapons()
						
						if crabbed:IsNPC() || crabbed:IsPlayer() then
							dbl:SetPos(pos)
							ply:SetEyeAngles(crabbed:EyeAngles())
						else
							ent:PillSound("bite")
						end
						if crabbed:IsPlayer() then
							crabbed:KillSilent()
						else
							crabbed:Remove()
						end
					else
						crabbed:TakeDamage(10000,ply,ply)
					end
				else
					crabbed:TakeDamage(ent.formTable.biteDmg,ply,ply)
				end
				ent.canBite=nil
			end
		end
		end
	end,
	land=function (ply,ent)
	ent.canBite=nil
	end,
	biteDmg=60,
	canBurrow=true,
	health=40
})

pk_pills.register("headcrab_fast",{
	parent="headcrab",
	printName="Fast Headcrab",
	zombie="zombie_fast",
	type="ply",
	model="models/headcrab.mdl",
	default_rp_cost=8000,
	anims={
		default={
			jump="attack",
			reload="lookaround"
		}
	},
	reload=function(ply,ent)
		ent:PillAnim("reload",true)
	end,
	moveSpeed={
		walk=100,
		run=200
	},
	canBurrow=false
})

pk_pills.register("headcrab_poison",{
	parent="headcrab",
	printName="Poison Headcrab",
	zombie="zombie_poison",
	type="ply",
	model="models/headcrabblack.mdl",
	default_rp_cost=7000,
	anims={
		default={
			jump=false,
			poison_jump="tele_attack_a",
			idl="idlesniff",
			id2="idlesumo",
		}
	},
	reload=function(ply,ent)
		ent:PillAnim(math.random(1,2)==1 and "id1" or "id2",true)
	end,
	sounds={
		rattle=pk_pills.helpers.makeList("npc/headcrab_poison/ph_rattle#.wav",3),
		jump=pk_pills.helpers.makeList("npc/headcrab_poison/ph_jump#.wav",3),
		bite=pk_pills.helpers.makeList("npc/headcrab_poison/ph_poisonbite#.wav",3)
	},
	moveSpeed={
		run=100
	}, 
	jumpPower=0,
	glideThink=function(ply,ent)
		if ent.canBite then
		
			ply:LagCompensation(true)
			
			local aim=ply:GetAimVector()
			aim.z=0
			aim:Normalize()

			local tracedata = {}
			tracedata.start = ply:EyePos()
			tracedata.endpos = ply:EyePos()+aim*70+Vector(0,0,-5)
			tracedata.filter = ply
			tracedata.mins = Vector(-8,-8,-8)
			tracedata.maxs = Vector(8,8,8)

			local tr1 = util.TraceLine( tracedata )
			local tr2 = util.TraceHull( tracedata )
			local tr = IsValid(tr2.Entity) and tr2 or tr1
			
			ply:LagCompensation(false) -- Don't forget to disable it!

			local DidHit            = tr.Hit and not tr.HitSky
			local HitEntity         = tr.Entity
			
			if DidHit then
			if HitEntity and IsValid( HitEntity ) then
				local crabbed = HitEntity
				if ply:GetNWBool("cant") and crabbed:IsPlayer() and crabbed:Alive() and crabbed:Health() > 120 then return end
				if crabbed:IsPlayer() and crabbed:GetRole(DRESSIROVSHIK) then return end
				if crabbed:IsNPC() || crabbed:IsPlayer() then
					ent:PillSound("bite")
				end
				if crabbed:Health()<=ent.formTable.biteDmg and not crabbed:IsFlagSet(FL_GODMODE) and crabbed:IsPlayer() then
					
					local crabbed_actual
					if pk_pills.getMappedEnt(crabbed) then
						crabbed_actual= pk_pills.getMappedEnt(crabbed)
					else
						crabbed_actual= crabbed
					end

					if crabbed_actual:LookupBone("ValveBiped.Bip01_Head1") && crabbed_actual:LookupBone("ValveBiped.Bip01_L_Foot") && crabbed_actual:LookupBone("ValveBiped.Bip01_R_Foot") then
						local mdl
						if pk_pills.getMappedEnt(crabbed) then
							local crabbedpill = pk_pills.getMappedEnt(crabbed)
							if crabbedpill.subModel then
								mdl=crabbedpill.subModel --doesnt work
							else
								mdl=crabbedpill:GetPuppet():GetModel()
							end
						else
							mdl=crabbed:GetModel()
						end

						local t = ent.formTable.zombie
						if t=="zombie" and pk_pills.hasPack("ep1") and table.HasValue(combineMdls,mdl) then t="ep1_zombine" end

						local newPill = pk_pills.apply(ply,"zombie_poison")
						
						local dbl=ents.Create("pill_attachment_zed")
												
						if dbl.SetBystanderColor then
							dbl:SetBystanderColor(crabbed:GetBystanderColor())
						end
						
						dbl:SetParent(newPill:GetPuppet())
						dbl:SetModel(mdl)
						dbl:Spawn()
						local pos = crabbed:GetPos()
						newPill.subModel=mdl
							
						crabbed:SetNWBool("h_hooked", true)
						ply:SetNWBool("hooked", true)
						ply:SetNWInt("hooked_time", CurTime())
						ply:SetNWBool("hooked_troup", false)
						ply:SetNWEntity("hooked_ply", crabbed)
						ply:SetNWEntity("hooked_dbl", dbl)
						ply:SetNWString("hooked_type", "zombie_poison")
						timer.Simple(0, function() crabbed:SpecEntity( ply, OBS_MODE_CHASE ) end)
						
						crabbed:DropWeapons()
						
						if crabbed:IsNPC() || crabbed:IsPlayer() then
							dbl:SetPos(pos)
							ply:SetEyeAngles(crabbed:EyeAngles())
						else
							ent:PillSound("bite")
						end
						if crabbed:IsPlayer() then
							crabbed:KillSilent()
						else
							crabbed:Remove()
						end
					else
						crabbed:TakeDamage(10000,ply,ply)
					end
				else
					crabbed:TakeDamage(ent.formTable.biteDmg,ply,ply)
				end
				ent.canBite=nil
			end
		end
		end
	end,
	jump=function(ply,ent)
		v= ply:EyeAngles():Forward()
		v.z=0
		v:Normalize()
		ent:PillSound("rattle")
		ent:PillAnim("poison_jump",true)

		timer.Simple(1.6,function()
			if !IsValid(ent) then return end
			ent:PillSound("jump")
			ply:SetVelocity(v*200+Vector(0,0,300))
			ent.canBite=true
		end)
	end,
	biteDmg=120,
	canBurrow=false
})