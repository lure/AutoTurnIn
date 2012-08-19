local addonName, ptable = ...
ptable.CONST = {}
local C = ptable.CONST

local weapon = {GetAuctionItemSubClasses(1)}
local armor = {GetAuctionItemSubClasses(2)}

-- C.STOPTOKENS = {['INVTYPE_RELIC']='', ['INVTYPE_TRINKET']='', ['INVTYPE_HOLDABL']=''}
C.WEAPONLABEL, C.ARMORLABEL = GetAuctionItemClasses()
C.JEWELRY = {['INVTYPE_FINGER']='', ['INVTYPE_NECK']=''}

-- Most of the constants are never used but it's convinient to have them here as a reminder and shortcut
C.ITEMS = {
	['One-Handed Axes'] = weapon[1],
	['Two-Handed Axes'] = weapon[2],
	['Bows'] = weapon[3],
	['Guns'] = weapon[4],
	['One-Handed Maces'] = weapon[5],
	['Two-Handed Maces'] = weapon[6],
	['Polearms'] = weapon[7],
	['One-Handed Swords'] = weapon[8],
	['Two-Handed Swords'] = weapon[9],
	['Staves'] = weapon[10],
	['Fist Weapons'] = weapon[11],
	--['Miscellaneous'] = select(12, weapon)
	['Daggers'] = weapon[13],
	['Thrown'] = weapon[14],
	['Crossbows'] = weapon[15],
	['Wands'] = weapon[16],
	--['Fishing Pole'] = select(17, weapon)
	-- armor
	--['Miscellaneous'] = armor[1]
	['Cloth'] = armor[2],
	['Leather'] = armor[3],
	['Mail'] = armor[4],
	['Plate'] = armor[5],
	['Shields'] = armor[6],
	--[[3rd slot
	['Librams'] = armor[7],
	['Idols'] = armor[8],
	['Totems'] = armor[9],
	]]--
}