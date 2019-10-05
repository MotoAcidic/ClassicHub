local addon, dark_addon = ...

dark_addon.console = {
  debugLevel = 0,
  file = '',
  line = ''
}

local fontObject = CreateFont("dark_addon_console")
fontObject:SetFont("Interface\\Addons\\dark_addon\\media\\Consolas.ttf", 12)

local consoleFrame = CreateFrame('ScrollingMessageFrame', 'dark_addon_console', UIParent)


consoleFrame:SetFontObject("dark_addon_console")

-- position and setup
consoleFrame:SetPoint('CENTER', UIParent)
consoleFrame:SetMaxLines(1000)
consoleFrame:SetInsertMode('BOTTOM')
consoleFrame:SetWidth(500)
consoleFrame:SetHeight(145)
consoleFrame:SetJustifyH('LEFT')
consoleFrame:SetFading(false)
consoleFrame:SetClampedToScreen(true)
consoleFrame:Hide()

-- setup background
consoleFrame.background = consoleFrame:CreateTexture('background')
consoleFrame.background:SetPoint('TOPLEFT', consoleFrame, 'TOPLEFT', -5, 5)
consoleFrame.background:SetPoint('BOTTOMRIGHT', consoleFrame, 'BOTTOMRIGHT', 5, -5)
consoleFrame.background:SetColorTexture(0, 0, 0, 0.75)

consoleFrame.background2 = consoleFrame:CreateTexture('background')
consoleFrame.background2:SetPoint('TOPLEFT', consoleFrame, 'TOPLEFT', -7, 7)
consoleFrame.background2:SetPoint('BOTTOMRIGHT', consoleFrame, 'BOTTOMRIGHT', 7, -7)
consoleFrame.background2:SetColorTexture(20/255, 20/255, 20/255, 0.4)

-- make draggable
consoleFrame:SetMovable(true)
consoleFrame:EnableMouse(true)
consoleFrame:RegisterForDrag('LeftButton')
consoleFrame:SetScript('OnDragStart', consoleFrame.StartMoving)
consoleFrame:SetScript('OnDragStop', consoleFrame.StopMovingOrSizing)

-- scrolling
consoleFrame:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        else
            self:ScrollUp()
        end
    else
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        else
            self:ScrollDown()
        end
    end
end)

-- display frame
function dark_addon.console.set_level(level)
  level = tonumber(level) or 0
  dark_addon.console.debugLevel = level
  dark_addon.settings.store('debug_level', level)
end

function dark_addon.console.toggle(show)
  show = show
  dark_addon.settings.store('debug_show', show)
  if show then
    consoleFrame:Show()
  else
    consoleFrame:Hide()
  end
end

local function join(...)
    local ret = ''
    for n = 1, select('#', ...) do
        ret = ret .. ', ' .. tostring(select(n, ...))
    end
    return ret:sub(3)
end

local colorize = dark_addon.interface.colorize

local last = false
function dark_addon.console.log_time(str)
  local at = date('%H:%M:%S', time())
  local joined = string.format('%s %s', at, str)
  if last ~= joined then
    dark_addon.console.log(joined)
    last = joined
  end
end

function dark_addon.console.log(...)
    consoleFrame:AddMessage(...)
end

function dark_addon.console.notice(...)
  dark_addon.console.log(date('%H:%M:%S', time())..'|cff91FF00[notice]|r ' .. join(...))
end

function dark_addon.console.debug(level, section, color, ...)
  if dark_addon.console.debugLevel >= level then
    dark_addon.console.log_time(
      string.format(
        '%s %s',
        colorize(color, '[' .. section .. ']'),
        join(...)
      )
    )
  end
end

function dark_addon.log(string, ...)
  local formatted = string.format(string, ...)
  print('|cff' .. dark_addon.color .. '['..dark_addon.name..']|r ' .. formatted)
end

function dark_addon.error(...)
  print('|cff' .. dark_addon.color .. '['..dark_addon.name..']|r |cffc32425' .. join(...) .. '|r')
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function dark_addon.format(value)
  if tonumber(value) then
    return round(value, 2)
  else
    return tostring(value)
  end
end

dark_addon.on_ready(function()
  local debug_level = dark_addon.settings.fetch('debug_level', nil)
  dark_addon.console.set_level(debug_level)
  local toggle = dark_addon.settings.fetch('debug_show', false)
  dark_addon.console.toggle(toggle)
  dark_addon.console.log("Welcome!")
end)


