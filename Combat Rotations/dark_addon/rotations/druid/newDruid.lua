-------------------------------------
-- Druid Levelling Rotation by Rex --
-------------------------------------

--Notes
--Credit to Euler for the Healing Function
--
--Settings
--
--Preferred Form - Bear and Cat implemented, Moonkin not (will automatically use Dire Bear if you know it in place of Bear)
--Preferred Opener from Resting - None, Moonfire, Faerie Fire and Feral Faerie Fire
--Cat Options - no of combo points to use Rip at if you dont know Ferocious Bite
--Bear Options - checkboxes for Demoralizing Roar and Growl
--Self Healing Options - Healing Cooldown for if Healing Touch "double casts" - variable based on your lag, Healing Touch checkbox and percent to cast at, 
--Cure Poison checkbox - will Cure Poison out of combat
--
--General
--Persistent Forms - will stay in your Preferred Form at all times except for:
--Override Form toggle on DR UI - turn this red to cancel animal form to interact with NPCs and objects
--When you use and Opener from Resting it will switch to caster form and then back to animal form
--
--Cooldowns on UI
--Tiger's Fury is used when Cooldowns is toggled on
--
--Interrupts on UI
--Uses Bash in Bear Form when Interrupts is toggled on  


--To do
    --Healing Spells
    ----------------
    --Rejuvenation
    --Regrowth
    --Cure Poison
    --Rebirth
    --Tranquility
    --Remove Curse
    --Abolish Poison
    --Innervate
    --Swiftmend
    --Nature's Swiftness

    --Crowd Control
    ---------------
    --Hibernate
    --Soothe Animal
    --Nature's Grasp

    --Druid Cast
    ------------
    --Faerie Fire
    --Starfire
    --Insect Swarm
    --Hurricane

    --Cooldowns
    -----------
    --Omen of Clarity

    --Forms
    -------
    --Moonkin Form


local addon, dark_addon = ...
local C = dark_addon.interface.colorize

--Interrupt Function
local function interrupt()
  if not toggle('interrupts', false) then return end
  local intpercent = math.random(35, 55)
    if target.exists and target.alive and castable('Bash') and -spell('Bash') == 0 and target.interrupt('target', intpercent) and IsSpellInRange('Bash', 'target') == 1 then
      print("Bash @ " .. intpercent)
      cast('Bash', 'target')
      return true
    end
  return false
end
setfenv(interrupt, dark_addon.environment.env)
--End

--Group Roles Error - temporary till fixed
function UnitGroupRolesAssigned(unit)
  return 'nothing'
end
--End

--Use Miscellaneous Items Function
local ManaPotID = {2455, 3385, 3827, 6149, 18841, 13443, 13444}
local ManaPotName = {'Minor Mana Potion', 'Lesser Mana Potion', 'Mana Potion', 'Greater Mana Potion', 'Combat Mana Potion', 'Superior Mana Potyion', 'Major Mana Potion'}
local HealPotID = {118, 858, 4596, 929, 1710, 18839, 3928, 13446}
local HealPotName = {'Minor Healing Potion', 'Lesser Healing Potion', 'Discolored Healing Potion', 'Healing Potion', 'Greater Healing Potion', 'Combat Healing Potion', 'Superior Healing Potion', 'Major Healing Potion'}
local function useitem()
  local usehealpot = dark_addon.settings.fetch('dr_druid_healpot.check', true)
  local usehealpotpercent = dark_addon.settings.fetch('dr_druid_healpot.spin', 25)
  local usemanapot = dark_addon.settings.fetch('dr_druid_manapot.check', true)
  local usemanapotpercent = dark_addon.settings.fetch('dr_druid_manapot.spin', 25)  
  if usemanapot == true then
    for i=#ManaPotID,1,-1 do
      if GetItemCount(ManaPotID[i]) >= 1
      and player.power.mana.percent <= usemanapotpercent
      and (GetItemCooldown(ManaPotID[i])) == 0 then
        macro('/use '..ManaPotName[i])
        return true
      end
    end
  end
  if usehealpot == true then
    for i=#HealPotID,1,-1 do
      if GetItemCount(HealPotID[i]) >= 1
      and player.health.percent <= usehealpotpercent
      and (GetItemCooldown(HealPotID[i])) == 0 then
        macro('/use '..HealPotName[i])
        return true
      end
    end
  end
  return false
end
setfenv(useitem, dark_addon.environment.env)
--End

