local addonName, ptable = ...
local L = ptable.L
AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")
AutoTurnIn.defaults = {enabled = true, all = false, dontloot = true, tournament = 2, darkmoonteleport=true, togglekey=1}

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
	if (AutoTurnInCharacterDB.togglekey == nil) then 
		AutoTurnInCharacterDB.togglekey = 1
	end
	
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
local funcList = {[1] = function() return false end, [2]=IsAltKeyDown, [3]=IsControlKeyDown, [4]=IsShiftKeyDown}

function AutoTurnIn:ConsoleComand(arg)	
	arg = strlower(arg)
	if (#arg == 0) then
		InterfaceOptionsFrame_OpenToCategory(_G["AutoTurnInOptionsPanel"])
	elseif arg == "on" then 
		if (not AutoTurnInCharacterDB.enabled) then 
			AutoTurnInCharacterDB.enabled = true
			self:RegisterGossipEvents()
		end
		self:Print(L["enabled"])
	elseif arg == "off"  then
		if AutoTurnInCharacterDB.enabled then 
			AutoTurnInCharacterDB.enabled = false
			self:UnregisterAllEvents()
		end
		self:Print(L["disabled"])
	elseif arg == "all" then 
		AutoTurnInCharacterDB.all = true
		self:Print(L["all"])
	elseif arg == "list" then 
		AutoTurnInCharacterDB.all = false
		self:Print(L["list"])
	elseif arg == "loot" then 
		AutoTurnInCharacterDB.dontloot = not AutoTurnInCharacterDB.dontloot 
		self:Print(L["dontloot"..tostring(AutoTurnInCharacterDB.dontloot)])
	elseif arg == "help" then 
		self:Print(p1[AutoTurnInCharacterDB.enabled == true]) 		
		self:Print(p2[AutoTurnInCharacterDB.all])
		self:Print(L["dontloot"..tostring(AutoTurnInCharacterDB.dontloot)])		
	end
end

local function GetItemAmount(isCurrency, item)
	local amount = isCurrency and select(2, GetCurrencyInfo(item)) or GetItemCount(item, nil, true)
	return amount and amount or 0
end 

local function AllowedToHandle()
	-- Double 'not' converts possible 'nil' to boolean representation
	local IsModifiedClick = not not funcList[AutoTurnInCharacterDB.togglekey]()
	-- it's a simple xor implementation (a ~= b) 
	AutoTurnIn.allowed = (not not AutoTurnInCharacterDB.enabled) ~= (IsModifiedClick)
	return AutoTurnIn.allowed
end

-- OldGossip interaction system. Burn in hell See http://wowprogramming.com/docs/events/QUEST_GREETING
function AutoTurnIn:QUEST_GREETING()
	if (not AllowedToHandle()) then 
		return 
	end 

	for index=1, GetNumActiveQuests() do 
		local quest, completed = GetActiveTitle(index)		
		if (AutoTurnInCharacterDB.all or L.quests[quest]) and (completed) then 
			SelectActiveQuest(index)
		end
	end
end

-- (gaq[i+3]) equals "1" if quest is complete, "nil" otherwise
-- why not 	gaq={GetGossipAvailableQuests()}? Well, tables in lua are truncated for values with ending `nil`. So: '#' for {1,nil, "b", nil} returns 1
function AutoTurnIn:GOSSIP_SHOW()	
	if (not AllowedToHandle()) then 
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
	if AutoTurnIn.allowed and (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) then
		QuestInfoDescriptionText:SetAlphaGradient(0, math.huge)
		QuestInfoDescriptionText:SetAlpha(1)
		AcceptQuest()
	end
end

function AutoTurnIn:QUEST_PROGRESS()
    if  AutoTurnIn.allowed and (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) and IsQuestCompletable() then
		CompleteQuest()
    end
end

function AutoTurnIn:QUEST_COMPLETE()
	if not AutoTurnIn.allowed then 
		return 
	end

	if (AutoTurnInCharacterDB.showrewardtext) then
		local gossip = UnitName("target")
		self:Print(gossip)
		self:Print(GetRewardText())
	end

	local quest = L.quests[GetTitleText()] 
    if AutoTurnInCharacterDB.all or quest then
		local index, money = 0, 0; 
		if GetNumQuestChoices() > 0 then 
			if not AutoTurnInCharacterDB.dontloot then
				if (quest == "tournament") then
					GetQuestReward(AutoTurnInCharacterDB.tournament)
					return
				end				
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
				else
					self:Print("rewards have no cost! Send a message to author please.")
				end 
			end
		else
			GetQuestReward(index)
		end
    end
end


local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
if LDB then 
	local dataObj = LDB:NewDataObject("AutoTurnIn", {
		type = "launcher",
		icon = "Interface\\QUESTFRAME\\UI-QuestLog-BookIcon",
		text="AutoTurnIn",
		OnClick = function(clickedframe, button)
			if InterfaceOptionsFrame:IsVisible() then 
				InterfaceOptionsFrameCancel:Click()			
			else
				InterfaceOptionsFrame_OpenToCategory(_G["AutoTurnInOptionsPanel"])
			end
		end,
	})
end
