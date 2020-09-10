--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

local function SetRandom(enable)
	if enable then
--				NecrosisShortMessages:Disable()
		NecrosisSummmonMessages:Enable()
		NecrosisSummmonShortMessages:Enable()
		NecrosisSoulstoneMessages:Enable()
		NecrosisSoulstoneShortMessages:Enable()
		NecrosisDemonMessages:Enable()
		NecrosisSteedMessages:Enable()
--				NecrosisRoSMessages:Enable()
	else
--				NecrosisShortMessages:Disable()
		NecrosisSummmonMessages:Disable()
		NecrosisSummmonShortMessages:Disable()
		NecrosisSoulstoneMessages:Disable()
		NecrosisSoulstoneShortMessages:Disable()
		NecrosisDemonMessages:Disable()
		NecrosisSteedMessages:Disable()
--				NecrosisRoSMessages:Disable()
	end
end

function Necrosis:SetMessagesConfig()

	local frame = _G["NecrosisMessagesConfig"]
	if not frame then
		local y = -25 -- initial offset
		local y_offset = -23
		local x_offset = 25

		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisMessagesConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Activer les bulles d'aide
		frame = CreateFrame("CheckButton", "NecrosisShowTooltip", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.NecrosisToolTip = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Déplacer les messages dans la zone système
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisChatType", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.ChatType = not self:GetChecked()
			Necrosis:Msg(Necrosis.Config.Messages.Position, "USER")
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Activer les messages de TP et de Rez
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSpeech", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.ChatMsg = self:GetChecked()
			SetRandom(NecrosisConfig.ChatMsg)
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Reminder
		y = y + y_offset
		local spacer_1 = NecrosisMessagesConfig:CreateFontString(nil, nil, "GameFontNormalSmall")
		spacer_1:Show()
		spacer_1:ClearAllPoints()
		spacer_1:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)
		spacer_1:SetTextColor(1, 0.5, 0)
		spacer_1:SetText(L["SPEECH_API"])
