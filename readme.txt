== AutoTurnIn ==
author: alex.shubert@gmail.com
http://wow.curseforge.com/addons/autoturnin/
Accepts and turn in quest to NPC. May handle any quests or specified list. 
May turn in quests with rewards and choose most expensive one for future selling.

/au 		- for GUI
/au all 	- any quest would by accepted and turned in
/au list 	- only specified quest
/au off 	- turns addon off
/au on 		- turns addon on
/au help 	- brief help and active settings


# https://www.reddit.com/r/WowUI/comments/2lpmff/help_what_debugging_tools_are_available_to/
# /console scriptErrors 1 
#/run local fr=ObjectiveTrackerFrame;for i=1, #fr.MODULES do for id,b in pairs(fr.MODULES[i].Header.module.usedBlocks) do for y,z in pairs(b) do print(y,z) end end end
#/run local fr=ObjectiveTrackerFrame;for i=1, #fr.MODULES do for id,b in pairs(fr.MODULES[i].Header.module.usedBlocks) do for y,z in pairs(b.lines.QuestComplete) do print(y,z) end end end

https://www.curseforge.com/docs/repomigration
https://www.curseforge.com/docs/packaging