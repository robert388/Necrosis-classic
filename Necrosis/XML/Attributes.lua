--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

--[[ https://wowwiki.fandom.com/wiki/SecureActionButtonTemplate
"type"					Any clicks.
"*type1"				Any left click.
"type1"					Unmodified left click.
"shift-type2"			Shift+right click. (But not Alt+Shift+right click)
"shift-type*"			Shift+any button click.
"alt-ctrl-shift-type*"	Alt+Control+Shift+any button click.
"ctrl-alt-shift-type*"	Invalid, as modifiers are in the wrong order.
===
For example, suppose we wanted to create a button that would alter behavior based on whether you can attack your target. 
Setting the following attributes has the desired effect:
"unit"				"target"				Make all actions target the player's target.
"*harmbutton1"		"nuke1"					Remap any left clicks to "nuke1" clicks when target is hostile.
"*harmbutton2"		"nuke2"					Remap any right clicks to "nuke2" clicks when target is hostile.
"helpbutton1"		"heal1"					Remap unmodified left clicks to "heal1" clicks when target is friendly.
"type"				"spell"					Make all clicks cast a spell.
"spell-nuke1"		"Mind Flay"				Cast Mind Flay on "hostile" left click.
"spell-nuke2"		"Shadow Word: Death"	Cast Shadow Word: Death on "hostile" right click.
"alt-spell-nuke2"	"Mind Blast"			Cast Mind Blast on "hostile" alt-right click.
"spell-heal1"		"Flash Heal"			Cast Flash Heal on "friendly" left click.

:::SecureActionButtonTemplate "type" attributes:::
Type			Used attributes		Behavior
"actionbar"		"action"			Switches the current action bar depending on the value of the "action" attribute:
									A number: switches to a the bar specified by the number.
									"increment" or "decrement": move one bar up/down.
									"a, b", where a, and b are numeric, switches between bars a and b.
"action"		"unit", "action"
				["actionpage"]		Performs an action specified by the "action" attribute (a number).
									If the button:GetID() > 0, paging behavior is supported; 
									see the ActionButton_CalculateAction FrameXML function.
"pet"			"unit", "action"	Calls CastPetAction(action, unit);
"spell"			"unit", "spell"		Calls CastSpellByName(spell, unit);
"item"			"unit"
				"item" OR
				["bag", "slot"]		Equips or uses the specified item, as resolved by SecureCmdItemParse.
									"item" attribute value may be a macro conditioned string, item name, or "bag slot" string (i.e. "1 3").
									If "item" is nil, the "bag" and "slot" attributes are used; those are deprecated -- use a "bag slot" item string.
"macro"			"macro" OR
				"macrotext"			If "macro" attribute is specified, calls RunMacro(macro, button); otherwise, RunMacroText(macrotext, button);
"cancelaura"	"unit"
				"index" OR
				"spell"[, "rank"]	Calls either CancelUnitBuff(unit, index) or CancelUnitBuff(unit, spell, rank). The first version
									Note: the value of the "index" attribute must resolve to nil/false for the "spell", "rank" attributes to be considered.

"stop"	 							Calls SpellStopTargeting().
"target"		"unit"				Changes target, targets a unit for a spell, or trades unit an item on the cursor.
									If "unit" attribute value is "none", your target is cleared.
"focus"			"unit"				Calls FocusUnit(unit).
"assist"		"unit"				Calls AssistUnit(unit).
"mainassist"	"action", "unit"	Performs a main assist status on the unit based on the value of the "action" attribute:
									nil or "set": the unit is assigned main assist status. (SetPartyAssignment)
									"clear": the unit is stripped main assist status. (ClearPartyAssignment)
									"toggle": the main assist status of the unit is inverted.
"maintank"		"action", "unit"	As "mainassist", but for main tank status.
"click"			"clickbutton"		Calls clickbutton:Click(button)
"attribute"		["attribute-frame",]
				"attribute-name"
				"attribute-value"	Calls frame:SetAttribute(attributeName, attributeValue). 
									If "attribute-frame" is not specified, the button itself is assumed.
									Any other value	"_type"	Action depends on the value of the modified ("_" .. type) attribute, or rawget(button, type), in that order.
									If the value is a function, it is called with (self, unit, button, actionType) arguments
									If the value is a string, a restricted snippet stored in the attribute specified by the value on the button is executed as if it was OnClick.
--]]

