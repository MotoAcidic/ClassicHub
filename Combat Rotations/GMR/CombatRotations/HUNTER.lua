local t, f, p, pet = "target", "focus", "player", "pet"
if IsUsableSpell(GetSpellInfo(75)) then
	if GetDistanceBetweenObjects(p, t) >= 10 then
		if ENEMY_COMBAT_RANGE ~= 39 then
			ENEMY_COMBAT_RANGE = 39
		end
	elseif ENEMY_COMBAT_RANGE ~= 5 then
		ENEMY_COMBAT_RANGE = 5
	end
elseif ENEMY_COMBAT_RANGE ~= 5 then
	ENEMY_COMBAT_RANGE = 5
end

local wing_clip, raptor_strike, serpent_sting, arcane_shot, multi_shot  = GetSpellInfo(2974), GetSpellInfo(2973), GetSpellInfo(1978), GetSpellInfo(3044), GetSpellInfo(2643)
local feed_pet, bestial_wrath, hunters_mark, auto_shot, pet_stun  = GetSpellInfo(6991), GetSpellInfo(19574), GetSpellInfo(1130), GetSpellInfo(75), GetSpellInfo(19577)
local summon_pet, revive_pet, heal_pet, aimed_shot  = GetSpellInfo(883), GetSpellInfo(982), GetSpellInfo(136), GetSpellInfo(19434)
local growl, hawk_aspect, slow_shot, pet_stun  = GetSpellInfo(2649), GetSpellInfo(13165), GetSpellInfo(5116), GetSpellInfo(19577)
local mongoos_bite, monkey_aspect, rapid_fire, berserking = GetSpellInfo(1495), GetSpellInfo(13163), GetSpellInfo(3045), GetSpellInfo(20554)
local feed_pet_buff, feign_death, pet_spell_lightning_breath = GetSpellInfo(1539), GetSpellInfo(5384), GetSpellInfo(24844)

  -- HEALING POTIONS CODE -- By Andoido
  -- Major Healing Potions --
  if Health(p) <= 25 and GetItemCount(13446) > 1 and GetItemCooldown(13446) == 0 then
    RunMacroText('/use Major Healing Potion')
  end

  -- Superior Healing Potions --
  if Health(p) <= 25 and GetItemCount(3928) > 1 and GetItemCooldown(3928) == 0 then
    RunMacroText('/use Superior Healing Potion')
  end

  -- Greater Healing Potions --
  if Health(p) <= 25 and GetItemCount(1710) > 1 and GetItemCooldown(1710) == 0 then
    RunMacroText('/use Greater Healing Potion')
  end

  -- Healing Potions --
  if Health(p) <= 25 and GetItemCount(929) > 1 and GetItemCooldown(929) == 0 then
    RunMacroText('/use Healing Potion')
  end

  -- Lesser Healing Potions --
  if Health(p) <= 25 and GetItemCount(858) > 1 and GetItemCooldown(858) == 0 then
    RunMacroText('/use Lesser Healing Potion')
  end

  -- Minor Healing Potions --
  if Health(p) <= 25 and GetItemCount(118) > 1 and GetItemCooldown(118) == 0 then
    RunMacroText('/use Minor Healing Potion')
  end
  ------------ END OF HEALING POTIONS CHECK ------------

function HunterHasPet()
	if GMR_HUNTER_PET ~= "NOEXIST" then
		return GetSpellInfo(summon_pet) ~= nil
	end
end
function GMR_Hunter_Damage()
	if GMR_HUNTER_PET == "DEAD" and UnitExists("pet") then
		GMR_HUNTER_PET = nil
	end
	if not UnitCastingInfo("player")
	and not UnitChannelInfo("player") then
		if ObjectExists(p) and ObjectExists(t) then
			if IsUsableSpell(pet_spell_lightning_breath)
			and GetSpellCooldown(pet_spell_lightning_breath) == 0 
			and IsSpellInRange(pet_spell_lightning_breath, t) == 1 then
				Cast(pet_spell_lightning_breath, t)
			end
			if GetDistanceBetweenObjects(p, t) >= 10 then
				if UnitTarget("target") == GetPlayerPointer() then
					if CanCastSpell(pet_stun, t)
					and (not PET_STUN_DELAY or PET_STUN_DELAY <= GetTime()) then
						PET_STUN_DELAY = GetTime()+1
						Cast(pet_stun, t)
					elseif CanCastSpell(slow_shot, t)
					and not Debuff(t, pet_stun) then
						Cast(slow_shot, t)
					end
				end
				if CanCastSpell(hawk_aspect)
				and not Buff(p, hawk_aspect) then
					if CanCastSpell(hawk_aspect) then
						Cast(hawk_aspect)
					end
				else
					if (Mana(p) >= 50 
					or GetNumEnemies(t, 5) >= 2) then
						if CanCastSpell(hunters_mark, t)
						and not Debuff(t, hunters_mark) then
							Cast(hunters_mark, t)
						elseif CanCastSpell(serpent_sting, t)
						and UnitCreatureTypeID(t) ~= 4
						and UnitCreatureTypeID(t) ~= 3
						and UnitCreatureTypeID(t) ~= 11
						and not Debuff(t, serpent_sting) then
							Cast(serpent_sting, t)
						end
						if UnitAffectingCombat("player") then
							if CanCastSpell(rapid_fire)
							and not Buff(p, berserking) then
								Cast(rapid_fire)
							elseif CanCastSpell(berserking)
							and not Buff(p, rapid_fire) then
								Cast(berserking)
							elseif CanCastSpell(bestial_wrath) then
								Cast(bestial_wrath)
							end
						end
						if CanCastSpell(arcane_shot, t) then
							Cast(arcane_shot, t)
						elseif CanCastSpell(auto_shot, t)
						and not IsCurrentSpell(auto_shot)
						and (not GMR_AUTO_SHOT_TIMER or GMR_AUTO_SHOT_TIMER <= GetTime()) then
							GMR_AUTO_SHOT_TIMER = GetTime()+0.75
							GMR_AUTO_SHOT = true
							Cast(auto_shot, t)
						end
					else
						if CanCastSpell(auto_shot, t)
						and not IsCurrentSpell(auto_shot)
						and (not GMR_AUTO_SHOT_TIMER or GMR_AUTO_SHOT_TIMER <= GetTime()) then
							GMR_AUTO_SHOT_TIMER = GetTime()+0.75
							GMR_AUTO_SHOT = true
							Cast(auto_shot, t)
						end
					end
				end
			else
				if IsCurrentSpell(auto_shot) then
					StopAttack()
				end
				if (not GMR_HUNTER_MEELE_TIMER or GMR_HUNTER_MEELE_TIMER <= GetTime()) then
					GMR_HUNTER_MEELE_TIMER = GetTime()+1
					StartAttack()
				end
				if ENEMY_COMBAT_RANGE ~= 5 then
					ENEMY_COMBAT_RANGE = 5 
				end
				if GMR_AUTO_SHOT == true then
					GMR_AUTO_SHOT = nil
					StopAttack()
				end
					if (Mana(p) >= 50 
					or GetNumEnemies(t, 5) >= 2) then
				if CanCastSpell(mongoos_bite, t) then
					Cast(mongoos_bite, t)
				end
				if CanCastSpell(raptor_strike, t)
				and not IsCurrentSpell(raptor_strike) then
					Cast(raptor_strike, t)
				end
					end
			end
		end
	end
