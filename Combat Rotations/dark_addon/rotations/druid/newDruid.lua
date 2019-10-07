-------------------------------------
-- Druid Levelling Rotation by Rex / TFinch --
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
    --Starfire
    --Hurricane

    --Cooldowns
    -----------
    --Omen of Clarity

    --Forms
    -------
    --Moonkin Form


local addon, dark_addon = ...
local addon, dark_addon_potions = ...

local SelfHealCastTime = 0
local function selfheal()
  if player.dead or player.channeling() then return end

  -- Pause if eating or drinking
  if dark_addon.settings.fetch('dr_druid_drinking', true) then
    for i=1,40 do
      local name, _ = UnitBuff("player",i)
      if name =='Drink' or name =='Food' then return end
    end
  end

  --- SELF HEALING
  -- Regrowth
  if player.health.percent <= dark_addon.settings.fetch('dr_druid_regrowth.spin', 10) 
  and dark_addon.settings.fetch('dr_druid_regrowth.check', false) then
    macro('/use Regrowth')
  end

  -- Rejuvenation
  if player.health.percent < dark_addon.settings.fetch('dr_druid_Rejuvenation.spin', 20)
  and dark_addon.settings.fetch('dr_druid_Rejuvenation.check', false) then
    macro('/use Rejuvenation')
  end

  -- Healing Touch
  if player.health.percent < dark_addon.settings.fetch('dr_druid_healingtouch.spin', 40)
  and dark_addon.settings.fetch('dr_druid_healingtouch.check', false) then
    macro('/use Healing Touch')
  end
end



local function interrupt()
  if not toggle('interrupts', false) then return end
  local intpercent = math.random(35, 55)
    if target.exists and target.alive and castable('Bash') and -spell('Bash') == 0 and target.interrupt(intpercent, false) and IsSpellInRange('Bash', 'target') == 1 then
      print("Bash @ " .. intpercent)
      cast('Bash', 'target')
      return true
    end
  return false
end
setfenv(interrupt, dark_addon.environment.env)

local function combat()

  local mylevel = UnitLevel("player")
  local targetlevel = UnitLevel("target")
  local inRange = enemies.around(5)
  local animalform = player.buff('Bear Form').up or player.buff('Cat Form').up or player.buff('Dire Bear Form').up 
    or player.buff('Travel Form').up or player.buff('Aquatic Form').up
  local bearform = player.buff('Bear Form').up or player.buff('Dire Bear Form').up
  local catform = player.buff('Cat Form').up

  local useichealingtouch = dark_addon.settings.fetch('dr_druid_ichealingtouch.check', true)
  local ichealingtouchpercent = dark_addon.settings.fetch('dr_druid_ichealingtouch.spin', 25)

  local useicregrowth = dark_addon.settings.fetch('dr_druid_icregrowth.check', true)
  local icregrowthpercent = dark_addon.settings.fetch('dr_druid_icregrowth.spin', 25)

  local useicrejuvenation = dark_addon.settings.fetch('dr_druid_icrejuvenation.check', true)
  local icrejuvenationpercent = dark_addon.settings.fetch('dr_druid_icrejuvenation.spin', 25)

  local useichealthpotion = dark_addon.settings.fetch('dr_druid_ichealthpotion.check', true)
  local ichealthpotionpercent = dark_addon.settings.fetch('dr_druid_icrhealthpotion.spin', 25)

  local useicmanapotion = dark_addon.settings.fetch('dr_druid_icmanapotion.check', true)
  local icmanapotionpercent = dark_addon.settings.fetch('dr_druid_icrmanapotion.spin', 25)

  local usedemoroar = dark_addon.settings.fetch('dr_druid_usedemoroar', false)
  local usegrowl = dark_addon.settings.fetch('dr_druid_usegrowl', false)
  local ripcp = dark_addon.settings.fetch('dr_druid_ripcp', 3)

  if target.alive and target.enemy and player.alive and not player.channeling() then

    --Cancel Current Form IC
    --Allows interaction with objects and NPCs
    if toggle('override_form', false) then
      macro("/cancelform")
    end    

    --Defensives IC
    if selfheal(true) then 
      return 
    end

    --Interrupts
    if interrupt() then 
      return 
    end

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
    if (dark_addon.settings.fetch('dr_druid_form') == 'Bear') or (dark_addon.settings.fetch('dr_druid_form') == 'Manual' and lastform == "bearform") then

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
    if (dark_addon.settings.fetch('dr_druid_form') == 'Cat') or (dark_addon.settings.fetch('dr_druid_form') == 'Manual' and lastform == "catform") then
      
      --Prowl
      --Dash

      --Cower

      --Ravage (requires Prowl and behind target)
      --Pounce (requires Prowl and behind target)
      --Shred (requires behind the target)

      --Tiger's Fury (cooldown)
      if toggle('cooldowns', false) then
        if castable("Tiger's Fury") and -spell("Tiger's Fury") == 0 then
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