--Skinning Function
local lootDelay = 0
local skinTimer = 0
local function skinning()
  local useskinning = dark_addon.settings.fetch('dr_druid_skinning', true)
  local LbCanLootUnit = function (...) return __LB__.UnitIsLootable(...) end
  local LbInteractUnit = function (...) return __LB__.ObjectInteract(...) end
  local LbTargetUnit = function (...) return TargetUnit(...) end
  if castable('Skinning') and not player.casting and not player.moving and useskinning == true then
      if getListOfCorpse() ~= nil then

      if LbCanLootUnit(getListOfCorpse()) and lootDelay <= GetTime() and (not player.buff('Food').exists or not player.buff('Drink').exists or not player.buff('Bandage').exists) then
        LbInteractUnit(getListOfCorpse())
        lootDelay = GetTime() + dark_addon.settings.fetch('dr_druid_lootDelay', 1)
      end

      if __LB__.UnitHasFlag(getListOfCorpse(), __LB__.EUnitFlags.Skinnable) and skinTimer <= GetTime() and (not player.buff('Food').exists or not player.buff('Drink').exists or not player.buff('Bandage').exists) then
        LbTargetUnit(getListOfCorpse())
        cast('Skinning')
        skinTimer = GetTime() + dark_addon.settings.fetch('dr_druid_skinDelay', 1)
      end

    end
  end
  return false
end
setfenv(skinning, dark_addon.environment.env)
--End

--Scan for Corpses Function
function getListOfCorpse()
  if dark_addon.luaboxdev then
    local object = __LB__.GetObjects(10)
    for i , guid in ipairs(object) do
      if UnitIsDead(guid) then
        return guid
      end
    end
  end 
end
--End

