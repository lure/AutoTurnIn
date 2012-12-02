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
	
	for i = 1, #WATCHFRAME_LINKBUTTONS do
		button = WATCHFRAME_LINKBUTTONS[i]

		if( button.type == "QUEST" ) then
			local questIndex = GetQuestIndexForWatch(button.index)
			if questIndex then				
				local textLine = button.lines[button.startLine]
				if textLine.text:GetText() and (not string.find("", "^%[.*%].*")) then
					local title, level, _, _, _, _, _, isDaily = GetQuestLogTitle(questIndex)					
					local questTypeIndex = GetQuestLogQuestType(questIndex)
					tagString = AutoTurnIn.QuestTypesIndex[questTypeIndex]
					if (not tagString) then
						--AutoTurnIn:Print("Please, inform addon author unknown QT for: " ..title)
						tagString = ""
					end
					textLine.text:SetText(AutoTurnIn.WatchFrameLevelFormat:format(level, tagString, isDaily and "\*" or "", title))
				end
			end
		end
	end
end
