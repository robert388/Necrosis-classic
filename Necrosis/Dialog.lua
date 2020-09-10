--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

------------------------------------------------
-- ENGLISH  VERSION TEXTS --
------------------------------------------------
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

function Necrosis:Localization_Dialog()
end


--[[
At initialization, this table will be used to get localized names of items.
The call to GetItemInfo *may* return nil if the local install has not seen these yet *in this session*. 
When this occurs, the event GET_ITEM_INFO_RECEIVED is used retrieve the data once
WoW has added it to local cache. https://wow.gamepedia.com/API_GetItemInfo
The lookup is by spell id so SetItem needs to get passed the id from initialization.

This file and Spells.lua are the two places WoW ids are specified. Then short names, localized names, or passed ids are used.
--]]
Necrosis.GetItemsCount = 0 -- used to register / unregister event GET_ITEM_INFO_RECEIVED
local items_to_get = 0
local items_list = { -- Items to get localized names (strings) for
	[21340]	= "soul_pouch", -- BAG_SOUL_POUCH
	[22243]	= "small_soul_pouch", -- BAG_SMALL_SOUL_POUCH
	[22244]	= "box_of_souls", -- BAG_BOX_OF_SOULS
	[21341]	= "felcloth_bag", -- BAG_FELCLOTH_BAG
	[6265]	= "soul_shard", -- Soul shard
	[5565]	= "infernal_stone", -- Infernal stone
	[16583]	= "demonic_figurine", -- Demonic figurine
	[16893]	= "soul_stone", -- Soul stone
	[5509]	= "health_stone", -- Health stone
	[5522]	= "spell_stone", -- Spell stone
	[1254]	= "fire_stone", -- Fire stone
	[6948]	= "hearth_stone", -- Hearth stone
}
--[[
At initialization, this table will be filled with localized names.
- index will be the short name from items_list
- value will be the localized name
--]]
local items_by_name = {}

-- helper routines: getters and setters for the localized items list so the list remains hidden
function Necrosis.SetItem(item_id, succ) -- called from event handler
	-- Only process an id we care about!
	local short_name = items_list[item_id] 
	local l_name = ""
	if name then
		l_name = name -- have localized name
	else
		l_name = "" -- need to wait for server...
	end
	if short_name then -- safety, do not inflict errors on the player
		items_by_name[short_name] = l_name -- safe to assign
	end

	-- Should always be an id we care about! But have seen the server spam odd ids, some not in Classic
	if succ and items_list[item_id] then 
		items_by_name[items_list[item_id]] = Necrosis.Utils.GetItemName(item_id) -- just get the localized name
		items_to_get = items_to_get - 1

		if Necrosis.Debug.init_path then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SetItem"
			.." i'"..tostring(item_id or "nyl").."'"
			.." s'"..tostring(succ or "nyl").."'"
			.." n'"..tostring(items_by_name[items_list[item_id]] or "nyl").."'"
			.." c'"..tostring(items_to_get or "nyl").."'"
			)
		end
		-- the info is now in local cache...
	end
end

function Necrosis.GetItemList() -- Debug
	return items_list
end

function Necrosis.GetItemNames() -- Debug
	return items_by_name
end

function Necrosis.GetItem(item_name) -- needs to be string value in items_list
	local res = ""
	if items_by_name[item_name] then
		res = items_by_name[item_name]
	else
		res = "" -- nil would create Lua errors
	end
	return res
end

function Necrosis.InitWarlockItems()
	items_to_get = 0
	for i,v in pairs(items_list) do
		local name = Necrosis.Utils.GetItemName(i) -- just get the localized name
		if name then
			items_by_name[v] = name -- got the info
		else
			-- rely on GET_ITEM_INFO_RECEIVED to fill in
			items_to_get = items_to_get + 1
		end
		if Necrosis.Debug.init_path then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("InitWarlockItems"
			.." i'"..tostring(i or "nyl").."'"
			.." n'"..tostring(name or "nyl").."'"
			)
		end
	end

	if Necrosis.Debug.init_path then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("InitWarlockItems"
		.." ic'"..tostring(items_to_get or "nyl").."'"
		)
	end
end

