--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new(populate, ...)
		local tbl
		local t = next(cache)
		if ( t ) then
			cache[t] = nil
			tbl = t
		else
			tbl = {}
		end
		if ( populate ) then
			local num = select("#", ...)
			if ( populate == "hash" ) then
				assert(math.fmod(num, 2) == 0)
				local key
				for i = 1, num do
					local v = select(i, ...)
					if not ( math.fmod(i, 2) == 0 ) then
						key = v
					else
						tbl[key] = v
						key = nil
					end
				end
			elseif ( populate == "array" ) then
				for i = 1, num do
					local v = select(i, ...)
					table.insert(tbl, i, v)
				end
			end
		end
		return tbl
	end
	function del(t)
		for k in next, t do
			t[k] = nil
		end
		cache[t] = true
	end
end
--[==[ Necrosis tables
Translation items are in Dialog.lua!

This file and Dialog.lua are the two places WoW ids are specified. Then short names, localized names, or passed ids are used.

These include item names and labels set manual and programmatic.
Notes: 
- Translation strings are held via a mix of variables in Dialog and Spells (this file). 
   The rule of thumb is items, labels, and 'dialog' to the player are in Dialog; spell info in Spells
- The code to set them is in Necrosis as part of the initialization code.

There are 4 main tables that form the basis of Necrosis:
- Warlock_Spells
- Warlock_Buttons
- Warlock_Lists
- Warlock_Spell_Use

Note: Spell lists are in this file. This keeps them in one, maintainable place.

::: Warlock_Spells
Specifies all the warlock spells we process (and more).

::: Warlock_Lists
This table hold various lists needed; importantly it specifies the button order and grouping of the Necrosis buttons;
it also holds other lists that are explained in comments inside the table.

::: Warlock_Buttons
Holds the frame information of the Necrosis buttons

::: Warlock_Spell_Use
This table holds ALL the warlock spells listed in Warlock_Spells. Names of some spells are needed even if not known by the warlock.
This table is created on the fly at initialization and rebuilt when spells are learned or changed.
Use IsSpellKnown below to determine if a spell is known / in the spell book.

======
The set of tables allows the highest spells of a type to be gathered and referenced easily using a 'usage' string id, such as "armor".
There is no need to remember spell ids or table indexes.

A group of helper routines are at the bottom of this file to get get spell info, see if a spell is known, and more.
These encapsulates the rather long statements to get data.

Basing the spells on WoW ids and 'usage' allows spell info to be localized automatically without relying on manual translations.
The UsageRank abstracts what highest means and eliminates a lot of hard coding. An example is Demon Skin becoming Demon Armor.

--]==]
--[===[ ::: Add a new spell to existing list
To add a new spell do the following:

Warlock_Spells
- Add the spell by id, including all its levels
- Set the UsageRank and SpellRank manually
- Set Usage to link to lists (Warlock_Lists)
- Set the Type depending on what, if any timer, is needed. 
- Set Length and Cooldown if Timer

Warlock_Buttons
- Create a button entry for the spell
- Set the index (short name) which will be used in Warlock_Lists
- Set Tip for tool tip in Necrosis.lua 
- Set anchor, relative to its
- Set the texture norm; high / push if needed; New files in /UI may need to created

Warlock_Lists
- Determine which list it will be in
- Set f_ptr to the button short name 
- Set high_of the same as Usage in Warlock_Spells

TooltipData (Dialog.lua)
- Add an entry whose index is the same as tip in Warlock_Buttons
- Add a Label entry under index
- Add Text / Text2 / Ritual as needed; these are hard coded into BuildButtonTooltip in Necrosis.lua
   Update localization files for any new strings

Other
- Look at Attributes.lua to see if the right attributes would be set for the new spell.
--]===]

--[===[ ::: Add a new menu
To add a new menu do the following:
- Follow steps to add new spell(s) (above) for the new menu - Warlock_Spells / Warlock_Buttons / TooltipData

Warlock_Buttons
- Create a button entry for the menu
- Set the index (short name) which will be used in Warlok_Lists
- Set f to the frame name to use. This needs to unique across all frames. using Necrosis as a prefix is a good start.
   This is NOT used for any logic, that the names include numbers is a hold over to original coding. 
- Set Tip for tool tip in Necrosis.lua 
- Set anchor, relative to its
- Set the texture norm; high / push if needed; New files in UI may need to be created for graphics
- Set menu so any special logic can be added
   Check other menu values to see where the logic needs to be, especially XML.lua

Warlock_Lists: 
- Add an entry to "on_sphere" for the new menu; set menu to new entry in Warlock_Lists
- Add a entry to hold spells (copy buffs as an example)
- Add an entry for each spell in the menu
- For each spell in the menu - Set f_ptr to the button short name 
- For each spell in the menuSet high_of the same as Usage in Warlock_Spells

Necrosis.TooltipData (Dialog.lua)
- Add an entry whose index is the same as tip for the menu in Warlock_Buttons
- Add a Label entry under index
- Add Text / Text2 / Ritual as needed; these are hard coded into BuildButtonTooltip in Necrosis.lua
   Update localization files for any new strings

Other
- Look at Attributes.lua to see if the right attributes would be set for the new spell buttons and menu button.
   New routines may be needed.
- Look at Local.DefaultConfig- add the new buttons with default positions
- Look at option code in XML folder. Likely new options or check boxes will be needed
--]===]

--========================================================
--[[ Warlock_Spell_Use
Fields
- index is string and are the same values as Usage in Warlock_Spells.

Built on the fly on at initialize / spell change. 
By 'Usage', will contain highest id of each 'Usage' known by the warlock or the 'lowest' if not known
--]]
Necrosis.Warlock_Spell_Use = {} 

