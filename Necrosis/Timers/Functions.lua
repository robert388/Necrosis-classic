--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]
------------------------------------------------------------------------------------------------------

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

--[[
------------------------------------------------------------------------------------------------------
-- FUNCTIONS TO ADD TIMERS || FONCTIONS D'INSERTION

For 7.0 This was rewritten to use data driven logic based on the spell data in Warlock_Spells.
------------------------------------------------------------------------------------------------------
--]]
------------------------------------------------------------------------------------------------------
-- Helper routines
------------------------------------------------------------------------------------------------------

-- sort timers according to their group || On trie les timers selon leur groupe
local function Tri(SpellTimer, clef)
	return SpellTimer:sort(
		function (SubTab1, SubTab2)
			return SubTab1[clef] < SubTab2[clef]
		end)
end

-- defined timer groups || On définit les groupes de chaque Timer
local function Parsing(SpellGroup, SpellTimer)
	for index = 1, #SpellTimer, 1 do
		if SpellTimer[index].Group == 0 then
			local GroupeOK = false
			for i = 1, #SpellGroup, 1 do
				if ((SpellTimer[index].Type == i) and (i <= 3)) or
				   (SpellTimer[index].TargetGUID == SpellGroup[i].TargetGUID)
					then
					GroupeOK = true
					SpellTimer[index].Group = i
					SpellGroup[i].Visible = SpellGroup[i].Visible + 1
					break
				end
			end
			-- Create a new group if it doesnt exist || Si le groupe n'existe pas, on en crée un nouveau
			if not GroupeOK then
				SpellGroup:insert(
					{
						Name = SpellTimer[index].Target,
						SubName = SpellTimer[index].TargetLevel,
						TargetGUID = SpellTimer[index].TargetGUID,
						Visible = 1
					}
				)
				SpellTimer[index].Group = #SpellGroup
			end
		end
	end

	Tri(SpellTimer, "Group")
	return SpellGroup, SpellTimer
end

local function OutputTimer(reason, usage, index, Timer, note, override)
	if Necrosis.Debug.timers or override then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("OTimer::"
		.." ip'"..(tostring(index) or "nyl").."'"
		.." rp'"..(reason or "Timer").."'"
		.." up'"..(tostring(usage) or "nyl").."'"
		.." g'"..(tostring(Timer.SpellTimer[index].Group) or "nyl").."'"
		.." n'"..(tostring(Timer.SpellTimer[index].Name) or "nyl").."'"
		.." sec'"..(tostring(Timer.SpellTimer[index].Time) or "nyl").."'"
		.." T'"..(tostring(Timer.SpellTimer[index].Type) or "nyl").."'"
		.." u'"..(tostring(Timer.SpellTimer[index].Usage) or "nyl").."'"
		.." r'"..(tostring(Timer.SpellTimer[index].Remove) or "nyl").."'"
		.." tl'"..(tostring(Timer.SpellTimer[index].TargetLevel) or "nyl").."'"
		.." t'"..(tostring(Timer.SpellTimer[index].Target) or "nyl").."'"
		.." '"..(tostring(Timer.SpellTimer[index].TargetGUID) or "nyl").."'"
		
		.." '"..(tostring(note) or "nyl").."'"
		)
	else
		-- no output requested
	end
end

