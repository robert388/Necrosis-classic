--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- Get a reference to the global env variable containing all the frames || On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

local function OutputGroup(SpellGroup, index, msg)
	if Necrosis.Debug.timers then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("OGroup::"
		.." '"..(tostring(msg) or "nyl").."'"
		.." i'"..(tostring(index) or "nyl").."'"
		.." n'"..(tostring(SpellGroup[index].Name) or "nyl").."'"
		.." sn'"..(tostring(SpellGroup[index].SubName) or "nyl").."'"
		.." tg'"..(tostring(SpellGroup[index].TargetGUID) or "nyl").."'"
		.." v'"..(tostring(SpellGroup[index].Visible) or "nyl").."'"
		.." t'"..(tostring(SpellGroup[index].Text) or "nyl").."'"
		)
	end
end
------------------------------------------------------------------------------------------------------
-- FUNCTIONS FOR CREATION OF FRAMES ||FONCTIONS DE CREATION DES FRAMES
------------------------------------------------------------------------------------------------------

--Creation of headers for timer groups || Création des entêtes des groupes de timers
local function CreateGroup(SpellGroup, index)

	local texte = ""
	if _G["NecrosisSpellTimer"..index] then
		local f = _G["NecrosisSpellTimer"..index]
		local FontString = _G["NecrosisSpellTimer"..index.."Text"]
		if SpellGroup[index] and SpellGroup[index].Name then
			texte = SpellGroup[index].Name
		else
			texte = "?"
		end
		if SpellGroup[index] and SpellGroup[index].SubName then
			texte = texte.." - "..SpellGroup[index].SubName
		else
			texte = texte.." - ?"
		end
		if texte == "? - ?" then
			f:Hide()
		else
			FontString:SetText(texte)
			f:Show()
		end
		return f
	end

	local FrameName = "NecrosisSpellTimer"..index
	local frame = CreateFrame("Frame", FrameName, UIParent)

	-- Définition de ses attributs
	frame:SetWidth(150)
	frame:SetHeight(10)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 3000, 3000)
	frame:Show()

	-- Définition de la Frame du texte
	local FontString = frame:CreateFontString(FrameName.."Text", "OVERLAY", "TextStatusBarText")

	FontString:SetWidth(150)
	FontString:SetHeight(10)
	FontString:SetJustifyH("CENTER")
	FontString:SetJustifyV("MIDDLE")
	FontString:SetTextColor(1, 1, 1)
	FontString:ClearAllPoints()
	FontString:SetPoint("LEFT", FrameName, "LEFT", 0, 0)
	FontString:Show()

	-- Définition du texte
	if SpellGroup[index] and SpellGroup[index].Name then
		texte = SpellGroup[index].Name
	else
		texte = "?"
	end
	if SpellGroup[index] and SpellGroup[index].SubName then
		texte = texte.." - "..SpellGroup[index].SubName
	else
		texte = texte.." - ?"
	end

	if texte == "? - ?" then
		frame:Hide()
	else
		FontString:SetText(texte)
		frame:Show()
	end

	
	OutputGroup(SpellGroup, index, "create")

	return frame
end

-- Creation of the timers || Création des timers
function Necrosis:AddFrame(FrameName)

	if _G[FrameName] then
		f = _G[FrameName]
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		f:Show()
		return _G[FrameName.."Text"], _G[FrameName.."Bar"]
	end

	-- Création de la frame principale du timer
	local frame = CreateFrame("Frame", FrameName, UIParent)

	-- Définition de ses attributs
	frame:SetWidth(150)
	frame:SetHeight(10)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 3000, 3000)
	frame:Show()

	--Définition de sa texture
	local texture = frame:CreateTexture(FrameName.."Texture", "BACKGROUND")

	texture:SetWidth(150)
	texture:SetHeight(10)
	texture:SetTexture(0, 0, 0, 0.5)
	texture:ClearAllPoints()
	texture:SetPoint(NecrosisConfig.SpellTimerJust, FrameName, NecrosisConfig.SpellTimerJust, 0, 0)
	texture:Show()

	-- Définition de ses textes
	-- Extérieur
	local FontString = frame:CreateFontString(FrameName.."OutText", "OVERLAY", "TextStatusBarText")

	FontString:SetWidth(150)
	FontString:SetHeight(10)
	FontString:SetTextColor(1, 1, 1)
	FontString:ClearAllPoints()

	if NecrosisConfig.SpellTimerPos == -1 then
		FontString:SetPoint("RIGHT", FrameName, "LEFT", -5, 1)
		FontString:SetJustifyH("RIGHT")
	else
		FontString:SetPoint("LEFT", FrameName, "RIGHT", 5, 1)
		FontString:SetJustifyH("LEFT")
	end
	FontString:Show()


	-- Définition de ses textes
	-- Intérieur
	FontString = frame:CreateFontString(FrameName.."Text", "OVERLAY", "GameFontNormalSmall")

	FontString:SetWidth(150)
	FontString:SetHeight(10)
	FontString:SetJustifyH("LEFT")
	FontString:SetJustifyV("MIDDLE")
	FontString:ClearAllPoints()
	FontString:SetPoint("LEFT", FrameName, "LEFT", 0, 0)
	FontString:Show()

	FontString:SetTextColor(1, 1, 1)

	-- Définition de la barre colorée
	local StatusBar = CreateFrame("StatusBar", FrameName.."Bar", frame)

	StatusBar:SetWidth(150)
	StatusBar:SetHeight(10)
	StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	StatusBar:SetStatusBarColor(1, 1, 0)
	StatusBar:SetFrameLevel(StatusBar:GetFrameLevel() - 1)
	StatusBar:ClearAllPoints()
	StatusBar:SetPoint(NecrosisConfig.SpellTimerJust, FrameName, NecrosisConfig.SpellTimerJust, 0, 0)
	StatusBar:Show()

	-- Définition de l'étincelle en bout de barre
	texture = StatusBar:CreateTexture(FrameName.."Spark", "OVERLAY")

	texture:SetWidth(32)
	texture:SetHeight(32)
	texture:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	texture:SetBlendMode("ADD")
	texture:ClearAllPoints()
	texture:SetPoint("CENTER", StatusBar, "LEFT", 0, 0)
	texture:Show()

	return FontString, StatusBar
