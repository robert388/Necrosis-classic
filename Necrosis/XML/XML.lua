--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

local function White(str)
	return "|c00FFFFFF"..str.."|r"
end


------------------------------------------------------------------------------------------------------
-- ANCHOR FOR THE GRAPHICS/TEXT TIMER || ANCRES DES TIMERS GRAPHIQUES ET TEXTUELS
------------------------------------------------------------------------------------------------------

function Necrosis:CreateTimerAnchor()
	local ft = _G[Necrosis.Warlock_Buttons.timer.f]
	if NecrosisConfig.TimerType == 1 then
		-- Create the graphical timer frame || Création de l'ancre invisible des timers graphiques
		local f = _G["NecrosisTimerFrame0"]
		if not f then
			f = CreateFrame("Frame", "NecrosisTimerFrame0", UIParent)
			f:SetWidth(150)
			f:SetHeight(10)
			f:Show()
			f:ClearAllPoints()
			f:SetPoint("LEFT", ft, "CENTER", 50, 0)
		end
	elseif NecrosisConfig.TimerType == 2 then
		-- Create the text timer || Création de la liste des Timers Textes
		local FontString = _G["NecrosisListSpells"]
		if not FontString then
			FontString = ft:CreateFontString(
				"NecrosisListSpells", nil, "GameFontNormalSmall"
			)
		end

		-- Define the attributes || Définition de ses attributs
		FontString:SetJustifyH("LEFT")
		FontString:SetPoint("LEFT", ft, "LEFT", 23, 0)
		FontString:SetTextColor(1, 1, 1)
	end
end

function Necrosis:CreateWarlockUI()
------------------------------------------------------------------------------------------------------
-- TIMER BUTTON || BOUTON DU TIMER DES SORTS
------------------------------------------------------------------------------------------------------

	-- Create the timer button || Création du bouton de Timer des sorts
	local f = Necrosis.Warlock_Buttons.timer.f
	local frame = nil
	frame = _G[f]
	if not frame then
		frame = CreateFrame("Button", f, UIParent, "SecureActionButtonTemplate")
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetFrameStrata("MEDIUM")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Normal")
	frame:SetPushedTexture("Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Pushed")
	frame:SetHighlightTexture("Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Highlight")
	frame:RegisterForClicks("AnyUp")

	-- Create the timer anchor || Création des ancres des timers
	self:CreateTimerAnchor()
	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnLoad", function(self)
		self:RegisterForDrag("LeftButton")
		self:RegisterForClicks("RightButtonUp")
	end)
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
--	frame:SetScript("OnEnter", function(self) Necrosis:BuildTooltip(self, "SpellTimer", "ANCHOR_RIGHT", "Timer") end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop",  function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][1],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][2],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][3],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][4],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][5]
	)
	frame:Show()


------------------------------------------------------------------------------------------------------
-- SPHERE NECROSIS
------------------------------------------------------------------------------------------------------

	-- Create the main Necrosis button  || Création du bouton principal de Necrosis
	frame = nil
	frame = _G["NecrosisButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisButton", UIParent, "SecureActionButtonTemplate")
		frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetFrameLevel(1)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(58)
	frame:SetHeight(58)
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Show()

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisButton"][1],
		NecrosisConfig.FramePosition["NecrosisButton"][2],
		NecrosisConfig.FramePosition["NecrosisButton"][3],
		NecrosisConfig.FramePosition["NecrosisButton"][4],
		NecrosisConfig.FramePosition["NecrosisButton"][5]
	)

	frame:SetScale(NecrosisConfig.NecrosisButtonScale / 100)
	
	-- Create the soulshard counter || Création du compteur de fragments d'âme
	local FontString = _G["NecrosisShardCount"]
	if not FontString then
		FontString = frame:CreateFontString("NecrosisShardCount", nil, "GameFontNormal")
	end

	-- Define its attributes || Définition de ses attributs
	FontString:SetText("00")
	FontString:SetPoint("CENTER")
	FontString:SetTextColor(1, 1, 1)
end

------------------------------------------------------------------------------------------------------
-- BUTTONS for stones (health / spell / Fire), and the Mount || BOUTON DES PIERRES, DE LA MONTURE
------------------------------------------------------------------------------------------------------

