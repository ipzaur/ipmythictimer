local AddonName, Addon = ...

local points = {
    CENTER      = 'CENTER',
    TOP         = 'TOP',
    BOTTOM      = 'BOTTOM',
    LEFT        = 'LEFT',
    RIGHT       = 'RIGHT',
    TOPLEFT     = 'TOPLEFT',
    TOPRIGHT    = 'TOPRIGHT',
    BOTTOMLEFT  = 'BOTTOMLEFT',
    BOTTOMRIGHT = 'BOTTOMRIGHT',
}

function Addon:RenderElemEditor()
    Addon.fElemEditor = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fElemEditor:ClearAllPoints()
    Addon.fElemEditor:SetSize(250, 220)
    Addon.fElemEditor:SetPoint("CENTER", Addon.fMain, "LEFT", -150, 0)
    Addon.fElemEditor:SetBackdrop(Addon.backdrop)
    Addon.fElemEditor:SetBackdropColor(0,0,0, .9)
    Addon.fElemEditor:EnableMouse(true)
    Addon.fElemEditor:SetMovable(true)
    Addon.fElemEditor:RegisterForDrag("LeftButton")
    Addon.fElemEditor:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fElemEditor:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
    end)

    Addon.fElemEditor.caption = Addon.fElemEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fElemEditor.caption:SetPoint("CENTER", Addon.fElemEditor, "TOP", 0, -20)
    Addon.fElemEditor.caption:SetJustifyH("CENTER")
    Addon.fElemEditor.caption:SetSize(250, 20)
    Addon.fElemEditor.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fElemEditor.caption:SetTextColor(1, 1, 1)
    Addon.fElemEditor.caption:SetText(Addon.localization.ELEMPOS)

    -- X-Close button
    Addon.fElemEditor.closeX = CreateFrame("Button", nil, Addon.fElemEditor, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fElemEditor.closeX:SetPoint("TOP", Addon.fElemEditor, "TOPRIGHT", -20, -5)
    Addon.fElemEditor.closeX:SetSize(26, 26)
    Addon.fElemEditor.closeX:SetBackdrop(Addon.backdrop)
    Addon.fElemEditor.closeX:SetBackdropColor(0,0,0, 1)
    Addon.fElemEditor.closeX:SetScript("OnClick", function(self)
        Addon:CloseElemEditor()
    end)
    Addon.fElemEditor.closeX:SetScript("OnEnter", function(self, event, ...)
        Addon.fElemEditor.closeX:SetBackdropColor(.1,.1,.1, 1)
    end)
    Addon.fElemEditor.closeX:SetScript("OnLeave", function(self, event, ...)
        Addon.fElemEditor.closeX:SetBackdropColor(0,0,0, 1)
    end)
    Addon.fElemEditor.closeX.icon = Addon.fElemEditor.closeX:CreateTexture()
    Addon.fElemEditor.closeX.icon:SetSize(16, 16)
    Addon.fElemEditor.closeX.icon:ClearAllPoints()
    Addon.fElemEditor.closeX.icon:SetPoint("CENTER", Addon.fElemEditor.closeX, "CENTER", 0, 0)
    Addon.fElemEditor.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\x-close")

    -- Settings
    -- Point caption
    local top = -50
    Addon.fElemEditor.pointCaption = Addon.fElemEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fElemEditor.pointCaption:SetPoint("CENTER", Addon.fElemEditor, "TOP", 0, top)
    Addon.fElemEditor.pointCaption:SetJustifyH("CENTER")
    Addon.fElemEditor.pointCaption:SetSize(200, 20)
    Addon.fElemEditor.pointCaption:SetTextColor(1, 1, 1)
    Addon.fElemEditor.pointCaption:SetText(Addon.localization.POINT)
    -- Point
    top = top - 24
    Addon.fElemEditor.point = CreateFrame("Button", nil, Addon.fElemEditor, "IPListBox")
    Addon.fElemEditor.point:SetSize(210, 30)
    Addon.fElemEditor.point:SetPoint("CENTER", Addon.fElemEditor, "TOP", 0, top)
    Addon.fElemEditor.point:SetList(points)
    Addon.fElemEditor.point:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetElemPosition('point', key)
        end,
    })
    -- Relative Point caption
    top = top - 34
    Addon.fElemEditor.rPointCaption = Addon.fElemEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fElemEditor.rPointCaption:SetPoint("CENTER", Addon.fElemEditor, "TOP", 0, top)
    Addon.fElemEditor.rPointCaption:SetJustifyH("CENTER")
    Addon.fElemEditor.rPointCaption:SetSize(200, 20)
    Addon.fElemEditor.rPointCaption:SetTextColor(1, 1, 1)
    Addon.fElemEditor.rPointCaption:SetText(Addon.localization.RELPOINT)
    -- Relative Point
    top = top - 24
    Addon.fElemEditor.rPoint = CreateFrame("Button", nil, Addon.fElemEditor, "IPListBox")
    Addon.fElemEditor.rPoint:SetSize(210, 30)
    Addon.fElemEditor.rPoint:SetPoint("CENTER", Addon.fElemEditor, "TOP", 0, top)
    Addon.fElemEditor.rPoint:SetList(points)
    Addon.fElemEditor.rPoint:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetElemPosition('rPoint', key)
        end,
    })

    top = top - 50
    -- X caption
    Addon.fElemEditor.posXCaption = Addon.fElemEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fElemEditor.posXCaption:SetPoint("RIGHT", Addon.fElemEditor, "TOP", -76, top)
    Addon.fElemEditor.posXCaption:SetJustifyH("RIGHT")
    Addon.fElemEditor.posXCaption:SetSize(20, 20)
    Addon.fElemEditor.posXCaption:SetTextColor(1, 1, 1)
    Addon.fElemEditor.posXCaption:SetText('x')
    -- X edit box
    Addon.fElemEditor.posX = CreateFrame("EditBox", nil, Addon.fElemEditor, "IPEditBox")
    Addon.fElemEditor.posX:SetAutoFocus(false)
    Addon.fElemEditor.posX:SetPoint("RIGHT", Addon.fElemEditor, "TOP", -10, top)
    Addon.fElemEditor.posX:SetSize(60, 30)
    Addon.fElemEditor.posX:SetMaxLetters(4)
    Addon.fElemEditor.posX:SetScript('OnTextChanged', function(self)
        Addon:SetElemPosition('x', self:GetText())
    end)
    -- Y caption
    Addon.fElemEditor.posYCaption = Addon.fElemEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fElemEditor.posYCaption:SetPoint("RIGHT", Addon.fElemEditor, "TOPRIGHT", -86, top)
    Addon.fElemEditor.posYCaption:SetJustifyH("RIGHT")
    Addon.fElemEditor.posYCaption:SetSize(20, 20)
    Addon.fElemEditor.posYCaption:SetTextColor(1, 1, 1)
    Addon.fElemEditor.posYCaption:SetText('y')
    -- Y edit box
    Addon.fElemEditor.posY = CreateFrame("EditBox", nil, Addon.fElemEditor, "IPEditBox")
    Addon.fElemEditor.posY:SetAutoFocus(false)
    Addon.fElemEditor.posY:SetPoint("RIGHT", Addon.fElemEditor, "TOPRIGHT", -20, top)
    Addon.fElemEditor.posY:SetSize(60, 30)
    Addon.fElemEditor.posY:SetMaxLetters(4)
    Addon.fElemEditor.posY:SetScript('OnTextChanged', function(self)
        Addon:SetElemPosition('y', self:GetText())
    end)
end
