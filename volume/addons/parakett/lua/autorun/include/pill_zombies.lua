AddCSLuaFile()

pk_pills.register("zombie",{
	printName="Zombie",
	side="hl_zombie",
	crab="headcrab",
	type="ply",
	model="models/Zombie/Classic.mdl",
	default_rp_cost=7000,
	health=100,
	bodyGroups={1},
	anims={
		default={
			idle="Idle01",
			walk="walk",
			melee1="attackA",
			melee2="attackB",
			melee3="attackC",
			melee4="attackD",
			melee5="attackE",
			melee6="attackF",
			release="releasecrab"
		}
	},
	sounds={
		melee=pk_pills.helpers.makeList("npc/zombie/zo_attack#.wav",2),
		melee_hit=pk_pills.helpers.makeList("npc/zombie/claw_strike#.wav",3),
		melee_miss=pk_pills.helpers.makeList("npc/zombie/claw_miss#.wav",2),
		bust="npc/barnacle/barnacle_crunch2.wav",
		release=pk_pills.helpers.makeList("npc/zombie/zombie_pain#.wav",6),
		step=pk_pills.helpers.makeList("npc/zombie/foot#.wav",3)
	},
	attack={
		mode="trigger",
		func = pk_pills.common.melee,
		animCount=6,
		delay=.8,
		range=40,
		dmg=25
	},
	reload=function(ply,ent)
		ent:PillAnim("release",true)
		ent:PillSound("release")
		timer.Simple(1,function()
			if !IsValid(ent) then return end
			
			/*
			local r = ents.Create("prop_ragdoll")
			r:SetModel(ent.subModel||ent:GetPuppet():GetModel())
			r:SetPos(ply:GetPos())
			
			if r.SetPlayerColor then
				r:SetPlayerColor(ent:GetPuppet():GetPlayerColor())
			end
			print(ent.PlayerColor)
				//crabbed:SetNWBool("SetCrabbing", true)
			//r:SetNWString("SteamidOw", ply:SteamID())
			
			r:SetAngles(ply:GetAngles())
			r:Spawn()
			r:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			r:Fire("FadeAndRemove",nil,10)
			*/
			ply:SetNWBool("hooked", false)
			local h = ply:GetNWEntity("hooked_ply")
			if IsValid(h) then
			h.ModelOld = h:GetModel()
			h:Spawn()
			h:SetPos(ply:GetPos())
			h:SetAngles(ply:GetAngles())
			h:SetNWBool("h_hooked",false)
			h:SetModel(h.ModelOld)
			h:Kill()
			end
			ply:SetNWEntity("hooked_ply",nil)
			ply:SetNWEntity("hooked_dbl", nil)
			local puppet= ent:GetPuppet()
			local attach = puppet:GetAttachment(puppet:LookupAttachment("head"))

			pk_pills.apply(ply,ent.formTable.crab)

			if (attach) then
				ply:SetPos(attach.Pos)
			else
				ply:SetPos(ply:GetPos()+Vector(0,0,60))
			end
		end)
	end,
	movePoseMode="yaw",
	moveSpeed={
		walk=50,
		run=100
	},
	jumpPower=0,
	duckBy=0
})

pk_pills.register("zombie_poison",{
	parent="zombie",
	printName="Poison Zombie",
	crab="headcrab_poison",
	model="models/Zombie/Poison.mdl",
	default_rp_cost=8000,
	health=300,
	anims={
		default={
			run="run",
			melee="melee_01",
			throw="Throw"
		}
	},
	bodyGroups={nil,2,3,4},
	sounds={
		throw1=pk_pills.helpers.makeList("npc/zombie_poison/pz_throw#.wav",2,3),
		throw2=pk_pills.helpers.makeList("npc/headcrab_poison/ph_jump#.wav",1,3)
	},
	attack={
		func = pk_pills.common.melee,
		animCount=6,
		delay=.8,
		range=100,
		dmg=80,
		animCount=false
	},
	attack2={
		mode="trigger",
		func= function(ply,ent)
			ent:PillAnim("throw",true)
			ent:PillSound("throw1")
			timer.Simple(1.3,function()
				if !IsValid(ent) then return end
				ent:PillSound("throw2")
				local id = "pill_jumper_headcrab"
				if math.random(1,3) == 2 then
					id = "pill_faster_headcrab"
				end
				local headcrab=ents.Create(id)
				local puppet=ent:GetPuppet()
				local angs=ply:EyeAngles()
				angs.p=0
				headcrab:SetPos(ply:EyePos()+angs:Forward()*100)
				headcrab:SetAngles(angs)
				headcrab:Spawn()
				headcrab:GetPhysicsObject():SetVelocity(angs:Forward()*300+Vector(0,0,200))
			end)
		end
	},
	moveSpeed={
		run=200
	},
	movePoseMode=false
})

