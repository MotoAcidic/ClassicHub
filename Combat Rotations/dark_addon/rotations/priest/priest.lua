local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.priest

local function combat()
  if player.dead or player.channeling() then return end

  -- Pause if eating or drinking
  if dark_addon.settings.fetch('cpl_drinking', true) then
    for i=1,40 do
      local name, _ = UnitBuff("player",i)
      if name =='Drink' or name =='Food' then return end
    end
  end

  -- Fade - Reduce threat

  -- Stoneform - Removes Bleed, Poison, Disease +10% armor.
  if dark_addon.settings.fetch('cpl_stoneform', true)
  and player.removable('bleed', 'poison', 'disease')
  and castable(SB.Stoneform) then
    return cast(SB.Stoneform, player)
  end

  -- Dispell Magic
  local dispell_unit = group.removable('magic')
  if toggle('dispel', false)
  and dark_addon.settings.fetch('cpl_dispellmagic', true)
  and dispell_unit
  and castable(SB.DispellMagic) then
    return cast(SB.DispellMagic, dispell_unit)
  end

  -- Cure Disease
  local cure_unit = group.removable('disease')
  if toggle('dispel', false)
  and dark_addon.settings.fetch('cpl_curedisease', true)
  and cure_unit
  and castable(SB.CureDisease) then
    return cast(SB.CureDisease, cure_unit)
  end

  --- SELF HEALING
  -- Healthstone
  if GetItemCooldown(5512) == 0 
  and player.health.percent <= dark_addon.settings.fetch('cpl_healthstone.spin', 10) 
  and dark_addon.settings.fetch('cpl_healthstone.check', false) then
    macro('/use Healthstone')
  end
  -- Desperate Prayer
  if castable(SB.DesperatePrayer) 
  and player.health.percent < dark_addon.settings.fetch('cpl_desperate.spin', 20)
  and dark_addon.settings.fetch('cpl_desperate.check', false) then
    return cast(SB.DesperatePrayer, player)
  end
  -- Power Word Shield
  if castable(SB.PowerWordShield)
  and not player.buff(SB.PowerWordShield).exists
  and (player.power.mana.percent > dark_addon.settings.fetch('cpl_pws.spin', 90) or player.health.percent < 30)
  and not player.debuff(SB.WeakenedSoul).exists
  and dark_addon.settings.fetch('cpl_pws.check', false) then
    return cast(SB.PowerWordShield, player)
  end
  -- Heal
  if castable(SB.Heal) 
  and not player.moving
  and player.health.percent < dark_addon.settings.fetch('cpl_heal.spin', 40)
  and dark_addon.settings.fetch('cpl_heal.check', false) then
    return cast(SB.Heal, player)
  end
  -- Lesser Heal
  if castable(SB.LesserHeal)
  and not player.moving
  and player.health.percent < dark_addon.settings.fetch('cpl_lesserheal.spin', 60)
  and dark_addon.settings.fetch('cpl_lesserheal.check', false) then
    return cast(SB.LesserHeal, player)
  end
  -- Renew
  if castable(SB.Renew)
  and not player.buff(SB.Renew).exists 
  and player.health.percent < dark_addon.settings.fetch('cpl_renew.spin', 80)
  and dark_addon.settings.fetch('cpl_renew.check', false) then
    return cast(SB.Renew, player)
  end

  --- DPS SPELLS
  if not target.exists or not target.enemy or not target.alive then return end
  if toggle('dps', false) then
    -- Shadow Word Pain
    if castable(SB.ShadowWordPain)
    and not target.debuff(SB.ShadowWordPain).exists 
    and target.health.actual > dark_addon.settings.fetch('cpl_swp.spin', 50)
    and dark_addon.settings.fetch('cpl_swp.check', true) then
      return cast(SB.ShadowWordPain, target)
    end
    -- Mind Blast
    if castable(SB.MindBlast) 
    and not player.moving 
    and dark_addon.settings.fetch('cpl_mindblast', true) then
      return cast(SB.MindBlast, target)
    end
    -- Smite
    if castable(SB.Smite) 
    and not player.moving 
    and player.power.mana.percent > dark_addon.settings.fetch('cpl_smite.spin', 50) 
    and dark_addon.settings.fetch('cpl_smite.check', true) then
      return cast(SB.Smite, target)
    end
    -- Shoot (Wand)
    if not player.moving 
    and player.power.mana.percent < dark_addon.settings.fetch('cpl_shoot.spin', 100) 
    and dark_addon.settings.fetch('cpl_shoot.check', true) then
      auto_shoot()
    end
  end
