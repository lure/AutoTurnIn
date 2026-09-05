AutoTurnIn.QuestLevelFormat = "[%d] %s"
AutoTurnIn.WatchFrameLevelFormat = "[%d%s%s] %s"
AutoTurnIn.QuestTypesIndex = {
	[0] = "",          -- Default
	[1] = "g",         -- Group
	[41] = "+",        -- PvP
	[62] = "r",        -- Raid
	[81] = "d",        -- Dungeon
	[83] = "L",        -- Legendary
	[85] = "h",        -- Heroic
	[98] = "s",        -- Scenario
	[102] = "a",       -- Account
}

local hookedText = setmetatable({}, {__mode = "k"})
local hookedPools = setmetatable({}, {__mode = "k"})
local hookedModules = setmetatable({}, {__mode = "k"})
local questLevelEvents

local function IsSecret(value)
	return issecretvalue and issecretvalue(value)
end

local function FormatQuestTitle(questID, text, watched)
	local profile = AutoTurnIn.db and AutoTurnIn.db.profile
	local option = watched and "watchlevel" or "questlevel"
	if not (profile and profile.enabled and profile[option]) then
		return text
	end
	if IsSecret(questID) or type(questID) ~= "number" or questID <= 0 then
		return text
	end

	local questLogIndex = C_QuestLog.GetLogIndexForQuestID(questID)
	local info = questLogIndex and C_QuestLog.GetInfo(questLogIndex)
	-- The quest may have left the log while its row is being recycled.
	if not info or info.isHeader then
		return text
	end
	local level = C_QuestLog.GetQuestDifficultyLevel(questID)
	if not IsSecret(level) and (not level or level <= 0) then
		level = info.level
	end
	if IsSecret(level) or type(level) ~= "number" or level <= 0 then
		return text
	end

	-- Respect a level already supplied by another addon, but allow [DNT], etc.
	if text:find("^%s*%[%d+[^%]]*%]") then
		return text
	end
	if watched then
		local tagInfo = C_QuestLog.GetQuestTagInfo(questID)
		local tag = tagInfo and AutoTurnIn.QuestTypesIndex[tagInfo.tagID] or ""
		local recurring = info.frequency == Enum.QuestFrequency.Daily or info.frequency == Enum.QuestFrequency.Weekly
		return AutoTurnIn.WatchFrameLevelFormat:format(level, tag or "", recurring and "*" or "", text)
	end
	return AutoTurnIn.QuestLevelFormat:format(level, text)
end

local function HookTitleText(fontString, getQuestID, watched)
	if not fontString or hookedText[fontString] then
		return
	end
	hookedText[fontString] = true
	local updating, previousQuestID, previousText, previousResult
	hooksecurefunc(fontString, "SetText", function(_, text)
		if updating or IsSecret(text) or type(text) ~= "string" or text == "" then
			return
		end
		local questID = getQuestID()
		if IsSecret(questID) then
			return
		end
		local originalText = text
		if questID == previousQuestID and text == previousResult then
			originalText = previousText
		end
		local result = FormatQuestTitle(questID, originalText, watched)
		previousQuestID, previousText, previousResult = questID, originalText, result
		if result ~= text then
			updating = true
			fontString:SetText(result)
			updating = false
		end
	end)
end

local function GetQuestTitlePool()
	local questsFrame = QuestMapFrame and QuestMapFrame.QuestsFrame
	local scrollFrame = QuestScrollFrame or (questsFrame and questsFrame.ScrollFrame)
	return (scrollFrame and scrollFrame.titleFramePool) or (questsFrame and questsFrame.titleFramePool)
end

function AutoTurnIn:ShowQuestLevelInLog()
	local pool = GetQuestTitlePool()
	if not pool then
		return
	end
	for button in pool:EnumerateActive() do
		HookTitleText(button.Text, function()
			return button.questID
		end, false)
	end
end

local function HookTrackerBlock(module, id, template)
	local block = module:GetExistingBlock(id, template)
	if block then
		HookTitleText(block.HeaderText, function()
			return block.id
		end, true)
	end
end

function AutoTurnIn:ShowQuestLevelInWatchFrame()
	-- Only quest modules: achievement IDs can also match IDs in the quest log.
	local moduleNames = {"QuestObjectiveTracker", "CampaignQuestObjectiveTracker", "WorldQuestObjectiveTracker", "BonusObjectiveTracker"}
	for _, name in ipairs(moduleNames) do
		local module = _G[name]
		if module and module.GetBlock and module.GetExistingBlock and not hookedModules[module] then
			hookedModules[module] = true
			-- GetBlock runs before SetHeader measures the text and lays out objectives.
			hooksecurefunc(module, "GetBlock", HookTrackerBlock)
			if module.EnumerateActiveBlocks then
				module:EnumerateActiveBlocks(function(block)
					HookTrackerBlock(module, block.id, block.template)
				end)
			end
		end
	end
end

function AutoTurnIn:QuestLevelHooks()
	local pool = GetQuestTitlePool()
	if pool and not hookedPools[pool] then
		hookedPools[pool] = true
		-- Attach to new rows before Blizzard sets their titles and measures them.
		hooksecurefunc(pool, "Acquire", function()
			AutoTurnIn:ShowQuestLevelInLog()
		end)
		self:ShowQuestLevelInLog()
	end
	self:ShowQuestLevelInWatchFrame()

	-- These UI addons can load after AutoTurnIn. Keep this separate from the
	-- automation events, which are unregistered when the addon is disabled.
	if not questLevelEvents then
		questLevelEvents = CreateFrame("Frame")
		questLevelEvents:RegisterEvent("ADDON_LOADED")
		questLevelEvents:SetScript("OnEvent", function()
			AutoTurnIn:QuestLevelHooks()
		end)
	end
end
