AddCSLuaFile()

pk_pills.register("antlion",{
	printName="Antlion",
	side="hl_antlion",
	type="ply",
	model="models/antlion.mdl",
	default_rp_cost=4000,
	options=function() return {
		{skin=0},
		{skin=1},
		{skin=2},
		{skin=3}
	} end,
	camera={
		offset=Vector(0,0,30),
		dist=150
	},
	hull=Vector(60,60,50),
	anims={
		default={
			idle="Idle",
			walk="walk_all",
			run="run_all",
			glide="jump_glide",
			jump="jump_start",
			melee1="attack1",
			melee2="attack2",
			melee3="attack3",
			charge_start="charge_start",
			charge_loop="charge_run",
			charge_hit="charge_end",
			swim="drown",
			burrow_in="digin",
			burrow_loop="digidle",
			burrow_out="digout"
		}
	},
	sounds={
		melee=pk_pills.helpers.makeList("npc/antlion/attack_single#.wav",3),
		melee_hit=pk_pills.helpers.makeList("npc/zombie/claw_strike#.wav",3),
		charge_start="npc/antlion/pain1.wav",
		charge_hit="npc/antlion/land1.wav",//"npc/antlion_guard/shove1.wav",
		loop_fly="npc/antlion/fly1.wav",
		loop_charge="npc/antlion/charge_loop1.wav",
		land="npc/antlion/land1.wav",
		burrow_in="npc/antlion/digdown1.wav",
		burrow_out="npc/antlion/digup1.wav",
		step=pk_pills.helpers.makeList("npc/antlion/foot#.wav",4)
	},
	aim={
		xPose="head_yaw",
		yPose="head_pitch",
		nocrosshair=true
	},
	attack={
		mode="trigger",
		func = pk_pills.common.melee,
		animCount=3,
		delay=.5,
		range=75,
		dmg=25
	},
	charge={
		vel=800,
		dmg=50,
		delay=.6
	},
	attack2={
		mode="trigger",
		func = function(ply,ent)
			ent:PillChargeAttack()
		end
	},
	movePoseMode="yaw",
	moveSpeed={
		walk=200,
		run=500
	},
	jumpPower=500,
	jump=function(ply,ent)
		if ply:GetVelocity():Length()<300 then
			ply:SetVelocity(Vector(0,0,500))
		end
	end,
	glideThink=function(ply,ent)
		ent:PillLoopSound("fly")
		local puppet=ent:GetPuppet()
		if puppet:GetBodygroup(1)==0 then
			puppet:SetBodygroup(1,1)
		end
	end,
	land=function(ply,ent)
		ent:PillLoopStop("fly")
		local puppet=ent:GetPuppet()
		puppet:SetBodygroup(1,0)
	end,
	canBurrow=true,
	health=120,
	noFallDamage=true,
	damageFromWater=1
})