--Combat Function
local function combat()
  DebugLog = dark_addon.settings.fetch('dr_druid_debuglog', false)

  local mylevel = UnitLevel("player")
  local targetlevel = UnitLevel("target")
  local inRange = enemies.around(5)
  local animalform = player.buff('Bear Form').up or player.buff('Cat Form').up or player.buff('Dire Bear Form').up 
    or player.buff('Travel Form').up or player.buff('Aquatic Form').up
  local bearform = player.buff('Bear Form').up or player.buff('Dire Bear Form').up
  local catform = player.buff('Cat Form').up  
  local usedemoroar = dark_addon.settings.fetch('dr_druid_usedemoroar', false)
  local usegrowl = dark_addon.settings.fetch('dr_druid_usegrowl', false)
  local ripcp = dark_addon.settings.fetch('dr_druid_ripcp', 3)


  if target.alive and target.enemy and player.alive and not player.channeling() and not player.casting then
  
    --Cancel Current Form IC
    --Allows interaction with objects and NPCs
    if toggle('override_form', false) then
      macro("/cancelform")
    end
    
    --Self Dispel Poison & Disease
    local dispel_unit = group.removable('poison')
    if dispel_unit and castable('Cure Poison') and -spell('Cure Poison') == 0 and IsSpellInRange('Cure Poison', dispel_unit.unitID) and not curepoisonooc then
      macro("/cancelform")      
      return cast('Cure Poison', player)
    end

    --Use Health Pots and Mana Pots
    if useitem() then
      return
    end

    --Interrupts
    if interrupt() then 
      return 
    end

    --Healing IC
    local useichealingtouch = dark_addon.settings.fetch('dr_druid_ichealingtouch.check', true)
    local ichealingtouchpercent = dark_addon.settings.fetch('dr_druid_ichealingtouch.spin', 25)
    local useicrejuvenation = dark_addon.settings.fetch('dr_druid_icrejuvenation.check', true)
    local icrejuvenationpercent = dark_addon.settings.fetch('dr_druid_icrejuvenation.spin', 25)
    local useicregrowth = dark_addon.settings.fetch('dr_druid_icregrowth.check', true)
    local icregrowthpercent = dark_addon.settings.fetch('dr_druid_icregrowth.spin', 25)
    --Cancel form to heal
    if useichealingtouch == true and player.health.percent <= ichealingtouchpercent and animalform ==  true then
      macro("/cancelform")
    end
    if useicrejuvenation == true and player.health.percent <= icrejuvenationpercent and animalform ==  true then
      macro("/cancelform")
    end
    if useicregrowth == true and player.health.percent <= icregrowthpercent and animalform ==  true then
      macro("/cancelform")
    end
    --Healing Touch
    if useichealingtouch == true and castable('Healing Touch') and player.health.percent <= ichealingtouchpercent and not spell('Healing Touch').lastcast then
      return cast('Healing Touch', 'player')
    end
    --Rejuvenation
    if useicrejuvenation == true and castable('Rejuvenation') and player.health.percent <= icrejuvenationpercent and player.buff('Rejuvenation').down then
      return cast('Rejuvenation', 'player')
    end
    --Regrowth
    if useicregrowth == true and castable('Regrowth') and player.health.percent <= icregrowthpercent and player.buff('Regrowth').down then
      return cast('Regrowth', 'player')
    end

    --Combat with "Manual" selected
    if dark_addon.settings.fetch('dr_druid_form') == 'Manual' then
      if animalform == false then
        if not IsCurrentSpell(6603) then
          return cast('Attack')
        end
        --Moonfire
        if castable('Moonfire') and -spell('Moonfire') == 0 and target.debuff('Moonfire').down and IsSpellInRange('Moonfire', 'target') == 1 then
          return cast('Moonfire', 'target')
        end
        --Wrath
        if castable('Wrath') and -spell('Wrath') == 0 and IsSpellInRange('Wrath', 'target') == 1 then
          return cast('Wrath', 'target')
        end
      end

      if bearform == true then
        if not IsCurrentSpell(6603) then
          return cast('Attack')
        end
        --Faerie Fire (Feral)
        if castable('Faerie Fire (Feral)') and -spell('Faerie Fire (Feral)') == 0 and target.debuff('Faerie Fire (Feral)').down and IsSpellInRange('Faerie Fire (Feral)', 'target') == 1 then
          return cast('Faerie Fire (Feral)', 'target')
        end
        --AoE
        --Swipe
        if inRange >= 2 and castable('Swipe') and -spell('Swipe') == 0 and IsSpellInRange('Swipe', 'target') == 1 then
          return cast('Swipe', 'target')
        end      
        --Demoralizing Roar
        if usedemoroar == true and castable('Demoralizing Roar') and -spell('Demoralizing Roar') == 0 and target.debuff('Demoralizing Roar').down then
          return cast('Demoralizing Roar')
        end
        --Growl
        if usegrowl == true and castable('Growl') and -spell('Growl') == 0 and IsSpellInRange('Growl', 'target') == 1 then
          return cast('Growl', 'target')
        end
        --Enrage
        if castable('Enrage') and -spell('Enrage') == 0 then
          return cast('Enrage', 'player')
        end
        --Maul
        if castable('Maul') and -spell('Maul') == 0 and IsSpellInRange('Maul', 'target') == 1 then
          return cast('Maul', 'target')
        end
      end
      
      if catform == true then
        --Prowl
        --Dash
        --Cower
        --Ravage (requires Prowl and behind target)
        --Pounce (requires Prowl and behind target)
        --Shred (requires behind the target)
        --Tiger's Fury (cooldown)
        if toggle('cooldowns', false) then
          if castable("Tiger's Fury") and -spell("Tiger's Fury") == 0 and player.buff("Tiger's Fury").down then
            return cast("Tiger's Fury")
          end
        end      
        if not IsCurrentSpell(6603) then
          return cast('Attack')
        end      
        --Cat Form
        if castable('Cat Form') and player.buff('Cat Form').down then
          return cast('Cat Form', 'player')
        end
        --Faerie Fire (Feral)
        if castable('Faerie Fire (Feral)') and -spell('Faerie Fire (Feral)') == 0 and target.debuff('Faerie Fire (Feral)').down and IsSpellInRange('Faerie Fire (Feral)', 'target') == 1 then
          return cast('Faerie Fire (Feral)', 'target')
        end
        --Rake
        if castable('Rake') and -spell('Rake') == 0 and target.debuff('Rake').down and player.power.combopoints.actual < 5 and IsSpellInRange('Rake', 'target') == 1 then
          return cast('Rake', 'target')
        end
        --Claw
        if castable('Claw') and -spell('Claw') == 0 and player.power.combopoints.actual < 5 and IsSpellInRange('Claw', 'target') == 1 then
          return cast('Claw', 'target')
        end
        --Rip if Ferocious Bite not known
        if not IsSpellKnown(22568) and castable('Rip') and -spell('Rip') == 0 and player.power.combopoints.actual >= ripcp and IsSpellInRange('Rip', 'target') == 1 then
          return cast('Rip', 'target')
        end
        --Ferocious Bite
        if castable('Ferocious Bite') and -spell('Ferocious Bite') == 0 and player.power.combopoints.actual == 5 and IsSpellInRange('Ferocious Bite', 'target') == 1 then
          return cast('Ferocious Bite', 'target')
        end
      end  
    end
    
    --Combat with Form Management selected
      --Caster Form Combat IC
      if (mylevel < 10 or (animalform == false and target.health.percent < 15)) then
        if not IsCurrentSpell(6603) then
          return cast('Attack')
        end
        --Moonfire
        if castable('Moonfire') and -spell('Moonfire') == 0 and target.debuff('Moonfire').down and IsSpellInRange('Moonfire', 'target') == 1 then
          return cast('Moonfire', 'target')
        end
        --Wrath
        if castable('Wrath') and -spell('Wrath') == 0 and IsSpellInRange('Wrath', 'target') == 1 then
          return cast('Wrath', 'target')
        end
      end

      --Bear Form Combat IC
      if dark_addon.settings.fetch('dr_druid_form') == 'Bear' then
        --Challenging Roar
        --Frenzied Regeneration
        --Feral Charge
        --Barkskin
        if not IsCurrentSpell(6603) then
          return cast('Attack')
        end
        --Dire Bear Form
        if IsSpellKnown(9634) and castable('Dire Bear Form') and player.buff('Dire Bear Form').down then
          return cast('Dire Bear Form', 'player')
        end
        --Bear Form
        if not IsSpellKnown(9634) and castable('Bear Form') and player.buff('Bear Form').down then
          return cast('Bear Form', 'player')
        end
        --Faerie Fire (Feral)
        if castable('Faerie Fire (Feral)') and -spell('Faerie Fire (Feral)') == 0 and target.debuff('Faerie Fire (Feral)').down and IsSpellInRange('Faerie Fire (Feral)', 'target') == 1 then
          return cast('Faerie Fire (Feral)', 'target')
        end
        --AoE
        --Swipe
        if inRange >= 2 and castable('Swipe') and -spell('Swipe') == 0 and IsSpellInRange('Swipe', 'target') == 1 then
          return cast('Swipe', 'target')
        end      
        --Demoralizing Roar
        if usedemoroar == true and castable('Demoralizing Roar') and -spell('Demoralizing Roar') == 0 and target.debuff('Demoralizing Roar').down then
          return cast('Demoralizing Roar')
        end
        --Growl
        if usegrowl == true and castable('Growl') and -spell('Growl') == 0 and IsSpellInRange('Growl', 'target') == 1 then
          return cast('Growl', 'target')
        end
        --Enrage
        if castable('Enrage') and -spell('Enrage') == 0 then
          return cast('Enrage', 'player')
        end
        --Maul
        if castable('Maul') and -spell('Maul') == 0 and IsSpellInRange('Maul', 'target') == 1 then
          return cast('Maul', 'target')
        end
      end

      --Cat Form Commbat IC
      if dark_addon.settings.fetch('dr_druid_form') == 'Cat' then
        --Prowl
        --Dash
        --Cower
        --Ravage (requires Prowl and behind target)
        --Pounce (requires Prowl and behind target)
        --Shred (requires behind the target)
        --Tiger's Fury (cooldown)
        if toggle('cooldowns', false) then
          if castable("Tiger's Fury") and -spell("Tiger's Fury") == 0 and player.buff("Tiger's Fury").down then
            return cast("Tiger's Fury")
          end
        end      
        if not IsCurrentSpell(6603) then
          return cast('Attack')
        end      
        --Cat Form
        if castable('Cat Form') and player.buff('Cat Form').down then
          return cast('Cat Form', 'player')
        end
        --Faerie Fire (Feral)
        if castable('Faerie Fire (Feral)') and -spell('Faerie Fire (Feral)') == 0 and target.debuff('Faerie Fire (Feral)').down and IsSpellInRange('Faerie Fire (Feral)', 'target') == 1 then
          return cast('Faerie Fire (Feral)', 'target')
        end
        --Rake
        if castable('Rake') and -spell('Rake') == 0 and target.debuff('Rake').down and player.power.combopoints.actual < 5 and IsSpellInRange('Rake', 'target') == 1 then
          return cast('Rake', 'target')
        end
        --Claw
        if castable('Claw') and -spell('Claw') == 0 and player.power.combopoints.actual < 5 and IsSpellInRange('Claw', 'target') == 1 then
          return cast('Claw', 'target')
        end
        --Rip if Ferocious Bite not known
        if not IsSpellKnown(22568) and castable('Rip') and -spell('Rip') == 0 and player.power.combopoints.actual >= ripcp and IsSpellInRange('Rip', 'target') == 1 then
          return cast('Rip', 'target')
        end
        --Ferocious Bite
        if castable('Ferocious Bite') and -spell('Ferocious Bite') == 0 and player.power.combopoints.actual == 5 and IsSpellInRange('Ferocious Bite', 'target') == 1 then
          return cast('Ferocious Bite', 'target')
        end
        --AoE
      end

  end
