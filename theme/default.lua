local AddonName, Addon = ...

Addon.theme = {}

Addon.theme[1] = {
    name    = Addon.localization.DEFAULT,
    font    = Addon.FONT_ROBOTO,
    main = {
        size = {
            w = 180,
            h = 80,
        },
        background = {
            texture = "Interface\\Buttons\\WHITE8X8",
            color   = {r=0, g=0, b=0, a=.4},
        },
        border  = {
            texture = 'none',
            size    = 0,
            color   = {r=1, g=1, b=1, a=0},
            inset   = 0,
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
}

Addon.defaultDecor = {
    size = {
        w = 60,
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
        color   = {r=0, g=0, b=0, a=.4},
    },
    border  = {
        texture = 'none',
        size    = 0,
        color   = {r=1, g=1, b=1, a=0},
        inset   = 0,
    },
    layer = 2,
    hidden = false,
}

Addon.theme[2] = {
    ["decors"] = {
        {
            ["background"] = {
                ["color"] = {
                    ["a"] = 1,
                    ["r"] = 0.9490196078431372,
                    ["g"] = 0.9529411764705882,
                    ["b"] = 1,
                },
                ["texture"] = "interface/dialogframe/ui-dialogbox-gold-dragon",
            },
            ["position"] = {
                ["y"] = "-3",
                ["x"] = "-32",
                ["point"] = "LEFT",
                ["rPoint"] = "LEFT",
            },
            ["border"] = {
                ["color"] = {
                    ["a"] = 1,
                    ["r"] = 0.2156862745098039,
                    ["g"] = 0.4980392156862745,
                    ["b"] = 0.1568627450980392,
                },
                ["texture"] = "none",
                ["inset"] = 0,
                ["size"] = 6,
            },
            ["layer"] = 2,
            ["hidden"] = false,
            ["size"] = {
                ["w"] = "120",
                ["h"] = "120",
            },
        }, -- [1]
        {
            ["background"] = {
                ["color"] = {
                    ["a"] = 1,
                    ["r"] = 0.7294117647058823,
                    ["g"] = 0.6941176470588235,
                    ["b"] = 0.580392156862745,
                },
                ["texture"] = "interface/glues/models/ui_dwarf/finishedwood",
            },
            ["position"] = {
                ["y"] = "0",
                ["x"] = "-7",
                ["point"] = "TOPRIGHT",
                ["rPoint"] = "BOTTOMRIGHT",
            },
            ["border"] = {
                ["color"] = {
                    ["a"] = 1,
                    ["r"] = 1,
                    ["g"] = 1,
                    ["b"] = 1,
                },
                ["texture"] = "none",
                ["inset"] = 0,
                ["size"] = 1,
            },
            ["layer"] = 1,
            ["hidden"] = false,
            ["size"] = {
                ["w"] = "110",
                ["h"] = "30",
            },
        }, -- [2]
    },
    ["font"] = "Fonts\\MORPHEUS_CYR.TTF",
    ["elements"] = {
        ["plusLevel"] = {
            ["fontSize"] = 13,
            ["justifyH"] = "LEFT",
            ["position"] = {
                ["y"] = "-24",
                ["x"] = "40",
                ["point"] = "LEFT",
                ["rPoint"] = "TOPLEFT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 20,
                ["h"] = 20,
            },
        },
        ["affixes"] = {
            ["iconSize"] = 22,
            ["size"] = {
                ["w"] = 90,
                ["h"] = 30,
            },
            ["hidden"] = false,
            ["position"] = {
                ["y"] = "0",
                ["x"] = "-16",
                ["point"] = "TOPRIGHT",
                ["rPoint"] = "BOTTOMRIGHT",
            },
        },
        ["progress"] = {
            ["fontSize"] = 20,
            ["justifyH"] = "LEFT",
            ["position"] = {
                ["y"] = "-6",
                ["x"] = "10",
                ["point"] = "LEFT",
                ["rPoint"] = "LEFT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 90,
                ["h"] = 30,
            },
        },
        ["plusTimer"] = {
            ["fontSize"] = 12,
            ["justifyH"] = "RIGHT",
            ["position"] = {
                ["y"] = "0",
                ["x"] = "-14",
                ["point"] = "RIGHT",
                ["rPoint"] = "RIGHT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 50,
                ["h"] = 18,
            },
        },
        ["deathTimer"] = {
            ["fontSize"] = 12,
            ["justifyH"] = "RIGHT",
            ["position"] = {
                ["y"] = "18",
                ["x"] = "-10",
                ["point"] = "RIGHT",
                ["rPoint"] = "BOTTOMRIGHT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.2588235294117647,
                ["g"] = 0.01176470588235294,
                ["b"] = 0,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 60,
                ["h"] = 18,
            },
        },
        ["prognosis"] = {
            ["fontSize"] = 12,
            ["justifyH"] = "LEFT",
            ["position"] = {
                ["y"] = "18",
                ["x"] = "14",
                ["point"] = "LEFT",
                ["rPoint"] = "BOTTOMLEFT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 60,
                ["h"] = 20,
            },
        },
        ["dungeonname"] = {
            ["fontSize"] = 13,
            ["justifyH"] = "LEFT",
            ["position"] = {
                ["y"] = "14",
                ["x"] = "0",
                ["point"] = "BOTTOMLEFT",
                ["rPoint"] = "TOPLEFT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["justifyV"] = "BOTTOM",
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 180,
                ["h"] = 100,
            },
        },
        ["level"] = {
            ["fontSize"] = 20,
            ["justifyH"] = "LEFT",
            ["position"] = {
                ["y"] = "-24",
                ["x"] = "14",
                ["point"] = "LEFT",
                ["rPoint"] = "TOPLEFT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 20,
                ["h"] = 20,
            },
        },
        ["timer"] = {
            ["fontSize"] = 12,
            ["justifyH"] = "RIGHT",
            ["position"] = {
                ["y"] = "-24",
                ["x"] = "-14",
                ["point"] = "RIGHT",
                ["rPoint"] = "TOPRIGHT",
            },
            ["color"] = {
                {
                    ["a"] = 1,
                    ["r"] = 1,
                    ["g"] = 1,
                    ["b"] = 0,
                }, -- [1]
                {
                    ["a"] = 1,
                    ["r"] = 0,
                    ["g"] = 1,
                    ["b"] = 0,
                }, -- [2]
                [0] = {
                    ["a"] = 1,
                    ["r"] = 1,
                    ["g"] = 1,
                    ["b"] = 1,
                },
                [-1] = {
                    ["a"] = 1,
                    ["r"] = 1,
                    ["g"] = 0,
                    ["b"] = 0,
                },
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 50,
                ["h"] = 18,
            },
        },
        ["bosses"] = {
            ["fontSize"] = 18,
            ["justifyH"] = "LEFT",
            ["position"] = {
                ["y"] = "-16",
                ["x"] = "10",
                ["point"] = "LEFT",
                ["rPoint"] = "BOTTOMLEFT",
            },
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.8,
                ["g"] = 0.8,
                ["b"] = 0.8,
            },
            ["hidden"] = false,
            ["size"] = {
                ["w"] = 50,
                ["h"] = 30,
            },
        },
    },
    ["main"] = {
        ["background"] = {
            ["color"] = {
                ["a"] = 1,
                ["r"] = 0.6588235294117647,
                ["g"] = 0.6980392156862745,
                ["b"] = 0.6941176470588235,
            },
            ["texture"] = "Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal",
        },
        ["border"] = {
            ["color"] = {
                ["a"] = 1,
                ["r"] = 1,
                ["g"] = 0.8745098039215686,
                ["b"] = 0.580392156862745,
            },
            ["texture"] = "Interface\\Tooltips\\UI-Tooltip-Border",
            ["inset"] = 4,
            ["size"] = 18,
        },
        ["size"] = {
            ["w"] = "160",
            ["h"] = "80",
        },
    },
    ["name"] = "Dragon",
}