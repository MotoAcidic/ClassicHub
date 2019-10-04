local frostbolt, nova, shield, armor, buff, cone = GetSpellInfo(116), GetSpellInfo(122), GetSpellInfo(11426), GetSpellInfo(168), GetSpellInfo(10157), GetSpellInfo(120)
local mana_gem, blast_wave, fireball, scorch, fireblast = GetSpellInfo(10054), GetSpellInfo(13021), GetSpellInfo(10151), GetSpellInfo(10207), GetSpellInfo(10199)
local blink, ice_armor, polymorph = GetSpellInfo(1953), GetSpellInfo(7302), GetSpellInfo(118)
local createFood, createDrink, amplify_magic, evocation, ice_barrier = GetSpellInfo(587), GetSpellInfo(5504), GetSpellInfo(604), GetSpellInfo(12051), GetSpellInfo(11426)
local t, f, p, pet = "target", "focus", "player", "pet"

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

if UnitCastingInfo(p) == polymorph then
	GMR_POLYMORPH_DELAY = GetTime()+9
end
if CanCastSpell(nova)
and GMR_FROSTNOVA == "CD" then
	GMR_FROSTNOVA = nil
end
if CanCastSpell(blink)
and GMR_BLINK == "CD" then
	GMR_BLINK = nil
end
if not UnitAffectingCombat("player")
and GetInventorySpace() ~= 0
and ((not GetFood() and GetSpellInfo(createFood))
or (not GetDrink() and GetSpellInfo(createDrink))) then
	if not UnitCastingInfo("player") then
		if not GetFood()
		and CanCastSpell(createFood) then
			Cast(createFood)
		end
		if not GetDrink()
		and CanCastSpell(createDrink) then
			Cast(createDrink)
		end
	end
else
	if GetSpellInfo(nova)
	and GetDistanceBetweenObjects(p, t) <= 12
	and GetDistanceBetweenObjects(p, t) >= 5.5
	and not GMR_FROSTNOVA then
		SpellStopCasting()
		if CanCastSpell(nova) then
			GMR_FROSTNOVA = "CD"
			Cast(nova)
		end
	end
	if GMR_BLINK == true then
		if GetDistanceBetweenObjects(p, t)
		and GetDistanceBetweenObjects(p, t) <= 5
		and not UnitIsDeadOrGhost(t)
		and GMR_BLINK ~= "CD"
		and ((not GetSpellInfo(nova) or (GetSpellInfo(nova) and GetSpellCooldown(nova) ~= 0 and GetSpellCooldown(frostbolt) == 0)) or (GetDistanceBetweenObjects(p, t) and GetDistanceBetweenObjects(p, t) <= 5))
		and GetSpellInfo(blink) then
			if GetWaypointInLoS() then
				local x, y, z = GetWaypointInLoS()[1], GetWaypointInLoS()[2], GetWaypointInLoS()[3]
				local a, b, c = ObjectPosition("player")
				if x and a then
					if UnitCastingInfo("player") then
						if GetSpellCooldown(blink) == 0 then
							SpellStopCasting()
						end
					else
						local angles = GetAnglesBetweenCoordinates(a, b, c, x, y, z)
						if Software("LuaBox") then
							__LB__.SetPlayerAngles(angles)
							Cast(blink)
							GMR_BLINK = "CD"
						elseif Software("EWT") then
							FaceDirection(angles, true)
							Cast(blink)
							GMR_BLINK = "CD"
						end
					end
				end
			end
		end
	end
	if Debuff(t, nova)
	and CanCastSpell(cone)
	and Health(t) < 25
	and GetDistanceBetweenObjects(p, t) <= 12 then
		Cast(cone)
	end

	if Debuff(t, nova)
	and Health(t) > 25
	and CanCastSpell(frostbolt) then
		Cast(frostbolt)
	end

	if not UnitAffectingCombat("player") then
		if Health(p) > 75
		and Mana(p) < 35
		and CanCastSpell(evocation) then
			Cast(evocation)
		end

		if GetSpellInfo(armor) then
			if CanCastSpell(armor)
			and not Buff(p, armor) then
				Cast(armor)
			end
		if CanCastSpell(buff, p)
		and not Buff(p, buff) then
			Cast(buff, p)
		elseif CanCastSpell(amplify_magic, p)
		and not Buff(p, amplify_magic) then
			Cast(amplify_magic, p)
		end
		end
		if CanCastSpell(buff, p)
		and not Buff(p, buff) then
			Cast(buff, p)
		end
	end
	if not GetSpellInfo(ice_barrier) then
		if Health("player") <= 95
		and CanCastSpell(ice_barrier) then
			Cast(ice_barrier)
	end
	elseif CanCastSpell(ice_barrier)
	and not Buff(p, ice_barrier) then
		Cast(ice_barrier)
	end
	if CanCastSpell(blast_wave)
	and GetDistanceBetweenObjects(p, t) <= 6 then
		Cast(blast_wave)
	elseif CanCastSpell(fireblast, t)
	and UnitAffectingCombat(p)
	and not Debuff(t, nova)
	and not UnitCastingInfo(p) then
		Cast(fireblast)
	elseif GetUnitSpeed(p) == 0 then
		if GetSpellInfo(frostbolt) then
			if IsUsableSpell(frostbolt)
			and Mana(p) >= 7 then
				if CanCastSpell(frostbolt, t) then
					Cast(frostbolt, t)
				end
			elseif CanUseWand() then
				UseWand(t)
			end
		elseif GetSpellInfo(fireball) then
			if IsUsableSpell(fireball)
			and Mana(p) >= 7 then
				if CanCastSpell(fireball, t) then
					Cast(fireball, t)
				end
			elseif CanUseWand() then
				UseWand(t)
			end
		end
	end
end
