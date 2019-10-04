local SinisterStrike, SliceandDice, AdrenalineRush, Eviscerate, Evasion = GetSpellInfo(1752), GetSpellInfo(6774), GetSpellInfo(13750), GetSpellInfo(2098), GetSpellInfo(5277)
local blade_flurry, blood_fury = GetSpellInfo(13877), GetSpellInfo(20572)
local vanish, cheap_shot, stealth, blind = GetSpellInfo(1856), GetSpellInfo(1833), GetSpellInfo(1784), GetSpellInfo(2094)
local comboPoints = GetComboPoints("player", "target")
local t, f, p, pet = "target", "focus", "player", "pet"

if not UnitAffectingCombat("player") then
	if not Buff(p, vanish) then
		if GetSpellInfo(stealth)
		and GetSpellInfo(cheap_shot) then
			if not Buff(p, stealth) then
				Cast(stealth)
			elseif CanCastSpell(cheap_shot, t) then
				Cast(cheap_shot, t)
			end
		end
	end
else
	local enemyCount, enemyTable = GetNumEnemies(t, 6.5)
	if GetSpellInfo(blind)
	and enemyCount
	and enemyTable and #enemyTable >= 2 then
		for i = 1,#enemyTable do
			local enemy = enemyTable[i]
			if enemy ~= ObjectPointer("target")
			and CanCastSpell(blind, enemy) then
				Cast(blind, enemy)
			end
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


	if CanCastSpell(vanish)
	and Health(p) <= 20 then
		Cast(vanish)
	end
	if CanCastSpell(Evasion)
	and (Health(p) <= 40 or enemyCount >= 2) then
		Cast(Evasion)
	end
	if CanCastSpell(SliceandDice)
	and not Buff(p, SliceandDice)
	and UnitLevel(p) >= 40
	and comboPoints >= 2 then
		Cast(SliceandDice)
	elseif CanCastSpell(blade_flurry)
	and not Buff(p, blade_flurry)
	and enemyCount >= 2
	and IsSpellInRange(SinisterStrike, t) then
		Cast(blade_flurry)
	elseif CanCastSpell(blood_fury)
	and IsSpellInRange(SinisterStrike, t) == 1 then
		Cast(blood_fury)
	elseif CanCastSpell(Eviscerate, t)
	and (comboPoints >= 4
	or (comboPoints >= 2
	and Health(t) >= 30)) then
		Cast(Eviscerate, t)
	elseif CanCastSpell(AdrenalineRush)
	and not Buff(p, AdrenalineRush)
	and enemyCount >= 2
	and IsSpellInRange(SinisterStrike, t) then
		Cast(AdrenalineRush)
	elseif CanCastSpell(SinisterStrike, t) then
		Cast(SinisterStrike, t)
	end

end
