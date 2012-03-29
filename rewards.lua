local addonName, ptable = ...
local weapon = {GetAuctionItemSubClasses(1)}
local armor = {GetAuctionItemSubClasses(2)}

--local  back = INVTYPE_CLOAK, INVTYPE_FINGER, INVTYPE_NECK, INVTYPE_HOLDABLE, INVTYPE_RELIC
-- INVTYPE_SHIELD <--- do not use, it is always shield

ptable.L.ITEMS = {
	['One-Handed Axes'] = select(1, weapon),
	['Two-Handed Axes'] = select(2, weapon),
	['Bows'] = select(3, weapon),
	['Guns'] = select(4, weapon),
	['One-Handed Maces'] = select(5, weapon),
	['Two-Handed Maces'] = select(6, weapon),
	['Polearms'] = select(7, weapon),
	['One-Handed Swords'] = select(8, weapon),
	['Two-Handed Swords'] = select(9, weapon),
	['Staves'] = select(10, weapon),
	['Fist Weapons'] = select(11, weapon),
	--['Miscellaneous'] = select(12, weapon)
	['Daggers'] = select(13, weapon),
	['Thrown'] = select(14, weapon),
	['Crossbows'] = select(15, weapon),
	['Wands'] = select(16, weapon),
	--['Fishing Pole'] = select(17, weapon)
	
	-- armor
	--['Miscellaneous'] = select(1, armor)
	['Cloth'] = select(2, armor),
	['Leather'] = select(3, armor),
	['Mail'] = select(4, armor),
	['Plate'] = select(5, armor),
	['Shields'] = select(6, armor),
	
	--[[3rd slot
	['Librams'] = select(7, armor),
	['Idols'] = select(8, armor),
	['Totems'] = select(9, armor),
	]]--
}

if not AutoTurnInCharacterDB.items then 
	AutoTurnInCharacterDB.items = {}
	for k, v in pairs(ptable.L.ITEMS) do 
		AutoTurnInCharacterDB.items[k]=0
	end 
end 


--[[ 
/run table.foreach(OPEN_FILTER_LIST, function(value) for v,k in pairs(value) do print(v,k) end)

/run for k,v in pairs(OPEN_FILTER_LIST) do for n,m in pairs(v) do print(n,m) end end

 /run print(_G[INVTYPE_CLOAK])
 
 
 /run function a(...) for i=1, select("#", ...), 2 do invType = _G[select(i, ...)] print(invType, select(i, ...)) end end a(GetAuctionInvTypes(2,2))
 00:08:47 Спина INVTYPE_CLOAK 1 INVTYPE_HOLDABLE nil
]]--