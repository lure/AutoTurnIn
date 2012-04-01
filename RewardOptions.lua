local addonName, ptable = ...
local C = ptable.CONST
local O = addonName .. "RewardPanel"
local RewardPanel = CreateFrame("Frame", O)
RewardPanel.name= QUEST_REWARDS

local function CreateCheckbox(name, parent, marginx, marginy, text)
	local cb = CreateFrame("CheckButton", "$parent"..name,  parent, "OptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", parent, marginx, marginy)
	_G[cb:GetName().."Text"]:SetText(text)
	cb:SetScript("OnClick", function(self)
		ptable.TempConfig.items[name] = self:GetChecked() == 1
	end)
	tinsert(parent.buttons, cb)
	return cb
end 

local function CreatePanel(name, text, w, h)
	local panel = CreateFrame("Frame", O..name,  RewardPanel, "OptionsBoxTemplate")
	panel:SetWidth(w)
	panel:SetHeight(h)
	panel.buttons = {}
	function panel:ClearCheckBoxes() 
		for k,v in ipairs(self.buttons) do 
			v:SetChecked(false)
		end
	end
	_G[panel:GetName().."Title"]:SetText(text)
	return panel
end

-- Description
local description = RewardPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetText("Reward loot options")
RewardPanel.parent = _G["AutoTurnInOptionsPanel"]

-- WEAPON
local WeaponPanel = CreatePanel("WeaponPanel", C.WEAPONLABEL, 590, 170)
CreateCheckbox("One-Handed Axes", WeaponPanel, 10, -8, C.ITEMS['One-Handed Axes'])
CreateCheckbox("Two-Handed Axes", WeaponPanel, 206, -8, C.ITEMS['Two-Handed Axes'] )
CreateCheckbox("One-Handed Maces", WeaponPanel, 402, -8, C.ITEMS['One-Handed Maces'])
	-- 2nd line 
CreateCheckbox("Two-Handed Maces", WeaponPanel, 10, -40, C.ITEMS['Two-Handed Maces'])
CreateCheckbox("Polearms", WeaponPanel, 206, -40, C.ITEMS['Polearms'])
CreateCheckbox("One-Handed Swords", WeaponPanel, 402, -40, C.ITEMS['One-Handed Swords'] )
    -- 3rd line
CreateCheckbox("Two-Handed Swords", WeaponPanel, 10, -72, C.ITEMS['Two-Handed Swords'])
CreateCheckbox("Staves", WeaponPanel, 206, -72, C.ITEMS['Staves'])
CreateCheckbox("Fist Weapons", WeaponPanel, 402, -72, C.ITEMS['Fist Weapons'])
	-- 4rd line
CreateCheckbox("Daggers", WeaponPanel, 10, -104, C.ITEMS['Daggers'] )
CreateCheckbox("Thrown", WeaponPanel, 206, -104, C.ITEMS['Thrown'])
CreateCheckbox("Wands", WeaponPanel, 402, -104, C.ITEMS['Wands'])
CreateCheckbox("Ranged", WeaponPanel, 10, -136, string.format("%s, %s, %s", C.ITEMS['Crossbows'], C.ITEMS['Bows'], C.ITEMS['Guns']) )


-- ARMOR 
local ArmorPanel = CreatePanel("ArmorPanel", C.ARMORLABEL, 590, 70)
CreateCheckbox("Cloth", ArmorPanel, 10, -8, C.ITEMS['Cloth'])
CreateCheckbox("Leather", ArmorPanel, 152, -8, C.ITEMS['Leather'] )
CreateCheckbox("Mail", ArmorPanel, 292, -8, C.ITEMS['Mail'])
CreateCheckbox("Plate", ArmorPanel, 436, -8, C.ITEMS['Plate'])
CreateCheckbox("Shields", ArmorPanel, 10, -40, C.ITEMS['Shields'])
	
-- ATTRIBUTES
local StatPanel = CreatePanel("StatPanel", STAT_CATEGORY_ATTRIBUTES, 590, 40) 
CreateCheckbox("Strength", StatPanel, 10, -8, SPELL_STAT1_NAME)
CreateCheckbox("Agility", StatPanel, 152, -8, SPELL_STAT2_NAME)
CreateCheckbox("Intellect", StatPanel, 292, -8, SPELL_STAT4_NAME)
CreateCheckbox("Spirit", StatPanel, 436, -8, SPELL_STAT5_NAME)

--[[ CONTROL PLACEMENT]]--
description:SetPoint("TOPLEFT", 16, -8)
WeaponPanel:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -20)
ArmorPanel:SetPoint("TOPLEFT", WeaponPanel, "BOTTOMLEFT", 0, -20)
StatPanel:SetPoint("TOPLEFT", ArmorPanel, "BOTTOMLEFT", 0, -20)

--[[ PANEL FINCTIONS ]]--
RewardPanel.refresh = function()
	WeaponPanel:ClearCheckBoxes()
	ArmorPanel:ClearCheckBoxes()
	StatPanel:ClearCheckBoxes()
	
	for k,v in pairs(ptable.TempConfig.items) do 
		local w = _G[WeaponPanel:GetName()..k]
		if not w then 
			w = _G[ArmorPanel:GetName()..k]
		end
		if not w then 
			w = _G[StatPanel:GetName()..k]
		end
		if w then
			w:SetChecked(v) 
		end
	end
end
--RewardPanel.default = function() end
--RewardPanel.okay = function()end

--[[ REGISTERING PANEL ]]--
InterfaceOptions_AddCategory(RewardPanel)

