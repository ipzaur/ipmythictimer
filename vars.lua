local AddonName, Addon = ...
Addon.version = 1300

Addon.AFFIX_TEEMING = 5

Addon.PROGRESS_FORMAT_PERCENT = 1
Addon.PROGRESS_FORMAT_FORCES  = 2

Addon.PROGRESS_DIRECTION_ASC  = 1
Addon.PROGRESS_DIRECTION_DESC = 2

Addon.CREATE_THEME_NEW    = 1
Addon.CREATE_THEME_COPY   = 2
Addon.CREATE_THEME_IMPORT = 3

Addon.season = {
    number   = 91,
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
Addon.opened = {
    options = false,
    themes  = false,
}

Addon.frames = {
    {
        label = 'dungeonname',
        name = Addon.localization.ELEMENT.DUNGENAME,
        hasText = true,
        dummy = {
            text = Addon.localization.ELEMENT.DUNGENAME,
        },
    },
    {
        label = 'level',
        name = Addon.localization.ELEMENT.LEVEL,
        hasText = true,
        dummy = {
            text = '24',
        },
    },
    {
        label = 'plusLevel',
        name = Addon.localization.ELEMENT.PLUSLEVEL,
        hasText = true,
        dummy = {
            text = '+2',
        },
    },
    {
        label = 'timer',
        name = Addon.localization.ELEMENT.TIMER,
        hasText = true,
        colors = {
            [-1] = Addon.localization.COLORDESCR.TIMER[-1],
            [0]  = Addon.localization.COLORDESCR.TIMER[0],
            [1]  = Addon.localization.COLORDESCR.TIMER[1],
            [2]  = Addon.localization.COLORDESCR.TIMER[2],
        },
        dummy = {
            text = '27:31',
            colorId = 1,
        },
    },
    {
        label = 'plusTimer',
        name = Addon.localization.ELEMENT.PLUSTIMER,
        hasText = true,
        dummy = {
            text = '04:19',
        },
    },
    {
        label = 'deathTimer',
        name = Addon.localization.ELEMENT.DEATHS,
        hasText = true,
        dummy = {
            text = '-00:15 [3]',
        },
    },
    {
        label = 'progress',
        name = Addon.localization.ELEMENT.PROGRESS,
        hasText = true,
        dummy = {
            text = {"57.32%", "134/286"},
        },
    },
    {
        label = 'prognosis',
        name = Addon.localization.ELEMENT.PROGNOSIS,
        hasText = true,
        dummy = {
            text = {"63.46%", "148"},
        },
    },
    {
        label = 'bosses',
        name = Addon.localization.ELEMENT.BOSSES,
        hasText = true,
        dummy = {
            text = '3/5',
        },
    },
    {
        label = 'affixes',
        name = Addon.localization.ELEMENT.AFFIXES,
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
    wavealert = true,
    wavesound = Addon.ACOUSTIC_STRING_X3,
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
    },
    createTheme = {
        [Addon.CREATE_THEME_NEW]    = Addon.localization.THEMEADD.NEW,
        [Addon.CREATE_THEME_COPY]   = Addon.localization.THEMEADD.COPY,
        [Addon.CREATE_THEME_IMPORT] = Addon.localization.THEMEADD.IMPORT,
    }
}