function Necrosis.WarlockItemsDone()
	local res = true
	for i,v in pairs(items_list) do
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("WarlockItemsDone"
.." i'"..tostring(i or "nyl").."'"
.." v'"..tostring(v or "nyl").."'"
.." n'"..tostring(items_by_name[v] or "nyl").."'"
.." c'"..tostring(items_to_get or "nyl").."'"
)
--]]
		if items_by_name[v] == "" 
		or items_by_name[v] == nil then -- need info
			res = false 
			break -- no need to check more
		else
			-- have data
		end
	end
	return res
end

Necrosis.HealthstoneCooldown = L["NECROSIS_LABEL"]
--[[
-- Resource: https://wow.tools/dbc/?dbc=globalstrings
Necrosis.Localize = {
	["Utilisation"] = USE, --L["USE"],
	["Echange"] = TRADE, --L["TRADE"],
}
--]]
Necrosis.TooltipData = {
	["Main"] = {
		Label = L["NECROSIS_LABEL"],
		Stone = {
			[true] = YES, --L["YES"], global strings
			[false] = NO, --L["NO"],
		},
--[[
		Hellspawn = {
			[true] = L["ON"],
			[false] = L["OFF"],
		},
--]]
		["Soulshard"] = L["SOUL_SHARD_LABEL"],
		["InfernalStone"] = L["INFERNAL_STONE_LABEL"],
		["DemoniacStone"] = L["DEMONIAC_STONE_LABEL"],
		["Soulstone"] = "\n"..L["SOUL_STONE_LABEL"],
		["Healthstone"] = L["HEALTH_STONE_LABEL"],
		["Spellstone"] = L["SPELL_STONE_LABEL"],
		["Firestone"] = L["FIRE_STONE_LABEL"],
		["CurrentDemon"] = L["CURRENT_DEMON"],
		["EnslavedDemon"] = L["ENSLAVED_DEMON"],
		["NoCurrentDemon"] = L["NO_CURRENT_DEMON"],
	},
	--[[
	34224, 	CLASS_WARLOCK_SPELLNAME2, 	Soulstone
	--]]
	["Soulstone"] = {
		Label = "|c00FF99FF"..L["SOUL_STONE"].."|r",
		Text = {L["SOULSTONE_TEXT_1"],L["SOULSTONE_TEXT_2"],L["SOULSTONE_TEXT_3"],L["SOULSTONE_TEXT_4"]},
		Ritual = L["SOULSTONE_RITUAL"]
	},
	["Healthstone"] = {
		Label = "|c0066FF33"..L["HEALTH_STONE"].."|r",
		Text = {L["HEALTHSTONE_TEXT_1_1"],L["HEALTHSTONE_TEXT_1_2"]},
		Text2 = L["HEALTHSTONE_TEXT_2"],
		Ritual = L["HEALTHSTONE_RITUAL"]
	},
	["Spellstone"] = {
		Label = "|c0099CCFF"..L["SPELL_STONE"].."|r",
		Text = {L["SPELLSTONE_TEXT_1"],L["SPELLSTONE_TEXT_2"],L["SPELLSTONE_TEXT_3"], L["SPELLSTONE_TEXT_4"]}
	},
	["Firestone"] = {
		Label = "|c00FF4444"..L["FIRE_STONE"].."|r",
		Text = {L["FIRESTONE_TEXT_1"],L["FIRESTONE_TEXT_2"],L["FIRESTONE_TEXT_3"], L["FIRESTONE_TEXT_4"]}
	},
	["SpellTimer"] = {
		Label = L["SPELLTIMER_LABEL"],
		Text = L["SPELLTIMER_TEXT"],
		Right = L["SPELLTIMER_RIGHT"]
	},
	["ShadowTrance"] = {
		Label = L["SHADOW_TRANCE_LABEL"]
	},
	["Backlash"] = {
		Label = L["BACKLASH_LABEL"]
	},
	["Banish"] = {
		Text = L["BANISH_TEXT"]
	},
	["Imp"] = {
		Label = "" --L["IMP_LABEL"]
	},
	["Voidwalker"] = {
		Label = "" --L["VOIDWALKER_LABEL"]
	},
	["Succubus"] = {
		Label = "" --L["SUCCUBUS_LABEL"]
	},
	["Felhunter"] = {
		Label = "" --L["FELHUNTER_LABEL"]
	},
	["Felguard"] = {
		Label = "" --L["FELGUARD_LABEL"]
	},
	["Infernal"] = {
		Label = "" --L["INFERNAL_LABEL"]
	},
	["Doomguard"] = {
		Label = "" --L["DOOMGUARD_LABEL"]
	},
	["Mount"] = {
		Label = L["MOUNTS_LABEL"],
		Text = L["MOUNT_TEXT"],
	},
	["BuffMenu"] = {
		Label = L["BUFF_MENU_LABEL"],
		Text = L["BUFF_MENU_TEXT_1"],
		Text2 = L["BUFF_MENU_TEXT_2"],
	},
	["PetMenu"] = {
		Label = L["PET_MENU_LABEL"],
		Text = L["PET_MENU_TEXT_1"],
		Text2 = L["PET_MENU_TEXT_2"],
	},
	["CurseMenu"] = {
		Label = L["CURSE_MENU_LABEL"],
		Text = L["CURSE_MENU_TEXT_1"],
		Text2 = L["CURSE_MENU_TEXT_2"],
	},
	["DominationCooldown"] = L["DOMINATION_COOLDOWN"],
	-- These are filled when the frame is created and the localized spell names are known
	-- curses
	["Weakness"] = {
		Label = ""
	},
	["Agony"] = {
		Label = ""
	},
	["Tongues"] = {
		Label = ""
	},
	["Exhaust"] = {
		Label = ""
	},
	["Elements"] = {
		Label = ""
	},
	["Doom"] = {
		Label = ""
	},
	["Corruption"] = {
		Label = ""
	},
	["Reckless"] = {
		Label = ""
	},
	["Shadow"] = {
		Label = ""
	},
	-- pets buffs
	["Domination"] = {
		Label = ""
	},
	["Banish"] = {
		Label = ""
	},
	["Enslave"] = {
		Label = ""
	},
	["Sacrifice"] = {
		Label = ""
	},
	-- various buffs
	["Armor"] = {
		Label = ""
	},
	["Aqua"] = {
		Label = ""
	},
	["Invisible"] = {
		Label = ""
	},
	["Kilrogg"] = {
		Label = ""
	},
	["TP"] = {
		Label = ""
	},
	["SoulLink"] = {
		Label = ""
	},
	["ShadowProtection"] = {
		Label = ""
	},
}