------------------------------------------------------------------------------------------------------
-- DEFINITION OF INITIAL MENU ATTRIBUTES || DEFINITION INITIALE DES ATTRIBUTS DES MENUS
------------------------------------------------------------------------------------------------------

-- On crée les menus sécurisés pour les différents sorts Buff / Démon / Malédictions
function Necrosis:MenuAttribute(menu)
	if InCombatLockdown() then
		return
	end

	local menuButton = _G[menu]
	
	if not menuButton:GetAttribute("state") then 
		menuButton:SetAttribute("state", "Ferme")
	end
	
	if not menuButton:GetAttribute("lastClick") then 
		menuButton:SetAttribute("lastClick", "LeftButton")
	end
	
	if not menuButton:GetAttribute("close") then 
		menuButton:SetAttribute("close", 0)
	end
	
	menuButton:Execute([[
		ButtonList = table.new(self:GetChildren())
		if self:GetAttribute("state") == "Bloque" then
			for i, button in ipairs(ButtonList) do
				button:Show()
			end
		else
			for i, button in ipairs(ButtonList) do
				button:Hide()
			end
		end
	]])

	menuButton:SetAttribute("_onclick", [[
		self:SetAttribute("lastClick", button)
		local Etat = self:GetAttribute("state")
		if  Etat == "Ferme" then
			if button == "RightButton" then
				self:SetAttribute("state", "ClicDroit")
			else
				self:SetAttribute("state", "Ouvert")
			end
		elseif Etat == "Ouvert" then
			if button == "RightButton" then
				self:SetAttribute("state", "ClicDroit")
			else
				self:SetAttribute("state", "Ferme")
			end
		elseif Etat == "Combat" then
			for i, button in ipairs(ButtonList) do
				if button:IsShown() then
					--button:Hide()
				else
					--button:Show()
				end
			end
		elseif Etat == "ClicDroit" and button == "LeftButton" then
			self:SetAttribute("state", "Ferme")
		end
	]])
	
	menuButton:SetAttribute("_onattributechanged", [[
		if name == "state" then
			if value == "Ferme" then
				for i, button in ipairs(ButtonList) do
					button:Hide()
				end
			elseif value == "Ouvert" then
				for i, button in ipairs(ButtonList) do
					button:Show()
				end
				
				self:SetAttribute("close", self:GetAttribute("close") + 1)
				-- control:SetTimer(6, self:GetAttribute("close"))
			elseif value == "Combat" or value == "Bloque" then
				for i, button in ipairs(ButtonList) do
					button:Show()
				end
			elseif value == "Refresh" then
				self:SetAttribute("state", "Ouvert")
			elseif value == "ClicDroit" then
				for i, button in ipairs(ButtonList) do
					button:Show()
				end
			end
		end
	]])
	
	menuButton:SetAttribute("_ontimer", [[
		if self:GetAttribute("close") <= message and not self:GetAttribute("mousehere") then
			self:SetAttribute("state", "Ferme")
		end
	]])
end

------------------------------------------------------------------------------------------------------
-- DEFINITION INITIALE DES ATTRIBUTS DES SORTS
------------------------------------------------------------------------------------------------------

