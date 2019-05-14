local AddonName, Addon = ...

local affixSize = {
    width  = 20,
    height = 20,
}

-- Main Frame
Addon.fMain = CreateFrame("Frame", "IPMTMain")
Addon.fMain:SetSize(170, 80)
Addon.fMain:SetPoint("CENTER", UIParent)
Addon.fMain:SetBackdrop(Addon.backdrop)
Addon.fMain:SetBackdropColor(0,0,0, 1)
Addon.fMain:EnableMouse(true)
Addon.fMain:RegisterForDrag("LeftButton")
Addon.fMain:SetScript("OnDragStart", function(self, button)
    Addon:StartDragging(self, button)
end)
Addon.fMain:SetScript("OnDragStop", function(self, button)
    Addon:StopDragging(self, button)
end)
Addon.fMain:SetScript("OnUpdate",  function(self, elapsed)
    Addon:OnUpdate(elapsed)
end)
Addon.fMain:SetMovable(true)
Addon.fMain:SetScript("OnEvent", function(self, event, ...)
    Addon:OnEvent(self, event, ...)
end)
Addon.fMain:SetScript("OnShow", function() 
    Addon:OnShow()
end)
Addon.fMain:Hide()

-- Key Level
Addon.fMain.level = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.level:SetPoint("LEFT", Addon.fMain, "TOPLEFT", 6, -16)
Addon.fMain.level:SetJustifyH("LEFT")
Addon.fMain.level:SetSize(30, 20)
Addon.fMain.level:SetFont(Addon.FONT_ROBOTO, 20)
Addon.fMain.level:SetTextColor(1, 1, 1)
Addon.fMain.level:SetText("0")

-- Key Level+
Addon.fMain.plusLevel = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.plusLevel:SetPoint("LEFT", Addon.fMain, "TOPLEFT", 30, -16)
Addon.fMain.plusLevel:SetJustifyH("LEFT")
Addon.fMain.plusLevel:SetSize(30, 20)
Addon.fMain.plusLevel:SetFont(Addon.FONT_ROBOTO, 13)
Addon.fMain.plusLevel:SetTextColor(0.8, 0.8, 0.8)
Addon.fMain.plusLevel:SetText("0")

-- Timer
Addon.fMain.timer = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.timer:SetPoint("LEFT", Addon.fMain, "TOPLEFT", 6, -40)
Addon.fMain.timer:SetJustifyH("LEFT")
Addon.fMain.timer:SetSize(50, 18)
Addon.fMain.timer:SetFont(Addon.FONT_ROBOTO, 12)
Addon.fMain.timer:SetTextColor(1, 1, 1)
Addon.fMain.timer:SetText("00:00")
-- Timer+
Addon.fMain.plusTimer = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.plusTimer:SetPoint("LEFT", Addon.fMain, "TOPLEFT", 50, -40)
Addon.fMain.plusTimer:SetJustifyH("LEFT")
Addon.fMain.plusTimer:SetSize(50, 18)
Addon.fMain.plusTimer:SetFont(Addon.FONT_ROBOTO, 12)
Addon.fMain.plusTimer:SetTextColor(0.8, 0.8, 0.8)
Addon.fMain.plusTimer:SetText("00:00")
-- Death Timer
Addon.fMain.deathTimer = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.deathTimer:SetPoint("RIGHT", Addon.fMain, "TOPRIGHT", -4, -40)
Addon.fMain.deathTimer:SetJustifyH("RIGHT")
Addon.fMain.deathTimer:SetSize(60, 18)
Addon.fMain.deathTimer:SetFont(Addon.FONT_ROBOTO, 12)
Addon.fMain.deathTimer:SetTextColor(0.6, 0.2, 0.2)
Addon.fMain.deathTimer:SetText("00:00")
Addon.fMain.deathTimer:Hide()

-- Progress
Addon.fMain.progress = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.progress:SetPoint("LEFT", Addon.fMain, "TOPLEFT", 6, -66)
Addon.fMain.progress:SetJustifyH("LEFT")
Addon.fMain.progress:SetSize(90, 30)
Addon.fMain.progress:SetFont(Addon.FONT_ROBOTO, 22)
Addon.fMain.progress:SetTextColor(1, 1, 1)
Addon.fMain.progress:SetText("0%")
-- Prognosis
Addon.fMain.prognosis = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.prognosis:SetPoint("LEFT", Addon.fMain, "TOPLEFT", 80, -66)
Addon.fMain.prognosis:SetJustifyH("LEFT")
Addon.fMain.prognosis:SetSize(60, 20)
Addon.fMain.prognosis:SetFont(Addon.FONT_ROBOTO, 15)
Addon.fMain.prognosis:SetTextColor(1, 1, 1)
Addon.fMain.prognosis:SetText("0%")
Addon.fMain.prognosis:Hide()
-- Bosses
Addon.fMain.bosses = Addon.fMain:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
Addon.fMain.bosses:SetPoint("RIGHT", Addon.fMain, "TOPRIGHT", -4, -66)
Addon.fMain.bosses:SetJustifyH("RIGHT")
Addon.fMain.bosses:SetSize(50, 30)
Addon.fMain.bosses:SetFont(Addon.FONT_ROBOTO, 22)
Addon.fMain.bosses:SetTextColor(0.8, 0.8, 0.8)
Addon.fMain.bosses:SetText("0/0")
Addon.fMain.affix = {}
for f = 1,4 do
    local right = (-1) * (affixSize.width + 1) * (f-1)
    Addon.fMain.affix[f] = CreateFrame("Frame", nil, Addon.fMain, "ScenarioChallengeModeAffixTemplate")
    Addon.fMain.affix[f]:SetSize(affixSize.width, affixSize.height)
    Addon.fMain.affix[f].Portrait:SetSize(affixSize.width - 2, affixSize.height - 2)
    Addon.fMain.affix[f]:SetPoint("RIGHT", Addon.fMain, "TOPRIGHT", right - 4, -16)
    Addon.fMain.affix[f]:SetScript("OnEnter", function(self, event, ...)
        Addon:OnAffixEnter(self, f)
    end)
end
