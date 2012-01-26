local addonName, ptable = ...
local L = ptable.L
AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")

-- quest autocomplete handlers and functions
function AutoTurnIn:OnEnable()
	if not AutoTurnInCharacterDB then 
		AutoTurnInCharacterDB = {enabled = true, all = false, loot = false}
	end
	if AutoTurnInCharacterDB.enabled then 
		self:RegisterGossipEvents()
	end
end

function AutoTurnIn:RegisterGossipEvents()
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
end

function AutoTurnIn:OnDisable()
  self:UnregisterAllEvents()
end

function AutoTurnIn:OnInitialize()
	self:RegisterChatCommand("au", "ConsoleComand")
end

local p1 = {
	[true]=L["enabled"],
	[false]=L["disabled"]
}
local p2 = {
	[true]=L["all"],
	[false]=L["list"]
}


function AutoTurnIn:ConsoleComand(arg)	
	if (#arg == 0) then
		InterfaceOptionsFrame_OpenToCategory(AutoTurnInOptionsPanel)
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
		AutoTurnInCharacterDB.lootMostExpensive = not AutoTurnInCharacterDB.lootMostExpensive 
		self:Print(L["loot"..tostring(AutoTurnInCharacterDB.lootMostExpensive)])
	elseif arg == "help" then 
		self:Print(L["usage1"] .. " | " .. p1[AutoTurnInCharacterDB.enabled]) 		
		self:Print(L["usage2"] .. " | " .. p2[AutoTurnInCharacterDB.all])
		self:Print(L["usage3"] .. " | " .. L["loot"..tostring(AutoTurnInCharacterDB.lootMostExpensive)])		
	end
end


-- (gaq[i+3]) equals "1" if quest is complete, "nil" otherwise
function AutoTurnIn:GOSSIP_SHOW()
	if (GetGossipActiveQuests()) then  
		local gaq = {GetGossipActiveQuests()}
	
		for i=1, #gaq, 4 do
			if (gaq[i+3]) then 
				local quest = L.quests[gaq[i]]
				if AutoTurnInCharacterDB.all or quest then 
					if quest and quest.amount then 
						local has = 0
						if quest.currency then 
							_, has = GetCurrencyInfo(quest.item)
						else 
							has = GetItemCount(quest.item, nil, true)
						end
						if has > quest.amount then 
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
	
	if (GetGossipAvailableQuests()) then
		gaq={GetGossipAvailableQuests()}
		for i=1, #gaq, 5 do
			if AutoTurnInCharacterDB.all or L.quests[gaq[i]] then 
				SelectGossipAvailableQuest(math.floor(i/5)+1)
				return
			end
		end
	end
end

function AutoTurnIn:QUEST_DETAIL()
	if AutoTurnInCharacterDB.all or L.quests[GetTitleText()] then
		QuestInfoDescriptionText:SetAlphaGradient(0, math.huge)
		QuestInfoDescriptionText:SetAlpha(1)
		AcceptQuest()
	end
end

function AutoTurnIn:QUEST_PROGRESS() 
    if (AutoTurnInCharacterDB.all or L.quests[GetTitleText()]) and IsQuestCompletable() then
		CompleteQuest()
    end
end

function AutoTurnIn:QUEST_COMPLETE()
    if AutoTurnInCharacterDB.all or L.quests[GetTitleText()] then
		local index, money = 0, 0; 
		if GetNumQuestChoices() > 0 then 
			if AutoTurnInCharacterDB.lootMostExpensive then
				for i=1, GetNumQuestChoices() do
					local m = select(11, GetItemInfo(GetQuestItemLink("choice", i)))
					if m > money then
						money = m
						index = i
					end
				end
				GetQuestReward(index)
			end
		else
			GetQuestReward(index)
		end
    end
end