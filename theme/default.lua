local AddonName, Addon = ...

Addon.theme = {}

Addon.theme[1] = {
    name      = Addon.localization.DEFAULT,
    font      = Addon.FONT_ROBOTO,
    fontStyle = '',
    main = {
        size = {
            w = 180,
            h = 80,
        },
        background = {
            texture = "Interface\\Buttons\\WHITE8X8",
            color   = {r=0, g=0, b=0, a=.4},
            coords  = {0, 1, 0, 1},
            texSize = {
                w = 0,
                h = 0,
            },
            inset   = 0,
        },
        border  = {
            texture = 'none',
            size    = 8,
            color   = {r=1, g=1, b=1, a=1},
        },
    },
    elements = {
        dungeonname = {
            size = {
                w = 180,
                h = 100,
            },
            position = {
                x      = 0,
                y      = 4,
                point  = 'BOTTOMLEFT',
                rPoint = 'TOPLEFT',
            },
            fontSize = 13,
            justifyV = 'BOTTOM',
            justifyH = 'LEFT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        level = {
            size = {
                w = 20,
                h = 20,
            },
            position = {
                x = 6,
                y = -16,
                point  = 'LEFT',
                rPoint = 'TOPLEFT',
            },
            fontSize = 20,
            justifyH = 'LEFT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        plusLevel = {
            size = {
                w = 20,
                h = 20,
            },
            position = {
                x = 30,
                y = -16,
                point  = 'LEFT',
                rPoint = 'TOPLEFT',
            },
            fontSize = 13,
            justifyH = 'LEFT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        timer = {
            size = {
                w = 50,
                h = 18,
            },
            position = {
                x = 6,
                y = 0,
                point  = 'LEFT',
                rPoint = 'LEFT',
            },
            fontSize = 12,
            justifyH = 'LEFT',
            color    = {
                [-1] = {r=1, g=0, b=0, a=1},
                [0]  = {r=1, g=1, b=1, a=1},
                [1]  = {r=1, g=1, b=0, a=1},
                [2]  = {r=0, g=1, b=0, a=1},
            },
            hidden   = false,
        },
        plusTimer = {
            size = {
                w = 50,
                h = 18,
            },
            position = {
                x = 50,
                y = 0,
                point  = 'LEFT',
                rPoint = 'LEFT',
            },
            fontSize = 12,
            justifyH = 'LEFT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        deathTimer = {
            size = {
                w = 60,
                h = 18,
            },
            position = {
                x      = -6,
                y      = 0,
                point  = 'RIGHT',
                rPoint = 'RIGHT',
            },
            fontSize = 12,
            justifyH = 'RIGHT',
            color    = {r=0.6, g=0.2, b=0.2, a=1},
            hidden   = false,
        },
        progress = {
            size = {
                w = 90,
                h = 30,
            },
            position = {
                x      = 6,
                y      = 14,
                point  = 'LEFT',
                rPoint = 'BOTTOMLEFT',
            },
            fontSize = 22,
            justifyH = 'LEFT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        prognosis = {
            size = {
                w = 60,
                h = 20,
            },
            position = {
                x      = 16,
                y      = 14,
                point  = 'CENTER',
                rPoint = 'BOTTOM',
            },
            fontSize = 15,
            justifyH = 'LEFT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        bosses = {
            size = {
                w = 50,
                h = 30,
            },
            position = {
                x      = -6,
                y      = 14,
                point  = 'RIGHT',
                rPoint = 'BOTTOMRIGHT',
            },
            fontSize = 22,
            justifyH = 'RIGHT',
            color    = {r=0.8, g=0.8, b=0.8, a=1},
            hidden   = false,
        },
        affixes = {
            size = {
                w = 90,
                h = 30,
            },
            position = {
                x      = -2,
                y      = 0,
                point  = 'TOPRIGHT',
                rPoint = 'TOPRIGHT',
            },
            iconSize = 22,
            hidden = false,
        },
    },
    decors = {},
    deaths = {
        font            = Addon.DECOR_FONT,
        fontStyle       = '',
        captionFontSize = 20 + Addon.DECOR_FONTSIZE_DELTA,
        headerFontSize  = 16 + Addon.DECOR_FONTSIZE_DELTA,
        recordFontSize  = 14 + Addon.DECOR_FONTSIZE_DELTA,
    },
}
Addon.defaultDecor = {
    size = {
        w = 120,
        h = 60,
    },
    position = {
        x      = -100,
        y      = 100,
        point  = 'TOPLEFT',
        rPoint = 'TOPLEFT',
    },
    background = {
        texture = "Interface\\Buttons\\WHITE8X8",
        color   = {r=1, g=1, b=1, a=1},
        coords  = {0, 1, 0, 1},
        texSize = {
            w = 0,
            h = 0,
        },
        inset   = 0,
    },
    border  = {
        texture = 'none',
        size    = 8,
        color   = {r=1, g=1, b=1, a=1},
    },
    layer = 2,
    hidden = false,
}
