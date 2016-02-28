local addonName, privateTable = ...
-- translated by http://www.curse.com/users/whitelightelgringo
if (GetLocale() == "frFR")  then
privateTable.L = setmetatable({
	["reset"]="setting was resetted",
	["usage1"]="'on'/'off' pour activer/désactiver l'addon",
    ["usage2"]="'all'/'list' pour prendre en compte toutes les quêtes ou juste une liste spécifique",
    ["usage3"]="'loot' Ne pas rendre les quêtes à objets de récompense ou rendre les quêtes en choisissant l'objet de récompense le plus cher",
	["enabled"]="enabled",
	["disabled"]="disabled",	
    ["all"]="Ready to handle every quest",
    ["list"]="only daily quests will be handled",
    ["dontlootfalse"]="Choisir la récompense la plus chère",
    ["dontloottrue"]="Ne pas rendre les quêtes à objets de récompense",
    ["resetbutton"]="Réinitialiser",
    
    ["questTypeLabel"] = "Quêtes à prendre en compte",
    ["questTypeAll"] =  "Toutes",
    ["questTypeList"] = "journalières",
    ["questTypeExceptDaily"] = "excepté journalières",
    ["TrivialQuests"]= "Accepter les quêtes 'grise'",
	["ShareQuestsLabel"] = "partager la quête",
    ["CompleteOnly"] = "turn in only",

    ["lootTypeLabel"]="Quêtes à récompense d'objet",
    ["lootTypeFalse"]="Ne pas rendre",
    ["lootTypeGreed"]="Vhoisir la récompense la plus chère",
    ["lootTypeNeed"]="choisir la récompense selon les paramètres",
    
    ["tournamentLabel"]="Le tournoi d'Argent",
    ["tournamentWrit"]="Commission de champion", -- 46114
    ["tournamentPurse"]="Bourse de champion",  -- 45724
    
    ["DarkmoonTeleLabel"]="Sombrelune : téléporter au canon",
	["ToDarkmoonLabel"]="Sombrelune : téléporter au île", -- darkmoon	
    ["DarkmoonFaireTeleport"]="Téléportologue Mélébou",
    ["DarkmoonAutoLabel"]="Sombrelune : Lancer le jeu!",
	["Darkmoon Island"]="Île de Sombrelune",
	["Darkmoon Faire Mystic Mage"]="Mage mystique de la foire de Sombrelune",

    ["The Jade Forest"]="La forêt de Jade",
    ["Scared Pandaren Cub"]="Bébé pandaren apeuré",

    ["rewardtext"]="Écrire le texte de quête dans le chat",
    ["questlevel"]="Indiquer le niveau des quêtes",
    ["watchlevel"]="Indiquer le niveau des quêtes en suivi",        
    ["autoequip"]="Équiper les objets de récompense",
    ["togglekey"]="Touche activer/désactiver",

	['Jewelry']="Joaillerie",
    ["rewardlootoptions"]="Règles d'objets de récompense",
    ['greedifnothing']="Cupidité si rien n'est trouvé",
    ["multiplefound"]="Récompense multiple trouvée. "..ERR_QUEST_MUST_CHOOSE,
    ["nosuitablefound"]="Aucunes récompenses appropriées trouvées. "..ERR_QUEST_MUST_CHOOSE,
    ["gogreedy"]="Aucunes récompenses appropriées trouvées, objet le plus cher choisit.",
    ["rewardlag"]=BUTTON_LAG_LOOT_TOOLTIP.. '. '..ERR_QUEST_MUST_CHOOSE,
    ["stopitemfound"]="Il y a %s en récompense. Choisissez et équiper un objet.",
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

-- Fiona's Caravan
["La pierre de Rimblat"]={donotaccept=true},
["La poupée de Pamela"]={donotaccept=true},
["Le journal d'Argus"]={donotaccept=true},
["Le porte-bonheur de Fiona"]={donotaccept=true},
["Le rouage de Beezil"]={donotaccept=true},
["Le talisman de Tarenar"]={donotaccept=true},
["Les bracières de Vex'tul"]={donotaccept=true},
["L'huile d'arme de Gidwin"]={donotaccept=true},


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
["Les graines de la peur"]={item="Eclats d’ambre d’effroi", amount=5, currency=false},
["Un plat pour Jogu"]={item="Carottes sautées", amount=5, currency=false},

["Un plat pour Ella"]={item="Raviolis aux crevettes", amount=5, currency=false},
["Un plat pour Chii Chii"]={item="Sauté de la vallée", amount=5, currency=false},
["Un plat pour le fermier Fung"]={item="Rôti de sauvagine", amount=5, currency=false},
["Un plat pour Marée"]={item="Plat de poissons jumeaux", amount=5, currency=false},
["Un plat pour Gina"]={item="Soupe de brumes tourbillonnantes", amount=5, currency=false},
["Un plat pour Haohan"]={item="Steak de tigre grillé au feu de bois", amount=5, currency=false},
["Un plat pour le Vieux Patte des Hauts"]={item="Tortue braisée", amount=5, currency=false},
["Un plat pour Sho"]={item="Poisson de l’Éternel printemps", amount=5, currency=false},
["Un plat pour Tina"]={item="Saumon de l’esprit du feu", amount=5, currency=false},
["Remplir le garde-manger"]={item="Panier de vivres", amount=1, currency=false},
--MOP timeless Island
['Cuissot de tigre épais']={item="Cuissot de tigre épais", amount=1, currency=false},
['Flanchet de yack épais']={item="Flanchet de yack épais", amount=1, currency=false},
['Oeuf tempête-de-feu en parfait état']={item="Oeuf tempête-de-feu en parfait état", amount=1, currency=false},
['Patte de grue charnue']={item="Patte de grue charnue", amount=1, currency=false},
['Viande de grande tortue']={item="Viande de grande tortue", amount=1, currency=false},

}

privateTable.L.ignoreList = {
--MOP Tillers
["Un lys des marais pour"]="",
["Une pomme délicieuse pour"]="",
["Un chat de jade pour"]="",
["Une plume bleue pour"]="",
["Un éclat de rubis pour"]="",
}
end