--[[ Warlock_Spells
 This table lists the spells used by Necrosis with rank. To Get Ids Use: https://classicdb.ch and GetItemInfo.

 The API to return spell info does NOT return the rank which sucks BIG time so this table will 
 hard code them.
 This is the overall list, the player spell book will also be parsed.
 
Fields:
- The index is the spell ID. GetSpellInfo is used to pull the localized name. 
- SpellRank: The spell rank was added by hand based on the spell id. NOTE: The rank returned by GetSpellInfo is always nil... 
- UsageRank: allows spells of different names to ranked appropriately. Creating health stones and demon skin / armor 
- Usage: is the link to the other tables.
- Timer: true / false whether a timer is desired
Note: As of 7.2, some timers were made selectable (optional) by users. They are in the config / saved variables
- Length / Cooldown / Group are used to create timers
Added fields by code:
- Name: localized spell name from GetSpellBookItemName
- Rank: localized spell rank from GetSpellBookItemName
- CastName: made from <Name>(<Rank>)
- Mana: Cost from GetSpellPowerCost
- InSpellBook: true if found in the player spell book

Notes:
- Created stones are looked for by localized name. The name does NOT include the rank / quality of the stone.
  The stone ids & links are provided but may not be used in the code

Timers:
Spell timers have different aspects:
- Cool down: Can NOT be canceled
- Duration - Buff: Can be canceled manually or by losing aura
- Duration - Spell: Can be canceled by losing aura or dropping out of combat
- Removal - casting: When cast what needs to be removed?
   - Always remove a timer with same Usage AND same target
- Removal - aura:
   - Always remove a timer with same Usage AND same target
   - This will handle curses (one per target)

Notes:
- Banish could be treated as spell or buff duration. WoW calls it a buff.
- For cross spell interaction such as curses (one per target)
  rely on events to remove the spell by name (SPELL_AURA_REMOVED);
  meaning the addon does not have to code this!


--]]
Necrosis.Warlock_Spells = {
--[[
Notes:
- Ritual of Souls (90429) was removed when Mists of Pandaria released
--]]
	-- ::: Summon something
	[5784]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "mount"}, -- 40 Felsteed  mount
	[23161]	= {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "mount"}, -- 60 Dreadsteed mount
	[688]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "imp", PetId = 416,}, -- Imp || Diablotin
	[697]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "voidwalker", PetId = 1860, reagent = "soul_shard", }, -- Voidwalker || Marcheur Pet-0-4379-0-47-1860-1700179E68
	[712]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "succubus", PetId = 1863, reagent = "soul_shard", }, -- Succubus || Succube
	[691]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "felhunter", PetId = 417, reagent = "soul_shard", }, -- Felhunter
	[1122]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "inferno", 
			Length = 5, Cooldown = 3600, reagent = "infernal_stone", }, -- 5852 Inferno || https://classicdb.ch/?spell=1122 -- Infernals https://classic.wowhead.com/spell=23426 Needs research
	[18540] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "rit_of_doom", 
			Length = 0, Cooldown = 3600, reagent = "demonic_figurine", }, -- 11859 Ritual of Doom || Rituel funeste || https://classicdb.ch/?spell=18540
	
	-- ::: Stones
	-- Create Soulstone minor || Création pierre d'âme
	[693]   = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "soulstone",}, -- minor 18|| https://classicdb.ch/?spell=693 || https://classicdb.ch/?item=5232
	[20752] = {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "soulstone",}, -- lesser 30|| https://classicdb.ch/?spell=20752 || https://classicdb.ch/?item=16892
	[20755] = {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "soulstone",}, -- 40 || https://classicdb.ch/?spell=20755 || https://classicdb.ch/?item=16893
	[20756] = {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "soulstone",}, -- greater 50|| https://classicdb.ch/?spell=20756 || https://classicdb.ch/?item=16895
	[20757] = {UsageRank = 5, SpellRank = 5, Timer = false, Usage = "soulstone",}, -- major 60|| https://classicdb.ch/?spell=20757 || https://classicdb.ch/?item=16896
	-- Create Healthstone minor || Création pierre de soin
	[6201]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "healthstone",}, -- minor 10 || https://classicdb.ch/?spell=6201 ||
	[6202]	= {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "healthstone",}, -- lesser 22 || https://classicdb.ch/?spell=6202 ||
	[5699]	= {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "healthstone",}, -- 34 || https://classicdb.ch/?spell=5699 ||
	[11729]	= {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "healthstone",}, -- greater 46 || https://classicdb.ch/?spell=11729||
	[11730]	= {UsageRank = 5, SpellRank = 5, Timer = false, Usage = "healthstone",}, -- major 58 || https://classicdb.ch/?spell=11730 ||

	-- Create Spellstone || Création pierre de sort
	[2362]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "spellstone", Length = 60, Cooldown = 180,}, -- 36 || https://classicdb.ch/?spell=2362 || https://classicdb.ch/?item=5522
	[17727]	= {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "spellstone", Length = 60, Cooldown = 180,}, -- 48 || https://classicdb.ch/?spell=17727 || https://classicdb.ch/?item=13602
	[17728]	= {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "spellstone", Length = 60, Cooldown = 180,}, -- 60 || https://classicdb.ch/?spell=17728 || https://classicdb.ch/?item=13603
	-- Create Firestone || Création pierre de feu
	[6366]  = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "firestone",}, -- 28 || https://classicdb.ch/?spell=6366 || http://classicdb.ch/?item=1254
	[17951] = {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "firestone",}, -- 36 || https://classicdb.ch/?spell=17951 || https://classicdb.ch/?item=13699
	[17952] = {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "firestone",}, -- 46 || https://classicdb.ch/?spell=17952 || https://classicdb.ch/?item=13700
	[17953] = {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "firestone",}, -- 56 || https://classicdb.ch/?spell=17953 || https://classicdb.ch/?item=13701

	-- ::: Buffs
	[687]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, -- Demon Skin || Peau de démon 
	[696]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, --  
	[706]	= {UsageRank = 3, SpellRank = 1, Timer = false, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, -- Demon Armor || Armure démoniaque
	[1086]	= {UsageRank = 4, SpellRank = 2, Timer = false, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, -- 
	[11733] = {UsageRank = 5, SpellRank = 3, Timer = false, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, -- 
	[11734] = {UsageRank = 6, SpellRank = 4, Timer = false, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, -- 
	[11735] = {UsageRank = 7, SpellRank = 5, Timer = false, Usage = "armor", Length = 1800, Buff = true, SelfOnly = true, }, -- 
	[5697]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "breath", Length = 600, Buff = true, }, -- Unending Breath || Respiration interminable
	[126]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "eye", Length = 45, Buff = true, SelfOnly = true, }, -- Eye of Kilrogg
	[698]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "summoning", Length = 600, Buff = true, }, -- Ritual of Summoning || Rituel d'invocation
	[19028] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "link", Buff = true, SelfOnly = true, }, -- Soul Link || Lien spirituel

	[6229]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "ward", Length = 30, Buff = true, }, -- Shadow Ward || Gardien de l'ombre
	[11739] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "ward", Length = 30, Buff = true, }, -- 
	[11740] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "ward", Length = 30, Buff = true, }, -- 
	[28610] = {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "ward", Length = 30, Buff = true, }, -- 

	[1098] 	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "enslave", Length = 300, Buff = true, }, -- Enslave Demon
	[11725] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "enslave", Length = 300, Buff = true, }, -- 
	[11726] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "enslave", Length = 300, Buff = true, }, --  

	[710]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "banish", Length = 20, Buff = true, }, -- Banish 
	[18647] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "banish", Length = 30, Buff = true, }, --  

	[132]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "invisible", Length = 600, Buff = true, }, -- 26 || Detect Invisibility || https://classicdb.ch/?spell=132
	[2970]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "invisible", Length = 600, Buff = true, }, -- 38 || https://classicdb.ch/?spell=2970
	[11743]	= {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "invisible", Length = 600, Buff = true, }, -- 50 || https://classicdb.ch/?spell=11743
	
	-- ::: Curses
	[702]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "weakness", Length = 120, }, -- Curse of Weakness || Malédiction Faiblesse 
	[1108]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "weakness", Length = 120, }, --  
	[6205]	= {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "weakness", Length = 120, }, --  
	[7646]	= {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "weakness", Length = 120, }, --  
	[11707] = {UsageRank = 5, SpellRank = 5, Timer = true, Usage = "weakness", Length = 120, }, --  
	[11708] = {UsageRank = 6, SpellRank = 6, Timer = true, Usage = "weakness", Length = 120, }, --  

	[980]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "agony", Length = 24, }, -- Curse of Agony || Malédiction Agonie 
	[1014]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "agony", Length = 24, }, --  
	[6217]	= {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "agony", Length = 24, }, --  
	[11711] = {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "agony", Length = 24, }, --  
	[11712] = {UsageRank = 5, SpellRank = 5, Timer = true, Usage = "agony", Length = 24, }, --  
	[11713] = {UsageRank = 6, SpellRank = 6, Timer = true, Usage = "agony", Length = 24, }, --  

	[1714]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "tongues", Length = 30, }, -- Curse of Tongues || Malédiction Langage 
	[11719] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "tongues", Length = 30, }, --  

	[18223] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "exhaustion", Length = 12, }, -- Curse of Exhaustion || Malédiction de fatigue || improved via talent points

	[1490]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "elements", Length = 300, }, -- Curse of the Elements || Malédiction Eléments 
	[11721] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "elements", Length = 300, }, --  
	[11722] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "elements", Length = 300, }, --  

	[17862]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "shadow", Length = 300, }, -- Curse of Shadow 
	[17937] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "shadow", Length = 300, }, --  

	[603]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "doom", Length = 60, Cooldown = 60,}, -- Curse of Doom || Malédiction funeste 

	[704]	= {UsageRank = 1, SpellRank = 1 , Timer = true, Usage = "recklessness", Length = 120, }, -- Curse of Recklessness - removed in patch 3.1 || Malédiction Témérité || 
	[7658]	= {UsageRank = 2, SpellRank = 2 , Timer = true, Usage = "recklessness", Length = 120, }, --  
	[7659]	= {UsageRank = 3, SpellRank = 3 , Timer = true, Usage = "recklessness", Length = 120, }, -- 
	[11717] = {UsageRank = 4, SpellRank = 4 , Timer = true, Usage = "recklessness", Length = 120, }, -- 

	[172]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "corruption", Length = 12, }, -- Corruption 
	[6222]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "corruption", Length = 15, }, --  
	[6223]	= {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "corruption", Length = 18, }, --  
	[7648]	= {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "corruption", Length = 18, }, --  
	[11671] = {UsageRank = 5, SpellRank = 5, Timer = true, Usage = "corruption", Length = 18, }, --  
	[11672] = {UsageRank = 6, SpellRank = 6, Timer = true, Usage = "corruption", Length = 18, }, --  
	[25311] = {UsageRank = 7, SpellRank = 7, Timer = true, Usage = "corruption", Length = 18, }, --  

	-- ::: Spells
	[348]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "immolate", Length = 15, }, -- Immolate 
	[707]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "immolate", Length = 15, }, --  
	[1094]	= {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "immolate", Length = 15, }, --  
	[2941]	= {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "immolate", Length = 15, }, --  
	[11665] = {UsageRank = 5, SpellRank = 5, Timer = true, Usage = "immolate", Length = 15, }, --  
	[11667] = {UsageRank = 6, SpellRank = 6, Timer = true, Usage = "immolate", Length = 15, }, --  
	[11668] = {UsageRank = 7, SpellRank = 7, Timer = true, Usage = "immolate", Length = 15, }, --  
	[25309] = {UsageRank = 8, SpellRank = 8, Timer = true, Usage = "immolate", Length = 15, }, --  
	[5782]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "fear", Length = 10, }, -- Fear 
	[6213]	= {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "fear", Length = 15, }, --  
	[6215]	= {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "fear", Length = 20, }, --  
	[18708] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "domination", Length = 15, Cooldown = 900,}, -- Fel Domination || Domination corrompue 
	[6353]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "soul_fire", Cooldown = 60,}, -- Soul Fire || Feu de l'âme 
	[17924] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "soul_fire", Cooldown = 60,}, --  
	[6789]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "death_coil", Length = 3, Cooldown = 180,}, -- Death Coil || Voile mortel 
	[17925] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "death_coil", Length = 3, Cooldown = 180,}, --  
	[17926] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "death_coil", Length = 3, Cooldown = 180,}, --  
	[17877] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "shadowburn", Cooldown = 15,}, -- Shadowburn || Brûlure de l'ombre 
	[18867] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "shadowburn", Cooldown = 15,}, --  
	[18868] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "shadowburn", Cooldown = 15,}, --  
	[18869] = {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "shadowburn", Cooldown = 15,}, --  
	[18870] = {UsageRank = 5, SpellRank = 5, Timer = true, Usage = "shadowburn", Cooldown = 15,}, --  
	[18871] = {UsageRank = 6, SpellRank = 6, Timer = true, Usage = "shadowburn", Cooldown = 15,}, --  
	[17962] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conflagration"}, -- Conflagration 
	[18930] = {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "conflagration"}, --  
	[18931] = {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "conflagration"}, --  
	[18932] = {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "conflagration"}, --  
	[18265] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "siphon_life", Length = 30, }, -- Siphon Life || Syphon de vie 
	[18879] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "siphon_life", Length = 30, }, --  
	[18880] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "siphon_life", Length = 30, }, --  
	[18881] = {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "siphon_life", Length = 30, }, --  
	[5484]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "howl", Length = 10, Cooldown = 40}, -- Howl of Terror || Hurlement de terreur 
	[17928] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "howl", Length = 15, Cooldown = 40}, --  
	[1454]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "life_tap"}, -- Life Tap || Connexion
	[1455]	= {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "life_tap"}, -- 
	[1456]	= {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "life_tap"}, -- 
	[11687] = {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "life_tap"}, -- 
	[11688] = {UsageRank = 5, SpellRank = 5, Timer = false, Usage = "life_tap"}, -- 
	[11689] = {UsageRank = 6, SpellRank = 6, Timer = false, Usage = "life_tap"}, -- 
	[7812]	= {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "sacrifice", Length = 30,  NeedPet = true, }, -- Sacrifice || Sacrifice démoniaque 
	[19438] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "sacrifice", Length = 30,  NeedPet = true,}, --  
	[19440] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "sacrifice", Length = 30,  NeedPet = true,}, --  
	[19441] = {UsageRank = 4, SpellRank = 4, Timer = true, Usage = "sacrifice", Length = 30,  NeedPet = true,}, --  
	[19442] = {UsageRank = 5, SpellRank = 5, Timer = true, Usage = "sacrifice", Length = 30,  NeedPet = true,}, --  
	[19443] = {UsageRank = 6, SpellRank = 6, Timer = true, Usage = "sacrifice", Length = 30,  NeedPet = true,}, --  
	[686]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "bolt"}, -- Shadow Bolt
	[695]	= {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "bolt"}, -- 
	[705]	= {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "bolt"}, -- 
	[1088]	= {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "bolt"}, -- 
	[1106]	= {UsageRank = 5, SpellRank = 5, Timer = false, Usage = "bolt"}, -- 
	[7641]	= {UsageRank = 6, SpellRank = 6, Timer = false, Usage = "bolt"}, -- 
	[11659] = {UsageRank = 7, SpellRank = 7, Timer = false, Usage = "bolt"}, -- 
	[11660] = {UsageRank = 8, SpellRank = 8, Timer = false, Usage = "bolt"}, -- 
	[11661] = {UsageRank = 9, SpellRank = 9, Timer = false, Usage = "bolt"}, -- 
	[25307] = {UsageRank = 10, SpellRank = 10, Timer = false, Usage = "bolt"}, -- 
	[18220] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "pact"}, -- Dark Pact || Pacte noir
	[18937] = {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "pact"}, 
	[18938] = {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "pact"}, 
	[1120] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "drain_soul", Length = 15,}, -- Ignore Improved Drain Soul (Affliction talent points)
	[8288] = {UsageRank = 2, SpellRank = 2, Timer = true, Usage = "drain_soul", Length = 15,}, 
	[8289] = {UsageRank = 3, SpellRank = 3, Timer = true, Usage = "drain_soul", Length = 15,}, 
	
	-- ::: Spells from using objects: These are spells we look for to create timers. They are not assigned to buttons.
	-- Blizzard has several ids in the DB for each, not sure which are used for Classic...
	-- However, when capturing the event, only the name will used so pick one of listed ids to get the right localized name
	
	-- Soulstone Resurrection || Résurrection de pierre d'ame
	--[[ When a soul stone is used it could be one of several spells because each gives different health and mana amounts
	The timer is on USING a soul stone, not the stone itself.  
	So use the lowest soul stone 'resurrection' spell the warlock can learn just for the timer.
	Take advantage that the various 'resurrection' spells share the same localized name AND the same cool down time. 
	From the id, WoW knows the health and mana to give if the soul stone is used.
	Note: WoW will only allow one soul stone at a time so we do not have to worry about multiple stones...
	--]] 
	[20707] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "minor_ss_used", Result = true, Cooldown = 1800, Group = 1, }, -- ss_rez
	[20762] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "lesser_ss_used", Result = true, Cooldown = 1800, Group = 1, }, -- 
	[20763] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "ss_used", Result = true, Cooldown = 1800, Group = 1, }, -- 
	[20764] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "greater_ss_used", Result = true, Cooldown = 1800, Group = 1, }, -- 
	[20765] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "major_ss_used", Result = true, Cooldown = 1800, Group = 1, }, -- 

	-- Health stone
	-- When a health stone is used it could be one of several spells because each gives different health amounts
	[6262] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "minor_hs_used", Result = true, Cooldown = 120, Group = 2, }, -- minor 120
	[6263] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "lesser_hs_used", Result = true, Cooldown = 120, Group = 2, }, -- lesser 250
	[5720] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "hs_used", Result = true, Cooldown = 120, Group = 2, }, -- 500
	[5723] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "greater_hs_used", Result = true, Cooldown = 120, Group = 2, }, -- greater 800
	[11732] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "major_hs_used", Result = true, Cooldown = 120, Group = 2, }, -- major 1200
	}