local function resting()

if not player.alive or player.buff('Drink').up or player.buff('Food').up then return end

  if target.exists and target.enemy and target.alive and not IsCurrentSpell(6603) then
    return cast('Attack')
  end  

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

    --Cancel Current Form OOC
    --Allows interaction with objects and NPCs
    if toggle('override_form', false) then
      macro("/cancelform")
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

    --Defensives OOC
    if selfheal(false) then 
      return 
    end

    --Self Dispel Poison & Disease
    local dispel_unit = player.removable('poison')
    if dispel_unit and -spell('Cure Poison') == 0 and curepoisonooc then
      macro("/cancelform")      
      return cast('Cure Poison', player)
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

    --Form management with "Manual" selected
    if dark_addon.settings.fetch('dr_druid_form') == 'Manual' then
      if player.buff('Bear Form').up then
        lastform = "bearform"
      end
      if player.buff('Dire Bear Form').up then
        lastform = "bearform"
      end
      if player.buff('Cat Form').up then
        lastform = "catform"
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

        --Form management with Insect Swarm opener
    if dark_addon.settings.fetch('dr_druid_opener') == 'Insect Swarm' then
      if animalform == true and target.exists and -spell('Insect Swarm') == 0 and target.debuff('Insect Swarm').down and IsSpellInRange('Insect Swarm', 'target') == 1 then
        macro("/cancelform")        
        return cast('Insect Swarm', 'target')
      end
      if target.exists and castable('Insect Swarm') and -spell('Insect Swarm') == 0 and target.debuff('Insect Swarm').down and IsSpellInRange('Insect Swarm', 'target') == 1 then
        return cast('Insect Swarm', 'target')
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
local function interface()

  local druid = {

  key = 'dr_druid',
  title = 'Druid',
  width = 300,
  height = 640,
  resize = true,
  show = false,
  template = {

  { type = 'header', text = 'Classic Druid Settings', align = 'center' },
  { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
  { type = 'rule' },
  { type = 'text', text = 'General Options' },   
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
    { key = 'Insect Swarm', text = 'Insect Swarm' },
  }
  },

  { type = 'rule' },
  { type = 'text', text = 'Cat Options' },
  { type = 'rule' },
  { key = 'autoprowl', type = 'checkbox', text = 'Automatically cast Prowl', desc = 'Use out of combat' },  
  { key = 'ripcp', type = 'spinner', text = 'Rip Combo Points', desc = 'Use Rip at ', default = 3, min = 1, max = 5, step = 1},

  { type = 'rule' },
  { type = 'text', text = 'Bear/Dire Bear Options' },
  { type = 'rule' },
  { key = 'usedemoroar', type = 'checkbox', text = 'Demoralizing Roar', desc = 'Use all the time' },
  { key = 'usegrowl', type = 'checkbox', text = 'Growl', desc = 'Use all the time' },

  { type = 'rule' },
  { type = 'text', text = 'Self Healing Options' },
  { type = 'rule' },
  { key = 'healpause', type = 'spinner', text = 'Healing Cooldown', desc = 'Pause before update check ', default = 8, min = 1, max = 50, step = 1},
  { key = 'ichealingtouch', type = 'checkspin', text = 'Healing Touch', desc = 'Healing Touch at player health %', min = 1, max = 100, step = 5},
  { key = 'icregrowth', type = 'checkspin', text = 'Regrowth', desc = 'Regrowth at player health %', min = 1, max = 100, step = 5},
  { key = 'icrejuvenation', type = 'checkspin', text = 'Rejuvenation', desc = 'Rejuvenation at player health %', min = 1, max = 100, step = 5},
  { key = 'ichealthpotion', type = 'checkspin', text = 'Health Potion', desc = 'Health Potion used at player health %', min = 1, max = 100, step = 5},
  { key = 'icmanapotion', type = 'checkspin', text = 'Mana Potion', desc = 'Mana Potion used at player health %', min = 1, max = 100, step = 5},
  { key = 'curepoisonooc', type = 'checkbox', text = 'Cure Poison', desc = 'Use out of combat' },
  
  { type = 'rule' },
  { type = 'text', text = 'Buff Options' },
  { type = 'rule' },
  { key = 'autobuffthorns', type = 'checkbox', text = 'Self-Buff Thorns', desc = 'Use out of combat' },
  { key = 'autobuffmotw', type = 'checkbox', text = 'Self-Buff MOTW', desc = 'Use out of combat' },      

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

  dark_addon.data.removables = {
  curse = {
    [25771] = { name = "test", count = 1, health = 100 }
  },
  disease = {
    [25771] = { name = "test", count = 1, health = 100 }
  },
  magic = {
    [25771] = { name = "test", count = 1, health = 100 }
  },
  poison = {
    -- https://classic.wowhead.com/npc-abilities/dispel-type:4
    [14792] = { name = "Venomhide Poison", count = 1, health  = 100},
    [13884] = { name = "Withering Poison", count = 1, health  = 100},
    [744] = { name = "Poison", count = 1, health  = 100},
    [5416] = { name = "Venom Sting", count = 1, health  = 100},
    [7125] = { name = "Toxic Saliva", count = 1, health  = 100},
    [28776] = { name = "Necrotic Poison", count = 1, health  = 100},
    [3815] = { name = "Poison Cloud", count = 1, health  = 100},
    [8257] = { name = "Venom Sting", count = 1, health  = 100},
    [25991] = { name = "Poison Bolt Volley", count = 1, health  = 100},
    [7365] = { name = "Bottle of Poison", count = 1, health  = 100},
    [3583] = { name = "Deadly Poison", count = 1, health  = 100},
    [6251] = { name = "Weak Poison", count = 1, health  = 100},
    [7947] = { name = "Localized Toxin", count = 1, health  = 100},
    [8382] = { name = "Leech Poison", count = 1, health  = 100},
    [3396] = { name = "Corrosive Poison", count = 1, health  = 100},
    [5208] = { name = "Poisoned Harpoon", count = 1, health  = 100},
    [7357] = { name = "Poisonous Stab", count = 1, health  = 100},
    [8275] = { name = "Poisoned Shot", count = 1, health  = 100},
    [11918] = { name = "Poison", count = 1, health  = 100},
    [12251] = { name = "Virulent Poison", count = 1, health  = 100},
    [6917] = { name = "Venom Spit", count = 1, health  = 100},
    [7951] = { name = "Toxic Spit", count = 1, health  = 100},
    [8806] = { name = "Poisoned Shot", count = 1, health  = 100},
    [3358] = { name = "Leech Poison", count = 1, health  = 100},
    [8363] = { name = "Parasite", count = 1, health  = 100},
    [16552] = { name = "Venom Spit", count = 1, health  = 100},
    [3609] = { name = "Paralyzing Poison", count = 1, health  = 100},
    [7992] = { name = "Slowing Poison", count = 1, health  = 100},
  }
}
