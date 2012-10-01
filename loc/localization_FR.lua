local addonName, privateTable = ...
if (GetLocale() == "frFR")  then
privateTable.L = setmetatable({
	["usage1"]="'on'/'off' to enable or disable addon",
	["usage2"]="'all'/'list' to handle any quest or just specified in a list",
	["usage3"]="'loot' do not complete quests with a list of rewards or complete it and choose most expensive one of rewards",
	["all"]="ready to handle every quest",
	["list"]="only daily quests will be handled",
	["dontlootfalse"]="loot most expensive reward",
	["dontloottrue"]="do not complete quests with rewards",
	["resetbutton"]="reset",
	
	["questTypeLabel"] = "Quests to handle", 
	["questTypeAll"] = "all",
	["TrivialQuests"]="Accept 'grey' quests", 
	["questTypeList"] = "daily", 

	["lootTypeLabel"]="Quests with rewards",
	["lootTypeFalse"]="don't turn in",
	["lootTypeGreed"]="loot most expensive reward",
	["lootTypeNeed"]="loot by parameters",
	
	["tournamentLabel"]="Tournament", 
	["tournamentWrit"]="Champion's Writ", -- 46114
	["tournamentPurse"]="Champion's Purse",  -- 45724
	
	["DarkmoonTeleLabel"]="Darkmoon: teleport to the cannon",
	["DarkmoonFaireTeleport"]="Teleportologist Fozlebub",
	["DarkmoonAutoLabel"]="Darkmoon: start the game!",	
	
	["rewardtext"]="Print quest reward text",
	["autoequip"]="Equip received reward",
	["togglekey"]="Enable/disable key",
	
	['Jewelry']="Jewelry",
	["rewardlootoptions"]="Reward loot rules",
	['greedifnothing']='Greed if nothing found',
	["multiplefound"]="Multiple reward candidates found. "..ERR_QUEST_MUST_CHOOSE,
	["nosuitablefound"]="No suitable reward found. "..ERR_QUEST_MUST_CHOOSE,
	["gogreedy"]="No suitable reward found, choosing the highest value one.",
	["rewardlag"]=BUTTON_LAG_LOOT_TOOLTIP.. '. '..ERR_QUEST_MUST_CHOOSE,
	["stopitemfound"]="There is %s in rewards. Choose an item yourself.",
	},
	{__index = function(table, index) return index end})
	
