local addon, dark_addon = ...
local rc = LibStub("LibRangeCheck-2.0")
local disp = LibStub("LibDispellable-1.0")
local UnitReverseDebuff = dark_addon.environment.unit_reverse_debuff

local unit = { }
local calledUnit

function unit:buff()
  return dark_addon.environment.conditions.buff(self)
end

function unit:debuff()
  return dark_addon.environment.conditions.debuff(self)
end

function unit:health()
  return dark_addon.environment.conditions.health(self)
end

function unit:spell()
  return dark_addon.environment.conditions.spell(self)
end

function unit:power()
  return dark_addon.environment.conditions.power(self)
end

function unit:enemies()
  return dark_addon.environment.conditions.enemies(self)
end

function unit:alive()
  return not UnitIsDeadOrGhost(self.unitID)
end

function unit:level()
  return UnitLevel(self.unitID)
end

function unit:dead()
  return UnitIsDeadOrGhost(self.unitID)
end

function unit:enemy()
  return UnitCanAttack('player', self.unitID)
end

function unit:friend()
  return not UnitCanAttack('player', self.unitID)
end

function unit:name()
  return UnitName(self.unitID)
end

function unit:exists()
  return UnitExists(self.unitID)
end

function unit:guid()
  return UnitGUID(self.unitID)
end

 function unit:distance()
   local minRange, maxRange = rc:GetRange(self.unitID)
   if not minRange then
     return nil
   elseif not maxRange then
     return nil
   else
     return maxRange
   end
 end

local function channeling(spell)
  local channeling_spell = ChannelInfo(calledUnit.unitID)
  if channeling_spell then
    if spell then
      if tonumber(spell) then
        spell = GetSpellInfo(spell)
      end
      if channeling_spell == spell then
        return true
      else
        return false
      end
    else
      return true
    end
  else
    return false
  end
end

function unit:channeling(spell)
  return channeling
end

function unit:castingpercent()
  local castingname, _, _, startTime, endTime, notInterruptible = CastingInfo("player")
  if castingname  then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return ((secondsLeft/castLength)*100)
  end
  return 0
end

function unit:moving()
  return GetUnitSpeed(self.unitID) ~= 0
end

function unit:has_stealable()
  local has_stealable = false
  for i = 1, 40 do
    buff, _, count, _, duration, expires, caster, stealable, _, spellID = _G['UnitBuff'](self.unitID, i)
    if stealable then has_stealable = true end
  end
  return has_stealable
end

function unit:combat()
  return UnitAffectingCombat(self.unitID)
end

local function unit_interrupt(percent, spell)
  local percent = tonumber(percent) or 100
  local spell = GetSpellInfo(spell) or false
  local name, startTime, endTime, notInterruptible
  name, _, _, startTime, endTime, _, _, notInterruptible, _ = CastingInfo(calledUnit.unitID)
  if not name then
    name, _, _, startTime, endTime, _, _, notInterruptible, _ = ChannelInfo(calledUnit.unitID)
  end
  if name and startTime and endTime and ((spell and name == spell) or (not spell and not notInterruptible)) then
    local castTimeRemaining = endTime / 1000 - GetTime()
    local castTimeTotal = (endTime - startTime) / 1000
    if castTimeTotal > 0 and castTimeRemaining / castTimeTotal * 100 <= percent then
      return true
    end
  end
  return false
end

function unit:interrupt()
  return unit_interrupt
end

local function unit_in_range(spell)
  if tonumber(spell) then
    name = GetSpellInfo(spell)
  end
  return IsSpellInRange(spell, calledUnit.unitID) == 1
end

function unit:in_range()
  return unit_in_range
end

local function totem_cooldown(name)
  if tonumber(name) then
    name = GetSpellInfo(name)
  end
  local haveTotem, totemName, startTime, duration
  for i = 1, 4 do
    haveTotem, totemName, startTime, duration = GetTotemInfo(i)
    if totemName == name then
      return duration - (GetTime() - startTime)
    end
  end
  return 0
