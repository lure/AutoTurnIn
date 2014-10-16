local _G = _G 	--Rumors say that global _G is called by lookup in a super-global table. Have no idea whether it is true. 
local _ 		--Sometimes blizzard exposes "_" variable as a global. 
local addonName, ptable = ...
local L = ptable.L
local C = ptable.CONST

AutoTurnIn.QuestLevelFormat = " [%d] %s"
AutoTurnIn.WatchFrameLevelFormat = "[%d%s%s] %s"
AutoTurnIn.QuestTypesIndex = {
	[0] = "",           --default
	[1] = "g",			--Group
	[41] = "+",			--PvP
	[62] = "r",			--Raid
	[81] = "d",			--Dungeon
	[83] = "L", 		--Legendary
	[85] = "h",			--Heroic 
	[98] = "s", 		--Scenario QUEST_TYPE_SCENARIO
	[102] = "a", 		-- Account
}

function AutoTurnIn:ShowQuestLevelInLog()
	if not AutoTurnInCharacterDB.questlevel then 
		return
	end
	
	-- see function QuestLog_Update() in function QuestLogFrame.lua for details
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame);
	local numEntries, numQuests = GetNumQuestLogEntries();
	
	for i=1, #QuestLogScrollFrame.buttons do
		local questIndex = i + scrollOffset;		
		local button = QuestLogScrollFrame.buttons[i]
		if ( questIndex <= numEntries ) then
			local title, level, _, _, isHeader = GetQuestLogTitle(questIndex);
			if (not isHeader and title) then 
				button:SetText(AutoTurnIn.QuestLevelFormat:format(level, title))
				QuestLogTitleButton_Resize(button)
			end
		end
	end
end

function AutoTurnIn:ShowQuestLevelInWatchFrame()
	if not AutoTurnInCharacterDB.watchlevel then 
		return
	end

	local tracker = ObjectiveTrackerFrame
	if ( not tracker.initialized )then
		return
	end

	for i = 1, #tracker.MODULES do
		for id,block in pairs( tracker.MODULES[i].Header.module.usedBlocks) do
			local text = block.HeaderText:GetText()
			if text and (not string.find(text, "^%[.*%].*")) then
				local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID,
					  startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(block.questLogIndex)

				local questTypeIndex = GetQuestLogQuestType(block.questLogIndex)
				local tagString = AutoTurnIn.QuestTypesIndex[questTypeIndex] or ""
				local dailyMod = (frequency == LE_QUEST_FREQUENCY_DAILY or frequency == LE_QUEST_FREQUENCY_WEEKLY) and "\*" or ""

				block.HeaderText:SetText(AutoTurnIn.WatchFrameLevelFormat:format(level, tagString, dailyMod, title))
			end
		end
	end
end
