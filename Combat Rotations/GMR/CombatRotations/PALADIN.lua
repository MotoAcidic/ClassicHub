local seal, sdm, aura, judgement, heal = GetSpellInfo(21084), GetSpellInfo(19740), GetSpellInfo(465), GetSpellInfo(20271), GetSpellInfo(639)
local seal_command, hoj, flash_of_light, lay_on_hands = GetSpellInfo(20375), GetSpellInfo(853), GetSpellInfo(19750), GetSpellInfo(633)
local bubble, hop, bubble_debuff, ret_aura, bom, gbom = GetSpellInfo(642), GetSpellInfo(1022), GetSpellInfo(25771), GetSpellInfo(7294), GetSpellInfo(19740), GetSpellInfo(25782)
local cleanse, hammer_of_wrath, sdk, gsdk, bow, gbow = GetSpellInfo(4987), GetSpellInfo(24275), GetSpellInfo(20217), GetSpellInfo(25898), GetSpellInfo(19742), GetSpellInfo(25894)
local seal_of_wisdom, judgement_wisdom = GetSpellInfo(20166), GetSpellInfo(20186)
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

if Health(p) < 60 then
	if Health(p) <= 15
	and not Buff(p, bubble_debuff) then
		if CanCastSpell(lay_on_hands, p) then
			SpellStopCasting()
			Cast(lay_on_hands, p)
		elseif CanCastSpell(bubble) then
			SpellStopCasting()
			Cast(bubble)
		elseif CanCastSpell(hop, p) then
			SpellStopCasting()
			Cast(hop, p)
		end
	end
	if CanCastSpell(hoj, t) then
		Cast(hoj, t)
	else
		if (not GetSpellInfo(seal_of_wisdom) or Buff(p, seal_of_wisdom)) then
			if CanCastSpell(heal, p) then
				Cast(heal, p)
			elseif CanCastSpell(flash_of_light, p) then
				Cast(flash_of_light, p)
			end
		end
	end
	if GetSpellInfo(seal_of_wisdom)
	and CanCastSpell(seal_of_wisdom)
	and not Buff(p, seal_of_wisdom) then
		Cast(seal_of_wisdom)
	end
else
	if (UnitCastingInfo(p) == heal
	or UnitCastingInfo(p) == flash_of_light) then
		SpellStopCasting()
	end
	if GetSpellInfo(ret_aura) then
		if CanCastSpell(ret_aura)
		and not Buff(p, ret_aura) then
			Cast(ret_aura)
		end
	elseif GetSpellInfo(aura) then
		if CanCastSpell(aura)
		and not Buff(p, aura) then
			Cast(aura)
		end
	end
	if GetSpellInfo(sdk) then
		if CanCastSpell(sdk, p)
		and not Buff(p, sdk)
		and not Buff(p, gsdk) then
			Cast(sdk, p)
		end
	elseif GetSpellInfo(bow) then
		if CanCastSpell(bow, p)
		and not Buff(p, gbow)
		and not Buff(p, bow) then
			Cast(bow, p)
		end
	elseif GetSpellInfo(bom) then
		if CanCastSpell(bom, p)
		and not Buff(p, gbom)
		and not Buff(p, bom) then
			Cast(bom, p)
		end
	end
	if GetSpellInfo(seal_of_wisdom) then
		if CanCastSpell(seal_of_wisdom)
		and not Buff(p, seal_of_wisdom) then
			Cast(seal_of_wisdom)
		end
	elseif GetSpellInfo(seal_command) then
		if CanCastSpell(seal_command)
		and not Buff(p, seal_command) then
			Cast(seal_command)
		end
	elseif GetSpellInfo(seal) then
		if CanCastSpell(seal)
		and not Buff(p, seal) then
			Cast(seal)
		end
	end
	if Mana(p) >= 35 then
		if CanCleanseDebuff()
		and not UnitCastingInfo(p)
		and CanCastSpell(cleanse, p) then
			Cast(cleanse, p)
		end
		if CanCastSpell(judgement, t)
		and not UnitCastingInfo(p)
		and (not Debuff(t, judgement_wisdom) or Mana(p) >= 50) then
			Cast(judgement, t)
		end
	elseif CanCastSpell(judgement, t)
	and not UnitCastingInfo(p)
	and not Debuff(t, judgement_wisdom)
	and Buff(p, seal_of_wisdom) then
		Cast(judgement, t)
	end
end
