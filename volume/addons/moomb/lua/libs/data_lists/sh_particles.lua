
function TTS.Player.DeathEffectApply(ent, typediss, ply)
	timer.Simple(0,function()
		if IsValid(ent) then
			if typediss == 'standart_diss' then
			
				ent.oldname=ent:GetName()
				ent:SetName("fizzled"..ent:EntIndex().."");
				local dissolver = ents.Create( "env_entity_dissolver" );
				if IsValid(dissolver) then
					dissolver:SetPos( ent:GetPos() );
					dissolver:SetOwner( ent );
					dissolver:Spawn();
					dissolver:Activate();
					dissolver:SetKeyValue( "target", "fizzled"..ent:EntIndex().."" );
					dissolver:SetKeyValue( "magnitude", 100 );
					dissolver:SetKeyValue( "dissolvetype", 0 );
					dissolver:Fire( "Dissolve" );
					timer.Simple( 1, function()
						if IsValid(ent) then 
							ent:SetName(corpseoldname)
						end
					end)
				end
			elseif typediss == 'standart_silnie_diss' then
				ent.oldname=ent:GetName()
				ent:SetName("fizzled"..ent:EntIndex().."");
				local dissolver = ents.Create( "env_entity_dissolver" );
				if IsValid(dissolver) then
					dissolver:SetPos( ent:GetPos() );
					dissolver:SetOwner( ent );
					dissolver:Spawn();
					dissolver:Activate();
					dissolver:SetKeyValue( "target", "fizzled"..ent:EntIndex().."" );
					dissolver:SetKeyValue( "magnitude", 100 );
					// 0 - standart 
					// 1 - silnie molnii vo vse storoni
					// 2 - silnie molnii sverhy
					// 3 - fast
					dissolver:SetKeyValue( "dissolvetype", 1 );
					dissolver:Fire( "Dissolve" );
					timer.Simple( 1, function()
						if IsValid(ent) then 
							ent:SetName(corpseoldname)
						end
					end)
				end
			end
			if IsValid(ply) then
				local vel = ply:GetVelocity()/6000
				for bone = 0, ent:GetPhysicsObjectCount() - 1 do
					local phys = ent:GetPhysicsObjectNum( bone )
					if IsValid(phys) then
						local pos, ang = ply:GetBonePosition( ent:TranslatePhysBoneToBone( bone ) )
						phys:SetPos(pos or ply:GetPos())
						phys:SetAngles(ang or ply:GetAngles())
						phys:SetVelocityInstantaneous(vel)
						phys:EnableGravity(false)
					end
				end
			end
		end
	end)
end

game.AddParticles("particles/item_fx.pcf")
game.AddParticles("particles/scary_ghost.pcf")
game.AddParticles("particles/halloween2015_unusuals.pcf")

PrecacheParticleSystem( "superrare_sparkles3" ) -- Кор

PrecacheParticleSystem( "turret_shield" ) -- Кор
PrecacheParticleSystem( "turret_shield_b" )

PrecacheParticleSystem( "unusual_robot_time_warp" ) -- Кор
PrecacheParticleSystem( "unusual_robot_time_warp2" ) 
PrecacheParticleSystem( "unusual_robot_time_warp_edge" ) 
PrecacheParticleSystem( "unusual_robot_time_warp_edge2" ) 
PrecacheParticleSystem( "unusual_robot_time_warp_rays" ) 
PrecacheParticleSystem( "unusual_robot_time_warp_spiral" ) 
PrecacheParticleSystem( "unusual_robot_time_warp_spiral2" ) 

-- ����� �����
PrecacheParticleSystem( "halloween_boss_foot_fire" )
PrecacheParticleSystem( "halloween_boss_foot_impact" )

-- ���������� ������
PrecacheParticleSystem( "unusual_nether_rope_blue" )
PrecacheParticleSystem( "unusual_nether_rope_glow_blue" )
PrecacheParticleSystem( "unusual_nether_sparkles_blue" )
PrecacheParticleSystem( "unusual_nether_sparkles2_blue" )
PrecacheParticleSystem( "unusual_nether_blue" ) //�������� ����

-- ������� ������
PrecacheParticleSystem( "unusual_nether_rope_pink" )
PrecacheParticleSystem( "unusual_nether_rope_glow_pink" )
PrecacheParticleSystem( "unusual_nether_sparkles_pink" )
PrecacheParticleSystem( "unusual_nether_sparkles2_pink" )
PrecacheParticleSystem( "unusual_nether_pink" ) //�������� ����

-- ��������� ���������
PrecacheParticleSystem( "unusual_hw_deathbydisco_ball_beams" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_ball" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_stage_lights" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_skeletons" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_ball_stars" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_ball_glow" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_bits" )
PrecacheParticleSystem( "unusual_hw_deathbydisco_parent" ) //�������� ����

-- ���������� �� ������ ������
PrecacheParticleSystem( "superrare_circling_childglow_pink" )
PrecacheParticleSystem( "superrare_circling_heart" ) //�������� ����
/*
-- ���������� �� ������ �����
PrecacheParticleSystem( "superrare_orbit" ) //�������� ����
*/
-- �������� ������
PrecacheParticleSystem( "superrare_purpleenergy" ) //�������� ����

-- �������� ������� ����
PrecacheParticleSystem( "unusual_bats_flaming_fire" )
PrecacheParticleSystem( "unusual_bats_flaming_bat" )
PrecacheParticleSystem( "unusual_bats_flaming_glow_orange" )
PrecacheParticleSystem( "unusual_bats_flaming_proxy_orange" ) //�������� ����

