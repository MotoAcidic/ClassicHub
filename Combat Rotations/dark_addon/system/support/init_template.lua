local addon, dark_addon = ...

_G['dark_interface'] = dark_addon
dark_addon.name = 'DarkRotations Classic'
dark_addon.version = 'r${i}'
dark_addon.color = '727bad'
dark_addon.color2 = '72ad98'
dark_addon.color3 = '96ad72'
dark_addon.ready = false
dark_addon.settings_ready = false
dark_addon.ready_callbacks = { }
dark_addon.protected = false
dark_addon.adv_protected = false

function dark_addon.on_ready(callback)
  dark_addon.ready_callbacks[callback] = callback
end
