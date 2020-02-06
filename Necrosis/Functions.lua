--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

------------------------------------------------
-- ENGLISH  VERSION FUNCTIONS --
------------------------------------------------
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

-- Types d'unité des PnJ utilisés par Necrosis
Necrosis.Unit = {
	["Undead"] = L["UNDEAD"],
	["Demon"] = L["DEMON"],
	["Elemental"] = L["ELEMENTAL"],
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = L["BACKLASH"],   -- https://classicdb.ch/?spell=4947 not sure this right one
	["ShadowTrance"] = L["SHADOW_TRANCE"] -- https://classicdb.ch/?spell=17941 (6) Apply Aura #108: Add % Modifier (10)
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = L["IMP"],
	[2] = L["VOIDWALKER"],
	[3] = L["SUCCUBUS"],
	[4] = L["FELHUNTER"],
	[5] = L["FELGUARD"],
	[6] = L["INFERNAL"],
	[7] = L["DOOMGUARD"],
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = L["SOUL_SHARD"], -- https://classicdb.ch/?item=6265
	["Soulstone"] = L["SOUL_STONE"], -- below
	["Healthstone"] = L["HEALTH_STONE"],
	["Spellstone"] = L["SPELL_STONE"],
	["Firestone"] = L["FIRE_STONE"],
	["InfernalStone"] = L["INFERNAL_STONE"],
	["DemoniacStone"] = L["DEMONIAC_STONE"],
	["Hearthstone"] = L["HEARTH_STONE"], -- https://classicdb.ch/?item=6948
--[[
	["SoulPouch"] = {L["BAG_SOUL_POUCH"], -- https://classicdb.ch/?item=21340
		L["BAG_SMALL_SOUL_POUCH"],  -- https://classicdb.ch/?item=22243
		L["BAG_BOX_OF_SOULS"], -- https://classicdb.ch/?item=22244
		L["BAG_FELCLOTH_BAG"], -- https://classicdb.ch/?item=21341   Last Classic bag
		L["BAG_EBON_SHADOW_BAG"], --
		L["BAG_CORE_FELCLOTH_BAG"], -- https://classicdb.ch/?item=21342
		L["BAG_ABYSSAL_BAG"], -- 
		}
--]]
}
Necrosis.Translation.SoulPouch = { -- holds localized names
	[1] = {id = 21340, name = ""}, -- https://classicdb.ch/?item=21340 BAG_SOUL_POUCH
	[2] = {id = 22243, name = ""},  -- https://classicdb.ch/?item=22243 BAG_SMALL_SOUL_POUCH
	[3] = {id = 22244, name = ""}, -- https://classicdb.ch/?item=22244 BAG_BOX_OF_SOULS
	[4] = {id = 21341, name = ""}, -- https://classicdb.ch/?item=21341 BAG_FELCLOTH_BAG  Last Classic bag
--	L["BAG_EBON_SHADOW_BAG"], --
--	L["BAG_CORE_FELCLOTH_BAG"], -- https://classicdb.ch/?item=21342
--	L["BAG_ABYSSAL_BAG"], -- 
}

