local addon, dark_addon = ...

dark_addon.event = {
  events = { },
  callbacks = { }
}

local frame = CreateFrame('frame')

function dark_addon.event.register(event, callback)
  if not dark_addon.event.events[event] then
    frame:RegisterEvent(event)
    dark_addon.event.events[event] = true
    dark_addon.event.callbacks[event] = { }
  end
  table.insert(dark_addon.event.callbacks[event], callback)
end

frame:SetScript('OnEvent', function(self, event, ...)
  if dark_addon.event.callbacks[event] then
    for key, callback in ipairs(dark_addon.event.callbacks[event]) do
      callback(...)
    end
  end
end)
