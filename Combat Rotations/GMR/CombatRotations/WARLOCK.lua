local dot1, dot2, shadowbolt, armor, drainlife = GetSpellInfo(172), GetSpellInfo(980), GetSpellInfo(686), GetSpellInfo(687), GetSpellInfo(689)
local imp, void, shield, drain_soul, immolate = GetSpellInfo(688), GetSpellInfo(697), GetSpellInfo(7812), GetSpellInfo(1120), GetSpellInfo(348)
local fear, demon_armor, health_funnel, fel_domination = GetSpellInfo(5782), GetSpellInfo(706), GetSpellInfo(755), GetSpellInfo(18708)
local siphon_life, life_tap, dunkler_pakt, wand = GetSpellInfo(18265), GetSpellInfo(1454), GetSpellInfo(18220), GetSpellInfo(5019)
local t, f, p, pet = "target", "focus", "player", "pet"

if UnitCastingInfo("player") == imp then
	GMR_PET_DELAY = GetTime()+1 
	GMR_WARLOCK_PET = "IMP"
end
if UnitCastingInfo("player") == void then
	GMR_PET_DELAY = GetTime()+1 
	GMR_WARLOCK_PET = "VOIDWALKER"
end
if UnitCastingInfo("player") == immolate then
	GMR_IMMOLATE_DELAY = GetTime()+0.5
end
if UnitCastingInfo("player") == dot1 then
	GMR_CORRUPTION_DELAY = GetTime()+0.5
end
if UnitCastingInfo("player") == fear then
	GMR_FEAR_DELAY = GetTime()+9
end
local function HasPet()
	if GetSpellInfo(imp) then
		return true
	end
end

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

if UnitExists("pet")
and ObjectExists("pet")
and not UnitIsUnit("pettarget", t)
and (not GMR_PETATTACK_DELAY or GMR_PETATTACK_DELAY <= GetTime()) then
	GMR_PETATTACK_DELAY = GetTime()+1
	RunMacroText("/petattack [@target]")
