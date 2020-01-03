local AddonName, Addon = ...

local helpInfo = {
    level = {
        size = {
            [0] = 160,
            [1] = 20,
        },
        position = {
            x = -180,
            y = 10,
        },
        text = "Уровень активного ключа",
        line = {
            size = {
                [0] = 178,
                [1] = 1,
            },
            position = {
                point = "BOTTOMLEFT",
                x = 0,
                y = 0,
            },
        },
    },
    plusLevel = {
        size = {
            [0] = 230,
            [1] = 20,
        },
        position = {
            x = -220,
            y = 40,
        },
        text = "Улучшение ключа при текущем таймере",
        line = {
            size = {
                [0] = 1,
                [1] = 40,
            },
            position = {
                point = "TOPRIGHT",
                x = 0,
                y = 0,
            },
        },
    },
    timer = {
        size = {
            [0] = 120,
            [1] = 20,
        },
        position = {
            x = -140,
            y = -10,
        },
        text = "Оставшееся время",
        line = {
            size = {
                [0] = 138,
                [1] = 1,
            },
            position = {
                point = "TOPLEFT",
                x = 0,
                y = 0,
            },
        },
    },
    plusTimer = {
        size = {
            [0] = 180,
            [1] = 20,
        },
        position = {
            x = -160,
            y = 90,
        },
        text = "Время до ухудшения прогресса",
        line = {
            size = {
                [0] = 1,
                [1] = 88,
            },
            position = {
                point = "TOPRIGHT",
                x = 0,
                y = 0,
            },
        },
    },
    deathTimer = {
        size = {
            [0] = 200,
            [1] = 20,
        },
        position = {
            x = -190,
            y = -114,
        },
        text = "Потраченное время из-за смертей",
        line = {
            size = {
                [0] = 1,
                [1] = 116,
            },
            position = {
                point = "BOTTOMRIGHT",
                x = 0,
                y = 0,
            },
        },
    },
    progress = {
        size = {
            [0] = 120,
            [1] = 20,
        },
        position = {
            x = -140,
            y = -10,
        },
        text = "Убито противников",
        line = {
            size = {
                [0] = 138,
                [1] = 1,
            },
            position = {
                point = "TOPLEFT",
                x = 0,
                y = 0,
            },
        },
    },
    prognosis = {
        size = {
            [0] = 180,
            [1] = 40,
        },
        position = {
            x = -160,
            y = -50,
        },
        text = "Прогресс, который дадут вошедшие в бой противники",
        line = {
            size = {
                [0] = 1,
                [1] = 60,
            },
            position = {
                point = "BOTTOMRIGHT",
                x = 0,
                y = 0,
            },
        },
    },
    bosses = {
        size = {
            [0] = 100,
            [1] = 20,
        },
        position = {
            x = -6,
            y = -120,
            point = "TOPRIGHT",
        },
        text = "Убито боссов",
        line = {
            size = {
                [0] = 1,
                [1] = 118,
            },
            position = {
                point = "BOTTOMRIGHT",
                x = 0,
                y = 0,
            },
        },
    },
    affixes = {
        size = {
            [0] = 80,
            [1] = 40,
        },
        position = {
            x = -10,
            y = 60,
            point = 'TOPRIGHT',
        },
        text = "Активные аффиксы",
        line = {
            size = {
                [0] = 1,
                [1] = 64,
            },
            position = {
                point = "TOPRIGHT",
                x = 0,
                y = 0,
            },
        },
    },
}

function Addon:HideHelp()
    Addon.fOptions.help:SetPoint("TOP", Addon.fOptions, "TOPRIGHT", -20, -5)
    Addon.fOptions.help:SetSize(30, 30)
    helpShown = false

    for frame, info in pairs(helpInfo) do
        Addon.fHelp[frame]:Hide()
    end
end

function Addon:ShowHelp()
    Addon.fOptions.help:SetPoint("TOP", Addon.fOptions, "TOPRIGHT", -20, 0)
    Addon.fOptions.help:SetSize(40, 40)
    helpShown = true

    if (Addon.fHelp == nil) then
        Addon.fHelp = {}
        for frame, info in pairs(helpInfo) do
            local point = info.position.point
            if (point == nil) then
                point = 'LEFT'
            end
            Addon.fHelp[frame] = CreateFrame("Frame", nil, Addon.fMain[frame])
            Addon.fHelp[frame]:ClearAllPoints()
            Addon.fHelp[frame]:SetSize(info.size[0], info.size[1])
            Addon.fHelp[frame]:SetPoint(point, info.position.x, info.position.y)
            Addon.fHelp[frame]:SetBackdrop(Addon.backdrop)
            Addon.fHelp[frame]:SetBackdropColor(0,0,0, .7)

            Addon.fHelp[frame].text = Addon.fHelp[frame]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            Addon.fHelp[frame].text:ClearAllPoints()
            Addon.fHelp[frame].text:SetSize(info.size[0]-12, info.size[1]-8)
            Addon.fHelp[frame].text:SetPoint("TOPLEFT", 6, -4)
            Addon.fHelp[frame].text:SetJustifyH("LEFT")
            Addon.fHelp[frame].text:SetFont(Addon.FONT_ROBOTO, 12)
            Addon.fHelp[frame].text:SetTextColor(.9, .9, 0)
            Addon.fHelp[frame].text:SetText(info.text)

            if (info.line ~= nil) then
                Addon.fHelp[frame].line = Addon.fHelp[frame]:CreateTexture()
                Addon.fHelp[frame].line:SetColorTexture(.9,.9,0, 0.9)
                Addon.fHelp[frame].line:SetSize(info.line.size[0], info.line.size[1])
                Addon.fHelp[frame].line:ClearAllPoints()
                Addon.fHelp[frame].line:SetPoint(info.line.position.point, info.line.position.x, info.line.position.y)
            end
        end
    else
        for frame, info in pairs(helpInfo) do
            Addon.fHelp[frame]:Show()
        end
    end
end
