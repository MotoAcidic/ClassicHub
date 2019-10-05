local addon, dark_addon = ...

dark_addon.rotation.timer = {
  lag = 0
}

local gcd_spell, gcd_spell_name

local function find_gcd_spell()
  local _, _, offset, numSpells = GetSpellTabInfo(2)
  for i = offset + 1, offset + numSpells do
    local slotType, slotID = GetSpellBookItemInfo(i, 'spell')
    if slotType == 'SPELL' then
      local slotName = GetSpellBookItemName(i, 'spell')
      local spellName, _, _, _, _, _, spellID = GetSpellInfo(slotName)
      local spellCD = GetSpellBaseCooldown(spellID or 0) -- spellID can be nil during loading
      local spellCharges = GetSpellCharges(spellID)
      if spellCD == 0 and spellCharges == nil then
        gcd_spell = spellID
        gcd_spell_name = spellName
        break
      end
    end
  end

  C_Timer.After(0.5, function()
    if not gcd_spell then
      dark_addon.console.debug(2, 'engine', 'engine', 'No GCD candidate found!')
    else
      dark_addon.console.debug(2, 'engine', 'engine', string.format('GCD candidate found, using %s (%s)', gcd_spell, gcd_spell_name))
    end
  end)
end

dark_addon.event.register('SPELLS_CHANGED', find_gcd_spell)

local last_loading = GetTime()
local loading_wait = math.random(120, 300)
local last_duration = false
local lastLag = 0
local castclip = 0
local turbo = false

function dark_addon.rotation.tick(ticker)
  turbo = dark_addon.settings.fetch('_engine_turbo', false)
  castclip = dark_addon.settings.fetch('_engine_castclip', 0.15)
  ticker._duration = dark_addon.settings.fetch('_engine_tickrate', 0.1)
  if ticker._duration ~= last_duration then
    last_duration = ticker._duration
    dark_addon.console.debug(2, 'engine', 'engine', string.format('Ticket Rate: %sms', last_duration * 1000))
  end
  local toggled = dark_addon.settings.fetch_toggle('master_toggle', false)
  if not toggled then
    dark_addon.interface.status('Ready...')
    return
  end

  local do_gcd = dark_addon.settings.fetch('_engine_gcd', true)
  local gcd_wait, start, duration = false
  if gcd_spell and do_gcd then
    start, duration = GetSpellCooldown(gcd_spell)
    gcd_wait = start > 0 and (duration - (GetTime() - start)) or 0
  end

  if dark_addon.rotation.active_rotation then
    if IsMounted() then return end

    local _, _, lagHome, lagWorld = GetNetStats()
    local lag = (((lagHome + lagWorld) / 2) / 1000) * 2
    if lag ~= lastLag then
      dark_addon.console.debug(2, 'engine', 'engine', string.format('Lag: %sms', lag * 1000))
      lastLag = lag
      dark_addon.rotation.timer.lag = lag
    end

    if not turbo and (gcd_wait and gcd_wait > (lag + castclip)) then
      if dark_addon.rotation.active_rotation.gcd then
        return dark_addon.rotation.active_rotation.gcd()
      else
        return
      end
    end

    if UnitAffectingCombat('player') then
      dark_addon.rotation.active_rotation.combat()
    else
      dark_addon.rotation.active_rotation.resting()
      if GetTime() - last_loading > loading_wait then
        dark_addon.interface.status_override(
          dark_addon.interface.loading_messages[math.random(#dark_addon.interface.loading_messages)],
          10
        )
        last_loading = GetTime()
        loading_wait = math.random(120, 300)
      else
        dark_addon.interface.status('Resting...')
      end
    end
  end
end




dark_addon.on_ready(function()
  dark_addon.rotation.timer.ticker = C_Timer.NewAdvancedTicker(0.1, dark_addon.rotation.tick)
end)
