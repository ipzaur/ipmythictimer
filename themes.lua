local AddonName, Addon = ...

function Addon:InitThemes()
    if IPMTTheme == nil then
        IPMTTheme = {}
    end
    IPMTTheme[1] = Addon:CopyObject(Addon.theme[1], IPMTTheme[1])
end

function Addon:ToggleThemeEditor()
    if Addon.fThemes and Addon.fThemes:IsShown() then
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
        Addon:FillThemeEditor()
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

    local theme = IPMTTheme[IPMTOptions.theme]
    for frame, info in pairs(theme.elements) do
        Addon.fMain[frame]:Show()
        Addon:ToggleVisible(frame, true)
    end
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
    for i,info in ipairs(Addon.frames) do
        Addon:ToggleMovable(info.label, false)
        if theme.elements[info.label].hidden then
            Addon.fMain[info.label]:Hide()
        end
    end
    Addon:CloseElemEditor()
end

function Addon:FillThemeEditor()
    local theme = IPMTTheme[IPMTOptions.theme]
    Addon.fThemes.name:SetText(theme.name)
    Addon.fThemes.fFonts.fText:SetFont(theme.font, 12)

    Addon.fThemes.bg.width:SetText(theme.main.size.w)
    Addon.fThemes.bg.height:SetText(theme.main.size.h)
    Addon.fThemes.bg.color:ColorChange(theme.main.background.color.r, theme.main.background.color.g, theme.main.background.color.b, theme.main.background.color.a, true)
    Addon.fThemes.bg.borderColor:ColorChange(theme.main.border.color.r, theme.main.border.color.g, theme.main.border.color.b, theme.main.border.color.a, true)

    for frame, info in pairs(theme.elements) do
        Addon:ToggleVisible(frame, true)
    end
end

function Addon:SetThemeName(name)
    IPMTTheme[IPMTOptions.theme].name = name
    Addon.fOptions.theme:SelectItem(IPMTOptions.theme, true)
end