pk_pills.register("zombie_fast",{
	parent="zombie",
	printName="Fast Zombie",
	crab="headcrab_fast",
	model="models/Zombie/fast.mdl",
	default_rp_cost=9000,
	anims={
		default={
			idle="idle",
			walk="walk_all",
			run="Run",
			jump="leap_start",
			glide="leap_loop",
			jump_attack="leap",
			glide_attack="leapstrike",
			attack="Melee",
			climb="climbloop",
			climb_start="climbmount",
			release="br2_roar"
		}
	},
	sounds={
		jump="npc/fast_zombie/fz_scream1.wav",
		attack="npc/fast_zombie/fz_frenzy1.wav"
	},
	attack={
		mode="tick",
		func = function(ply,ent)
			if !ply:IsOnGround() || ply:GetVelocity():Length()>1 then return end
			ent:PillAnimTick("attack")
			if !ent.lastAttack || ent.lastAttack+.3<CurTime() then
				if ply:TraceHullAttack(ply:EyePos(), ply:EyePos()+ply:EyeAngles():Forward()*40,  Vector(-10,-10,-10),  Vector(10,10,10), 30, DMG_SLASH, 1,  true) then
					ent:PillSound("melee_hit")
				else
					ent:PillSound("melee_miss")
				end
				ent.lastAttack=CurTime()
			end
			if !ent.lastAttackSound || ent.lastAttackSound+2<CurTime() then
				ent:PillSound("attack")
				ent.lastAttackSound=CurTime()
			end
		end
	},
	attack2={
		mode="tick",
		func=function(ply,ent)
			local start= ply:GetPos()+Vector(0,0,10)
			local dir= ply:GetAimVector()
			dir.z= 0
			dir:Normalize()

			local tracedata = {}
			tracedata.start = start
			tracedata.endpos = start+dir*20
			tracedata.filter = ply
			tracedata.mins = Vector(-8,-8,-8)
			tracedata.maxs = Vector(8,8,8)

			if util.TraceHull(tracedata).Hit then
				if ply:IsOnGround() then
					ply:SetVelocity(Vector(0,0,150))
					ent:PillAnim("climb_start")
				end
				ply:SetLocalVelocity(Vector(0,0,100))
				ent:PillAnimTick("climb")
			end
		end
	},
	noFallDamage=true,
	jump=function(ply,ent)
		if ply:GetVelocity():Length()<350 then
			v= ply:EyeAngles():Forward()
			v.z=0
			v:Normalize()
			ply:SetVelocity(v*100+Vector(0,0,300))
		else
			ent:PillAnim("jump_attack")
			ent.canAttack=true
		end
		ent:PillSound("jump")
	end,
	glideThink=function(ply,ent)
		if ent.canAttack then
			if ply:TraceHullAttack(ply:EyePos(), ply:EyePos()+ply:EyeAngles():Forward()*50,  Vector(-20,-20,-20),  Vector(20,20,20), 50, DMG_SLASH, 1,  true) then
				ent:PillSound("melee_hit")
				ent.canAttack=nil
			end

			ent:PillAnimTick("glide_attack")
		end
	end,
	land=function (ply,ent)
		ent.canAttack=nil
	end,
	moveSpeed={
		run=400
	},
	jumpPower=400
})

pk_pills.register("zombie_torso",{
	parent="zombie",
	printName="Zombie Torso",
	model="models/Zombie/classic_torso.mdl",
	default_rp_cost=6500,
	camera={
		offset=Vector(0,0,10),
		dist=150
	},
	hull=Vector(30,30,20),
	anims={
		default={
			idle="idle",
			walk="crawl",
			melee="attack",
			fall="fall"
		}
	},
	attack={
		animCount=false,
		delay=.4
	},
	movePoseMode=false
})

pk_pills.register("zombie_torso_fast",{
	parent="zombie_torso",
	printName="Fast Zombie Torso",
	model="models/zombie/fast_torso.mdl",
	default_rp_cost=8500,
	crab="headcrab_fast",
	anims={
		default={
			melee="attack01",
			fall=false
		}
	},
	moveSpeed={
		walk=100,
		run=200
	}
})