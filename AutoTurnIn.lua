--[[
Feel free to use this source code for any purpose ( except developing nuclear weapon! :)
Please keep original author statement.
@author Alex Shubert (alex.shubert@gmail.com)
]]--

local addonName, ptable = ...
local L = ptable.L
local C = ptable.CONST
local TOCVersion = GetAddOnMetadata(addonName, "Version")

AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")
AutoTurnIn.defaults = {enabled = true, all = false, trivial = false, lootreward = 1, tournament = 2,
					   darkmoonteleport=true, togglekey=4, darkmoonautostart=true, showrewardtext=true, 
					   version=TOCVersion, autoequip = false, debug=false,
					   armor = {}, weapon = {}, stat = {}, secondary = {}}
AutoTurnIn.ldb, AutoTurnIn.allowed = nil, nil
AutoTurnIn.caption = addonName ..' [%s]'
AutoTurnIn.funcList = {[1] = function() return false end, [2]=IsAltKeyDown, [3]=IsControlKeyDown, [4]=IsShiftKeyDown}
AutoTurnIn.OptionsPanel, AutoTurnIn.RewardPanel = nil, nil
AutoTurnIn.autoEquipList={}

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
	AutoTurnInCharacterDB.secondary = AutoTurnInCharacterDB.secondary and AutoTurnInCharacterDB.secondary or {}
	AutoTurnInCharacterDB.trivial = AutoTurnInCharacterDB.trivial ~= nil and AutoTurnInCharacterDB.trivial or false

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
		local triviaAndAllowedOrNotTrivia = (not IsAvailableQuestTrivial(index)) or AutoTurnInCharacterDB.trivial
		local quest = L.quests[GetAvailableTitle(index)]
		if (triviaAndAllowedOrNotTrivia and (AutoTurnInCharacterDB.all or quest))then
			if quest and quest.amount then
				if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
					SelectAvailableQuest(index)
				end
			else
				SelectAvailableQuest(index)
			end
		end
	end
end

-- (gaq[i+3]) equals "1" if quest is complete, "nil" otherwise
-- why not 	gaq={GetGossipAvailableQuests()}? Well, tables in lua are truncated for values
-- with ending `nil`. So: '#' for {1,nil, "b", nil} returns 1
function AutoTurnIn:VarArgForActiveQuests(...)
    local MOP_INDEX_CONST = 5 -- was '4' in Cataclysm
	for i=1, select("#", ...), MOP_INDEX_CONST do
		local completeStatus = select(i+3, ...)
		if (completeStatus) then  -- complete status
			local questname = select(i, ...)
			local quest = L.quests[questname]
			if AutoTurnInCharacterDB.all or quest  then
				if quest and quest.amount then
					if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
						SelectGossipActiveQuest(math.floor(i/MOP_INDEX_CONST)+1)
						self.DarkmoonAllowToProceed = false
					end
				else
					SelectGossipActiveQuest(math.floor(i/MOP_INDEX_CONST)+1)
					self.DarkmoonAllowToProceed = false
				end
			end
		end
	end
end

-- like previous function this one works around `nil` values in a list.
function AutoTurnIn:VarArgForAvailableQuests(...)
	local MOP_INDEX_CONST = 6 -- was '5' in Cataclysm
	for i=1, select("#", ...), MOP_INDEX_CONST do
		local questname = select(i, ...)
		local isTrivial = select(i+2, ...)		
		local quest = L.quests[questname] -- this quest exists in questlist, stored in addons localization files. There are mostly daily quests
		local triviaAndAllowedOrNotTrivia = (not isTrivial) or AutoTurnInCharacterDB.trivial
		local inListAndAllowed = quest and (not quest.donotaccept)		

		-- Quest is appropriate if: (it is trivial and trivial are accepted) and (any quest accepted or (it is daily quest that is not in ignore list))
		if (triviaAndAllowedOrNotTrivia and (AutoTurnInCharacterDB.all or inListAndAllowed)) then
			if quest and quest.amount then
				if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
					SelectGossipAvailableQuest(math.floor(i/MOP_INDEX_CONST)+1)
				end
			else
				SelectGossipAvailableQuest(math.floor(i/MOP_INDEX_CONST)+1)
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

