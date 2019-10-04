local fire, smite, heal, pain, devour, shield, hot = GetSpellInfo(14914), GetSpellInfo(585), GetSpellInfo(2050), GetSpellInfo(589), GetSpellInfo(2944), GetSpellInfo(17), GetSpellInfo(139)
local shield_debuff, inner_fire, buff, mindblast, embrace = GetSpellInfo(6788), GetSpellInfo(588), GetSpellInfo(1244), GetSpellInfo(8092), GetSpellInfo(15286)
local flash_heal, mind_flay, shadowform = GetSpellInfo(2061), GetSpellInfo(15407), GetSpellInfo(15473)
local t, f, p, pet = "target", "focus", "player", "pet"

if Buff("player", shadowform) 
and Health(p) < 40 then
	CancelBuff(shadowform)
end
if (UnitCastingInfo("player") == fire
or UnitCastingInfo("player") == smite)
and UnitIsDeadOrGhost(t) then
	SpellStopCasting()
end
if UnitCastingInfo(p) == fire
and Debuff(t, fire) then
	SpellStopCasting()
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

if not UnitCastingInfo("player") and not UnitChannelInfo("player") then
	if not Buff(p, shield)
	and not Debuff(p, shield_debuff)
	and CanCastSpell(shield, p) then
		Cast(shield, p)
	end
	if Health(p) <= 80
	and not Buff(p, hot)
	and CanCastSpell(hot, p) then
		Cast(hot, p)
	end
	if Health(p) <= 60
	and GetUnitSpeed(p) == 0 then
		if CanCastSpell(flash_heal, p) then
			Cast(flash_heal, p)
		elseif CanCastSpell(heal, p)
		and not GetSpellInfo(flash_heal) then
			Cast(heal, p)
		end
	end
	if CanCastSpell(buff, p)
	and not Buff(p, buff) then
		Cast(buff, p)
	end
	if CanCastSpell(inner_fire)
	and not Buff(p, inner_fire) then
		Cast(inner_fire)
	end
	if not UnitAffectingCombat(p) then
		if GetUnitSpeed(p) == 0 then
			if CanCastSpell(shadowform) 
			and Health("player") >= 40
			and not Buff(p, shadowform) then
				Cast(shadowform)
			end
			if CanCastSpell(mindblast, t) then
				Cast(mindblast, t)
			elseif CanCastSpell(fire, t) then
				Cast(fire, t)
			elseif CanCastSpell(smite, t) then
				Cast(smite, t)
			end
		end
	else
		if CanCastSpell(shadowform) 
		and Health(p) >= 40
		and not Buff(p, shadowform) then
			Cast(shadowform)
		end
		if CanCastSpell(pain, t)
		and not Debuff(t, pain)
		and UnitCreatureTypeID(t) ~= 11 then
			Cast(pain, t)
		end
		if CanCastSpell(embrace, t)
		and not Debuff(t, embrace)
		and UnitCreatureTypeID(t) ~= 11 then
			Cast(embrace, t)
		end
		if CanCastSpell(devour, t)
		and not Debuff(t, devour)
		and UnitCreatureTypeID(t) ~= 11 then
			Cast(devour, t)
		end
		if CanCastSpell(mindblast, t) then
			if GetUnitSpeed(p) == 0 then
				if Mana(p) >= 60 then
					Cast(mindblast, t)
				elseif CanUseWand() then
					UseWand(t)
				end
			end
		elseif CanCastSpell(mind_flay, t)
		and UnitCreatureTypeID(t) ~= 11 then
			if GetUnitSpeed(p) == 0 then
				if CanUseWand() then
					if Mana(p) >= 60 then
						Cast(mind_flay, t)
					else
						UseWand(t)
					end
				else
					Cast(mind_flay, t)
				end
			end
		elseif GetUnitSpeed(p) == 0 then
			if CanCastSpell(smite, t) then
				if CanUseWand() then
					if Mana(p) >= 60 then
						Cast(smite, t)
					else
						UseWand(t)
					end
				else
					Cast(smite, t)
				end
			elseif GetSpellCooldown(smite) == 0 
			and CanUseWand() then
				UseWand(t)
			end
		end
	end
end