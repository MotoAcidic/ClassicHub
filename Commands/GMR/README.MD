
- Settings
```
/run HEALTH_PERCENTAGE_EAT = 100
/run HEALTH_PERCENTAGE_EAT = 90
/run MANA_PERCENTAGE_DRINK = 50
/run GrindEverything(true)
```
- Open Clams
```
if GetItemCount(7973) >= 1 then
    RunMacroText("/use Big-mouth Clam")
    end
    if GetItemCount(5524) >= 1 then
    RunMacroText("/use Thick-shelled Clam")
    end
```