local function CreateStoneButton(stone)
	-- Create the stone button || Création du bouton de la pierre
	local b = stone
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateStoneButton"
		.." i'"..tostring(stone).."'"
		.." b'"..tostring(b and b.f).."'"
		--.." tn'"..tostring(b.norm).."'"
		--.." th'"..tostring(b.high).."'"
		)
	end

	local frame = CreateFrame("Button", b.f, UIParent, "SecureActionButtonTemplate")

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture(b.norm) --("Interface\\AddOns\\Necrosis\\UI\\"..stone.."Button-01")
	frame:SetHighlightTexture(b.high) --("Interface\\AddOns\\Necrosis\\UI\\"..stone.."Button-0"..num)
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Show()


	-- Edit the scripts associated with the buttons || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
--	frame:SetScript("OnEnter", function(self) Necrosis:BuildTooltip(self, stone, "ANCHOR_LEFT") end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self)
		if not NecrosisConfig.NecrosisLockServ then
			Necrosis:OnDragStart(self)
		end
	end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Attributes specific to the soulstone button || Attributs spécifiques à la pierre d'âme
	-- if there are no restrictions while in combat, then allow the stone to be cast || Ils permettent de caster la pierre sur soi si pas de cible et hors combat
	if stone == Necrosis.Warlock_Buttons.soul_stone.f then
		frame:SetScript("PreClick", function(self)
			if not (InCombatLockdown() or UnitIsFriend("player","target")) then
				self:SetAttribute("unit", "player")
			end
		end)
		frame:SetScript("PostClick", function(self)
			if not InCombatLockdown() then
				self:SetAttribute("unit", "target")
			end
		end)
	end

	-- Create a place for text
	-- Create the soulshard counter || Création du compteur de fragments d'âme
	local FontString = _G[b.f.."Text"]
	if not FontString then
		FontString = frame:CreateFontString(b.f, nil, "GameFontNormal")
	end

	-- Hidden but very useful...
	frame.high_of = stone
	frame.font_string = FontString

	-- Define its attributes || Définition de ses attributs
	FontString:SetText("") -- blank for now
	FontString:SetPoint("CENTER")

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if not NecrosisConfig.NecrosisLockServ then
		frame:ClearAllPoints()
		frame:SetPoint(
			NecrosisConfig.FramePosition[frame:GetName()][1],
			NecrosisConfig.FramePosition[frame:GetName()][2],
			NecrosisConfig.FramePosition[frame:GetName()][3],
			NecrosisConfig.FramePosition[frame:GetName()][4],
			NecrosisConfig.FramePosition[frame:GetName()][5]
		)
	end

	return frame
end


------------------------------------------------------------------------------------------------------
-- MENU BUTTONS || BOUTONS DES MENUS
------------------------------------------------------------------------------------------------------

local function CreateMenuButton(button)
	-- Create a Menu (Open/Close) button || Creaton du bouton d'ouverture du menu
	local b = button
	local frame = CreateFrame("Button", b.f, UIParent, "SecureHandlerAttributeTemplate SecureHandlerClickTemplate SecureHandlerEnterLeaveTemplate")

	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenuButton"
		.." i'"..tostring(button).."'"
		.." b'"..tostring(b.f).."'"
		--.." tn'"..tostring(b.norm).."'"
		--.." th'"..tostring(b.high).."'"
		)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture(b.norm) 
	frame:SetHighlightTexture(b.high) 
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Show()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self)
		--if not NecrosisConfig.NecrosisLockServ then
			Necrosis:OnDragStart(self)
		--end
	end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if not NecrosisConfig.NecrosisLockServ then
		frame:ClearAllPoints()
		frame:SetPoint(
			NecrosisConfig.FramePosition[frame:GetName()][1],
			NecrosisConfig.FramePosition[frame:GetName()][2],
			NecrosisConfig.FramePosition[frame:GetName()][3],
			NecrosisConfig.FramePosition[frame:GetName()][4],
			NecrosisConfig.FramePosition[frame:GetName()][5]
		)
	end

	return frame
end

