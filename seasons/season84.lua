local AddonName, Addon = ...

if Addon.season.number ~= 84 then return end

Addon.season.affix = 120
Addon.season.frameName = 'corruptions'
table.insert(Addon.frames, {
    label    = Addon.season.frameName,
    name     = Addon.localization.ELEMENT.OBELISKS,
    hasText  = true,
    hasIcons = true,
    colors = {
        [-1] = Addon.localization.COLORDESCR.OBELISKS[-1],
        [0]  = Addon.localization.COLORDESCR.OBELISKS[0],
    },
})

Addon.theme[1].elements[Addon.season.frameName] = {
    size = {
        w = 180,
        h = 40,
    },
    position = {
        x = 0,
        y = -4,
        point = 'TOPLEFT',
        rPoint = 'BOTTOMLEFT',
    },
    hidden = false,
    fontSize = 12,
    iconSize = 20,
    color = {
        [-1] = {r=0.9, g=0.9, b=0.9, a=1},
        [0]  = {r=0.9, g=0.9, b=0.9, a=.25},
    },
}

local corruptedNpc = {
    [161124] = 1, -- Urg'roth, Breaker of Heroes (Tank breaker)
    [161241] = 4, -- Voidweaver Mal'thir (Spider)
    [161243] = 3, -- Samh'rek, Beckoner of Chaos (Fear)
    [161244] = 2, -- Blood of the Corruptor (Blob)
}

local function SetCorruption(corruptionId, killed)
    local color = IPMTTheme[IPMTOptions.theme].elements[Addon.season.frameName].color[killed - 1]
    Addon.fMain.corruption[corruptionId].icon:SetVertexColor(color.r, color.g, color.b, color.a)
    Addon.fMain.corruption[corruptionId].text:SetTextColor(color.r, color.g, color.b)
    Addon.fMain.corruption[corruptionId].text:SetAlpha(color.a)
    if killed == 1 then
        Addon.fMain.corruption[corruptionId].text:Hide()
    else
        Addon.fMain.corruption[corruptionId].text:Show()
    end
end

-- Enemy forces for corrupted mobs (season 4)
-- Grabbed from MDT
function Addon.season:GetForces(npcID, isTeeming)
    if corruptedNpc[npcID] == nil then
        return nil
    end

    local mapID = C_Map.GetBestMapForUnit("player")
    local MDTMapID = Addon.MDTdungeon[mapID]
    if not isTeeming then
        if MDTMapID == 18 then -- SotS
            return 9
        elseif MDTMapID == 23 then -- Tol Dagor
            return 7
        else
            return 4
        end
    else
        if MDTMapID == 18 then -- SotS
            return 12
        elseif MDTMapID == 23 then -- Tol Dagor
            return 10
        else
            return 6
        end
    end
    return nil
end

function Addon.season:EnemyDied(npcID)
    if corruptedNpc[npcID] == nil then
        return nil
    end
    if IPMTDungeon.corrupted == nil then
        IPMTDungeon.corrupted = {}
    end
    IPMTDungeon.corrupted[npcID] = 1
    SetCorruption(npcID, 1)
    if IPMTDungeon.combat.boss then
        table.insert(IPMTDungeon.combat.killed, npcID)
    end
end

function Addon.season:BossWipe()
    for npcID in ipairs(IPMTDungeon.combat.killed) do
        IPMTDungeon.corrupted[npcID] = 0
        SetCorruption(npcID, 0)
    end
end

function Addon.season:ShowTimer()
    if not IPMTTheme[IPMTOptions.theme].elements[Addon.season.frameName].hidden and ( (IPMTDungeon.keyActive and Addon.season.isActive) or (not IPMTDungeon.keyActive and Addon.opened.options) ) then

        if IPMTDungeon.corrupted == nil or not IPMTDungeon.keyActive then
            IPMTDungeon.corrupted = {}
        end
        for corruptionId, flag in pairs(corruptedNpc) do
            local killed = 0
            if IPMTDungeon.corrupted[corruptionId] then
                killed = 1
            end
            local cost = ""
            if IPMTDungeon.keyActive and Addon.season.isActive then
                cost = Addon:GetEnemyForces(corruptionId)
            else
                if IPMTOptions.progress == Addon.PROGRESS_FORMAT_PERCENT then
                    cost = "1.25"
                else
                    cost = 12
                end
            end
            if cost and IPMTOptions.progress == Addon.PROGRESS_FORMAT_PERCENT then
                cost = cost .. "%"
            end
            SetCorruption(corruptionId, killed)
            Addon.fMain.corruption[corruptionId].text:SetText(cost)
        end
        Addon.fMain[Addon.season.frameName]:Show()
    else
        Addon.fMain[Addon.season.frameName]:Hide()
    end
