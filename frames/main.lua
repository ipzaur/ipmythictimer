local AddonName, Addon = ...

Addon.fMain = CreateFrame("Frame", "IPMTMain", UIParent, BackdropTemplateMixin and "BackdropTemplate")
Addon.fMain:SetScript("OnEvent", function(self, event, ...)
    Addon:OnEvent(self, event, ...)
end)

function Addon:RenderMain()
    local affixSize = {
        
    }

    local theme = IPMTTheme[IPMTOptions.theme]

    -- Main Frame
    local borderTexture = nil
    if theme.main.border.texture ~= 'none' then
        borderTexture = theme.main.border.texture
    end
    local backdrop = {
        bgFile   = theme.main.background.texture,
        edgeFile = borderTexture,
        tile     = false,
        edgeSize = theme.main.border.size,
        insets   = {
            left   = theme.main.border.inset,
            right  = theme.main.border.inset,
            top    = theme.main.border.inset,
            bottom = theme.main.border.inset,
        },
    }
    Addon.fMain:ClearAllPoints()
    Addon.fMain:SetPoint(IPMTOptions.position.main.point, IPMTOptions.position.main.x, IPMTOptions.position.main.y)
    Addon.fMain:SetFrameStrata("MEDIUM")
    Addon.fMain:SetScale(1 + IPMTOptions.scale / 100)
    Addon.fMain:SetSize(theme.main.size.w, theme.main.size.h)
    Addon.fMain:SetBackdrop(backdrop)
    Addon.fMain:SetBackdropColor(theme.main.background.color.r, theme.main.background.color.g, theme.main.background.color.b, theme.main.background.color.a)
    Addon.fMain:SetBackdropBorderColor(theme.main.border.color.r, theme.main.border.color.g, theme.main.border.color.b, theme.main.border.color.a)
    Addon.fMain:EnableMouse(false)
    Addon.fMain:SetMovable(false)
    Addon.fMain:SetResizable(false)
    Addon.fMain:RegisterForDrag("LeftButton")
    Addon.fMain:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fMain:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
        local point, _, _, x, y = self:GetPoint()
        IPMTOptions.position.main = {
            point = point,
            x     = math.floor(x),
            y     = math.floor(y),
        }
        theme.main.size = {
            w = Addon.fMain:GetWidth(),
            h = Addon.fMain:GetHeight(),
        }
    end)
    Addon.fMain:SetScript("OnUpdate",  function(self, elapsed)
        Addon:OnUpdate(elapsed)
    end)
    Addon.fMain:SetScript("OnShow", function() 
        Addon:OnShow()
    end)
    Addon.fMain:Hide()

    for i, info in ipairs(Addon.frames) do
        Addon:RenderElement(info)
    end
    Addon.fMain.decors = {}
    if #IPMTTheme[IPMTOptions.theme].decors then
        for decorID, info in ipairs(IPMTTheme[IPMTOptions.theme].decors) do
            Addon:RenderDecor(decorID)
        end
    end

    if Addon.season.RenderMain then
        Addon.season:RenderMain(theme)
    end
end


