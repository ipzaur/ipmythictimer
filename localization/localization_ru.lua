if GetLocale() ~= "ruRU" then return end

local AddonName, Addon = ...

Addon.localization.CLEANDBBT  = "Очистить базу мобов"
Addon.localization.CLEANDBTT  = "Очистить внутреннюю базу с процентами монстров.\n" ..
                                "Помогает, если счётчик процентов глючит"
Addon.localization.CLOSE      = "Закрыть"
Addon.localization.CUSTOMIZE  = "Настроить фрейм"
Addon.localization.CCAPTION   = "Фрейм:\n" ..
                                "    ЛКМ (тянуть) - переместить\n" ..
                                "    ПКМ (тянуть) - растянуть\n" ..
                                "Элемент:\n" ..
                                "    ЛКМ (тянуть) - переместить\n" ..
                                "    ПКМ (щелчок) - размер шрифта\n" ..
                                "    СКМ (щелчок) - скрыть/показать элемент\n"
Addon.localization.DAMAGE     = "Урон"
Addon.localization.DEATHCOUNT = "Смертей"
Addon.localization.DEATHSHOW  = "Нажмите для подробной информации"
Addon.localization.DEATHTIME  = "Потеряно времени"
Addon.localization.DIRECTION  = "Изменение прогресса"
Addon.localization.DIRECTIONS = {
    [1] = "по возрастанию (0% -> 100%)",
    [2] = "по убыванию (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "Журнал смертей"
Addon.localization.DUNGENAME  = "Название подземелья"
Addon.localization.FONT       = "Шрифт"
Addon.localization.FONTSIZE   = "Размер шрифта"
Addon.localization.MAPBUT     = "ЛКМ (клик) - открыть настройки\n" ..
                                "ЛКМ (зажать) - передвинуть иконку"
Addon.localization.MAPBUTOPT  = "Показать/Скрыть кнопку у миникарты"
Addon.localization.MELEEATACK = "Ближний бой"
Addon.localization.OPTIONS    = "Настройки"
Addon.localization.OPACITY    = "Непрозрачность фона"
Addon.localization.PROGFORMAT = {
    [1] = "Проценты (100.00%)",
    [2] = "Вес мобов (300)",
}
Addon.localization.PROGRESS   = "Формат прогресса"
Addon.localization.RESTORE    = "Сбросить"
Addon.localization.SCALE      = "Масштаб"
Addon.localization.SOURCE     = "Источник"
Addon.localization.STARTINFO  = "iP Mythic Timer загружен. Для вызова настроек наберите /ipmt."
Addon.localization.TIME       = "Время"
Addon.localization.UNKNOWN    = "Неизвестно"
Addon.localization.WHODIED    = "Кто умер"

Addon.localization.HELP = {
    LEVEL      = "Уровень активного ключа",
    PLUSLEVEL  = "Улучшение ключа при текущем таймере",
    TIMER      = "Оставшееся время",
    PLUSTIMER  = "Время до ухудшения прогресса",
    DEATHTIMER = "Потраченное время из-за смертей",
    PROGRESS   = "Убито противников",
    PROGNOSIS  = "Прогресс, который дадут вошедшие в бой противники",
    BOSSES     = "Убито боссов",
    AFFIXES    = "Активные аффиксы",
}

Addon.localization.CORRUPTED = {
    [161124] = "Ург'рот Сокрушитель Героев (Ломатель танков)",
    [161241] = "Мал'тир - маг Бездны (Паук)",
    [161243] = "Сам'рек Призыватель Хаоса (Фиряющий)",
    [161244] = "Кровь Заразителя (Капля)",
}