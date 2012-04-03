local addonName, ptable = ...
ptable.CONST = {}
local C = ptable.CONST

local weapon = {GetAuctionItemSubClasses(1)}
local armor = {GetAuctionItemSubClasses(2)}

-- C.STOPTOKENS = {['INVTYPE_RELIC']='', ['INVTYPE_TRINKET']=''}
C.WEAPONLABEL, C.ARMORLABEL = GetAuctionItemClasses()
C.JEWELRY = {['INVTYPE_FINGER']='', ['INVTYPE_NECK']=''}
C.STATS = {
	['ITEM_MOD_STRENGTH_SHORT'] = "Strength",
	['ITEM_MOD_AGILITY_SHORT'] = "Agility",
	['ITEM_MOD_INTELLECT_SHORT'] = "Intellect",
	['ITEM_MOD_SPIRIT_SHORT'] = "Spirit"
}

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



--[[ 
(\[('.+')\]\s+=\s+((weapon|armor)\[\d+\]),)

Статы: показываем актуальные для класса. Например, шаман - интеллект и ловкость. Воин - сила. 
Либрамы и триньки: останавливаем аддон и просим пользователя выбрать

if not _G.AutoTurnInCharacterDB.items then 
	AutoTurnInCharacterDB.items = {}
	for k, v in pairs(ptable.C.ITEMS) do 
		AutoTurnInCharacterDB.items[k]=0
	end 
end 
/run table.foreach(OPEN_FILTER_LIST, function(value) for v,k in pairs(value) do print(v,k) end)

/run for k,v in pairs(OPEN_FILTER_LIST) do for n,m in pairs(v) do print(n,m) end end
/run for k,v in pairs(InterfaceOptionsFrameAddOnsButton2.element) do print(k,v) end 

/run print(_G[INVTYPE_CLOAK])
/run print(select(6, GetItemInfo("Набедренники Прилива")))

/run function a(...) for i=1, select("#", ...), 2 do invType = _G[select(i, ...)] print(invType, select(i, ...)) end end a(GetAuctionInvTypes(2,2))
00:08:47 Спина INVTYPE_CLOAK 1 INVTYPE_HOLDABLE nil

SPELL_STAT1_NAME = "Strength";
SPELL_STAT2_NAME = "Agility";
SPELL_STAT3_NAME = "Stamina";
SPELL_STAT4_NAME = "Intellect";
SPELL_STAT5_NAME = "Spirit";

STAT_CATEGORY_ATTRIBUTES = "Attributes";
STAT_CATEGORY_DEFENSE = "Defense";
STAT_CATEGORY_GENERAL = "General";
STAT_CATEGORY_MELEE = "Melee";
STAT_CATEGORY_RANGED = "Ranged";

]]--