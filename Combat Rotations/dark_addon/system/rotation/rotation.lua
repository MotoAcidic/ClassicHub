local addon, dark_addon = ...

dark_addon.rotation = {
  classes = {
    druid = 11,
    hunter = 3,
    mage = 8,
    paladin = 2,
    priest = 5,
    rogue = 4,
    shaman = 7,
    warlock = 9,
    warrior = 1
  },
  rotation_store = { },
  spellbooks = { },
  talentbooks = { },
  dispellbooks = { },
  healingspells = { },
  active_rotation = false
}

function dark_addon.rotation.register(config)
  if config.gcd then
    setfenv(config.gcd, dark_addon.environment.env)
  end
  if config.combat then
    setfenv(config.combat, dark_addon.environment.env)
  end
  if config.resting then
    setfenv(config.resting, dark_addon.environment.env)
  end
  dark_addon.rotation.rotation_store[config.name] = config
end

function dark_addon.rotation.load(name)
  local rotation
  for _, rot in pairs(dark_addon.rotation.rotation_store) do
    if rot.name == name then
      rotation = rot
    end
  end

  if rotation then
    dark_addon.settings.store('active_rotation', name)
    dark_addon.rotation.active_rotation = rotation
    dark_addon.interface.buttons.reset()
    if rotation.interface then
      rotation.interface(rotation)
    end
    dark_addon.log('Loaded rotation: ' .. name)
    dark_addon.interface.status('Ready...')
  else
    dark_addon.error('Unable to load rotation: ' .. name)
  end
end



function dark_addon.environment.selectrank(ranks)
  if #ranks == 0 then return end
  for i = #ranks, 1, -1 do
      if IsSpellKnown(ranks[i]) then
        return ranks[i]
      end
  end
end

local rank_cache = { }

dark_addon.environment.hooks['SB'] = setmetatable({ }, {
  __index = function(self, key)
    local _, _, class = UnitClass('player') -- TODO: Use a global...
    local value = dark_addon.rotation.spellbook_map[class][key]
    if value then
      local spell_id = nil
      if type(value) == 'table' then
        local rank = dark_addon.environment.selectrank(value)
        if rank then spell_id = rank else spell_id = value[1] end
      else
        spell_id = value
      end
      if not rank_cache[spell_id] then
        rank_cache[spell_id] = setmetatable({
          id = spell_id,
          ranks = value
        }, {
          __index = function(self, key)
            if type(self.ranks) == 'table' and tonumber(key) then
              return self.ranks[key]
            end
            return self.id
          end,
          __call = function(self, key)
            if type(self.ranks) == 'table' and tonumber(key) then
              return self.ranks[key]
            end
            return self.id
          end,
          __tostring = function(self)
            return self.id
          end,
          __concat = function(l, r)
            if l.id then return GetSpellInfo(l.id) .. r end
            if r.id then return l .. GetSpellInfo(r.id) end
          end
        })
      end
      return rank_cache[spell_id]
    end
    return nil
  end,
  __call = function(self, key, rank)
    local _, _, class = UnitClass('player')
    if dark_addon.rotation.spellbook_map[class] then
      local value = dark_addon.rotation.spellbook_map[class][key]
      if type(value) == 'table' then
        local id = value[rank]
        if not id then return value[1] end
        return id
      else
        return value
      end
    end
    return nil
  end
})

dark_addon.environment.hooks['Spell'] = dark_addon.environment.hooks['SB']
dark_addon.environment.hooks['Spells'] = dark_addon.environment.hooks['SB']

local loading_wait = false

local function init()
  if not loading_wait then
    C_Timer.After(0.3, function()
      dark_addon.rotation.spellbook_map = {
        [1] = dark_addon.rotation.spellbooks.warrior,
        [2] = dark_addon.rotation.spellbooks.paladin,
        [3] = dark_addon.rotation.spellbooks.hunter,
        [4] = dark_addon.rotation.spellbooks.rogue,
        [5] = dark_addon.rotation.spellbooks.priest,
        [7] = dark_addon.rotation.spellbooks.shaman,
        [8] = dark_addon.rotation.spellbooks.mage,
        [9] = dark_addon.rotation.spellbooks.warlock,
        [11] = dark_addon.rotation.spellbooks.druid
      }
      local active_rotation = dark_addon.settings.fetch('active_rotation', false)
      if active_rotation then
        dark_addon.rotation.load(active_rotation)
        dark_addon.interface.status('Ready...')
      else
        dark_addon.interface.status('Load a rotation...')
      end
      loading_wait = false
    end)
  end
end

dark_addon.on_ready(function()
  init()
  loading_wait = true
end)

-- dark_addon.event.register("ACTIVE_TALENT_GROUP_CHANGED", function(...)
--   init()
--   loading_wait = true
-- end)
