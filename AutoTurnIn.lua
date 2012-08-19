local addonName, ptable = ...
local L = ptable.L
local C = ptable.CONST
local TOCVersion = GetAddOnMetadata(addonName, "Version")

AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")
AutoTurnIn.defaults = {enabled = true, all = false, lootreward = 1, tournament = 2, 
					   darkmoonteleport=true, togglekey=2, darkmoonautostart=true, showrewardtext=true, version=TOCVersion, autoequip = false}
AutoTurnIn.ldb, AutoTurnIn.allowed = nil, nil
AutoTurnIn.caption = addonName ..' [%s]'
AutoTurnIn.funcList = {[1] = function() return false end, [2]=IsAltKeyDown, [3]=IsControlKeyDown, [4]=IsShiftKeyDown}
AutoTurnIn.OptionsPanel, AutoTurnIn.RewardPanel = nil, nil

AutoTurnIn.ldbstruct = {
		type = "data source",
		icon = "Interface\\QUESTFRAME\\UI-QuestLog-BookIcon",
		label = addonName,
		text = addonName,
		OnClick = function(clickedframe, button)
			if InterfaceOptionsFrame:IsVisible() then
				if (InterfaceOptionsFrameAddOns.selection:GetName() == AutoTurnIn.OptionsPanel:GetName()) then --"AutoTurnInOptionsPanel"
					InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.RewardPanel)
				elseif (InterfaceOptionsFrameAddOns.selection:GetName() == AutoTurnIn.RewardPanel:GetName() ) then --"AutoTurnInRewardPanel"
					InterfaceOptionsFrameCancel:Click()
				end
			else
				InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)
			end
		end,
	}

function AutoTurnIn:SetEnabled(enabled)
	AutoTurnInCharacterDB.enabled = not not enabled
	if self.ldb then
		self.ldb.text = self.caption:format((AutoTurnInCharacterDB.enabled) and 'on' or 'off' )
		self.ldb.label = self.ldb.text
	end
end
-- quest autocomplete handlers and functions
function AutoTurnIn:OnEnable()
	if (not AutoTurnInCharacterDB) or (not AutoTurnInCharacterDB.version or (AutoTurnInCharacterDB.version < TOCVersion)) then
		AutoTurnInCharacterDB = nil
		self:Print(L["reset"])
	end

	if not AutoTurnInCharacterDB then
		_G.AutoTurnInCharacterDB = CopyTable(self.defaults)
	end
	if (tonumber(AutoTurnInCharacterDB.lootreward) == nil) then
		AutoTurnInCharacterDB.lootreward = 1
	end
	if (tonumber(AutoTurnInCharacterDB.togglekey) == nil) then
		AutoTurnInCharacterDB.togglekey = 1
	end
	AutoTurnInCharacterDB.armor = AutoTurnInCharacterDB.armor and AutoTurnInCharacterDB.armor or {}
	AutoTurnInCharacterDB.weapon = AutoTurnInCharacterDB.weapon and AutoTurnInCharacterDB.weapon or {}
	AutoTurnInCharacterDB.stat = AutoTurnInCharacterDB.stat and AutoTurnInCharacterDB.stat or {}

	local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if LDB then
		self.ldb = LDB:NewDataObject("AutoTurnIn", self.ldbstruct)
	end

	self:SetEnabled(AutoTurnInCharacterDB.enabled)
	self:RegisterGossipEvents()
end

function AutoTurnIn:RegisterGossipEvents()
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_COMPLETE")
end

function AutoTurnIn:OnDisable()
  self:UnregisterAllEvents()
end

function AutoTurnIn:OnInitialize()
	self:RegisterChatCommand("au", "ConsoleComand")
end

local p1 = {[true]=L["enabled"], [false]=L["disabled"]}
local p2 = {[true]=L["all"], [false]=L["list"]}
function AutoTurnIn:ConsoleComand(arg)
	arg = strlower(arg)
	if (#arg == 0) then
		InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)
	elseif arg == "on" then
		self:SetEnabled(true)
		self:Print(L["enabled"])
	elseif arg == "off"  then
		self:SetEnabled(false)
		self:Print(L["disabled"])
	elseif arg == "all" then
		AutoTurnInCharacterDB.all = true
		self:Print(L["all"])
	elseif arg == "list" then
		AutoTurnInCharacterDB.all = false
		self:Print(L["list"])
	elseif arg == "help" then
		self:Print(p1[AutoTurnInCharacterDB.enabled == true])
		self:Print(p2[AutoTurnInCharacterDB.all])
	end
