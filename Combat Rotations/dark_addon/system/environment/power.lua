local addon, dark_addon = ...

local power = { }

function power:base()
  return dark_addon.environment.conditions.powerType(self.unit)
end

function power:mana()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Mana, 'mana')
end

function power:rage()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Rage, 'rage')
end

function power:focus()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Focus, 'focus')
end

function power:energy()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Energy, 'energy')
end

function power:combopoints()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.ComboPoints, 'combopoints')
end

function power:runes()
 return dark_addon.environment.conditions.runes(self.unit, 'runes')
end

function power:runicpower()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.RunicPower, 'runicpower')
end

function power:soulshards()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.SoulShards, 'soulshards')
end

function power:lunarpower()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.LunarPower, 'lunarpower')
end

function power:astral()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.LunarPower, 'astral')
end

function power:holypower()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.HolyPower, 'holypower')
end

function power:maelstrom()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Maelstrom, 'maelstrom')
end

function power:chi()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Chi, 'chi')
end

function power:insanity()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Insanity, 'insanity')
end

function power:arcanecharges()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.ArcaneCharges, 'arcanecharges')
end

function power:fury()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Fury, 'fury')
end

function power:pain()
 return dark_addon.environment.conditions.powerType(self.unit, Enum.PowerType.Pain, 'pain')
end

function dark_addon.environment.conditions.power(unit, called)
  return setmetatable({
    unit = unit,
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      return power[k](t)
    end,
    __unm = function(t)
      return power['base'](t)
    end
  })
end