------------------------------------------------------------------------------------------------------
-- INSERT FUNCTIONS
------------------------------------------------------------------------------------------------------
--[[
Insert the requested timer(s) for the given spell.
Note: A spell could have ZERO or ONE or TWO timers!
- Zero: Should not get here
- One: such as curses or cool down such as health stones
- Two: Such Curse of Doom or Death Coil have both a use time and a cool down

Note: The way this code is written assumes any buff that WoW tracks on UI
and crosses login / reload does NOT have both a duration AND a cool down in Spells...
--]]
--[[
- Type (of timer)
	-- Type 0 = Pas de Timer || no timer
	-- Type 1 = Timer permanent principal || Standing main timer
	-- Type 2 = Timer permanent || main timer
	-- Type 3 = Timer de cooldown || cooldown timer
	-- Type 4 = Timer de malédiction || curse timer
	-- Type 5 = Timer de corruption || corruption timer
	-- Type 6 = Timer de combat || combat timer
--]]
local function InsertThisTimer(spell, cast_guid, Target, Timer, start_time, duration, note)
	-- 
	local target = Target
	local ttype = 0
	if target == nil or target == {} then
		target = {name = "", lvl = "", guid = "", }
	end

	local length = 0
	local length_max = 0
	if spell.Length and spell.Length > 0 then
		if start_time then
			length = floor(duration - GetTime() + start_time)
			length_max = floor(start_time + duration)
		else 
			length = spell.Length
			length_max = floor(GetTime() + spell.Length)
		end

		if spell.Buff then
			ttype = 2 -- can cancel or lose
		else
			ttype = 6 -- remove once out of combat
		end
			
		-- insert an entry into the table || Insertion de l'entrée dans le tableau
		Timer.SpellTimer:insert(
			{
				Name = spell.Name,
				Time = length,
				TimeMax = length_max,
				MaxBar = spell.Length,
				Type = ttype,
				Usage = spell.Usage,
				Target = target.name,
				TargetGUID = target.guid,
				TargetLevel = target.lvl,
				CastGUID = cast_guid,
				Group = spell.Group or 0,
				Gtimer = nil
			}
		)
		OutputTimer("Insert", spell.Usage, #Timer.SpellTimer, Timer, note)
	end
	
	-- check for a cool down to show
	if spell.Cooldown and (spell.Cooldown > 0) then
		if start_time then
			length = floor(duration - GetTime() + start_time)
			length_max = floor(start_time + duration)
		else 
			length = spell.Cooldown
			length_max = floor(GetTime() + spell.Cooldown)
		end
		
		Timer = Necrosis:RetraitTimerParNom(spell.Name, Timer, "Remove cool down")
		-- insert an entry into the table || Insertion de l'entrée dans le tableau
		Timer.SpellTimer:insert(
			{
				Name = spell.Name,
				Time = length,
				TimeMax = length_max,
				MaxBar = spell.Cooldown,
				Type = 2, -- spell cool down, cannot cancel
				Usage = spell.Usage,
				Target = "", -- target.name,
				TargetGUID = "", -- target.guid,
				TargetLevel = "", -- target.lvl,
				CastGUID = nil,
				Group = 0, --spell.Group or 0,
				Gtimer = nil
			}
		)
		OutputTimer("Insert Cool down", spell.Usage, #Timer.SpellTimer, Timer, note)
	end

	-- attach a graphical timer if enabled || Association d'un timer graphique au timer
	-- associate it to the frame (if present) || Si il y a une frame timer de libérée, on l'associe au timer
	if NecrosisConfig.TimerType == 1 then
		local TimerLibre = nil
		for index, valeur in ipairs(Timer.TimerTable) do
			if not valeur then
				TimerLibre = index
				Timer.TimerTable[index] = true
				break
			end
		end
		-- if there is no frame, add one || Si il n'y a pas de frame de libérée, on rajoute une frame
		if not TimerLibre then
			Timer.TimerTable:insert(true)
			TimerLibre = #Timer.TimerTable
		end
		-- update the timer display || Association effective au timer
		Timer.SpellTimer[#Timer.SpellTimer].Gtimer = TimerLibre
		local FontString, StatusBar = Necrosis:AddFrame("NecrosisTimerFrame"..TimerLibre)
		FontString:SetText(Timer.SpellTimer[#Timer.SpellTimer].Name)
		StatusBar:SetMinMaxValues(
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax - Timer.SpellTimer[#Timer.SpellTimer].Time,
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax
		)
	end

	if NecrosisConfig.TimerType > 0 then
		-- sort the timers by type || Tri des entrées par type de sort
		Tri(Timer.SpellTimer, "Type")

		-- Create timers by mob group || Création des groupes (noms des mobs) des timers
		Timer.SpellGroup, Timer.SpellTimer = Parsing(Timer.SpellGroup, Timer.SpellTimer)

		-- update the display || On met à jour l'affichage
		NecrosisUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)
	end

	return Timer
end

function Necrosis:TimerInsert(Cast, Target, Timer, note, start_time, duration, maxi)
	local spell = Necrosis.GetSpell(Cast.usage) 

	if spell.Timer then
		-- Cleanup, if needed
		Timer = Necrosis:RemoveTimerByNameAndGuid(spell.Name, Target.guid, Timer, note)

		Timer = InsertThisTimer(spell, Cast.Guid, Target, Timer, start_time, duration, note)
	else
		-- safety - no timer associated with spell
	end
	return Timer
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS TO REMOVE TIMERS || FONCTIONS DE RETRAIT
------------------------------------------------------------------------------------------------------

-- delete a timer by its index || Connaissant l'index du Timer dans la liste, on le supprime
function Necrosis:RetraitTimerParIndex(index, Timer, note)

	if NecrosisConfig.TimerType > 0 then
		-- remove the graphical timer || Suppression du timer graphique
		if NecrosisConfig.TimerType == 1 and Timer.SpellTimer[index] then
			if Timer.SpellTimer[index].Gtimer and Timer.TimerTable[Timer.SpellTimer[index].Gtimer] then
				Timer.TimerTable[Timer.SpellTimer[index].Gtimer] = false
				_G["NecrosisTimerFrame"..Timer.SpellTimer[index].Gtimer]:Hide()
			end
		end

		-- remove the mob group timer || Suppression du timer du groupe de mob
		if Timer.SpellTimer[index] and Timer.SpellGroup[Timer.SpellTimer[index].Group] then
			if Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible  then
				Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible = Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible - 1
				-- Hide the frame groups if empty || On cache la Frame des groupes si elle est vide
				if Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible <= 0 then
					local frameGroup = _G["NecrosisSpellTimer"..Timer.SpellTimer[index].Group]
					if frameGroup then frameGroup:Hide() end
				end
			end
		end
	end

	if note == nil then
		-- Cheat: Was called from another remove so do not output twice
	else 
		OutputTimer("RetraitTimerParIndex", "", index, Timer, note)
	end

	-- remove the timer from the list || On enlève le timer de la liste
	Timer.SpellTimer:remove(index)

	-- update the display || On met à jour l'affichage
	NecrosisUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)

	return Timer
end

-- remove a timer by name || Si on veut supprimer spécifiquement un Timer...
function Necrosis:RetraitTimerParNom(name, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].Name == name then
			OutputTimer("RetraitTimerParNom", "", index, Timer, note)
			Timer = self:RetraitTimerParIndex(index, Timer)
			break
		end
	end
	return Timer
end

function Necrosis:RetraitTimerParGuid(guid, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].TargetGUID == guid then
			OutputTimer("RetraitTimerParGuid", "", index, Timer, note)
			Timer = self:RetraitTimerParIndex(index, Timer)
			break
		end
	end
	return Timer
end

function Necrosis:RetraitTimerParCast(guid, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("RetraitTimer::"
.." g'"..(tostring(guid)).."'"
.." tg'"..(tostring(Timer.SpellTimer[index].CastGUID)).."'"
)
--]]
		if Timer.SpellTimer[index].CastGUID == guid then
			OutputTimer("RetraitTimerParCast", "", index, Timer, note)
			Timer = self:RetraitTimerParIndex(index, Timer)
			break
		end
	end
	return Timer
end

function Necrosis:RemoveTimerByNameAndGuid(name, guid, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].Name == name
		and Timer.SpellTimer[index].TargetGUID == guid then
			OutputTimer("RemoveTimerByNameAndGuid", "", index, Timer, note)
			Timer = self:RetraitTimerParIndex(index, Timer)
			break
		end
	end
	return Timer
end

-- remove combat timers  || Fonction pour enlever les timers de combat lors de la regen
function Necrosis:RetraitTimerCombat(Timer, note)
	local top = #Timer.SpellTimer
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index] then
			-- remove if its a cooldown timer || Si les cooldowns sont nominatifs, on enlève le nom
			if Timer.SpellTimer[index].Type == 3 then
				Timer.SpellTimer[index].Target = ""
				Timer.SpellTimer[index].TargetGUID = ""
				Timer.SpellTimer[index].TargetLevel = ""
			end
			-- other combat timers || Enlevage des timers de combat
			if Timer.SpellTimer[index].Type == 4
				or Timer.SpellTimer[index].Type == 5
				or Timer.SpellTimer[index].Type == 6
				then
					OutputTimer("RetraitTimerCombat", "", index, Timer, note)
					Timer = self:RetraitTimerParIndex(index, Timer)
			end
		end
	end

	if NecrosisConfig.TimerType > 0 then
		local index = 4
		while #Timer.SpellGroup >= 4 do
			if _G["NecrosisSpellTimer"..index] then _G["NecrosisSpellTimer"..index]:Hide() end
			Timer.SpellGroup:remove()

			if Necrosis.Debug.timers then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("RetraitTimerCombat"
				.." Group '"..tostring(index or "nyl").."'"
				)
			end
			index = index + 1
		end
	end

	return Timer
end

-- Debug
function Necrosis:DumpTimers(Timer)
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("::: Dump Timers start "..tostring(#Timer.SpellTimer))
	for index = 1, #Timer.SpellTimer, 1 do
		OutputTimer("Dump", "", index, Timer, "dump", true)
	end
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("::: Dump Timers end")
end

--[[
if Necrosis.Debug.events then
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("RetraitTimerParGuid "..note
	.." i'"..tostring(index or "nyl").."'"
	.." g'"..tostring(guid or "nyl").."'"
	.." tg'"..tostring(Timer.SpellTimer[index].TargetGUID or "nyl").."'"
	)
end
--]]