local addonName, privateTable = ...
if (GetLocale() == "ruRU")  then
privateTable.L = setmetatable({
	["reset"]="настройки были сброшены",
	["usage1"]="'on'/'off' включает или отключает аддон",
	["usage2"]="'all'/'list' принимать и сдавать все задания или только внесенные в список",
	["usage3"]="'loot' не завершать задания, где есть список наград либо завершать и выбирать самую дорогую",
	["enabled"]="включен",
	["disabled"]="отключен",
	["debug"]="Debug",
	["all"]="Принимать и сдавать любое задание",
	["list"]="Принимать и сдавать только дейлики",
	["dontlootfalse"]="завершать задания с выбором наград, брать самый дорогой предмет",
	["dontloottrue"]="не завершать задания, где есть выбор наград",
	["resetbutton"]="Сброс",
	
	["questTypeLabel"] = "Задания", 
	["questTypeAll"] = "все",
    ["questTypeList"] = "ежедневные",
    ["questTypeExceptDaily"] = "кроме ежедневных",
    ["TrivialQuests"]="Брать 'серые' квесты",
	["ShareQuestsLabel"] = "Предлагать задание группе",
    ["CompleteOnly"] = "Только завершать",

	["lootTypeLabel"]="задания с наградами",
	["lootTypeFalse"]="не сдавать",
	["lootTypeGreed"]="взять самую дорогую",
	["lootTypeNeed"]="взять самую нужную",
	
	["tournamentLabel"]="Серебряный Турнир", 
	["tournamentWrit"]="Удостоверение чемпиона", -- 46114
	["tournamentPurse"]="Кошелек чемпиона",  -- 45724
	
	["DarkmoonTeleLabel"]="Ярмарка Новолуния: телепортация к пушке", -- darkmoon
	["ToDarkmoonLabel"]="Ярмарка Новолуния: телепортация на остров", -- darkmoon
	["DarkmoonFaireTeleport"]="Телепортолог Фоцлебульб",
	["DarkmoonAutoLabel"]="Ярмарка Новолуния: начинать игру",	
	["Darkmoon Island"]="Остров Новолуния",
	["Darkmoon Faire Mystic Mage"]="Гадалка ярмарки Новолуния",
	
	["ReviveBattlePetLabel"]="Лечение боевых питомцев",
	["ReviveBattlePetQ"]="Мне бы хотелось воскресить и исцелить моих боевых питомцев.",
	["ReviveBattlePetA"]="За это надо бы и заплатить немножко.",
	
	["DismissKyrianStewardLabel"]="Dismiss Kyrian Steward.",
	
	["The Jade Forest"]="Нефритовый лес",
	["Scared Pandaren Cub"]="Испуганный юный пандарен",
	
	["rewardtext"]="Показывать финальный текст задания",
	["questlevel"]="Уровни заданий в журнале",
	["watchlevel"]="Уровни отслеживаемых заданий",
	["autoequip"]="Надеть полученную награду",
	["togglekey"]="клавиша разового включения/отключения",
	
	['Jewelry']="Ювелирные украшения",
	["rewardlootoptions"]="Правила выбора награды",
	["greedifnothing"]="Взять самую дорогую, если ничего не нашлось",
	["multiplefound"]="Найдено несколько подходящих наград. "..ERR_QUEST_MUST_CHOOSE,
	["nosuitablefound"]="Подходящих предметов не найдено. "..ERR_QUEST_MUST_CHOOSE,
	["gogreedy"]="Подходящих предметов не найдено. Берем самую дорогую.",
	["rewardlag"]=BUTTON_LAG_LOOT_TOOLTIP.. '. '..ERR_QUEST_MUST_CHOOSE,
	["stopitemfound"]="Среди наград есть %s. Выберите и наденьте предмет самостоятельно.",
	["relictoggle"]="Отключить автолут Релика",
	["artifactpowertoggle"]="Отключить автолут Силы Артефакта",
	["ivechosen"]="выбрал первую опцию за тебя",
	["ivechosenfive"]="выбрал пятый вариант для вас",
	["norewardsettings"]="Не выбраны желаемые награды. Автоодевание отключено.",
	["ignorenpc"]="Игнорировать персонажа",
	["cantstopignore"]="Этого персонажа нельзя перестать игнорировать",
	},
	{__index = function(table, index) return index end})

