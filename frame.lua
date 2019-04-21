local maxWidth = 150
local noticeWidth = 220

local FONT_ROBOTO = "Interface\\AddOns\\ipmythictimer\\RobotoCondensed-Light.ttf"
local backdrop = {
    bgFile   = "Interface\\TutorialFrame\\TutorialFrameBackground",
    edgeFile = nil,--"Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true,
    tileSize = 32,
}
local affixSize = {
    width  = 20,
    height = 20,
}

local function StartDragging(self, button)
    self:StartMoving()
    self.isMoving = true
end

local function StopDragging(self, button)
    self:StopMovingOrSizing()
    self.isMoving = false
end


-- Main Frame
fIPMT = CreateFrame("Frame", "IPKTMain", UIParent)
fIPMT:SetSize(170, 80)
fIPMT:SetPoint("CENTER", 0, 0)
fIPMT:SetBackdrop(backdrop)
fIPMT:EnableMouse(true)
fIPMT:RegisterForDrag("LeftButton")
fIPMT:SetScript("OnDragStart", StartDragging)
fIPMT:SetScript("OnDragStop", StopDragging)
fIPMT:SetScript("OnUpdate",  function(self, elapsed)
    IPMythicTimer:OnUpdate(elapsed)
end)
fIPMT:SetMovable(true)
fIPMT:SetScript("OnEvent", function(self, event, ...)
    IPMythicTimer:OnEvent(self, event, ...)
end)
fIPMT:Hide()

-- Key Level
fIPMT.level = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.level:SetPoint("LEFT", fIPMT, "TOPLEFT", 6, -16)
fIPMT.level:SetJustifyH("LEFT")
fIPMT.level:SetSize(30, 20)
fIPMT.level:SetFont(FONT_ROBOTO, 20)
fIPMT.level:SetTextColor(1, 1, 1)
fIPMT.level:SetText("0")

-- Key Level+
fIPMT.plusLevel = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.plusLevel:SetPoint("LEFT", fIPMT, "TOPLEFT", 30, -16)
fIPMT.plusLevel:SetJustifyH("LEFT")
fIPMT.plusLevel:SetSize(30, 20)
fIPMT.plusLevel:SetFont(FONT_ROBOTO, 13)
fIPMT.plusLevel:SetTextColor(0.8, 0.8, 0.8)
fIPMT.plusLevel:SetText("0")

-- Timer
fIPMT.timer = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.timer:SetPoint("LEFT", fIPMT, "TOPLEFT", 6, -40)
fIPMT.timer:SetJustifyH("LEFT")
fIPMT.timer:SetSize(50, 18)
fIPMT.timer:SetFont(FONT_ROBOTO, 12)
fIPMT.timer:SetTextColor(1, 1, 1)
fIPMT.timer:SetText("00:00")
-- Timer+
fIPMT.plusTimer = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.plusTimer:SetPoint("LEFT", fIPMT, "TOPLEFT", 50, -40)
fIPMT.plusTimer:SetJustifyH("LEFT")
fIPMT.plusTimer:SetSize(50, 18)
fIPMT.plusTimer:SetFont(FONT_ROBOTO, 12)
fIPMT.plusTimer:SetTextColor(0.8, 0.8, 0.8)
fIPMT.plusTimer:SetText("00:00")
-- Death Timer
fIPMT.deathTimer = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.deathTimer:SetPoint("RIGHT", fIPMT, "TOPRIGHT", -4, -40)
fIPMT.deathTimer:SetJustifyH("RIGHT")
fIPMT.deathTimer:SetSize(60, 18)
fIPMT.deathTimer:SetFont(FONT_ROBOTO, 12)
fIPMT.deathTimer:SetTextColor(0.6, 0.2, 0.2)
fIPMT.deathTimer:SetText("00:00")
fIPMT.deathTimer:Hide()

-- Progress
fIPMT.progress = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.progress:SetPoint("LEFT", fIPMT, "TOPLEFT", 6, -66)
fIPMT.progress:SetJustifyH("LEFT")
fIPMT.progress:SetSize(90, 30)
fIPMT.progress:SetFont(FONT_ROBOTO, 22)
fIPMT.progress:SetTextColor(1, 1, 1)
fIPMT.progress:SetText("0%")
-- Prognosis
fIPMT.prognosis = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.prognosis:SetPoint("LEFT", fIPMT, "TOPLEFT", 80, -66)
fIPMT.prognosis:SetJustifyH("LEFT")
fIPMT.prognosis:SetSize(60, 20)
fIPMT.prognosis:SetFont(FONT_ROBOTO, 15)
fIPMT.prognosis:SetTextColor(1, 1, 1)
fIPMT.prognosis:SetText("0%")
fIPMT.prognosis:Hide()
-- Bosses
fIPMT.bosses = fIPMT:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
fIPMT.bosses:SetPoint("RIGHT", fIPMT, "TOPRIGHT", -4, -66)
fIPMT.bosses:SetJustifyH("RIGHT")
fIPMT.bosses:SetSize(50, 30)
fIPMT.bosses:SetFont(FONT_ROBOTO, 22)
fIPMT.bosses:SetTextColor(0.8, 0.8, 0.8)
fIPMT.bosses:SetText("0/0")

fIPMT.affix = {}
for f = 1,4 do
    local right = (-1) * (affixSize.width + 1) * (f-1)
    fIPMT.affix[f] = CreateFrame("Frame", nil, fIPMT, "ScenarioChallengeModeAffixTemplate")
    fIPMT.affix[f]:SetSize(affixSize.width, affixSize.height)
    fIPMT.affix[f].Portrait:SetSize(affixSize.width - 2, affixSize.height - 2)
    fIPMT.affix[f]:SetPoint("RIGHT", fIPMT, "TOPRIGHT", right - 4, -16)
end
