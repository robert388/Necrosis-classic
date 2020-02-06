--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

Necrosis.Utils = {}

local NU = Necrosis.Utils -- save typing

function NU.Contains(list, item)  -- must simple list!
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
-- Get item info, return only what we want
function NU.GetItemInfo(itemID)
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
	-- only some parameters are needed or even used in Classic
	return
		itemName
end

--[[
 Get spell cooldown info, return only what we want
 At times, at some initial logins, it seems this returns nil...
--]]
function NU.GetSpellCooldown(id, place)
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
function NU.GetBagName(container)
	local name = GetBagName(container)
	-- only some parameters are needed or even used in Classic

--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("NU.GetBagName"
.." '"..(tostring(name) or "nyl")..'"'
)
--]]
	if name then
		return name
	else
		return ""
	end
end

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

-- Parse the item link, get only what we want
function NU.ParseItemLink(Type)
local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	-- only some parameters are needed or even used in Classic
	return
		Id,
		Name
end
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

function NU.printable(tb, level)
  level = level or 1
  local spaces = string.rep(' ', level*2)
  for k,v in pairs(tb) do
    if type(v) ~= "table" then
      print("["..level.."]v'"..spaces.."["..k.."]='"..tostring(v).."'")
    else
      print("["..level.."]t'"..spaces.."["..k.."]")
     level = level + 1
     NU.printable(v, level)
    end
  end  
end


--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- init")
