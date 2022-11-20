local AddonName, Addon = ...

Addon.fMain = CreateFrame("Frame", "IPMTMain", UIParent, BackdropTemplateMixin and "BackdropTemplate")
Addon.fMain:SetScript("OnEvent", function(self, event, ...)
    Addon:OnEvent(self, event, ...)
end)

function Addon:RenderMain()
    local theme = IPMTTheme[IPMTOptions.theme]

    -- Main Frame
    local borderTexture = nil
    if theme.main.border.texture ~= 'none' then
        borderTexture = theme.main.border.texture
    end
    local backdrop = {
        bgFile   = nil,
        edgeFile = borderTexture,
        tile     = false,
        edgeSize = theme.main.border.size,
    }
    Addon.fMain:ClearAllPoints()
    Addon.fMain:SetPoint(IPMTOptions.position.main.point, IPMTOptions.position.main.x, IPMTOptions.position.main.y)
    Addon.fMain:SetFrameStrata("MEDIUM")
    Addon.fMain:SetScale(1 + IPMTOptions.scale / 100)
    Addon.fMain:SetSize(theme.main.size.w, theme.main.size.h)
    Addon.fMain:SetBackdrop(backdrop)
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

    Addon.fMain.background = Addon.fMain:CreateTexture(nil, "BACKGROUND")
    Addon.fMain.background:SetAllPoints(Addon.fMain)
    Addon:ChangeDecor('main', theme.main, true)
    for i, info in ipairs(Addon.frames) do
        Addon:RenderElement(info)
    end
    Addon.fMain.decors = {}
    if #theme.decors then
        for decorID, info in ipairs(theme.decors) do
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
    if info.canResize then
        Addon.fMain[frame]:SetSize(elemInfo.size.w, elemInfo.size.h)
    end
    if info.hasText then
        local justifyH = elemInfo.justifyH
        if justifyH == nil then
            justifyH = 'LEFT'
        end
        Addon.fMain[frame].text = Addon.fMain[frame]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fMain[frame].text:SetAllPoints(Addon.fMain[frame])
        Addon.fMain[frame].text:SetJustifyH(elemInfo.justifyH)
        if info.canAlignV then
            local justifyV = elemInfo.justifyV
            if justifyV == nil then
                justifyV = 'BOTTOM'
            end
            Addon.fMain[frame].text:SetJustifyV(elemInfo.justifyV)
        end
        Addon.fMain[frame].text:SetFont(theme.font, elemInfo.fontSize)
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
        Addon.fMain.decors[decorID].background = Addon.fMain.decors[decorID]:CreateTexture(nil, "BACKGROUND")
        Addon.fMain.decors[decorID].background:SetAllPoints(Addon.fMain.decors[decorID])
    end

    local decorInfo = IPMTTheme[IPMTOptions.theme].decors[decorID]
    if decorInfo.hidden then
        Addon.fMain.decors[decorID]:Hide()
    else
        local point = decorInfo.position.point
        if point == nil then
            point = 'LEFT'
        end
        local rPoint = decorInfo.position.rPoint
        if rPoint == nil then
            rPoint = 'TOPLEFT'
        end
        Addon.fMain.decors[decorID]:ClearAllPoints()
        Addon.fMain.decors[decorID]:SetPoint(point, Addon.fMain, rPoint, decorInfo.position.x, decorInfo.position.y)
        Addon.fMain.decors[decorID]:SetFrameLevel(decorInfo.layer)
        Addon:ChangeDecor(decorID, decorInfo, true)
        Addon.fMain.decors[decorID]:Show()
    end
end