-- On associe les buffs au clic sur le bouton concerné
function Necrosis:BuffSpellAttribute()
	if InCombatLockdown() then
		return
	end

	-- Association de l'armure demoniaque si le sort est disponible
	if _G["NecrosisBuffMenu1"] then
		NecrosisBuffMenu1:SetAttribute("type", "spell")
		if not self.Spell[31].ID then
			NecrosisBuffMenu1:SetAttribute("spell",
				self.Spell[36].Name.."("..self.Spell[36].Rank..")"
			)
		else
			NecrosisBuffMenu1:SetAttribute("spell",
				self.Spell[31].Name.."("..self.Spell[31].Rank..")"
			)
		end
	end

	-- Buff menu buttons || Association des autres buffs aux boutons
	-- 31=Demon Armor | 47=Fel Armor | 32=Unending Breath | 33=Detect Invis | 34=Eye of Kilrogg | 37=Ritual of Summoning | 38=Soul Link | 43=Shadow Ward | 35=Enslave Demon | 59=Demonic Empowerment | 9=Banish
	local buffID = {31, 47, 32, 33, 34, 37, 38, 43, 59, 9}
	for i = 2, #buffID - 1, 1 do
		local f = _G["NecrosisBuffMenu"..i]
		if f then
			f:SetAttribute("type", "spell")
			-- Si le sort nécessite une cible, on lui en associe une
			if not (i == 2 or i == 5 or i == 7 or i == 8 or i == 9 or i == 10) then
				f:SetAttribute("unit", "target")
			end
			local SpellName_Rank = self.Spell[ buffID[i] ].Name
			if self.Spell[ buffID[i] ].Rank and not (self.Spell[ buffID[i] ].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..self.Spell[ buffID[i] ].Rank..")"
			end
			f:SetAttribute("spell", SpellName_Rank)
		end
	end


	-- Cas particulier : Bouton de Banish
	if _G["NecrosisBuffMenu10"] then
		local SpellName_Rank = self.Spell[9].Name.."("..self.Spell[9].Rank..")"

		NecrosisBuffMenu10:SetAttribute("unit*", "target")				-- associate left & right clicks with target
		NecrosisBuffMenu10:SetAttribute("ctrl-unit*", "focus") 		-- associate CTRL+left or right clicks with focus

		if self.Spell[9].Rank:find("1") then	-- the warlock can only do Banish(Rank 1) 
			-- left & right click will perform the same macro
			NecrosisBuffMenu10:SetAttribute("type*", "macro")
			NecrosisBuffMenu10:SetAttribute("macrotext*", "/focus\n/cast "..SpellName_Rank)

			-- Si le démoniste control + click le bouton de banish || if the warlock uses ctrl-click then
			-- On rebanish la dernière cible bannie || rebanish the previously banished target
			NecrosisBuffMenu10:SetAttribute("ctrl-type*", "spell")
			NecrosisBuffMenu10:SetAttribute("ctrl-spell*", SpellName_Rank)
		end 

		if self.Spell[9].Rank:find("2") then -- the warlock has Banish(rank 2)
			local Rank1 = SpellName_Rank:gsub("2", "1")
			
			-- so lets use the "harmbutton" special attribute!
			-- assign Banish(rank 2) to LEFT click 
			NecrosisBuffMenu10:SetAttribute("harmbutton1", "banishrank2")
			NecrosisBuffMenu10:SetAttribute("type-banishrank2", "macro")
			NecrosisBuffMenu10:SetAttribute("macrotext-banishrank2", "/focus\n/cast "..SpellName_Rank)
			
			-- assign Banish(rank 1) to RIGHT click 
			NecrosisBuffMenu10:SetAttribute("harmbutton2", "banishrank1")
			NecrosisBuffMenu10:SetAttribute("type-banishrank1", "macro")
			NecrosisBuffMenu10:SetAttribute("macrotext-banishrank1", "/focus\n/cast "..Rank1)

			-- allow focused target to be rebanished with CTRL+LEFT or RIGHT click
			NecrosisBuffMenu10:SetAttribute("ctrl-type1", "spell")
			NecrosisBuffMenu10:SetAttribute("ctrl-spell1", SpellName_Rank)
			NecrosisBuffMenu10:SetAttribute("ctrl-type2", "spell")
			NecrosisBuffMenu10:SetAttribute("ctrl-spell2", Rank1)
		end

	end
end

-- On associe les démons au clic sur le bouton concerné
function Necrosis:PetSpellAttribute()
	if InCombatLockdown() then
		return
	end

	-- Démons maitrisés
	for i = 2, 6, 1 do
		local f = _G["NecrosisPetMenu"..i]
		if f then
			local SpellName_Rank = self.Spell[i+1].Name
			if self.Spell[i+1].Rank and not (self.Spell[i+1].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..self.Spell[i+1].Rank..")"
			end
			f:SetAttribute("type1", "spell")
			f:SetAttribute("type2", "macro")
			f:SetAttribute("spell", SpellName_Rank)
			f:SetAttribute("macrotext",
				"/cast "..self.Spell[15].Name.."\n/stopcasting\n/cast "..SpellName_Rank
			)
		end
	end

	-- Autres sorts démoniaques
	local buttonID = {1, 7, 8, 9, 10, 11}
	local BuffID = {15, 8, 30, 35, 44, 59}
	for i = 1, #buttonID, 1 do
		local f = _G["NecrosisPetMenu"..buttonID[i]]
		if f then
			local SpellName_Rank = self.Spell[ BuffID[i] ].Name
			if self.Spell[ BuffID[i] ].Rank and not (self.Spell[ BuffID[i] ].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..self.Spell[ BuffID[i] ].Rank..")"
			end
			f:SetAttribute("type", "spell")
			f:SetAttribute("spell", SpellName_Rank)
		end
	end
end

-- On associe les malédictions au clic sur le bouton concerné
function Necrosis:CurseSpellAttribute()
	if InCombatLockdown() then
		return
	end

	local buffID = {23, 22, 25, 40, 26, 16, 14}
	for i = 1, #buffID, 1 do
		local f = _G["NecrosisCurseMenu"..i]
		if f then
--			local SpellName_Rank = self.Spell[ buffID[i] ].Name
--			if self.Spell[ buffID[i] ].Rank and not (self.Spell[ buffID[i] ].Rank == " ") then
--				SpellName_Rank = SpellName_Rank.."("..self.Spell[ buffID[i] ].Rank..")"
--			end
			f:SetAttribute("harmbutton", "debuff")
			f:SetAttribute("type-debuff", "spell")
			f:SetAttribute("unit", "target")
			f:SetAttribute("spell-debuff", self.Warlock_Spells[self.Spell[buffID[i]].ID].CastName)
--			f:SetAttribute("spell-debuff", SpellName_Rank)
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("CurseSpellAttribute"
.." "..tostring(buffID[i])..""
.." "..tostring(self.Spell[ buffID[i] ].ID or "nyl").."'"
.." '"..tostring(self.Spell[ buffID[i] ].Name).."'"
.." '"..(self.Spell[ buffID[i] ].Rank or "nyl").."'"
.." "..tostring(SpellName_Rank)..""
.." '"..(self.Warlock_Spells[self.Spell[ buffID[i] ].ID].CastName or "nyl").."'"
)
--]]
		end
	end
end

-- Associating the frames to buttons, and creating stones on right-click.
-- Association de la monture au bouton, et de la création des pierres sur un clic droit
function Necrosis:StoneAttribute(Steed)
	if InCombatLockdown() then
		return
	end

	-- stones || Pour les pierres
	local itemName = {"Soulstone", "Healthstone", "Spellstone", "Firestone" }
	local buffID = {51,52,53,54}
	for i = 1, #itemName, 1 do
		local f = _G["Necrosis"..itemName[i].."Button"]
		if f then
			f:SetAttribute("type2", "spell")
--			f:SetAttribute("spell2", self.Spell[ buffID[i] ].Name..Necrosis:RankToStone(self.Spell[ buffID[i] ].Rank))
			f:SetAttribute("spell2", self.Warlock_Spells[self.Spell[ buffID[i] ].ID].CastName)
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("StoneAttribute"
.." "..tostring(buffID[i]).."'"
.." '"..tostring(self.Spell[ buffID[i] ].Name).."'"
.." '"..(Necrosis:RankToStone(self.Spell[ buffID[i] ].Rank)).."'"
.." '"..self.Warlock_Spells[self.Spell[ buffID[i] ].ID].CastName.."'"
)
--]]
		end
	end

	-- mounts || Pour la monture
	if Steed and  _G["NecrosisMountButton"] then
		NecrosisMountButton:SetAttribute("type1", "spell")
		NecrosisMountButton:SetAttribute("type2", "spell")
		
		if (NecrosisConfig.LeftMount) then
			local leftMountName = GetSpellInfo(NecrosisConfig.LeftMount)
			NecrosisMountButton:SetAttribute("spell1", leftMountName)
		else
			if (self.Spell[2].ID) then
				NecrosisMountButton:SetAttribute("spell1", self.Spell[2].Name)
				NecrosisMountButton:SetAttribute("spell2", self.Spell[1].Name)
			else
				NecrosisMountButton:SetAttribute("spell*", self.Spell[1].Name)
			end			
		end
		
		if (NecrosisConfig.RightMount) then
			local rightMountName = GetSpellInfo(NecrosisConfig.RightMount)
			NecrosisMountButton:SetAttribute("spell2", rightMountName)
		end
	end

	-- hearthstone || Pour la pierre de foyer
	NecrosisSpellTimerButton:SetAttribute("unit1", "target")
	NecrosisSpellTimerButton:SetAttribute("type1", "macro")
	NecrosisSpellTimerButton:SetAttribute("macrotext", "/focus")
	NecrosisSpellTimerButton:SetAttribute("type2", "item")
	NecrosisSpellTimerButton:SetAttribute("item", self.Translation.Item.Hearthstone)

	-- if the 'Ritual of Souls' spell is known, then associate it to the hearthstone shift-click.
	-- Cas particulier : Si le sort du Rituel des âmes existe, on l'associe au shift+clic healthstone.
	if _G["NecrosisHealthstoneButton"] and self.Spell[50].ID then
		NecrosisHealthstoneButton:SetAttribute("shift-type*", "spell")
		NecrosisHealthstoneButton:SetAttribute("shift-spell*", self.Spell[50].Name)
	end
	
	-- if the 'Ritual of Summoning' spell is known, then associate it to the soulstone shift-click.
	if _G["NecrosisSoulstoneButton"] and self.Spell[37].ID then
		NecrosisSoulstoneButton:SetAttribute("shift-type*", "spell")
		NecrosisSoulstoneButton:SetAttribute("shift-spell*", self.Spell[37].Name)
	end
	
	