-- Sunrise
PrecacheParticleSystem( "unusual_eotl_sunrise_rays_2" )
PrecacheParticleSystem( "unusual_eotl_sunrise_rays" )
PrecacheParticleSystem( "unusual_eotl_sunrise_clouds" )
PrecacheParticleSystem( "unusual_eotl_sunrise_clouds_highlight" )
PrecacheParticleSystem( "unusual_eotl_sunrise_glow" )
PrecacheParticleSystem( "unusual_eotl_sunrise" ) //�������� ����

-- Sunset
PrecacheParticleSystem( "unusual_eotl_sunset_rays_2" )
PrecacheParticleSystem( "unusual_eotl_sunset_rays" )
PrecacheParticleSystem( "unusual_eotl_sunset_clouds" )
PrecacheParticleSystem( "unusual_eotl_sunset_clouds_highlight" )
PrecacheParticleSystem( "unusual_eotl_sunset_glow" )
PrecacheParticleSystem( "unusual_eotl_sunset" ) //�������� ����

-- ����� � ������ *TODO: green, orange
PrecacheParticleSystem( "unusual_eyes_cloud_purple" )
PrecacheParticleSystem( "unusual_eyes_cloud" )
PrecacheParticleSystem( "unusual_eyes_purple" )
PrecacheParticleSystem( "unusual_eyes_purple_parent" ) //�������� ����

-- ���� ������������ � �������
PrecacheParticleSystem( "unusual_fullmoon_cloudy_child" )
PrecacheParticleSystem( "unusual_fullmoon_cloudy" ) //�������� ����

-- ����������� �����
PrecacheParticleSystem( "unusual_orbit_nutsnbolts_large" )
PrecacheParticleSystem( "unusual_orbit_nutsnbolts_fall" )
PrecacheParticleSystem( "unusual_orbit_nutsnbolts" ) //�������� ����

game.AddParticles( "particles/dissolve_w.pcf" )
PrecacheParticleSystem( "w_dissolve_test" )
PrecacheParticleSystem( "w_dissolve_corp_body" )
PrecacheParticleSystem( "w_lina_death" )


game.AddParticles("particles/diss_fx.pcf")
PrecacheParticleSystem("black_splash")
PrecacheParticleSystem("blacksplash2")
PrecacheParticleSystem("blacksplash3")
PrecacheParticleSystem("blacksplash_1")
PrecacheParticleSystem("bsend")

game.AddParticles( "particles/lightning_trail_yellow.pcf")
PrecacheParticleSystem("yellow_lightning")
PrecacheParticleSystem("yellow_lightning_blur")
PrecacheParticleSystem("yellow_lightning_electrify")
PrecacheParticleSystem("yellow_lightning_emitter")
PrecacheParticleSystem("yellow_lightning_emitter_2")
PrecacheParticleSystem("yellow_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_red.pcf")
PrecacheParticleSystem("red_lightning")
PrecacheParticleSystem("red_lightning_blur")
PrecacheParticleSystem("red_lightning_electrify")
PrecacheParticleSystem("red_lightning_emitter")
PrecacheParticleSystem("red_lightning_emitter_2")
PrecacheParticleSystem("red_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_blue.pcf")
PrecacheParticleSystem("blue_lightning")
PrecacheParticleSystem("blue_lightning_blur")
PrecacheParticleSystem("blue_lightning_electrify")
PrecacheParticleSystem("blue_lightning_emitter")
PrecacheParticleSystem("blue_lightning_emitter_2")
PrecacheParticleSystem("blue_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_green.pcf")
PrecacheParticleSystem("green_lightning")
PrecacheParticleSystem("green_lightning_blur")
PrecacheParticleSystem("green_lightning_electrify")
PrecacheParticleSystem("green_lightning_emitter")
PrecacheParticleSystem("green_lightning_emitter_2")
PrecacheParticleSystem("green_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_orange.pcf")
PrecacheParticleSystem("orange_lightning")
PrecacheParticleSystem("orange_lightning_blur")
PrecacheParticleSystem("orange_lightning_electrify")
PrecacheParticleSystem("orange_lightning_emitter")
PrecacheParticleSystem("orange_lightning_emitter_2")
PrecacheParticleSystem("orange_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_purple.pcf")
PrecacheParticleSystem("purple_lightning")
PrecacheParticleSystem("purple_lightning_blur")
PrecacheParticleSystem("purple_lightning_electrify")
PrecacheParticleSystem("purple_lightning_emitter")
PrecacheParticleSystem("purple_lightning_emitter_2")
PrecacheParticleSystem("purple_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_black.pcf")
PrecacheParticleSystem("black_lightning")
PrecacheParticleSystem("black_lightning_blur")
PrecacheParticleSystem("black_lightning_electrify")
PrecacheParticleSystem("black_lightning_emitter")
PrecacheParticleSystem("black_lightning_emitter_2")
PrecacheParticleSystem("black_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_white.pcf")
PrecacheParticleSystem("white_lightning")
PrecacheParticleSystem("white_lightning_blur")
PrecacheParticleSystem("white_lightning_electrify")
PrecacheParticleSystem("white_lightning_emitter")
PrecacheParticleSystem("white_lightning_emitter_2")
PrecacheParticleSystem("white_lightning_emitter_rough")
game.AddParticles( "particles/lightning_trail_v9.pcf")
PrecacheParticleSystem("v9_lightning")
PrecacheParticleSystem("v9_lightning_blur")
PrecacheParticleSystem("v9_lightning_electrify")
PrecacheParticleSystem("v9_lightning_emitter")
PrecacheParticleSystem("v9_lightning_emitter_2")
PrecacheParticleSystem("v9_lightning_emitter_rough")