Necrosis.Sound = {
	["Fear"] = L["SOUND_FEAR"],
	["SoulstoneEnd"] = L["SOUND_SOUL_STONE_END"],
	["EnslaveEnd"] = L["SOUND_ENSLAVE_END"],
	["ShadowTrance"] = L["SOUND_SHADOW_TRANCE"],
	["Backlash"] = L["SOUND_BACKLASH"],
}

Necrosis.ProcText = {
	["ShadowTrance"] = L["PROC_SHADOW_TRANCE"],
	["Backlash"] = L["PROC_BACKLASH"],
}


Necrosis.ChatMessage = {
	["Bag"] = {
		["FullPrefix"] = L["BAG_FULL_PREFIX"],
		["FullSuffix"] = L["BAG_FULL_SUFFIX"],
		["FullDestroySuffix"] = L["BAG_FULL_DESTROY_PREFIX"],
	},
	["Interface"] = {
		["Welcome"] = L["INTERFACE_WELCOME"],
		["TooltipOn"] = L["INTERFACE_TOOLTIP_ON"],
		["TooltipOff"] = L["INTERFACE_TOOLTIP_OFF"],
		["MessageOn"] = L["INTERFACE_MESSAGE_ON"],
		["MessageOff"] = L["INTERFACE_MESSAGE_OFF"],
		["DefaultConfig"] = L["INTERFACE_DEFAULT_CONFIG"],
		["UserConfig"] = L["INTERFACE_USER_CONFIG"],
	},
	["Help"] = {
		L["HELP_1"],
		L["HELP_2"],
	},
	["Information"] = {
		["FearProtect"] = L["INFO_FEAR_PROTECT"],
		["EnslaveBreak"] = L["INFO_ENSLAVE_BREAK"],
		["SoulstoneEnd"] = L["INFO_SOUL_STONE_END"]
	}
}