end
if not UnitChannelInfo(p) then
	if HasPet() and not UnitExists("pet") then
		if (GetSpellInfo(imp) or (GetSpellInfo(void) and GetContainerItemCount(GetItemInfo(6265)) >= 1))
		and (not UnitExists("pet") or UnitIsDeadOrGhost("pet"))
		and GetUnitSpeed("player") == 0
		and not Buff(p, shield) then
			if (not GMR_PET_DELAY or GMR_PET_DELAY <= GetTime()) then
				if CanCastSpell(fel_domination) then
					Cast(fel_domination)
				else
					if CanCastSpell(void)
					and GetContainerItemCount(GetItemInfo(6265)) >= 1 then
						Cast(void)
					elseif CanCastSpell(imp) then
						Cast(imp)
					end
				end
			end
		end
	elseif ((UnitAffectingCombat("pet") or not UnitExists("pet")) or UnitAffectingCombat(p)) then		
		if CanCastSpell(dunkler_pakt)
		and UnitExists("pet")
		and Mana("pet") >= 50 
		and Mana(p) <= 50 then
			Cast(dunkler_pakt)
		end
		if CanCastSpell(life_tap)
		and Health(p) >= 70 
		and Mana(p) <= 39 then
			Cast(life_tap)
		end
		if GetSpellInfo(drain_soul)
		and Mana(p) >= 10 
		and not IsFalling()
		and not IsFlying()
		and not UnitChannelInfo(p)
		and UnitCreatureTypeID(t)
		and UnitCreatureTypeID(t) ~= 9
		and Health(t) <= 25 then
			if GetContainerItemCount(GetItemInfo(6265)) < 1 then
				if GetInventorySpace() >= 1 then
					if UnitCastingInfo(p) then
						SpellStopCasting()
					elseif CanCastSpell(drain_soul, t) then
						Cast(drain_soul, t)
					end
				end
			elseif GetContainerItemCount(GetItemInfo(6265)) < 2 then
				if GetInventorySpace() >= 2 then
					if UnitCastingInfo(p) then
						SpellStopCasting()
					elseif CanCastSpell(drain_soul, t) then
						Cast(drain_soul, t)
					end
				end
			end
		end
		if CanCastSpell(void)
		and (not GMR_PET_DELAY or GMR_PET_DELAY <= GetTime())
		and not Buff(p, shield)
		and GMR_WARLOCK_PET == "IMP" then
			Cast(void)
		end
		if Health("pet") <= 45 
		and Health(p) >= 50
		and GetUnitSpeed("player") == 0 
		and UnitIsUnit("targettarget", "pet") 
		and CanCastSpell(health_funnel)
		and GetDistanceBetweenObjects(p, pet) <= 20
		and not UnitCastingInfo(p)
		and not UnitChannelInfo(p) then	
			Cast(health_funnel)
		end
		if CanCastSpell(demon_armor) then
			if not Buff(p, demon_armor)
			and not Buff(p, armor) then
				Cast(demon_armor)
			end
		elseif CanCastSpell(armor) then
			if not Buff(p, armor)
			and not Buff(p, demon_armor) then
				Cast(armor)
			end
		end
		if not UnitAffectingCombat("player") then
			if GetUnitSpeed("player") == 0 then
				if UnitCastingInfo("player") == shadowbolt
				and UnitCreatureTypeID(t) ~= 11 then
					GMR_SHADOWBOLT_CAST = GetTime()+1 
				end
				if (not GMR_SHADOWBOLT_CAST or GMR_SHADOWBOLT_CAST <= GetTime())
				and (UnitLevel(p) < 15 or not CanUseWand()) then
					if CanCastSpell(shadowbolt, target) then
						Cast(shadowbolt, t) 
					end
				elseif (GMR_SHADOWBOLT_CAST	and GMR_SHADOWBOLT_CAST > GetTime())
				or UnitLevel(p) >= 15 then
					if CanCastSpell(immolate, t)
					and (not GMR_IMMOLATE_DELAY or GMR_IMMOLATE_DELAY < GetTime())
					and UnitCreatureTypeID(t) ~= 11 then
						Cast(immolate, t)
					end
				end							
			end
		else
			if Health(p) <= 60 then
				if Health(p) <= 12.5 then
					if CanCastSpell(shield) then
						Cast(shield)
					end
				end
				if GetUnitSpeed("player") == 0
				and CanCastSpell(drainlife, t)
				and not UnitCastingInfo(p)
				and UnitCreatureTypeID(t) ~= 11
				and UnitCreatureTypeID(t) ~= 9
				and not UnitChannelInfo(p) then
					Cast(drainlife, t)	
				end
			end
			if not Debuff(t, immolate)
			and GetUnitSpeed(p) == 0
			and (not GMR_IMMOLATE_DELAY or GMR_IMMOLATE_DELAY < GetTime())
			and Health(t) > 35
			and UnitCreatureTypeID(t) ~= 11 
			and IsSpellInRange(immolate, t) == 1 then
				GMR_CASTING = GetTime()+0.5
				if CanCastSpell(immolate, t) then
					Cast(immolate, t)
				end
			end
			if not Debuff(t, siphon_life)
			and CanCastSpell(siphon_life, t) then
				Cast(siphon_life, t)
			end
			if not Debuff(t, dot2)
			and CanCastSpell(dot2, t) then
				Cast(dot2, t)
			end
			if not Debuff(t, dot1)
			and GetUnitSpeed("player") == 0
			and (not GMR_CORRUPTION_DELAY or GMR_CORRUPTION_DELAY < GetTime())
			and CanCastSpell(dot1, t) then
				Cast(dot1, t)
			end
			if GMR_CASTING and GMR_CASTING > GetTime()
			and IsCurrentSpell(wand)
			and not UnitCastingInfo(p)
			and not UnitChannelInfo(p) then
				CancelPendingSpell()
			end
			if GetUnitSpeed(p) == 0 then
				if CanCastSpell(shadowbolt, t)
				and (UnitLevel(p) < 15 or not CanUseWand()) then
					if CanUseWand() then
						if Mana(p) >= 60 then
							Cast(shadowbolt, t)
						elseif not UnitCastingInfo(p) and not UnitChannelInfo(p)
						and (not GMR_CASTING or GMR_CASTING <= GetTime())
						and GetSpellCooldown(wand) == 0 then
							UseWand(t)
						end
					else
						Cast(shadowbolt, t)
					end
				elseif (GetSpellCooldown(shadowbolt) == 0 or UnitLevel(p) >= 25)
				and not UnitCastingInfo(p) and not UnitChannelInfo(p)
				and (not GMR_CASTING or GMR_CASTING <= GetTime())
				and GetSpellCooldown(wand) == 0
				and CanUseWand() then
					UseWand(t)
				end
			end
		end
	end
end