--[[ Warlock_Buttons
Frames for the various buttons created and used.
Does NOT include timers and config!

Fields
- index is the same string used for Usage in Warlock_Spells.
- f: is the frame name to use. The intent is isolate frame names from usage (such as ...Menu1 through ...Menu9).
- tip: the string reference to the tool tip table.
- menu: The menu 'name', exists only if the frame is used as a menu of buttons.
- anchor: where to anchor the tool tip frame relative to the button.
- norm / high / push: holds the textures to use when creating the frame.

Note: Button name - as a string - are in:
- Initialize.lua to prevent a catch-22 to reference them
- Necrosis.lua config / saved variables for proper referencing
- in config /XML routines as part of anonymous functions

The intention is to use the index to reference the frames rather than coding indexes into the names.
This allows a more flexible scheme and should reduce maintenance and impact if WoW Classic changes over time.
--]]
Necrosis.Warlock_Buttons = {
	timer 		= {f = "NecrosisSpellTimerButton", tip = "SpellTimer", menu = "Timer", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Normal",
					high = "Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Highlight",
					push = "Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Pushed",
					}, --
	main 		= {f = "NecrosisButton", tip = "Main", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Shard",
					}, --

	fire_stone 	= {f = "NecrosisFirestoneButton", tip = "Firestone", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\FirestoneButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\FirestoneButton-03",
					}, --
	spell_stone = {f = "NecrosisSpellstoneButton", tip = "Spellstone", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\SpellstoneButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\SpellstoneButton-03",
					}, --
	health_stone= {f = "NecrosisHealthstoneButton", tip = "Healthstone", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\HealthstoneButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\HealthstoneButton-03",
					}, --
	hearth_stone= {f = "NecrosisHearthstoneButton", tip = "Hearthstone", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\INV_Misc_Rune_01",
					high = "Interface\\AddOns\\Necrosis\\UI\\INV_Misc_Rune_01",
					}, --
	soul_stone 	= {f = "NecrosisSoulstoneButton", tip = "Soulstone", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\SoulstoneButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\SoulstoneButton-04",
					}, --
	mounts 		= {f = "NecrosisMountButton", anchor = "ANCHOR_LEFT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\MountButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\MountButton-02",
					}, --

	buffs 		= {f = "NecrosisBuffMenuButton", tip = "BuffMenu", menu = "Buff",
					norm = "Interface\\AddOns\\Necrosis\\UI\\BuffMenuButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\BuffMenuButton-02",
					}, --
	pets 		= {f = "NecrosisPetMenuButton", tip = "PetMenu", menu = "Pet",
					norm = "Interface\\AddOns\\Necrosis\\UI\\PetMenuButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\PetMenuButton-02",
					}, --
	curses 		= {f = "NecrosisCurseMenuButton", tip = "CurseMenu", menu = "Curse",
					norm = "Interface\\AddOns\\Necrosis\\UI\\CurseMenuButton-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\CurseMenuButton-02",
					}, --

	armor 		= {f = "NecrosisBuffMenu01", tip = "Armor", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Armor-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Armor-02",
					}, --
	breath 		= {f = "NecrosisBuffMenu02", tip = "Aqua", anchor = "ANCHOR_RIGHT", can_target = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\Aqua-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Aqua-02",
					}, --
	invis 		= {f = "NecrosisBuffMenu03", tip = "Invisible", anchor = "ANCHOR_RIGHT", can_target = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\Invisible-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Invisible-02",
					}, --
	eye 		= {f = "NecrosisBuffMenu04", tip = "Kilrogg", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Kilrogg-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Kilrogg-02",
					}, --
	summoning 	= {f = "NecrosisBuffMenu05", tip = "TP", anchor = "ANCHOR_RIGHT", can_target = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\TP-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\TP-02",
					}, --
	link 		= {f = "NecrosisBuffMenu06", tip = "SoulLink", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\SoulLink-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\SoulLink-02",
					}, --
	ward 		= {f = "NecrosisBuffMenu07", tip = "ShadowProtection", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\ShadowProtection-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\ShadowProtection-02",
					}, --
	renforcement= {f = "NecrosisBuffMenu08", tip = "Renforcement", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Renforcement-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Renforcement-02",
					}, --
	banish 		= {f = "NecrosisBuffMenu09", tip = "Banish", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Banish-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Banish-02",
					}, --

	domination 	= {f = "NecrosisPetMenu01", tip = "Domination", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Domination-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Domination-02",
					}, --
	imp 		= {f = "NecrosisPetMenu02", tip = "Imp", anchor = "ANCHOR_RIGHT", pet = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\Imp-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Imp-02",
					}, --
	voidwalker 	= {f = "NecrosisPetMenu03", tip = "Voidwalker", anchor = "ANCHOR_RIGHT", pet = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\Voidwalker-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Voidwalker-02",
					}, --
	succubus 	= {f = "NecrosisPetMenu04", tip = "Succubus", anchor = "ANCHOR_RIGHT", pet = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\Succubus-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Succubus-02",
					}, --
	felhunter 	= {f = "NecrosisPetMenu05", tip = "Felhunter", anchor = "ANCHOR_RIGHT", pet = true,
					norm = "Interface\\AddOns\\Necrosis\\UI\\Felhunter-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Felhunter-02",
					}, --
	inferno 	= {f = "NecrosisPetMenu06", tip = "Infernal", anchor = "ANCHOR_RIGHT", 
					norm = "Interface\\AddOns\\Necrosis\\UI\\Infernal-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Infernal-02",
					}, --
	rit_of_doom	= {f = "NecrosisPetMenu07", tip = "Doomguard", anchor = "ANCHOR_RIGHT", 
					norm = "Interface\\AddOns\\Necrosis\\UI\\Doomguard-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Doomguard-02",
					}, --
	enslave 	= {f = "NecrosisPetMenu08", tip = "Enslave", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Enslave-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Enslave-02",
					}, --
	sacrifice 	= {f = "NecrosisPetMenu09", tip = "Sacrifice", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Sacrifice-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Sacrifice-02",
					}, --

	weakness 	= {f = "NecrosisCurseMenu01", tip = "Weakness", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Weakness-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Weakness-02",
					}, --
	agony 		= {f = "NecrosisCurseMenu02", tip = "Agony", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Agony-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Agony-02",
					}, --
	tongues 	= {f = "NecrosisCurseMenu03", tip = "Tongues", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Tongues-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Tongues-02",
					}, --
	exhaustion 	= {f = "NecrosisCurseMenu04", tip = "Exhaust", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Exhaust-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Exhaust-02",
					}, --
	elements 	= {f = "NecrosisCurseMenu05", tip = "Elements", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Elements-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Elements-02",
					}, --
	doom 		= {f = "NecrosisCurseMenu06", tip = "Doom", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Doom-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Doom-02",
					}, --
	corruption 	= {f = "NecrosisCurseMenu07", tip = "Corruption", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Corruption-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Corruption-02",
					}, --
	recklessness= {f = "NecrosisCurseMenu08", tip = "Reckless", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Reckless-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Reckless-02",
					}, --
	shadow		= {f = "NecrosisCurseMenu09", tip = "Shadow", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Shadow-01",
					high = "Interface\\AddOns\\Necrosis\\UI\\Shadow-02",
					}, --

	trance 		= {f = "NecrosisShadowTranceButton", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\ShadowTrance-Icon",
					pos = {"CENTER", "UIParent", "CENTER", 20, 0},}, --
	backlash 	= {f = "NecrosisBacklashButton", anchor = "ANCHOR_RIGHT",
					norm = "Interface\\AddOns\\Necrosis\\UI\\Backlash-Icon",
					pos = {"CENTER", "UIParent", "CENTER", 60, 0},}, --
	elemental 	= {f = "NecrosisCreatureAlertButton",
					norm = "Interface\\AddOns\\Necrosis\\UI\\ElemAlert",
					pos = {"CENTER", "UIParent", "CENTER", -60, 0},}, --
	anti_fear 	= {f = "NecrosisAntiFearButton",
					norm = "Interface\\AddOns\\Necrosis\\UI\\AntiFear-01",
					pos = {"CENTER", "UIParent", "CENTER", -20, 0},}, --
}