--[[
		-- Activer les messages courts
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisShortMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.SM_Summon = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)
--]]
		-- Sep 2020: Added player summons messages for explicit control
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSummmonMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)

		frame:SetScript("OnClick", function(self) 
							local checked = self:GetChecked() 
							NecrosisConfig.PlayerSummons = checked
							if checked then
								NecrosisSummmonShortMessages:Enable()
							else
								NecrosisSummmonShortMessages:Disable()
							end
							end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)

			-- Activer les messages courts
			y = y + y_offset
			frame = CreateFrame("CheckButton", "NecrosisSummmonShortMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
			frame:EnableMouse(true)
			frame:SetWidth(24)
			frame:SetHeight(24)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*3, y)

			frame:SetScript("OnClick", function(self) NecrosisConfig.PlayerSummonsSM = self:GetChecked() end)

			FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
			FontString:Show()
			FontString:ClearAllPoints()
			FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
			FontString:SetTextColor(1, 1, 1)
			-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
			frame:SetFontString(FontString)

		-- Sep 2020: Added player SS messages for explicit control
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSoulstoneMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.PlayerSS = self:GetChecked() end)
		frame:SetScript("OnClick", function(self) 
							local checked = self:GetChecked() 
							NecrosisConfig.PlayerSS = checked
							if checked then
								NecrosisSoulstoneShortMessages:Enable()
							else
								NecrosisSoulstoneShortMessages:Disable()
							end
							end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)

			-- Activer les messages courts
			y = y + y_offset
			frame = CreateFrame("CheckButton", "NecrosisSoulstoneShortMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
			frame:EnableMouse(true)
			frame:SetWidth(24)
			frame:SetHeight(24)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*3, y)

			frame:SetScript("OnClick", function(self) NecrosisConfig.PlayerSSSM = self:GetChecked() end)

			FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
			FontString:Show()
			FontString:ClearAllPoints()
			FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
			FontString:SetTextColor(1, 1, 1)
			-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
			frame:SetFontString(FontString)

		-- Activer les messages des démons
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisDemonMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.DemonSummon = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)

		-- Activer les messages des montures
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSteedMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.SteedSummon = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)
--[[
		-- Activate Ritual of Souls speech button -Draven (April 3rd, 2008)
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisRoSMessages", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset*2, y)
		
		frame:SetScript("OnClick", function(self) NecrosisConfig.RoSSummon = self:GetChecked() end)
		
		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		--FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)
--]]
		-- Alertes sonores
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSound", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.Sound = self:GetChecked()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Aertes Antifear
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisFear", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.AntiFearAlert = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Alertes Elementaire / Démon
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisBanish", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.Banish = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Alertes transes
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisTrance", NecrosisMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMessagesConfig, "TOPLEFT", x_offset, y)

		frame:SetScript("OnClick", function(self) NecrosisConfig.ShadowTranceAlert = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

	end

	NecrosisShowTooltip:SetChecked(NecrosisConfig.NecrosisToolTip)
	NecrosisChatType:SetChecked(not NecrosisConfig.ChatType)
	NecrosisSpeech:SetChecked(NecrosisConfig.ChatMsg)
--	NecrosisShortMessages:SetChecked(NecrosisConfig.SM)
	NecrosisSummmonMessages:SetChecked(NecrosisConfig.PlayerSummons)
	NecrosisSoulstoneMessages:SetChecked(NecrosisConfig.PlayerSS)
	NecrosisSoulstoneShortMessages:SetChecked(NecrosisConfig.PlayerSSSM)
	NecrosisDemonMessages:SetChecked(NecrosisConfig.DemonSummon)
	NecrosisSteedMessages:SetChecked(NecrosisConfig.SteedSummon)
--	NecrosisRoSMessages:SetChecked(NecrosisConfig.RoSSummon)
	NecrosisSound:SetChecked(NecrosisConfig.Sound)
	NecrosisFear:SetChecked(NecrosisConfig.AntiFearAlert)
	NecrosisBanish:SetChecked(NecrosisConfig.Banish)
	NecrosisTrance:SetChecked(NecrosisConfig.ShadowTranceAlert)


	NecrosisShowTooltip:SetText(self.Config.Messages["Afficher les bulles d'aide"])
	NecrosisChatType:SetText(self.Config.Messages["Afficher les messages dans la zone systeme"])
	NecrosisSpeech:SetText(self.Config.Messages["Activer les messages aleatoires de TP et de Rez"])
--	NecrosisShortMessages:SetText(self.Config.Messages["Utiliser des messages courts"])
	NecrosisSummmonMessages:SetText(self.Config.Messages["Activate_random_summons_messages"])
	NecrosisSummmonShortMessages:SetText(self.Config.Messages["Utiliser des messages courts"])
	NecrosisSoulstoneMessages:SetText(self.Config.Messages["Activate_random_soulstone_messages"])
	NecrosisSoulstoneShortMessages:SetText(self.Config.Messages["Utiliser des messages courts"])
	NecrosisDemonMessages:SetText(self.Config.Messages["Activer egalement les messages pour les Demons"])
	NecrosisSteedMessages:SetText(self.Config.Messages["Activer egalement les messages pour les Montures"])
--	NecrosisRoSMessages:SetText(self.Config.Messages["Activer egalement les messages pour le Rituel des ames"])
	NecrosisSound:SetText(self.Config.Messages["Activer les sons"])
	NecrosisFear:SetText(self.Config.Messages["Alerter quand la cible est insensible a la peur"])
	NecrosisBanish:SetText(self.Config.Messages["Alerter quand la cible peut etre banie ou asservie"])
	NecrosisTrance:SetText(self.Config.Messages["M'alerter quand j'entre en Transe"])

	SetRandom(NecrosisConfig.ChatMsg)
	frame:Show()
end