end


------------------------------------------------------------------------------------------------------
-- FUNCTIONS TO UPDATE THE DISPLAY || FONCTION DE MISE À JOUR DE L'AFFICHAGE
------------------------------------------------------------------------------------------------------

function NecrosisUpdateTimer(tableau, Changement)
	if not (NecrosisConfig.TimerType == 1 and tableau[1]) then
		return
	end

	local LastPoint = {}
	LastPoint[1], LastPoint[2], LastPoint[3], LastPoint[4], LastPoint[5] = NecrosisTimerFrame0:GetPoint()
	local LastGroup = 0

	local yPosition = - NecrosisConfig.SensListe * 12

	-- smooth timers (if selected) || *Lisse* l'écoulement des timers si option sélectionnée
	local Now
	if NecrosisConfig.Smooth then
		Now = GetTime()
	else
		Now = floor(GetTime())
	end

	for index =  1, #tableau, 1 do
		-- Ca arrive quand on passe des timers textes aux timers graphiques
		if not tableau[index].Gtimer then break end

		-- selection of frames timer that vary with time || Sélection des frames du timer qui varient en fonction du temps
		local Frame = _G["NecrosisTimerFrame"..tableau[index].Gtimer]
		local StatusBar = _G["NecrosisTimerFrame"..tableau[index].Gtimer.."Bar"]
		local Spark = _G["NecrosisTimerFrame"..tableau[index].Gtimer.."Spark"]
		local Text = _G["NecrosisTimerFrame"..tableau[index].Gtimer.."OutText"]

		-- move frames to ensure they dont overlap || Déplacement des Frames si besoin pour qu'elles ne se chevauchent pas
		if Changement then
			-- if the frame belongs to a mob group, then move the whole group || Si les Frames appartiennent à un groupe de mob, et qu'on doit changer de groupe
			if not (tableau[index].Group == LastGroup) and tableau[index].Group > 3 then
				local f = CreateGroup(Changement, tableau[index].Group)
				LastPoint[5] = LastPoint[5] + 1.2 * yPosition
				f:ClearAllPoints()
				f:SetPoint(LastPoint[1], LastPoint[2], LastPoint[3], LastPoint[4], LastPoint[5])
				LastPoint[5] = LastPoint[5] + 0.2 * yPosition
				LastGroup = tableau[index].Group
			end
			Frame:ClearAllPoints()
			LastPoint[5] = LastPoint[5] + yPosition
			Frame:SetPoint(LastPoint[1], LastPoint[2], LastPoint[3], LastPoint[4], LastPoint[5])
		end

		-- creation of color timers || Création de la couleur des timers en fonction du temps
		local r, g
		local b = 37/255
		local b_end = tableau[index].TimeMax -- tableau[index].MaxBar tableau[index].TimeMax
		local PercentColor = (b_end - Now) / tableau[index].Time
		if PercentColor > 0.5 then
			r = (207/255) - (1 - PercentColor) * 2 * (207/255)
			g = 1
		else
			r = 1
			g = (207/255) - (0.5 - PercentColor) * 2 * (207/255)
		end

		-- calculate the position of the spark on the timer || Calcul de la position de l'étincelle sur la barre de status
		local sparkPosition = 150 * (b_end - Now) / tableau[index].Time
		if sparkPosition < 1 then sparkPosition = 1 end

		-- set the color and determine the portion to be filled || Définition de la couleur du timer et de la quantitée de jauge remplie
		StatusBar:SetValue(2 * b_end - (tableau[index].Time + Now))
		StatusBar:SetStatusBarColor(r, g, b)
		Spark:ClearAllPoints()
		Spark:SetPoint("CENTER", StatusBar, "LEFT", sparkPosition, 0)

		-- update the clock value on the timer || Affichage du chrono extérieur
		local minutes, secondes, affichage = 0, 0, nil
		secondes = b_end - floor(GetTime())
		minutes = floor(secondes / 60 )
		secondes = math.fmod(secondes, 60)

		if minutes > 9 then
			affichage = minutes..":"
		elseif minutes > 0 then
			affichage = "0"..minutes..":"
		else
			affichage = "0:"
		end

		if secondes > 9 then
			affichage = affichage..secondes
		else
			affichage = affichage.."0"..secondes
		end

		if (tableau[index].Type == 1 or tableau[index].Type == 3 
		and tableau[index].Target and not (tableau[index].Target == "")) then
			if NecrosisConfig.SpellTimerPos == 1 then
				affichage = affichage.." - "..tableau[index].Target
			else
				affichage = tableau[index].Target.." - "..affichage
			end
		end

		Text:SetText(affichage)
	end
end