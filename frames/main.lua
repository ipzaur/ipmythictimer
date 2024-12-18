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

function Addon:RenderTimerbar(elemInfo)
    local theme = IPMTTheme[IPMTOptions.theme]
    if elemInfo == nil then
        elemInfo = theme.elements.timerbar
    else
        Addon.fMain.timerbar:SetSize(elemInfo.size.w, elemInfo.size.h)
        Addon.fMain.timerbar:ClearAllPoints()
        Addon.fMain.timerbar:SetPoint(elemInfo.position.point, Addon.fMain, elemInfo.position.rPoint, elemInfo.position.x, elemInfo.position.y)
    end
    local bgColor = elemInfo.background.color
    Addon.fMain.timerbar:SetBackdropColor(bgColor.r,bgColor.g,bgColor.b, bgColor.a)
    local fSection = Addon.fMain.timerbar.section

    local padding = elemInfo.padding
    local size
    if elemInfo.type == 'H' then
        size = elemInfo.size.w - 2*padding
    else
        size = elemInfo.size.h - 2*padding
    end
    fSection[1].size = math.ceil(size*0.2)
    if IPMTOptions.timerDir == Addon.TIMER_DIRECTION_DESC then
        fSection[0].size = fSection[1].size
        fSection[2].size = size - 2*fSection[0].size - 4
    else
        fSection[0].size = size - 2*fSection[1].size - 4
        fSection[2].size = fSection[1].size
    end
    local pos = 0
    for i=0,2 do
        fSection[i].shadow:ClearAllPoints()
        fSection[i].active:ClearAllPoints()
        if elemInfo.type == 'H' then
            fSection[i].shadow:SetWidth(fSection[i].size)
            fSection[i].shadow:SetPoint('TOPLEFT', Addon.fMain.timerbar, 'TOPLEFT', pos + padding, -padding)
            fSection[i].shadow:SetPoint('BOTTOMLEFT', Addon.fMain.timerbar, 'BOTTOMLEFT', pos + padding, padding)

            fSection[i].active:SetWidth(fSection[i].size)
            fSection[i].active:SetPoint('TOPLEFT', fSection[i].shadow, 'TOPLEFT', 0, 0)
            fSection[i].active:SetPoint('BOTTOMLEFT', fSection[i].shadow, 'BOTTOMLEFT', 0, 0)
        else
            fSection[i].shadow:SetHeight(fSection[i].size)
            fSection[i].shadow:SetPoint('BOTTOMLEFT', Addon.fMain.timerbar, 'BOTTOMLEFT', padding, pos + padding)
            fSection[i].shadow:SetPoint('BOTTOMRIGHT', Addon.fMain.timerbar, 'BOTTOMRIGHT', -padding, pos + padding)

            fSection[i].active:SetHeight(fSection[i].size)
            fSection[i].active:SetPoint('BOTTOMLEFT', fSection[i].shadow, 'BOTTOMLEFT', 0, 0)
            fSection[i].active:SetPoint('BOTTOMRIGHT', fSection[i].shadow, 'BOTTOMRIGHT', 0, 0)
        end
        pos = pos + fSection[i].size + 2

        fSection[i].shadow:SetTexture('Interface\\Buttons\\WHITE8X8')
        fSection[i].shadow:SetVertexColor(0, 0, 0, .75)
        local color = IPMTTheme[IPMTOptions.theme].elements.timer.color[i]
        fSection[i].active:SetTexture(elemInfo.statusbar.texture)
        fSection[i].active:SetVertexColor(color.r, color.g, color.b, color.a)
        if elemInfo.type == 'H' then
            fSection[i].active:SetTexCoord(0,0, 0,1, 1,0, 1,1)
        else
            fSection[i].active:SetTexCoord(0,1, 1,1, 0,0, 1,0)
        end
    end
end

local function CreateTimerbar()
    Addon.fMain.timerbar.section = {}
    for i=0,2 do
        Addon.fMain.timerbar.section[i] = {
            shadow = Addon.fMain.timerbar:CreateTexture(),
            active = Addon.fMain.timerbar:CreateTexture(),
            size   = nil,
        }
        Addon.fMain.timerbar.section[i].shadow:SetDrawLayer("BACKGROUND", 1)
        Addon.fMain.timerbar.section[i].active:SetDrawLayer("BACKGROUND", 2)
    end
    Addon:RenderTimerbar()
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
    if frame == 'timerbar' then
        CreateTimerbar()
    else 
        Addon.fMain[frame]:SetBackdropColor(1,1,1, 0)
    end
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
        for f = 1,Addon.affixesCount do
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