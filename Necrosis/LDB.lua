--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

Necrosis.LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Necrosis", 
    { type = "data source", 
      icon = "Interface\\AddOns\\Necrosis\\UI\\CurseMenuButton-01",
      text = L["NECROSIS"],
      label = L["NECROSIS"]
     }
);

function Necrosis.LDB:OnClick(button)
    GameTooltip:Hide();
    if ( button == "LeftButton" ) then
--        Armory:Toggle();
    elseif ( button == "RightButton" ) then
		Necrosis:OpenConfigPanel()
--		InterfaceOptionsFrame_OpenToCategory(L["NECROSIS"]);
--		InterfaceOptionsFrame_OpenToCategory(L["NECROSIS"]); -- hack for a Blizz bug...
    end
end

function Necrosis.LDB:OnTooltipShow()
	self:AddLine(L["NECROSIS"] .. " "..GetAddOnMetadata(NECROSIS_ID, "Version") or "NA")
	self:AddLine("Left click to open options menu.", 1, 1, 1)
end
--[[
function Necrosis.LDB:OnEnter()
    if ( not GameTooltip:IsVisible() ) then
        GameTooltip:SetOwner(self, "ANCHOR_NONE");
        GameTooltip:ClearLines();

        Necrosis.LDB:OnTooltipShow(GameTooltip);
        
        GameTooltip:Show();
    end
end

function Necrosis.LDB:OnLeave()
    GameTooltip:Hide();
end
--]]