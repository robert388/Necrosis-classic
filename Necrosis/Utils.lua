--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

Necrosis.Utils = {}

local NU = Necrosis.Utils -- save typing

-- Allows you to find / arrange shards in bags || Fonction qui permet de trouver / ranger les fragments dans les sacs
function NU.ParseItemLink(Type)
local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	-- only some parameters are needed or even used in Classic
	return
		Id,
		Name
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
end

--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- init")
