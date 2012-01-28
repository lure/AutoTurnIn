local addonName, ptable = ...
local L = ptable.L
--[[ 
	Thanks to LoseControl author Kouri for ideas and direction 
	http://forums.wowace.com/showthread.php?t=15763
	http://www.wowwiki.com/UI_Object_UIDropDownMenu
]]-- 
local O = addonName .. "OptionsPanel"
local OptionsPanel = CreateFrame("Frame", O)
OptionsPanel.name=addonName
-- Title
local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetText(addonName)
-- Description
local subText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
local notes = GetAddOnMetadata(addonName, "Notes-" .. GetLocale())
if not notes then
	notes = GetAddOnMetadata(addonName, "Notes")
end
subText:SetText(notes)

-- Enable CheckBox
local Enable = CreateFrame("CheckButton", O.."Enable", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."EnableText"]:SetText(L["enabled"])
Enable:SetScript("OnClick", function(self) AutoTurnInCharacterDB.enabled = self:GetChecked() end)

-- Quest types to handle 

local QuestType = CreateFrame("Frame", O.."QuestTypes", OptionsPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(QuestType, function (self, level)
    local info
    for k, v in pairs({["all"] = L["all"],["list"] = L["list"]}) do
        info = UIDropDownMenu_CreateInfo()
        info.text = v
        info.value = k
        info.func = function(self) 
						UIDropDownMenu_SetSelectedID(QuestType, self:GetID())
						AutoTurnInCharacterDB.all = (self:GetID() == 2) 
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(QuestType,400 );
UIDropDownMenu_JustifyText(QuestType, "LEFT")

-- Loot type 
local LootType = CreateFrame("Frame", O.."LootTypes", OptionsPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(LootType, function (self, level)
    local info
    for k, v in pairs({["loottrue"] = L["loottrue"],["lootfalse"] = L["lootfalse"]}) do
        info = UIDropDownMenu_CreateInfo()
        info.text = v
        info.value = k
        info.func = function(self) 
						UIDropDownMenu_SetSelectedID(LootType, self:GetID())
						AutoTurnInCharacterDB.lootMostExpensive = (self:GetID() == 2) 
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(LootType,400 );
UIDropDownMenu_JustifyText(LootType, "LEFT")

-- Control placement
title:SetPoint("TOPLEFT", 16, -16)
subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
Enable:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -16)
QuestType:SetPoint("TOPLEFT", Enable, "BOTTOMLEFT", -15, -16)
LootType:SetPoint("TOPLEFT", QuestType, "BOTTOMLEFT", 0, -16)

OptionsPanel.refresh = function()
	Enable:SetChecked(AutoTurnInCharacterDB.enabled)

	if AutoTurnInCharacterDB.all then 
		UIDropDownMenu_SetSelectedID(QuestType, 2)
		UIDropDownMenu_SetText(QuestType, L["all"])
	else 
		UIDropDownMenu_SetSelectedID(QuestType, 1)
		UIDropDownMenu_SetText(QuestType, L["list"])
	end

	if AutoTurnInCharacterDB.lootMostExpensive then 
		UIDropDownMenu_SetSelectedID(LootType, 2)
		UIDropDownMenu_SetText(LootType, L["loottrue"])
	else 
		UIDropDownMenu_SetSelectedID(LootType, 1)
		UIDropDownMenu_SetText(LootType, L["lootfalse"])
	end
end

OptionsPanel.default = function() 
	AutoTurnInCharacterDB.enabled = true
	AutoTurnInCharacterDB.all = false
	AutoTurnInCharacterDB.lootMostExpensive = false
end
InterfaceOptions_AddCategory(OptionsPanel)