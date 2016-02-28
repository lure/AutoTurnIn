local addonName, privateTable = ...
if (GetLocale() == "deDE") then
privateTable.L = setmetatable({
	["reset"]="zurücksetzen",
	["usage1"]="'on'/'off' zum Aktivieren oder Deaktivieren des Addons",
	["usage2"]="'all'/'list' alle Quests oder nur gelistete",
	["usage3"]="'loot' Quests mit mehreren wahlmöglichkeiten zur Belohnung nicht abgeben oder die teuerste Belohnung wählen",
	["enabled"]="Eingeschaltet",
	["disabled"]="Ausgeschaltet",
	["all"]="alle Quests",
	["list"]="nur tägliche Quests",
	["dontlootfalse"]="Wähle die teuerste Belohnung",
	["dontloottrue"]="Quests mit Belohnungen nicht beenden",
	["resetbutton"]="zurücksetzen",

	["questTypeLabel"] = "quests", 
	["questTypeAll"] = "alle",
    ["questTypeList"] = "Tägliche",
    ["questTypeExceptDaily"] = "außer Tägliche",
    ["TrivialQuests"]="'graue' Quests annehmen",
	["ShareQuestsLabel"] = "teilen die Quest",
    ["CompleteOnly"] = "zurückliefern bloß",

	["lootTypeLabel"]="Jobs mit Belohnungen",
	["lootTypeFalse"]="nicht abgeben",
	["lootTypeGreed"]="Teuerste Belohnung wählen",
	["lootTypeNeed"]="Wähle Belohnung nach Parametern",

	["tournamentLabel"]="Das Argentumturnier",
	["tournamentWrit"]="Verfügung des Champions", -- 46114
	["tournamentPurse"]="Geldbeutel des Champions",  -- 45724

	["DarkmoonTeleLabel"]="Dunkelmond-Jahrmarkt: Zurück zur Kanone!",
	["ToDarkmoonLabel"]="Dunkelmond-Jahrmarkt: Zurück zur Insel", -- darkmoon
	["DarkmoonFaireTeleport"]="Teleportologe Fosselbab",
	["DarkmoonAutoLabel"]="Dunkelmond-Jahrmarkt: Spiel starten!",
	["Darkmoon Island"]="Dunkelmond-Insel",
	["Darkmoon Faire Mystic Mage"]="Mystischer Magier des Dunkelmond-Jahrmarkts",	

	["The Jade Forest"]="Der Jadewald",
	["Scared Pandaren Cub"]="verängstigte Pandarenkinder",

	["rewardtext"]="Zeige Questabgabetext",
	["questlevel"]="Zeige Quest Level",
	["watchlevel"]="Zeige Level von beobachtetem Quest",		
	["autoequip"]="Belohnung ausrüsten",
	["togglekey"]="aktivieren/deaktivieren Taste",
	
	['Jewelry']="Schmuck",
	["rewardlootoptions"]="Belohnungsregeln",
	['greedifnothing']='Wertvollstes nehmen wenn nichts passendes gefunden',
	["multiplefound"]="Mehrere passende Belohnungen gefunden. "..ERR_QUEST_MUST_CHOOSE,
	["nosuitablefound"]="Nichts hat sich als geeignet erwiesen. "..ERR_QUEST_MUST_CHOOSE,
	["gogreedy"]="Nichts hat sich als geeignet erwiesen. Wertvollste Belohnung wird gewählt.",
	["rewardlag"]=BUTTON_LAG_LOOT_TOOLTIP.. '. '..ERR_QUEST_MUST_CHOOSE,
	["stopitemfound"]="Gefunden: %s. Ihr müsst eine Belohnung manuell auswählen und ausrüsten.",
	},
	{__index = function(table, index) return index end})
	