end


-- returns specified item count on player character. It may be some sort of currency or present in inventory as real items.
function AutoTurnIn:GetItemAmount(isCurrency, item)
	local amount = isCurrency and select(2, GetCurrencyInfo(item)) or GetItemCount(item, nil, true)
	return amount and amount or 0
end

-- returns set 'self.allowed' to true if addon is allowed to handle current gossip conversation 
-- Cases when it may not : (addon is enabled and toggle key was pressed) or (addon is disabled and toggle key is not presse)
-- 'forcecheck' does what it name says: forces check 
function AutoTurnIn:AllowedToHandle(forcecheck)
	if ( self.allowed == nil or forcecheck ) then
		-- Double 'not' converts possible 'nil' to boolean representation
		local IsModifiedClick = not not self.funcList[AutoTurnInCharacterDB.togglekey]()
		-- it's a simple xor implementation (a ~= b)
		self.allowed = (not not AutoTurnInCharacterDB.enabled) ~= (IsModifiedClick)
	end
	return self.allowed
end

-- OldGossip interaction system. Burn in hell. See http://wowprogramming.com/docs/events/QUEST_GREETING
function AutoTurnIn:QUEST_GREETING()
	if (not self:AllowedToHandle(true)) then
		return
	end
	for index=1, GetNumActiveQuests() do
		local quest, completed = GetActiveTitle(index)
		if (AutoTurnInCharacterDB.all or L.quests[quest]) and (completed) then
			SelectActiveQuest(index)
		end
	end

	for index=1, GetNumAvailableQuests() do
		local quest = L.quests[GetAvailableTitle(index)]
		if (AutoTurnInCharacterDB.all or quest)then
			if quest and quest.amount then
				if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
					SelectAvailableQuest(index)
					return
				end
			else
				SelectAvailableQuest(index)
			end
		end
	end
end

-- (gaq[i+3]) equals "1" if quest is complete, "nil" otherwise
-- why not 	gaq={GetGossipAvailableQuests()}? Well, tables in lua are truncated for values with ending `nil`. So: '#' for {1,nil, "b", nil} returns 1
function AutoTurnIn:VarArgForActiveQuests(...)
	for i=1, select("#", ...), 4 do
		local completeStatus = select(i+3, ...)
		if (completeStatus) then  -- complete status
			local questname = select(i, ...)
			local quest = L.quests[questname]
			if AutoTurnInCharacterDB.all or quest  then
				if quest and quest.amount then
					if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
						SelectGossipActiveQuest(math.floor(i/4)+1)
						self.DarkmoonAllowToProceed = false
						return
					end
				else
					SelectGossipActiveQuest(math.floor(i/4)+1)
					self.DarkmoonAllowToProceed = false
					return
				end
			end
		end
	end
end

-- like previous function this one works around `nil` values in a list.
function AutoTurnIn:VarArgForAvailableQuests(...)
	for i=1, select("#", ...), 5 do
		local questname = select(i, ...)
		local quest = L.quests[questname]
		if AutoTurnInCharacterDB.all or (quest and (not quest.donotaccept)) then
			if quest and quest.amount then
				if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
					SelectGossipAvailableQuest(math.floor(i/5)+1)
					return
				end
			else
				SelectGossipAvailableQuest(math.floor(i/5)+1)
				return
			end
		end
	end
end

function AutoTurnIn:GOSSIP_SHOW()
	if (not self:AllowedToHandle(true)) then
		return
	end

	if (AutoTurnInCharacterDB.darkmoonteleport and (L["DarkmoonFaireTeleport"]==UnitName("target"))) then
		SelectGossipOption(1)
		StaticPopup1Button1:Click()
	end
	-- darkmoon fairy gossip sometime turns in quest too fast so I can't relay only on quest number count. It often lie.
	self.DarkmoonAllowToProceed = true
	local questCount = GetNumGossipActiveQuests() > 0
	self:VarArgForActiveQuests(GetGossipActiveQuests())
	self:VarArgForAvailableQuests(GetGossipAvailableQuests())

	if (self.DarkmoonAllowToProceed and questCount) and AutoTurnInCharacterDB.darkmoonautostart and (GetZoneText() == L["Darkmoon Island"]) then
		local options = {GetGossipOptions()}
		for k, v in pairs(options) do
			if ((v ~= "gossip") and strfind(v, "|cFF0008E8%(")) then
				SelectGossipOption(math.floor(k / GetNumGossipOptions())+1)
			end
		end
	end