function Addon:SetFont(filepath, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    if woSave ~= true then
        theme.font = filepath
    end
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
end

function Addon:ToggleVisible(frame, woSave)
    local elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    if woSave ~= true then
        elemInfo.hidden = not elemInfo.hidden
    end

    if elemInfo.hidden then
        Addon.fMain[frame]:SetBackdropColor(.85,0,0, .15)
        Addon.fThemes[frame].toggle.icon:SetTexCoord(.25, .5, 0, .5)
    else
        local alpha = .15
        if woSave == true then
            alpha = 0
        end
        Addon.fMain[frame]:SetBackdropColor(1,1,1, alpha)
        Addon.fThemes[frame].toggle.icon:SetTexCoord(0, .25, 0, .5)
    end
end

function Addon:ChangeMain(param, value, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    if param == 'color' then
        if woSave ~= true then
            theme.main.background.color = Addon:CopyObject(value)
        end
        Addon.fMain:SetBackdropColor(value.r, value.g, value.b, value.a)
    end
    if param == 'borderColor' then
        if woSave ~= true then
            theme.main.border.color = Addon:CopyObject(value)
        end
        Addon.fMain:SetBackdropBorderColor(value.r, value.g, value.b, value.a)
    end
    if param == 'width' then
        if woSave ~= true then
            theme.main.size.w = value
        end
        Addon.fMain:SetWidth(value)
    end
    if param == 'height' then
        if woSave ~= true then
            theme.main.size.h = value
        end
        Addon.fMain:SetHeight(value)
    end
    if param == 'texture' or param == 'border' or param == 'borderSize' or param == 'borderInset' then
        local backdrop = {
            bgFile   = theme.main.background.texture,
            edgeFile = theme.main.border.texture,
            tile     = false,
            edgeSize = theme.main.border.size,
            insets   = {
                left   = theme.main.border.inset,
                right  = theme.main.border.inset,
                top    = theme.main.border.inset,
                bottom = theme.main.border.inset,
            },
        }
        if backdrop.edgeFile == 'none' then
            backdrop.edgeFile = nil
        end
        if param == 'texture' then
            if woSave ~= true then
                theme.main.background.texture = value
            end
            backdrop.bgFile = value
        end
        if param == 'border' then
            if woSave ~= true then
                theme.main.border.texture = value
            end
            if value == 'none' then
                value = nil
            end
            backdrop.edgeFile = value
        end
        if param == 'borderSize' then
            if woSave ~= true then
                theme.main.border.size = value
            end
            backdrop.edgeSize = value
        end
        if param == 'borderInset' then
            if woSave ~= true then
                theme.main.border.inset = value
            end
            backdrop.insets = {
                left   = value,
                right  = value,
                top    = value,
                bottom = value,
            }
        end
        Addon.fMain:SetBackdrop(backdrop)
        Addon.fMain:SetBackdropColor(theme.main.background.color.r, theme.main.background.color.g, theme.main.background.color.b, theme.main.background.color.a)
        Addon.fMain:SetBackdropBorderColor(theme.main.border.color.r, theme.main.border.color.g, theme.main.border.color.b, theme.main.border.color.a)
    end
end

function Addon:SetFontSize(frame, value)
    local theme = IPMTTheme[IPMTOptions.theme]
    local elemInfo = theme.elements[frame]
    elemInfo.fontSize = value
    if frame == Addon.season.frameName then
        if Addon.season.SetFont then
            Addon.season:SetFont(theme.font, elemInfo.fontSize)
        end
    else
        Addon.fMain[frame].text:SetFont(theme.font, elemInfo.fontSize)
        if frame ~= "dungeonname" then
            local width = Addon.fMain[frame].text:GetStringWidth()
            local height = Addon.fMain[frame].text:GetStringHeight()
            Addon.fMain[frame]:SetSize(width, height)
        end
    end
end

function Addon:SetColor(frame, color, i)
    local theme = IPMTTheme[IPMTOptions.theme]
    local elemInfo = theme.elements[frame]
    if elemInfo.color.r ~= nil then
        elemInfo.color = Addon:CopyObject(color)
    else
        elemInfo.color[i] = Addon:CopyObject(color)
    end
    if frame == Addon.season.frameName then
        if Addon.season.SetColor then
            Addon.season:SetColor(color)
        end
    else
        Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
        Addon.fMain[frame].text:SetAlpha(color.a)
    end
end

function Addon:SetIconSize(frame, value)
    local theme = IPMTTheme[IPMTOptions.theme]
    local elemInfo = theme.elements[frame]
    elemInfo.iconSize = value
    Addon.fMain[frame]:SetSize(elemInfo.iconSize*4 + 10, elemInfo.iconSize + 10)
    for f = 1,4 do
        local right = (-1) * (elemInfo.iconSize + 1) * (f-1)
        Addon.fMain.affix[f]:SetSize(elemInfo.iconSize, elemInfo.iconSize)
        Addon.fMain.affix[f].Portrait:SetSize(elemInfo.iconSize, elemInfo.iconSize - 2)
        Addon.fMain.affix[f]:SetPoint("RIGHT", Addon.fMain.affixes, "RIGHT", right - 4, 0)
    end
end

function Addon:ToggleMovable(frame, enable)
    if enable == nil then
        enable = not Addon.fMain[frame].isMovable
    end
    Addon.fMain[frame].isMovable = enable
    if Addon.fMain[frame].isMovable then
        Addon.fMain[frame]:SetBackdropColor(1,1,1, .25)
        Addon.fThemes[frame].moveMode.icon:SetVertexColor(1, 1, 1)
    else
        if IPMTTheme[IPMTOptions.theme].elements[frame].hidden then
            Addon.fMain[frame]:SetBackdropColor(.85,0,0, .15)
        else
            local alpha = .15
            if not Addon.fThemes:IsShown() then
                alpha = 0
            end
            Addon.fMain[frame]:SetBackdropColor(1,1,1, alpha)
        end
        Addon.fThemes[frame].moveMode.icon:SetVertexColor(.5, .5, .5)
    end
    Addon.fMain[frame]:EnableMouse(Addon.fMain[frame].isMovable)
    Addon.fMain[frame]:SetMovable(Addon.fMain[frame].isMovable)
    for f = 1,4 do
        Addon.fMain.affix[f]:EnableMouse(not Addon.fMain[frame].isMovable)
    end
end

function Addon:MoveElement(frame, point, rPoint, x, y)
    Addon.fMain[frame]:ClearAllPoints()
    Addon.fMain[frame]:SetPoint(point, Addon.fMain, rPoint, x, y)

    local elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    elemInfo.position.x = x
    elemInfo.position.y = y
    elemInfo.position.point = point
    elemInfo.position.rPoint = rPoint
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
    Addon:MoveElement(frame, point, rPoint, x, y)
end
