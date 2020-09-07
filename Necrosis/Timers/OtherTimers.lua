--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- NON-GRAPHICAL TIMERS FUNCTIONS || FONCTIONS D'AFFICHAGE DES TIMERS NON GRAPHIQUES
------------------------------------------------------------------------------------------------------

-- Displays the resurrection timer on the soul stone button
function Necrosis:RezStoneUpdate(SpellTimer)
	local Time, TimeMax, Minutes, Secondes
	for index, valeur in ipairs(SpellTimer) do
		if Necrosis.IsSpellRez(Necrosis.GetSpellName(SpellTimer[index].Usage)) then 
			Time = valeur.Time
			TimeMax = valeur.TimeMax
			break
		end
	end

	local ss = Necrosis.Warlock_Buttons.soul_stone.f
	local f = _G[ss]
	if Time then
		Secondes = TimeMax - floor(GetTime())
		Minutes = floor(Secondes/60)
		Secondes = mod(Secondes, 60)

		if (Minutes > 0) then
			if f then f.font_string:SetText("|CFFFFC4FF"..string.format("%02d",tostring(Minutes)).."|r") end -- white
		else
			if f then f.font_string:SetText("|CFFFF00FF"..tostring(Secondes).."|r") end -- purple
		end
	else
		if f then f.font_string:SetText("") end -- cleanup for safety
	end
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("RezStoneUpdate"
.." t'"..(tostring(Time)).."'"
.." m'"..(tostring(Minutes)).."'"
.." s'"..(tostring(Secondes)).."'"
.." ss'"..(tostring(ss)).."'"
.." f'"..(tostring(f)).."'"
)
--]]
end

-- Displays the resurrection timer in the sphere || Permet l'affichage du timer de rez dans la Sphere
function Necrosis:RezTimerUpdate(SpellTimer, LastUpdate)
	local Time, TimeMax, Minutes, Secondes
	for index, valeur in ipairs(SpellTimer) do
		if Necrosis.IsSpellRez(valeur) then 
			Time = valeur.Time
			TimeMax = valeur.TimeMax
			break
		end
	end

	local f = _G[Necrosis.Warlock_Buttons.main.f]
	if not Time then
		NecrosisShardCount:SetText("???")
		f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")
		return LastUpdate
	end

	Secondes = TimeMax - floor(GetTime())
	Minutes = floor(Secondes/60)
	Secondes = mod(Secondes, 60)

	-- Le timer numérique
	if NecrosisConfig.CountType == 3 then
		if (Minutes > 0) then
			NecrosisShardCount:SetText(Minutes.." m")
		else
			NecrosisShardCount:SetText(Secondes)
		end
	end
	-- Le timer graphique
	if NecrosisConfig.Circle == 2 then
		if (Minutes >= 16) then
			if not (LastUpdate == "Turquoise\\Shard"..(Minutes - 15)) then
				LastUpdate = "Turquoise\\Shard"..(Minutes - 15)
				f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..LastUpdate)
			end
		elseif (Minutes >= 1 or Secondes >= 33) then
			if not (LastUpdate == "Orange\\Shard"..(Minutes + 1)) then
				LastUpdate = "Orange\\Shard"..(Minutes + 1)
				f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..LastUpdate)
			end
		elseif not (LastUpdate == "Rose\\Shard"..Secondes) then
			LastUpdate = "Rose\\Shard"..Secondes
			f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..LastUpdate)
		end
	end

	return LastUpdate
end

-- Allows the viewing of recorded timers || Permet l'affichage des timers textuels
-- and other textual timers || Allows the posting of text timers
function Necrosis:TextTimerUpdate(SpellTimer, SpellGroup)
	if not SpellTimer[1] then
		NecrosisListSpells:SetText("")
		return
	end

	local Now = floor(GetTime())
	local minutes = 0
	local seconds = 0
	local display = ""

	local LastGroup = 0

	for index in ipairs(SpellTimer) do
		-- Changement de la couleur suivant le temps restant
		local percent = (floor(SpellTimer[index].TimeMax - Now) / SpellTimer[index].Time)*100
		local color = NecrosisTimerColor(percent)

		-- Affichage de l'entête si on change de groupe
		if not (SpellTimer[index].Group == LastGroup) and SpellTimer[index].Group > 3 then
			if SpellTimer[index].Group and SpellGroup[SpellTimer[index].Group] then
				if SpellGroup[SpellTimer[index].Group].Name then
					display = display.."<purple>-------------------------------\n"
					display = display..SpellGroup[SpellTimer[index].Group].Name
					display = display.." - "
					display = display..SpellGroup[SpellTimer[index].Group].SubName
					display = display.."\n-------------------------------<close>\n<white>"
				end
			end
			LastGroup = SpellTimer[index].Group
		end

		-- Affichage du temps restant
		seconds = SpellTimer[index].TimeMax - Now
		minutes = floor(seconds/60);
		seconds = mod(seconds, 60)
		if (minutes > 0) then
			if (minutes > 9) then
				display = display..minutes..":"
			else
				display = display.."0"..minutes..":"
			end
		else
			display = display.."0:"
		end
		if (seconds > 9) then
			display = display..seconds
		else
			display = display.."0"..seconds
		end
		display = display.." - <close>"..color..SpellTimer[index].Name.."<close>"
		
		if (SpellTimer[index].Target == nil) then
			SpellTimer[index].Target = "";
		end
		
		if (SpellTimer[index].Type == 1)
			and not (SpellTimer[index].Target == "")
			then
				display = display.."<white> - "..SpellTimer[index].Target.."<close>\n";
		else
			display = display.."\n";
		end
	end
	display = self:MsgAddColor(display)
	NecrosisListSpells:SetText(display)
end