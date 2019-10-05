local addon, dark_addon = ...

local ticker

ticker = C_Timer.NewTicker(0.1, function()
  if dark_addon.settings_ready then
    for _, callback in pairs(dark_addon.ready_callbacks) do
      callback()
    end
    ticker:Cancel()
  end
end)

