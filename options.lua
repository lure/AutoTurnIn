local addonName, ptable = ...
local L = ptable.L
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
	ptable.TempConfig.enabled = self:GetChecked() == 1
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
						ptable.TempConfig.all = (self:GetID() == 1) 
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
						ptable.TempConfig.tournament = self:GetID() 
					end		
        UIDropDownMenu_AddButton(info, level)
    end
end
UIDropDownMenu_SetWidth(TournamentDropDown, 200);
UIDropDownMenu_JustifyText(TournamentDropDown, "LEFT")

-- How to loot
local LootLabel = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
LootLabel:SetText(L["lootTypeLabel"])
local LootConst = {L["lootTypeFalse"], L["lootTypeGreed"], L["lootTypeNeed"]}
local LootDropDown = CreateFrame("Frame", O.."LootDropDown", OptionsPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(LootDropDown, function (self, level)   
    for k, v in ipairs(LootConst) do
        local info = UIDropDownMenu_CreateInfo()
		info.text, info.value = v, k
        info.func = function(self)
						UIDropDownMenu_SetSelectedID(LootDropDown, self:GetID())
						ptable.TempConfig.lootreward = self:GetID()
						if ptable.TempConfig.lootreward == 1 then 
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
	ptable.TempConfig.darkmoonteleport = self:GetChecked() == 1 
end)

-- Darkmoon games
local DarkMoonAutoStart = CreateFrame("CheckButton", O.."DarkMoonAutoStart", OptionsPanel, "OptionsCheckButtonTemplate")
_G[DarkMoonAutoStart:GetName().."Text"]:SetText(L["DarkmoonAutoLabel"])
DarkMoonAutoStart:SetScript("OnClick", function(self) 
	ptable.TempConfig.darkmoonautostart = self:GetChecked() == 1 
end)

-- 'Show Reward Text' CheckBox
local ShowRewardText = CreateFrame("CheckButton", O.."Reward", OptionsPanel, "OptionsCheckButtonTemplate")
_G[ShowRewardText:GetName().."Text"]:SetText(L["rewardtext"])
ShowRewardText:SetScript("OnClick", function(self) 
	ptable.TempConfig.showrewardtext = self:GetChecked() == 1 
end)

-- Auto toggle key
local ToggleKeyLabel = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
ToggleKeyLabel:SetText(L["togglekey"])
local ToggleKeyConst = {NONE_KEY, ALT_KEY, CTRL_KEY, SHIFT_KEY}
local ToggleKeyDropDown = CreateFrame("Frame", O.."ToggleKeyDropDown", OptionsPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(ToggleKeyDropDown, function (self, level)   
    for k, v in ipairs(ToggleKeyConst) do
        local info = UIDropDownMenu_CreateInfo()
		info.text, info.value = v, k
        info.func = function(self)
						UIDropDownMenu_SetSelectedID(ToggleKeyDropDown, self:GetID())
						ptable.TempConfig.togglekey = self:GetID()
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(ToggleKeyDropDown, 200);
UIDropDownMenu_JustifyText(ToggleKeyDropDown, "LEFT")


-- Control placement
title:SetPoint("TOPLEFT", 16, -16)
subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
Enable:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -16)
QuestLabel:SetPoint("BOTTOMLEFT", QuestDropDown, "TOPLEFT", 18, 0)
QuestDropDown:SetPoint("TOPLEFT", Enable, "BOTTOMLEFT", -15, -35)
LootLabel:SetPoint("BOTTOMLEFT", LootDropDown, "TOPLEFT", 18, 0)
LootDropDown:SetPoint("TOPLEFT", QuestDropDown, "BOTTOMLEFT", 0, -30)
TournamentDropDownLabel:SetPoint("BOTTOMLEFT", TournamentDropDown, "TOPLEFT", 18, 0)
TournamentDropDown:SetPoint("TOPLEFT", LootDropDown, "TOPRIGHT", 17, 0)
DarkMoonCannon:SetPoint("TOPLEFT", LootDropDown, "BOTTOMLEFT", 16, -16)
DarkMoonAutoStart:SetPoint("TOPLEFT", DarkMoonCannon, "BOTTOMLEFT", 0, -16)
ShowRewardText:SetPoint("TOPLEFT", DarkMoonAutoStart, "BOTTOMLEFT", 0, -16)

ToggleKeyLabel:SetPoint("BOTTOMLEFT", ToggleKeyDropDown, "TOPLEFT", 18, 0)
ToggleKeyDropDown:SetPoint("TOPLEFT", ShowRewardText, "BOTTOMLEFT", -15, -30)

OptionsPanel.refresh = function()
	ptable.TempConfig = CopyTable(AutoTurnInCharacterDB)

	Enable:SetChecked(ptable.TempConfig.enabled)

	UIDropDownMenu_SetSelectedID(QuestDropDown, ptable.TempConfig.all and 1 or 2)
	UIDropDownMenu_SetText(QuestDropDown, ptable.TempConfig.all and L["questTypeAll"] or L["questTypeList"]  )

	UIDropDownMenu_SetSelectedID(LootDropDown, ptable.TempConfig.lootreward)
	UIDropDownMenu_SetText(LootDropDown, LootConst[ptable.TempConfig.lootreward])
	
	UIDropDownMenu_SetSelectedID(TournamentDropDown, ptable.TempConfig.tournament)
	UIDropDownMenu_SetText(TournamentDropDown,TournamentConst[ptable.TempConfig.tournament])
	if (ptable.TempConfig.lootreward == 1) then
		UIDropDownMenu_DisableDropDown(TournamentDropDown)
	end
	DarkMoonCannon:SetChecked(ptable.TempConfig.darkmoonteleport)
	DarkMoonAutoStart:SetChecked(ptable.TempConfig.darkmoonautostart)
	ShowRewardText:SetChecked(ptable.TempConfig.showrewardtext)

	UIDropDownMenu_SetSelectedID(ToggleKeyDropDown, ptable.TempConfig.togglekey)
	UIDropDownMenu_SetText(ToggleKeyDropDown,  ToggleKeyConst[ptable.TempConfig.togglekey])
end

OptionsPanel.default = function() 
	ptable.TempConfig = CopyTable(AutoTurnIn.defaults)
end

OptionsPanel.okay = function()
	AutoTurnInCharacterDB = CopyTable(ptable.TempConfig)
	AutoTurnIn:SetEnabled(AutoTurnInCharacterDB.enabled)
end

InterfaceOptions_AddCategory(OptionsPanel)