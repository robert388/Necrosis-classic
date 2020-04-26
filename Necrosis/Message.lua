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
	if msg then
		inInstance, _ = IsInInstance()

		-- dispatch the message to the appropriate chat channel depending on the message type
		if (type == "WORLD") then
			local groupMembersCount = GetNumGroupMembers()
			if (groupMembersCount > 5) then
				-- send to all raid members
				SendChatMessage(msg, "RAID")
			elseif (groupMembersCount > 0) then
				-- send to party members
				SendChatMessage(msg, "PARTY")
			else
				-- not in a group so lets use the 'say' channel
				if (inInstance) then SendChatMessage(msg, "SAY") end
			end
		elseif (type == "PARTY") then
			SendChatMessage(msg, "PARTY")
		elseif (type == "RAID") then
			SendChatMessage(msg, "RAID")
		elseif (type == "SAY") then
			if (inInstance) then SendChatMessage(msg, "SAY") end
		elseif (type == "EMOTE") then
			if (inInstance) then SendChatMessage(msg, "EMOTE") end
		elseif (type == "YELL") then
			if (inInstance) then SendChatMessage(msg, "YELL") end
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
function Necrosis:MsgReplace(msg, target, pet)
	msg = msg:gsub("<player>", UnitName("player"))
	msg = msg:gsub("<emote>", "")
	msg = msg:gsub("<after>", "")
	msg = msg:gsub("<sacrifice>", "")
	msg = msg:gsub("<yell>", "")
	if target then
		msg = msg:gsub("<target>", target)
	end
	if pet then
		msg = msg:gsub("<pet>", pet)
	end

	if Necrosis.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("MsgReplace"
		.." '"..(tostring(msg) or "nyl").."'"
		)
	end

	return msg
end

local function Out(msg)
	Necrosis:Msg(msg)