--[=[
This table contains various lists, some that need to ordered.
We could have created the Necrosis buttons via tables IF the buttons had similar actions and structure.
It seemed better to collect the various lists in one place for ease of change.

: Button lists : on_sphere | buffs | curses | pets
- index is numeric and specifies the order frames should be in.
- f_ptr: The frame to use (index to Warlock_Buttons)
- high_of: Use the highest of the referenced spell(s). Same values as Usage in Warlock_Spells.

--]=]
Necrosis.Warlock_Lists = {
	["on_sphere"] = {
		[1] = {f_ptr = "fire_stone", high_of = "firestone",},
		[2] = {f_ptr = "spell_stone", high_of = "spellstone",},
		[3] = {f_ptr = "health_stone", high_of = "healthstone",},
		[4] = {f_ptr = "soul_stone", high_of = "soulstone",},
		[5] = {f_ptr = "buffs",	menu = "buffs", },
		[6] = {f_ptr = "mounts", high_of = "mount",},
		[7] = {f_ptr = "pets", menu = "pets", },
		[8] = {f_ptr = "curses", menu = "curses", },
--		[9] = {f_ptr = "hearth_stone", item = "Hearthstone",},
	},
-- 31=Demon Armor | 47=Fel Armor | 32=Unending Breath | 33=Detect Invis | 34=Eye of Kilrogg | 37=Ritual of Summoning | 38=Soul Link | 43=Shadow Ward | 35=Enslave Demon | 59=Demonic Empowerment | 9=Banish
--	local buffID = {31, 47, 32, 33, 34, 37, 38, 43, 59, 9}
	["buffs"] = {
		[1] = {f_ptr = "armor", high_of = "armor", },
		[2] = {f_ptr = "breath", high_of = "breath", },
		[3] = {f_ptr = "invis", high_of = "invisible", },
		[4] = {f_ptr = "eye", high_of = "eye", },
		[5] = {f_ptr = "summoning", high_of = "summoning", },
		[6] = {f_ptr = "link", high_of = "link", },
		[7] = {f_ptr = "ward", high_of = "ward", },
		[8] = {f_ptr = "banish", high_of = "banish", },
	},
-- 			15, 3, 4, 5, 6, 8, 30, 35, 44, 59
	["pets"] = { -- 2 types: summon pet and (buff or temporary) pet
		[1] = {f_ptr = "domination", high_of = "domination",},
		[2] = {f_ptr = "imp", high_of = "imp", s_type = "summon", },
		[3] = {f_ptr = "voidwalker", high_of = "voidwalker", },
		[4] = {f_ptr = "succubus", high_of = "succubus", },
		[5] = {f_ptr = "felhunter", high_of = "felhunter", },
		[6] = {f_ptr = "inferno", high_of = "inferno", },
		[7] = {f_ptr = "rit_of_doom", high_of = "rit_of_doom", },
		[8] = {f_ptr = "enslave", high_of = "enslave", },
		[9] = {f_ptr = "sacrifice", high_of = "sacrifice", },
	},
-- 23, -- Curse of weakness 22, -- Curse of agony 25, -- Curse of tongues 40, -- Curse of exhaustion 26, -- Curse of the elements 16, -- Curse of doom 14 -- Corruption
	["curses"] = {
		[1] = {f_ptr = "weakness", high_of = "weakness", },
		[2] = {f_ptr = "agony", high_of = "agony", },
		[3] = {f_ptr = "tongues", high_of = "tongues", },
		[4] = {f_ptr = "exhaustion", high_of = "exhaustion", },
		[5] = {f_ptr = "elements", high_of = "elements", },
		[6] = {f_ptr = "doom", high_of = "doom", },
		[7] = {f_ptr = "corruption", high_of = "corruption", },
		[8] = {f_ptr = "recklessness", high_of = "recklessness", },
--		[9] = {f_ptr = "shadow", high_of = "shadow", },
	},
	-- {19, 31, 37, 41, 43, 44, 55} See GetMainSpellList
	["config_main_spell"] = {
		[1] = {high_of = "death_coil", },
		[2] = {high_of = "armor", },
		[3] = {high_of = "summoning", },
		[4] = {high_of = "life_tap", },
		[5] = {high_of = "ward", },
		[6] = {high_of = "sacrifice", },
		[7] = {high_of = "pact", },
		[8] = {high_of = "banish", },
	},
	-- Only using ids for comparison. Dialog contains localized strings
	["reagents"] = {
		soul_shard			= {id = 6265, count = 0, }, --
		infernal_stone		= {id = 5565, count = 0, }, -- 
		demonic_figurine	= {id = 16583, count = 0, }, --
	},
	["soul_bags"] = {
		soul_pouch			= {id = 21340, }, --
		small_soul_pouch	= {id = 22243, }, -- 
		box_of_souls		= {id = 22244, }, --
		felcloth_bag		= {id = 21341, }, --
	},
	["health_stones"] = { -- these have multiple possible ids, not sure which are used...
		minor_hs_1			= {id = 5511, }, --
		minor_hs_2			= {id = 19004, }, --
		minor_hs_3			= {id = 19005, }, --
		lesser_hs_1			= {id = 5512, }, -- 
		lesser_hs_2			= {id = 19006, }, -- 
		lesser_hs_3			= {id = 19007, }, -- 
		hs_1				= {id = 5509, }, --
		hs_2				= {id = 19008, }, --
		hs_3				= {id = 19009, }, --
		greater_hs_1		= {id = 5510, }, --
		greater_hs_2		= {id = 19010, }, --
		greater_hs_3		= {id = 19011, }, --
		major_hs_1			= {id = 9421, }, --
		major_hs_2			= {id = 19012, }, --
		major_hs_3			= {id = 19013, }, --
	},
	["soul_stones"] = {
		minor_hs			= {id = 5232, }, --
		lesser_hs			= {id = 16892, }, -- 
		hs					= {id = 16893, }, --
		greater_hs			= {id = 16895, }, --
		major_hs			= {id = 16896, }, --
	},
	["spell_stones"] = {
		spell				= {id = 5522, }, --
		greater_spell		= {id = 13602, }, --
		major_spell			= {id = 13603, }, --
	},
	["fire_stones"] = {
		lesser_fire			= {id = 1254, }, -- 
		fire				= {id = 13699, }, --
		greater_fire		= {id = 13700, }, --
		major_fire			= {id = 13701, }, --
	},
	["auras"] = { -- buffs and debuffs
		fear_ward			= {id = 19337, }, -- Dwarf priest racial trait
		forsaken			= {id = 7744, }, -- Forsaken racial trait
		fearless			= {id = 12733, }, -- Trinket
		berserk				= {id = 18499, }, -- Warrior Fury talent
		reckless			= {id = 1719, }, -- Warrior Fury talent
		wish				= {id = 12328, }, -- Warrior Fury talent
		wrath				= {id = 19574, }, -- Hunter Beast Mastery talent
		ice					= {id = 11958, }, -- Mage Ice talent
		protect				= {id = 498, }, -- Paladin Holy buff
		shield				= {id = 642, }, -- Paladin Holy buff
		tremor				= {id = 8143, }, -- Shaman totem
		abolish				= {id = 776, }, -- Majordomo (NPC) spell
		recklessness		= {id = 704, }, -- Warlock spell grants anti-fear
	},
	["recall"] = {
		main				= {f_ptr = "main", x = 0, y = -100, show = true,}, -- 
		timer				= {f_ptr = "timer", x = 0, y = 100, show = true,}, -- 
		anti_fear			= {f_ptr = "anti_fear", x = 20, y = 0,}, -- 
		elemental			= {f_ptr = "elemental", x = 60, y = 0,}, -- 
		backlash			= {f_ptr = "backlash", x = -60, y = 0,}, -- 
		trance				= {f_ptr = "trance", x = -20, y = 0,}, -- 
	},
}

