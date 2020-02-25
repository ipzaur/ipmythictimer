local AddonName, Addon = ...

local helpInfo = {
    level = {
        size = {
            [0] = 160,
            [1] = 20,
        },
        position = {
            x = -180,
            y = 5,
        },
        text = Addon.localization.HELP.LEVEL,
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
            [0] = 240,
            [1] = 20,
        },
        position = {
            x = -230,
            y = 60,
        },
        text = Addon.localization.HELP.PLUSLEVEL,
        line = {
            size = {
                [0] = 1,
                [1] = 60,
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
        text = Addon.localization.HELP.TIMER,
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
            [0] = 200,
            [1] = 20,
        },
        position = {
            x = -180,
            y = 110,
        },
        text = Addon.localization.HELP.PLUSTIMER,
        line = {
            size = {
                [0] = 1,
                [1] = 108,
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
            [0] = 210,
            [1] = 20,
        },
        position = {
            x = -200,
            y = -114,
        },
        text = Addon.localization.HELP.DEATHTIMER,
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
        text = Addon.localization.HELP.PROGRESS,
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
        text = Addon.localization.HELP.PROGNOSIS,
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
        text = Addon.localization.HELP.BOSSES,
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
        text = Addon.localization.HELP.AFFIXES,
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
    dungeonname = {
        size = {
            [0] = 160,
            [1] = 20,
        },
        position = {
            x = -180,
            y = 4,
            point = "BOTTOMLEFT",
        },
        text = Addon.localization.DUNGENAME,
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
}

function Addon:HideHelp()
    if Addon.fOptions.help.glow:IsShown() then
        Addon.fOptions.help:SetPoint("TOP", Addon.fOptions, "TOPLEFT", 20, -5)
        Addon.fOptions.help:SetSize(30, 30)
        Addon.fOptions.help.glow:Hide()

        for frame, info in pairs(helpInfo) do
            Addon.fHelp[frame]:Hide()
        end
    end
end

function Addon:ShowHelp()
    Addon.fOptions.help:SetPoint("TOP", Addon.fOptions, "TOPLEFT", 20, 0)
    Addon.fOptions.help:SetSize(40, 40)
    Addon.fOptions.help.glow:Show()

    if Addon.fHelp == nil then
        Addon.fHelp = {}
        for frame, info in pairs(helpInfo) do
            local point = info.position.point
            if point == nil then
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
            Addon.fHelp[frame].text:SetFont(Addon.DECOR_FONT, 12 + Addon.DECOR_FONTSIZE_DELTA)
            Addon.fHelp[frame].text:SetTextColor(.9, .9, 0)
            Addon.fHelp[frame].text:SetText(info.text)

            if info.line ~= nil then
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