-- initiated in AutoTurnIn:TurnInQuest
AutoTurnIn.delayFrame = CreateFrame('Frame')
AutoTurnIn.delayFrame:Hide()
AutoTurnIn.delayFrame:SetScript('OnUpdate', function()
	if not next(AutoTurnIn.autoEquipList) then
		AutoTurnIn.delayFrame:Hide()
		return
	end

	if(time() < AutoTurnIn.delayFrame.delay) then
		return
	end

	for bag=0, NUM_BAG_SLOTS do
		for slot=1, GetContainerNumSlots(bag), 1 do
			local link = GetContainerItemLink (bag, slot)
			if ( link ) then
				local name = GetItemInfo(link)
				if ( name and AutoTurnIn.autoEquipList[name] ) then
					AutoTurnIn:Print(L["equipping reward"], link)
					EquipItemByName(name, AutoTurnIn.autoEquipList[name])
					AutoTurnIn.autoEquipList[name]=nil
				end
			end
		end
	end
end)

-- turns quest in printing reward text if `showrewardtext` option is set.
-- prints appropriate message if item is taken by greed
-- equips received reward if such option selected
function AutoTurnIn:TurnInQuest(rewardIndex)
	if (AutoTurnInCharacterDB.showrewardtext) then
		self:Print((UnitName("target") and  UnitName("target") or '')..'\n', GetRewardText())
	end

	if self.forceGreed then
		if GetNumQuestChoices() > 0 then 
			self:Print(L["gogreedy"])
		end
	else
		local name = GetQuestItemInfo("choice", rewardIndex)
		if (AutoTurnInCharacterDB.autoequip and (strlen(name) > 0)) then
			local lootLevel, _, _, _, _, equipSlot = select(4, GetItemInfo(GetQuestItemLink("choice", rewardIndex)))

			-- Compares reward and already equiped item levels. If reward level is greater than equiped item, auto equip reward
			local slots = C.SLOTS[equipSlot]
			local slotNumber = GetInventorySlotInfo(slots[1])
			local invLink = GetInventoryItemLink("player", slotNumber)
			local eqLevel = select(4, GetItemInfo(invLink))
			-- If reward is a ring  trinket or one-handed weapons all slots must be checked in order to swap one with a lesser item-level
			if (#slots > 1) then
				invLink = GetInventoryItemLink("player", GetInventorySlotInfo(slots[2]))
				if (invLink) then 
					local eq2Level = select(4, GetItemInfo(invLink))
					eqLevel = (eqLevel > eq2Level) and eq2Level or eqLevel
					slotNumber = (eqLevel > eq2Level) and GetInventorySlotInfo(slots[2]) or slotNumber
				end
			end
			if(lootLevel > eqLevel) then
				self.autoEquipList[name] = slotNumber
				self.delayFrame.delay = time() + 2
				self.delayFrame:Show()
			end
		end
	end

	if (AutoTurnInCharacterDB.debug) then
		local link = GetQuestItemLink("choice", rewardIndex)
		if (link) then
			self:Print("Debug: item to loot=", GetQuestItemLink("choice", rewardIndex))
		elseif (GetNumQuestChoices() == 0) then
			self:Print("Debug: turning quest in")
		end
	else
		GetQuestReward(rewardIndex)
	end
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

	for i=1, GetNumQuestChoices() do
		local link = GetQuestItemLink("choice", i)

		if ( link == nil ) then
			self:Print(L["rewardlag"])
			return true
		end

		local class, subclass, _, equipSlot = select(6, GetItemInfo(link))
		--[[trinkets are out of autoloot]]--
		if  ( 'INVTYPE_TRINKET' == equipSlot )then
			self:Print(L["stopitemfound"]:format(_G[equipSlot]))
			return true
		end
		local itemCandidate = {index=i, points=0, type="", stat="NOTCHOSEN", secondary={}}

		-- TYPE: item is suitable if there are no type specified at all or item type is chosen
		local OkByType = false
		if class == C.WEAPONLABEL then
			OkByType = (not next(AutoTurnInCharacterDB.weapon)) or (AutoTurnInCharacterDB.weapon[subclass] or
						self:IsRangedAndRequired(subclass))
		else
			OkByType = ( not next(AutoTurnInCharacterDB.armor) ) or ( AutoTurnInCharacterDB.armor[subclass] or
						AutoTurnInCharacterDB.armor[equipSlot] or self:IsJewelryAndRequired(equipSlot) )
		end
		itemCandidate.type=subclass .. ((not not OkByType) and "=>OK" or "=>FAIL")

		--STAT+SECONDARY: Same here: if no stat specified or item stat is chosen then item is wanted
		local OkByStat = not next(AutoTurnInCharacterDB.stat) 					-- true if table is empty
		local OkBySecondary = not next(AutoTurnInCharacterDB.secondary) -- true if table is empty
		if (not (OkByStat and OkBySecondaryStat)) then
			wipe(self.stattable)
			GetItemStats(link, self.stattable)
			for stat, value in pairs(self.stattable) do
				if ( AutoTurnInCharacterDB.stat[stat] ) then
					OkByStat = true
					itemCandidate.stat=_G[stat].."=>OK"
				end
				if ( AutoTurnInCharacterDB.secondary[stat] ) then
					OkBySecondary = true
					itemCandidate.points =  itemCandidate.points + 1
					tinsert(itemCandidate.secondary, _G[stat])
				end
			end
		end

		-- User may not choose any options hence any item became 'ok'. That situation is undoubtly incorrect.
		local SettingsExists = (class == C.WEAPONLABEL and next(AutoTurnInCharacterDB.weapon) or next(AutoTurnInCharacterDB.armor))
								or next(AutoTurnInCharacterDB.stat)
 		-- OK means that particular options section is empty or item meets requirements
		if (OkByType and OkByStat and OkBySecondary and SettingsExists) then
			tinsert(self.found, itemCandidate)
		end

		if (AutoTurnInCharacterDB.debug) then
			local secondaryDebug = ""
			for _, sec in pairs(itemCandidate.secondary) do
				secondaryDebug = sec..","..secondaryDebug
			end
			self:Print("Debug:", GetQuestItemLink("choice", itemCandidate.index), " type:", itemCandidate.type,
						" stat:", itemCandidate.stat, " secondary:[", secondaryDebug, "]=>", itemCandidate.points)
		end
	end

	-- HANDLE RESULT
	local foundCount = #self.found
	if foundCount > 1 then
		-- sorting found items by relevance (count of attributes that concidence)
		table.sort(self.found, function(a,b) return a.points > b.points end)

		if (self.found[1].points == self.found[2].points) then
			self:Print(L["multiplefound"])
			for _, reward in pairs(self.found) do
				self:Print(GetQuestItemLink("choice", reward.index))
			end
		else
			self:TurnInQuest(self.found[1].index)
		end
	elseif(foundCount == 1) then
		self:TurnInQuest(self.found[1].index)
	elseif  ( foundCount == 0 and GetNumQuestChoices() > 0 ) and ( not AutoTurnInCharacterDB.greedifnothingfound ) then
		self:Print(L["nosuitablefound"])
	end

	return ( foundCount ~= 0 )
end

-- I was forced to make decision on offhands, cloack and shileds separate from armor but I can't pick up my mind about the reason...
function AutoTurnIn:QUEST_COMPLETE()
	-- blasted Lands citadel wonderful NPC. They do not trigger any events except quest_complete.
	if not self:AllowedToHandle() then
		return
	end

	local quest = L.quests[GetTitleText()]
    if AutoTurnInCharacterDB.all or quest then
		if GetNumQuestChoices() > 1 then
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
			self:TurnInQuest(1)
		end
    end
end

-- gossip and quest interaction goes through a sequence of windows: gossip [shows a list of available quests] - quest[describes specified quest]
-- sometimes some parts of this chain is skipped. For example, priest in Honor Hold show quest window directly. This is a trick to handle 'toggle key'
hooksecurefunc(QuestFrame, "Hide", function() AutoTurnIn.allowed = nil end)