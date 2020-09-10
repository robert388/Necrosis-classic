--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- One defines G as being the table containing all the existing frames.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- Message handler (CONSOLE, CHAT, MESSAGE SYSTEM)
------------------------------------------------------------------------------------------------------
--[[ As of Sep 2019, SendChatMessage was made hardware protected to public channels
- SAY/YELL seems hardware event protected while outdoors but not inside instances/raids
- public channels require hw events outdoors/indoors
- WHISPER is unaffected
--]]
function Necrosis:Msg(msg, type)
	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(":Msg"
		.." "..(tostring(type))..":"
		.." '"..(tostring(msg)).."'"
		)
	end

	if msg then
		inInstance, _ = IsInInstance()

		-- dispatch the message to the appropriate chat channel depending on the message type
		if (type == "WORLD") then
			if UnitInRaid("player") then
				-- send to all raid members
				SendChatMessage(msg, "RAID")
			elseif UnitInParty("player") then
				-- send to party members
				SendChatMessage(msg, "PARTY")
			else
				-- not in a group so lets use the 'say' channel
				if (inInstance) then SendChatMessage(msg, "SAY") end
			end
		else
			-- Add some color to our message :D
			msg = self:MsgAddColor(msg)
			local Intro = "|CFFFF00FFNe|CFFFF50FFcr|CFFFF99FFos|CFFFFC4FFis|CFFFFFFFF: "..msg.."|r"
			if NecrosisConfig.ChatType then
				-- ...... on the first chat frame
				ChatFrame1:AddMessage(Intro, 1.0, 0.7, 1.0, 1.0, UIERRORS_HOLD_TIME)
			else
				-- ...... on the middle of the screen
				UIErrorsFrame:AddMessage(Intro, 1.0, 0.7, 1.0, 1.0, UIERRORS_HOLD_TIME)
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Color functions
------------------------------------------------------------------------------------------------------

-- Replace any color strings in the message with its associated value
function Necrosis:MsgAddColor(msg)
	if type(msg) == "string" then
		msg = msg:gsub("<white>", "|CFFFFFFFF")
		msg = msg:gsub("<lightBlue>", "|CFF99CCFF")
		msg = msg:gsub("<brightGreen>", "|CFF00FF00")
		msg = msg:gsub("<lightGreen2>", "|CFF66FF66")
		msg = msg:gsub("<lightGreen1>", "|CFF99FF66")
		msg = msg:gsub("<yellowGreen>", "|CFFCCFF66")
		msg = msg:gsub("<lightYellow>", "|CFFFFFF66")
		msg = msg:gsub("<darkYellow>", "|CFFFFCC00")
		msg = msg:gsub("<lightOrange>", "|CFFFFCC66")
		msg = msg:gsub("<dirtyOrange>", "|CFFFF9933")
		msg = msg:gsub("<darkOrange>", "|CFFFF6600")
		msg = msg:gsub("<redOrange>", "|CFFFF3300")
		msg = msg:gsub("<red>", "|CFFFF0000")
		msg = msg:gsub("<lightRed>", "|CFFFF5555")
		msg = msg:gsub("<lightPurple1>", "|CFFFFC4FF")
		msg = msg:gsub("<lightPurple2>", "|CFFFF99FF")
		msg = msg:gsub("<purple>", "|CFFFF50FF")
		msg = msg:gsub("<darkPurple1>", "|CFFFF00FF")
		msg = msg:gsub("<darkPurple2>", "|CFFB700B7")
		msg = msg:gsub("<close>", "|r")
	end
	return msg
end

-- Adjusts the timer color based on the percentage of time left.
function NecrosisTimerColor(percent)
	local color = "<brightGreen>"
	if (percent < 10) then
		color = "<red>"
	elseif (percent < 20) then
		color = "<redOrange>"
	elseif (percent < 30) then
		color = "<darkOrange>"
	elseif (percent < 40) then
		color = "<dirtyOrange>"
	elseif (percent < 50) then
		color = "<darkYellow>"
	elseif (percent < 60) then
		color = "<lightYellow>"
	elseif (percent < 70) then
		color = "<yellowGreen>"
	elseif (percent < 80) then
		color = "<lightGreen1>"
	elseif (percent < 90) then
		color = "<lightGreen2>"
	end
	return color
