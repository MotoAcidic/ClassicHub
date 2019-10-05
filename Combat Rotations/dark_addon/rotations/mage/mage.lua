local addon, dark_addon = ...

local function combat()
  -- combat
end

local function resting()
  -- resting
end

dark_addon.rotation.register({
  class = dark_addon.rotation.classes.mage,
  name = 'mage',
  label = 'Bundled Mage',
  combat = combat,
  resting = resting
})
