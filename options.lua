local addonName, ptable = ...
local L = ptable.L
local TempConfig = nil
 
local O = addonName .. "OptionsPanel"
local OptionsPanel = CreateFrame("Frame", O)
OptionsPanel.name=addonName
-- Title
local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetText(addonName)
-- Description
local notes = GetAddOnMetadata(addonName, "Notes-" .. GetLocale())
notes = notes or GetAddOnMetadata(addonName, "Notes")
local subText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subText:SetText(notes)

-- 'Enable' CheckBox
local Enable = CreateFrame("CheckButton", O.."Enable", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."EnableText"]:SetText(L["enabled"])
Enable:SetScript("OnClick", function(self) 
	TempConfig.enabled = self:GetChecked() == 1 
	if (TempConfig.enabled) then 
		AutoTurnIn:RegisterGossipEvents()
	else
		AutoTurnIn:UnregisterAllEvents()
	end
end)

-- Quest types to handle 
local QuestLabel = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
QuestLabel:SetText(L["questTypeLabel"])
local QuestConst = {L["questTypeAll"], L["questTypeList"]}
local QuestDropDown = CreateFrame("Frame", O.."QuestDropDown", OptionsPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(QuestDropDown, function (self, level)   
    for k, v in ipairs(QuestConst) do
        local info = UIDropDownMenu_CreateInfo()
        info.text, info.value = v, k
        info.func = function(self) 
						UIDropDownMenu_SetSelectedID(QuestDropDown, self:GetID())
						TempConfig.all = (self:GetID() == 1) 
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(QuestDropDown, 200);
UIDropDownMenu_JustifyText(QuestDropDown, "LEFT")

-- Tournament loot type 
local TournamentDropDownLabel = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
TournamentDropDownLabel:SetText(L["tournamentLabel"])
local TournamentConst = {L["tournamentWrit"], L["tournamentPurse"]};
local TournamentDropDown = CreateFrame("Frame", O.."TournamentDropDown", OptionsPanel, "UIDropDownMenuTemplate")
function TournamentDropDown:initialize ()	
    for k, v in ipairs(TournamentConst) do
        local info = UIDropDownMenu_CreateInfo()
        info.text, info.value = v, k
        info.func = function(self)
						UIDropDownMenu_SetSelectedID(TournamentDropDown, self:GetID())
						TempConfig.tournament = self:GetID() 
					end		
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_SetWidth(TournamentDropDown, 200);
UIDropDownMenu_JustifyText(TournamentDropDown, "LEFT")

-- How to loot
local LootLabel = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
LootLabel:SetText(L["lootTypeLabel"])
local LootConst = {L["lootTypeFalse"], L["lootTypeTrue"]}
local LootDropDown = CreateFrame("Frame", O.."LootDropDown", OptionsPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(LootDropDown, function (self, level)   
    for k, v in ipairs(LootConst) do
        local info = UIDropDownMenu_CreateInfo()
		info.text, info.value = v, k
        info.func = function(self)
						UIDropDownMenu_SetSelectedID(LootDropDown, self:GetID())
						TempConfig.dontloot = (self:GetID() == 1)
						if TempConfig.dontloot then 
							UIDropDownMenu_DisableDropDown(TournamentDropDown)
						else 
							UIDropDownMenu_EnableDropDown(TournamentDropDown)
						end
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(LootDropDown, 200);
UIDropDownMenu_JustifyText(LootDropDown, "LEFT")

-- DarkmoonTeleport
local DarkMoonCannon = CreateFrame("CheckButton", O.."DarkMoonCannon", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."DarkMoonCannonText"]:SetText(L["DarkmoonTeleLabel"])
DarkMoonCannon:SetScript("OnClick", function(self) 
	TempConfig.darkmoonteleport = self:GetChecked() == 1 
end)

-- Control placement
title:SetPoint("TOPLEFT", 16, -16)
subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
Enable:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -16)
QuestLabel:SetPoint("BOTTOMLEFT", QuestDropDown, "TOPLEFT", 18, 0)
QuestDropDown:SetPoint("TOPLEFT", Enable, "BOTTOMLEFT", -15, -35)
LootLabel:SetPoint("BOTTOMLEFT", LootDropDown, "TOPLEFT", 18, 0)
LootDropDown:SetPoint("TOPLEFT", QuestDropDown, "BOTTOMLEFT", 0, -35)
TournamentDropDownLabel:SetPoint("BOTTOMLEFT", TournamentDropDown, "TOPLEFT", 18, 0)
TournamentDropDown:SetPoint("TOPLEFT", LootDropDown, "TOPRIGHT", 17, 0)
DarkMoonCannon:SetPoint("TOPLEFT", LootDropDown, "BOTTOMLEFT", 16, -16)

OptionsPanel.refresh = function()
	TempConfig = CopyTable(AutoTurnInCharacterDB)

	Enable:SetChecked(TempConfig.enabled)

	UIDropDownMenu_SetSelectedID(QuestDropDown, TempConfig.all and 1 or 2)
	UIDropDownMenu_SetText(QuestDropDown, TempConfig.all and L["questTypeAll"] or L["questTypeList"]  )

	UIDropDownMenu_SetSelectedID(LootDropDown, TempConfig.dontloot and 1 or 2)
	UIDropDownMenu_SetText(LootDropDown, TempConfig.dontloot and L["lootTypeFalse"] or L["lootTypeTrue"])
	
	UIDropDownMenu_SetSelectedID(TournamentDropDown, TempConfig.tournament)
	UIDropDownMenu_SetText(TournamentDropDown,TournamentConst[TempConfig.tournament])
	if (TempConfig.dontloot) then 
		UIDropDownMenu_DisableDropDown(TournamentDropDown)
	end
	DarkMoonCannon:SetChecked(TempConfig.darkmoonteleport)
end

OptionsPanel.default = function() 
	TempConfig = CopyTable(AutoTurnIn.defaults)
end

OptionsPanel.okay = function()
	AutoTurnInCharacterDB = CopyTable(TempConfig)
end


InterfaceOptions_AddCategory(OptionsPanel)