end

------------------------------------------------------------------------------------------------------
-- Replace user-friendly string variables in the invocation messages
------------------------------------------------------------------------------------------------------
local function MsgReplace(msg, player, target, pet)
	msg = msg:gsub("<emote>", "")
	msg = msg:gsub("<after>", "")
	msg = msg:gsub("<sacrifice>", "")
	msg = msg:gsub("<yell>", "")

		msg = msg:gsub("<player>", player)
		msg = msg:gsub("<target>", target)
		msg = msg:gsub("<pet>", pet)

	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("MsgReplace"
		.." '"..(tostring(msg) or "nyl").."'"
		)
	end

	return msg
end

local function Out(Spell, Speech, msg, style)
	local player = UnitName("player") or UNKNOWN
	local target = Spell.TargetName or UNKNOWN
	local pet = Speech.DemonName or UNKNOWN
	local s = style or "USER"
	
	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Out"
		.." n'"..(tostring(player)).."'"
		.." t'"..(tostring(target)).."'"
		.." p'"..(tostring(pet)).."'"
		.." s'"..(tostring(s).."'")
		)
	end

	Necrosis:Msg(MsgReplace(msg, player, target, pet), style)
end
------------------------------------------------------------------------------------------------------
-- Handles the posting of messages while casting a spell.
------------------------------------------------------------------------------------------------------
function Necrosis:Speech_It(Spell, Speeches, metatable)
	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It ::"
		.." sum'"..tostring(NecrosisConfig.PlayerSummons).."'"
		.." dem'"..tostring(NecrosisConfig.DemonSummon).."'"
		.." soul'"..tostring(NecrosisConfig.RoSSummon).."'"
		)
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It"
		.." n'"..(tostring(Spell.Name) or "nyl").."'"
		.." mnt'"..(tostring(Necrosis.IsSpellMount(Spell.Name)) or "nyl").."'"
		.." rez'"..(tostring(Necrosis.IsSpellRez(Spell.Name)) or "nyl").."'"
		.." sum'"..(tostring(Spell.Name == Necrosis.GetSpellName("summoning")) or "nyl").."'"
		.." dem'"..(tostring(Necrosis.IsSpellDemon(Spell.Name)) or "nyl").."'"
		)
	end

	-- messages to be posted while summoning a mount
	if Necrosis.IsSpellMount(Spell.Name) then -- 1 or 2 
		Speeches.SpellSucceed.Steed = setmetatable({}, metatable)
		if NecrosisConfig.SteedSummon and NecrosisConfig.ChatMsg and self.Speech.Demon[7] then
			local tempnum = math.random(1, #self.Speech.Demon[7])
			while tempnum == Speeches.LastSpeech.Steed and #self.Speech.Demon[7] >= 2 do
				tempnum = math.random(1, #self.Speech.Demon[7])
			end
			Speeches.LastSpeech.Steed = tempnum
			for i in ipairs(self.Speech.Demon[7][tempnum]) do
				if self.Speech.Demon[7][tempnum][i]:find("<after>") then
					Speeches.SpellSucceed.Steed:insert(self.Speech.Demon[7][tempnum][i])
				else
					Out(Spell, Speeches, self.Speech.Demon[7][tempnum][i], "WORLD")
				end
			end
		end
	-- messages to be posted while casting 'Soulstone' on a friendly target
	elseif Necrosis.IsSpellRez(Spell.Name) -- 11  
--		and not (Spell.TargetName == UnitName("player")) 
		then
			local tempnum = 1
		Speeches.SpellSucceed.Rez = setmetatable({}, metatable)
		if NecrosisConfig.PlayerSS and NecrosisConfig.ChatMsg and self.Speech.Rez then
			if NecrosisConfig.PlayerSSSM then
				tempnum = 0 -- short message
			else
				tempnum = math.random(1, #self.Speech.Rez)
				-- do not use the same speech twice in a row
				while tempnum == Speeches.LastSpeech.Rez and #self.Speech.Rez >= 3 do
					tempnum = math.random(1, #self.Speech.Rez)
				end
			end
			Speeches.LastSpeech.Rez = tempnum
			for i in ipairs(self.Speech.Rez[tempnum]) do
				if self.Speech.Rez[tempnum][i]:find("<after>") then
					Speeches.SpellSucceed.Rez:insert(self.Speech.Rez[tempnum][i])
				else
					Out(Spell, Speeches, self.Speech.Rez[tempnum][i], "WORLD")
				end
			end
		end
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It SS::::"
.." chat'"..tostring(NecrosisConfig.ChatMsg).."'"
.." sum'"..tostring(NecrosisConfig.PlayerSS).."'"
.." SM'"..tostring(NecrosisConfig.PlayerSSSM).."'"
.." #'"..tostring(tempnum).."'"
)
--]]
	-- messages to be posted while casting 'Ritual of Summoning'
	elseif Spell.Name == Necrosis.GetSpellName("summoning") then -- 37
			local tempnum = 1
		-- Output the victim if in party or raid
		Speeches.SpellSucceed.TP = setmetatable({}, metatable)
		if NecrosisConfig.PlayerSummons and NecrosisConfig.ChatMsg then
			if NecrosisConfig.PlayerSummonsSM then
				tempnum = 0 -- short message
			else
				tempnum = math.random(1, #self.Speech.TP)
				-- do not use the same speech twice in a row
				while tempnum == Speeches.LastSpeech.TP and #self.Speech.TP >= 3 do
					tempnum = math.random(1, #self.Speech.TP)
				end
			end
			Speeches.LastSpeech.TP = tempnum
			for i in ipairs(self.Speech.TP[tempnum]) do
				if self.Speech.TP[tempnum][i]:find("<after>") then
					Speeches.SpellSucceed.TP:insert(self.Speech.TP[tempnum][i])
				else
					Out(Spell, Speeches, self.Speech.TP[tempnum][i], "WORLD")
				end
			end
		end
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It summon::::"
.." chat'"..tostring(NecrosisConfig.ChatMsg).."'"
.." sum'"..tostring(NecrosisConfig.PlayerSummons).."'"
.." SM'"..tostring(NecrosisConfig.PlayerSummonsSM).."'"
.." #'"..tostring(tempnum).."'"
)
--]]
		AlphaBuffMenu = 1
		AlphaBuffVar = GetTime() + 3
	-- messages to be posted while summoning a pet demon
	elseif Necrosis.IsSpellDemon(Spell.Name) then
		Speeches.SpellSucceed.Pet = setmetatable({}, metatable)
		Speeches.SpellSucceed.Sacrifice = setmetatable({}, metatable)
		
		local id, usage, timer = Necrosis.GetSpellByName(Spell.Name)
		Speeches.DemonName = NecrosisConfig.PetInfo[usage] or "" 
		if usage -- safety...
		then
			if usage == "imp" then Speeches.DemonId = 1 
			elseif usage == "voidwalker" then Speeches.DemonId = 2 
			elseif usage == "succubus"   then Speeches.DemonId = 3 
			elseif usage == "felhunter"  then Speeches.DemonId = 4 
			else -- should never happen...
			end
		else
			-- should never happen...
		end

		if NecrosisConfig.DemonSummon and NecrosisConfig.ChatMsg then
			local generalSpeechNum = math.random(1, 10) -- show general speech if num is 9 or 10

			local dn = 0
			if (NecrosisConfig.PetInfo[usage] == "" or generalSpeechNum > 8) and self.Speech.Demon[6] then
				dn = 6
			elseif self.Speech.Demon[Speeches.DemonId] then
				dn = Speeches.DemonId
			else
				dn = 0 -- ??
			end

			if dn > 0 then
				local tempnum = math.random(1, #self.Speech.Demon[dn])
				while tempnum == Speeches.LastSpeech.Pet and #self.Speech.Demon[dn] >= 2 do
					tempnum = math.random(1, #self.Speech.Demon[dn])
				end
				if Necrosis.Debug.speech then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It summon "
						.." '"..(tostring(Spell.Name)).."'"
						.." '"..(tostring(Speeches.DemonName)).."'"
						.." '"..(tostring(Speeches.DemonId)).."'"
						.." #'"..(tostring(generalSpeechNum)).."'"
						.." #'"..(tostring(dn)).."'"
						.." '"..(tostring(NecrosisConfig.PetName[dn])).."'"
						.." picked #'"..(tostring(tempnum) or "nyl").."'"
						.." last #'"..(tostring(Speeches.LastSpeech.Pet) or "nyl").."'"
					)
				end
				Speeches.LastSpeech.Pet = tempnum
				for i in ipairs(self.Speech.Demon[dn][tempnum]) do
					if Necrosis.Debug.speech then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It summon "
						.." i'"..(tostring(i) or "nyl").."'"
						.." '"..(tostring(self.Speech.Demon[dn][tempnum][i]) or "nyl").."'"
						)
					end
					if self.Speech.Demon[dn][tempnum][i]:find("<after>") then
						Speeches.SpellSucceed.Pet:insert(
							self.Speech.Demon[dn][tempnum][i]
						)
					elseif self.Speech.Demon[dn][tempnum][i]:find("<sacrifice>")then
						Speeches.SpellSucceed.Sacrifice:insert(
							self.Speech.Demon[dn][tempnum][i]
						)
					else
						Out(Spell, Speeches, self.Speech.Demon[dn][tempnum][i], "WORLD")
					end
				end
			end
		end
		AlphaPetMenu = 1
		AlphaPetVar = GetTime() + 3
	end
	return Speeches