end
--End

--Resting Function
local function resting()
  DebugLog = dark_addon.settings.fetch('dr_druid_debuglog', false)

if not player.alive or player.buff('Drink').up or player.buff('Food').up or player.channeling() or player.casting then return end

  local mylevel = UnitLevel("player")
  local animalform = player.buff('Bear Form').up or player.buff('Cat Form').up or player.buff('Dire Bear Form').up 
    or player.buff('Travel Form').up or player.buff('Aquatic Form').up  
  local curepoisonooc = dark_addon.settings.fetch('dr_druid_curepoisonooc', false)
  local autobuffthorns = dark_addon.settings.fetch('dr_druid_autobuffthorns', false)
  local autobuffmotw = dark_addon.settings.fetch('dr_druid_autobuffmotw', false)
  local autoprowl = dark_addon.settings.fetch('dr_druid_autoprowl', false)
  local outdoors = IsOutdoors()
  local water = IsSubmerged() or IsSwimming()

  if dark_addon.protected then

   --Self Dispel Poison & Disease
  local dispel_unit = group.removable('poison')
  if dispel_unit and castable('Cure Poison') and -spell('Cure Poison') == 0 and IsSpellInRange('Cure Poison', dispel_unit.unitID) and curepoisonooc then
    macro("/cancelform")      
    return cast('Cure Poison', player)
  end  

  if target.exists and target.enemy and target.alive and not IsCurrentSpell(6603) then
    return cast('Attack')
  end  
        
    --Cancel Current Form OOC
    --Allows interaction with objects and NPCs
    if toggle('override_form', false) then
      macro("/cancelform")
    end

    --Healing OOC
    local useoochealingtouch = dark_addon.settings.fetch('dr_druid_oochealingtouch.check', true)
    local oochealingtouchpercent = dark_addon.settings.fetch('dr_druid_oochealingtouch.spin', 25)
    local useoocrejuvenation = dark_addon.settings.fetch('dr_druid_oocrejuvenation.check', true)
    local oocrejuvenationpercent = dark_addon.settings.fetch('dr_druid_oocrejuvenation.spin', 25)
    local useoocregrowth = dark_addon.settings.fetch('dr_druid_oocregrowth.check', true)
    local oocregrowthpercent = dark_addon.settings.fetch('dr_druid_oocregrowth.spin', 25)
    --Cancel form to heal
    if useoochealingtouch == true and player.health.percent <= oochealingtouchpercent and animalform ==  true then
      macro("/cancelform")
    end
    if useoocrejuvenation == true and player.health.percent <= oocrejuvenationpercent and animalform ==  true then
      macro("/cancelform")
    end
    if useoocregrowth == true and player.health.percent <= oocregrowthpercent and animalform ==  true then
      macro("/cancelform")
    end
    --Healing Touch
    if useoochealingtouch == true and castable('Healing Touch') and player.health.percent <= oochealingtouchpercent and not spell('Healing Touch').lastcast then
      return cast('Healing Touch', 'player')
    end
    --Rejuvenation
    if useoocrejuvenation == true and castable('Rejuvenation') and player.health.percent <= oocrejuvenationpercent and player.buff('Rejuvenation').down then
      return cast('Rejuvenation', 'player')
    end
    --Regrowth
    if useoocregrowth == true and castable('Regrowth') and player.health.percent <= oocregrowthpercent and player.buff('Regrowth').down then
      return cast('Regrowth', 'player')
    end

    --if (toggle('travel_form', false) and (player.buff('Bear Form').up or player.buff('Cat Form').up or player.buff('Dire Bear Form').up)) then
    --  macro("/cancelform")
    --end    

    --Travel Form OOC
    --if toggle('travel_form', false) and outdoors and castable('Travel Form') and -spell('Travel Form') == 0 and player.buff('Travel Form').down then
    --  return cast('Travel Form', 'player')
    --end

    --if toggle('travel_form', false) and water and castable('Aquatic Form') and -spell('Aquatic Form') == 0 and player.buff('Aquatic Form').down then
    --  return cast('Aquatic Form', 'player')
    --end  

    --if toggle('travel_form', false) then
    --  travelform()
    --  return 
    --end    
    --if toggle('travel_form', false) then
    --    if outdoors and (player.buff('Bear Form').up or player.buff('Cat Form').up or player.buff('Dire Bear Form').up) then
    --      macro("/cancelform")
    --    end
    --    if outdoors and -spell('Travel Form') == 0 and player.buff('Travel Form').down then
    --      return cast('Travel Form', 'player')
    --    end
    --    if water and (player.buff('Bear Form').up or player.buff('Cat Form').up or player.buff('Dire Bear Form').up) then
    --      macro("/cancelform")
    --    end  
    --    if water and castable('Aquatic Form') and -spell('Aquatic Form') == 0 and player.buff('Aquatic Form').down then
    --      return cast('Aquatic Form', 'player')
    --    end
    --end               

    --Prowl OOC
    if autoprowl and castable('Prowl') and -spell('Prowl') == 0 and player.buff('Prowl').down then
      return cast('Prowl', 'player')
    end

    --Buffs OOC
    --Cancel form to replace buff
    if (autobuffmotw or autobuffthorns) and (not player.buff('Mark of the Wild').any or not player.buff('Thorns').any) and (player.buff('Bear Form').up or player.buff('Dire Bear Form').up or player.buff('Cat Form').up) then
      macro('/cancelform')
    end

    --Gift of the Wild
    --if IsSpellKnown(21849) and castable('Gift of the Wild') and -spell('Gift of the Wild') == 0 and not player.buff('Gift of the Wild').up and not player.channeling() then
    --  return cast('Gift of the Wild', 'player')
    --end

    --Mark of the Wild
    if autobuffmotw and not IsSpellKnown(21849) and castable('Mark of the Wild') and -spell('Mark of the Wild') == 0 and not player.buff('Mark of the Wild').any and not player.channeling() then
      return cast('Mark of the Wild', 'player')
    end

    --Thorns
    if autobuffthorns and castable('Thorns') and -spell('Thorns') == 0 and not player.buff('Thorns').any and not player.channeling() then
      return cast('Thorns', 'player')
    end
    
    --Skinning
    if skinning() then
      return
    end

    --Caster Form Combat OOC
    if mylevel < 10 then
      --Opener from resting Moonfire
      if dark_addon.settings.fetch('dr_druid_opener') == 'Moonfire' then
        if target.exists and castable('Moonfire') and -spell('Moonfire') == 0 and target.debuff('Moonfire').down and IsSpellInRange('Moonfire', 'target') == 1 then
          return cast('Moonfire', 'target')
        end
      end      
      --Open with Wrath if Moonfire not known
      if target.exists and not IsSpellKnown(8921) and castable('Wrath') and -spell('Wrath') == 0 and IsSpellInRange('Wrath', 'target') == 1 then
        return cast('Wrath', 'target')
      end
    end

    --Openers with "Manual" selected
    if dark_addon.settings.fetch('dr_druid_form') == 'Manual' then
      if dark_addon.settings.fetch('dr_druid_opener') == 'Moonfire' then
        if target.exists and castable('Moonfire') and -spell('Moonfire') == 0 and target.debuff('Moonfire').down and IsSpellInRange('Moonfire', 'target') == 1 then
          return cast('Moonfire', 'target')
        end
      end
      if dark_addon.settings.fetch('dr_druid_opener') == 'Faerie Fire' then
        if target.exists and castable('Faerie Fire') and -spell('Faerie Fire') == 0 and target.debuff('Faerie Fire').down and IsSpellInRange('Faerie Fire', 'target') == 1 then
          return cast('Faerie Fire', 'target')
        end
      end
      if dark_addon.settings.fetch('dr_druid_opener') == 'Moonfire' then
        if animalform == true and target.exists and castable('Faerie Fire (Feral)') and -spell('Faerie Fire (Feral)') == 0 and target.debuff('Faerie Fire (Feral)').down and IsSpellInRange('Faerie Fire (Feral)', 'target') == 1 then
          return cast('Faerie Fire (Feral)', 'target')
        end
      end                
    end
    
        --Form management with no opener
        if dark_addon.settings.fetch('dr_druid_opener') == 'None' then
          if not toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Bear' then
            --Dire Bear Form
            if IsSpellKnown(9634) and castable('Dire Bear Form') and player.buff('Dire Bear Form').down then
              return cast('Dire Bear Form', player)
            end
            --Bear Form
            if not IsSpellKnown(9634) and castable('Bear Form') and player.buff('Bear Form').down then
              return cast('Bear Form', player)
            end
          end
          if not toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Cat' then  
            --Cat Form
            if castable('Cat Form') and player.buff('Cat Form').down then
              return cast('Cat Form', player)
            end
          end  
        end       

        --Form management with Moonfire opener
        if dark_addon.settings.fetch('dr_druid_opener') == 'Moonfire' then
          if animalform == true and target.exists and -spell('Moonfire') == 0 and target.debuff('Moonfire').down and IsSpellInRange('Moonfire', 'target') == 1 then
            macro("/cancelform")        
            return cast('Moonfire', 'target')
          end
          if target.exists and castable('Moonfire') and -spell('Moonfire') == 0 and target.debuff('Moonfire').down and IsSpellInRange('Moonfire', 'target') == 1 then
            return cast('Moonfire', 'target')
          end
          if not toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Bear' then      
            --Dire Bear Form
            if IsSpellKnown(9634) and castable('Dire Bear Form') and player.buff('Dire Bear Form').down then
              return cast('Dire Bear Form', player)
            end
            --Bear Form
            if not IsSpellKnown(9634) and castable('Bear Form') and player.buff('Bear Form').down then
              return cast('Bear Form', player)
            end
          end
          if not toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Cat' then
            --Cat Form
            if castable('Cat Form') and player.buff('Cat Form').down then
              return cast('Cat Form', player)
            end
          end            
        end

        --Form management with Faerie Fire opener
        if dark_addon.settings.fetch('dr_druid_opener') == 'Faerie Fire' then
          if animalform == true and target.exists and -spell('Faerie Fire') == 0 and target.debuff('Faerie Fire').down and IsSpellInRange('Faerie Fire', 'target') == 1 then
            macro("/cancelform")        
            return cast('Faerie Fire', 'target')
          end
          if target.exists and castable('Faerie Fire') and -spell('Faerie Fire') == 0 and target.debuff('Faerie Fire').down and IsSpellInRange('Faerie Fire', 'target') == 1 then
            return cast('Faerie Fire', 'target')
          end
          if not toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Bear' then      
            --Dire Bear Form
            if IsSpellKnown(9634) and castable('Dire Bear Form') and player.buff('Dire Bear Form').down then
              return cast('Dire Bear Form', player)
            end
            --Bear Form
            if not IsSpellKnown(9634) and castable('Bear Form') and player.buff('Bear Form').down then
              return cast('Bear Form', player)
            end
          end
          if not toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Cat' then
            --Cat Form
            if castable('Cat Form') and player.buff('Cat Form').down then
              return cast('Cat Form', player)
            end
          end            
        end

        --Form management with Feral Faerie Fire opener
        if dark_addon.settings.fetch('dr_druid_opener') == 'Feral Faerie Fire' then
          if animalform == true and target.exists and castable('Faerie Fire (Feral)') and -spell('Faerie Fire (Feral)') == 0 and target.debuff('Faerie Fire (Feral)').down 
          and IsSpellInRange('Faerie Fire (Feral)', 'target') == 1 and player.buff('Prowl').down then
            return cast('Faerie Fire (Feral)', 'target')
          end
          if toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Bear' then      
            --Dire Bear Form
            if IsSpellKnown(9634) and castable('Dire Bear Form') and player.buff('Dire Bear Form').down then
              return cast('Dire Bear Form', player)
            end
            --Bear Form
            if not IsSpellKnown(9634) and castable('Bear Form') and player.buff('Bear Form').down then
              return cast('Bear Form', player)
            end
          end
          if toggle('override_form', false) and dark_addon.settings.fetch('dr_druid_form') == 'Cat' then
            --Cat Form
            if castable('Cat Form') and player.buff('Cat Form').down then
              return cast('Cat Form', player)
            end
          end            
        end
    
  end
