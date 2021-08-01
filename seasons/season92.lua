local AddonName, Addon = ...

if Addon.season.number ~= 92 then return end

Addon.season.affix = 128
Addon.season.frameName = 'torments'
table.insert(Addon.frames, {
    label    = Addon.season.frameName,
    name     = Addon.localization.ELEMENT.TORMENT,
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
    iconSize = 20,
    color = {
        [-1] = {r=0.9, g=0.9, b=0.9, a=1},
        [0]  = {r=0.9, g=0.9, b=0.9, a=.25},
    },
}

local tormentedNpc = {
    [179890] = 1, -- Executioner Varruth (Fear)
    [179891] = 2, -- Soggodon the Breaker (Chain)
    [179892] = 3, -- Oros Coldheart (Cold)
    [179446] = 4, -- Incinerator Arkolath (Fire)
}

local function SetTormented(tormentId, killed)
    local color = IPMTTheme[IPMTOptions.theme].elements[Addon.season.frameName].color[killed - 1]
    Addon.fMain.torment[tormentId].icon:SetVertexColor(color.r, color.g, color.b, color.a)
end

-- Enemy forces for tormented mobs (season 92)
function Addon.season:GetForces(npcID, isTeeming)
    if tormentedNpc[npcID] ~= nil then
        return 0
    end
end

function Addon.season:EnemyDied(npcID)
    if tormentedNpc[npcID] == nil then
        return nil
    end
    if IPMTDungeon.tormented == nil then
        IPMTDungeon.tormented = {}
    end
    IPMTDungeon.tormented[npcID] = 1
    SetTormented(npcID, 1)
end

function Addon.season:ShowTimer()
    if not IPMTTheme[IPMTOptions.theme].elements[Addon.season.frameName].hidden and ( (IPMTDungeon.keyActive and Addon.season.isActive) or (not IPMTDungeon.keyActive and Addon.opened.options) ) then

        if IPMTDungeon.tormented == nil or not IPMTDungeon.keyActive then
            IPMTDungeon.tormented = {}
        end
        for tormentId, flag in pairs(tormentedNpc) do
            local killed = 0
            if IPMTDungeon.tormented[tormentId] then
                killed = 1
            end
            SetTormented(tormentId, killed)
        end
        Addon.fMain[Addon.season.frameName]:Show()
    else
        Addon.fMain[Addon.season.frameName]:Hide()
    end
end

local function OnTormentEnter(self, tormentId)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetText(Addon.localization.TORMENTED[tormentId], 1, 1, 1, 1, true)
    GameTooltip:Show()
end

function Addon.season:RenderMain(theme)
    Addon.fMain.torment = {}
    local f = 0
    local iconSize = theme.elements[Addon.season.frameName].iconSize
    local color = theme.elements[Addon.season.frameName].color[-1]
    for tormentId, flag in pairs(tormentedNpc) do
        local left = 44 * f
        Addon.fMain.torment[tormentId] = CreateFrame("Frame", nil, Addon.fMain[Addon.season.frameName], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fMain.torment[tormentId]:SetSize(iconSize, iconSize)
        Addon.fMain.torment[tormentId]:SetPoint("CENTER", Addon.fMain[Addon.season.frameName], "TOPLEFT", left + 24, -12)
        Addon.fMain.torment[tormentId]:SetScript("OnEnter", function(self, event, ...)
            OnTormentEnter(self, tormentId)
        end)
        Addon.fMain.torment[tormentId]:SetScript("OnLeave", function(self, event, ...)
            GameTooltip:Hide()
        end)

        Addon.fMain.torment[tormentId].icon = Addon.fMain.torment[tormentId]:CreateTexture()
        Addon.fMain.torment[tormentId].icon:SetAllPoints(Addon.fMain.torment[tormentId])
        Addon.fMain.torment[tormentId].icon:SetPoint("CENTER", Addon.fMain.torment[tormentId], "CENTER", 0, 0)
        Addon.fMain.torment[tormentId].icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\torments")
        local x1 = (tormentedNpc[tormentId] - 1) * .25
        local x2 = x1 + .25
        Addon.fMain.torment[tormentId].icon:SetTexCoord(x1, x2, 0, 1)
        Addon.fMain.torment[tormentId].icon:SetVertexColor(color.r, color.g, color.b, color.a)
        f = f + 1
    end
end

function Addon.season:SetIconSize(iconSize)
    for tormentId, flag in pairs(tormentedNpc) do
        Addon.fMain.torment[tormentId]:SetSize(iconSize, iconSize)
    end
end

function Addon.season:SetColor(color, i)
    for tormentId, flag in pairs(tormentedNpc) do
        Addon.fMain.torment[tormentId].icon:SetVertexColor(color.r, color.g, color.b, color.a)
    end
end