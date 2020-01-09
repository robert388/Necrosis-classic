--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CRÉATION ET INVOCATION DU PANNEAU DE CONFIGURATION
------------------------------------------------------------------------------------------------------

-- Ouverture du cadre des menus des options
function Necrosis:OpenConfigPanel()
    
	-- On affiche les messages d'aide
	if self.ChatMessage.Help[1] then
		for i = 1, #self.ChatMessage.Help, 1 do
			self:Msg(self.ChatMessage.Help[i], "USER")
		end
	end
    local me = self
	local frame = _G["NecrosisGeneralFrame"]
	-- Si la fenêtre n'existe pas, on la crée
	if not frame then
		frame = CreateFrame("Frame", "NecrosisGeneralFrame", UIParent)

		-- Définition de ses attributs
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:SetToplevel(true)
		frame:SetWidth(450)
		frame:SetHeight(512)
		frame:Show()
		frame:ClearAllPoints()
		if NecrosisConfig.FramePosition.NecrosisGeneralFrame then
			frame:SetPoint(
				NecrosisConfig.FramePosition["NecrosisGeneralFrame"][1],
				NecrosisConfig.FramePosition["NecrosisGeneralFrame"][2],
				NecrosisConfig.FramePosition["NecrosisGeneralFrame"][3],
				NecrosisConfig.FramePosition["NecrosisGeneralFrame"][4],
				NecrosisConfig.FramePosition["NecrosisGeneralFrame"][5]
			)
		else
			frame:SetPoint("TOPLEFT", 100, -100)
		end

		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
		frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
		frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

		-- Texture en haut à gauche : icone
		local texture = frame:CreateTexture("NecrosisGeneralIcon", "BACKGROUND")
		texture:SetWidth(75)
		texture:SetHeight(61)
		texture:SetTexture("Interface\\Spellbook\\Spellbook-Icon")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", 10, -6)

		-- Textures du cadre
		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(322)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT")

		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(128)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPRIGHT")

		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(322)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("BOTTOMLEFT")

		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(128)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("BOTTOMRIGHT")

		-- Texte du titre
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormal")
		FontString:SetTextColor(1, 0.8, 0)
		FontString:SetText(self.Data.Label)
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("CENTER", 6, 233)
--[[
		-- Crédits
		FontString = frame:CreateFontString(nil, nil, "GameFontNormal")
		FontString:SetTextColor(1, 0.8, 0)
		FontString:SetText("Developed by Lomig & Tarcalion")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("TOP", 0, -48)
--]]
		-- Titre de section au bas de la page
		FontString = frame:CreateFontString("NecrosisGeneralPageText", nil, "GameFontNormal")
		FontString:SetTextColor(1, 0.8, 0)
		FontString:SetWidth(150) -- 102
		FontString:SetHeight(0)
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", 0, 96)

		-- Bouton de fermeture de la fenêtre
		frame = CreateFrame("Button", "NecrosisGeneralCloseButton", NecrosisGeneralFrame, "UIPanelCloseButton")
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", "NecrosisGeneralFrame", "TOPRIGHT", -46, -24)

		-- Premier onglet du panneau de configuration
		frame = CreateFrame("CheckButton", "NecrosisGeneralTab1", NecrosisGeneralFrame)
		frame:SetWidth(32)
		frame:SetHeight(32)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", "NecrosisGeneralFrame", "TOPRIGHT", -32, -65)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(me.Config.Panel[1])
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnClick", function() Necrosis:SetPanel(1) end)


		texture = frame:CreateTexture(nil, "BACKGROUND")
		texture:SetWidth(64)
		texture:SetHeight(64)
		texture:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", -3, 11)

		frame:SetNormalTexture("Interface\\Icons\\Ability_Creature_Cursed_03")
		frame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		frame:GetHighlightTexture():SetBlendMode("ADD")
		frame:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
		frame:GetCheckedTexture():SetBlendMode("ADD")

		-- Autres onglets
		local tex = {
			"INV_Misc_Gem_Amethyst_02",
			"Trade_Engineering",
			"INV_Wand_1H_Stratholme_D_02",
			"Spell_Nature_TimeStop",
			"Ability_Creature_Disease_05"
		}
	 
		for i in ipairs(tex) do
			frame = CreateFrame("CheckButton", "NecrosisGeneralTab"..(i + 1), NecrosisGeneralFrame)
			frame:SetWidth(32)
			frame:SetHeight(32)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", "NecrosisGeneralTab"..i, "BOTTOMLEFT", 0, -17)
			
			frame:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				
				GameTooltip:SetText(me.Config.Panel[i + 1])
			end)
			frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
			frame:SetScript("OnClick", function() Necrosis:SetPanel(i + 1) end)


			texture = frame:CreateTexture(nil, "BACKGROUND")
			texture:SetWidth(64)
			texture:SetHeight(64)
			texture:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
			texture:Show()
			texture:ClearAllPoints()
			texture:SetPoint("TOPLEFT", -3, 11)

			frame:SetNormalTexture("Interface\\Icons\\"..tex[i])
			frame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
			frame:GetHighlightTexture():SetBlendMode("ADD")
			frame:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
			frame:GetCheckedTexture():SetBlendMode("ADD")
		end

		self:SetPanel(1)
	else

		if frame:IsVisible() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end


