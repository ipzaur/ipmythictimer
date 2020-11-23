local AddonName, Addon = ...

function Addon:InitThemes()
    if IPMTTheme == nil then
        IPMTTheme = {}
        if IPMTOptions.font then
            IPMTTheme = {
                [1] = {
                    font = IPMTOptions.font,
                    main = {
                        size = {
                            w = IPMTOptions.size[0],
                            h = IPMTOptions.size[1],
                        },
                        background = {
                            color   = {r=0, g=0, b=0, a=IPMTOptions.opacity},
                        },
                    },
                    elements = {},
                }
            }
            for frame, info in pairs(IPMTOptions.frame) do
                IPMTTheme[1].elements[frame] = {}
                if info.fontSize then 
                    IPMTTheme[1].elements[frame].fontSize = info.fontSize
                end
                if info.hidden then 
                    IPMTTheme[1].elements[frame].hidden = info.hidden
                end
            end
        end
    end

    for i, theme in ipairs(IPMTTheme) do
        IPMTTheme[i] = Addon:CopyObject(Addon.theme[1], IPMTTheme[i])
    end
end

function Addon:ToggleThemeEditor()
    if Addon.opened.themes then
        Addon:CloseThemeEditor()
    else
        Addon:ShowThemeEditor()
    end
end

local optionsSize = {
    collapsed = {
        w = 0,
        h = 0,
    },
    expanded = {
        w = 0,
        h = 0,
    },
}
function Addon:ShowThemeEditor()
    if Addon.fThemes == nil then
        Addon:RenderThemeEditor()
    end
    if optionsSize.collapsed.w == 0 then
        optionsSize.collapsed.w = Addon.fOptions:GetWidth()
        optionsSize.collapsed.h = Addon.fOptions:GetHeight()

        optionsSize.expanded.w = optionsSize.collapsed.w + Addon.fThemes:GetWidth() + 28
        optionsSize.expanded.h = max(optionsSize.collapsed.h, 600)
         
    end
    Addon.fOptions:SetSize(optionsSize.expanded.w, optionsSize.expanded.h)
    Addon.fOptions.editTheme.fTexture:SetVertexColor(1, 1, 1)
    Addon.fOptions.editTheme:SetBackdropColor(.25,.25,.25, 1)
    Addon.opened.themes = true

    Addon:FillDummy()
    Addon:FillThemeEditor()
    Addon.fThemes:Show()
end

function Addon:CloseThemeEditor()
    if Addon.fThemes == nil then
        return
    end
    local theme = IPMTTheme[IPMTOptions.theme]
    Addon.fOptions:SetSize(optionsSize.collapsed.w, optionsSize.collapsed.h)
    Addon.fOptions.editTheme:SetBackdropColor(.175,.175,.175, 1)
    Addon.fThemes:Hide()
    Addon.opened.themes = false
    for frame,info in pairs(theme.elements) do
        Addon:ToggleMovable(frame, false)
        if info.hidden then
            Addon.fMain[frame]:Hide()
        elseif IPMTDungeon.keyActive and frame == 'deathTimer' then
            Addon.deaths:Update()
        end
    end
    Addon:CloseElemEditor()
    Addon.fOptions.editTheme:OnLeave()
end

function Addon:FillDummy()
    local theme = IPMTTheme[IPMTOptions.theme]
    for i, info in ipairs(Addon.frames) do
        local frame = info.label
        if info.hasText and info.dummy ~= nil then
            if not IPMTDungeon.keyActive or Addon.fMain[frame].text:GetText() == nil then
                local text = info.dummy.text
                if frame == "progress" or frame == "prognosis" then
                    text = text[IPMTOptions.progress]
                end
                Addon.fMain[frame].text:SetText(text)
                Addon.fMain[frame]:Show()
                if info.dummy.colorId then
                    local color = theme.elements[frame].color[info.dummy.colorId]
                    Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
                end
            end
            if frame ~= 'dungeonname' then
                local width = Addon.fMain[frame].text:GetStringWidth()
                local height = Addon.fMain[frame].text:GetStringHeight()
                Addon.fMain[frame]:SetSize(width, height)
            end
        end
    end

    if not IPMTDungeon.keyActive then
        local name, description, filedataid = C_ChallengeMode.GetAffixInfo(117) -- Reaping icon
        for i = 1,4 do
            SetPortraitToTexture(Addon.fMain.affix[i].Portrait, filedataid)
            Addon.fMain.affix[i]:Show()
        end
    end
