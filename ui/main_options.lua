local addonName, ptable = ...
local L = ptable.L
local O = addonName .. "OptionsPanel"
AutoTurnIn.OptionsPanel = CreateFrame("Frame", O)
AutoTurnIn.OptionsPanel.name=addonName
local OptionsPanel = AutoTurnIn.OptionsPanel

local MakeACopy=true

-- Title
local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetText(addonName)
-- Description
local notes = GetAddOnMetadata(addonName, "Notes-" .. GetLocale())
notes = notes or GetAddOnMetadata(addonName, "Notes")
local subText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subText:SetText(notes)
-- Reset button
local ResetButton = CreateFrame("Button", nil, OptionsPanel, "OptionsButtonTemplate")
ResetButton:SetText(L["resetbutton"])
ResetButton:SetScript("OnClick", function()
	ptable.TempConfig = CopyTable(AutoTurnIn.defaults)
	
	MakeACopy=false;
	AutoTurnIn.RewardPanel.refresh();
	AutoTurnIn.OptionsPanel.refresh();
end)

local function CreateCheckbox(name, marginx, marginy)
	local nm = O..name
	local cb = CreateFrame("CheckButton", nm,  OptionsPanel, "OptionsCheckButtonTemplate")
	_G[nm.."Text"]:SetText(L[name])
	cb:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", marginx, marginy)
	cb:SetScript("OnClick", function(self)
		ptable.TempConfig[name] = self:GetChecked() == 1
	end)
	return cb
end

-- 'Enable' CheckBox
local Enable = CreateCheckbox("enabled", subText, 0, -14)
--[[
CreateFrame("CheckButton", O.."Enable", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."EnableText"]:SetText(L["enabled"])
Enable:SetScript("OnClick", function(self) 
	ptable.TempConfig.enabled = self:GetChecked() == 1
end)
]]--

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

-- DarkmoonTeleport
local TrivialQuests = CreateFrame("CheckButton", O.."TrivialQuests", OptionsPanel, "OptionsCheckButtonTemplate")
_G[TrivialQuests:GetName().."Text"]:SetText(L["TrivialQuests"])
TrivialQuests:SetScript("OnClick", function(self) 
	ptable.TempConfig.trivial = self:GetChecked() == 1 
end)

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
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(LootDropDown, 200);
UIDropDownMenu_JustifyText(LootDropDown, "LEFT")

-- Teleport to Darkmoon Faire
local ToDarkMoon= CreateFrame("CheckButton", O.."ToDarkMoon", OptionsPanel, "OptionsCheckButtonTemplate")
_G[O.."ToDarkMoonText"]:SetText(L["ToDarkmoonLabel"])
ToDarkMoon:SetScript("OnClick", function(self) 
	ptable.TempConfig.todarkmoon = self:GetChecked() == 1 
end)

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

-- 'Equip Reward Text' CheckBox
local EquipReward = CreateFrame("CheckButton", O.."Equip", OptionsPanel, "OptionsCheckButtonTemplate")
_G[EquipReward:GetName().."Text"]:SetText(L["autoequip"])
EquipReward:SetScript("OnClick", function(self) 
	ptable.TempConfig.autoequip = self:GetChecked() == 1 
end)

-- 'Equip Reward Text' CheckBox
local Debug = CreateFrame("CheckButton", O.."Debug", OptionsPanel, "OptionsCheckButtonTemplate")
_G[Debug:GetName().."Text"]:SetText(L["debug"])
Debug:SetScript("OnClick", function(self) 
	ptable.TempConfig.debug = self:GetChecked() == 1 
end)

