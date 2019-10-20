local AddonName, Addon = ...

local frameWidth = 500
local rowWidth = frameWidth - 20
Addon.deathRowHeight = 24

-- Deaths Frame
Addon.fDeaths = CreateFrame("Frame", "IPMTDeaths", UIParent)
Addon.fDeaths:SetFrameStrata("MEDIUM")
Addon.fDeaths:SetSize(frameWidth, 400)
Addon.fDeaths:SetPoint("CENTER", UIParent)
Addon.fDeaths:SetBackdrop(Addon.backdrop)
Addon.fDeaths:SetBackdropColor(0,0,0, 1)
Addon.fDeaths:EnableMouse(true)
Addon.fDeaths:RegisterForDrag("LeftButton")
Addon.fDeaths:SetScript("OnDragStart", function(self, button)
    Addon:StartDragging(self, button)
end)
Addon.fDeaths:SetScript("OnDragStop", function(self, button)
    Addon:StopDragging(self, button)
    local point, _, _, x, y = self:GetPoint()
    IPMTOptions.position.deaths = {
        point = point,
        x     = math.floor(x),
        y     = math.floor(y),
    }
end)
Addon.fDeaths:SetMovable(true)
Addon.fDeaths:Hide()

-- Deaths caption
Addon.fDeaths.caption = Addon.fDeaths:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fDeaths.caption:SetPoint("CENTER", Addon.fDeaths, "TOP", 0, -20)
Addon.fDeaths.caption:SetJustifyH("CENTER")
Addon.fDeaths.caption:SetSize(rowWidth, 20)
Addon.fDeaths.caption:SetFont(Addon.FONT_ROBOTO, 20)
Addon.fDeaths.caption:SetTextColor(1, 1, 1)
Addon.fDeaths.caption:SetText(Addon.localization.DTHCAPTION)

-- Deaths table head
Addon.fDeaths.head = CreateFrame("Frame", nil, Addon.fDeaths)
Addon.fDeaths.head:SetSize(rowWidth, Addon.deathRowHeight)
Addon.fDeaths.head:SetPoint("TOP", Addon.fDeaths, "TOP", 0, -40)

Addon.fDeaths.head.name = Addon.fDeaths.head:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fDeaths.head.name:SetSize(160, Addon.deathRowHeight)
Addon.fDeaths.head.name:ClearAllPoints()
Addon.fDeaths.head.name:SetPoint("LEFT", 8, 0)
Addon.fDeaths.head.name:SetJustifyH("LEFT")
Addon.fDeaths.head.name:SetFont(Addon.FONT_ROBOTO, 16)
Addon.fDeaths.head.name:SetTextColor(1, 1, 1)
Addon.fDeaths.head.name:SetText(Addon.localization.WHODIED)

Addon.fDeaths.head.enemy = Addon.fDeaths.head:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fDeaths.head.enemy:SetSize(160, Addon.deathRowHeight)
Addon.fDeaths.head.enemy:ClearAllPoints()
Addon.fDeaths.head.enemy:SetPoint("LEFT", 190, 0)
Addon.fDeaths.head.enemy:SetJustifyH("LEFT")
Addon.fDeaths.head.enemy:SetFont(Addon.FONT_ROBOTO, 16)
Addon.fDeaths.head.enemy:SetTextColor(1, 1, 1)
Addon.fDeaths.head.enemy:SetText(Addon.localization.SOURCE)

Addon.fDeaths.head.damage = Addon.fDeaths.head:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fDeaths.head.damage:SetSize(60, Addon.deathRowHeight)
Addon.fDeaths.head.damage:ClearAllPoints()
Addon.fDeaths.head.damage:SetPoint("RIGHT", -68, 0)
Addon.fDeaths.head.damage:SetJustifyH("LEFT")
Addon.fDeaths.head.damage:SetFont(Addon.FONT_ROBOTO, 16)
Addon.fDeaths.head.damage:SetTextColor(1, 1, 1)
Addon.fDeaths.head.damage:SetText(Addon.localization.DAMAGE)

Addon.fDeaths.head.time = Addon.fDeaths.head:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fDeaths.head.time:SetSize(60, Addon.deathRowHeight)
Addon.fDeaths.head.time:ClearAllPoints()
Addon.fDeaths.head.time:SetPoint("RIGHT", -8, 0)
Addon.fDeaths.head.time:SetJustifyH("RIGHT")
Addon.fDeaths.head.time:SetFont(Addon.FONT_ROBOTO, 16)
Addon.fDeaths.head.time:SetTextColor(1, 1, 1)
Addon.fDeaths.head.time:SetText(Addon.localization.TIME)

-- Deaths list
Addon.fDeaths.list = CreateFrame("ScrollFrame", nil, Addon.fDeaths)
Addon.fDeaths.list:SetSize(rowWidth, 274)
Addon.fDeaths.list:SetPoint("TOP", Addon.fDeaths, "TOP", 0, -70)
Addon.fDeaths.list:EnableMouseWheel(true)
Addon.fDeaths.list:SetScript("OnMouseWheel", function(self, delta)
    local scrollY = self:GetVerticalScroll() - 14 * delta
    if scrollY < 0 then
        scrollY = 0
    else
        local maxScroll = self:GetVerticalScrollRange()
        if scrollY > maxScroll then
            scrollY = maxScroll
        end
    end
    self:SetVerticalScroll(scrollY)
end)

Addon.fDeaths.lines = CreateFrame("Frame", nil, Addon.fDeaths.list)
Addon.fDeaths.lines:SetSize(rowWidth, Addon.deathRowHeight)
Addon.fDeaths.list:SetScrollChild(Addon.fDeaths.lines)

