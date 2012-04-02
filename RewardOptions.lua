local addonName, ptable = ...
local C = ptable.CONST
local O = addonName .. "RewardPanel"
local RewardPanel = CreateFrame("Frame", O)
RewardPanel.name= QUEST_REWARDS

local function CreateCheckbox(name, parent, marginx, marginy, text)
	local cb = CreateFrame("CheckButton", "$parent"..name,  parent, "OptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", parent, marginx, marginy)
	_G[cb:GetName().."Text"]:SetText(text and text or name)
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
CreateCheckbox(armor[2], ArmorPanel, 10, -8)
CreateCheckbox(armor[3], ArmorPanel, 152, -8)
CreateCheckbox(armor[4], ArmorPanel, 292, -8)
CreateCheckbox(armor[5], ArmorPanel, 436, -8)
	-- 2nd line 
CreateCheckbox(armor[6], ArmorPanel, 10, -40)
CreateCheckbox("Jewelry", ArmorPanel, 292, -40, ptable.L['Jewelry'] )
	
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