-- helper routines for config screens
--[[
This fills the drop down in config to set the main spell to use on the sphere. 
Only known spells will be selectable. Unknown spells will be shown as gray and not selectable.
--]]
function Necrosis.GetMainSpellList()
	local main_spell =  {} -- {19, 31, 37, 41, 43, 44, 55}

	for i = 1, #Necrosis.Warlock_Lists.config_main_spell, 1 do -- build as needed
		main_spell[i] = Necrosis.Warlock_Lists.config_main_spell[i].high_of
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis:GetMainSpellList"
.." i'"..(tostring(i) or "nyl")..'"'
.." u'"..(tostring(Necrosis.Warlock_Lists.config_main_spell[i].high_of) or "nyl")..'"'
)
--]]
	end

	return main_spell
end

--[[
This updates a spell timer value AND the user config.
--]]
function Necrosis.UpdateSpellTimer(index, show)
	NecrosisConfig.Timers[index].show = show

	for i, v in pairs(Necrosis.Warlock_Spells) do
		if Necrosis.Warlock_Spells[i].Usage == NecrosisConfig.Timers[index].usage then
			local t = Necrosis.Warlock_Spells[i].Timer
			Necrosis.Warlock_Spells[i].Timer = show
			end
	end
end

--[[
This updates the spell timer value based on the user selection list from options.
--]]
function Necrosis.UpdateSpellTimers(list)
	for j = 1, #list, 1 do 
		for i, v in pairs(Necrosis.Warlock_Spells) do
			if Necrosis.Warlock_Spells[i].Usage == list[j].usage then
				local t = Necrosis.Warlock_Spells[i].Timer
				Necrosis.Warlock_Spells[i].Timer = list[j].show
			end
		end
	end
