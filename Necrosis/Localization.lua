--[[
    Necrosis LdC
    Copyright (C) - copyright file included in this release
--]]

Necrosis = {}
NECROSIS_ID = "Necrosis"

Necrosis.Data = {
	Version = GetAddOnMetadata("Necrosis", "Version"),
	AppName = "Necrosis LdC",
	LastConfig = 20191125,
	Enabled = false,
}
Necrosis.Frame_Prefix = "Necrosis"
Necrosis.Frame_Postfix = "Button"
Necrosis.Frame_Prefix_Pet = "NecrosisPetMenu"

Necrosis.Data.Label = Necrosis.Data.AppName.." "..Necrosis.Data.Version

Necrosis.Speech = {}
Necrosis.Unit = {}
Necrosis.Translation = {}

Necrosis.Config = {}

local ntooltip = CreateFrame("Frame", "NecrosisTooltip", UIParent, "GameTooltipTemplate");
local nbutton  = CreateFrame("Button", "NecrosisButton", UIParent, "SecureActionButtonTemplate")

-- Edit the scripts associated with the button || Edition des scripts associés au bouton
NecrosisButton:SetScript("OnEvent", function(self,event, ...)
	-- if (event == "UNIT_SPELLCAST_SUCCEEDED") then
	-- 	print 'yah UNIT_SPELLCAST_SUCCEEDED'
	-- 	print(...)
	-- 	print(sourceGUID)
	-- end

	 Necrosis:OnEvent(self, event,...) 
	end)
NecrosisButton:SetScript("OnUpdate", 		function(self, arg1) Necrosis:OnUpdate(self, arg1) end)
NecrosisButton:SetScript("OnEnter", 		function(self) Necrosis:BuildTooltip(self, "Main", "ANCHOR_LEFT") end)
NecrosisButton:SetScript("OnLeave", 		function() GameTooltip:Hide() end)
NecrosisButton:SetScript("OnMouseUp", 		function(self) Necrosis:OnDragStop(self) end)
NecrosisButton:SetScript("OnDragStart", 	function(self) Necrosis:OnDragStart(self) end)
NecrosisButton:SetScript("OnDragStop", 		function(self) Necrosis:OnDragStop(self) end)

NecrosisButton:RegisterEvent("PLAYER_LOGIN")
NecrosisButton:RegisterEvent("PLAYER_ENTERING_WORLD")
--NecrosisButton:RegisterEvent("SPELLS_CHANGED")

--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- init")
