local AddonName, Addon = ...
Addon.version = 1200

Addon.AFFIX_TEEMING = 5

Addon.PROGRESS_FORMAT_PERCENT = 1
Addon.PROGRESS_FORMAT_FORCES  = 2

Addon.PROGRESS_DIRECTION_ASC  = 1
Addon.PROGRESS_DIRECTION_DESC = 2

Addon.season = {
    number   = 84,
    isActive = false,
}

Addon.FONT_ROBOTO_LIGHT = "Interface\\AddOns\\" .. AddonName .. "\\media\\RobotoCondensed-Light.ttf"
Addon.FONT_ROBOTO = "Interface\\AddOns\\" .. AddonName .. "\\media\\RobotoCondensed-Regular.ttf"
Addon.ACOUSTIC_STRING_X3 = "Interface\\AddOns\\" .. AddonName .. "\\media\\acoustic_string_x3.mp3"

Addon.DECOR_FONT = Addon.FONT_ROBOTO
Addon.DECOR_FONTSIZE_DELTA = 0
if GetLocale() == "zhTW" or GetLocale() == "zhCN" then
    Addon.DECOR_FONT = "Arial"
    Addon.DECOR_FONTSIZE_DELTA = -2
end

Addon.backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = nil,
    tile     = false,
}

Addon.frames = {
    {
        label = 'dungeonname',
        name = 'Название подземелья',
        hasText = true,
    },
    {
        label = 'level',
        name = 'Уровень ключа',
        hasText = true,
    },
    {
        label = 'plusLevel',
        name = 'Улучшение ключа',
        hasText = true,
    },
    {
        label = 'timer',
        name = 'Время ключа',
        hasText = true,
        colors = {
            [-1] = 'Цвет таймера, если группа не уложилась в таймер',
            [0]  = 'Цвет таймера, если время укладывается в диапазон для +1',
            [1]  = 'Цвет таймера, если время укладывается в диапозон для +2',
            [2]  = 'Цвет таймера, если время укладывается в диапазон для +3',
        },
    },
    {
        label = 'plusTimer',
        name = 'Время до ухудшения прогресса',
        hasText = true,
    },
    {
        label = 'deathTimer',
        name = 'Смерти',
        hasText = true,
    },
    {
        label = 'progress',
        name = 'Убито противников',
        hasText = true,
    },
    {
        label = 'prognosis',
        name = 'Проценты после боя',
        hasText = true,
    },
    {
        label = 'bosses',
        name = 'Боссы',
        hasText = true,
    },
    {
        label = 'affixes',
        name = 'Активные аффиксы',
        hasIcons = true,
    },
}

Addon.defaultOption = {
    version   = 0,
    scale     = 0,
    direction = 1,
    progress  = 1,
    theme     = 1,
    position  = {
        main = {
            point = 'TOPRIGHT',
            x = -30,
            y = -320,
        },
        options = {
            point = 'CENTER',
            x = 0,
            y = -50,
        },
        deaths = {
            point = 'CENTER',
            x = 0,
            y = -50,
        },
    },
}

Addon.cleanDungeon = {
    id          = 0,
    keyActive   = false,
    time        = 0,
    affixes     = {},
    level       = 0,
    players     = {},
    prognosis   = {},
    isTeeming   = false,
    timeLimit   = {
        [2] = nil,
        [1] = nil,
        [0] = nil,
    },
    trash       = {
        total   = 0,
        current = 0,
        killed  = 0,
    },
    combat      = {
        boss   = false,
        killed = {},
    },
    deathes     = {},
}

Addon.optionList = {
    direction = {
        [Addon.PROGRESS_DIRECTION_ASC]  = Addon.localization.DIRECTIONS.asc,
        [Addon.PROGRESS_DIRECTION_DESC] = Addon.localization.DIRECTIONS.desc,
    },
    progress = {
        [Addon.PROGRESS_FORMAT_PERCENT] = Addon.localization.PROGFORMAT.percent,
        [Addon.PROGRESS_FORMAT_FORCES]  = Addon.localization.PROGFORMAT.forces,
    }
}