-- Gestion XML - Menu de configuration
Necrosis.Config.Panel = {
	L["CONFIG_MESSAGE"],
	L["CONFIG_SPHERE"],
	L["CONFIG_BUTTON"],
	L["CONFIG_MENU"],
	L["CONFIG_TIMER"],
	L["CONFIG_MISC"],
}

Necrosis.Config.Messages = {
	["Position"] = L["MSG_POSITION"],
	["Afficher les bulles d'aide"] = L["MSG_SHOW_TIPS"],
	["Afficher les messages dans la zone systeme"] = L["MSG_SHOW_SYS"],
	["Activer les messages aleatoires de TP et de Rez"] = L["MSG_RANDOM"],
	["Utiliser des messages courts"] = L["MSG_USE_SHORT"],
	["Activate_random_summons_messages"] = L["MSG_RANDOM_SUMMONS"],
	["Activate_random_soulstone_messages"] = L["MSG_RANDOM_SOULSTONE"],
	["Activer egalement les messages pour les Demons"] = L["MSG_RANDOM_DEMON"],
	["Activer egalement les messages pour les Montures"] = L["MSG_RANDOM_STEED"],
	["Activer egalement les messages pour le Rituel des ames"] = L["MSG_RANDOM_SOULS"],
	["Activer les sons"] = L["MSG_SOUNDS"],
	["Alerter quand la cible est insensible a la peur"] = L["MSG_WARN_FEAR"],
	["Alerter quand la cible peut etre banie ou asservie"] = L["MSG_WARN_BANISH"],
	["M'alerter quand j'entre en Transe"] = L["MSG_WARN_TRANCE"],
}

Necrosis.Config.Sphere = {
	["Taille de la sphere"] = L["SPHERE_SIZE"],
	["Skin de la pierre Necrosis"] = L["SPHERE_SKIN"],
	["Evenement montre par la sphere"] = L["SPHERE_EVENT"],
	["Sort caste par la sphere"] = L["SPHERE_SPELL"],
	["Afficher le compteur numerique"] = L["SPHERE_COUNTER"],
	["Type de compteur numerique"] = L["SPHERE_STONE"],
}
Necrosis.Config.Sphere.Colour = {
	L["PINK"],
	L["BLUE"],
	L["ORANGE"],
	L["TURQUOISE"],
	L["PURPLE"],
	L["666"],
	L["X"],
}
Necrosis.Config.Sphere.Count = {
	L["SOUL_SHARDS"],
	L["DEMON_SUMMON_STONES"],
	L["REZ_TIMER"],
	L["MANA"],
	L["HEALTH"],
}

Necrosis.Config.Buttons = {
	["Rotation des boutons"] = L["BUTTONS_ROTATION"],
	["Fixer les boutons autour de la sphere"] = L["BUTTONS_STICK"],
	["Utiliser mes propres montures"] = L["BUTTONS_MOUNT"],
	["Choix des boutons a afficher"] = L["BUTTONS_SELECTION"],
	["Monture - Clic gauche"] = L["BUTTONS_LEFT"],
	["Monture - Clic droit"] = L["BUTTONS_RIGHT"],
}
Necrosis.Config.Buttons.Name = {
	L["SHOW_FIRE_STONE"],
	L["SHOW_SPELL_STONE"],
	L["SHOW_HEALTH_STONE"],
	L["SHOW_SOUL_STONE"],
	L["SHOW_SPELL"],
	L["SHOW_STEED"],
	L["SHOW_DEMON"],
	L["SHOW_CURSE"],
}

