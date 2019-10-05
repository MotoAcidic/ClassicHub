# dark_addon

An addon.

Changes:

* ** Specs are no longer a thing.  Each 'Class' will have its own set of loadable rotations. /dr list will show all available to the specific class.
* ** UnitCastingInfo is not working. target.casting will fail, but player.casting should work. CastingInfo still works.
* ** Talent functions are gone.
* ** All Spellbooks will have to be recreated.  Look at the warrior test file test.lua.  You will notice that you can just do return cast(spellname).  I will be creating spell books and not using that method



More to come...
