--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

-- On crée ou on affiche le panneau de configuration de la sphere
function Necrosis:SetSphereConfig()

	local frame = _G["NecrosisSphereConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisSphereConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Création du slider de scale de Necrosis
		frame = CreateFrame("Slider", "NecrosisSphereSize", NecrosisSphereConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(50, 200)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisSphereConfig, "BOTTOMLEFT", 225, 400)

		local f = _G[Necrosis.Warlock_Buttons.main.f]
--		local NBx, NBy = f:GetCenter()
		local point, relativeTo, relativePoint, NBx, NBy = f:GetPoint()
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("SetSphereConfig scale"
.." p'"..(tostring(point))..'"'
.." rt'"..(tostring(relativeTo:GetName()))..'"'
.." rp'"..(tostring(relativePoint))..'"'
.." x'"..(tostring(NBx))..'"'
.." y'"..(tostring(NBy))..'"'
)
--]]
		NBx = NBx * (NecrosisConfig.NecrosisButtonScale / 100) -- undo the scaling
		NBy = NBy * (NecrosisConfig.NecrosisButtonScale / 100)

		frame:SetScript("OnEnter", function(self)
--			NBx, NBy = f:GetCenter()
--			NBx = NBx * (NecrosisConfig.NecrosisButtonScale / 100)
--			NBy = NBy * (NecrosisConfig.NecrosisButtonScale / 100)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetValue().." %")
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnValueChanged", function(self)
			if not (self:GetValue() == NecrosisConfig.NecrosisButtonScale) then
				GameTooltip:SetText(self:GetValue().." %")
				NecrosisConfig.NecrosisButtonScale = self:GetValue()
				
				NecrosisConfig.FramePosition["NecrosisButton"][4] = NBx / (NecrosisConfig.NecrosisButtonScale / 100)
				NecrosisConfig.FramePosition["NecrosisButton"][5] = NBy / (NecrosisConfig.NecrosisButtonScale / 100)
				
				f:ClearAllPoints()
				f:SetPoint(NecrosisConfig.FramePosition["NecrosisButton"][1],
					NecrosisConfig.FramePosition["NecrosisButton"][2],
					NecrosisConfig.FramePosition["NecrosisButton"][3], 
					NBx / (NecrosisConfig.NecrosisButtonScale / 100), 
					NBy / (NecrosisConfig.NecrosisButtonScale / 100)
					)
--				f:SetPoint("CENTER", "UIParent", "CENTER", NBx, NBy)
--[[
				f:SetPoint(
					NecrosisConfig.FramePosition["NecrosisButton"][1],
					NecrosisConfig.FramePosition["NecrosisButton"][2],
					NecrosisConfig.FramePosition["NecrosisButton"][3],
					NecrosisConfig.FramePosition["NecrosisButton"][4],
					NecrosisConfig.FramePosition["NecrosisButton"][5]
				)
--]]
				f:SetScale(NecrosisConfig.NecrosisButtonScale / 100)
				Necrosis:ButtonSetup()
			end
		end)

		NecrosisSphereSizeLow:SetText("50 %")
		NecrosisSphereSizeHigh:SetText("200 %")

		-------------------------------------------------
		-- Skin de la sphère
		frame = CreateFrame("Frame", "NecrosisSkinSelection", NecrosisSphereConfig, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisSphereConfig, "BOTTOMRIGHT", 40, 325)

		local FontString = frame:CreateFontString("NecrosisSkinSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", NecrosisSphereConfig, "BOTTOMLEFT", 35, 328)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		-------------------------------------------------
		-- Evenement montré par la sphère
		frame = CreateFrame("Frame", "NecrosisEventSelection", NecrosisSphereConfig, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisSphereConfig, "BOTTOMRIGHT", 40, 300)

		FontString = frame:CreateFontString("NecrosisEventSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", NecrosisSphereConfig, "BOTTOMLEFT", 35, 303)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		------------------------------------------------- https://wow.gamepedia.com/Using_UIDropDownMenu
		-- Sort associé à la sphère
		frame = CreateFrame("Frame", "NecrosisSpellSelection", NecrosisSphereConfig, "UIDropDownMenuTemplate")
		UIDropDownMenu_SetText(NecrosisSpellSelection, Necrosis.GetSpellName(NecrosisConfig.MainSpell))
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisSphereConfig, "BOTTOMRIGHT", 40, 275)

		FontString = frame:CreateFontString("NecrosisSpellSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", NecrosisSphereConfig, "BOTTOMLEFT", 35, 278)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		-------------------------------------------------
		-- Affiche ou masque le compteur numérique
		frame = CreateFrame("CheckButton", "NecrosisShowCount", NecrosisSphereConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisSphereConfig, "BOTTOMLEFT", 25, 200)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.ShowCount = self:GetChecked()
			Necrosis:BagExplore()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Evenement montré par le compteur
		frame = CreateFrame("Frame", "NecrosisCountSelection", NecrosisSphereConfig, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisSphereConfig, "BOTTOMRIGHT", 40, 175)

		FontString = frame:CreateFontString("NecrosisCountSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", NecrosisSphereConfig, "BOTTOMLEFT", 35, 178)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

	end

	UIDropDownMenu_Initialize(NecrosisSkinSelection, Necrosis.Skin_Init)
	UIDropDownMenu_Initialize(NecrosisEventSelection, Necrosis.Event_Init)
	UIDropDownMenu_Initialize(NecrosisSpellSelection, Necrosis.Spell_Init)
	UIDropDownMenu_Initialize(NecrosisCountSelection, Necrosis.Count_Init)

	NecrosisSphereSizeText:SetText(self.Config.Sphere["Taille de la sphere"])
	NecrosisSkinSelectionT:SetText(self.Config.Sphere["Skin de la pierre Necrosis"])
	NecrosisEventSelectionT:SetText(self.Config.Sphere["Evenement montre par la sphere"])
	NecrosisSpellSelectionT:SetText(self.Config.Sphere["Sort caste par la sphere"])
	NecrosisShowCount:SetText(self.Config.Sphere["Afficher le compteur numerique"])
	NecrosisCountSelectionT:SetText(self.Config.Sphere["Type de compteur numerique"])

	NecrosisSphereSize:SetValue(NecrosisConfig.NecrosisButtonScale)
	NecrosisShowCount:SetChecked(NecrosisConfig.ShowCount)

	local couleur = {"Rose", "Bleu", "Orange", "Turquoise", "Violet", "666", "X"}
	for i in ipairs(couleur) do
		if couleur[i] == NecrosisConfig.NecrosisColor then
			UIDropDownMenu_SetSelectedID(NecrosisSkinSelection, i)
			UIDropDownMenu_SetText(NecrosisSkinSelection, self.Config.Sphere.Colour[i])
			break
		end
	end

	UIDropDownMenu_SetSelectedID(NecrosisEventSelection, NecrosisConfig.Circle)
	if NecrosisConfig.Circle == 1 then
		UIDropDownMenu_SetText(NecrosisEventSelection, self.Config.Sphere.Count[NecrosisConfig.Circle])
	else
		UIDropDownMenu_SetText(NecrosisEventSelection, self.Config.Sphere.Count[NecrosisConfig.Circle + 1])
	end