privateTable.L.quests = {
-- Steamwheedle Cartel
['Восстановление добрых отношений']={item="Руническая ткань", amount=40, currency=false},
['Морской бой']={item="Магическая ткань", amount=40, currency=false},
['Предатель Кровавого Паруса']={item="Шелковый материал", amount=40, currency=false},
['Исцеление старых ран']={item="Льняной материал", amount=40, currency=false},
-- AV both fractions 
["Пустые стойла"]={donotaccept=true},
-- Alliance AV Quests
["Друза"]={donotaccept=true},
["Ивус Лесной Властелин"]={donotaccept=true},
["Небо зовет – флот Слидора"]={donotaccept=true},
["Небо зовет – флот Змейера"]={donotaccept=true},
["Небо зовет – флот Ромеона"]={donotaccept=true},
["Больше обломков брони"]={donotaccept=true},
["Обломки брони"]={donotaccept=true},
["Упряжь ездовых баранов"]={donotaccept=true},
-- Horde AV Quests
["Галлон крови"]={donotaccept=true},
["Локолар Владыка Льда"]={donotaccept=true},
["Небо зовет – флот Мааши"]={donotaccept=true},
["Небо зовет – флот Маэстра"]={donotaccept=true}, 
["Небо зовет – флот Смуггла"]={donotaccept=true},
["Больше добычи!"]={donotaccept=true},
["Вражеский трофей"]={donotaccept=true},
["Упряжь из бараньей кожи"]={donotaccept=true},
-- Timbermaw Quests
["Перья для Гразла"]={item="Перо из головного убора Мертвого Леса", amount=5, currency=false},
["Перья для Нафиэна"]={item="Перо из головного убора Мертвого Леса", amount=5, currency=false},
["Четки для Сальфы"]={item="Бусы духов Зимней Спячки", amount=5, currency=false},
-- Cenarion
["Зашифрованные Сумеречные тексты"]={item="Зашифрованный Сумеречный текст", amount=10, currency=false},
["Не теряя веры"]={item="Зашифрованные Сумеречные тексты", amount=10, currency=false},
-- Thorium Brotherhood 
["Завоевать еще большую благосклонность"]={item="Окалина черного железа", amount=100, currency=false},
["Завоевать благосклонность"]={item="Окалина черного железа", amount=4, currency=false},
["Покровительство братства, кожа Недр"]={item="Кожа Недр", amount=2, currency=false},
["Покровительство братства, кровь горы"]={item="Кровь Горы", amount=1, currency=false},
["Покровительство братства, огненное ядро"]={item="Огненное ядро", amount=1, currency=false},
["Покровительство братства, черное железо"]={item="Руда черного железа", amount=10, currency=false},
["Покровительство братства, ядро лавы"]={item="Ядро лавы", amount=1, currency=false},

-- Fiona's Caravan
['Дневник Аргуса']={donotaccept=true},
['Камень Римблата']={donotaccept=true},
['Кукла Памелы']={donotaccept=true},
['Оружейная смазка Гидвина']={donotaccept=true},
["Поручи Векс'тула"]={donotaccept=true},
['Счастливый талисман Фионы']={donotaccept=true},
['Талисман Таренара']={donotaccept=true},
['Шестеренка Бизила']={donotaccept=true},


--[[Burning Crusade]]--
--Lower City
["Больше перьев"]={item="Перо араккоа", amount=30, currency=false},
--Aldor
["Больше знаков Кил'джедена"]={item="Знак Кил'джедена", amount=10, currency=false},
["Больше знаков Саргераса"]={item="Знак Саргераса", amount=10, currency=false},
["Латные перчатки Скверны"]={item="Латные перчатки Скверны", amount=10, currency=false},
["Знак Кил'джедена"]={item="Знак Кил'джедена", amount=1, currency=false},
["Знак Саргераса"]={item="Знак Саргераса", amount=1, currency=false},
["Больше ядовитых желез"]={item="Ядовитая железа Смертеплета", amount=8, currency=false},
--Scryer
["Больше перстней Огнекрылов"]={item="Перстень Огнекрылов", amount=10, currency=false},
["Больше перстней Ярости Солнца"]={item="Перстень Ярости Солнца", amount=10, currency=false},
["Чародейские фолианты"]={item="Чародейский фолиант", amount=1, currency=false},
["Перстень Огнекрылов"]={item="Перстень Огнекрылов", amount=1, currency=false},
["Перстень Ярости Солнца"]={item="Перстень Ярости Солнца", amount=1, currency=false},
["Больше глаз василисков"]={item="Глаз гладкоспинного василиска", amount=8, currency=false},
--Cenarion Exp
["Определение растений"]="",
--Skettis
["Больше теневой пыли"]={item="Теневая пыль", amount=6, currency=false},
["Огонь над Скеттисом"]="",
["Побег из Скеттиса"]="",
--Sporeggar
["Принеси мне еще одну клумбу!"]={item="Кровавый гибискус", amount=5, currency=false},
["Нужно больше грибов!"]={item="Огнешляпка", amount=10, currency=false},
["Новые прорастающие споры"]={item="Прорастающие споры", amount=6, currency=false},
["Новые мешочки со спорами"]={item="Прорастающие споры", amount=10, currency=false},
["Еще усиков!"]={item="Усик болотника", amount=6, currency=false},
["Раз уж мы по-прежнему друзья..."]="",

["Больше Вечного льда!"]={item="Частичка Вечного льда", amount=1, currency=false},

["Подношение Ходиру"]={item="Реликвия Ульдуара", amount=10, currency=false},

["В огонь"]={donotaccept=true},
["Одинокая башня"]={donotaccept=true},
["Дополнительное оружие"]={item=416, amount=125, currency=true},
["Наполнение лунного колодца"]={item=416, amount=125, currency=true},
["Призыв Древних"]={item=416, amount=125, currency=true},
["Развлечения для самых маленьких"] = {item=393, amount=15, currency=true},

--MoP
["Семена Страха"]={item="Осколки жуткого янтаря", amount=5, currency=false},
["Поход за продуктами"]={item="Пакет с продуктами", amount=1, currency=false},

["Угощение для Йогу"]={item="Пассерованная морковь", amount=5, currency=false},
["Угощение для Эллы"]={item="Клецки с раками-богомолами", amount=5, currency=false},
["Угощение для Чи-Чи"]={item="Cтир-фрай долины", amount=5, currency=false},
["Угощение для фермера Фуна"]={item="Жареная дичь", amount=5, currency=false},
["Угощение для Рыбы"]={item="Блюдо из двух рыб", amount=5, currency=false},
["Угощение для Джины"]={item="Суп из клубящегося тумана", amount=5, currency=false},
["Угощение для Хаоханя"]={item="Жареный на углях стейк из тигриного мяса", amount=5, currency=false},
["Угощение для старика Горной Лапы"]={item="Тушеное черепашье мясо", amount=5, currency=false},
["Угощение для Шо"]={item="Рыба по-дольски", amount=5, currency=false},
["Угощение для Тины"]={item="Лосось духов огня", amount=5, currency=false},
["Поход за продуктами"]={item="Пакет с продуктами", amount=1, currency=false},
--MOP timeless Island
['Бок тяжелого яка']={item="Бок тяжелого яка", amount=1, currency=false},
['Мясистая нога журавля']={item="Мясистая нога журавля", amount=1, currency=false},
['Мясо большой черепахи']={item="Мясо большой черепахи", amount=1, currency=false},
['Нетронутое яйцо огненной бури']={item="Нетронутое яйцо огненной бури", amount=1, currency=false},
['Толстый тигриный окорок']={item="Толстый тигриный окорок", amount=1, currency=false},
}

privateTable.L.ignoreList = {
--MOP Tillers
["Болотная лилия для"]="",
["Милое яблочко для"]="",
["Нефритовый кот для"]="",
["Синее перо для"]="",
["Рубиновый осколок для"]="",
["Supplies Needed: Starlight Roses"]="",
["Город Света"]="",
}
end
