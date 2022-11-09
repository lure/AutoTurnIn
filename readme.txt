== AutoTurnIn ==
git: https://github.com/lure/AutoTurnIn
http://wow.curseforge.com/addons/autoturnin/
Accepts and turn in quest to NPC. May handle any quests or specified list. 
May turn in quests with rewards and choose most expensive one for future selling.

/au 		- for GUI settings

---------------------------------------------------------------------------------------------------
Usefull staff since I tend to forget it:
---------------------------------------------------------------------------------------------------
to enable taint logging ingame 
	/console taintLog settingg
in config: 
	SET taintLog setting

0 Disables taint logging.
1 Actions blocked due to taint are logged.
2 Enables additional log messages indicating when accesses to tainted global variables occur.
---------------------------------------------------------------------------------------------------
to enable console: add `-console` to game start params 
---------------------------------------------------------------------------------------------------
to export source code: console should be enabled, 
	exportInterfaceFiles code
---------------------------------------------------------------------------------------------------
to export arts: console should be enabled, 
	exportInterfaceFiles art
---------------------------------------------------------------------------------------------------
to dump ingame expressions, instances etc
	/dump ... 
---------------------------------------------------------------------------------------------------
Framestack 	
	/fstack [showhidden]
---------------------------------------------------------------------------------------------------
Expose events 
	/etrace <<command>>