end

local function OnCorruptionEnter(self, corruptionId)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetText(Addon.localization.CORRUPTED[corruptionId], 1, 1, 1, 1, true)
    GameTooltip:Show()
end

function Addon.season:RenderMain(theme)
    Addon.fMain.corruption = {}
    local f = 0
    local iconSize = theme.elements[Addon.season.frameName].iconSize
    local color = theme.elements[Addon.season.frameName].color[-1]
    for corruptionId, flag in pairs(corruptedNpc) do
        local left = 44 * f
        Addon.fMain.corruption[corruptionId] = CreateFrame("Frame", nil, Addon.fMain[Addon.season.frameName], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fMain.corruption[corruptionId]:SetSize(iconSize, iconSize)
        Addon.fMain.corruption[corruptionId]:SetPoint("CENTER", Addon.fMain[Addon.season.frameName], "TOPLEFT", left + 24, -12)
        Addon.fMain.corruption[corruptionId]:SetScript("OnEnter", function(self, event, ...)
            OnCorruptionEnter(self, corruptionId)
        end)
        Addon.fMain.corruption[corruptionId]:SetScript("OnLeave", function(self, event, ...)
            GameTooltip:Hide()
        end)

        Addon.fMain.corruption[corruptionId].icon = Addon.fMain.corruption[corruptionId]:CreateTexture()
        Addon.fMain.corruption[corruptionId].icon:SetAllPoints(Addon.fMain.corruption[corruptionId])
        Addon.fMain.corruption[corruptionId].icon:SetPoint("CENTER", Addon.fMain.corruption[corruptionId], "CENTER", 0, 0)
        Addon.fMain.corruption[corruptionId].icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\corruptions")
        local x1 = (corruptedNpc[corruptionId] - 1) * .25
        local x2 = x1 + .25
        Addon.fMain.corruption[corruptionId].icon:SetTexCoord(x1, x2, 0, 1)
        Addon.fMain.corruption[corruptionId].icon:SetVertexColor(color.r, color.g, color.b, color.a)

        Addon.fMain.corruption[corruptionId].text = Addon.fMain.corruption[corruptionId]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fMain.corruption[corruptionId].text:ClearAllPoints()
        Addon.fMain.corruption[corruptionId].text:SetPoint("CENTER", Addon.fMain.corruption[corruptionId], "CENTER", 0, -iconSize)
        Addon.fMain.corruption[corruptionId].text:SetJustifyH("CENTER")
        Addon.fMain.corruption[corruptionId].text:SetFont(theme.font, theme.elements[Addon.season.frameName].fontSize)
        Addon.fMain.corruption[corruptionId].text:SetTextColor(1, 1, 1)
        Addon.fMain.corruption[corruptionId].text:SetText("1.25%")
        f = f + 1
    end
end

function Addon.season:SetFont(fontFamily, fontSize)
    for corruptionId, flag in pairs(corruptedNpc) do
        Addon.fMain.corruption[corruptionId].text:SetFont(fontFamily, fontSize)
    end
end

function Addon.season:SetIconSize(iconSize)
    for corruptionId, flag in pairs(corruptedNpc) do
        Addon.fMain.corruption[corruptionId]:SetSize(iconSize, iconSize)
    end
end

function Addon.season:SetColor(color, i)
    for corruptionId, flag in pairs(corruptedNpc) do
        Addon.fMain.corruption[corruptionId].icon:SetVertexColor(color.r, color.g, color.b, color.a)
        Addon.fMain.corruption[corruptionId].text:SetTextColor(color.r, color.g, color.b)
        Addon.fMain.corruption[corruptionId].text:SetAlpha(color.a)
    end
end