end
if CanCastSpell(hawk_aspect) 
and not Buff(p, hawk_aspect) then
	Cast(hawk_aspect)
end
if HunterHasPet() then
	if not UnitExists(pet) then
		if CanCastSpell(summon_pet)
		and not UnitCastingInfo("player") then
			if GMR_HUNTER_PET ~= "DEAD" then
				Cast(summon_pet)
			elseif GMR_HUNTER_PET == "DEAD" then
				if CanCastSpell(revive_pet)
				and not UnitCastingInfo("player")
				and not UnitChannelInfo("player")
				and GetUnitSpeed("player") == 0 then
					Cast(revive_pet)
				end
			end
		end
	end
	if UnitIsDeadOrGhost(pet)
	and not UnitCastingInfo("player")
	and not UnitChannelInfo("player")
	and CanCastSpell(revive_pet) then
		GMR_HUNTER_PET = nil
		Cast(revive_pet)
	end
	if not UnitIsUnit("targettarget", pet) 
	and CanCastSpell(growl, t) then
		Cast(growl, t)
	end
	if ObjectExists(pet) then
		-- Pet Follow
		if GetDistanceBetweenObjects(p, pet)
		and GetDistanceBetweenObjects(p, pet) >= 39
		and GetDistanceBetweenObjects(p, t)
		and GetDistanceBetweenObjects(p, t) >= 39
		and UnitTarget("target") == GetPetPointer() then
			RunMacroText("/petfollow")
			GMR_Log("PETFOLLOW_1")
		end
		
		-- Heal Pet
		if Health(pet) <= 60 then
			if not UnitIsDeadOrGhost(pet)
			and not UnitCastingInfo("player")
			and not UnitChannelInfo("player")
			and not Buff(pet, heal_pet)
			and GetDistanceBetweenObjects(p, pet) then
				if GetDistanceBetweenObjects(p, pet) <= 17.5 then
					if GetUnitSpeed("pet") ~= 0 then
						RunMacroText("/petstay")
					end
					if CanCastSpell(heal_pet) then
						Cast(heal_pet)
					end
				elseif (not GMR_PET_FOLLOW_TIMER or GMR_PET_FOLLOW_TIMER <= GetTime()) then
					GMR_PET_FOLLOW_TIMER = GetTime()+2
					PetFollow()
					GMR_Log("PETFOLLOW_2")
				end
			end
		end	
	end
end
if ((HunterHasPet() and UnitExists("pet"))
or not HunterHasPet())
or Health("player") <= 75 then
	if ObjectExists("pet")
	and not UnitIsDeadOrGhost("pet") then
		if not UnitAffectingCombat("pet")
		and UnitExists("pet")
		and not UnitIsDeadOrGhost("pet")
		and InLoS("Hard", t) then
			if (not GMR_PETATTACK_DELAY or GMR_PETATTACK_DELAY <= GetTime())
			and (not GMR_HUNTER_PAUSE or GMR_HUNTER_PAUSE <= GetTime())
			and not Buff("pet", feed_pet_buff) then
				GMR_PETATTACK_DELAY = GetTime()+1
				PetAttack()
			end
		else
			if (not GMR_PETATTACK_DELAY or GMR_PETATTACK_DELAY <= GetTime())
			and (not GMR_HUNTER_PAUSE or GMR_HUNTER_PAUSE <= GetTime())
			and not UnitIsUnit("pettarget", "target")
			and InLoS("Hard", t)
			and not Buff("pet", feed_pet_buff) then
				GMR_PETATTACK_DELAY = GetTime()+1
				PetAttack()
			end
			GMR_Hunter_Damage()
		end
	else
		GMR_Hunter_Damage()
	end
elseif not Buff("pet", feed_pet_buff) then
	StopAttack()
end