local ShareQuests = CreateFrame("CheckButton", O.."ShareQuests", OptionsPanel, "OptionsCheckButtonTemplate")
_G[ShareQuests:GetName().."Text"]:SetText(L["ShareQuestsLabel"])
ShareQuests:SetScript("OnClick", function(self)
	ptable.TempConfig.questshare = self:GetChecked() == 1
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

-- 'Show QuestLevel' CheckBox
local ShowQuestLevel = CreateFrame("CheckButton", O.."QuestLevel", OptionsPanel, "OptionsCheckButtonTemplate")
_G[ShowQuestLevel:GetName().."Text"]:SetText(L["questlevel"])
ShowQuestLevel:SetScript("OnClick", function(self) 
	ptable.TempConfig.questlevel = self:GetChecked() == 1 
end)

-- 'Show Watch Quest Level' CheckBox
local ShowWatchLevel = CreateFrame("CheckButton", O.."WatchLevel", OptionsPanel, "OptionsCheckButtonTemplate")
_G[ShowWatchLevel:GetName().."Text"]:SetText(L["watchlevel"])
ShowWatchLevel:SetScript("OnClick", function(self) 
	ptable.TempConfig.watchlevel = self:GetChecked() == 1 
end)

-- Control placement
title:SetPoint("TOPLEFT", 16, -16)
subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
ResetButton:SetPoint("TOPRIGHT", OptionsPanel, "TOPRIGHT", -10, -10)
Enable:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -14)
QuestLabel:SetPoint("BOTTOMLEFT", QuestDropDown, "TOPLEFT", 18, 0)
QuestDropDown:SetPoint("TOPLEFT", Enable, "BOTTOMLEFT", -15, -22)
TrivialQuests:SetPoint("TOPLEFT", QuestDropDown, "TOPRIGHT", 30, 0)
LootLabel:SetPoint("BOTTOMLEFT", LootDropDown, "TOPLEFT", 18, 0)
LootDropDown:SetPoint("TOPLEFT", QuestDropDown, "BOTTOMLEFT", 0, -22)
TournamentDropDownLabel:SetPoint("BOTTOMLEFT", TournamentDropDown, "TOPLEFT", 18, 0)
TournamentDropDown:SetPoint("TOPLEFT", LootDropDown, "TOPRIGHT", 17, 0)
EquipReward:SetPoint("TOPLEFT", LootDropDown, "BOTTOMLEFT", 16, -10)
ShowRewardText:SetPoint("TOPLEFT", EquipReward, "BOTTOMLEFT", 0, -10)
ToDarkMoon:SetPoint("TOPLEFT", ShowRewardText, "BOTTOMLEFT", 0, -10)
DarkMoonCannon:SetPoint("TOPLEFT", ToDarkMoon, "BOTTOMLEFT", 0, -10)
DarkMoonAutoStart:SetPoint("TOPLEFT", DarkMoonCannon, "BOTTOMLEFT", 0, -10)
Debug:SetPoint("TOPLEFT", ResetButton, "BOTTOMLEFT", 0, -10)
ToggleKeyLabel:SetPoint("BOTTOMLEFT", ToggleKeyDropDown, "TOPLEFT", 18, 0)
ToggleKeyDropDown:SetPoint("TOPLEFT", DarkMoonAutoStart, "BOTTOMLEFT", -15, -22)
ShowQuestLevel:SetPoint("TOPLEFT", ToggleKeyDropDown, "BOTTOMLEFT", 16, -10)
ShowWatchLevel:SetPoint("TOPLEFT", ShowQuestLevel, "BOTTOMLEFT", 0, -10)
ShareQuests:SetPoint("TOPLEFT", ShowWatchLevel, "BOTTOMLEFT", 0, -10)

OptionsPanel.refresh = function()
	if ( MakeACopy ) then 
		ptable.TempConfig = CopyTable(AutoTurnInCharacterDB)
	end

	Enable:SetChecked(ptable.TempConfig.enabled)

	UIDropDownMenu_SetSelectedID(QuestDropDown, ptable.TempConfig.all and 1 or 2)
	UIDropDownMenu_SetText(QuestDropDown, ptable.TempConfig.all and L["questTypeAll"] or L["questTypeList"]  )

	UIDropDownMenu_SetSelectedID(LootDropDown, ptable.TempConfig.lootreward)
	UIDropDownMenu_SetText(LootDropDown, LootConst[ptable.TempConfig.lootreward])
	
	UIDropDownMenu_SetSelectedID(TournamentDropDown, ptable.TempConfig.tournament)
	UIDropDownMenu_SetText(TournamentDropDown,TournamentConst[ptable.TempConfig.tournament])
	ToDarkMoon:SetChecked(ptable.TempConfig.todarkmoon)
	DarkMoonCannon:SetChecked(ptable.TempConfig.darkmoonteleport)
	DarkMoonAutoStart:SetChecked(ptable.TempConfig.darkmoonautostart)
	ShowRewardText:SetChecked(ptable.TempConfig.showrewardtext)
	EquipReward:SetChecked(ptable.TempConfig.autoequip)
	Debug:SetChecked(ptable.TempConfig.debug)
	TrivialQuests:SetChecked(ptable.TempConfig.trivial)
	ShowQuestLevel:SetChecked(ptable.TempConfig.questlevel)
	ShowWatchLevel:SetChecked(ptable.TempConfig.watchlevel)
	ShareQuests:SetChecked(ptable.TempConfig.questshare)
	
	UIDropDownMenu_SetSelectedID(ToggleKeyDropDown, ptable.TempConfig.togglekey)
	UIDropDownMenu_SetText(ToggleKeyDropDown,  ToggleKeyConst[ptable.TempConfig.togglekey])
	MakeACopy = true
end

OptionsPanel.default = function() 
	ptable.TempConfig = CopyTable(AutoTurnIn.defaults)
end

OptionsPanel.okay = function()
	AutoTurnInCharacterDB = CopyTable(ptable.TempConfig)
	AutoTurnIn:SetEnabled(AutoTurnInCharacterDB.enabled)
	QuestLog_Update()
	WatchFrame_Update(WatchFrame)
end

InterfaceOptions_AddCategory(OptionsPanel)