end

-- Connection Association to the central button if the spell is available || Association de la Connexion au bouton central si le sort est disponible
function Necrosis:MainButtonAttribute()
	if not NecrosisButton then return end
	-- Le clic droit ouvre le Menu des options
	NecrosisButton:SetAttribute("type2", "Open")
	NecrosisButton.Open = function()
		if not InCombatLockdown() then
			Necrosis:OpenConfigPanel()
		end
	end

	if Necrosis.Spell[NecrosisConfig.MainSpell].ID then
		NecrosisButton:SetAttribute("type1", "spell")
		NecrosisButton:SetAttribute("spell", Necrosis.Spell[NecrosisConfig.MainSpell].Name)
	end
end


------------------------------------------------------------------------------------------------------
-- DEFINITION DES ATTRIBUTS DES SORTS EN FONCTION DU COMBAT / REGEN
------------------------------------------------------------------------------------------------------

function Necrosis:NoCombatAttribute(SoulstoneMode, FirestoneMode, SpellstoneMode, Pet, Buff, Curse)

	-- Si on veut que le menu s'engage automatiquement en combat
	-- Et se désengage à la fin
	if NecrosisConfig.AutomaticMenu and not NecrosisConfig.BlockedMenu then
		if _G["NecrosisPetMenuButton"] then
			if NecrosisPetMenuButton:GetAttribute("lastClick") == "RightButton" then
				NecrosisPetMenuButton:SetAttribute("state", "ClicDroit")
			else
				NecrosisPetMenuButton:SetAttribute("state", "Ferme")
			end
			if NecrosisConfig.ClosingMenu then
				for i = 1, #Pet, 1 do
					NecrosisPetMenuButton:WrapScript(Pet[i], "OnClick", [[
						if self:GetParent():GetAttribute("state") == "Ouvert" then
							self:GetParent():SetAttribute("state", "Ferme")
						end
					]])
				end
			end
		end
		if _G["NecrosisBuffMenuButton"] then
			if NecrosisBuffMenuButton:GetAttribute("lastClick") == "RightButton" then
				NecrosisBuffMenuButton:SetAttribute("state", "ClicDroit")
			else
				NecrosisBuffMenuButton:SetAttribute("state", "Ferme")
			end
			if NecrosisConfig.ClosingMenu then
				for i = 1, #Buff, 1 do
					NecrosisBuffMenuButton:WrapScript(Buff[i], "OnClick", [[
						if self:GetParent():GetAttribute("state") == "Ouvert" then
							self:GetParent():SetAttribute("state", "Ferme")
						end
					]])
				end
			end
		end
		if _G["NecrosisCurseMenuButton"] then
			if NecrosisCurseMenuButton:GetAttribute("lastClick") == "RightButton" then
				NecrosisCurseMenuButton:SetAttribute("state", "ClicDroit")
			else
				NecrosisCurseMenuButton:SetAttribute("state", "Ferme")
			end
			if NecrosisConfig.ClosingMenu then
				for i = 1, #Curse, 1 do
					NecrosisCurseMenuButton:WrapScript(Curse[i], "OnClick", [[
						if self:GetParent():GetAttribute("state") == "Ouvert" then
							self:GetParent():SetAttribute("state", "Ferme")
						end
					]])
				end
			end
		end
	end


	-- Si on connait l'emplacement de la pierre de sort,
	-- Alors cliquer sur le bouton de pierre de sort l'équipe.
	if NecrosisConfig.ItemSwitchCombat[1] and _G["NecrosisSpellstoneButton"] then
		NecrosisSpellstoneButton:SetAttribute("type1", "macro")
		NecrosisSpellstoneButton:SetAttribute("macrotext*","/cast "..NecrosisConfig.ItemSwitchCombat[1].."\n/use 16")
	end
	-- Si on connait l'emplacement de la pierre de feu,
	-- Alors cliquer sur le bouton de pierre de feu l'équipe.
	if NecrosisConfig.ItemSwitchCombat[2] and _G["NecrosisFirestoneButton"] then
		NecrosisFirestoneButton:SetAttribute("type1", "macro")
		NecrosisFirestoneButton:SetAttribute("macrotext*", "/cast "..NecrosisConfig.ItemSwitchCombat[2].."\n/use 16")
	end
