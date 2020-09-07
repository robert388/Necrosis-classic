--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

Necrosis.Utils = {}

local NU = Necrosis.Utils -- save typing

function Necrosis.Utils.Contains(list, item)  -- must simple list!
	for _, v in pairs(list) do
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.Contains"
.." v'"..(tostring(v) or "nyl")..'"'
.." i'"..(tostring(i) or "nyl")..'"'
)
--]]
		if v == item then return true end
	end
	return false
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.GetItemInfo"
.." id'"..(itemID or "nyl")..'"'
.." n'"..(itemName or "nyl")..'"'
)
--]]
end

function Necrosis.Utils.GetItemInfo(itemID) -- Get item info, return only what we want
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
	itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, 
	isCraftingReagent 
	= GetItemInfo(itemID)

--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.GetItemInfo"
.." id'"..(itemID or "nyl")..'"'
.." n'"..(itemName or "nyl")..'"'
)
--]]
	return
		itemName
end

function Necrosis.Utils.GetItemName(itemID) 
	local name = Necrosis.Utils.GetItemInfo(itemID)
	return name
end

function Necrosis.Utils.GetSpellName(spell_id) -- Get spell info, return only what we want
	local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spell_id)

--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.GetItemInfo"
.." id'"..(itemID or "nyl")..'"'
.." n'"..(itemName or "nyl")..'"'
)
--]]
	-- only some parameters are needed or even used in Classic
	return
		name
end

--[[
 Get spell cooldown info, return only what we want
 At times, at some initial logins, it seems this returns nil...
--]]
function Necrosis.Utils.GetSpellCooldown(id, place)
	local start, duration, enabled, modRate 
	= GetSpellCooldown(id, place)
	-- only some parameters are needed or even used in Classic

	if start and duration then
		return start, duration
	else
		return 0, 0 -- assume it is ready
	end
end

--[[
 Get bag info, return only what we want
 At times, at some initial logins, it seems this returns nil...
--]]
function Necrosis.Utils.GetBagName(container)
	local name = GetBagName(container)
	local id = nil
	-- for some reason the API will not return info for Backpack or the name not be in cache
	if name == "Backpack" 
	or name == ""
	or name == nil
	then
		-- skip and do the best we can
	else
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
		itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, 
		isCraftingReagent 
		= GetItemInfo(name)
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.GetBagName"
.." '"..(tostring(name) or "nyl")..'"'
.." i'"..(tostring(itemName) or "nyl")..'"'
.." i'"..(tostring(itemLink) or "nyl")..'"'
.." i'"..(tostring(id) or "nyl")..'"'
)
--]]
		if itemName then
			Necrosis.Utils.ParseItemLink(itemLink)
		else
			-- Need to wait for server, get it next time
		end
	end
	-- only some parameters are needed or even used in Classic

	if name then
		return name, id
	else
		return "", nil
	end
end

-- Parse the item link, get only what we want || https://wowwiki.fandom.com/wiki/ItemLink
function Necrosis.Utils.ParseGUID(guid)
	local res = nil
	-- only interested in pet for now
	if guid then
		local utype, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid)

		if utype == "Pet" then
			res = tonumber(npc_id)
		else
			res = nil
		end
	else
	end
	
	return res
end

-- Parse the item link, get only what we want || https://wowwiki.fandom.com/wiki/ItemLink
function Necrosis.Utils.ParseItemLink(itemLink)
	local r_id = nil
	local r_name = ""
	
	if type(itemLink) == 'string' then
		local _, _, color, ltype, id, enchant, gem1, gem2, gem3, gem4,
			suffix, unique, linkLvl, specID,
			upgradeID, instance_diff_id, num_bonus_ids, bonus1, bonus2, name = string.find(itemLink,
		   "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*):?(%d*):?(%d*):?(%d*):?(%d*):|h%[(.-)%]|h?|?r?")
-- |cff1eff00|HItem:10998::::::::29:::::::|h[Lesser Astral\|h|r

--[[
local printable = gsub(itemLink, "\124", "\124\124");
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.ParseItemLink"
.." i'"..(tostring(id) or "nyl").."'"
.." ll'"..(tostring(linkLvl) or "nyl").."'"
.." n'"..(tostring(num_bonus_ids) or "nyl").."'"
.." n'"..(tostring(bonus1) or "nyl").."'"
.." n'"..(tostring(bonus2) or "nyl").."'"
.." n'"..(tostring(name) or "nyl").."'"
.." l'"..(tostring(printable) or "nyl").."'"
--.." l'"..(tostring(itemLink) or "nyl").."'"
)
--]]
		-- only some parameters are needed or even used in Classic
		r_id = tonumber(id)
		r_name = name
	end

	return
		r_id,
		r_name
end

