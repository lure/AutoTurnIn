local addonName, ptable = ...
local C = ptable.CONST
local L = ptable.L
local O = addonName .. "RewardPanel"
local RewardPanel = CreateFrame("Frame", O)
RewardPanel.name = QUEST_REWARDS

local function CreateCheckbox(name, parent, marginx, marginy, text)
	local cb = CreateFrame("CheckButton", "$parent"..name,  parent, "OptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", parent, marginx, marginy)
	_G[cb:GetName().."Text"]:SetText(text and text or name)
	cb:SetScript("OnClick", function(self)
		parent.GetConfig()[name] = self:GetChecked() == 1 and true or nil
	end)
	tinsert(parent.buttons, cb)
	return cb
end 

local function CreatePanel(name, text, w, h)
	local panel = CreateFrame("Frame", O..name,  RewardPanel, "OptionsBoxTemplate")
	panel:SetWidth(w)
	panel:SetHeight(h)
	panel.buttons = {}
	panel.config=config
	function panel:ClearCheckBoxes() 
		for k,v in ipairs(self.buttons) do 
			v:SetChecked(false)
		end
	end
	function panel:GetConfig()
		if name == "StatPanel" then 
			return ptable.TempConfig.stat
		elseif name == "ArmorPanel" then
			return ptable.TempConfig.armor
		else 
			return ptable.TempConfig.weapon
		end
	end
	_G[panel:GetName().."Title"]:SetText(text)
	return panel
end

-- Description
local description = RewardPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetText(L["rewardlootoptions"])
RewardPanel.parent = _G["AutoTurnInOptionsPanel"]

local weapon = {GetAuctionItemSubClasses(1)}
local armor = {GetAuctionItemSubClasses(2)}

-- WEAPON
local WeaponPanel = CreatePanel("WeaponPanel", C.WEAPONLABEL, 590, 170)
CreateCheckbox(weapon[1], WeaponPanel, 10, -8)
CreateCheckbox(weapon[2], WeaponPanel, 206, -8)
CreateCheckbox(weapon[5], WeaponPanel, 402, -8)
	-- 2nd line 
CreateCheckbox(weapon[6], WeaponPanel, 10, -40)
CreateCheckbox(weapon[7], WeaponPanel, 206, -40)
CreateCheckbox(weapon[8], WeaponPanel, 402, -40)
    -- 3rd line
CreateCheckbox(weapon[9], WeaponPanel, 10, -72)
CreateCheckbox(weapon[10], WeaponPanel, 206, -72)
CreateCheckbox(weapon[11], WeaponPanel, 402, -72)
	-- 4rd line
CreateCheckbox(weapon[13], WeaponPanel, 10, -104)
CreateCheckbox(weapon[14], WeaponPanel, 206, -104)
CreateCheckbox(weapon[16], WeaponPanel, 402, -104)
	-- 5th line
CreateCheckbox("Ranged", WeaponPanel, 10, -136, string.format("%s, %s, %s", weapon[3], weapon[4], weapon[15]) )

-- ARMOR 
local ArmorPanel = CreatePanel("ArmorPanel", C.ARMORLABEL, 590, 70)
local ArmorDropDown = CreateFrame("Frame", O.."ToggleKeyDropDown", ArmorPanel, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(ArmorDropDown, function (self, level)   
local ArmorConst = {NONE_KEY, armor[2], armor[3], armor[4],armor[5]}
    for k, v in ipairs(ArmorConst) do
        local info = UIDropDownMenu_CreateInfo()
		info.text, info.value = v, k
        info.func = function(self)
						UIDropDownMenu_SetSelectedID(ArmorDropDown, self:GetID())
						wipe(ptable.TempConfig.armor)
						if self:GetID() > 1 then 
							ptable.TempConfig.armor[self:GetText()] = true
						end
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(ArmorDropDown, 200);
UIDropDownMenu_JustifyText(ArmorDropDown, "LEFT")
ArmorDropDown:SetPoint("TOPLEFT", ArmorPanel, 0, -8)
CreateCheckbox(armor[6], ArmorPanel, 292, -8)
	-- 2nd line 
CreateCheckbox("Jewelry", ArmorPanel, 10, -40, L['Jewelry'] )
CreateCheckbox(INVTYPE_HOLDABLE, ArmorPanel, 206, -40)
CreateCheckbox(INVTYPE_CLOAK, ArmorPanel, 206, -40)
	
-- ATTRIBUTES
local StatPanel = CreatePanel("StatPanel", STAT_CATEGORY_ATTRIBUTES, 590, 40) 
CreateCheckbox("Strength", StatPanel, 10, -8, SPELL_STAT1_NAME)
CreateCheckbox("Agility", StatPanel, 152, -8, SPELL_STAT2_NAME)
CreateCheckbox("Intellect", StatPanel, 292, -8, SPELL_STAT4_NAME)
CreateCheckbox("Spirit", StatPanel, 436, -8, SPELL_STAT5_NAME)

-- 'Enable' CheckBox
local GreedAfterNeed = CreateFrame("CheckButton", O.."Enable", RewardPanel, "OptionsCheckButtonTemplate")
_G[GreedAfterNeed:GetName().."Text"]:SetText(L["greedifnothing"])
GreedAfterNeed:SetScript("OnClick", function(self) 
	ptable.TempConfig.greedifnothingfound = self:GetChecked() == 1
end)

--[[ CONTROL PLACEMENT]]--
description:SetPoint("TOPLEFT", 16, -8)
WeaponPanel:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -20)
ArmorPanel:SetPoint("TOPLEFT", WeaponPanel, "BOTTOMLEFT", 0, -20)
StatPanel:SetPoint("TOPLEFT", ArmorPanel, "BOTTOMLEFT", 0, -20)
GreedAfterNeed:SetPoint("TOPLEFT", StatPanel, "BOTTOMLEFT", 8, -16)

--[[ PANEL FINCTIONS ]]--
local AC = {[NONE_KEY]=1, [armor[2]]=2, [armor[3]]=3, [armor[4]]=4,[armor[5]]=5}
RewardPanel.refresh = function()
	WeaponPanel:ClearCheckBoxes()
	ArmorPanel:ClearCheckBoxes()
	StatPanel:ClearCheckBoxes()

	for k,v in pairs(ptable.TempConfig.weapon) do
		_G[WeaponPanel:GetName()..k]:SetChecked(v)
	end
	for k,v in pairs(ptable.TempConfig.stat) do
		_G[StatPanel:GetName()..k]:SetChecked(v)
	end
	
	GreedAfterNeed:SetChecked(ptable.TempConfig.greedifnothingfound )
	
	local armor = next(ptable.TempConfig.armor) 
	local index = armor and AC[armor] or 1
	UIDropDownMenu_SetSelectedID(ArmorDropDown, index)
	UIDropDownMenu_SetText(ArmorDropDown,  armor and armor or NONE_KEY)
end
--RewardPanel.default = function() end
--RewardPanel.okay = function()end

--[[ REGISTERING PANEL ]]--
InterfaceOptions_AddCategory(RewardPanel)