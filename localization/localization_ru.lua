if GetLocale() ~= "ruRU" then return end

local AddonName, Addon = ...

Addon.localization.ADDELEMENT = "Добавить элемент"

Addon.localization.BACKGROUND = "Фон"
Addon.localization.BORDER     = "Рамка"
Addon.localization.BORDERLIST = "Выбрать рамку из библиотеки"
Addon.localization.BRDERWIDTH = "Толщина рамки"

Addon.localization.CLEANDBBT  = "Очистить базу мобов"
Addon.localization.CLEANDBTT  = "Очистить внутреннюю базу с процентами монстров.\n" ..
                                "Помогает, если счётчик процентов глючит"
Addon.localization.CLOSE      = "Закрыть"
Addon.localization.COLOR      = "Цвет"
Addon.localization.COLORDESCR = {
    TIMER = {
        [-1] = 'Цвет таймера, если группа не уложилась в таймер',
        [0]  = 'Цвет таймера, если время укладывается в диапазон для +1',
        [1]  = 'Цвет таймера, если время укладывается в диапозон для +2',
        [2]  = 'Цвет таймера, если время укладывается в диапазон для +3',
    },
    OBELISKS = {
        [-1] = 'Цвет живого обелиска',
        [0]  = 'Цвет закрытого обелиска',
    },
}
Addon.localization.COPY       = "Копия"
Addon.localization.CORRUPTED = {
    [161124] = "Ург'рот Сокрушитель Героев (Ломатель танков)",
    [161241] = "Мал'тир - маг Бездны (Паук)",
    [161243] = "Сам'рек Призыватель Хаоса (Фиряющий)",
    [161244] = "Кровь Заразителя (Капля)",
}

Addon.localization.DAMAGE     = "Урон"
Addon.localization.DECORELEMS = "Декоративные элементы"
Addon.localization.DEFAULT    = "По-умолчанию"
Addon.localization.DEATHCOUNT = "Смертей"
Addon.localization.DEATHSHOW  = "Нажмите для подробной информации"
Addon.localization.DEATHTIME  = "Потеряно времени"
Addon.localization.DELETDECOR = "Удалить декоративный элемент"
Addon.localization.DIRECTION  = "Изменение прогресса"
Addon.localization.DIRECTIONS = {
    asc  = "По возрастанию (0% -> 100%)",
    desc = "По убыванию (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "Журнал смертей"

Addon.localization.ELEMENT    = {
    AFFIXES   = "Активные аффиксы",
    BOSSES    = "Боссы",
    DEATHS    = "Смерти",
    DUNGENAME = "Название подземелья",
    LEVEL     = "Уровень ключа",
    OBELISKS  = "Обелиски",
    PLUSLEVEL = "Улучшение ключа",
    PLUSTIMER = "Время до ухудшения прогресса ключа",
    PROGRESS  = "Убито противников",
    PROGNOSIS = "Проценты после боя",
    TIMER     = "Время ключа",
}
Addon.localization.ELEMACTION =  {
    SHOW = "Показать элемент",
    HIDE = "Скрыть элемент",
    MOVE = "Переместить элемент",
}
Addon.localization.ELEMPOS    = "Позиция элемента"

Addon.localization.FONT       = "Шрифт"
Addon.localization.FONTSIZE   = "Размер шрифта"

Addon.localization.HEIGHT     = "Высота"
Addon.localization.HELP       = {
    AFFIXES    = "Активные аффиксы",
    BOSSES     = "Убито боссов",
    DEATHTIMER = "Потраченное время из-за смертей",
    LEVEL      = "Уровень активного ключа",
    PLUSLEVEL  = "Улучшение ключа при текущем таймере",
    PLUSTIMER  = "Время до ухудшения прогресса",
    PROGNOSIS  = "Прогресс, который дадут вошедшие в бой противники",
    PROGRESS   = "Убито противников",
    TIMER      = "Оставшееся время",
}

Addon.localization.ICONSIZE   = "Размер иконки"

Addon.localization.JUSTIFYH   = "Горизонтальное выравнивание текста"

Addon.localization.LAYER      = "Слой"

Addon.localization.MAPBUT     = "ЛКМ (клик) - открыть настройки\n" ..
                                "ЛКМ (зажать) - передвинуть иконку"
Addon.localization.MAPBUTOPT  = "Показать/Скрыть кнопку у миникарты"
Addon.localization.MELEEATACK = "Ближний бой"

Addon.localization.OPTIONS    = "Настройки"

Addon.localization.POINT      = "Точка опоры"
Addon.localization.PRECISEPOS = "Правый клик для точного позиционирования"
Addon.localization.PROGFORMAT = {
    percent = "Проценты (100.00%)",
    forces  = "Вес мобов (300)",
}
Addon.localization.PROGRESS   = "Формат прогресса"

Addon.localization.RELPOINT   = "Точка зависимости"

Addon.localization.SCALE      = "Масштаб"
Addon.localization.SEASONOPTS = "Настройки для сезона"
Addon.localization.SOURCE     = "Источник"
Addon.localization.STARTINFO  = "iP Mythic Timer загружен. Для вызова настроек наберите /ipmt."

Addon.localization.TEXTURE    = "Текстура"
Addon.localization.TEXTURELST = "Выбрать текстуру из библиотеки"
Addon.localization.TXTRINDENT = "Отступ текстуры"
Addon.localization.THEME      = "Тема"
Addon.localization.THEMEADD   = {
    NEW    = "Создать новую тему",
    COPY   = "Скопировать текущую тему",
    IMPORT = "Импортировать тему",
}
Addon.localization.THEMEBUTNS = {
    ADD         = "Добавить тему",
    DELETE      = "Удалить тему",
    RESTORE     = 'Вернуть тему "' .. Addon.localization.DEFAULT .. '" в исходное состояние и применить её',
    OPENEDITOR  = "Открыть редактор темы",
    CLOSEEDITOR = "Закрыть редактор темы",
}
Addon.localization.THEMEDITOR = "Редактирование темы"
Addon.localization.THEMENAME  = "Название темы"
Addon.localization.TIME       = "Время"
Addon.localization.TIMERCHCKP = "Контрольные точки"

Addon.localization.UNKNOWN    = "Неизвестно"

Addon.localization.WHODIED    = "Кто умер"
Addon.localization.WIDTH      = "Ширина"
Addon.localization.WAVEALERT  = "Оповещать перед 20%"