end

function unit:totem()
  return totem_cooldown
end


local function unit_talent(a, b)
  local tier, column
  if type(a) == 'table' then
    tier = a[1]
    column = a[2]
  else
    tier = a
    column = b
  end
  local talentID, name, texture, selected, available, spellID, unknown, row, column, unknown, known = GetTalentInfo(tier, column, GetActiveSpecGroup())
  return available
end

function unit:talent()
  return unit_talent
end

local death_tracker = {}
function unit:time_to_die()
  if death_tracker[self.unitID] and death_tracker[self.unitID].guid == UnitGUID(self.unitID) then
    local health_change = death_tracker[self.unitID].health - UnitHealth(self.unitID)
    local time_change = GetTime() - death_tracker[self.unitID].time
    local health_per_time = health_change / time_change
    local time_to_die = UnitHealth(self.unitID) / health_per_time
    return math.min(math.max(time_to_die, 0), 9999) -- give it the clamps
  end
  if not death_tracker[self.unitID] then death_tracker[self.unitID] = {} end
  death_tracker[self.unitID].guid = UnitGUID(self.unitID)
  death_tracker[self.unitID].time = GetTime()
  death_tracker[self.unitID].health = UnitHealth(self.unitID)
  return 9999
end

local function spell_cooldown(spell)
  local time, value = GetSpellCooldown(spell)
  if not time or time == 0 then
    return 0
  end
  local cd = time + value - GetTime() - (select(4, GetNetStats()) / 1000)
  if cd > 0 then
    return cd
  else
    return 0
  end
end

local function spell_castable(spell)
  spell = GetSpellInfo(spell)
  local usable, noMana = IsUsableSpell(spell)
  local inRange = IsSpellInRange(spell, calledUnit.unitID)
  if usable and inRange == 1 then
    if spell_cooldown(spell) == 0 then
      return true
    else
      return false
    end
  end
  return false
end

function unit:castable()
  return spell_castable
end

local function check_removable(removable_type)
  local debuff, count, duration, expires, caster, found_debuff = UnitReverseDebuff(calledUnit.unitID, dark_addon.data.removables[removable_type])
  if debuff and (count == 0 or count >= found_debuff.count) and calledUnit.health.percent <= found_debuff.health then
    return unit
  end
  return false
end

local function unit_removable(...)
  for i = 1, select('#', ...) do
    local removable_type, _ = select(i, ...)
    if dark_addon.data.removables[removable_type] then
      local possible_unit = check_removable(removable_type)
      if possible_unit then
        return possible_unit
      end
    end
  end
  return false
end

function unit:removable(...)
  return unit_removable
end

local function unit_dispellable(spell)
  return disp:CanDispelWith(calledUnit.unitID, spell)
end

function unit:dispellable(spell)
  return unit_dispellable
end

function dark_addon.environment.conditions.unit(unitID)
  return setmetatable({
    unitID = unitID
  }, {
    __index = function(t, k, k2)
      if t and k then
        calledUnit = t
        return unit[k](t)
      end
    end
  })
end

local player_hook = dark_addon.environment.conditions.unit('player')
local player_spell_hook = player_hook['spell']
dark_addon.environment.hooks.spell = player_spell_hook
dark_addon.environment.hooks.buff = player_hook['buff']
dark_addon.environment.hooks.debuff = player_hook['debuff']
dark_addon.environment.hooks.power = player_hook['power']
dark_addon.environment.hooks.health = player_hook['health']
dark_addon.environment.hooks.talent = player_hook['talent']
dark_addon.environment.hooks.totem = player_hook['totem']
dark_addon.environment.hooks.enemies = player_hook['enemies']

dark_addon.environment.hooks.castable = function(spell)
  return player_spell_hook(spell)['castable']
end

dark_addon.environment.hooks.lastcast = function(spell)
  return player_spell_hook(spell)['lastcast']
end