end

local function resting()
  if player.dead 
  or player.buff(SB.SpiritTap).exists 
  or (UnitIsAFK("player") and dark_addon.settings.fetch('cpl_afk', true)) then return end

  -- Pause if eating or drinking
  if dark_addon.settings.fetch('cpl_drinking', true) then
    for i=1,40 do
      local name, _ = UnitBuff("player",i)
      if name =='Drink' or name =='Food' then return end
    end
  end

  --- Resting Spells
  -- Power Word Fortitude -- check for .any?
  if dark_addon.settings.fetch('cpl_resting_fortitude.check', true)
  and player.power.mana.percent > dark_addon.settings.fetch('cpl_resting_fortitude.spin', 50)
  and castable(SB.PowerWordFortitude) 
  and not player.buff(SB.PowerWordFortitude).exists then
    return cast(SB.PowerWordFortitude, player)
  end
  -- Inner Fire
  if dark_addon.settings.fetch('cpl_resting_innerfire', true)
  and castable(SB.InnerFire) 
  and not player.buff(SB.InnerFire).exists then
    return cast(SB.InnerFire, player)
  end
  -- Power Word Shield
  if dark_addon.settings.fetch('cpl_resting_pws.check', false)
  and player.power.mana.percent > dark_addon.settings.fetch('cpl_resting_pws.spin', 95)
  and castable(SB.PowerWordShield)
  and player.moving
  and not player.buff(SB.PowerWordShield).exists
  and not player.debuff(SB.WeakenedSoul).exists then
    return cast(SB.PowerWordShield, player)
  end
  -- Heal
  if dark_addon.settings.fetch('cpl_resting_heal.check', false)
  and player.health.percent < dark_addon.settings.fetch('cpl_resting_heal.spin', 40)
  and castable(SB.Heal) 
  and not player.moving then
    return cast(SB.Heal, player)
  end
  -- Lesser Heal
  if dark_addon.settings.fetch('cpl_resting_lesserheal.check', false)
  and player.health.percent < dark_addon.settings.fetch('cpl_resting_lesserheal.spin', 60)
  and castable(SB.LesserHeal)
  and not player.moving then
    return cast(SB.LesserHeal, player)
  end
  -- Renew
  if dark_addon.settings.fetch('cpl_resting_renew.check', false)
  and player.health.percent < dark_addon.settings.fetch('cpl_resting_renew.spin', 80)
  and castable(SB.Renew)
  and not player.buff(SB.Renew).exists then
    return cast(SB.Renew, player)
  end
end

