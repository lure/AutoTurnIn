local addonName, privateTable = ...
-- translators wanted :(
if (GetLocale() == "itIT")  then
privateTable.L = setmetatable({
	["reset"]="Le impostazioni sono state resettate",
	["usage1"]="'on'/'off' per abilitare o disabilitare l'addon",
	["usage2"]="'all'/'list' per gestire qualsiasi missione o solo quelle specificate in una lista",
	["usage3"]="'loot' non completare le missioni con una lista di ricompense o completarle scegliendo la più costosa tra le ricompense",
	["enabled"]="abilitato",
	["disabled"]="disabilitato",
	["debug"]="Debug",
	["all"]="pronto a gestire ogni missione",
	["list"]="solo le missioni giornaliere verranno gestite",
	["dontlootfalse"]="scegli la ricompensa più costosa",
	["dontloottrue"]="non completare le missioni con ricompense",
	["resetbutton"]="resetta",

	["questTypeLabel"] = "missioni da gestire",
	["questTypeAll"] = "Tutte",
	["questTypeList"] = "giornaliere",
	["questTypeExceptDaily"] = "escuso le giornaliere",
	["TrivialQuests"]="accetta le missioni 'grigie'",
	["ShareQuestsLabel"] = "condivisione automatica delle missioni",
	["CompleteOnly"] = "completa solamente",

	["lootTypeLabel"]="missioni con ricompensa",
	["lootTypeFalse"]="non consegnare",
	["lootTypeGreed"]="scegli la ricompensa più costosa",
	["lootTypeNeed"]="scegli la ricompensa da parametri",

	["tournamentLabel"]="Torneo d'argento",
	["tournamentWrit"]="Decreto del Campione", -- 46114
	["tournamentPurse"]="Borsellino del Campione", -- 45724

	["DarkmoonTeleLabel"]="Lunacupa: teletrasportarsi al cannone",
	["ToDarkmoonLabel"]="Lunacupa: teletrasportarsi a isola",
	["DarkmoonFaireTeleport"]="Teletrasportologo Fozlebub",
	["DarkmoonAutoLabel"]="Lunacupa: avviare il gioco!",
	["Darkmoon Island"]="Isola di Lunacupa",
	["Darkmoon Faire Mystic Mage"]="Maga Mistica di Lunacupa",
	
	["ReviveBattlePetLabel"]="Guarigione Mascotte da Combattimento",
	["ReviveBattlePetQ"]="Vorrei resuscitare e curare le mie mascotte da combattimento",
	["ReviveBattlePetA"]="Richiediamo un piccolo contributo per i reagenti",
	
	["DismissKyrianStewardLabel"]="Congeda Factotum",
	
	["The Jade Forest"]="Foresta di Giada",
	["Scared Pandaren Cub"]="Cucciolo Pandaren Spaventato",
	
	["rewardtext"]="Mostra il testo di completamento della missione",
	["questlevel"]="Mostra il livello della missione",
	["watchlevel"]="Mostra livello missione tracciata",
	["autoequip"]="Equipaggia ricompensa ricevuta",
	["togglekey"]="Tasto di abilitazione/disabilitazione",
	
	['Gioielli']="Gioielli",
	["rewardlootoptions"]="Condizioni di selezione ricompensa",
	['greedifnothing']='Valore più alto se non viene trovato nulla',
	["multiplefound"]="Candidati di ricompensa multipli trovati. "..ERR_QUEST_MUST_CHOOSE,
	["nosuitablefound"]="Nessuna ricompensa adeguata trovata. "..ERR_QUEST_MUST_CHOOSE,
	["gogreedy"]="Nessuna ricompensa adeguata trovata, scelgo quella dal valore più alto.",
	["rewardlag"]=BUTTON_LAG_LOOT_TOOLTIP.. '. '..ERR_QUEST_MUST_CHOOSE,
	["stopitemfound"]="Ci sono %s nelle ricompense. Scegli ed equipaggia un oggetto autonomamente.",
	["relictoggle"]="Disabilita raccolta automatica reliquia come ricompensa",
	["artifactpowertoggle"]="Disattiva la raccolta automatica delle ricompense in Potere Artefatto",
	["ivechosen"]="Ho scelto per te la prima opzione",
	["ivechosenfive"]="Ho scelto per te la quinta opzione",
	["norewardsettings"]="Nessuna preferenza per la ricompensa trovata. Equipaggiamento automatico disabilitato.",
	["ignorenpc"]="Ignora questo personaggio",
	["cantstopignore"]="Non riesco a smettere di ignorare questo personaggio",
	},
	{__index = function(table, index) return index end})
	
privateTable.L.quests = {
-- Steamwheedle Cartel
['Fare ammenda']={item="Tessuto di Telarunica", amount=40, currency=false},
['Guerra sul mare']={item="Tessuto di Telamagica", amount=40, currency=false},
['Traditore dei Velerosse']={item="Tessuto di Seta", amount=40, currency=false},
['Curare vecchie ferite']={item="Tessuto di Lino", amount=40, currency=false},
-- AV both fractions
['Stalle vuote']={donotaccept=true},
-- Alliance AV Quests
['Crystal Cluster']={donotaccept=true},
['Ivus the Forest Lord']={donotaccept=true},
["Il richiamo dell'aria: la Squadriglia di Ichman"]={donotaccept=true},
["Il richiamo dell'aria: la Squadriglia di Slidore"]={donotaccept=true},
["Il richiamo dell'aria: la Squadriglia di Vipore"]={donotaccept=true},
['Armor Scraps']={donotaccept=true},
['More Armor Scraps']={donotaccept=true},
['Ram Riding Harnesses']={donotaccept=true},
-- Horde AV Quests
['A Gallon of Blood']={donotaccept=true},
['Lokholar il Signore del Ghiaccio']={donotaccept=true},
["Il richiamo dell'aria: la Squadriglia di Guse"]={donotaccept=true},
["Il richiamo dell'aria: la Squadriglia di Jeztor"]={donotaccept=true},
["Il richiamo dell'aria: la Squadriglia di Mulverick"]={donotaccept=true},
['Bottino nemico']={donotaccept=true},
['Altro bottino!']={donotaccept=true},
['Ram Hide Harnesses']={donotaccept=true},
-- Timbermaw Quests
['Piume per Grazle']={item="Piuma di Copricapo dei Legnomorto", amount=5, currency=false},
['Piume per Nafien']={item="Piuma di Copricapo dei Legnomorto", amount=5, currency=false},
['More Beads for Salfa']={item="Winterfall Spirit Beads", amount=5, currency=false},
-- Cenarion
['Encrypted Twilight Texts']={item="Encrypted Twilight Text", amount=10, currency=false},
['Still Believing']={item="Encrypted Twilight Text", amount=10, currency=false},
-- Thorium Brotherhood
['Nelle grazie della Fratellanza: Sangue di Montagna']={item="Sangue di Montagna", amount=1, currency=false},
['Nelle grazie della Fratellanza: Cuoio del Nucleo']={item="Cuoio del Nucleo", amount=2, currency=false},
['Nelle grazie della Fratellanza: Minerale di Ferroscuro']={item="Minerale di Ferroscuro", amount=10, currency=false},
['Nelle grazie della Fratellanza: Nucleo Rovente']={item="Nucleo Rovente", amount=1, currency=false},
['Nelle grazie della Fratellanza: Nucleo di Lava']={item="Nucleo di Lava", amount=1, currency=false},
['Gaining Acceptance']={item="Dark Iron Residue", amount=4, currency=false},
['Gaining Even More Acceptance']={item="Dark Iron Residue", amount=100, currency=false},

-- Fiona's Caravan
["Argus' Journal"]={donotaccept=true},
["Beezil's Cog"]={donotaccept=true},
["Amuleto fortunato di Fiona"]={donotaccept=true},
["Olio per armi di Gidwin"]={donotaccept=true},
["La bambola di Pamela"]={donotaccept=true},
["Pietra di Rimblat"]={donotaccept=true},
["Tarenar's Talisman"]={donotaccept=true},
["Vex'tul's Armbands"]={donotaccept=true},

--[[Burning Crusade]]--
--Lower City
["Ancora piume"]={item="Piuma di Arakkoa", amount=30, currency=false},
--Aldor
["Altri Contrassegni di Kil'jaeden"]={item="Contrassegno di Kil'jaeden", amount=10, currency=false},
["Altri Contrassegni di Sargeras"]={item="Contrassegno di Sargeras", amount=10, currency=false},
["Armamenti Vili"]={item="Armamenti Vili", amount=10, currency=false},
["Singolo Contrassegno di Kil'jaeden"]={item="Contrassegno di Kil'jaeden", amount=1, currency=false},
["Singolo Contrassegno di Sargeras"]={item="Contrassegno di Sargeras", amount=1, currency=false},
["Altre sacche di veleno"]={item="Sacca di Veleno di Malazanna", amount=8, currency=false},
--Scryer
["Altri Anelli con Sigillo di Alardente"]={item="Anello con Sigillo di Alardente", amount=10, currency=false},
["Altri Anelli con Sigillo dei Furia del Sole"]={item="Anello con Sigillo dei Furia del Sole", amount=10, currency=false},
["Arcane Tomes"]={item="Arcane Tome", amount=1, currency=false},
["Singolo Anello con Sigillo di Alardente"]={item="Anello con Sigillo di Alardente", amount=1, currency=false},
["Singolo Anello con Sigillo dei Furia del Sole"]={item="Anello con Sigillo dei Furia del Sole", amount=1, currency=false},
["Altri Occhi di Basilisco"]={item="Occhio di Basilisco Scagliaumida", amount=8, currency=false},
--Skettis
["Altra polvere d'ombra"]={item="Polvere d'Ombra", amount=6, currency=false},
--SporeGar
["Portami altre piante!"]={item="Ibisco Vermiglio", amount=5, currency=false},
["Altre Spore Fertili"]={item="Spore Fertili", amount=6, currency=false},
["More Glowcaps"]={item="Glowcap", amount=10, currency=false},
["Altre sacche di spore"]={item="Sacca di Spore Mature", amount=10, currency=false},
["Altri tentacoli!"]={item="Tentacolo dei Signori del Pantano", amount=6, currency=false},
-- Halaa
["Polvere di Cristallo di Oshu'gun"]={item="Campione di Polvere di Cristallo di Oshu'gun", amount=10, currency=false},

["Tributo di Hodir"]={item="Reliquia di Ulduar", amount=10, currency=false},
["Remember Everfrost!"]={item="Everfrost Chip", amount=1, currency=false},
["Armamenti aggiuntivi"]={item=416, amount=125, currency=true},
["Richiamo degli Antichi"]={item=416, amount=125, currency=true},
["Riempire il Pozzo Lunare"]={item=416, amount=125, currency=true},
["Into the Fire"]={donotaccept=true},
["The Forlorn Spire"]={donotaccept=true},
["Fun for the Little Ones"] = {item=393, amount=15, currency=true},
--MoP
["Semi della paura"]={item="Schegge di Ambra del Terrore", amount=5, currency=false},
["Un Piatto per Jogu"]={item="Carote Trifolate", amount=5, currency=false},

["Un Piatto per Ella"]={item="Ravioli di Gamberetti", amount=5, currency=false},
["Spadellata della Valle"]={item="Spadellata della Valle", amount=5, currency=false},
["Un Piatto per il Contadino Fung"]={item="Arrosto di Uccello Selvatico", amount=5, currency=false},
["Un Piatto per Trota"]={item="Trote Gemelle in Bellavista", amount=5, currency=false},
['Zuppa "Nebbia Vorticante"']={item='Zuppa "Nebbia Vorticante"', amount=5, currency=false},
["Un Piatto per Haohan"]={item="Costata di Tigre alla Griglia", amount=5, currency=false},
["Un Piatto per il Vecchio Zampa Brulla"]={item="Brasato di Tartaruga", amount=5, currency=false},
["Un Piatto per Sho"]={item="Pesce Primavera", amount=5, currency=false},
["Un Piatto per Tina"]={item="Salmone allo Spirito di Fuoco", amount=5, currency=false},
["Replenishing the Pantry"]={item="Bundle of Groceries", amount=1, currency=false},
--MOP timeless Island
['Carne di Tartaruga Maestosa']={item="Carne di Tartaruga Maestosa", amount=1, currency=false},
['Costato Pesante di Yak']={item="Heavy Yak Flank", amount=1, currency=false},
['Coscia di Gru Carnosa']={item="Coscia di Gru Carnosa", amount=1, currency=false},
['Uovo di Serpe di Fuoco Vibrante']={item="Uovo di Serpe di Fuoco Vibrante", amount=1, currency=false},
['Cosciotto di Tigre Carnoso']={item="Cosciotto di Tigre Carnoso", amount=1, currency=false},

}

privateTable.L.ignoreList = {
--MOP Tillers
["Un Giglio di Palude per"]="",
["Una Mela Appetitosa per"]="",
["Un Gatto di Giada per"]="",
["Una Piuma Blu per"]="",
["Una Scheggia di Rubino per"]="",
["Supplies Needed: Starlight Roses"]="",
["Città della luce"]="",
}
end
