local addon, dark_addon = ...

dark_addon.environment.logical = {
  prefixes = {
    '^player',
    '^pet',
    '^vehicle',
    '^target',
    '^focus',
    '^mouseover',
    '^none',
    '^npc',
    '^party[1-4]',
    '^raid[1-4]?[0-9]',
    '^boss[1-5]',
    '^arena[1-5]'
  }
}

function dark_addon.environment.logical.validate(unitID)
  local length, offset = string.len(unitID), 0
  for i = 1, #dark_addon.environment.logical.prefixes do
    local start, index = string.find(unitID, dark_addon.environment.logical.prefixes[i])
    if start then
      offset = index + 1
      if offset > length then
        return true
      else
        while true do
          local start, index = string.find(unitID, 'target', offset, true)
          if start then
            offset = index + 1
            if offset > length then
              return true
            end
          else
            return false
          end
        end
      end
    end
  end
  return false
end
