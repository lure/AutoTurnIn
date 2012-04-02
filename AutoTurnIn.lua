local addonName, ptable = ...
local L = ptable.L
local C = ptable.CONST

AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")
AutoTurnIn.defaults = {enabled = true, all = false, dontloot = 1, tournament = 2, darkmoonteleport=true, togglekey=1}
AutoTurnIn.ldb, AutoTurnIn.allowed = nil, nil
local ldbstruct = {
		type = "data source",
		icon = "Interface\\QUESTFRAME\\UI-QuestLog-BookIcon",
		label = addonName,
		text = addonName,
		OnClick = function(clickedframe, button)
			if InterfaceOptionsFrame:IsVisible() then 
				InterfaceOptionsFrameCancel:Click()			
			else
				InterfaceOptionsFrame_OpenToCategory(_G["AutoTurnInOptionsPanel"])
			end
		end,
	}

local caption = addonName ..' [%s]'
function AutoTurnIn:SetEnabled(enabled)
	AutoTurnInCharacterDB.enabled = not not enabled
	if AutoTurnIn.ldb then 
		AutoTurnIn.ldb.text = caption:format((AutoTurnInCharacterDB.enabled) and 'on' or 'off' )
		AutoTurnIn.ldb.label = AutoTurnIn.ldb.text
	end
end
-- quest autocomplete handlers and functions
function AutoTurnIn:OnEnable()
	local vers = GetAddOnMetadata(addonName, "Version")

	if (not AutoTurnInDB) or (not AutoTurnInDB.version or (AutoTurnInDB.version < vers)) then 
		AutoTurnInCharacterDB = nil
		_G.AutoTurnInDB = {version = vers}
		self:Print(L["reset"])
	end
	
	if not AutoTurnInCharacterDB then 
		_G.AutoTurnInCharacterDB = CopyTable(AutoTurnIn.defaults)	
	end
	if (tonumber(AutoTurnInCharacterDB.togglekey) == nil) then 
		AutoTurnInCharacterDB.togglekey = 1
	end
	if ( AutoTurnInCharacterDB.items == nil ) then 
		AutoTurnInCharacterDB.items = {}
	end
	
	local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if LDB then 
		AutoTurnIn.ldb = LDB:NewDataObject("AutoTurnIn", ldbstruct)
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
		InterfaceOptionsFrame_OpenToCategory(_G["AutoTurnInOptionsPanel"])
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

local function GetItemAmount(isCurrency, item)
	local amount = isCurrency and select(2, GetCurrencyInfo(item)) or GetItemCount(item, nil, true)
	return amount and amount or 0
end 

local funcList = {[1] = function() return false end, [2]=IsAltKeyDown, [3]=IsControlKeyDown, [4]=IsShiftKeyDown}
local function AllowedToHandle(forcecheck)
	if ( AutoTurnIn.allowed == nil or forcecheck ) then 
		-- Double 'not' converts possible 'nil' to boolean representation
		local IsModifiedClick = not not funcList[AutoTurnInCharacterDB.togglekey]()
		-- it's a simple xor implementation (a ~= b) 
		AutoTurnIn.allowed = (not not AutoTurnInCharacterDB.enabled) ~= (IsModifiedClick)
	end
	return AutoTurnIn.allowed
end

-- OldGossip interaction system. Burn in hell See http://wowprogramming.com/docs/events/QUEST_GREETING
function AutoTurnIn:QUEST_GREETING()
	if (not AllowedToHandle(true)) then 
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
				if GetItemAmount(quest.currency, quest.item) >= quest.amount then 
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
function AutoTurnIn:GOSSIP_SHOW()	
	if (not AllowedToHandle(true)) then 
		return 
	end

	if (AutoTurnInCharacterDB.darkmoonteleport and (L["DarkmoonFaireTeleport"]==UnitName("target"))) then 
		SelectGossipOption(1)
		StaticPopup1Button1:Click()
	end

	local function VarArgForActiveQuests(...)	
		for i=1, select("#", ...), 4 do
			local completeStatus = select(i+3, ...) 
			if (completeStatus) then  -- complete status 
				local questname = select(i, ...)
				local quest = L.quests[questname]				
				if AutoTurnInCharacterDB.all or quest  then 
					if quest and quest.amount then 
						if GetItemAmount(quest.currency, quest.item) >= quest.amount then 
							SelectGossipActiveQuest(math.floor(i/4)+1)
							return						
						end
					else
						SelectGossipActiveQuest(math.floor(i/4)+1)
						return
					end
				end
			end		
		end
	end

	local function VarArgForAvailableQuests(...)
		for i=1, select("#", ...), 5 do
			local questname = select(i, ...)
			local quest = L.quests[questname] 
			if AutoTurnInCharacterDB.all or (quest and (not quest.donotaccept)) then			
				if quest and quest.amount then 
					if GetItemAmount(quest.currency, quest.item) >= quest.amount then 
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

	VarArgForActiveQuests(GetGossipActiveQuests())
	VarArgForAvailableQuests(GetGossipAvailableQuests())