------------------------------------------------------------------------------------------------------
-- FONCTIONS LIÉES AU PANNEAU DE CONFIGURATION
------------------------------------------------------------------------------------------------------

-- Function to display different pages of the control panel || Fonction permettant l'affichage des différentes pages du panneau de configuration
function Necrosis:SetPanel(PanelID)
	local TabName
	for index=1, 6, 1 do
		TabName = _G["NecrosisGeneralTab"..index]
		if index == PanelID then
			TabName:SetChecked(1)
		else
			TabName:SetChecked(nil)
		end
	end
	NecrosisGeneralPageText:SetText(self.Config.Panel[PanelID])
	if PanelID == 1 then
		HideUIPanel(NecrosisSphereConfig)
		HideUIPanel(NecrosisButtonsConfig)
		HideUIPanel(NecrosisMenusConfig)
		HideUIPanel(NecrosisTimersConfig)
		HideUIPanel(NecrosisMiscConfig)
		self:SetMessagesConfig()
	elseif PanelID == 2 then
		HideUIPanel(NecrosisMessagesConfig)
		HideUIPanel(NecrosisButtonsConfig)
		HideUIPanel(NecrosisMenusConfig)
		HideUIPanel(NecrosisTimersConfig)
		HideUIPanel(NecrosisMiscConfig)
		self:SetSphereConfig()
	elseif PanelID == 3 then
		HideUIPanel(NecrosisMessagesConfig)
		HideUIPanel(NecrosisSphereConfig)
		HideUIPanel(NecrosisMenusConfig)
		HideUIPanel(NecrosisTimersConfig)
		HideUIPanel(NecrosisMiscConfig)
		self:SetButtonsConfig()
	elseif PanelID == 4 then
		HideUIPanel(NecrosisMessagesConfig)
		HideUIPanel(NecrosisSphereConfig)
		HideUIPanel(NecrosisButtonsConfig)
		HideUIPanel(NecrosisTimersConfig)
		HideUIPanel(NecrosisMiscConfig)
		self:SetMenusConfig()
	elseif PanelID == 5 then
		HideUIPanel(NecrosisMessagesConfig)
		HideUIPanel(NecrosisSphereConfig)
		HideUIPanel(NecrosisButtonsConfig)
		HideUIPanel(NecrosisMenusConfig)
		HideUIPanel(NecrosisMiscConfig)
		self:SetTimersConfig()
	elseif PanelID == 6 then
		HideUIPanel(NecrosisMessagesConfig)
		HideUIPanel(NecrosisSphereConfig)
		HideUIPanel(NecrosisButtonsConfig)
		HideUIPanel(NecrosisMenusConfig)
		HideUIPanel(NecrosisTimersConfig)
		self:SetMiscConfig()
	end
end