privateTable.L.quests = {
-- Steamwheedle Cartel
['Faire amende honorable']={item="Etoffe runique", amount=40, currency=false},
['Combat naval']={item="Etoffe de tisse-mage", amount=40, currency=false},
['Un traitre envers la Voile sanglante']={item="Etoffe de soie", amount=40, currency=false},
['Soigner de vieilles blessures']={item="Etoffe de lin", amount=40, currency=false},
-- AV both fractions
['Ecuries vides']={donotaccept=true},

-- Alliance AV Quests
['Grappes de cristaux']={donotaccept=true},
['Ivus le Seigneur des forêts']={donotaccept=true},
["L'appel des airs - l'escadrille d'Ichman"]={donotaccept=true},
["L'appel des airs - l'escadrille de Slidore"]={donotaccept=true},
["L'appel des airs - l'escadrille de Vipore"]={donotaccept=true},
["Morceaux d'armures"]={donotaccept=true},
["Plus de morceaux d'armure !"]={donotaccept=true},
['Harnais pour béliers']={donotaccept=true},
-- Horde AV Quests
['Quelques litres de sang']={donotaccept=true},
['Lokholar le Seigneur des Glaces']={donotaccept=true},
["L'appel des airs - l'escadrille de Guse"]={donotaccept=true},
["L'appel des airs - l'escadrille de Jeztor"]={donotaccept=true},
["L'appel des airs - l'escadrille de Mulverick"]={donotaccept=true},
["Pris à l'ennemi"]={donotaccept=true},
['Plus de butin !']={donotaccept=true},
['Harnais en cuir de bélier']={donotaccept=true},
-- Timbermaw Quests
['Des plumes pour Grifleur']={item="Coiffure de plumes mort-bois", amount=5, currency=false},
['Des plumes pour Nafien']={item="Coiffure de plumes mort-bois", amount=5, currency=false},
['Plus de perles pour Salfa']={item="Perles d'esprit tombe-hiver", amount=5, currency=false},
-- Cenarion
['Les textes du Crépuscule cryptés']={item="Texte du Crépuscule crypté", amount=10, currency=false},
['Je crois encore...']={item="Texte du Crépuscule crypté", amount=10, currency=false},
-- Thorium Brotherhood
['Faveur auprès de la Confrérie, Sang de la montagne']={item="Sang de la montagne", amount=1, currency=false},
['Faveur auprès de la Confrérie, Cuir du Magma']={item="Cuir du Magma", amount=2, currency=false},
['Faveur auprès de la Confrérie, Minerai de sombrefer']={item="Minerai de sombrefer", amount=10, currency=false},
['Faveur auprès de la Confrérie, Noyau de feu']={item="Noyau de feu", amount=1, currency=false},
['Faveur auprès de la Confrérie, Noyau de lave']={item="Noyau de lave", amount=1, currency=false},
['Se faire accepter']={item="Résidu de sombrefer", amount=4, currency=false},
['Se faire encore mieux accepter']={item="Résidu de sombrefer", amount=100, currency=false},

--[[Burning Crusade]]--
--Lower City
["Plus de plumes"]={item="Plume d'arakkoa", amount=30, currency=false},
--Aldor
["De nouvelles marques de Kil'jaeden"]={item="Marque de Kil'jaeden", amount=10, currency=false},
["De nouvelles marques de Sargeras"]={item="Marque de Sargeras", amount=10, currency=false},
["Armes gangrenées"]={item="Arme gangrenée", amount=10, currency=false},
["Une marque de Kil'jaeden"]={item="Marque de Kil'jaeden", amount=1, currency=false},
["Une marque de Sargeras"]={item="Marque de Sargeras", amount=1, currency=false},
["Plus de glandes à venin"]={item="Glande à venin de croc-d'effroi", amount=8, currency=false},
--Scryer
["De nouvelles chevalières Aile-de-feu"]={item="Chevalière Aile-de-feu", amount=10, currency=false},
["De nouvelles chevalières Solfurie"]={item="Chevalière Solfurie", amount=10, currency=false},
["Tomes des arcanes"]={item="Tome des Arcanes", amount=1, currency=false},
["Une chevalière Aile-de-feu"]={item="Chevalière Aile-de-feu", amount=1, currency=false},
["Une chevalière Solfurie"]={item="Chevalière Solfurie", amount=1, currency=false},
["Plus d'yeux de basilic"]={item="Oeil de basilic trempécaille", amount=8, currency=false},
--Cenarion Exp
--Skettis
["L'évasion de Skettis"]="",
["Un déluge de feu sur Skettis"]="",
["Plus de poussière ombreuse"]={item="Poussière ombreuse", amount=6, currency=false},
--SporeGar
["Rapportez-moi un autre jardinet !"]={item="Hibiscus sanguin", amount=5, currency=false},
["Plus de spores fertiles"]={item="Spores fertiles", amount=6, currency=false},
["Plus de chapeluisants"]={item="Chapeluisant", amount=10, currency=false},
["Encore des sacs de spores"]={item="Sac de spores à maturité", amount=10, currency=false},
["Plus de vrilles !"]={item="Vrille de seigneur-tourbe", amount=6, currency=false},
-- Halaa
["La poudre de cristal d'Oshu'gun"]={item="Echantillon de poudre de cristal d'Oshu'gun", amount=10, currency=false},

--Sons of Hodir
['Un tribut à Hodir']={item="Relique d'Ulduar", amount=10, currency=false},
["N'oubliez pas le permagivre !"]={item="Morceau de permagivre", amount=1, currency=false},

["Dans le feu"]={donotaccept=true},

["La flèche Lugubre"]={donotaccept=true},

["Appeler les Anciens"]={item=416, amount=125, currency=true},
["Des armes en rab"]={item=416, amount=125, currency=true},
["Remplir le puits de lune"]={item=416, amount=125, currency=true},
--Darkmoon Faire
["Les petits s'amusent aussi"] = {item=393, amount=15, currency=true},
--MoP
["Les graines de la peur"]={item="Eclats d’ambre d’effroi", amount=20, currency=false},
}
end