function Necrosis.Utils.printable(tb, level)
  level = level or 1
  local spaces = string.rep(' ', level*2)
  for k,v in pairs(tb) do
    if type(v) ~= "table" then
      print("["..level.."]v'"..spaces.."["..tostring(k).."]='"..tostring(v).."'")
    else
      print("["..level.."]t'"..spaces.."["..tostring(k).."]")
     level = level + 1
     NU.printable(v, level)
    end
  end  
end

function Necrosis.Utils.TimeLeft(sec)
	local seconde = sec
	local affiche, minute, second
	if seconde <= 59 then
		affiche = ":"..tostring(floor(seconde))
	else
		minute = tostring(floor(seconde/60))
		seconde = mod(seconde, 60)
		if seconde <= 9 then
			second = "0"..tostring(floor(seconde))
		else
			second = tostring(floor(seconde))
		end
		affiche = minute..":"..second
	end
	return affiche
end


--[[
::: API GetSpellCooldown :::
Retrieves the cooldown data of the spell specified.
start, duration, enabled = GetSpellCooldown(spellName or spellID or slotID, "bookType");

Arguments
spellName 
String - name of the spell to retrieve cooldown data for.
spellID 
Number - ID of the spell in the database
slotID 
Number - Valid values are 1 through total number of spells in the spellbook on all pages and all tabs, ignoring empty slots.
bookType 
String - BOOKTYPE_SPELL or "spell", or BOOKTYPE_PET or "pet" depending on whether you wish to query the player or pet spellbook.

Returns
startTime 
Number - The time when the cooldown started (as returned by GetTime()); zero if no cooldown; current time if (enabled == 0).
duration 
Number - Cooldown duration in seconds, 0 if spell is ready to be cast.
enabled 
Number - 0 if the spell is active (Stealth, Shadowmeld, Presence of Mind, etc) and the cooldown will begin as soon as the spell is used/cancelled; 1 otherwise.
--]]

--[[ ::: API itemLink ::: https://wowwiki.fandom.com/wiki/ItemLink
|cff9d9d9d - Colorizes the link with a medium grey color (hex color code)
The first two characters after '|c' may be the alpha level, where 'ff' is fully opaque.
The next three sets of two characters represent the red, green, and blue levels, just like HTML.
|H - Hyperlink link data starts here
item:7073:0:0:0:0:0:0:0:0:0:0:0:0 or item:7073:::::::::::: - the item string. See itemString.
|h - End of link, text follows
[Broken Fang] - The actual text displayed
|h - End of hyperlink
|r - Restores color to normal
"|cff9d9d9d|Hitem:3299::::::::20:257::::::|h[Fractured Canine]|h|r"
--]]
--[[ ::: API itemString ::: https://wowwiki.fandom.com/wiki/ItemString
item:itemId:enchantId:gemId1:gemId2:gemId3:gemId4:
suffixId:uniqueId:linkLevel:specializationID:upgradeId:instanceDifficultyId:
numBonusIds:bonusId1:bonusId2:upgradeValue
"item:3299::::::::20:257::::::"
--]]
--[[ ::: API GetItemInfo :::
Arguments
One of the following four ways to specify which item to query:

itemId 
Number - Numeric ID of the item. e.g. 30234 for  [Nordrassil Wrath-Kilt]
itemName 
String - Name of an item owned by the player at some point during this play session, e.g. "Nordrassil Wrath-Kilt".
itemString 
String - A fragment of the itemString for the item, e.g. "item:30234:0:0:0:0:0:0:0" or "item:30234".
itemLink 
String - The full itemLink.

Returns
1. itemName
String - The localized name of the item.
2. itemLink
String - The localized item link of the item.
3. itemRarity
Number - The quality of the item. The value is 0 to 7, which represents Poor to Heirloom. This appears to include gains from upgrades/bonuses.
4. itemLevel
Number - The base item level of this item, not including item levels gained from upgrades. Use GetDetailedItemLevelInfo to get the actual current level of the item.
5. itemMinLevel
Number - The minimum level required to use the item, 0 meaning no level requirement.
6. itemType
String - The localized type of the item: Armor, Weapon, Quest, Key, etc.
7. itemSubType
String - The localized sub-type of the item: Enchanting, Cloth, Sword, etc. See itemType.
8. itemStackCount
Number - How many of the item per stack: 20 for Runecloth, 1 for weapon, 100 for Alterac Ram Hide, etc.
9. itemEquipLoc
String - The type of inventory equipment location in which the item may be equipped, or "" if it can't be equippable. The string returned is also the name of a global string variable e.g. if "INVTYPE_WEAPONMAINHAND" is returned, _G["INVTYPE_WEAPONMAINHAND"] will be the localized, displayable name of the location.
10. itemIcon
Number (fileID) - The icon texture for the item.
11. itemSellPrice
Number - The price, in copper, a vendor is willing to pay for this item, 0 for items that cannot be sold.
12. itemClassID
Number - This is the numerical value that determines the string to display for 'itemType'.
13. itemSubClassID
Number - This is the numerical value that determines the string to display for 'itemSubType'
14. bindType
Number - Item binding type: 0 - none; 1 - on pickup; 2 - on equip; 3 - on use; 4 - quest.
15. expacID
Number - ?
16. itemSetID
Number - ?
17. isCraftingReagent
Boolean - ?
Details
If the item hasn't been encountered since the game client was last started, this function will initially return nil, but will asynchronously query the server to obtain the missing data, triggering GET_ITEM_INFO_RECEIVED when the information is available.
ItemMixin:ContinueOnItemLoad() provides a convenient callback once item data has been queried:
local item = Item:CreateFromItemID(itemID)
item:ContinueOnItemLoad(function()
	print(item:GetItemLink())
	--local _, itemLink = GetItemInfo(itemID)
	--print(itemLink)
end)
--]]

