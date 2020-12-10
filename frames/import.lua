local AddonName, Addon = ...

function Addon:RenderImport()
    local width = 600
    local heigth = 600
    -- Debug Frame
    Addon.fImport = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fImport:SetFrameStrata("HIGH")
    Addon.fImport:SetSize(width, heigth)
    Addon.fImport:SetPoint("CENTER", UIParent)
    Addon.fImport:SetBackdrop(Addon.backdrop)
    Addon.fImport:SetBackdropColor(0,0,0, 1)
    Addon.fImport:EnableMouse(true)
    Addon.fImport:SetMovable(true)
    Addon.fImport:RegisterForDrag("LeftButton", "RightButton")
    Addon.fImport:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fImport:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
    end)
    Addon.fImport:Hide()

    -- Options caption
    Addon.fImport.caption = Addon.fImport:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fImport.caption:SetPoint("CENTER", Addon.fImport, "TOP", 0, -24)
    Addon.fImport.caption:SetJustifyH("CENTER")
    Addon.fImport.caption:SetSize(250, 20)
    Addon.fImport.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fImport.caption:SetTextColor(1, 1, 1)
    Addon.fImport.caption:SetText('')


    Addon.fImport.content = CreateFrame("ScrollFrame", nil, Addon.fImport, "IPScrollBox")
    Addon.fImport.content:ClearAllPoints()
    Addon.fImport.content:SetPoint("TOPLEFT", Addon.fImport, "TOPLEFT", 10, -50)
    Addon.fImport.content:SetPoint("BOTTOMRIGHT", Addon.fImport, "BOTTOMRIGHT", -10, 50)

    -- Text area
    Addon.fImport.textarea = CreateFrame("EditBox", nil, Addon.fImport.content)
    Addon.fImport.textarea:ClearAllPoints()
    Addon.fImport.textarea:SetMultiLine(true)
    Addon.fImport.textarea:SetAutoFocus(true)
    Addon.fImport.textarea:SetTextInsets(10, 6, 10, 10)
    Addon.fImport.textarea:SetPoint("TOPLEFT", Addon.fImport.content, "TOPLEFT", 8, -40)
    Addon.fImport.textarea:SetSize(width - 40, heigth - 4)
    Addon.fImport.textarea:SetFontObject("ChatFontNormal")
    Addon.fImport.content:SetScrollChild(Addon.fImport.textarea)

    -- X-Close button
    Addon.fImport.closeX = CreateFrame("Button", nil, Addon.fImport, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fImport.closeX:SetPoint("TOP", Addon.fImport, "TOPRIGHT", -20, -5)
    Addon.fImport.closeX:SetSize(26, 26)
    Addon.fImport.closeX:SetBackdrop(Addon.backdrop)
    Addon.fImport.closeX:SetBackdropColor(0,0,0, 1)
    Addon.fImport.closeX:SetScript("OnClick", function(self)
        Addon.fImport:Hide()
    end)
    Addon.fImport.closeX:SetScript("OnEnter", function(self, event, ...)
        Addon.fImport.closeX:SetBackdropColor(.1,.1,.1, 1)
    end)
    Addon.fImport.closeX:SetScript("OnLeave", function(self, event, ...)
        Addon.fImport.closeX:SetBackdropColor(0,0,0, 1)
    end)
    Addon.fImport.closeX.icon = Addon.fImport.closeX:CreateTexture()
    Addon.fImport.closeX.icon:SetSize(16, 16)
    Addon.fImport.closeX.icon:ClearAllPoints()
    Addon.fImport.closeX.icon:SetPoint("CENTER", Addon.fImport.closeX, "CENTER", 0, 0)
    Addon.fImport.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\x-close")

    -- Apply
    Addon.fImport.apply = CreateFrame("Button", nil, Addon.fImport, "IPButton")
    Addon.fImport.apply:SetPoint("RIGHT", Addon.fImport, "BOTTOM", -10, 24)
    Addon.fImport.apply:SetSize(160, 30)
    Addon.fImport.apply:SetText(Addon.localization.IMPORT)
    Addon.fImport.apply:SetScript("OnClick", function(self)
        Addon:ImportTheme(Addon.fImport.textarea:GetText())
    end)
    -- Cancel
    Addon.fImport.cancel = CreateFrame("Button", nil, Addon.fImport, "IPButton")
    Addon.fImport.cancel:SetPoint("LEFT", Addon.fImport, "BOTTOM", 10, 24)
    Addon.fImport.cancel:SetSize(160, 30)
    Addon.fImport.cancel:SetText(Addon.localization.CLOSE)
    Addon.fImport.cancel:SetScript("OnClick", function(self)
        Addon:CloseImport()
    end)
end