end

function Necrosis:InCombatAttribute(Pet, Buff, Curse)

	-- Si on veut que le menu s'engage automatiquement en combat
	if NecrosisConfig.AutomaticMenu and not NecrosisConfig.BlockedMenu then
		if _G["NecrosisPetMenuButton"] and NecrosisConfig.StonePosition[7] then
			NecrosisPetMenuButton:SetAttribute("state", "Combat")
			if NecrosisConfig.ClosingMenu then
				for i = 1, #Pet, 1 do
					NecrosisPetMenuButton:UnwrapScript(Pet[i], "OnClick")
				end
			end
		end
		if _G["NecrosisBuffMenuButton"] and NecrosisConfig.StonePosition[5] then
			NecrosisBuffMenuButton:SetAttribute("state", "Combat")
			if NecrosisConfig.ClosingMenu then
				for i = 1, #Buff, 1 do
					NecrosisBuffMenuButton:UnwrapScript(Buff[i], "OnClick")
				end
			end
		end
		if _G["NecrosisCurseMenuButton"] and NecrosisConfig.StonePosition[8] then
			NecrosisCurseMenuButton:SetAttribute("state", "Combat")
			if NecrosisConfig.ClosingMenu then
				for i = 1, #Curse, 1 do
					NecrosisCurseMenuButton:UnwrapScript(Curse[i], "OnClick")
				end
			end
		end
	end

	-- Si on connait le nom de la pierre de sort,
	-- Alors le clic gauche utiliser la pierre
	if NecrosisConfig.ItemSwitchCombat[1] and _G["NecrosisSpellstoneButton"] then
		NecrosisSpellstoneButton:SetAttribute("type1", "macro")
		NecrosisSpellstoneButton:SetAttribute("macrotext*", "/cast "..NecrosisConfig.ItemSwitchCombat[1].."\n/use 16")
	end

	-- Si on connait le nom de la pierre de feu,
	-- Alors le clic sur le bouton équipera la pierre
	if NecrosisConfig.ItemSwitchCombat[2] and _G["NecrosisFirestoneButton"] then
		NecrosisFirestoneButton:SetAttribute("type1", "macro")
		NecrosisFirestoneButton:SetAttribute("macrotext*", "/cast "..NecrosisConfig.ItemSwitchCombat[2].."\n/use 16")
	end

	-- Si on connait le nom de la pierre de soin,
	-- Alors le clic gauche sur le bouton utilisera la pierre
	if NecrosisConfig.ItemSwitchCombat[3] and _G["NecrosisHealthstoneButton"] then
		NecrosisHealthstoneButton:SetAttribute("type1", "macro")
		NecrosisHealthstoneButton:SetAttribute("macrotext1", "/stopcasting \n/use "..NecrosisConfig.ItemSwitchCombat[3])
	end

	-- Si on connait le nom de la pierre d'âme,
	-- Alors le clic gauche sur le bouton utilisera la pierre
	if NecrosisConfig.ItemSwitchCombat[4] and _G["NecrosisSoulstoneButton"] then
		NecrosisSoulstoneButton:SetAttribute("type1", "item")
		NecrosisSoulstoneButton:SetAttribute("unit", "target")
		NecrosisSoulstoneButton:SetAttribute("item1", NecrosisConfig.ItemSwitchCombat[4])
	end