end

function Addon:FillThemeEditor()
    local theme = IPMTTheme[IPMTOptions.theme]
    Addon.fThemes.name:SetText(theme.name)

    Addon.fThemes.fFonts:SelectItem(theme.font, true)
    Addon.fThemes.fFonts.fText:SetFont(theme.font, 12)

    Addon.fThemes.bg.width:SetText(theme.main.size.w)
    Addon.fThemes.bg.height:SetText(theme.main.size.h)
    Addon.fThemes.bg.texture:SelectItem(theme.main.background.texture, true)
    Addon.fThemes.bg.color:ColorChange(theme.main.background.color.r, theme.main.background.color.g, theme.main.background.color.b, theme.main.background.color.a, true)
    Addon.fThemes.bg.borderInset:SetValue(theme.main.border.inset)
    Addon.fThemes.bg.border:SelectItem(theme.main.border.texture, true)
    Addon.fThemes.bg.borderColor:ColorChange(theme.main.border.color.r, theme.main.border.color.g, theme.main.border.color.b, theme.main.border.color.a, true)
    Addon.fThemes.bg.borderSize:SetValue(theme.main.border.size)

    for frame, info in pairs(theme.elements) do
        Addon.fMain[frame]:Show()
        Addon:ToggleVisible(frame, true)
        if info.fontSize ~= nil then
            Addon.fThemes[frame].fontSize:SetValue(info.fontSize)
        end
        if info.color ~= nil then
            if info.color.r ~= nil then
                Addon.fThemes[frame].color[-1]:ColorChange(info.color.r, info.color.g, info.color.b, info.color.a, true)
            else
                for i, color in pairs(info.color) do
                    Addon.fThemes[frame].color[i]:ColorChange(color.r, color.g, color.b, color.a, true)
                end
            end
        end
    end
end

function Addon:SetThemeName(name)
    IPMTTheme[IPMTOptions.theme].name = name
    Addon.fOptions.theme:SelectItem(IPMTOptions.theme, true)
end

function Addon:ToggleVisible(frame, woSave)
    local elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    if woSave ~= true then
        elemInfo.hidden = not elemInfo.hidden
    end

    if elemInfo.hidden then
        Addon.fMain[frame]:SetBackdropColor(.85,0,0, .35)
        alpha = Addon.fThemes[frame].toggle.icon:GetAlpha()
        Addon.fThemes[frame].toggle.icon:SetVertexColor(.85, 0, 0, alpha)
        Addon.fThemes[frame].toggle.icon:SetTexCoord(.25, .5, 0, .5)
    else
        local alpha = .15
        if woSave == true then
            alpha = 0
        end
        Addon.fMain[frame]:SetBackdropColor(1,1,1, alpha)
        Addon.fThemes[frame].toggle.icon:SetTexCoord(0, .25, 0, .5)
        alpha = Addon.fThemes[frame].toggle.icon:GetAlpha()
        Addon.fThemes[frame].toggle.icon:SetVertexColor(1, 1, 1, alpha)
    end
end
function Addon:HoverVisible(frame, button)
    button.icon:SetAlpha(.9)
    local text
    if IPMTTheme[IPMTOptions.theme].elements[frame].hidden then
        text = Addon.localization.ELEMACTION.SHOW
    else
        text = Addon.localization.ELEMACTION.HIDE
    end
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:SetText(text, .9, .9, 0, 1, true)
    GameTooltip:Show()
    Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
end
function Addon:BlurVisible(frame, button)
    button.icon:SetAlpha(.5)
    GameTooltip:Hide()
end

function Addon:ChangeMain(param, value, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]

    local params = Addon:CopyObject(theme.main)

    if param == 'width' then
        params.size.w = value
    elseif param == 'height' then
        params.size.h = value
    elseif param == 'color' then
        params.background.color = Addon:CopyObject(value)
    elseif param == 'borderColor' then
        params.border.color = Addon:CopyObject(value)
    elseif param == 'texture' then
        params.background.texture = value
    elseif param == 'border' then
        params.border.texture = value
    elseif param == 'borderSize' then
        params.border.size = value
    elseif param == 'borderInset' then
        params.border.inset = value
    end

    local backdrop = {
        bgFile   = params.background.texture,
        edgeFile = params.border.texture,
        tile     = false,
        edgeSize = params.border.size,
        insets   = {
            left   = params.border.inset,
            right  = params.border.inset,
            top    = params.border.inset,
            bottom = params.border.inset,
        },
    }
    if backdrop.edgeFile == 'none' then
        backdrop.edgeFile = nil
    end

    Addon.fMain:SetSize(params.size.w, params.size.h)
    Addon.fMain:SetBackdrop(backdrop)
    Addon.fMain:SetBackdropColor(params.background.color.r, params.background.color.g, params.background.color.b, params.background.color.a)
    Addon.fMain:SetBackdropBorderColor(params.border.color.r, params.border.color.g, params.border.color.b, params.border.color.a)

    if woSave ~= true then
        theme.main = Addon:CopyObject(params)
    end