--	Necrosis.Spell_Click(NecrosisSpellSelection)

	UIDropDownMenu_SetSelectedID(NecrosisCountSelection, NecrosisConfig.CountType)
	UIDropDownMenu_SetText(NecrosisCountSelection, self.Config.Sphere.Count[NecrosisConfig.CountType])

	frame:Show()
end


------------------------------------------------------------------------------------------------------
-- FONCTIONS NECESSAIRES AUX DROPDOWNS
------------------------------------------------------------------------------------------------------

-- Fonctions du Dropdown des skins
function Necrosis.Skin_Init()
	local element = {}

	for i in ipairs(Necrosis.Config.Sphere.Colour) do
		element.text = Necrosis.Config.Sphere.Colour[i]
		element.checked = false
		element.func = Necrosis.Skin_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Necrosis.Skin_Click(self)
	local ID = self:GetID()
	local couleur = {"Rose", "Bleu", "Orange", "Turquoise", "Violet", "666", "X"}
	UIDropDownMenu_SetSelectedID(NecrosisSkinSelection, ID)
	NecrosisConfig.NecrosisColor = couleur[ID]
	local f = _G[Necrosis.Warlock_Buttons.main.f]
	f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..couleur[ID].."\\Shard16")
end

-- Fonctions du Dropdown des Events de la sphère
function Necrosis.Event_Init()
	local element = {}
	for i in ipairs(Necrosis.Config.Sphere.Count) do
		if not (i == 2) then
			element.text = Necrosis.Config.Sphere.Count[i]
			element.checked = false
			element.func = Necrosis.Event_Click
			UIDropDownMenu_AddButton(element)
		end
	end
end

function Necrosis.Event_Click(self)
	local ID = self:GetID()
	UIDropDownMenu_SetSelectedID(NecrosisEventSelection, ID)
	NecrosisConfig.Circle = ID
	Necrosis:UpdateHealth()
	Necrosis:UpdateMana()
	Necrosis:BagExplore()
end

-- Fonctions du Dropdown des sorts de la sphère
function Necrosis.Spell_Init()
	local element = UIDropDownMenu_CreateInfo()
	local selected = ""
	local main_spell = Necrosis.GetMainSpellList()
	local color = ""

	for i = 1, #main_spell, 1 do
		if Necrosis.IsSpellKnown(main_spell[i]) then  -- known
			color = "|CFFFFFFFF"
			element.func = Necrosis.Spell_Click
		else
			color = "|CFF808080"
		end
		spell = color..Necrosis.GetSpellName(main_spell[i]).."|r"
		element.text = spell
		element.arg1 = i
		
		if (NecrosisConfig.MainSpell == main_spell[i]) then
			element.checked = true
			selected = spell
		else
			element.checked = false
		end
		UIDropDownMenu_AddButton(element)
	end
end

function Necrosis.Spell_Click(self, arg1, arg2, checked)
	local main_spell = Necrosis.GetMainSpellList()
	local ID = self:GetID()
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Spell_Click"
.." 1'"..(tostring(arg1) or "nyl").."'"
.." 2'"..(tostring(arg2) or "nyl").."'"
.." c'"..(tostring(checked) or "nyl").."'"
.." cs'"..(tostring(main_spell[arg1]) or "nyl").."'"
)
--]]
	UIDropDownMenu_SetSelectedID(NecrosisSpellSelection, arg1)
--	UIDropDownMenu_SetText(NecrosisSpellSelection, Necrosis.GetSpellName(main_spell[ID]))
	NecrosisConfig.MainSpell = main_spell[arg1]
	Necrosis.MainButtonAttribute()
end

-- Fonctions du Dropdown des Events du compteur
function Necrosis.Count_Init()
	local element = {}
	for i in ipairs(Necrosis.Config.Sphere.Count) do
		element.text = Necrosis.Config.Sphere.Count[i]
		element.checked = false
		element.func = Necrosis.Count_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Necrosis.Count_Click(self)
	local ID = self:GetID()
	UIDropDownMenu_SetSelectedID(NecrosisCountSelection, ID)
	NecrosisConfig.CountType = ID
	NecrosisShardCount:SetText("")
	Necrosis:UpdateHealth()
	Necrosis:UpdateMana()
	Necrosis:BagExplore()
end