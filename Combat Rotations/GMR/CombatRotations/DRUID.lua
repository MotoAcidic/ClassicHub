local wrath, healingTouch, regrowth, rejuvenation, faerie = GetSpellInfo(9912), GetSpellInfo(25297), GetSpellInfo(9858), GetSpellInfo(25299), GetSpellInfo(9907)
local moonfire, innervate, buff, thorns, insects = GetSpellInfo(9835), GetSpellInfo(29166), GetSpellInfo(9885), GetSpellInfo(9910), GetSpellInfo(24977)
local bear2, bear, cat, travel = GetSpellInfo(9634), GetSpellInfo(5487), GetSpellInfo(768), GetSpellInfo(783)
local bash, maul, swpie, enrage, regen = GetSpellInfo(5211), GetSpellInfo(6807), GetSpellInfo(779), GetSpellInfo(5229), GetSpellInfo(22842)
local comboPoints = GetComboPoints("player", "target")
local rake, finisher, claw, fury, fearieFeral = GetSpellInfo(1822), GetSpellInfo(22568), GetSpellInfo(1082), GetSpellInfo(5217), GetSpellInfo(16857)
local barkskin = GetSpellInfo(22812)
local t, f, p, pet = "target", "focus", "player", "pet"

if UnitCastingInfo(p) == regrowth
and Health(p) >= 70 then
	SpellStopCasting()
end
if CanCastSpell(buff, p)
and not Buff(p, buff) then
	if GetShapeshiftForm() ~= 0 then
		CancelShapeshift()
	else
		Cast(buff, p)
	end
end
if CanCastSpell(thorns, p)
and not Buff(p, thorns) then
	if GetShapeshiftForm() ~= 0 then
		CancelShapeshift()
	else
		Cast(thorns, p)
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

if Mana(p)
and Mana(p) <= 50
and CanCastSpell(innervate, p) then
	if CanCastSpell(bash, t) then
		Cast(bash, t) 
	else
		if GetShapeshiftForm() ~= 0 then
			CancelShapeshift()
		else
			Cast(innervate, p)
		end
	end
end
if Health("player") <= 65
and not Buff(p, rejuvenation)
and ((Mana("player") and Mana("player") >= 50) or GetHighestDruidForm() == "Human") then
	if CanCastSpell(bash, t) then
		Cast(bash, t)
	else
		if GetShapeshiftForm() ~= 0 then
			CancelShapeshift()
		else
			if CanCastSpell(regrowth, p)
			and not Buff(p, regrowth)
			and GetUnitSpeed("player") == 0 then
				Cast(regrowth, p)
			elseif CanCastSpell(rejuvenation, p)
			and GetUnitSpeed("player") == 0 
			and not Buff(p, rejuvenation) then
				Cast(rejuvenation, p)
			end
		end
	end
else
	if GetHighestDruidForm() == "Bear Form" then
		if ENEMY_COMBAT_RANGE ~= 5 then
			ENEMY_COMBAT_RANGE = 5
		end
		if GetShapeshiftForm() ~= 1 then
			if GetShapeshiftFormCooldown(1) == 0
			and (not GMR_BEAR_FORM_TIMER or GMR_BEAR_FORM_TIMER <= GetTime()) then
				GMR_BEAR_FORM_TIMER = GetTime()+1
				CastShapeshiftForm(1)
			end
		else
			if Health("player") <= 85 then
				if CanCastSpell(regen) then
					Cast(regen)
				end
				if CanCastSpell(barkskin) then
					Cast(barkskin)
				end
			end
			if CanCastSpell(enrage) then
				Cast(enrage)
			end
			if GetNumEnemies(t, 5) >= 2 then
				if CanCastSpell(swipe, t)
				and not IsCurrentSpell(swipe) then
					Cast(swipe, t)
				end
			elseif CanCastSpell(maul, t)
			and not IsCurrentSpell(maul) then
				Cast(maul, t)
			end
		end
	elseif GetHighestDruidForm() == "Cat Form" then
		if ENEMY_COMBAT_RANGE ~= 5 then
			ENEMY_COMBAT_RANGE = 5
		end
		if not Buff(p, cat) then
			if CanCastSpell(cat) then
				Cast(cat)
			end
		else
			if Health(p) <= 80 
			and CanCastSpell(barkskin) then
				Cast(barkskin)
			end
			if not Debuff(t, fearieFeral)
			and CanCastSpell(fearieFeral, t) then
				Cast(fearieFeral, t)
			elseif CanCastSpell(rake, t)
			and not Debuff(t, rake) then
				Cast(rake, t)
			elseif CanCastSpell(finisher, t)
			and comboPoints >= 4 then
				Cast(finisher, t)
			elseif CanCastSpell(claw, t) then
				Cast(claw, t)
			end
		end
	elseif GetHighestDruidForm() == "Human Form" then
		if ENEMY_COMBAT_RANGE ~= 29 then
			ENEMY_COMBAT_RANGE = 29
		end
		if not UnitAffectingCombat(p) then
			if GetUnitSpeed("player") == 0 
			and CanCastSpell(wrath, t) then
				Cast(wrath, t)
			end
		else
			if CanCastSpell(moonfire, t)
			and not Debuff(t, moonfire) then
				Cast(moonfire, t)
			elseif CanCastSpell(insects, t)
			and not Debuff(t, insects) then
				Cast(insects, t)
			elseif CanCastSpell(wrath, t)
			and GetUnitSpeed("player") == 0 then
				Cast(wrath, t)
			end
		end
	end
end