end

function AutoTurnIn:QUEST_DETAIL()
	if AllowedToHandle() and (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) then
		QuestInfoDescriptionText:SetAlphaGradient(0, math.huge)
		QuestInfoDescriptionText:SetAlpha(1)
		AcceptQuest()
	end
end

function AutoTurnIn:QUEST_PROGRESS()
    if  AllowedToHandle() and (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) and IsQuestCompletable() then
		CompleteQuest()
    end
end

local function IsRangedWeapon(subclass)
	return (AutoTurnInCharacterDB.items['Ranged'] and (C.ITEMS['Crossbows'] == subclass or 
														C.ITEMS['Guns'] == subclass or 
														C.ITEMS['Bows'] == subclass))
end

local function IsJewelry(equipSlot)
	return AutoTurnInCharacterDB.items['Jewelry'] and (C.JEWELRY[equipSlot])
end

function AutoTurnIn:QUEST_COMPLETE()
	-- blasted Lands citadel wonderful NPC. They do not trigger any events except quest_complete. 
	if not AllowedToHandle() then 
		return 
	end
	
	if (AutoTurnInCharacterDB.showrewardtext) then
		local gossip = UnitName("target")
		if (gossip) then 
			self:Print(gossip)
		end
		self:Print(GetRewardText())
	end

	local quest = L.quests[GetTitleText()] 
    if AutoTurnInCharacterDB.all or quest then
		local index, money = 0, 0; 
		if GetNumQuestChoices() > 0 then 
			if AutoTurnInCharacterDB.dontloot > 1 then -- Auto Loot enabled! 
			
				-- Tournament quest found
				if (quest == "tournament") then
					GetQuestReward(AutoTurnInCharacterDB.tournament)
					return
				end	
				
				-- G R E E D
				if (AutoTurnInCharacterDB.dontloot == 2) then
					for i=1, GetNumQuestChoices() do
						local m = select(11, GetItemInfo(GetQuestItemLink("choice", i)))
						if m > money then
							money = m
							index = i
						end
					end
					if money > 0 then  -- some quests, like tournament ones, offer reputation rewards and they have no cost.
						GetQuestReward(index)
						return
					end
				end
				-- #G R E E D
				
				-- N E E D
				if (AutoTurnInCharacterDB.dontloot == 3) then
					local found = {}
					
					for i=1, GetNumQuestChoices() do
						local link = GetQuestItemLink("choice", i)
						local class, subclass, _, equipSlot = select(6, GetItemInfo(link))
						--[[relics and trinkets are out of autoloot
						if C.STOPTOKENS[equipSlot] then
							self:Print(INVTYPE_RELIC..' or ' .. INVTYPE_TRINKET .. ' found. Choose reward manually pls.')
							return
						end]]--
						if  AutoTurnInCharacterDB.items[subclass] or IsRangedWeapon(subclass) or IsJewelry(equipSlot) then 
							local stattable = GetItemStats(link)
							for stat, value in pairs(stattable) do
								if ( C.STATS[stat] ) then
									tinsert(found, i)
								end
							end
						end
					end
					
					print("Handle "..#found )
					-- HANDLE RESULT 
					if #found > 1 then
						for _, reward in pairs(found) do
							print("found: " .. GetQuestItemLink("choice", found[reward]))
						--_G["QuestInfoItem" .. index]
						end
					elseif(#found == 1) then
						print("found: " .. GetQuestItemLink("choice", found[1]))
						--GetQuestReward(found[1])
					end
				end
				-- #N E E D 
				
				
			end
		else
			--GetQuestReward(index)
		end
    end
end

-- gossip and quest interaction goes through a sequence of windows: gossip [shows a list of available quests] - quest[describes specified quest]
-- sometimes some parts of this chain is skipped. For example, priest in Honor Hold show quest window directly. This is a trick to handle 'toggle key' 
hooksecurefunc(QuestFrame, "Hide", function() AutoTurnIn.allowed = nil end)