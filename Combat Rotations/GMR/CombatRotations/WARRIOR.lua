local stance, rend, ms, hamstring, heroic_strike = GetSpellInfo(2457), GetSpellInfo(11573), GetSpellInfo(12294), GetSpellInfo(1715), GetSpellInfo(78)
local Charge, Intercept, Execute, Mocking_Blow, Overpower = GetSpellInfo(11578), GetSpellInfo(20617), GetSpellInfo(20662), GetSpellInfo(20560), GetSpellInfo(11584)
local Battle_Shout, Bloodthirst, Revenge, Recklessness = GetSpellInfo(25289), GetSpellInfo(23894), GetSpellInfo(25288), GetSpellInfo(1719)
local bloodrage, retaliation, cleave = GetSpellInfo(2687), GetSpellInfo(20230), GetSpellInfo(845)
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

if not GetShapeshiftForm() then
	if CanCastSpell(stance) then
		Cast(stance)
	end
else
	if CanCastSpell(Charge, t)
	and not UnitAffectingCombat("player") then
		Cast(Charge, t)
	elseif CanCastSpell(Intercept, t) then
		Cast(Intercept, t)
	elseif CanCastSpell(retaliation)
	and IsSpellInRange(rend, t) == 1 
	and GetNumEnemies(t) >= 3 then
		Cast(retaliation)
	elseif CanCastSpell(Battle_Shout)
	and not Buff(p, Battle_Shout) then
		Cast(Battle_Shout)
	elseif CanCastSpell(Recklessness) then
		Cast(Recklessness)
	elseif CanCastSpell(Execute, t) then
		Cast(Execute, t)
	elseif CanCastSpell(Overpower, t) then
		Cast(Overpower, t)
	elseif CanCastSpell(rend, t)
	and UnitCreatureTypeID(t) ~= 9
	and UnitCreatureTypeID(t) ~= 11
	and not Debuff(t, rend) then
		Cast(rend, t)
	elseif CanCastSpell(bloodrage)
	and UnitAffectingCombat(p) then
		Cast(bloodrage)
	elseif CanCastSpell(ms, t) then
		Cast(ms, t)
	elseif CanCastSpell(Bloodthirst, t) then
		Cast(Bloodthirst, t)
	elseif CanCastSpell(Revenge, t) then
		Cast(Revenge, t)
	elseif CanCastSpell(Mocking_Blow, t) then
		Cast(Mocking_Blow, t)
	elseif GetNumEnemies(t, 5) >= 2
	and CanCastSpell(cleave, t)
	and not IsCurrentSpell(cleave)
	and not IsCurrentSpell(heroic_strike) then
		Cast(cleave)
	elseif CanCastSpell(heroic_strike, t)
	and not IsCurrentSpell(cleave)
	and not IsCurrentSpell(heroic_strike) then
		Cast(heroic_strike, t)
	end
end