privateTable.L.quests = {
-- Steamwheedle Cartel
['Wiedergutmachung']={item="Runenstoff", amount=40, currency=false},
['Krieg zur See']={item="Magiestoff", amount=40, currency=false},
['Verrat am Blutsegel']={item="Seidenstoff", amount=40, currency=false},
['Heilen alter Wunden']={item="Leinenstoff", amount=40, currency=false},
-- AV both fractions
["Verwaiste Ställe"]={donotaccept=true},
--Alliance AV Quests
["Haufenweise Kristalle"]={donotaccept=true},
["Ivus der Waldfürst"]={donotaccept=true},
["Ruf der Lüfte - Slidores Luftflotte"]={donotaccept=true},
["Ruf der Lüfte - Ichmans Luftflotte"]={donotaccept=true},
["Ruf der Lüfte - Vipores Luftflotte"]={donotaccept=true},
["Rüstungsfetzen"]={donotaccept=true},
["Mehr Rüstungsfetzen"]={donotaccept=true},
["Widderzaumzeug"]={donotaccept=true},
--Horde AV Quests
["Eine Gallone Blut"]={donotaccept=true},
["Lokholar der Eislord"]={donotaccept=true},
["Ruf der Lüfte - Guses Luftflotte"]={donotaccept=true},
["Ruf der Lüfte - Mulvericks Luftflotte"]={donotaccept=true},
["Ruf der Lüfte - Jeztors Luftflotte"]={donotaccept=true},
["Beutezug im Feindesland"]={donotaccept=true},
["Mehr Beute!"]={donotaccept=true},
["Widderledernes Zaumzeug"]={donotaccept=true},
--Timbermaw Quests
['Federn für Grazle']={item="Kopfputzfeder der Totenwaldfelle", amount=5, currency=false},
['Federn für Nafien']={item="Kopfputzfeder der Totenwaldfelle", amount=5, currency=false},
['Mehr Perlen für Salfa']={item="Geisterperlen der Winterfelle", amount=5, currency=false},
--Cenarion
['Fester Glauben']={item="Verschlüsselter Schattenhammertext", amount=10, currency=false},
['Verschlüsselte Schattenhammertexte']={item="Verschlüsselter Schattenhammertext", amount=10, currency=false},
--Thorium Brotherhood
['Gunst der Bruderschaft, Blut des Berges']={item="Blut des Berges", amount=1, currency=false},
['Gunst der Bruderschaft, Dunkeleisenerz']={item="Dunkeleisenerz", amount=10, currency=false},
['Gunst der Bruderschaft, Feuerkern']={item="Feuerkern", amount=1, currency=false},
['Gunst der Bruderschaft, Kernleder']={item="Kernleder", amount=2, currency=false},
['Gunst der Bruderschaft, Lavakern']={item="Lavakern", amount=1, currency=false},
['Anerkennung erlangen']={item="Dunkeleisenrückstände", amount=4, currency=false},
['Noch mehr Anerkennung erlangen']={item="Dunkeleisenrückstände", amount=100, currency=false},

-- Fiona's Caravan
["Argus' Tagebuch"]={donotaccept=true},
['Beezils Zahnrad']={donotaccept=true},
['Fionas Glücksbringer']={donotaccept=true},
['Gidwins Waffenöl']={donotaccept=true},
['Pamelas Puppe']={donotaccept=true},
['Rimblats Stein']={donotaccept=true},
['Tarenars Talisman']={donotaccept=true},
["Vex'tuls Armbinden"]={donotaccept=true},

--[[Burning Crusade]]--
--Lower City
["Mehr Federn"]={item="Arakkoafeder", amount=30, currency=false},
--Aldor
["Ein reinigendes Licht"]={item="Teuflische Waffen", amount=1, currency=false},
['Einzelne Male des Sargeras']={item="Mal des Sargeras", amount=1, currency=false},
["Einzelne Male von Kil'jaeden"]={item="Mal von Kil'jaeden", amount=1, currency=false},
['Male des Sargeras']={item="Mal des Sargeras", amount=10, currency=false},
["Male von Kil'jaeden"]={item="Mal von Kil'jaeden", amount=10, currency=false},
['Mehr Male des Sargeras']={item="Mal des Sargeras", amount=10, currency=false},
["Mehr Male von Kil'jaeden"]={item="Mal von Kil'jaeden", amount=10, currency=false},
["Mehr Giftbeutel"]={item="Schreckensgiftbeutel", amount=8, currency=false},
--Scryer
['Arkane Folianten']={item="Arkaner Foliant", amount=1, currency=false},
['Einzelne Siegel der Feuerschwingen']={item="Siegel der Feuerschwingen", amount=1, currency=false},
['Einzelne Siegel des Sonnenzorns']={item="Siegel des Sonnenzorns", amount=1, currency=false},
['Mehr Basiliskenaugen']={item="Auge eines Dunstschuppenbasilisken", amount=8, currency=false},
['Mehr Siegel der Feuerschwingen']={item="Siegel der Feuerschwingen", amount=10, currency=false},
['Mehr Siegel des Sonnenzorns']={item="Siegel des Sonnenzorns", amount=10, currency=false},
['Siegel der Feuerschwingen']={item="Siegel der Feuerschwingen", amount=10, currency=false},
['Siegel des Sonnenzorns']={item="Siegel des Sonnenzorns", amount=10, currency=false},
--Cenarion Exp
['Pflanzenteile identifizieren']={item="Unbekannte Pflanzenteile", amount=10, currency=false},
--Skettis
['Feuer über Skettis']="",
['Flucht aus Skettis']="",
['Mehr Schattenstaub']={item="Schattenstaub", amount=6, currency=false},
--SporeGar 
['Bringt mir ein weiteres Gebüsch!']={item="Bluthibiskus", amount=5, currency=false},
['Mehr Ranken!']={item="Sumpflordranke", amount=6, currency=false},
['Noch ein paar Sporensäcke']={item="Reifer Sporenbeutel", amount=6, currency=false},
['Noch mehr fruchtbare Sporen']={item="Fruchtbare Sporen", amount=6, currency=false},
['Noch mehr Glühkappen']={item="Glühkappe", amount=10, currency=false},
--Halaa
["Kristallpulver von Oshu'gun"]={item="Kristallpulverprobe von Oshu'gun", amount=10, currency=false},
--Sons of Hodir
['Hodirs Tribut']={item="Relikt von Ulduar", amount=10, currency=false},
['Vergesst das Immerfrosteis nicht!']={item="Immerfrostsplitter", amount=1, currency=false},
--[[ Cataclysm]]--
--Firelands Invasion
["Befüllung des Mondbrunnens"]={item=416, amount=125, currency=true},
['Der Einsame Turm']={donotaccept=true},
['Ins Feuer']={donotaccept=true},
["Rufen der Urtume"]={item=416, amount=125, currency=true},
["Verstärkung"]={item=416, amount=125, currency=true},
--Darkmoon Faire
["Spaß für die Kleinen"] = {item=393, amount=15, currency=true},
--MoP
["Saat der Angst"]={item="Schreckensambersplitter", amount=5, currency=false},
["Ein Gericht für Jogu"]={item="Gebratene Karotten", amount=5, currency=false},

["Garnelenklößchen"]={item="Garnelenklößchen", amount=5, currency=false},
["Ein Gericht für Chi-Chi"]={item="Pfannengericht nach Vier-Winde-Art", amount=5, currency=false},
["Ein Gericht für Bauer Fung"]={item="Wildgeflügelbraten", amount=5, currency=false},
["Ein Gericht für Fischi"]={item="Zwillingsfischplatte", amount=5, currency=false},
["Ein Gericht für Gina"]={item="Verwirbelte Nebelsuppe", amount=5, currency=false},
["Ein Gericht für Haohan"]={item="Gegrilltes Tigersteak", amount=5, currency=false},
["Ein Gericht für den alten Hügelpranke"]={item="Geschmorte Schildkröte", amount=5, currency=false},
["Ein Gericht für Sho"]={item="Blütenfischfilet", amount=5, currency=false},
["Ein Gericht für Tina"]={item="Feuergeisterlachs", amount=5, currency=false},
["Auffüllen der Speisekammer"]={item="Bündel mit Zutaten", amount=1, currency=false},
--MOP timeless Island
['Dicke Tigerkeule']={item="Dicke Tigerkeule", amount=1, currency=false},
['Fleischige Kranichkeule']={item="Fleischige Kranichkeule", amount=1, currency=false},
['Großschildkrötenfleisch']={item="Großschildkrötenfleisch", amount=1, currency=false},
['Makelloses Feuersturmei']={item="Makelloses Feuersturmei", amount=1, currency=false},
['Schwere Yakrippe']={item="Schwere Yakrippe", amount=1, currency=false},

}

privateTable.L.ignoreList = {
--MOP Tillers
["Eine Sumpflilie für"]="",
["Ein hübscher Apfel für"]="",
["Eine Jadekatze für"]="",
["Eine blaue Feder für"]="",
["Ein Rubinsplitter für"]="",
}
end