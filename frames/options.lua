local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

function Addon:RenderOptions()
    -- Options Frame
    Addon.fOptions = CreateFrame("Frame", "IPMTSettings", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fOptions:SetFrameStrata("MEDIUM")
    Addon.fOptions:SetSize(270, 408)
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
    Addon.fOptions.common:SetWidth(250)
    Addon.fOptions.common:SetPoint("TOPLEFT", Addon.fOptions, "TOPLEFT", 10, -10)
    Addon.fOptions.common:SetPoint("BOTTOM", Addon.fOptions, "BOTTOMLEFT", 10, 10)

    -- Options caption
    Addon.fOptions.caption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.caption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -10)
    Addon.fOptions.caption:SetJustifyH("CENTER")
    Addon.fOptions.caption:SetSize(200, 20)
    Addon.fOptions.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fOptions.caption:SetTextColor(1, 1, 1)
    Addon.fOptions.caption:SetText(Addon.localization.OPTIONS)

    -- Scale slider
    Addon.fOptions.scale = CreateFrame("Slider", "IPMTScale", Addon.fOptions.common, "OptionsSliderTemplate")
    Addon.fOptions.scale:SetWidth(220)
    Addon.fOptions.scale:SetHeight(18)
    Addon.fOptions.scale:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -66)
    Addon.fOptions.scale:SetOrientation('HORIZONTAL')
    Addon.fOptions.scale:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    Addon.fOptions.scale:EnableMouseWheel(true)
    Addon.fOptions.scale:SetMinMaxValues(0, 100)
    Addon.fOptions.scale:SetValue(IPMTOptions.scale)
    Addon.fOptions.scale:SetValueStep(1.0)
    Addon.fOptions.scale:SetObeyStepOnDrag(true)
    getglobal(Addon.fOptions.scale:GetName() .. 'Low'):SetText('100 %')
    getglobal(Addon.fOptions.scale:GetName() .. 'High'):SetText('200 %')
    getglobal(Addon.fOptions.scale:GetName() .. 'Text'):SetText(Addon.localization.SCALE .. " (" .. (IPMTOptions.scale + 100) .. "%)")
    Addon.fOptions.scale:SetScript('OnValueChanged', function(self)
        Addon:SetScale(self:GetValue())
    end)
    Addon.fOptions.scale:SetScript('OnMouseWheel', function(self)
        Addon:SetScale(self:GetValue())
    end)

    -- ProgressFormat caption
    Addon.fOptions.progressCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.progressCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -110)
    Addon.fOptions.progressCaption:SetJustifyH("CENTER")
    Addon.fOptions.progressCaption:SetSize(120, 20)
    Addon.fOptions.progressCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.progressCaption:SetText(Addon.localization.PROGRESS)

    -- ProgressFormat selector
    Addon.fOptions.progressFormat = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.progressFormat:SetSize(220, 30)
    Addon.fOptions.progressFormat:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -134)
    Addon.fOptions.progressFormat:SetList(Addon.optionList.progress, IPMTOptions.progress)
    Addon.fOptions.progressFormat:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetProgressFormat(key)
        end,
    })

    -- Progress direction caption
    Addon.fOptions.directionCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.directionCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -168)
    Addon.fOptions.directionCaption:SetJustifyH("CENTER")
    Addon.fOptions.directionCaption:SetSize(180, 20)
    Addon.fOptions.directionCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.directionCaption:SetText(Addon.localization.DIRECTION)

    -- Progress direction selector
    Addon.fOptions.progressDirection = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.progressDirection:SetSize(220, 30)
    Addon.fOptions.progressDirection:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -192)
    Addon.fOptions.progressDirection:SetList(Addon.optionList.direction, IPMTOptions.direction)
    Addon.fOptions.progressDirection:SetCallback({
        OnSelect = function(self, key, text)
            Addon:SetProgressDirection(key)
        end,
    })

    -- Minimap Button checkbox
    Addon.fOptions.Mapbut = CreateFrame("CheckButton", nil, Addon.fOptions.common, "InterfaceOptionsCheckButtonTemplate")
    Addon.fOptions.Mapbut:SetSize(22, 22)
    Addon.fOptions.Mapbut:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 20, -240)
    Addon.fOptions.Mapbut.label = Addon.fOptions.Mapbut:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.Mapbut.label:SetJustifyH("LEFT")
    Addon.fOptions.Mapbut.label:SetPoint("LEFT", Addon.fOptions.Mapbut, "CENTER", 20, 0)
    Addon.fOptions.Mapbut.label:SetSize(200, 40)
    Addon.fOptions.Mapbut.label:SetTextColor(1, 1, 1)
    Addon.fOptions.Mapbut.label:SetText(Addon.localization.MAPBUTOPT)
    Addon.fOptions.Mapbut:SetScript("PostClick", function(self)
        Addon:toggleMapbutton(Addon.fOptions.Mapbut:GetChecked())
    end)


    -- Themes caption
    Addon.fOptions.themeCaption = Addon.fOptions.common:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fOptions.themeCaption:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -280)
    Addon.fOptions.themeCaption:SetJustifyH("CENTER")
    Addon.fOptions.themeCaption:SetSize(180, 20)
    Addon.fOptions.themeCaption:SetTextColor(1, 1, 1)
    Addon.fOptions.themeCaption:SetText('Тема')

    -- Themes selector
    local function getThemesList()
        local list = {}
        for label,theme in pairs(IPMTTheme) do
            list[label] = theme.name
        end
        return list
    end
    Addon.fOptions.theme = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.theme:SetSize(220, 30)
    Addon.fOptions.theme:SetPoint("CENTER", Addon.fOptions.common, "TOP", 0, -304)
    Addon.fOptions.theme:SetList(getThemesList, IPMTOptions.theme)
    Addon.fOptions.theme:SetCallback({
        OnSelect = function(self, key, text)
            print(key)
            print(text)
            --Addon:SetProgressDirection(key)
        end,
    })

    -- Edit Theme button
    Addon.fOptions.themeEdit = CreateFrame("Button", nil, Addon.fOptions.common, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fOptions.themeEdit:SetPoint("CENTER", Addon.fOptions.common, "TOP", 122, -304)
    Addon.fOptions.themeEdit:SetSize(20, 20)
    Addon.fOptions.themeEdit:SetBackdrop(Addon.backdrop)
    Addon.fOptions.themeEdit:SetBackdropColor(0,0,0, 0)
    Addon.fOptions.themeEdit:SetScript("OnClick", function(self)
        Addon:ToggleThemeEditor()
    end)
    Addon.fOptions.themeEdit:SetScript("OnEnter", function(self, event, ...)
        local text
        if Addon.fThemes == nil or not Addon.fThemes:IsShown() then
            Addon.fOptions.themeEdit.icon:SetVertexColor(.9, .9, .9)
            text = 'Открыть редактор темы'
        else
            text = 'Закрыть редактор темы'
        end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text, .9, .9, 0, 1, true)
        GameTooltip:Show()
    end)
    Addon.fOptions.themeEdit:SetScript("OnLeave", function(self, event, ...)
        if Addon.fThemes == nil or not Addon.fThemes:IsShown() then
            Addon.fOptions.themeEdit.icon:SetVertexColor(.5, .5, .5)
        end
        GameTooltip:Hide()
    end)
    Addon.fOptions.themeEdit.icon = Addon.fOptions.themeEdit:CreateTexture()
    Addon.fOptions.themeEdit.icon:SetSize(20, 20)
    Addon.fOptions.themeEdit.icon:ClearAllPoints()
    Addon.fOptions.themeEdit.icon:SetPoint("CENTER", Addon.fOptions.themeEdit, "CENTER", 0, 0)
    Addon.fOptions.themeEdit.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fOptions.themeEdit.icon:SetVertexColor(.5, .5, .5)
    Addon.fOptions.themeEdit.icon:SetTexCoord(0, .5, .5, 1)

    -- Clear database button
    Addon.fOptions.cleanDB = CreateFrame("Button", nil, Addon.fOptions.common, "UIPanelButtonTemplate")
    Addon.fOptions.cleanDB:SetPoint("CENTER", Addon.fOptions.common, "BOTTOM", 0, 20)
    Addon.fOptions.cleanDB:SetSize(220, 30)
    Addon.fOptions.cleanDB:SetText(Addon.localization.CLEANDBBT)
    Addon.fOptions.cleanDB:SetScript("OnClick", function(self)
        Addon:CleanDB()
    end)
    Addon.fOptions.cleanDB:SetScript("OnEnter", function(self, event, ...)
        Addon:ToggleDBTooltip(self, true)
    end)
    Addon.fOptions.cleanDB:SetScript("OnLeave", function(self, event, ...)
        Addon:ToggleDBTooltip(self, false)
    end)

    -- Help button
    Addon.fOptions.help = CreateFrame("Button", nil, Addon.fOptions)
    Addon.fOptions.help:SetPoint("TOP", Addon.fOptions, "TOPLEFT", 20, -5)
    Addon.fOptions.help:SetSize(30, 30)
    Addon.fOptions.help:SetScript("OnClick", function(self)
        Addon:ToggleHelp()
    end)
    Addon.fOptions.help.icon = Addon.fOptions.help:CreateTexture()
    Addon.fOptions.help.icon:SetAllPoints(Addon.fOptions.help)
    Addon.fOptions.help.icon:SetTexture("Interface\\common\\help-i")
    Addon.fOptions.help.glow = Addon.fOptions.help:CreateTexture(nil, "BACKGROUND")
    Addon.fOptions.help.glow:SetAllPoints(Addon.fOptions.help)
    Addon.fOptions.help.glow:SetTexture(167062)
    Addon.fOptions.help.glow:SetVertexColor(.9, .9, 0)
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

    if Addon.season.options and Addon.season.options.Render then
        local top = (-400)
        Addon.fOptions.season = {}
        -- Options caption
        Addon.fOptions.season.caption = Addon.fOptions:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fOptions.season.caption:SetPoint("CENTER", Addon.fOptions, "TOP", 0, top)
        Addon.fOptions.season.caption:SetJustifyH("CENTER")
        Addon.fOptions.season.caption:SetSize(200, 20)
        Addon.fOptions.season.caption:SetFont(Addon.DECOR_FONT, 17)
        Addon.fOptions.season.caption:SetTextColor(1, 1, 1)
        Addon.fOptions.season.caption:SetText(Addon.localization.SEASONOPTS)

        local addHeight = Addon.season.options:Render(top - 30)
        local height = Addon.fOptions:GetHeight()
        Addon.fOptions:SetHeight(height + addHeight)
    end



    -- Restore button
    Addon.fOptions.restore = CreateFrame("Button", nil, Addon.fOptions, "UIPanelButtonTemplate")
    Addon.fOptions.restore:SetPoint("CENTER", Addon.fOptions, "BOTTOM", 0, -98)
    Addon.fOptions.restore:SetSize(200, 30)
    Addon.fOptions.restore:SetText(Addon.localization.RESTORE)
    Addon.fOptions.restore:SetScript("OnClick", function(self)
        Addon:RestoreOptions()
    end)
end