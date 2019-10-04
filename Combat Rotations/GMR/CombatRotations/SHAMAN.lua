local flameshock, frostshock, lightning_bolt, searing_totem = GetSpellInfo(8050), GetSpellInfo(8056), GetSpellInfo(403), GetSpellInfo(3599)
local small_heal, big_heal, lightning_shield, flametongue = GetSpellInfo(8004), GetSpellInfo(331), GetSpellInfo(324), GetSpellInfo(8024)
local totemName, _, _, _, icon = GetTotemInfo(1)
local t, f, p, pet = "target", "focus", "player", "pet"

if Health(p) <= 65 then
	if CanCastSpell(small_heal, p) then
		Cast(small_heal, p)
	elseif CanCastSpell(big_heal, p) then
		Cast(big_heal, p)
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

if GetWeaponEnchantInfo() ~= true
and CanCastSpell(flametongue) then
	Cast(flametongue)
end
if CanCastSpell(lightning_shield)
and not Buff(p, lightning_shield) then
	Cast(lightning_shield)
end
if not UnitAffectingCombat(p) then
	if (not totemName or (totemName and icon ~= 135825))
	and CanCastSpell(searing_totem) then
		Cast(searing_totem)
	end
	if CanCastSpell(lightning_bolt, t)
	and UnitCreatureTypeID(t) ~= 4 then
		Cast(lightning_bolt, t)
	end
end
if CanCastSpell(frostshock, t)
and not Debuff(t, frostshock) then
	Cast(frostshock, t)
elseif (not totemName or (totemName and icon ~= 135825))
and CanCastSpell(searing_totem) then
	Cast(searing_totem)
elseif CanCastSpell(flameshock, t) then
	Cast(flameshock, t)
elseif CanCastSpell(lightning_bolt, t)
and UnitCreatureTypeID(t) ~= 4 then
	Cast(lightning_bolt, t)
end