end

------------------------------------------------------------------------------------------------------
-- Handles the posting of messages after a spell has been cast.
------------------------------------------------------------------------------------------------------
function Necrosis:Speech_Then(Spell, Speech)
	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_Then"
		.." n'"..(tostring(Spell.Name) or "nyl").."'"
		.." mnt'"..(tostring(Necrosis.IsSpellMount(Spell.Name)) or "nyl").."'"
		.." rez'"..(tostring(Necrosis.IsSpellRez(Spell.Name)) or "nyl").."'"
		.." sum'"..(tostring(Spell.Name == Necrosis.GetSpellName("summoning")) or "nyl").."'"
		.." dem'"..(tostring(Necrosis.IsSpellDemon(Spell.Name)) or "nyl").."'"
		)
	end
	
	-- messages to be posted after a mount is summoned.
	if Necrosis.IsSpellMount(Spell.Name) then -- 1 or 2 
		for i in ipairs(Speech.SpellSucceed.Steed) do
			Out(Spell, Speech.SpellSucceed, Speech.Steed[i], "USER")
		end
		Speech.Steed = {}
		local f = _G[Necrosis.Warlock_Buttons.mounts.f]
		if f then
			f:SetNormalTexture("Interface\\Addons\\Necrosis\\UI\\MountButton-02")
		end
	-- messages to be posted after 'Soulstone' is cast
	elseif Necrosis.IsSpellRez(Spell.Name) then -- 11
		for i in ipairs(Speech.SpellSucceed.Rez) do
			Out(Spell, Speech, Speech.SpellSucceed.Rez[i], "WORLD")
		end
		Speech.Rez = {}
	-- messages to be posted after 'Ritual of Summoning' is cast
	elseif Spell.Name == Necrosis.GetSpellName("summoning") then -- 37 
		for i in ipairs(Speech.SpellSucceed.TP) do
			Out(Spell, Speech, Speech.SpellSucceed.TP[i], "WORLD")
		end
		Speech.TP = {}
	-- messages to be posted after sacrificing a demon
	elseif Spell.Name == Necrosis.GetSpellName("sacrifice") then -- 44 
		for i in ipairs(Speech.SpellSucceed.Sacrifice) do
			Out(Spell, Speech, Speech.SpellSucceed.Sacrifice[i], "WORLD")
		end
		Speech.Sacrifice = {}
	-- messages to be posted after summoning a demon
	elseif Necrosis.IsSpellDemon(Spell.Name) then
		for i in ipairs(Speech.SpellSucceed.Pet) do
			Out(Spell, Speech, Speech.SpellSucceed.Pet[i], "WORLD")
		end
		Speech.Pet = {}
	end

	return Speech.SpellSucceed
end
