-- Run from the addon directory with Lua 5.1: lua tests/quest_level.lua
-- Model the retail ordering: acquire a row/block, set text, then measure it.
local unpack = unpack or table.unpack
local hookCount, frames, combat = 0, {}, false
local secret = {}
function issecretvalue(value) return value == secret end
function InCombatLockdown() return combat end
function hooksecurefunc(object, method, callback)
    hookCount = hookCount + 1
    local original = object[method]
    object[method] = function(...)
        local results = {original(...)}
        callback(...)
        return unpack(results)
    end
end
function CreateFrame()
    local frame = {events = {}}
    function frame:RegisterEvent(event) self.events[event] = true end
    function frame:SetScript(_, callback) self.callback = callback end
    frames[#frames + 1] = frame
    return frame
end
local function fireEvent(event)
    for _, frame in ipairs(frames) do
        if frame.events[event] then frame.callback(frame, event) end
    end
end
local function fontString()
    local font = {}
    function font:SetText(text) self.text = text end
    function font:GetText() return self.text end
    function font:GetHeight() return math.ceil(#(self.text or '') / 20) * 12 end
    return font
end
local function pool()
    local value = {active = {}}
    function value:Acquire()
        local button = {Text = fontString()}
        self.active[button] = true
        return button, true
    end
    function value:EnumerateActive() return pairs(self.active) end
    return value
end
local function tracker()
    local value = {blocks = {}}
    function value:GetExistingBlock(id) return self.blocks[id] end
    function value:GetBlock(id)
        if not self.blocks[id] then
            local block = {id = id, HeaderText = fontString(), template = 'QuestBlock'}
            function block:SetHeader(text)
                self.HeaderText:SetText(text)
                self.height = self.HeaderText:GetHeight()
            end
            self.blocks[id] = block
        end
        return self.blocks[id]
    end
    function value:EnumerateActiveBlocks(callback)
        for _, block in pairs(self.blocks) do callback(block) end
    end
    return value
end
local infos = {
    [101] = {level = 10, title = 'First quest', frequency = 0},
    [102] = {level = 20, title = 'Weekly dungeon', frequency = 2},
    [103] = {level = 30, title = 'Daily quest', frequency = 1},
    [104] = {level = 0, title = 'Unknown level'},
    [105] = {level = 50, title = 'Header', isHeader = true},
}
local levels = {[101] = 80, [102] = 81, [103] = 0, [104] = -1, [105] = 50}
Enum = {QuestFrequency = {Daily = 1, Weekly = 2}}
C_QuestLog = {
    GetLogIndexForQuestID = function(id) return infos[id] and id end,
    GetInfo = function(index) return infos[index] end,
    GetQuestDifficultyLevel = function(id) return levels[id] end,
    GetQuestTagInfo = function(id) return id == 102 and {tagID = 81} or nil end,
}
AutoTurnIn = {db = {profile = {enabled = true, questlevel = true, watchlevel = true}}}
dofile('QuestLevel.lua')
local assertions = 0
local function equal(actual, expected, label)
    assert(actual == expected, label .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual))
    assertions = assertions + 1
end

-- Missing load-on-demand UI must be safe and hookable when it becomes available.
AutoTurnIn:QuestLevelHooks()
equal(#frames, 1, 'one addon-load listener')
QuestScrollFrame = {titleFramePool = pool()}
QuestMapFrame = {QuestsFrame = {ScrollFrame = QuestScrollFrame}}
QuestObjectiveTracker = tracker()
CampaignQuestObjectiveTracker = tracker()
WorldQuestObjectiveTracker = tracker()
BonusObjectiveTracker = tracker()
AchievementObjectiveTracker = tracker()
fireEvent('ADDON_LOADED')
local initialHooks = hookCount
AutoTurnIn:QuestLevelHooks()
fireEvent('ADDON_LOADED')
equal(hookCount, initialHooks, 'initialization is idempotent')
equal(#frames, 1, 'listener is not duplicated')

local row, isNew = QuestScrollFrame.titleFramePool:Acquire()
equal(isNew, true, 'pool return values preserved')
row.questID = 101
row.Text:SetText('First quest')
equal(row.Text:GetText(), '[80] First quest', 'scaled quest level')
row.Text:SetText(row.Text:GetText())
equal(row.Text:GetText(), '[80] First quest', 'no duplicate prefix')
levels[101] = 90
row.Text:SetText(row.Text:GetText())
equal(row.Text:GetText(), '[90] First quest', 'level updates for existing text')
row.Text:SetText('|A:quest-icon:16:16|a First quest')
equal(row.Text:GetText(), '[90] |A:quest-icon:16:16|a First quest', 'decoration preserved')
row.Text:SetText('[DNT] First quest')
equal(row.Text:GetText(), '[90] [DNT] First quest', 'bracketed quest title')
row.Text:SetText('[42] Already decorated')
equal(row.Text:GetText(), '[42] Already decorated', 'another addon prefix preserved')

local longTitle = 'A title with 19 chr!'
row.Text:SetText(longTitle)
equal(row.Text:GetHeight(), 24, 'log measures decorated text before layout')
local secondRow = QuestScrollFrame.titleFramePool:Acquire()
secondRow.questID = 103
secondRow.Text:SetText('Daily quest')
equal(secondRow.Text:GetText(), '[30] Daily quest', 'nonpositive difficulty falls back to log level')
row.Text:SetText('First quest')
equal(row.Text:GetText(), '[90] First quest', 'row closures retain their own quest ID')
row.questID = 102
row.Text:SetText('Weekly dungeon')
equal(row.Text:GetText(), '[81] Weekly dungeon', 'recycled row gets new quest level')

for _, module in ipairs({QuestObjectiveTracker, CampaignQuestObjectiveTracker, WorldQuestObjectiveTracker, BonusObjectiveTracker}) do
    local block = module:GetBlock(102)
    block:SetHeader('Weekly dungeon')
    equal(block.HeaderText:GetText(), '[81d*] Weekly dungeon', 'quest module and weekly dungeon tag')
    equal(block.height, block.HeaderText:GetHeight(), 'Blizzard measures decorated tracker header')
end
local daily = QuestObjectiveTracker:GetBlock(103)
daily:SetHeader('Daily quest')
equal(daily.HeaderText:GetText(), '[30*] Daily quest', 'daily tag')
local achievement = AchievementObjectiveTracker:GetBlock(101)
achievement:SetHeader('Achievement')
equal(achievement.HeaderText:GetText(), 'Achievement', 'achievement ID collision is ignored')
local hooksBeforeReuse = hookCount
QuestObjectiveTracker:GetBlock(103)
equal(hookCount, hooksBeforeReuse, 'reused block is not hooked twice')

AutoTurnIn.db.profile.watchlevel = false
daily:SetHeader(daily.HeaderText:GetText())
equal(daily.HeaderText:GetText(), 'Daily quest', 'tracker option removes prefix on next update')
row.Text:SetText('Weekly dungeon')
equal(row.Text:GetText(), '[81] Weekly dungeon', 'log option is independent')
AutoTurnIn.db.profile.questlevel = false
row.Text:SetText(row.Text:GetText())
equal(row.Text:GetText(), 'Weekly dungeon', 'log option removes prefix on next update')
AutoTurnIn.db.profile.questlevel = true
AutoTurnIn.db.profile.watchlevel = true
AutoTurnIn.db.profile.enabled = false
row.Text:SetText('Weekly dungeon')
daily:SetHeader('Daily quest')
equal(row.Text:GetText(), 'Weekly dungeon', 'disabled addon leaves log unchanged')
equal(daily.HeaderText:GetText(), 'Daily quest', 'disabled addon leaves tracker unchanged')
AutoTurnIn.db.profile.enabled = true

-- Text-only hooks still let Blizzard own every layout field while in combat.
combat = true
daily:SetHeader('Daily quest')
equal(daily.HeaderText:GetText(), '[30*] Daily quest', 'combat text updates')
equal(daily.height, daily.HeaderText:GetHeight(), 'combat layout measured by Blizzard')
combat = false
for _, id in ipairs({104, 105, 999}) do
    row.questID = id
    row.Text:SetText('Unchanged')
    equal(row.Text:GetText(), 'Unchanged', 'missing level/header/removed quest')
end
row.questID = 101
levels[101] = secret
row.Text:SetText('Secret level')
equal(row.Text:GetText(), 'Secret level', 'secret level ignored')
row.questID = secret
row.Text:SetText('Secret quest ID')
equal(row.Text:GetText(), 'Secret quest ID', 'secret quest ID ignored')
row.Text:SetText(secret)
equal(row.Text:GetText(), secret, 'secret text ignored')
row.Text:SetText(nil)
equal(row.Text:GetText(), nil, 'nil text ignored')
row.Text:SetText('')
equal(row.Text:GetText(), '', 'empty text ignored')

-- Also support the previous pool location while using the same title hook.
QuestScrollFrame = nil
QuestMapFrame = {QuestsFrame = {titleFramePool = pool()}}
AutoTurnIn:QuestLevelHooks()
local legacyRow = QuestMapFrame.QuestsFrame.titleFramePool:Acquire()
legacyRow.questID = 103
legacyRow.Text:SetText('Daily quest')
equal(legacyRow.Text:GetText(), '[30] Daily quest', 'previous pool location')
print('QuestLevel: ' .. assertions .. ' assertions passed')