end

-- helper routines to get spell info / determine if a spell is usable
function Necrosis.IsSpellKnown(usage)
	if Necrosis.Warlock_Spell_Use[usage] -- get spell id
	then
		return 
			Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].InSpellBook
	else
		return false -- safety
	end
end

function Necrosis.IsSpellKnownId(id)
	if Necrosis.Warlock_Spells[id] -- get spell id
	then
		return 
			Necrosis.Warlock_Spells[id].InSpellBook or false
	else
		return false -- safety
	end
end

function Necrosis.GetSpellByName(name)
	local s_id = nil
	local s_usage = ""
	local s_timer = false
	for i, v in pairs(Necrosis.Warlock_Spells) do
		if Necrosis.Warlock_Spells[i].Name == name then
			s_id = Necrosis.Warlock_Spell_Use[Necrosis.Warlock_Spells[i].Usage] -- spell determined by spell setup
			s_usage = Necrosis.Warlock_Spells[i].Usage
			s_timer = (Necrosis.Warlock_Spells[i].Timer) -- if has timer
			s_buff = (Necrosis.Warlock_Spells[i].Buff and true or false)
			s_cool = (Necrosis.Warlock_Spells[i].Buff and true or false)
			break
		end
	end
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis.GetSpellByName"
.." n'"..(tostring(name) or "nyl")..'"'
.." i'"..(tostring(s_id) or "nyl")..'"'
.." u'"..(tostring(s_usage) or "nyl")..'"'
.." t'"..(tostring(s_timer) or "nyl")..'"'
)
--]]
	return s_id, s_usage, s_timer, s_buff, s_cool
