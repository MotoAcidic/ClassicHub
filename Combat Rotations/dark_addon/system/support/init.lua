local addon, dark_addon = ...

_G['dark_interface'] = dark_addon
dark_addon.name = 'DarkRotations Classic'
dark_addon.version = 'r217'
dark_addon.color = 'ebdec2'
dark_addon.color2 = 'ebdec2'
dark_addon.color3 = 'ebdec2'
dark_addon.ready = false
dark_addon.settings_ready = false
dark_addon.ready_callbacks = { }
dark_addon.protected = false
dark_addon.adv_protected = false
dark_addon.libcc = LibStub("LibClassicCasterino")

function dark_addon.on_ready(callback)
  dark_addon.ready_callbacks[callback] = callback
end

local libccstub = function(event, ...) return end
dark_addon.libcc.RegisterCallback(dark_addon.name,"UNIT_SPELLCAST_START", libccstub)
UnitCastingInfo = function(unit) return dark_addon.libcc:UnitCastingInfo(unit) end
UnitChannelInfo = function(unit) return dark_addon.libcc:UnitChannelInfo(unit) end