Necrosis.Config.Menus = {
	["Options Generales"] = L["MENU_GENERAL"],
	["Menu des Buffs"] = L["MENU_SPELLS"],
	["Menu des Demons"] = L["MENU_DEMONS"],
	["Menu des Maledictions"] = L["MENU_CURSES"],
	["Afficher les menus en permanence"] = L["MENU_ALWAYS"],
	["Afficher automatiquement les menus en combat"] = L["MENU_AUTO_COMBAT"],
	["Fermer le menu apres un clic sur un de ses elements"] = L["MENU_CLOSE_CLICK"],
	["Orientation du menu"] = L["MENU_ORIENTATION"],
	["Changer la symetrie verticale des boutons"] = L["MENU_VERT"],
	["Taille du bouton Banir"] = L["MENU_BANISH"],
}
Necrosis.Config.Menus.Orientation = {
	L["HORIZONTAL"],
	L["UPWARDS"],
	L["DOWNWARDS"],
}

Necrosis.Config.Timers = {
	["Type de timers"] = L["TIMER_TYPE"],
	["Afficher le bouton des timers"] = L["TIMER_SPELL"],
	["Afficher les timers sur la gauche du bouton"] = L["TIMER_LEFT"],
	["Afficher les timers de bas en haut"] = L["TIMER_UP"],
}
Necrosis.Config.Timers.Type = {
	L["NO_TIMER"],
	L["GRAPHICAL"],
	L["TEXTUAL"],
}

Necrosis.Config.Misc = {
	["Deplace les fragments"] = L["MISC_SHARDS_BAG"],
	["Detruit les fragments si le sac plein"] = L["MISC_SHARDS_DESTROY"],
	["Choix du sac contenant les fragments"] = L["MISC_BAG"],
	["Nombre maximum de fragments a conserver"] = L["MISC_SHARDS_MAX"],
	["Verrouiller Necrosis sur l'interface"] = L["MISC_LOCK"],
	["Afficher les boutons caches"] = L["MISC_HIDDEN"],
	["Taille des boutons caches"] = L["MISC_HIDDEN_SIZE"],
}

-- From Functions.lua
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
		Necrosis.Utils.GetSpellName(19337), --L["ANTI_FEAR_BUFF_FEAR_WARD"],	-- Dwarf priest racial trait
		Necrosis.Utils.GetSpellName(7744), --L["ANTI_FEAR_BUFF_FORSAKEN"],	-- Forsaken racial trait
		Necrosis.Utils.GetSpellName(12733), --L["ANTI_FEAR_BUFF_FEARLESS"],	-- Trinket
		Necrosis.Utils.GetSpellName(18499), --L["ANTI_FEAR_BUFF_BERSERK"],	-- Warrior Fury talent
		Necrosis.Utils.GetSpellName(1719), --L["ANTI_FEAR_BUFF_RECKLESS"],	-- Warrior Fury talent
		Necrosis.Utils.GetSpellName(12328), --L["ANTI_FEAR_BUFF_WISH"],		-- Warrior Fury talent
		Necrosis.Utils.GetSpellName(19574), --L["ANTI_FEAR_BUFF_WRATH"],		-- Hunter Beast Mastery talent
		Necrosis.Utils.GetSpellName(11958), --L["ANTI_FEAR_BUFF_ICE"],		-- Mage Ice talent
		Necrosis.Utils.GetSpellName(498), --L["ANTI_FEAR_BUFF_PROTECT"],	-- Paladin Holy buff
		Necrosis.Utils.GetSpellName(642), --L["ANTI_FEAR_BUFF_SHIELD"],		-- Paladin Holy buff
		Necrosis.Utils.GetSpellName(8143), --L["ANTI_FEAR_BUFF_TREMOR"],		-- Shaman totem
		Necrosis.Utils.GetSpellName(776), --L["ANTI_FEAR_BUFF_ABOLISH"],	-- Majordomo (NPC) spell
	},
	-- Debuffs and curses giving temporary immunity to fear effects
	["Debuff"] = {
		Necrosis.Utils.GetSpellName(704), --L["ANTI_FEAR_DEBUFF_RECKLESS"],	-- While under this curse the target ignores fear and horror
	}
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
		
		
		"Curse of Recklessness",	--  1 https://classicdb.ch/?spell=704 2 https://classicdb.ch/?spell=7658 3 https://classicdb.ch/?spell=7659 4 https://classicdb.ch/?spell=11717 :: https://classicdb.ch/?spell=16231
	--]]
	--[[
	--]]
}