end

function Necrosis.GetSpellMana(usage)
	if Necrosis.Warlock_Spell_Use[usage] -- 
	then
		return 
			Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].Mana
	else
		return ""
	end
end

function Necrosis.GetSpellRank(usage)
	if Necrosis.Warlock_Spell_Use[usage] -- 
	then
		return 
			Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].SpellRank
	else
		return ""
	end
end

function Necrosis.GetSpellName(usage)
	if Necrosis.Warlock_Spell_Use[usage] -- 
	then
		return 
			Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].Name
	else
		return ""
	end
end

function Necrosis.GetSpell(usage) -- return the Warlock_Spells table (pointer)
	if Necrosis.Warlock_Spell_Use[usage] -- 
	then
		return 
			Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]]
	else
		return nil
	end
end

function Necrosis.GetSpellById(id) -- return the Warlock_Spells table (pointer)
	return Necrosis.Warlock_Spells[id] or nil
end

function Necrosis.GetSpellCastName(usage)
	if Necrosis.Warlock_Spell_Use[usage] -- 
	then
		return 
			Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].CastName
	else
		return ""
	end
end

function Necrosis.GetDemonSpeechIdByName(name)
	local id, usage, timer = Necrosis.GetSpellByName(name)
	local res = ""

	res = NecrosisConfig.PetInfo[usage] or ""

--[[
	if Necrosis.IsSpellDemon(name) -- safety...
	then
		if usage == "imp" then res = 1 
		elseif usage == "voidwalker" then res = 2 
		elseif usage == "succubus" then res = 3 
		elseif usage == "felhunter" then res = 4 
		else -- should never happen...
		end
	else
		-- should never happen...
	end
--]]
	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("GetDemonSpeechIdByName"
		.." n'"..(tostring(name)).."'"
		.." u'"..(tostring(usage)).."'"
		.." r'"..(tostring(res)).."'"
		)
	end
	return res
end

-- helper routines to determine if a spell is within a list
function Necrosis.IsSpellDemon(name)
	if name == Necrosis.GetSpellName("imp") -- 3 
	or name == Necrosis.GetSpellName("voidwalker") -- 4 
	or name == Necrosis.GetSpellName("succubus") -- 5 
	or name == Necrosis.GetSpellName("felhunter") -- 6 
	then
		return true
	else
		return false
	end
end

function Necrosis.IsSpellRez(name)
	if name == (Necrosis.Warlock_Spell_Use["minor_ss_used"] and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["minor_ss_used"]].Name or "")
	or name == (Necrosis.Warlock_Spell_Use["lesser_ss_used"] and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["lesser_ss_used"]].Name or "")
	or name == (Necrosis.Warlock_Spell_Use["ss_used"] and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["ss_used"]].Name or "")
	or name == (Necrosis.Warlock_Spell_Use["greater_ss_used"] and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["greater_ss_used"]].Name or "")
	or name == (Necrosis.Warlock_Spell_Use["major_ss_used"] and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["major_ss_used"]].Name or "")
	then
		return true
	else
		return false
	end
end

function Necrosis.IsSpellMount(name)
	if name == Necrosis.Warlock_Spells[5784].Name
	or name == Necrosis.Warlock_Spells[23161].Name
	then
		return true
	else
		return false
	end
end

function Necrosis.UpdatePouches()
	-- Fill pouch data with WoW localized names from Dialog over hard-coded localized names
	for i, v in pairs (Necrosis.Warlock_Lists.soul_bags) do
		Necrosis.Warlock_Lists.soul_bags[i].name = Necrosis.GetItem(i)
		if Necrosis.Debug.init_path then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("UpdatePouches"
			.." n'"..(Necrosis.Warlock_Lists.soul_bags[i].name or "nyl")..'"'
			)
		end
	end
end

function Necrosis.IsSoulPouch(name)
	local res = false -- assume not
	for i, v in pairs (Necrosis.Warlock_Lists.soul_bags) do
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("IsSoulPouch"
.." i'"..(v.id or "nyl")..'"'
.." n'"..(v.name or "nyl")..'"'
.." n'"..(name or "nyl")..'"'
)
--]]
		if name == v.name then
			res = true
			break
		else
			-- nothing
		end
	end
	
	return res
end

function Necrosis.IsHealthStone(id)
	local res = false -- assume not
	for i, v in pairs (Necrosis.Warlock_Lists.health_stones) do
		if id == v.id then
			res = true
			break
		else
			-- nothing
		end
	end
	
	return res
end

function Necrosis.IsSoulStone(id)
	local res = false -- assume not
	for i, v in pairs (Necrosis.Warlock_Lists.soul_stones) do
		if id == v.id then
			res = true
			break
		else
			-- nothing
		end
	end
	
	return res
end

function Necrosis.IsFireStone(id)
	local res = false -- assume not
	for i, v in pairs (Necrosis.Warlock_Lists.fire_stones) do
		if id == v.id then
			res = true
			break
		else
			-- nothing
		end
	end
	
	return res
end

function Necrosis.IsSpellStone(id)
	local res = false -- assume not
	for i, v in pairs (Necrosis.Warlock_Lists.spell_stones) do
		if id == v.id then
			res = true
			break
		else
			-- nothing
		end
	end
	
	return res
end

function Necrosis.IsHearthStone(id)
	if (id == 6948) then
		return true
	else
		return false
	end
end

--[[
Create a cast name to use on buttons.
There are two types of names - those with {} and those without. 
The ones with, such as create stones, include the 'rank'.
--]]
local function CreateNames(spell, rank)
	local cast = ""
	local name = ""
	local s = spell
	local r = rank or ""
	if string.find(s, "%(") then -- literal paren
		-- make the names match across the 'ranks' for spells that have () in the name
		s = string.match(s, "(.+)%(")           -- grab everything up to the "("