function Necrosis:CreateMenuItem(i)
	local b = nil
	-- look up the button info
	for idx, v in pairs (Necrosis.Warlock_Buttons) do
		if idx == i.f_ptr then
			b = v
			break
		else
		end
	end
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenuItem"
		.." i'"..tostring(i.f_ptr).."'"
		.." b'"..tostring(b.f).."'"
		.." bt'"..tostring(b.tip).."'"
		.." ih'"..tostring(i.high_of).."'"
		.." s'"..tostring(Necrosis:GetSpellName(i.high_of)).."'"
		)
	end

	-- Create the button || Creaton du bouton
	local frame = _G[b.f] 
	if not frame then
		frame = CreateFrame("Button", b.f, UIParent, "SecureActionButtonTemplate")

		-- Définition de ses attributs
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:SetWidth(40)
		frame:SetHeight(40)
		frame:SetHighlightTexture(b.high) --("Interface\\AddOns\\Necrosis\\UI\\"...)
		frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

		-- ======  hidden but effective
		-- Add valuable data to the frame for retrieval later
		frame.high_of = i.high_of
		frame.pet = b.pet
		
		-- Set the tooltip label to the localized name if not given one already
		Necrosis.TooltipData[b.tip].Label = White(Necrosis.GetSpellName(i.high_of)) 
	end

	frame:SetNormalTexture(b.norm)
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton 
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

	--============= Special settings per button
	--
	-- Special attributes for casting certain buffs || Attributs spéciaux pour les buffs castables sur les autres joueurs
	if i == "breath" or i == "invis" then
		frame:SetScript("PreClick", function(self)
			if not (InCombatLockdown() or UnitIsFriend("player","target")) then
				self:SetAttribute("unit", "player")
			end
		end)
		frame:SetScript("PostClick", function(self)
			if not InCombatLockdown() then
				self:SetAttribute("unit", "target")
			end
		end)
	end

	-- Special attribute for the Banish button || Attributes spéciaux pour notre ami le sort de Bannissement
	if i == "banish" then
		frame:SetScale(NecrosisConfig.BanishScale/100)
	end

	return frame
end

------------------------------------------------------------------------------------------------------
-- SPECIAL POPUP BUTTONS || BOUTONS SPECIAUX POPUP
------------------------------------------------------------------------------------------------------

function Necrosis:CreateWarlockPopup()

------------------------------------------------------------------------------------------------------
	-- Create the ShadowTrance button || Creation du bouton de ShadowTrance
	local frame = nil
	frame = _G["NecrosisShadowTranceButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisShadowTranceButton", UIParent)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\ShadowTrance-Icon")
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Hide()

	-- Edit scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][1],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][2],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][3],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][4],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][5]
	)

------------------------------------------------------------------------------------------------------
	-- Create the Backlash button || Creation du bouton de BackLash
	local frame = _G["NecrosisBacklashButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisBacklashButton", UIParent)
	end

	-- Definte its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Backlash-Icon")
	frame:RegisterForDrag("LeftButton")
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][1],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][2],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][3],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][4],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][5]
	)

------------------------------------------------------------------------------------------------------
	-- Create the Elemental alert button || Creation du bouton de détection des cibles banissables / asservissables
	frame = nil
	frame = _G["NecrosisCreatureAlertButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisCreatureAlertButton", UIParent)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\ElemAlert")
	frame:RegisterForDrag("LeftButton")
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if NecrosisConfig.FramePosition then
		if NecrosisConfig.FramePosition["NecrosisCreatureAlertButton"] then
			frame:ClearAllPoints()
			frame:SetPoint(
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton"][1],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton"][2],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton"][3],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton"][4],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton"][5]
			)
		end
	else
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER", -50, 0)
	end

------------------------------------------------------------------------------------------------------
	-- Create the AntiFear button || Creation du bouton de détection des cibles protégées contre la peur
	local frame = _G["NecrosisAntiFearButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisAntiFearButton", UIParent)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\AntiFear-01")
	frame:RegisterForDrag("LeftButton")
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if NecrosisConfig.FramePosition then
		if NecrosisConfig.FramePosition["NecrosisAntiFearButton"] then
			frame:ClearAllPoints()
			frame:SetPoint(
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][1],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][2],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][3],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][4],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][5]
			)
		end
	else
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER", 50, 0)
	end
end


------------------------------------------------------------------------------------------------------
-- CREATE BUTTONS ON DEMAND || CREATION DES BOUTONS A LA DEMANDE
------------------------------------------------------------------------------------------------------
function Necrosis:CreateSphereButtons(button_info)
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateSphereButtons"
		.." f'"..tostring(button_info.f).."'"
		)
	end
	if button_info.menu then
		return CreateMenuButton(button_info)
	else
		return CreateStoneButton(button_info)
	end
end