--[[ Example link
|cff9d9d9d - Colorizes the link with a medium grey color (hex color code)
The first two characters after '|c' may be the alpha level, where 'ff' is fully opaque.
The next three sets of two characters represent the red, green, and blue levels, just like HTML.
|H - Hyperlink link data starts here
item:7073:0:0:0:0:0:0:0:0:0:0:0:0 or item:7073:::::::::::: - the item string. See itemString.
|h - End of link, text follows
[Broken Fang] - The actual text displayed
|h - End of hyperlink
|r - Restores color to normal

|cff9d9d9d|Hitem:7073::::::::::::|h[Broken Fang]|h|r


:::itemString:::
itemID - Item ID that can be used for GetItemInfo calls.
enchantId - Permament enchants applied to an item. See list of EnchantIds.
gemId1 - Embedded gems re-use EnchantId indices, though gem icons show only for specific values
gemId2 (number)
gemId3 (number)
gemId4 (number)
suffixId - Random enchantment ID; may be negative. See list of SuffixIds.
uniqueId - Data pertaining to a specific instance of the item.
linkLevel - Level of the character supplying the link. This is used to render scaling heirloom item tooltips at the proper level.
specializationID - Specialization ID
upgradeId - Reforging info. 0 or empty for items that have not been reforged
instanceDifficultyId (number)
numBonusIds (number)
bonusId1 (number)
bonusId2 (number)
upgradeValue (number)

item:itemId:enchantId:gemId1:gemId2:gemId3:gemId4:
suffixId:uniqueId:linkLevel:specializationID:upgradeId:instanceDifficultyId:
numBonusIds:bonusId1:bonusId2:upgradeValue

item:6948::::::::80::::
--]]

--[[ enchant ids - more than Classic || https://wow.gamepedia.com/EnchantId
3609	Lesser Firestone
3610	Firestone
3611	Greater Firestone
3612	Major Firestone
*3613	Fel Firestone
*3614	Grand Firestone
3615	Spellstone
3616	Greater Spellstone
3617	Major Spellstone
*3618	Master Spellstone
*3619	Demonic Spellstone
*3620	Grand Spellstone
--]]

--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- init")
--[[ ::: API CombatLogGetCurrentEventInfo :::
arg1, arg2, ... = CombatLogGetCurrentEventInfo()
      eventInfo = {CombatLogGetCurrentEventInfo()}
	  
Returns
Returns a variable number of parameters: 11 base parameters and up to 13 extra parameters.

timestamp number - Unix Time in seconds with milliseconds precision, for example 1555749627.861. Similar to time() and can be passed as the second argument of date().
event string
hideCaster boolean - Returns true if the source unit should be hidden in the Blizzard combat log.
sourceGuid string - Globally unique identifier for units (NPCs, players, pets, etc), for example "Creature-0-3113-0-47-94-00003AD5D7".
sourceName string
sourceFlags number - Contains the flag bits for a unit's type, controller, reaction and affiliation. For example 68168 = 0x10A48: Unit is the current target, is an NPC, the controller is an NPC, reaction is hostile and affiliation is outsider.
sourceRaidFlags number - Contains the raid flag bits for a unit's raid target icon.
destGuid string
destName string
destFlags number
destRaidFlags number
The number and type of additional return values depend on the event.

Details
In the new event system for 8.0, supporting the original functionality of the CLEU event was problematic due to the "context" arguments, i.e. each argument can be interpreted differently depending on the previous arguments. The payload was subsequently moved to this function. [1]
Examples
Prints all CLEU parameters.
local function OnEvent(self, event)
	print(CombatLogGetCurrentEventInfo())
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)
Displays your spell or melee critical hits.
local playerGUID = UnitGUID("player")
local MSG_CRITICAL_HIT = "Your %s critically hit %s for %d damage!"

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
	-- pass a variable number of arguments
	self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)

function f:OnEvent(event, ...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

	if subevent == "SWING_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	end
	
	if critical and sourceGUID == playerGUID then
		local action = spellId and GetSpellLink(spellId) or MELEE
		print(MSG_CRITICAL_HIT:format(action, destName, amount))
	end
end
Patch changes
Battle for Azeroth Patch 8.0.1 (2018-07-17): Added. [2]
--]]