--[[
Minor Healthstone https://classicdb.ch/?item=19004 : create https://classicdb.ch/?spell=23518
https://classicdb.ch/?item=19004 https://classicdb.ch/?item=19005 ??
Lesser Healthstone https://classicdb.ch/?item=5511 : https://classic.wowhead.com/spell=6202/create-healthstone-lesser   
https://classic.wowhead.com/item=19007/lesser-healthstone ??
Healthstone https://classicdb.ch/?item=5509 https://classicdb.ch/?item=19008 https://classicdb.ch/?item=19009 
Greater https://classicdb.ch/?item=5510 https://classicdb.ch/?item=19010 https://classicdb.ch/?item=19011
Major https://classicdb.ch/?item=9421 https://classicdb.ch/?item=19012 https://classicdb.ch/?item=19011

Spell Stone https://classicdb.ch/?item=5522
Major https://classicdb.ch/?item=13603
Greater https://classicdb.ch/?item=13602

Lesser http://classicdb.ch/?item=1254 :: https://classicdb.ch/?spell=6366
Firestone https://classicdb.ch/?item=13699 :: https://classicdb.ch/?spell=17951
Greater https://classicdb.ch/?item=13700 :: https://classicdb.ch/?spell=17952
Major http://classicdb.ch/?item=13701 :: https://classicdb.ch/?spell=17953

Infernal https://classicdb.ch/?item=5565 

--]]
--[[
-- IG stones ranks || Traduction du nom des rang de pierres
-- there is a fifth one but without 'name' (some bug may lie here)
Necrosis.Translation.StoneRank = {
	["Minor"] = L["MINOR"],
	["Major"] = L["MAJOR"],
	["Lesser"] = L["LESSER"],
	["Greater"] = L["GREATER"],
}
Necrosis.Translation.Soulstones = { -- new
	["Minor"] = L["MINOR"], -- /script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:5232:0:0:0:0:0:0:0:0\124h[Minor Soulstone]\124h\124r")
	["Major"] = L["MAJOR"], -- /script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:16896:0:0:0:0:0:0:0:0\124h[Major Soulstone]\124h\124r")
	["Lesser"] = L["LESSER"], -- /script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:16892:0:0:0:0:0:0:0:0\124h[Lesser Soulstone]\124h\124r")
	["Greater"] = L["GREATER"], -- /script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:16895:0:0:0:0:0:0:0:0\124h[Greater Soulstone]\124h\124r")
-- /script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:16893:0:0:0:0:0:0:0:0\124h[Soulstone]\124h\124r");
}
--]]
-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = L["COOLDOWN"],
	["Rank"] = L["RANK"],
	["Create"] = L["CREATE"],
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Buffs giving temporary immunity to fear effects
	["Buff"] = {
		L["ANTI_FEAR_BUFF_FEAR_WARD"],	-- Dwarf priest racial trait
		L["ANTI_FEAR_BUFF_FORSAKEN"],	-- Forsaken racial trait
		L["ANTI_FEAR_BUFF_FEARLESS"],	-- Trinket
		L["ANTI_FEAR_BUFF_BERSERK"],	-- Warrior Fury talent
		L["ANTI_FEAR_BUFF_RECKLESS"],	-- Warrior Fury talent
		L["ANTI_FEAR_BUFF_WISH"],		-- Warrior Fury talent
		L["ANTI_FEAR_BUFF_WRATH"],		-- Hunter Beast Mastery talent
		L["ANTI_FEAR_BUFF_ICE"],		-- Mage Ice talent
		L["ANTI_FEAR_BUFF_PROTECT"],	-- Paladin Holy buff
		L["ANTI_FEAR_BUFF_SHIELD"],		-- Paladin Holy buff
		L["ANTI_FEAR_BUFF_TREMOR"],		-- Shaman totem
		L["ANTI_FEAR_BUFF_ABOLISH"],	-- Majordomo (NPC) spell
	},
	--[[
		"Fear Ward",			-- Dwarf priest racial trait https://classicdb.ch/?spell=6346#taught-by-quest :: https://classicdb.ch/?spell=19337
		"Will of the Forsaken",	-- Forsaken racial trait https://classicdb.ch/?spell=7744
		"Fearless",				-- Trinket https://classicdb.ch/?spell=12733
		"Berserker Rage",		-- Warrior Fury talent https://classicdb.ch/?spell=18499 -- Improved Berserker Rage
		"Recklessness",			-- Warrior Fury talent https://classicdb.ch/?spell=1719
		"Death Wish",			-- Warrior Fury talent https://classicdb.ch/?spell=12328
		"Bestial Wrath",		-- Hunter Beast Mastery talent https://classicdb.ch/?spell=19574
		"Ice Block",			-- Mage Ice talent https://classicdb.ch/?spell=11958 https://classicdb.ch/?spell=27619 (not classic??):: 
		-- :: Despawn Ice Block https://classicdb.ch/?spell=30132 https://classicdb.ch/?spell=28523
		"Divine Protection",	-- Paladin Holy buff 1 https://classicdb.ch/?spell=498 2 https://classicdb.ch/?spell=5573 :: https://classicdb.ch/?spell=13007
		"Divine Shield",		-- Paladin Holy buff 1 https://classicdb.ch/?spell=642 2 https://classicdb.ch/?spell=1020 :: https://classicdb.ch/?spell=13874
		"Tremor Totem",			-- Shaman totem https://classicdb.ch/?spell=8143 :: https://classicdb.ch/?spell=8144
		"Abolish Magic"			-- Majordomo (NPC) spell https://classicdb.ch/?spell=776 :: https://classicdb.ch/?spell=1437
	--]]
	-- Debuffs and curses giving temporary immunity to fear effects
	["Debuff"] = {
		L["ANTI_FEAR_DEBUFF_RECKLESS"],	-- Forsaken racial trait
	}
	--[[
		"Curse of Recklessness",	-- Forsaken racial trait 1 https://classicdb.ch/?spell=704 2 https://classicdb.ch/?spell=7658 3 https://classicdb.ch/?spell=7659 4 https://classicdb.ch/?spell=11717 :: https://classicdb.ch/?spell=16231
	--]]
}
--[[
for i = 1, MAX_SKILLLINE_TABS do
   local name, texture, offset, numSpells = GetSpellTabInfo(i);
   
   if not name then
      break;
   end
   
   for s = offset + 1, offset + numSpells do
      local	spell, rank = GetSpellName(s, BOOKTYPE_SPELL);
      
      if rank then
          spell = spell.." "..rank;
      end
      
      DEFAULT_CHAT_FRAME:AddMessage(name..": "..spell);
   end
end
--]]