--		s,r = string.match(s, "(.+)(%(.*%))")   -- grab everything up to the "(" & from ( to )
		s = string.gsub(s, "^s*(.-)%s*$", "%1") -- trim white space on either side
		cast = spell -- ok for cast by name
		name = s -- stripped for the lookups
	else
		if r == "" then -- safety
			cast = s
		else
			cast = s.."("..r..")"
		end
		name = spell -- unchanged for the lookups
	end
	return name, cast -- should now be the full spell to cast!
end

local function getManaCost(spellID) -- assume only the first mana cost found is needed for now
    if not spellID then return end
	local cost = 0
	local costTable = GetSpellPowerCost(spellID);
	if costTable == nil then
		return false
	end
	return table.foreach(costTable, function(k,v)  
		if v.name  == "MANA" then
			return v.cost;
		end 
	end )

end

-- My favourite feature! Create a list of spells known by the warlock sorted by name & rank || Ma fonction préférée ! Elle fait la liste des sorts connus par le démo, et les classe par rang.
-- Select the highest available spell in the case of stones. || Pour les pierres, elle sélectionne le plus haut rang connu
function Necrosis:SpellSetup(reason)
--    print("SpellSetup")
	Necrosis.Warlock_Spell_Use = {}

	local spellID = 1
	local Invisible = 0
	local InvisibleID = 0
	-- local totalSpellTabs = GetNumSpellTabs();

	if Necrosis.Debug.spells_init then
		DEFAULT_CHAT_FRAME:AddMessage(""
		.."::: SpellSetup :::"
		.." "..tostring(reason or "nyl")
		)
	end

	-- helper routine to fill Warlock_Spell_Use fields
	-- we need access to the local variables in SpellSetup
	local function Update(id, sub_name, spell)
		str = ""
		
		-- update usage rank, if needed
		local str1 = "exists"
		if not Necrosis.Warlock_Spell_Use[self.Warlock_Spells[id].Usage] then
			Necrosis.Warlock_Spell_Use[self.Warlock_Spells[id].Usage] = id
			str1 = "new"
		else
			if self.Warlock_Spells[id].UsageRank 
				> self.Warlock_Spells[Necrosis.Warlock_Spell_Use[self.Warlock_Spells[id].Usage]].UsageRank then
				Necrosis.Warlock_Spell_Use[self.Warlock_Spells[id].Usage] = id
				str1 = "update"
			else
				-- nothing to do
			end
		end
		if Necrosis.Debug.spells_init then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage(">> rank "..str1
			.." '"..id.."'"
			.." N:'"..self.Warlock_Spells[id].Name.."'"
			.." r:'"..self.Warlock_Spells[id].SpellRank.."'"
			.." u:'"..self.Warlock_Spells[id].Usage.."'"
			)
		end
	end

	--[=[ Step 1
	Go through the warlock spells we are interested: add the localized name, rank, and mana cost
	--]=]
--	Necrosis:CreateSpellList()
	for id, v in pairs(Necrosis.Warlock_Spells) do
		local spell_name = GetSpellInfo(id) -- localized, rank is BROKEN (always nil)
		if Necrosis.Debug.spells_init then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SpellSetup "
			.." i"..tostring(id).."'"
			.." s'"..(tostring(spell_name) or "nyl").."'"
			--.." n'"..(tostring(spell_name) or "nyl").."'"
			)
		end
		Necrosis.Warlock_Spells[id].Name = spell_name
		Necrosis.Warlock_Spells[id].ID = id -- redundant to the 'id' but allows the spell to be self contained if returned as a table

		-- Add the name by usage even if the warlock does not know the spell. 
		-- Use the 'lowest' usage. Will be updated to highest if known by warlock
		local usage = Necrosis.Warlock_Spells[id].Usage
		if Necrosis.Warlock_Spell_Use[usage] then
			if Necrosis.Warlock_Spells[id].UsageRank 
			< Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].UsageRank then
				Necrosis.Warlock_Spell_Use[usage] = id
			else
			end
		else
			Necrosis.Warlock_Spell_Use[usage] = id
		end
		
--		local start, duration, enabled = GetSpellCooldown(id)
		-- For timers, the API appears to return 'valid' values once cast
--		Necrosis.Warlock_Spells[id].Length = 0 -- For timers, although the API appears to return values once cast
		
		local cost = getManaCost(id) or 0 -- populate the warlock spells we are interested in
		Necrosis.Warlock_Spells[id].Mana = cost
		
		Necrosis.Warlock_Spells[id].InSpellBook = false -- later routine will fill this
		
		if Necrosis.Warlock_Spells[id].Result then
			-- This spell is the result of another spell and will NOT be in spell book
			Update(id, Necrosis.Warlock_Spells[id].SpellRank, Necrosis.Warlock_Spells[id].Name)
		end
	end
	if Necrosis.Debug.spells_init then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(">> Search Spell Book")
	end

	--[=[ Step 2
	Go through the spell book for spells we are interested: 
	- add to temp array; set 'in spell book'
	--]=]
	local str = ""
	-- Search through the spell book (abilities)
	for i = 1, MAX_SKILLLINE_TABS do
	   local name, texture, offset, numSpells = GetSpellTabInfo(i);

		if name then -- tab exists
			for s = offset + 1, offset + numSpells do
				local spell, sub_name, id = GetSpellBookItemName(s, BOOKTYPE_SPELL)
				-- spell and sub_name / rank are localized

				if self.Warlock_Spells[id] then -- a warlock spell we care about
					local n, c  = CreateNames(spell, sub_name)
					self.Warlock_Spells[id].CastName = c
					spell = n
					if Necrosis.Debug.spells_init then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(tostring(name)..":"
						.." id "..tostring(id)..""
						.." s'"..(spell or "nyl").."'"
						.." r'"..(sub_name or "nyl").."'"
						.." m'"..tostring(self.Warlock_Spells[id].Mana).."'"
						--.." off'"..tostring(s).."'"
						.."' c'"..tostring(self.Warlock_Spells[id].CastName)
						.."' n'"..tostring(self.Warlock_Spells[id].Name)
						--.."' u'"..tostring(self.Warlock_Spells[id].Usage)
						)
					end

					if sub_name == nil then
						sub_name = "" -- ensure not nil for later checks
					end

					self.Warlock_Spells[id].Name = spell -- localized name without rank
					self.Warlock_Spells[id].InSpellBook = true
					self.Warlock_Spells[id].Rank = sub_name -- localized
					
					Update(id, sub_name, spell)
					
				end

			end
		else
			-- No tab found
		end
	end

	if Necrosis.Debug.spells_init then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(">> Other localized strings")
	end
	--[=[ Step 3
	Fill other items that we can get localized names for.
	--]=]
	for i,v in pairs(Necrosis.Warlock_Lists.reagents) do
		v.name = GetItemInfo(v.id) -- just the name
	end

	if Necrosis.Debug.spells_init then
		DEFAULT_CHAT_FRAME:AddMessage(""
		.."::: SpellSetup ::: end"
		)
	end
end

--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("IsHearthStone"
.." i'"..(tostring(id) or "nyl").."'"
)
--]]
