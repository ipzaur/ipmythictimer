local AddonName, Addon = ...

function Addon:RenderNews()
    local width = 600
    local heigth = 410

    -- News Frame
    Addon.fNews = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fNews:SetFrameStrata("HIGH")
    Addon.fNews:SetSize(width, heigth)
    Addon.fNews:SetPoint("CENTER", UIParent)
    Addon.fNews:SetBackdrop(Addon.backdrop)
    Addon.fNews:SetBackdropColor(0,0,0, 1)
    Addon.fNews:EnableMouse(true)
    Addon.fNews:SetMovable(true)
    Addon.fNews:RegisterForDrag("LeftButton", "RightButton")
    Addon.fNews:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fNews:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
    end)

    -- News caption
    Addon.fNews.caption = Addon.fNews:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fNews.caption:SetPoint("CENTER", Addon.fNews, "TOP", 0, -24)
    Addon.fNews.caption:SetJustifyH("CENTER")
    Addon.fNews.caption:SetSize(500, 20)
    Addon.fNews.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fNews.caption:SetTextColor(1, 1, 1)
    Addon.fNews.caption:SetText('iP Mythic Timer: ' .. Addon.localization.WHATSNEW)

    -- News picture
    Addon.fNews.picture = Addon.fNews:CreateTexture()
    Addon.fNews.picture:SetSize(400, 300)
    Addon.fNews.picture:ClearAllPoints()
    Addon.fNews.picture:SetPoint("TOPRIGHT", Addon.fNews, "TOPRIGHT", -10, -50)
    Addon.fNews.picture:SetDrawLayer("BACKGROUND", 1)

    -- News title
    Addon.fNews.title = Addon.fNews:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fNews.title:SetPoint("TOPLEFT", Addon.fNews, "TOPLEFT", 20, -50)
    Addon.fNews.title:SetJustifyH("LEFT")
    Addon.fNews.title:SetJustifyV("TOP")
    Addon.fNews.title:SetSize(500, 30)
    Addon.fNews.title:SetFont(Addon.DECOR_FONT, 18)
    Addon.fNews.title:SetTextColor(1, 1, 1)

    -- News text
    Addon.fNews.text = Addon.fNews:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fNews.text:SetPoint("TOPLEFT", Addon.fNews, "TOPLEFT", 20, -90)
    Addon.fNews.text:SetJustifyH("LEFT")
    Addon.fNews.text:SetJustifyV("TOP")
    Addon.fNews.text:SetSize(250, 300)
    Addon.fNews.text:SetFont(Addon.DECOR_FONT, 16)
    Addon.fNews.text:SetTextColor(1, 1, 1)

    -- X-Close button
    Addon.fNews.closeX = CreateFrame("Button", nil, Addon.fNews, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fNews.closeX:SetPoint("TOP", Addon.fNews, "TOPRIGHT", -20, -5)
    Addon.fNews.closeX:SetSize(26, 26)
    Addon.fNews.closeX:SetBackdrop(Addon.backdrop)
    Addon.fNews.closeX:SetBackdropColor(0,0,0, 1)
    Addon.fNews.closeX:SetScript("OnClick", function(self)
        Addon:CloseNews()
    end)
    Addon.fNews.closeX:SetScript("OnEnter", function(self, event, ...)
        Addon.fNews.closeX:SetBackdropColor(.1,.1,.1, 1)
    end)
    Addon.fNews.closeX:SetScript("OnLeave", function(self, event, ...)
        Addon.fNews.closeX:SetBackdropColor(0,0,0, 1)
    end)
    Addon.fNews.closeX.icon = Addon.fNews.closeX:CreateTexture()
    Addon.fNews.closeX.icon:SetSize(16, 16)
    Addon.fNews.closeX.icon:ClearAllPoints()
    Addon.fNews.closeX.icon:SetPoint("CENTER", Addon.fNews.closeX, "CENTER", 0, 0)
    Addon.fNews.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\x-close")

    -- OK button
    Addon.fNews.apply = CreateFrame("Button", nil, Addon.fNews, "IPButton")
    Addon.fNews.apply:SetPoint("BOTTOM", Addon.fNews, "BOTTOM", 0, 16)
    Addon.fNews.apply:SetSize(160, 30)
    Addon.fNews.apply:SetText(Addon.localization.OK)
    Addon.fNews.apply:SetScript("OnClick", function(self)
        Addon:CloseNews()
    end)
end