-- Close button
Addon.fDeaths.close = CreateFrame("Button", nil, Addon.fDeaths, "UIPanelButtonTemplate")
Addon.fDeaths.close:SetPoint("CENTER", Addon.fDeaths, "BOTTOM", 0, 30)
Addon.fDeaths.close:SetSize(200, 30)
Addon.fDeaths.close:SetText(Addon.localization.CLOSE)
Addon.fDeaths.close:SetScript("OnClick", function(self)
    Addon:ToggleDeaths(false)
end)

Addon.fDeaths.line = {}
function Addon:FillDeathRow(num, deathInfo, summary)
    if Addon.fDeaths.line[num] then
        Addon.fDeaths.line[num]:Show()
    else
        Addon.fDeaths.line[num] = CreateFrame("Frame", nil, Addon.fDeaths.lines)
        Addon.fDeaths.line[num]:SetSize(rowWidth, Addon.deathRowHeight)
        Addon.fDeaths.line[num]:SetPoint("TOP", Addon.fDeaths.lines, "TOP", 0, -1 * (num * Addon.deathRowHeight - Addon.deathRowHeight))
        if (num % 2 ~= 0) then
            Addon.fDeaths.line[num]:SetBackdrop(Addon.backdrop)
            Addon.fDeaths.line[num]:SetBackdropColor(1,1,1, 0.15)
        end

        Addon.fDeaths.line[num].name = Addon.fDeaths.line[num]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fDeaths.line[num].name:SetSize(160, Addon.deathRowHeight)
        Addon.fDeaths.line[num].name:ClearAllPoints()
        Addon.fDeaths.line[num].name:SetPoint("LEFT", 8, 0)
        Addon.fDeaths.line[num].name:SetJustifyH("LEFT")
        Addon.fDeaths.line[num].name:SetFont(Addon.FONT_ROBOTO, 14)

        Addon.fDeaths.line[num].spell = CreateFrame("Frame", nil, Addon.fDeaths.line[num])
        Addon.fDeaths.line[num].spell:SetSize(18, 18)
        Addon.fDeaths.line[num].spell:ClearAllPoints()
        Addon.fDeaths.line[num].spell:SetPoint("LEFT", 168, 0)
        Addon.fDeaths.line[num].spell:SetScript("OnEnter", function(self, event, ...)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(Addon.DB.profile.dungeon.deathes.list[num].spell.name, 1, 1, 1)
            if Addon.DB.profile.dungeon.deathes.list[num].spell.description ~= nil then
                GameTooltip:AddLine(Addon.DB.profile.dungeon.deathes.list[num].spell.description)
            end
            GameTooltip:Show()
        end)
        Addon.fDeaths.line[num].spell:SetScript("OnLeave", function(self, event, ...)
            GameTooltip:Hide()
        end)
        Addon.fDeaths.line[num].spell.texture = Addon.fDeaths.line[num].spell:CreateTexture(nil, "BACKGROUND")
        Addon.fDeaths.line[num].spell.texture:SetAllPoints(Addon.fDeaths.line[num].spell)

        Addon.fDeaths.line[num].enemy = Addon.fDeaths.line[num]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fDeaths.line[num].enemy:SetSize(160, Addon.deathRowHeight)
        Addon.fDeaths.line[num].enemy:ClearAllPoints()
        Addon.fDeaths.line[num].enemy:SetPoint("LEFT", 190, 0)
        Addon.fDeaths.line[num].enemy:SetJustifyH("LEFT")
        Addon.fDeaths.line[num].enemy:SetFont(Addon.FONT_ROBOTO, 14)
        Addon.fDeaths.line[num].enemy:SetTextColor(1, 1, 1)

        Addon.fDeaths.line[num].damage = Addon.fDeaths.line[num]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fDeaths.line[num].damage:SetSize(60, Addon.deathRowHeight)
        Addon.fDeaths.line[num].damage:ClearAllPoints()
        Addon.fDeaths.line[num].damage:SetPoint("RIGHT", -68, 0)
        Addon.fDeaths.line[num].damage:SetJustifyH("LEFT")
        Addon.fDeaths.line[num].damage:SetFont(Addon.FONT_ROBOTO, 14)
        Addon.fDeaths.line[num].damage:SetTextColor(1, .2, .2)

        Addon.fDeaths.line[num].time = Addon.fDeaths.line[num]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fDeaths.line[num].time:SetSize(60, Addon.deathRowHeight)
        Addon.fDeaths.line[num].time:ClearAllPoints()
        Addon.fDeaths.line[num].time:SetPoint("RIGHT", -8, 0)
        Addon.fDeaths.line[num].time:SetJustifyH("RIGHT")
        Addon.fDeaths.line[num].time:SetFont(Addon.FONT_ROBOTO, 14)
        Addon.fDeaths.line[num].time:SetTextColor(1, 1, 1)
    end

    local _, playerClass = UnitClass(deathInfo.playerName)
    local color = RAID_CLASS_COLORS[playerClass] or HIGHLIGHT_FONT_COLOR
    Addon.fDeaths.line[num].name:SetTextColor(color.r, color.g, color.b)
    Addon.fDeaths.line[num].name:SetText(deathInfo.playerName .. " (" .. summary .. ")")
    Addon.fDeaths.line[num].time:SetText(SecondsToClock(deathInfo.time))
    Addon.fDeaths.line[num].damage:SetText(deathInfo.damage)
    Addon.fDeaths.line[num].spell.texture:SetTexture(deathInfo.spell.icon)
    Addon.fDeaths.line[num].enemy:SetText(deathInfo.enemy)
end