end

function Addon:SetFont(filepath, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    for i, info in ipairs(Addon.frames) do
        local frameName = info.label
        local elemInfo = theme.elements[frameName]
        if frameName == Addon.season.frameName then
            if Addon.season.SetFont then
                Addon.season:SetFont(filepath, elemInfo.fontSize)
            end
        elseif info.hasText then
            Addon.fMain[frameName].text:SetFont(filepath, elemInfo.fontSize)
            if frameName ~= "dungeonname" then
                local width = Addon.fMain[frameName].text:GetStringWidth()
                local height = Addon.fMain[frameName].text:GetStringHeight()
                Addon.fMain[frameName]:SetSize(width, height)
            end
        end
    end
    if woSave ~= true then
        theme.font = filepath
    end
end

function Addon:SetFontSize(frame, value, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    if frame == Addon.season.frameName then
        if Addon.season.SetFont then
            Addon.season:SetFont(theme.font, value)
        end
    else
        Addon.fMain[frame].text:SetFont(theme.font, value)
        if frame ~= "dungeonname" then
            local width = Addon.fMain[frame].text:GetStringWidth()
            local height = Addon.fMain[frame].text:GetStringHeight()
            Addon.fMain[frame]:SetSize(width, height)
        end
    end
    if woSave ~= true then
        theme.elements[frame].fontSize = value
    end
end

function Addon:SetColor(frame, color, i, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    if frame == Addon.season.frameName then
        if Addon.season.SetColor then
            Addon.season:SetColor(color, i)
        end
    else
        Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
        Addon.fMain[frame].text:SetAlpha(color.a)
    end
    if woSave ~= true then
        local elemInfo = theme.elements[frame]
        if elemInfo.color.r ~= nil then
            elemInfo.color = Addon:CopyObject(color)
        else
            elemInfo.color[i] = Addon:CopyObject(color)
        end
    end
end

function Addon:SetIconSize(frame, value, woSave)
    if frame == Addon.season.frameName then
        if Addon.season.SetIconSize then
            Addon.season:SetIconSize(value)
        end
    else
        Addon.fMain[frame]:SetSize(value*4 + 10, value + 10)
        for f = 1,4 do
            local right = (-1) * (value + 1) * (f-1)
            Addon.fMain.affix[f]:SetSize(value, value)
            Addon.fMain.affix[f].Portrait:SetSize(value, value - 2)
            Addon.fMain.affix[f]:SetPoint("RIGHT", Addon.fMain.affixes, "RIGHT", right - 4, 0)
        end
    end

    if woSave ~= true then
        IPMTTheme[IPMTOptions.theme].elements[frame].iconSize = value
    end
end

-- Movable element
function Addon:ToggleMovable(frame, enable)
    if enable == nil then
        enable = not Addon.fMain[frame].isMovable
    end
    Addon.fMain[frame].isMovable = enable
    if Addon.fMain[frame].isMovable then
        Addon.fMain[frame]:SetBackdropColor(1,1,1, .25)
        Addon.fThemes[frame].moveMode.icon:SetAlpha(1)
    else
        if IPMTTheme[IPMTOptions.theme].elements[frame].hidden then
            Addon.fMain[frame]:SetBackdropColor(.85,0,0, .15)
        else
            local alpha = .15
            if not Addon.opened.themes then
                alpha = 0
            end
            Addon.fMain[frame]:SetBackdropColor(1,1,1, alpha)
        end
        local alpha = Addon.fThemes[frame].moveMode.icon:GetAlpha()
        if alpha == 1 then
            alpha = .9
        else
            alpha = .5
        end
        Addon.fThemes[frame].moveMode.icon:SetAlpha(alpha)
    end
    Addon.fMain[frame]:EnableMouse(Addon.fMain[frame].isMovable)
    Addon.fMain[frame]:SetMovable(Addon.fMain[frame].isMovable)
    if frame == 'affixes' then
        for f = 1,4 do
            Addon.fMain.affix[f]:EnableMouse(not Addon.fMain[frame].isMovable)
        end
    end
end
function Addon:HoverMovable(frame, button)
    if not Addon.fMain[frame].isMovable then
        button.icon:SetAlpha(.9)
    end
    local text
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:SetText(Addon.localization.ELEMACTION.MOVE, .9, .9, 0, 1, true)
    GameTooltip:Show()
    Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
end
function Addon:BlurMovable(frame, button)
    if not Addon.fMain[frame].isMovable then
        button.icon:SetAlpha(.5)
    end
    GameTooltip:Hide()
end

function Addon:MoveElement(frame, params, woSave)
    local elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    if params == nil then
        params = elemInfo.position
    else
        if params.point == nil then
            params.point = elemInfo.position.point
        end
        if params.rPoint == nil then
            params.rPoint = elemInfo.position.rPoint
        end
        if params.x == nil then
            params.x = elemInfo.position.x
        end
        if params.y == nil then
            params.y = elemInfo.position.y
        end
    end
    Addon.fMain[frame]:ClearAllPoints()
    Addon.fMain[frame]:SetPoint(params.point, Addon.fMain, params.rPoint, params.x, params.y)

    if woSave ~= true then
        local elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
        elemInfo.position.x = params.x
        elemInfo.position.y = params.y
        elemInfo.position.point = params.point
        elemInfo.position.rPoint = params.rPoint
    end
end

function Addon:SmartMoveElement(self, frame)
    local x = self:GetLeft() - Addon.fMain:GetLeft()
    local y = self:GetTop() - Addon.fMain:GetTop() - self:GetHeight() / 2
    local point = "LEFT"
    local rPoint
    if x > Addon.fMain:GetWidth() / 2 then
        point = "RIGHT"
        x = self:GetRight() - Addon.fMain:GetRight()
    end
    if y < Addon.fMain:GetHeight() / -2 then
        rPoint = "BOTTOM" .. point
        y = self:GetBottom() - Addon.fMain:GetBottom() + self:GetHeight() / 2
    else
        rPoint = "TOP" .. point
    end
    Addon:MoveElement(frame, {
        point = point,
        rPoint = rPoint,
        x = x,
        y = y,
    })
end

function Addon:DuplicateTheme(theme)
    local newTheme = Addon:CopyObject(theme)
    newTheme.name = newTheme.name .. " (" .. Addon.localization.COPY .. ")"
    table.insert(IPMTTheme, newTheme)
end

function Addon:ApplyTheme(themeID)
    IPMTOptions.theme = themeID
    local theme = IPMTTheme[IPMTOptions.theme]

    Addon:ChangeMain(nil, nil, true)
    Addon:SetFont(theme.font, true)
    for frame, info in pairs(theme.elements) do
        Addon:MoveElement(frame, nil, true)
        if info.fontSize ~= nil then
            Addon:SetFontSize(frame, info.fontSize, true)
            if info.color ~= nil then
                if info.color.r ~= nil then
                    Addon:SetColor(frame, info.color, nil, true)
                else
                    Addon:SetColor(frame, info.color[0], nil, true)
                end
            end
        end
        if info.iconSize then
            Addon:SetIconSize(frame, info.iconSize, true)
        end
        if info.hidden then
            Addon.fMain[frame]:Hide()
        else
            Addon.fMain[frame]:Show()
            Addon.fMain[frame]:SetBackdropColor(1,1,1, 0)
        end
    end
    if Addon.opened.themes then
        Addon:FillThemeEditor()
    end
    Addon.fOptions.removeTheme:ToggleDisabled(IPMTOptions.theme == 1)
end

function Addon:RemoveTheme(themeID)
    if themeID == 1 then
        return
    end
    local themes = {}
    for i,theme in ipairs(IPMTTheme) do
        if i ~= themeID then
            table.insert(themes, theme)
        end
    end
    IPMTTheme = themes
    Addon.fOptions.theme:SelectItem(1)
end

function Addon:RestoreDefaultTheme()
    IPMTTheme[1] = Addon:CopyObject(Addon.theme[1])
    Addon.fOptions.theme:SelectItem(1)
end