end

function AutoTurnIn:QUEST_DETAIL()
	if self:AllowedToHandle() and (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) then
		QuestInfoDescriptionText:SetAlphaGradient(0, -1)
		QuestInfoDescriptionText:SetAlpha(1)
		AcceptQuest()
	end
end

function AutoTurnIn:QUEST_PROGRESS()
    if  self:AllowedToHandle() and (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) and IsQuestCompletable() then
		CompleteQuest()
    end
end

-- return true if an item is of `ranged` type and is suitable with current options
function AutoTurnIn:IsRangedAndRequired(subclass)
	return (AutoTurnInCharacterDB.weapon['Ranged'] and
		(C.ITEMS['Crossbows'] == subclass or C.ITEMS['Guns'] == subclass or C.ITEMS['Bows'] == subclass))
end

-- return true if an item is of `Jewelry` type and is suitable with current options
function AutoTurnIn:IsJewelryAndRequired(equipSlot)
	return AutoTurnInCharacterDB.armor['Jewelry'] and (C.JEWELRY[equipSlot])
end

--[[ doesn't work. Frame appear faster than items loaded. Need rework. It is called nowhere right now
local function TryToLoadRewards()
	local title = GetTitleText()
	numEntries = GetNumQuestLogEntries()
	for questIndex=1, numEntries do
		questLogTitleText, _, _, _, isHeader = GetQuestLogTitle(questIndex)
		if (not isHeader) then
			if title == questLogTitleText then
				SelectQuestLogEntry(questIndex)
				if not QuestLogFrame:IsVisible() then
					QuestLogFrame:Show()
					QuestLogFrame:Hide()
				end
			end
		end
	end
end]]--

function AutoTurnIn:AutoEquip(rewardIndex)
	if (AutoTurnInCharacterDB.autoequip and rewardIndex) then 
		EquipItemByName(GetQuestItemLink("choice", rewardIndex))
	end
end

-- turns quest in printing reward text if `showrewardtext` option is set. 
-- prints appropriate message if item is taken by greed 
function AutoTurnIn:TurnInQuest(rewardIndex)	
	if (AutoTurnInCharacterDB.showrewardtext) then
		self:Print((UnitName("target") and  UnitName("target") or '')..'\n', GetRewardText())
	end
	if  self.forceGreed then 
		self:Print(L["gogreedy"])
	end

	if (rewardIndex) then 
		self:Print("debug " .. rewardIndex)
		self:Print("debug " .. GetQuestItemLink("choice", rewardIndex))
	end
	GetQuestReward(rewardIndex)
	AutoEquip(rewardIndex)	
end

function AutoTurnIn:Greed()
	local index, money = 0, 0;

	for i=1, GetNumQuestChoices() do
		local link = GetQuestItemLink("choice", i)
		if ( link == nil ) then
			return
		end
		local m = select(11, GetItemInfo(link))
		if m > money then
			money = m
			index = i
		end
	end
	if money > 0 then  -- some quests, like tournament ones, offer reputation rewards and they have no cost.
		self:TurnInQuest(index)
	end
end