end
------------------------------------------------------------------------------------------------------
-- Handles the posting of messages while casting a spell.
------------------------------------------------------------------------------------------------------
function Necrosis:Speech_It(Spell, Speeches, metatable)

	-- messages to be posted while summoning a mount
	if Necrosis.IsSpellMount(Spell.Name) then -- 1 or 2 
		if Necrosis.Debug.speech then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It mount"
			.." n'"..(tostring(Spell.Name) or "nyl").."'"
			)
		end
		Speeches.SpellSucceed.Steed = setmetatable({}, metatable)
		if NecrosisConfig.SteedSummon and NecrosisConfig.ChatMsg and self.Speech.Demon[7] and not NecrosisConfig.SM then
			local tempnum = math.random(1, #self.Speech.Demon[7])
			while tempnum == Speeches.LastSpeech.Steed and #self.Speech.Demon[7] >= 2 do
				tempnum = math.random(1, #self.Speech.Demon[7])
			end
			Speeches.LastSpeech.Steed = tempnum
			for i in ipairs(self.Speech.Demon[7][tempnum]) do
				if self.Speech.Demon[7][tempnum][i]:find("<after>") then
					Speeches.SpellSucceed.Steed:insert(self.Speech.Demon[7][tempnum][i])
				elseif self.Speech.Demon[7][tempnum][i]:find("<emote>") then
					self:Msg(self:MsgReplace(self.Speech.Demon[7][tempnum][i]), "EMOTE")
				elseif self.Speech.Demon[7][tempnum][i]:find("<yell>") then
					self:Msg(self:MsgReplace(self.Speech.Demon[7][tempnum][i]), "YELL")
				else
					self:Msg(self:MsgReplace(self.Speech.Demon[7][tempnum][i]), "SAY")
				end
			end
		end
	-- messages to be posted while casting 'Soulstone' on a friendly target
	elseif Necrosis.IsSpellRez(Spell.Name) -- 11  
		and not (Spell.TargetName == UnitName("player")) then
		if Necrosis.Debug.speech then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It soul stone"
			.." n'"..(tostring(Spell.Name) or "nyl").."'"
			)
		end
		Speeches.SpellSucceed.Rez = setmetatable({}, metatable)
		if (NecrosisConfig.ChatMsg or NecrosisConfig.SM) and self.Speech.Rez then
			local tempnum = math.random(1, #self.Speech.Rez)
			while tempnum == Speeches.LastSpeech.Rez and #self.Speech.Rez >= 2 do
				tempnum = math.random(1, #self.Speech.Rez)
			end
			Speeches.LastSpeech.Rez = tempnum
			for i in ipairs(self.Speech.Rez[tempnum]) do
				if self.Speech.Rez[tempnum][i]:find("<after>") then
					Speeches.SpellSucceed.Rez:insert(self.Speech.Rez[tempnum][i])
				elseif self.Speech.Rez[tempnum][i]:find("<emote>") then
					self:Msg(self:MsgReplace(self.Speech.Rez[tempnum][i], Spell.TargetName), "EMOTE")
				elseif self.Speech.Rez[tempnum][i]:find("<yell>") then
					self:Msg(self:MsgReplace(self.Speech.Rez[tempnum][i], Spell.TargetName), "YELL")
				else
					self:Msg(self:MsgReplace(self.Speech.Rez[tempnum][i], Spell.TargetName), "WORLD")
				end
			end
		end
	-- messages to be posted while casting 'Ritual of Summoning'
	elseif Spell.Name == Necrosis:GetSpellName("summoning") then -- 37
		if Necrosis.Debug.speech then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It Ritual"
			.." n'"..(tostring(Spell.Name) or "nyl").."'"
			)
		end
		Speeches.SpellSucceed.TP = setmetatable({}, metatable)
		if (NecrosisConfig.ChatMsg or NecrosisConfig.SM) and self.Speech.TP then
			local tempnum = math.random(1, #self.Speech.TP)
			while tempnum == Speeches.LastSpeech.TP and #self.Speech.TP >= 2 do
				tempnum = math.random(1, #self.Speech.TP)
			end
			Speeches.LastSpeech.TP = tempnum
			for i in ipairs(self.Speech.TP[tempnum]) do
				if self.Speech.TP[tempnum][i]:find("<after>") then
					Speeches.SpellSucceed.TP:insert(self.Speech.TP[tempnum][i])
				elseif self.Speech.TP[tempnum][i]:find("<emote>") then
					self:Msg(self:MsgReplace(self.Speech.TP[tempnum][i], Spell.TargetName), "EMOTE")
				elseif self.Speech.TP[tempnum][i]:find("<yell>") then
					self:Msg(self:MsgReplace(self.Speech.TP[tempnum][i], Spell.TargetName), "YELL")
				else
					self:Msg(self:MsgReplace(self.Speech.TP[tempnum][i], Spell.TargetName), "WORLD")
				end
			end
		end
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
			elseif usage == "succubus" then Speeches.DemonId = 3 
			elseif usage == "felhunter" then Speeches.DemonId = 4 
			else -- should never happen...
			end
		else
			-- should never happen...
		end

		if NecrosisConfig.DemonSummon and NecrosisConfig.ChatMsg and not NecrosisConfig.SM then
			local generalSpeechNum = math.random(1, 10) -- show general speech if num is 9 or 10

			local dn = 0
			if (not NecrosisConfig.PetInfo[usage] or generalSpeechNum > 8) and self.Speech.Demon[6] then
				dn = 6
			elseif self.Speech.Demon[Speeches.DemonId] then
				dn = Speeches.DemonId
			else
				dn = 0 -- ??
			end

--[[
				if Necrosis.Debug.speech then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It summon pet first time, get name"
					.." n'"..(tostring(Spell.Name) or "nyl").."'"
					)
				end
				local tempnum = math.random(1, #self.Speech.Demon[6])
				while tempnum == Speeches.LastSpeech.Pet and #self.Speech.Demon[6] >= 2 do
					tempnum = math.random(1, #self.Speech.Demon[6])
				end
				if Necrosis.Debug.speech then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("Speech_It picked"
					.." #'"..(tostring(tempnum) or "nyl").."'"
					.." l'"..(tostring(Speeches.LastSpeech.Pet) or "nyl").."'"
					)
				end
				Speeches.LastSpeech.Pet = tempnum
				for i in ipairs(self.Speech.Demon[6][tempnum]) do
					if self.Speech.Demon[6][tempnum][i]:find("<after>") then
						Speeches.SpellSucceed.Pet:insert(self.Speech.Demon[6][tempnum][i])
					elseif self.Speech.Demon[6][tempnum][i]:find("<sacrifice>")then
						Speeches.SpellSucceed.Sacrifice:insert(self.Speech.Demon[6][tempnum][i])
					elseif self.Speech.Demon[6][tempnum][i]:find("<emote>") then
						self:Msg(self:MsgReplace(self.Speech.Demon[6][tempnum][i]), "EMOTE")
					elseif self.Speech.Demon[6][tempnum][i]:find("<yell>") then
						self:Msg(self:MsgReplace(self.Speech.Demon[6][tempnum][i]), "YELL")
					else
						self:Msg(self:MsgReplace(self.Speech.Demon[6][tempnum][i]), "SAY")
					end
				end
--]]
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
					elseif self.Speech.Demon[dn][tempnum][i]:find("<emote>") then
						self:Msg(self:MsgReplace(self.Speech.Demon[dn][tempnum][i], nil , Speeches.DemonName), "EMOTE")
					elseif self.Speech.Demon[dn][tempnum][i]:find("<yell>") then
						self:Msg(self:MsgReplace(self.Speech.Demon[dn][tempnum][i], nil , Speeches.DemonName), "YELL")
					else
						self:Msg(self:MsgReplace(self.Speech.Demon[dn][tempnum][i], nil , Speeches.DemonName), "SAY")
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
function Necrosis:Speech_Then(Spell, DemonName, Speech)
-- TODO need to be fixed ..
	-- messages to be posted after a mount is summoned.
	if Necrosis.IsSpellMount(Spell.Name) then -- 1 or 2 
		for i in ipairs(Speech.Steed) do
			if Speech.Steed[i]:find("<emote>") then
				self:Msg(self:MsgReplace(Speech.Steed[i]), "EMOTE")
			elseif Speech.Steed[i]:find("<yell>") then
				self:Msg(self:MsgReplace(Speech.Steed[i]), "YELL")
			else
				self:Msg(self:MsgReplace(Speech.Steed[i]), "WORLD")
			end
		end
		Speech.Steed = {}
		local f = _G[Necrosis.Warlock_Buttons.mounts.f]
		if f then
			f:SetNormalTexture("Interface\\Addons\\Necrosis\\UI\\MountButton-02")
		end
	-- messages to be posted after 'Soulstone' is cast
	elseif Necrosis.IsSpellRez(Spell.Name) then -- 11
		for i in ipairs(Speech.Rez) do
			if Speech.Rez[i]:find("<emote>") then
				self:Msg(self:MsgReplace(Speech.Rez[i], Spell.TargetName), "EMOTE")
			elseif Speech.Rez[i]:find("<yell>") then
				self:Msg(self:MsgReplace(Speech.Rez[i], Spell.TargetName), "YELL")
			else
				self:Msg(self:MsgReplace(Speech.Rez[i], Spell.TargetName), "WORLD")
			end
		end
		Speech.Rez = {}
	-- messages to be posted after 'Ritual of Summoning' is cast
	elseif Spell.Name == Necrosis:GetSpellName("summoning") then -- 37 
		for i in ipairs(Speech.TP) do
			if Speech.TP[i]:find("<emote>") then
				self:Msg(self:MsgReplace(Speech.TP[i], Spell.TargetName), "EMOTE")
			elseif Speech.TP[i]:find("<yell>") then
				self:Msg(self:MsgReplace(Speech.TP[i], Spell.TargetName), "YELL")
			else
				self:Msg(self:MsgReplace(Speech.TP[i], Spell.TargetName), "WORLD")
			end
		end
		Speech.TP = {}
	-- messages to be posted after sacrificing a demon
	elseif Spell.Name == Necrosis:GetSpellName("sacrifice") then -- 44 
		for i in ipairs(Speech.Sacrifice) do
			if Speech.Sacrifice[i]:find("<emote>") then
				self:Msg(self:MsgReplace(Speech.Sacrifice[i], nil, DemonName), "EMOTE")
			elseif Speech.Sacrifice[i]:find("<yell>") then
				self:Msg(self:MsgReplace(Speech.Sacrifice[i], nil, DemonName), "YELL")
			else
				self:Msg(self:MsgReplace(Speech.Sacrifice[i], nil, DemonName), "SAY")
			end
		end
		Speech.Sacrifice = {}
	-- messages to be posted after summoning a demon
	elseif Necrosis.IsSpellDemon(Spell.Name) then
		for i in ipairs(Speech.Pet) do
			if Speech.Pet[i]:find("<emote>") then
				self:Msg(self:MsgReplace(Speech.Pet[i], nil, DemonName), "EMOTE")
			elseif Speech.Pet[i]:find("<yell>") then
				self:Msg(self:MsgReplace(Speech.Pet[i], nil, DemonName), "YELL")
			else
				self:Msg(self:MsgReplace(Speech.Pet[i], nil, DemonName), "SAY")
			end
		end
		Speech.Pet = {}
	end

	return Speech
end
