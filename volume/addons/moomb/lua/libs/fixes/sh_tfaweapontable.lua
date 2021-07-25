//TFA.
TTS.TFA = TTS.TFA or {}
TTS.TFA.Reverse = {
	bayonet = 'weapon_mu_knife_bayonet',
	bowie = 'weapon_mu_knife_bowie',
	butfly = 'weapon_mu_knife_butterfly',  
	falch = 'weapon_mu_knife_falchion',
	flip = 'weapon_mu_knife_flip',
	gut = 'weapon_mu_knife_gut',
	['gypsy_jackknife'] = 'weapon_mu_knife_gypsy', 
	karam = 'weapon_mu_knife_karambit',
	m9 = 'weapon_mu_knife_m9',
	pickaxe = 'weapon_mu_knife_pickaxe', 
	pushkn = 'weapon_mu_knife_daggers',
	stiletto = 'weapon_mu_knife_stiletto' , 
	tackni = 'weapon_mu_knife_huntsman',
	ursus = 'weapon_mu_knife_ursus', 
	widowmaker = 'weapon_mu_knife_widowmaker',
}

function TTS.TFA.MakeSWEP(tabl)
	local class, base, name = tabl.class, tabl.base, tabl.name
	
	local SWEP = {}
	
	SWEP.Base				= base

	SWEP.tfaclass 			= class
	SWEP.tfaname			= name
	SWEP.tfabase			= base
	SWEP.v_skin 			= "!"
	SWEP.w_skin 			= SWEP.v_skin
	-- if TTS.CFG.SERVER == "MURDER" then
		-- SWEP.ENT = string.Replace(class, "weapon_", "") //mu_knife_bayonet_dopple
		
		-- base_ent = string.Replace(base, "weapon_", "")//mu_knife_bayonet
		
		-- local ENT = {}
		-- ENT.Base = base_ent		
		-- ENT.WeaponClass = class
		-- ENT.Skin = "!"
		
		-- scripted_ents.Register(ENT, SWEP.ENT)
	-- end
	weapons.Register(SWEP, class)
end 

if IsValid(TTS.TFA.HandsEnt) then
	TTS.TFA.HandsEnt:Remove()
	TTS.TFA.HandsEnt = nil
end

local rigmdl = "models/weapons/tfa_csgo/c_hands_translator.mdl" 

hook.Add("PostDrawViewModel", "TTS.TFA_DrawViewModel", function(vm, ply, weapon)


	if ply.GetHands then
		local hands = ply:GetHands()

		if IsValid(hands) and weapon.UseHands then
			render.OverrideColorWriteEnable(true, false)
				if not IsValid(TTS.TFA.HandsEnt) then
					TTS.TFA.HandsEnt = ClientsideModel(rigmdl)
				end
				if not vm:LookupBone("ValveBiped.Bip01_R_Hand") then
					local newhands = TTS.TFA.HandsEnt

					newhands:SetParent(vm)
					newhands:SetPos(vm:GetPos())
					newhands:SetAngles(vm:GetAngles())
					newhands:AddEffects(EF_BONEMERGE)
					newhands:AddEffects(EF_BONEMERGE_FASTCULL)

					hands:SetParent(newhands)
					hands:AddEffects(EF_BONEMERGE)
					hands:AddEffects(EF_BONEMERGE_FASTCULL)
				end
				if weapon.ViewModelFlip then
					render.CullMode(MATERIAL_CULLMODE_CW)
				end

				hands:DrawModel()

				if weapon.ViewModelFlip then
					render.CullMode(MATERIAL_CULLMODE_CCW)
				end

			render.OverrideColorWriteEnable(false, false)
		end
	end
end)