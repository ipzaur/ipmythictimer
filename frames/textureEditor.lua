local AddonName, Addon = ...

function Addon:RenderTextureEditor()
    Addon.fTextureEditor = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fTextureEditor:ClearAllPoints()
    Addon.fTextureEditor:SetSize(380, 310)
    Addon.fTextureEditor:SetPoint("CENTER", Addon.fThemes, "RIGHT", 250, 0)
    Addon.fTextureEditor:SetBackdrop(Addon.backdrop)
    Addon.fTextureEditor:SetBackdropColor(0,0,0, .9)
    Addon.fTextureEditor:EnableMouse(true)
    Addon.fTextureEditor:SetMovable(true)
    Addon.fTextureEditor:RegisterForDrag("LeftButton")
    Addon.fTextureEditor:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fTextureEditor:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
    end)

    Addon.fTextureEditor.caption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.caption:SetPoint("CENTER", Addon.fTextureEditor, "TOP", 0, -20)
    Addon.fTextureEditor.caption:SetJustifyH("CENTER")
    Addon.fTextureEditor.caption:SetSize(350, 20)
    Addon.fTextureEditor.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fTextureEditor.caption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.caption:SetText(Addon.localization.TXTSETTING)

    -- X-Close button
    Addon.fTextureEditor.closeX = CreateFrame("Button", nil, Addon.fTextureEditor, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fTextureEditor.closeX:SetPoint("TOP", Addon.fTextureEditor, "TOPRIGHT", -20, -5)
    Addon.fTextureEditor.closeX:SetSize(26, 26)
    Addon.fTextureEditor.closeX:SetBackdrop(Addon.backdrop)
    Addon.fTextureEditor.closeX:SetBackdropColor(0,0,0, 1)
    Addon.fTextureEditor.closeX:SetScript("OnClick", function(self)
        Addon:CloseTextureEditor()
    end)
    Addon.fTextureEditor.closeX:SetScript("OnEnter", function(self, event, ...)
        Addon.fTextureEditor.closeX:SetBackdropColor(.1,.1,.1, 1)
    end)
    Addon.fTextureEditor.closeX:SetScript("OnLeave", function(self, event, ...)
        Addon.fTextureEditor.closeX:SetBackdropColor(0,0,0, 1)
    end)
    Addon.fTextureEditor.closeX.icon = Addon.fTextureEditor.closeX:CreateTexture()
    Addon.fTextureEditor.closeX.icon:SetSize(16, 16)
    Addon.fTextureEditor.closeX.icon:ClearAllPoints()
    Addon.fTextureEditor.closeX.icon:SetPoint("CENTER", Addon.fTextureEditor.closeX, "CENTER", 0, 0)
    Addon.fTextureEditor.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\x-close")

    -- Settings
    -- Sizes caption
    local top = -60
    Addon.fTextureEditor.sizesCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.sizesCaption:SetPoint("CENTER", Addon.fTextureEditor, "TOP", 0, top)
    Addon.fTextureEditor.sizesCaption:SetJustifyH("CENTER")
    Addon.fTextureEditor.sizesCaption:SetSize(300, 20)
    Addon.fTextureEditor.sizesCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.sizesCaption:SetText("Изначальные размеры текстуры")
    top = top - 34
    -- Width caption
    Addon.fTextureEditor.widthCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.widthCaption:SetPoint("RIGHT", Addon.fTextureEditor, "TOP", -96, top)
    Addon.fTextureEditor.widthCaption:SetJustifyH("RIGHT")
    Addon.fTextureEditor.widthCaption:SetSize(60, 20)
    Addon.fTextureEditor.widthCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.widthCaption:SetText(Addon.localization.WIDTH)
    -- Width edit box
    Addon.fTextureEditor.width = CreateFrame("EditBox", nil, Addon.fTextureEditor, "IPEditBox")
    Addon.fTextureEditor.width:SetAutoFocus(false)
    Addon.fTextureEditor.width:SetPoint("RIGHT", Addon.fTextureEditor, "TOP", -10, top)
    Addon.fTextureEditor.width:SetSize(80, 30)
    Addon.fTextureEditor.width:SetNumeric(true)
    Addon.fTextureEditor.width:SetMaxLetters(5)
    Addon.fTextureEditor.width:SetScript('OnTextChanged', function(self)
        if self:HasFocus() then
            Addon:SetTextureSettings()
        end
    end)
    -- Height caption
    Addon.fTextureEditor.heightCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.heightCaption:SetPoint("LEFT", Addon.fTextureEditor, "TOP", 0, top)
    Addon.fTextureEditor.heightCaption:SetJustifyH("RIGHT")
    Addon.fTextureEditor.heightCaption:SetSize(60, 20)
    Addon.fTextureEditor.heightCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.heightCaption:SetText(Addon.localization.HEIGHT)
    -- Height edit box
    Addon.fTextureEditor.height = CreateFrame("EditBox", nil, Addon.fTextureEditor, "IPEditBox")
    Addon.fTextureEditor.height:SetAutoFocus(false)
    Addon.fTextureEditor.height:SetPoint("LEFT", Addon.fTextureEditor, "TOP", 66, top)
    Addon.fTextureEditor.height:SetSize(80, 30)
    Addon.fTextureEditor.height:SetNumeric(true)
    Addon.fTextureEditor.height:SetMaxLetters(5)
    Addon.fTextureEditor.height:SetScript('OnTextChanged', function(self)
        if self:HasFocus() then
            Addon:SetTextureSettings()
        end
    end)

    -- Crop caption
    top = top - 50
    Addon.fTextureEditor.cropCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.cropCaption:SetPoint("CENTER", Addon.fTextureEditor, "TOP", 0, top)
    Addon.fTextureEditor.cropCaption:SetJustifyH("CENTER")
    Addon.fTextureEditor.cropCaption:SetSize(200, 20)
    Addon.fTextureEditor.cropCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.cropCaption:SetText(Addon.localization.TXTCROP)

    top = top - 50
    -- Top edit box
    Addon.fTextureEditor.cropTop = CreateFrame("EditBox", nil, Addon.fTextureEditor, "IPEditBox")
    Addon.fTextureEditor.cropTop:SetAutoFocus(false)
    Addon.fTextureEditor.cropTop:SetPoint("CENTER", Addon.fTextureEditor, "TOP", 0, top)
    Addon.fTextureEditor.cropTop:SetSize(60, 30)
    Addon.fTextureEditor.cropTop:SetNumeric(true)
    Addon.fTextureEditor.cropTop:SetMaxLetters(4)
    Addon.fTextureEditor.cropTop:SetScript('OnTextChanged', function(self)
        if self:HasFocus() then
            Addon:SetTextureSettings()
        end
    end)
    -- Top caption
    Addon.fTextureEditor.cropTopCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.cropTopCaption:SetPoint("BOTTOM", Addon.fTextureEditor.cropTop, "TOP", 0, 0)
    Addon.fTextureEditor.cropTopCaption:SetJustifyH("CENTER")
    Addon.fTextureEditor.cropTopCaption:SetSize(60, 20)
    Addon.fTextureEditor.cropTopCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.cropTopCaption:SetText(Addon.localization.TOP)

    top = top - 34
    -- Left edit box
    Addon.fTextureEditor.cropLeft = CreateFrame("EditBox", nil, Addon.fTextureEditor, "IPEditBox")
    Addon.fTextureEditor.cropLeft:SetAutoFocus(false)
    Addon.fTextureEditor.cropLeft:SetPoint("RIGHT", Addon.fTextureEditor, "TOP", -30, top)
    Addon.fTextureEditor.cropLeft:SetSize(60, 30)
    Addon.fTextureEditor.cropLeft:SetNumeric(true)
    Addon.fTextureEditor.cropLeft:SetMaxLetters(4)
    Addon.fTextureEditor.cropLeft:SetScript('OnTextChanged', function(self)
        if self:HasFocus() then
            Addon:SetTextureSettings()
        end
    end)
    -- Left caption
    Addon.fTextureEditor.cropLeftCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.cropLeftCaption:SetPoint("RIGHT", Addon.fTextureEditor, "TOP", -96, top)
    Addon.fTextureEditor.cropLeftCaption:SetJustifyH("RIGHT")
    Addon.fTextureEditor.cropLeftCaption:SetSize(60, 20)
    Addon.fTextureEditor.cropLeftCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.cropLeftCaption:SetText(Addon.localization.LEFT)

    -- Right edit box
    Addon.fTextureEditor.cropRight = CreateFrame("EditBox", nil, Addon.fTextureEditor, "IPEditBox")
    Addon.fTextureEditor.cropRight:SetAutoFocus(false)
    Addon.fTextureEditor.cropRight:SetPoint("LEFT", Addon.fTextureEditor, "TOP", 30, top)
    Addon.fTextureEditor.cropRight:SetSize(60, 30)
    Addon.fTextureEditor.cropRight:SetNumeric(true)
    Addon.fTextureEditor.cropRight:SetMaxLetters(4)
    Addon.fTextureEditor.cropRight:SetScript('OnTextChanged', function(self)
        if self:HasFocus() then
            Addon:SetTextureSettings()
        end
    end)
    -- Right caption
    Addon.fTextureEditor.cropRightCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.cropRightCaption:SetPoint("LEFT", Addon.fTextureEditor, "TOP", 96, top)
    Addon.fTextureEditor.cropRightCaption:SetJustifyH("LEFT")
    Addon.fTextureEditor.cropRightCaption:SetSize(60, 20)
    Addon.fTextureEditor.cropRightCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.cropRightCaption:SetText(Addon.localization.RIGHT)

    -- Bottom edit box
    top = top - 34
    Addon.fTextureEditor.cropBottom = CreateFrame("EditBox", nil, Addon.fTextureEditor, "IPEditBox")
    Addon.fTextureEditor.cropBottom:SetAutoFocus(false)
    Addon.fTextureEditor.cropBottom:SetPoint("CENTER", Addon.fTextureEditor, "TOP", 0, top)
    Addon.fTextureEditor.cropBottom:SetSize(60, 30)
    Addon.fTextureEditor.cropBottom:SetNumeric(true)
    Addon.fTextureEditor.cropBottom:SetMaxLetters(4)
    Addon.fTextureEditor.cropBottom:SetScript('OnTextChanged', function(self)
        if self:HasFocus() then
            Addon:SetTextureSettings()
        end
    end)
    -- Bottom caption
    Addon.fTextureEditor.cropBottomCaption = Addon.fTextureEditor:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fTextureEditor.cropBottomCaption:SetPoint("TOP", Addon.fTextureEditor.cropBottom, "BOTTOM", 0, 0)
    Addon.fTextureEditor.cropBottomCaption:SetJustifyH("CENTER")
    Addon.fTextureEditor.cropBottomCaption:SetSize(60, 20)
    Addon.fTextureEditor.cropBottomCaption:SetTextColor(1, 1, 1)
    Addon.fTextureEditor.cropBottomCaption:SetText(Addon.localization.TOP)
    top = top - 50
end
