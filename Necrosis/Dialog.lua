--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

------------------------------------------------
-- ENGLISH  VERSION TEXTS --
------------------------------------------------
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

function Necrosis:Localization_Dialog()
end

	Necrosis.HealthstoneCooldown = L["NECROSIS_LABEL"]
	
	Necrosis.Localize = {
		["Utilisation"] = L["USE"],
		["Echange"] = L["TRADE"],
	}

	Necrosis.TooltipData = {
		["Main"] = {
			Label = L["NECROSIS_LABEL"],
			Stone = {
				[true] = L["YES"],
				[false] = L["NO"],
			},
			Hellspawn = {
				[true] = L["ON"],
				[false] = L["OFF"],
			},
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
		["Soulstone"] = {
			Text = {L["SOULSTONE_TEXT_1"],L["SOULSTONE_TEXT_2"],L["SOULSTONE_TEXT_3"],L["SOULSTONE_TEXT_4"]},
			Ritual = L["SOULSTONE_RITUAL"]
		},
		["Healthstone"] = {
			Text = {L["HEALTHSTONE_TEXT_1_1"],L["HEALTHSTONE_TEXT_1_2"]},
			Text2 = L["HEALTHSTONE_TEXT_2"],
			Ritual = L["HEALTHSTONE_RITUAL"]
		},
		["Spellstone"] = {
			Text = {L["SPELLSTONE_TEXT_1"],L["SPELLSTONE_TEXT_2"],L["SPELLSTONE_TEXT_3"], L["SPELLSTONE_TEXT_4"]}
		},
		["Firestone"] = {
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
			Label = L["IMP_LABEL"]
		},
		["Voidwalker"] = {
			Label = L["VOIDWALKER_LABEL"]
		},
		["Succubus"] = {
			Label = L["SUCCUBUS_LABEL"]
		},
		["Felhunter"] = {
			Label = L["FELHUNTER_LABEL"]
		},
		["Felguard"] = {
			Label = L["FELGUARD_LABEL"]
		},
		["Infernal"] = {
			Label = L["INFERNAL_LABEL"]
		},
		["Doomguard"] = {
			Label = L["DOOMGUARD_LABEL"]
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