--[[ 
iterates all rewards and compares with chosen stats and types. If only one appropriate item found then it accepted and quest is turned in. 
if more than one suitable item found then item list is shown in a chat window and addons return control to player. 

@returns 'true' if one or more suitable reward is found, 'false' otherwise ]]--
-- tables are declared here to optimize memory model. Said that in current implementation it's cheaper to wipe than to create.
AutoTurnIn.found, AutoTurnIn.stattable = {}, {} 
function AutoTurnIn:Need()
	wipe(self.found)
	local rewardsCount = GetNumQuestChoices()
	
	if ( rewardsCount < 2 ) then 
		self:TurnInQuest(1)
		return true
	end
	
	for i=1, GetNumQuestChoices() do
		local link = GetQuestItemLink("choice", i)

		if ( link == nil ) then
			self:Print(L["rewardlag"])
			return true
		end

		local class, subclass, _, equipSlot = select(6, GetItemInfo(link))
		--[[relics and trinkets are out of autoloot]]--
		if  (UnitHasRelicSlot("player") and 'INVTYPE_RELIC' == equipSlot) or 'INVTYPE_TRINKET' == equipSlot then
			self:Print(L["stopitemfound"]:format(_G[equipSlot]))
			return true
		end

		-- item is suitable is there are no type cpecified at all or item type is required
		local OkByType = false
		if class == C.WEAPONLABEL then
			OkByType = (not next(AutoTurnInCharacterDB.weapon)) or (AutoTurnInCharacterDB.weapon[subclass] or 
						self:IsRangedAndRequired(subclass))
		else
			OkByType = ( not next(AutoTurnInCharacterDB.armor) ) or ( AutoTurnInCharacterDB.armor[subclass] or 
						AutoTurnInCharacterDB.armor[equipSlot] or self:IsJewelryAndRequired(equipSlot) )
		end

		--Same here: if no stat specified or item stat is chosen then item is wanted
		local OkByStat = (not next(AutoTurnInCharacterDB.stat)) -- true if table is empty
		if (not OkByStat) and ('INVTYPE_RELIC' ~= equipSlot) then
			wipe(self.stattable)
			GetItemStats(link, self.stattable)
			for stat, value in pairs(self.stattable) do
				if ( AutoTurnInCharacterDB.stat[stat] ) then
					OkByStat = true
				end
			end
		end

		-- User may not choose any options hence any item became 'ok'. That situation is undoubtly incorrect.
		local EmptySettings = (class == C.WEAPONLABEL and (not next(AutoTurnInCharacterDB.weapon)) or (not next(AutoTurnInCharacterDB.armor))) and 
							  (not next(AutoTurnInCharacterDB.stat))
		
		if (OkByType and OkByStat and (not EmptySettings)) then
			tinsert(self.found, i)
		end
	end

	-- HANDLE RESULT
	if #self.found > 1 then
		local vars = ""
		for _, reward in pairs(self.found) do
			vars = vars..' '..GetQuestItemLink("choice", reward)
		end
		self:Print(L["multiplefound"])	
	elseif(#self.found == 1) then
		self:TurnInQuest(self.found[1])
	end

	if  ( #self.found == 0 and GetNumQuestChoices() > 0 ) and ( not AutoTurnInCharacterDB.greedifnothingfound ) then 
		self:Print(L["nosuitablefound"])
	end	
	return ( #self.found ~= 0 )
end

-- I was forced to make decision on offhands, cloack and shileds separate from armor but I can't pick up my mind about the reason...
function AutoTurnIn:QUEST_COMPLETE()
	-- blasted Lands citadel wonderful NPC. They do not trigger any events except quest_complete.
	if not self:AllowedToHandle() then
		return
	end

	local quest = L.quests[GetTitleText()]
    if AutoTurnInCharacterDB.all or quest then
		if GetNumQuestChoices() > 0 then
			if AutoTurnInCharacterDB.lootreward > 1 then -- Auto Loot enabled!
				self.forceGreed = false 
				
				-- Tournament quest found
				if (quest == "tournament") then
					self:TurnInQuest(AutoTurnInCharacterDB.tournament)
					return
				end
			
				if (AutoTurnInCharacterDB.lootreward == 3) then
					self.forceGreed = (not self:Need() ) and AutoTurnInCharacterDB.greedifnothingfound
				end
				if (AutoTurnInCharacterDB.lootreward == 2 or self.forceGreed) then
					self:Greed()
				end
			end
		else
			self:TurnInQuest(nil)
		end
    end
end

-- gossip and quest interaction goes through a sequence of windows: gossip [shows a list of available quests] - quest[describes specified quest]
-- sometimes some parts of this chain is skipped. For example, priest in Honor Hold show quest window directly. This is a trick to handle 'toggle key'
hooksecurefunc(QuestFrame, "Hide", function() AutoTurnIn.allowed = nil end)