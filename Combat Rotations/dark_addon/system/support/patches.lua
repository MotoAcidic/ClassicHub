local addon, dark_addon = ...

-- local function _RemoveTalent(id)
--   if dark_addon.adv_protected then
--     RemoveTalent(id)
--   else
--     secured = false
--     while not secured do
--       RunScript([[
--         for index = 1, 500 do
--           if not issecure() then
--             return
--           end
--         end
--         RemoveTalent("]] .. id .. [[")
--         secured = true
--       ]])
--     end
--   end
-- end

-- local function _LearnTalent(id)
--   if dark_addon.adv_protected then
--     LearnTalent(id)
--   else
--     secured = false
--     while not secured do
--       RunScript([[
--         for index = 1, 500 do
--           if not issecure() then
--             return
--           end
--         end
--         LearnTalent("]] .. id .. [[")
--         secured = true
--       ]])
--     end
--   end
-- end

-- local hookedTalents = false
-- local frame = CreateFrame('Frame')
-- frame:RegisterEvent("ADDON_LOADED")
-- frame:SetScript("OnEvent", function(self, event, addon)
--   if addon == "Blizzard_TalentUI" then
--     if not hookedTalents then
--       hooksecurefunc("PlayerTalentFrameTalent_OnClick", function(self, button)
--         for i = 1, #self:GetParent().talents do
--           _RemoveTalent(self:GetParent().talents[i]:GetID())
--           _RemoveTalent(self:GetParent().talents[i]:GetID())
--           UIErrorsFrame:Clear()
--         end
--         C_Timer.After(0.45, function()
--           _LearnTalent(self:GetID())
--         end)
--       end)
--     end
--     hookedTalents = true
--   end
-- end)

local function hide_block(...)
  StaticPopup1:Hide()
end

function StaticPopup_OnShow(self)
  if self.which ~= 'MACRO_ACTION_FORBIDDEN' and self.which ~= 'ADDON_ACTION_FORBIDDEN' and self.which ~= 'ADDON_ACTION_BLOCKED' then
    PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
  end

  local dialog = StaticPopupDialogs[self.which];
  local OnShow = dialog.OnShow;

  if ( OnShow ) then
    OnShow(self, self.data);
  end
  if ( dialog.hasMoneyInputFrame ) then
    _G[self:GetName().."MoneyInputFrameGold"]:SetFocus();
  end
  if ( dialog.enterClicksFirstButton ) then
    self:SetScript("OnKeyDown", StaticPopup_OnKeyDown);
  end
end

function StaticPopup_OnHide(self)
  if self.which ~= 'MACRO_ACTION_FORBIDDEN' and self.which ~= 'ADDON_ACTION_FORBIDDEN' and self.which ~= 'ADDON_ACTION_BLOCKED' then
    PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE);
  end

  StaticPopup_CollapseTable();

  local dialog = StaticPopupDialogs[self.which];
  local OnHide = dialog.OnHide;
  if ( OnHide ) then
    OnHide(self, self.data);
  end
  self.extraFrame:Hide();
  if ( dialog.enterClicksFirstButton ) then
    self:SetScript("OnKeyDown", nil);
  end
  if ( self.insertedFrame ) then
    self.insertedFrame:Hide();
    self.insertedFrame:SetParent(nil);
    local text = _G[self:GetName().."Text"];
    _G[self:GetName().."MoneyFrame"]:SetPoint("TOP", text, "BOTTOM", 0, -5);
    _G[self:GetName().."MoneyInputFrame"]:SetPoint("TOP", text, "BOTTOM", 0, -5);
  end
end

function C_Timer.NewAdvancedTicker(duration, callback, iterations)
  local ticker = setmetatable({}, TickerMetatable);
  ticker._duration = duration;
  ticker._remainingIterations = iterations;
  ticker._callback = function()
    if ( not ticker._cancelled ) then
      callback(ticker);

      --Make sure we weren't cancelled during the callback
      if ( not ticker._cancelled ) then
        if ( ticker._remainingIterations ) then
          ticker._remainingIterations = ticker._remainingIterations - 1;
        end
        if ( not ticker._remainingIterations or ticker._remainingIterations > 0 ) then
          C_Timer.After(ticker._duration, ticker._callback);
        end
      end
    end
  end;

  C_Timer.After(ticker._duration, ticker._callback);
  return ticker;
end

dark_addon.event.register("MACRO_ACTION_FORBIDDEN", hide_block)
dark_addon.event.register("ADDON_ACTION_FORBIDDEN", hide_block)
dark_addon.event.register("ADDON_ACTION_BLOCKED", hide_block)