local function interface()
  local classic_priest_gui = {
    key = 'cpl',
    title = 'Classic Priest - Bundled',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Rotation Info' },
      { type = 'text', text = 'This rotation is a WiP. The (on:90) at the end of the description is the default values for reference.' },
      { type = 'rule' },

      { type = 'text', text = 'General' },
      { key = 'afk', type = 'checkbox', text = 'AFK Pause', desc = 'Pause the rotation when AFK. (on)', default = true },
      { key = 'drinking', type = 'checkbox', text = 'Food & Drink Pause', desc = 'Pause the rotation when eating or drinking. (on)', default = true },
      { type = 'rule' },

      { type = 'text', text = 'Combat' },
      { key = 'stoneform', type = 'checkbox', text = 'Stoneform', desc = 'Cast Stoneform on self when bleeding, poisoned, or diseased. (on)', default = true },
      { key = 'dispellmagic', type = 'checkbox', text = 'Dispell Magic', desc = 'Cast Dispell Magic on group when needed. (on)', default = true },
      { key = 'curedisease', type = 'checkbox', text = 'Cure Disease', desc = 'Cast Cure Disease on group when needed. (on)', default = true },
      { type = 'rule' },

      { type = 'text', text = 'Self Healing' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Use Healthstone at health % (on:10)', default_check = true, default_spin = 10, min = 5, max = 100, step = 5 },
      { key = 'desperate', type = 'checkspin', text = 'Desperate Prayer', desc = 'Cast Desperate Prayer at health % (on:20)', default_check = true, default_spin = 20, min = 5, max = 100, step = 5 },
      { key = 'pws', type = 'checkspin', text = 'Power Word: Shield', desc = 'Cast Power Word: Shield on self at mana % (on:90)', default_check = true, default_spin = 90, min = 5, max = 100, step = 5 },
      { key = 'renew', type = 'checkspin', text = 'Renew', desc = 'Cast Renew on self at health %  (on:80)', default_check = true, default_spin = 80, min = 5, max = 100, step = 5 },
      { key = 'heal', type = 'checkspin', text = 'Heal', desc = 'Cast Heal on self at health % (off:40)', default_check = false, default_spin = 40, min = 5, max = 100, step = 5 },
      { key = 'lesserheal', type = 'checkspin', text = 'Lesser Heal', desc = 'Cast Lesser Heal on self at health % (off:60)', default_check = false, default_spin = 60, min = 5, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'DPS Spells' },
      { key = 'swp', type = 'checkspin', text = 'Shadow Word: Pain', desc = 'Cast Shadow Word: Pain when target is above health % (on:10)', default_check = true, default_spin = 10, min = 5, max = 100, step = 5 },
      { key = 'mindblast', type = 'checkbox', text = 'Mindblast', desc = 'Cast Mindblast on cooldown. (on)', default = true },
      { key = 'smite', type = 'checkspin', text = 'Smite', desc = 'Cast Smite when mana % (on:50)', default_check = true, default_spin = 50, min = 5, max = 100, step = 5 },
      { key = 'shoot', type = 'checkspin', text = 'Shoot', desc = 'Cast Shoot (Wand) when mana less than % (on:100)', default_check = true, default_spin = 100, min = 5, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Resting Spells' },
      { key = 'resting_fortitude', type = 'checkspin', text = 'Power Word: Fortitude', desc = 'Cast Power Word: Fortitude on self at mana % (on:90)', default_check = true, default_spin = 90, min = 5, max = 100, step = 5 },
      { key = 'resting_innerfire', type = 'checkbox', text = 'Inner Fire', desc = 'Keep Inner Fire on player. (on)', default = true },
      { key = 'resting_pws', type = 'checkspin', text = 'Power Word: Shield', desc = 'Cast Power Word: Shield on self at mana % (on:90)', default_check = true, default_spin = 90, min = 5, max = 100, step = 5 },
      { key = 'resting_renew', type = 'checkspin', text = 'Renew', desc = 'Cast Renew on self at health % (on:80)', default_check = true, default_spin = 80, min = 5, max = 100, step = 5 },
      { key = 'resting_heal', type = 'checkspin', text = 'Heal', desc = 'Cast Heal on self at health % (on:40)', default_check = true, default_spin = 40, min = 5, max = 100, step = 5 },
      { key = 'resting_lesserheal', type = 'checkspin', text = 'Lesser Heal', desc = 'Cast Lesser Heal on self at health % (on:60)', default_check = true, default_spin = 60, min = 5, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Raid & Party Settings' },
      -- { key = 'check', type = 'checkbox', text = 'TextLabel', desc = 'Description here' },
    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(classic_priest_gui)

  dark_addon.interface.buttons.add_toggle({
    name = 'dps',
    label = 'DPS Target',
    on = {
      label = dark_addon.interface.icon('wand-magic'),
      color = dark_addon.interface.color.teal,
      color2 = dark_addon.interface.color.dark_teal
    },
    off = {
      label = dark_addon.interface.icon('wand'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'raid',
    label = 'Raid / Dungeon Healing Mode',
    on = {
      label = dark_addon.interface.icon('dragon'), -- Raid
      color = dark_addon.interface.color.teal,
      color2 = dark_addon.interface.color.dark_teal
    },
    off = {
      label = dark_addon.interface.icon('dungeon'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'dispel',
    label = 'Automatically Dispell',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('book-spells'),
      color = dark_addon.interface.color.teal,
      color2 = dark_addon.interface.color.dark_teal
    },
    off = {
      label = dark_addon.interface.icon('book-spells'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'settings',
    label = 'Rotation Settings',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('cog'),
      color = dark_addon.interface.color.cyan,
      color2 = dark_addon.interface.color.dark_cyan
    },
    off = {
      label = dark_addon.interface.icon('cog'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    },
    callback = function(self)
      if configWindow.parent:IsShown() then
        configWindow.parent:Hide()
      else
        configWindow.parent:Show()
      end
    end
  })

end

dark_addon.rotation.register({
  class = dark_addon.rotation.classes.priest,
  name = 'priest',
  label = 'Bundled Priest',
  combat = combat,
  resting = resting,
  interface = interface
})
