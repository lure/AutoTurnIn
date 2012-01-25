AutoTurnin = LibStub("AceAddon-3.0"):NewAddon("AutoTurnin", "AceEvent-3.0", "AceConsole-3.0")

-- quest autocomplete handlers and functions
function AutoTurnin:OnEnable()
	if not AutoTurninCharacterDB then 
		AutoTurninCharacterDB = {enabled = true, all = false, loot=false}
	end
	if AutoTurninCharacterDB.enabled then 
		self:RegisterGossipEvents()
	end
end

function AutoTurnin:RegisterGossipEvents()
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
end

function AutoTurnin:OnDisable()
  self:UnregisterAllEvents()
end

function AutoTurnin:OnInitialize()
	self:RegisterChatCommand("au", "ConsoleComand")
end

function AutoTurnin:ConsoleComand(arg)	
	if (#arg == 0) then 
		self:Print(AutoTurnin.L["usage1"])
		self:Print(AutoTurnin.L["usage2"])
		self:Print(AutoTurnin.L["usage3"])
	elseif arg == "on" then 
		if (not AutoTurninCharacterDB.enabled) then 
			AutoTurninCharacterDB.enabled = true
			self:RegisterGossipEvents()
		end
		self:Print(AutoTurnin.L["enabled"])
	elseif arg == "off"  then
		if AutoTurninCharacterDB.enabled then 
			AutoTurninCharacterDB.enabled = false
			self:UnregisterAllEvents()
		end
		self:Print(AutoTurnin.L["disabled"])
	elseif arg == "all" then 
		AutoTurninCharacterDB.all = true
		self:Print(AutoTurnin.L["all"])
	elseif arg == "list" then 
		AutoTurninCharacterDB.all = false
		self:Print(AutoTurnin.L["list"])
	elseif arg == "loot" then 
		AutoTurninCharacterDB.lootMostExpensive = not AutoTurninCharacterDB.lootMostExpensive 
		self:Print(AutoTurnin.L["loot"..tostring(AutoTurninCharacterDB.lootMostExpensive)])
	end
end


-- (gaq[i+3]) equals "1" if quest is complete, "nil" otherwise
function AutoTurnin:GOSSIP_SHOW()
	if (GetGossipActiveQuests()) then  
		local gaq = {GetGossipActiveQuests()}
	
		for i=1, #gaq, 4 do
			if (gaq[i+3]) then 
				local quest = AutoTurnin.quests[gaq[i]]
				if AutoTurninCharacterDB.all or quest then 
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
			if AutoTurninCharacterDB.all or AutoTurnin.quests[gaq[i]] then 
				SelectGossipAvailableQuest(math.floor(i/5)+1)
				return
			end
		end
	end
end

function AutoTurnin:QUEST_DETAIL()
	if AutoTurninCharacterDB.all or AutoTurnin.quests[GetTitleText()] then
		QuestInfoDescriptionText:SetAlphaGradient(0, math.huge)
		QuestInfoDescriptionText:SetAlpha(1)
		AcceptQuest()
	end
end

function AutoTurnin:QUEST_PROGRESS() 
    if (AutoTurninCharacterDB.all or AutoTurnin.quests[GetTitleText()]) and IsQuestCompletable() then
		CompleteQuest()
    end
end

function AutoTurnin:QUEST_COMPLETE()
    if AutoTurninCharacterDB.all or AutoTurnin.quests[GetTitleText()] then
		local index, money = 0, 0; 
		if GetNumQuestChoices() > 0 then 
			if AutoTurninCharacterDB.lootMostExpensive then
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