end

------------------------------------------------------------------------------------------------------
-- DEFINITION SITUATIONNELLE DES ATTRIBUTS DES SORTS
------------------------------------------------------------------------------------------------------

function Necrosis:SoulstoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisSoulstoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisSoulstoneButton:SetAttribute("type1", "spell")
		NecrosisSoulstoneButton:SetAttribute("spell1", self.Spell[51].Name..Necrosis:RankToStone(self.Spell[51].Rank))
		return
	end

	NecrosisSoulstoneButton:SetAttribute("type1", "item")
	NecrosisSoulstoneButton:SetAttribute("type3", "item")
	NecrosisSoulstoneButton:SetAttribute("unit", "target")
	NecrosisSoulstoneButton:SetAttribute("item1", NecrosisConfig.ItemSwitchCombat[4])
	NecrosisSoulstoneButton:SetAttribute("item3", NecrosisConfig.ItemSwitchCombat[4])
end

function Necrosis:HealthstoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisHealthstoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisHealthstoneButton:SetAttribute("type1", "spell")
--		NecrosisHealthstoneButton:SetAttribute("spell1", self.Spell[52].Name..Necrosis:RankToStone(self.Spell[52].Rank))
		NecrosisHealthstoneButton:SetAttribute("spell1", Necrosis.Warlock_Spells[self.Spell[52].ID].CastName)
		return
	end

	NecrosisHealthstoneButton:SetAttribute("type1", "macro")
	NecrosisHealthstoneButton:SetAttribute("macrotext1", "/stopcasting \n/use "..NecrosisConfig.ItemSwitchCombat[3])
	NecrosisHealthstoneButton:SetAttribute("type3", "Trade")
	NecrosisHealthstoneButton:SetAttribute("ctrl-type1", "Trade")
	NecrosisHealthstoneButton.Trade = function () self:TradeStone() end
end

function Necrosis:SpellstoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisSpellstoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisSpellstoneButton:SetAttribute("type1", "spell")
		NecrosisSpellstoneButton:SetAttribute("spell*", self.Spell[53].Name.."("..self.Spell[53].Rank..")")
		return
	end

	NecrosisSpellstoneButton:SetAttribute("type1", "macro")
	NecrosisSpellstoneButton:SetAttribute("macrotext*", "/cast "..NecrosisConfig.ItemSwitchCombat[1].."\n/use 16")
end

function Necrosis:FirestoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisFirestoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisFirestoneButton:SetAttribute("type1", "spell")
		NecrosisFirestoneButton:SetAttribute("spell*", self.Spell[54].Name.."("..self.Spell[54].Rank..")")
		return
	end

	NecrosisFirestoneButton:SetAttribute("type1", "macro")
	NecrosisFirestoneButton:SetAttribute("macrotext*", "/cast "..NecrosisConfig.ItemSwitchCombat[2].."\n/use 16")
end
