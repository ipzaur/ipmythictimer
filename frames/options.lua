local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

function Addon:RenderOptions()
    -- Options Frame
    Addon.fOptions = CreateFrame("Frame", "IPMTSettings", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fOptions:SetFrameStrata("MEDIUM")
    Addon.fOptions:SetSize(270, 540)
    Addon.fOptions:ClearAllPoints()
    Addon.fOptions:SetPoint(IPMTOptions.position.options.point, IPMTOptions.position.options.x, IPMTOptions.position.options.y)
    Addon.fOptions:SetBackdrop(Addon.backdrop)
    Addon.fOptions:SetBackdropColor(0,0,0, 1)
    Addon.fOptions:EnableMouse(true)
    Addon.fOptions:RegisterForDrag("LeftButton")
    Addon.fOptions:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fOptions:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
        local point, _, _, x, y = self:GetPoint()
        IPMTOptions.position.options = {
            point = point,
            x     = math.floor(x),
            y     = math.floor(y),
        }
    end)
    Addon.fOptions:SetMovable(true)

    Addon.fOptions.common = CreateFrame("Frame", nil, Addon.fOptions)
    Addon.fOptions.common:SetFrameStrata("MEDIUM")
    Addon.fOptions.common:SetWidth(230)
    Addon.fOptions.common:SetPoint("TOPLEFT", Addon.fOptions, "TOPLEFT", 20, -10)
    Addon.fOptions.common:SetPoint("BOTTOM", Addon.fOptions, "BOTTOMLEFT", 20, 10)

    -- Options caption
    Addon.fOptions.caption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.caption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -10)
    Addon.fOptions.caption:SetJustifyH("CENTER")
    Addon.fOptions.caption:SetSize(200, 20)
    Addon.fOptions.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fOptions.caption:SetTextColor(1, 1, 1)
    Addon.fOptions.caption:SetText(Addon.localization.OPTIONS)

    -- Scale slider
    local top = -66
    Addon.fOptions.scale = CreateFrame("Slider", nil, Addon.fOptions.common, "IPOptionsSlider")
    Addon.fOptions.scale:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.scale:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.scale:SetOrientation('HORIZONTAL')
    Addon.fOptions.scale:SetMinMaxValues(0, 100)
    Addon.fOptions.scale:SetValue(IPMTOptions.scale)
    Addon.fOptions.scale:SetValueStep(1.0)
    Addon.fOptions.scale:SetObeyStepOnDrag(true)
    Addon.fOptions.scale.Low:SetText('100 %')
    Addon.fOptions.scale.High:SetText('200 %')
    Addon.fOptions.scale.Text:SetText(Addon.localization.SCALE .. " (" .. (IPMTOptions.scale + 100) .. "%)")
    Addon.fOptions.scale:SetScript('OnValueChanged', function(self)
        Addon:SetScale(self:GetValue())
    end)
    Addon.fOptions.scale:SetScript('OnMouseWheel', function(self)
        Addon:SetScale(self:GetValue())
    end)

    -- TimerDirection caption
    top = top - 44
    Addon.fOptions.timerCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.timerCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, top)
    Addon.fOptions.timerCaption:SetJustifyH("CENTER")
    Addon.fOptions.timerCaption:SetSize(120, 20)
    Addon.fOptions.timerCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.timerCaption:SetText(Addon.localization.TIMERDIR)

    -- TimerDirection selector
    top = top - 24
    Addon.fOptions.timerDirection = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.timerDirection:SetHeight(30)
    Addon.fOptions.timerDirection:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.timerDirection:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.timerDirection:SetList(Addon.optionList.timerDir, IPMTOptions.timerDir)
    Addon.fOptions.timerDirection:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetTimerDirection(key)
        end,
    })

    -- ProgressFormat caption
    top = top - 34
    Addon.fOptions.progressCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.progressCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, top)
    Addon.fOptions.progressCaption:SetJustifyH("CENTER")
    Addon.fOptions.progressCaption:SetSize(120, 20)
    Addon.fOptions.progressCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.progressCaption:SetText(Addon.localization.PROGRESS)

    -- ProgressFormat selector
    top = top - 24
    Addon.fOptions.progressFormat = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.progressFormat:SetHeight(30)
    Addon.fOptions.progressFormat:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.progressFormat:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.progressFormat:SetList(Addon.optionList.progress, IPMTOptions.progress)
    Addon.fOptions.progressFormat:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetProgressFormat(key)
        end,
    })

    -- Progress direction caption
    top = top - 34
    Addon.fOptions.directionCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.directionCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, top)
    Addon.fOptions.directionCaption:SetJustifyH("CENTER")
    Addon.fOptions.directionCaption:SetSize(180, 20)
    Addon.fOptions.directionCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.directionCaption:SetText(Addon.localization.DIRECTION)

    -- Progress direction selector
    top = top - 24
    Addon.fOptions.progressDirection = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.progressDirection:SetHeight(30)
    Addon.fOptions.progressDirection:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.progressDirection:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.progressDirection:SetList(Addon.optionList.direction, IPMTOptions.direction)
    Addon.fOptions.progressDirection:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetProgressDirection(key)
        end,
    })

    -- Limit Progress checkbox
    top = top - 34
    Addon.fOptions.limitProgress = CreateFrame("CheckButton", nil, Addon.fOptions.common, "IPCheckButton")
    Addon.fOptions.limitProgress:SetHeight(22)
    Addon.fOptions.limitProgress:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.limitProgress:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.limitProgress:SetText(Addon.localization.LIMITPRGRS)
    Addon.fOptions.limitProgress:SetScript("PostClick", function(self)
        Addon:SetLimitProgress(self:GetChecked())
    end)
    Addon.fOptions.limitProgress:SetChecked(IPMTOptions.limitProgress)

    -- Minimap Button checkbox
    top = top - 48
    Addon.fOptions.Mapbut = CreateFrame("CheckButton", nil, Addon.fOptions.common, "IPCheckButton")
    Addon.fOptions.Mapbut:SetHeight(22)
    Addon.fOptions.Mapbut:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.Mapbut:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.Mapbut:SetText(Addon.localization.MAPBUTOPT)
    Addon.fOptions.Mapbut:SetScript("PostClick", function(self)
        Addon:ToggleMapButton(self:GetChecked())
    end)
    Addon.fOptions.Mapbut:SetChecked(not Addon.DB.global.minimap.hide)


    -- Themes caption
    top = top - 40
    Addon.fOptions.themeCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.themeCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, top)
    Addon.fOptions.themeCaption:SetJustifyH("CENTER")
    Addon.fOptions.themeCaption:SetSize(180, 20)
    Addon.fOptions.themeCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.themeCaption:SetText(Addon.localization.THEME)

    -- Themes selector
    top = top - 24
    local function GetThemesList()
        local list = {}
        for id,theme in pairs(IPMTTheme) do
            list[id] = theme.name
        end
        return list
    end
    Addon.fOptions.theme = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.theme:SetHeight(30)
    Addon.fOptions.theme:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.theme:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, top)
    Addon.fOptions.theme:SetList(GetThemesList, IPMTOptions.theme, true)
    Addon.fOptions.theme:SetCallback({
        OnSelect = function(self, key, text)
            Addon:ApplyTheme(key)
        end,
    })

    -- New theme button
    top = top - 36
    Addon.fOptions.newTheme = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.newTheme:SetSize(50, 30)
    Addon.fOptions.newTheme:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, top)
    Addon.fOptions.newTheme:SetList(Addon.optionList.createTheme, nil, true)
    Addon.fOptions.newTheme:SetBackdropColor(.15,.15,.15, 1)
    Addon.fOptions.newTheme.fText:Hide()
    Addon.fOptions.newTheme.fTriangle:ClearAllPoints()
    Addon.fOptions.newTheme.fTriangle:SetPoint("CENTER", Addon.fOptions.newTheme, "CENTER", 0, 0)
    Addon.fOptions.newTheme.fTriangle:SetSize(20, 20)
    Addon.fOptions.newTheme.fTriangle:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fOptions.newTheme.fTriangle:SetTexCoord(.5, .75, .5, 1)
    Addon.fOptions.newTheme.fTriangle:SetVertexColor(.75, .75, .75, 1)
    Addon.fOptions.newTheme:SetCallback({
        OnCancel = function(self, key, text)
            Addon.fOptions.newTheme.fTriangle:SetVertexColor(.75, .75, .75, 1)
        end,
        OnSelect = function(self, key, text)
            Addon.fOptions.newTheme.fTriangle:SetVertexColor(.75, .75, .75, 1)
            Addon:ThemeAction(key)
        end,
    })
    Addon.fOptions.newTheme:HookScript("OnEnter", function(self)
        self.fTriangle:SetVertexColor(1, 1, 1, 1)
        self:SetBackdropColor(.175,.175,.175, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.THEMEBUTNS.ACTIONS, .9, .9, 0, 1, true)
        GameTooltip:Show()
    end)
    Addon.fOptions.newTheme:HookScript("OnLeave", function(self)
        self.fTriangle:SetVertexColor(.75, .75, .75, 1)
        self:SetBackdropColor(.15,.15,.15, 1)
        GameTooltip:Hide()
    end)

    -- Remove theme button
    Addon.fOptions.removeTheme = CreateFrame("Button", nil, Addon.fOptions.common, "IPButton")
    Addon.fOptions.removeTheme:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 60, top)
    Addon.fOptions.removeTheme:SetSize(50, 30)
    Addon.fOptions.removeTheme:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fOptions.removeTheme.fTexture:SetSize(20, 20)
    Addon.fOptions.removeTheme.fTexture:SetTexCoord(.75, 1, 0, .5)
    Addon.fOptions.removeTheme.fTexture:SetVertexColor(.75, .75, .75)
    Addon.fOptions.removeTheme:SetScript("OnClick", function(self)
        if not self.disabled then
           Addon:RemoveTheme(IPMTOptions.theme)
        end
    end)
    Addon.fOptions.removeTheme:HookScript("OnEnter", function(self)
        if not self.disabled then
            self.fTexture:SetVertexColor(1, 1, 1)
        end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.THEMEBUTNS.DELETE, .9, .9, 0, 1, true)
        GameTooltip:Show()
    end)
    Addon.fOptions.removeTheme:HookScript("OnLeave", function(self)
        if not self.disabled then
            self.fTexture:SetVertexColor(.75, .75, .75)
        end
        GameTooltip:Hide()
    end)
    Addon.fOptions.removeTheme.OnDisabled = function(self, disable)
        if disable then
            self.fTexture:SetVertexColor(.35, .35, .35)
        else
            self.fTexture:SetVertexColor(.75, .75, .75)
        end
    end
    if IPMTOptions.theme == 1 then
        Addon.fOptions.removeTheme:ToggleDisabled(true)
    end

    -- Restore theme button
    Addon.fOptions.restoreTheme = CreateFrame("Button", nil, Addon.fOptions.common, "IPButton")
    Addon.fOptions.restoreTheme:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 120, top)
    Addon.fOptions.restoreTheme:SetSize(50, 30)
    Addon.fOptions.restoreTheme:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fOptions.restoreTheme.fTexture:SetSize(20, 20)
    Addon.fOptions.restoreTheme.fTexture:SetTexCoord(.75, 1, .5, 1)
    Addon.fOptions.restoreTheme.fTexture:SetVertexColor(.75, .75, .75)
    Addon.fOptions.restoreTheme:SetScript("OnClick", function(self)
        Addon:RestoreDefaultTheme()
    end)
    Addon.fOptions.restoreTheme:HookScript("OnEnter", function(self)
        self.fTexture:SetVertexColor(1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.THEMEBUTNS.RESTORE, .9, .9, 0, 1, true)
        GameTooltip:Show()
    end)
    Addon.fOptions.restoreTheme:HookScript("OnLeave", function(self)
        self.fTexture:SetVertexColor(.75, .75, .75)
        GameTooltip:Hide()
    end)

    -- Edit Theme button
    Addon.fOptions.editTheme = CreateFrame("Button", nil, Addon.fOptions.common, "IPButton")
    Addon.fOptions.editTheme:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 180, top)
    Addon.fOptions.editTheme:SetSize(50, 30)
    Addon.fOptions.editTheme:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fOptions.editTheme.fTexture:SetSize(20, 20)
    Addon.fOptions.editTheme.fTexture:SetTexCoord(0, .25, .5, 1)
    Addon.fOptions.editTheme.fTexture:SetVertexColor(.75, .75, .75)
    Addon.fOptions.editTheme:SetScript("OnClick", function(self)
        Addon:ToggleThemeEditor()
    end)
    Addon.fOptions.editTheme:HookScript("OnEnter", function(self)
        self.fTexture:SetVertexColor(1, 1, 1)
        local text
        if not Addon.opened.themes then
            text = Addon.localization.THEMEBUTNS.OPENEDITOR
        else
            self:SetBackdropColor(.25,.25,.25, 1)
            text = Addon.localization.THEMEBUTNS.CLOSEEDITOR
        end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text, .9, .9, 0, 1, true)
        GameTooltip:Show()
    end)
    Addon.fOptions.editTheme:HookScript("OnLeave", function(self)
        if not Addon.opened.themes then
            self.fTexture:SetVertexColor(.75, .75, .75)
        else
            self:SetBackdropBorderColor(1,1,1, 1)
            self:SetBackdropColor(.25,.25,.25, 1)
        end
        GameTooltip:Hide()
    end)

    -- Clear database button
    Addon.fOptions.cleanDB = CreateFrame("Button", nil, Addon.fOptions.common, "IPButton")
    Addon.fOptions.cleanDB:SetPoint("CENTER", Addon.fOptions.common, "BOTTOM", 0, 20)
    Addon.fOptions.cleanDB:SetSize(220, 30)
    Addon.fOptions.cleanDB:SetText(Addon.localization.CLEANDBBT)
    Addon.fOptions.cleanDB:SetScript("OnClick", function(self)
        Addon:CleanDB()
    end)
    Addon.fOptions.cleanDB:HookScript("OnEnter", function(self, event, ...)
        Addon:ToggleDBTooltip(self, true)
    end)
    Addon.fOptions.cleanDB:HookScript("OnLeave", function(self, event, ...)
        Addon:ToggleDBTooltip(self, false)
    end)

    -- Help button
    Addon.fOptions.help = CreateFrame("Button", nil, Addon.fOptions)
    Addon.fOptions.help:SetPoint("CENTER", Addon.fOptions, "TOPLEFT", 20, -20)
    Addon.fOptions.help:SetSize(40, 40)
    Addon.fOptions.help:SetScript("OnClick", function(self)
        Addon:ToggleHelp()
    end)
    Addon.fOptions.help.icon = Addon.fOptions.help:CreateTexture()
    Addon.fOptions.help.icon:SetSize(16, 16)
    Addon.fOptions.help.icon:SetPoint("CENTER", Addon.fOptions.help, "CENTER", 0, 0)
    Addon.fOptions.help.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fOptions.help.icon:SetTexCoord(.5, .75, 0, .5)
    Addon.fOptions.help.icon:SetVertexColor(.9, .85, 0)
    Addon.fOptions.help.glow = Addon.fOptions.help:CreateTexture(nil, "BACKGROUND")
    Addon.fOptions.help.glow:SetAllPoints(Addon.fOptions.help)
    Addon.fOptions.help.glow:SetTexture(167062)
    Addon.fOptions.help.glow:SetVertexColor(.9, .85, 0)
    Addon.fOptions.help.glow:Hide()

    -- X-Close button
    Addon.fOptions.closeX = CreateFrame("Button", nil, Addon.fOptions, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fOptions.closeX:SetPoint("TOP", Addon.fOptions, "TOPRIGHT", -20, -5)
    Addon.fOptions.closeX:SetSize(26, 26)
    Addon.fOptions.closeX:SetBackdrop(Addon.backdrop)
    Addon.fOptions.closeX:SetBackdropColor(0,0,0, 1)
    Addon.fOptions.closeX:SetScript("OnClick", function(self)
        Addon:CloseOptions()
    end)
    Addon.fOptions.closeX:SetScript("OnEnter", function(self, event, ...)
        Addon.fOptions.closeX:SetBackdropColor(.1,.1,.1, 1)
    end)
    Addon.fOptions.closeX:SetScript("OnLeave", function(self, event, ...)
        Addon.fOptions.closeX:SetBackdropColor(0,0,0, 1)
    end)
    Addon.fOptions.closeX.icon = Addon.fOptions.closeX:CreateTexture()
    Addon.fOptions.closeX.icon:SetSize(16, 16)
    Addon.fOptions.closeX.icon:ClearAllPoints()
    Addon.fOptions.closeX.icon:SetPoint("CENTER", Addon.fOptions.closeX, "CENTER", 0, 0)
    Addon.fOptions.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\x-close")

    top = top - 60
    if Addon.season.options and Addon.season.options.Render then
        Addon.fOptions.season = {}
        -- Options caption
        Addon.fOptions.season.caption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fOptions.season.caption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, top)
        Addon.fOptions.season.caption:SetJustifyH("CENTER")
        Addon.fOptions.season.caption:SetSize(200, 20)
        Addon.fOptions.season.caption:SetFont(Addon.DECOR_FONT, 17)
        Addon.fOptions.season.caption:SetTextColor(1, 1, 1)
        Addon.fOptions.season.caption:SetText(Addon.localization.SEASONOPTS)

        local addHeight = Addon.season.options:Render(top - 30)
        local height = Addon.fOptions.common:GetHeight()
        Addon.fOptions.common:SetHeight(height + addHeight)
        Addon.fOptions:SetHeight(height + addHeight + 20)
    end
end

-- Frame for settings in global options panel
Addon.panel = CreateFrame("Frame", "IPMTOptionsPanel", UIParent)
Addon.panel.name = AddonName
Addon.panel.fShowOptions = CreateFrame("Button", nil, Addon.panel, "UIPanelButtonTemplate")
Addon.panel.fShowOptions:SetPoint("CENTER", Addon.panel, "TOP", 0, -140)
Addon.panel.fShowOptions:SetSize(200, 30)
Addon.panel.fShowOptions:SetText(Addon.localization.OPTIONS)
Addon.panel.fShowOptions:SetScript("OnClick", function(self)
    Addon:OpenSettingsFromPanel()
end)
InterfaceOptions_AddCategory(Addon.panel)
