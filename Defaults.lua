local addonName, privateTable = ...
privateTable.interface10 = select(4, GetBuildInfo()) >= 100000
privateTable.defaults = {
	profile = {
		enabled = true,
		all = 2,
		trivial = false,
		completeonly = false,
		lootreward = 1,
		tournament = 2,
		darkmoonteleport = true,
		todarkmoon = true,
		darkmoonautostart = true,
		showrewardtext = true,
		version = GetAddOnMetadata(addonName, "Version"),
		autoequip = false,
		togglekey = 4,
		debug = false,
		questlevel = true,
		watchlevel = true,
		questshare = false,
		armor = {},
		weapon = {},
		stat = {},
		secondary = {},
		relictoggle = true,
		artifactpowertoggle = true,
		reviveBattlePet = false,
		covenantswapgossipcompletion = false,
		IGNORED_NPC = {
			["87391"] = "fate-twister-seress",
			["88570"] = "Fate-Twister Tiklal",
			["15077"] = "Riggle Bassbait",
			["119388"] = "Chieftain Hatuun",
			["127037"] = "Nabiru",
			["142063"] = "Tezran",
			["141584"] = "Zurvan", --seals of fate 
			["111243"] = "Archmage Lan'dalock", --seals of fate
		},
		WANTED_NPC = {
			["167881"] = "Ta'lan the Antiquary",
			["167880"] = "Finder Ta'sul",
			["158653"] = "Prince Renethal",
		},
		WANTED_QUESTS = {
			["6942"] = "Frostwolf Soldier's Medal",
			["6943"] = "Frostwolf Commander's Medal",
			["6941"] = "Frostwolf Lieutenant's Medal",
		}
	}
}