end
--End

local function interface()

  local druid = {

  key = 'dr_druid',
  title = 'Druid',
  width = 300,
  height = 860,
  resize = true,
  show = false,
  template = {

  { type = 'header', text = 'Classic Druid Settings', align = 'center' },
  { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
  { type = 'rule' },
  { type = 'header', text = 'General Options', align = 'left' },   
  { type = 'rule' },

  { key = 'debuglog', type = 'checkbox', text = 'Send debug info to console', default = false},
  { type = 'rule' },

  { key = 'form', type = 'dropdown', text = 'Preferred Form', desc = '', default = 'Bear',
    list = {
    { key = 'Bear', text = 'Bear' },
    { key = 'Cat', text = 'Cat' },
    { key = 'Manual', text = 'You control all' },
  }
  },

  { type = 'rule' },
  { key = 'opener', type = 'dropdown', text = 'Preferred Opener from Resting', desc = '', default = 'Moonfire',
    list = {
    { key = 'None', text = 'None' },
    { key = 'Moonfire', text = 'Moonfire' },
    { key = 'Faerie Fire', text = 'Faerie Fire' },
    { key = 'Feral Faerie Fire', text = 'Feral Faerie Fire' },
  }
  },

  { type = 'rule' },
  { type = 'header', text = 'Cat Options', align = 'left'  },
  { type = 'rule' },
  { key = 'autoprowl', type = 'checkbox', text = 'Automatically cast Prowl', desc = 'Use out of combat' },  
  { key = 'ripcp', type = 'spinner', text = 'Rip Combo Points', desc = 'Use Rip at ', default = 3, min = 1, max = 5, step = 1},

  { type = 'rule' },
  { type = 'header', text = 'Bear/Dire Bear Options', align = 'left'  },
  { type = 'rule' },
  { key = 'usedemoroar', type = 'checkbox', text = 'Demoralizing Roar', desc = 'Use all the time' },
  { key = 'usegrowl', type = 'checkbox', text = 'Growl', desc = 'Use all the time' },

  { type = 'rule' },
  { type = 'header', text = 'Self Healing Options', align = 'left'  },
  { type = 'rule' },
  --{ key = 'healpause', type = 'spinner', text = 'Healing Cooldown', desc = 'Pause before update check ', default = 8000, min = 1, max = 10000, step = 1},
  { key = 'ichealingtouch', type = 'checkspin', text = 'Healing Touch In Combat', desc = 'Healing Touch at player health %', min = 1, max = 100, step = 5},
  { key = 'oochealingtouch', type = 'checkspin', text = 'Healing Touch At Rest', desc = 'Healing Touch at player health %', min = 1, max = 100, step = 5},
  { key = 'icregrowth', type = 'checkspin', text = 'Regrowth In Combat', desc = 'Regrowth at player health %', min = 1, max = 100, step = 5},
  { key = 'oocregrowth', type = 'checkspin', text = 'Regrowth At Rest', desc = 'Regrowth at player health %', min = 1, max = 100, step = 5},
  { key = 'icrejuvenation', type = 'checkspin', text = 'Rejuvenation In Combat', desc = 'Rejuvenation at player health %', min = 1, max = 100, step = 5},
  { key = 'oocrejuvenation', type = 'checkspin', text = 'Rejuvenation At Rest', desc = 'Rejuvenation at player health %', min = 1, max = 100, step = 5},
  { key = 'curepoisonooc', type = 'checkbox', text = 'Cure Poison', desc = 'Use out of combat, otherwise will use in combat' },
  { key = 'healpot', type = 'checkspin', text = 'Use Healing Potion In Combat', desc = 'Healing Potion at player health %', min = 1, max = 100, step = 5},
  { key = 'manapot', type = 'checkspin', text = 'Use Mana Potion In Combat', desc = 'Mana Potion at player mana %', min = 1, max = 100, step = 5},

  { type = 'rule' },
  { type = 'header', text = 'Buff Options', align = 'left'  },
  { type = 'rule' },
  { key = 'autobuffthorns', type = 'checkbox', text = 'Self-Buff Thorns', desc = 'Use out of combat' },
  { key = 'autobuffmotw', type = 'checkbox', text = 'Self-Buff MOTW', desc = 'Use out of combat' },
  
  --{ type = 'rule' },
  --{ type = 'header', text = 'Skinning', align = 'left' },
  --{ type = 'rule' },

  --{ key = 'skinning', type = 'checkbox', text = 'Enable Auto Skinning', desc = 'Uses Luabox Skinning Function', default = false},
  --{ key = 'scan_radius_skin', type = 'spinner', text = 'Scan Radius Skinning', desc = '', default = 20, min = 5, max = 50, step = 5},
  --{ key = 'lootDelay', type = 'spinner', text = 'Loot Timer Blacklist', desc = '', default = 1, min = 0, max = 10, step = 0.01},
  --{ key = 'skinDelay', type = 'spinner', text = 'Skin Timer Blacklist', desc = '', default = 1, min = 0, max = 10, step = 0.01},

}
}

configWindow = dark_addon.interface.builder.buildGUI(druid)

dark_addon.interface.buttons.add_toggle({
  name = 'override_form',
  label = 'Override Form',
  font = 'dark_addon_icon',
  on = {
    label = dark_addon.interface.icon('do-not-enter'),
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.dark_red
    },
    off = {
      label = dark_addon.interface.icon('do-not-enter'),
        color = dark_addon.interface.color.grey,
        color2 = dark_addon.interface.color.dark_grey
      }
    })

--dark_addon.interface.buttons.add_toggle({
--  name = 'travel_form',
--  label = 'Travel Form',
--  font = 'dark_addon_icon',
--  on = {
--    label = dark_addon.interface.icon('car'),
--      color = dark_addon.interface.color.orange,
--      color2 = dark_addon.interface.color.dark_orange
--    },
--    off = {
--      label = dark_addon.interface.icon('car'),
--        color = dark_addon.interface.color.grey,
--        color2 = dark_addon.interface.color.dark_grey
--      }
--    })

    dark_addon.interface.buttons.add_toggle({
      name = 'settings',
      label = 'Rotation Settings',
      font = 'dark_addon_icon',
      on = {
        label = dark_addon.interface.icon('cog'),
        color = dark_addon.interface.color.orange,
        color2 = dark_addon.interface.color.dark_orange
      },
      off = {
        label = dark_addon.interface.icon('cog'),
        color = dark_addon.interface.color.grey,
        color2 = dark_addon.interface.color.dark_grey
      },
      callback = function(self)
        if configWindow.parent:IsShown() then
          configWindow.parent:Hide()
        else
          configWindow.parent:Show()
        end

      end
    })

  end

  dark_addon.rotation.register({
    name = 'druid',
    label = 'Druid Rotation',
    combat = combat,
    resting = resting,
    interface = interface
  })