function Addon:RenderElement(info)
    local theme = IPMTTheme[IPMTOptions.theme]
    local frame = info.label
    local elemInfo = theme.elements[frame]
    local point = elemInfo.position.point
    if point == nil then
        point = 'LEFT'
    end
    local rPoint = elemInfo.position.rPoint
    if rPoint == nil then
        rPoint = 'TOPLEFT'
    end

    Addon.fMain[frame] = CreateFrame("Frame", nil, Addon.fMain, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fMain[frame]:SetSize(elemInfo.size.w, elemInfo.size.h)
    Addon.fMain[frame]:ClearAllPoints()
    Addon.fMain[frame]:SetPoint(point, Addon.fMain, rPoint, elemInfo.position.x, elemInfo.position.y)
    Addon.fMain[frame]:SetBackdrop(Addon.backdrop)
    Addon.fMain[frame]:SetBackdropColor(1,1,1, 0)
    if info.hasText then
        local justify = elemInfo.justifyH
        if (justify == nil) then
            justify = 'LEFT'
        end
        local color = elemInfo.color
        if (color == nil) then
            color = {
                [0] = 1,
                [1] = 1,
                [2] = 1,
            }
        end
        Addon.fMain[frame].text = Addon.fMain[frame]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fMain[frame].text:ClearAllPoints()
        Addon.fMain[frame].text:SetPoint(justify, 0, 0)
        Addon.fMain[frame].text:SetJustifyH(justify)
        if elemInfo.justifyV then
            Addon.fMain[frame].text:SetJustifyV(elemInfo.justifyV)
        end
        if frame == "dungeonname" then
            Addon.fMain[frame].text:SetAllPoints(Addon.fMain[frame])
        end
        Addon.fMain[frame].text:SetFont(theme.font, elemInfo.fontSize)
        Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
        Addon.fMain[frame].text:SetText("")
    end

    Addon.fMain[frame].isMovable = false
    Addon.fMain[frame]:EnableMouse(false)
    Addon.fMain[frame]:SetMovable(false)
    Addon.fMain[frame]:RegisterForDrag("LeftButton")
    Addon.fMain[frame]:SetScript("OnDragStart", function(self, button)
        if self.isMovable then
            GameTooltip:Hide()
            Addon:StartDragging(self, button)
        end
    end)
    Addon.fMain[frame]:SetScript("OnDragStop", function(self, button)
        if self.isMovable then
            Addon:StopDragging(self, button)
            Addon:SmartMoveElement(self, frame)
        end
    end)
    Addon.fMain[frame]:SetScript("OnMouseUp", function(self, button)
        if self.isMovable and button == 'RightButton' then
            Addon:ToggleElemEditor(frame)
        elseif frame == 'deathTimer' and button == 'LeftButton' then
            Addon.deaths:Toggle()
        end
    end)
    Addon.fMain[frame]:SetScript("OnEnter", function(self, event, ...)
        if self.isMovable then
            if not self.isMoving then
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:SetText(Addon.localization.PRECISEPOS, .9, .9, 0, 1, true)
                GameTooltip:Show()
            end
        else
            if frame == 'deathTimer' then
                Addon.deaths:ShowTooltip(self)
            elseif frame == 'bosses' then
                Addon:OnBossesEnter(self)
            elseif frame == 'timer' then
                Addon:OnTimerEnter(self)
            end
        end
    end)
    Addon.fMain[frame]:SetScript("OnLeave", function(self, event, ...)
        GameTooltip:Hide()
    end)
    if frame == 'affixes' then
        Addon.fMain.affix = {}
        for f = 1,4 do
            Addon.fMain.affix[f] = CreateFrame("Frame", nil, Addon.fMain.affixes, "ScenarioChallengeModeAffixTemplate")
            Addon.fMain.affix[f]:SetScript("OnEnter", function(self, event, ...)
                Addon:OnAffixEnter(self, f)
            end)
            Addon.fMain.affix[f]:SetScript("OnLeave", function(self, event, ...)
                GameTooltip:Hide()
            end)
        end
        Addon:SetIconSize(frame, elemInfo.iconSize)
    end
    if elemInfo.hidden then
        Addon.fMain[frame]:Hide()
    end
end


function Addon:RenderDecor(decorID)
    if Addon.fMain.decors[decorID] == nil then
        Addon.fMain.decors[decorID] = CreateFrame("Frame", nil, Addon.fMain, BackdropTemplateMixin and "BackdropTemplate")
        Addon.fMain.decors[decorID].isMovable = false
        Addon.fMain.decors[decorID]:EnableMouse(false)
        Addon.fMain.decors[decorID]:SetMovable(false)
        Addon.fMain.decors[decorID]:RegisterForDrag("LeftButton")
        Addon.fMain.decors[decorID]:SetScript("OnDragStart", function(self, button)
            if self.isMovable then
                GameTooltip:Hide()
                Addon:StartDragging(self, button)
            end
        end)
        Addon.fMain.decors[decorID]:SetScript("OnDragStop", function(self, button)
            if self.isMovable then
                Addon:StopDragging(self, button)
                Addon:SmartMoveElement(self, decorID)
            end
        end)
        Addon.fMain.decors[decorID]:SetScript("OnMouseUp", function(self, button)
            if self.isMovable and button == 'RightButton' then
                Addon:ToggleElemEditor(decorID)
            end
        end)
        Addon.fMain.decors[decorID]:SetScript("OnEnter", function(self, event, ...)
            if self.isMovable then
                if not self.isMoving then
                    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                    GameTooltip:SetText(Addon.localization.PRECISEPOS, .9, .9, 0, 1, true)
                    GameTooltip:Show()
                end
            end
        end)
        Addon.fMain.decors[decorID]:SetScript("OnLeave", function(self, event, ...)
            GameTooltip:Hide()
        end)
    end

    local decorInfo = IPMTTheme[IPMTOptions.theme].decors[decorID]
    local point = decorInfo.position.point
    if point == nil then
        point = 'LEFT'
    end
    local rPoint = decorInfo.position.rPoint
    if rPoint == nil then
        rPoint = 'TOPLEFT'
    end

    local borderTexture = nil
    if decorInfo.border.texture ~= 'none' then
        borderTexture = decorInfo.border.texture
    end
    local backdrop = {
        bgFile   = decorInfo.background.texture,
        edgeFile = borderTexture,
        tile     = false,
        edgeSize = decorInfo.border.size,
        insets   = {
            left   = decorInfo.border.inset,
            right  = decorInfo.border.inset,
            top    = decorInfo.border.inset,
            bottom = decorInfo.border.inset,
        },
    }
    Addon.fMain.decors[decorID]:SetSize(decorInfo.size.w, decorInfo.size.h)
    Addon.fMain.decors[decorID]:ClearAllPoints()
    Addon.fMain.decors[decorID]:SetPoint(point, Addon.fMain, rPoint, decorInfo.position.x, decorInfo.position.y)
    Addon.fMain.decors[decorID]:SetBackdrop(backdrop)
    Addon.fMain.decors[decorID]:SetBackdropColor(decorInfo.background.color.r, decorInfo.background.color.g, decorInfo.background.color.b, decorInfo.background.color.a)
    Addon.fMain.decors[decorID]:SetBackdropBorderColor(decorInfo.border.color.r, decorInfo.border.color.g, decorInfo.border.color.b, decorInfo.border.color.a)
    Addon.fMain.decors[decorID]:SetFrameLevel(decorInfo.layer)

    if decorInfo.hidden then
        Addon.fMain.decors[decorID]:Hide()
    else
        Addon.fMain.decors[decorID]:Show()
    end
end