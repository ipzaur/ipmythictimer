local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

-- Options Frame
Addon.fOptions = CreateFrame("Frame", "IPMTSettings", UIParent)
Addon.fOptions:SetFrameStrata("MEDIUM")
Addon.fOptions:SetSize(270, 480)
Addon.fOptions:SetPoint("CENTER", UIParent)
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
Addon.fOptions:Hide()

-- Options caption
Addon.fOptions.caption = Addon.fOptions:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.caption:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -20)
Addon.fOptions.caption:SetJustifyH("CENTER")
Addon.fOptions.caption:SetSize(200, 20)
Addon.fOptions.caption:SetFont(Addon.DECOR_FONT, 20)
Addon.fOptions.caption:SetTextColor(1, 1, 1)
Addon.fOptions.caption:SetText(Addon.localization.OPTIONS)

-- Opactity slider
Addon.fOptions.opacity = CreateFrame("Slider", "IPMTOpacity", Addon.fOptions, "OptionsSliderTemplate")
Addon.fOptions.opacity:SetWidth(220)
Addon.fOptions.opacity:SetHeight(18)
Addon.fOptions.opacity:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -66)
Addon.fOptions.opacity:SetOrientation('HORIZONTAL')
Addon.fOptions.opacity:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
Addon.fOptions.opacity:EnableMouseWheel(true)
Addon.fOptions.opacity:SetMinMaxValues(0, 100)
Addon.fOptions.opacity:SetValue(100)
Addon.fOptions.opacity:SetValueStep(1.0)
Addon.fOptions.opacity:SetObeyStepOnDrag(true)
getglobal(Addon.fOptions.opacity:GetName() .. 'Low'):SetText('0 %')
getglobal(Addon.fOptions.opacity:GetName() .. 'High'):SetText('100 %')
getglobal(Addon.fOptions.opacity:GetName() .. 'Text'):SetText(Addon.localization.OPACITY)
Addon.fOptions.opacity:SetScript('OnValueChanged', function(self)
    Addon:SetOpacity(self:GetValue())
end)
Addon.fOptions.opacity:SetScript('OnMouseWheel', function(self)
    Addon:SetOpacity(self:GetValue())
end)

-- Scale slider
Addon.fOptions.scale = CreateFrame("Slider", "IPMTScale", Addon.fOptions, "OptionsSliderTemplate")
Addon.fOptions.scale:SetWidth(220)
Addon.fOptions.scale:SetHeight(18)
Addon.fOptions.scale:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -106)
Addon.fOptions.scale:SetOrientation('HORIZONTAL')
Addon.fOptions.scale:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
Addon.fOptions.scale:EnableMouseWheel(true)
Addon.fOptions.scale:SetMinMaxValues(0, 100)
Addon.fOptions.scale:SetValue(0)
Addon.fOptions.scale:SetValueStep(1.0)
Addon.fOptions.scale:SetObeyStepOnDrag(true)
getglobal(Addon.fOptions.scale:GetName() .. 'Low'):SetText('100 %')
getglobal(Addon.fOptions.scale:GetName() .. 'High'):SetText('200 %')
getglobal(Addon.fOptions.scale:GetName() .. 'Text'):SetText(Addon.localization.SCALE)
Addon.fOptions.scale:SetScript('OnValueChanged', function(self)
    Addon:SetScale(self:GetValue())
end)
Addon.fOptions.scale:SetScript('OnMouseWheel', function(self)
    Addon:SetScale(self:GetValue())
end)


-- Fonts caption
Addon.fOptions.fontsCaption = Addon.fOptions:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.fontsCaption:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -136)
Addon.fOptions.fontsCaption:SetJustifyH("CENTER")
Addon.fOptions.fontsCaption:SetSize(120, 20)
Addon.fOptions.fontsCaption:SetTextColor(1, 1, 1)
Addon.fOptions.fontsCaption:SetText(Addon.localization.FONT)

-- Fonts selector
local function getFontList()
    local fontList = LSM:List('font')
    local list = {}
    for i,font in pairs(fontList) do
        local filepath = LSM:Fetch('font', font)
        list[filepath] = font
    end
    return list
end
Addon.fOptions.fFonts = iPElemsCreateListBox(nil, Addon.fOptions, getFontList, {
    onRenderItem = function(fItem, key, text)
        fItem.fText:SetFont(key, 12)
    end,
    onSelect = function(key, text)
        Addon.fOptions.fFonts.fText:SetFont(key, 12)
        Addon:SetFont(key)
    end,
})
Addon.fOptions.fFonts:SetSize(220, 30)
Addon.fOptions.fFonts:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -160)


-- ProgressFormat caption
Addon.fOptions.progressCaption = Addon.fOptions:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.progressCaption:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -194)
Addon.fOptions.progressCaption:SetJustifyH("CENTER")
Addon.fOptions.progressCaption:SetSize(120, 20)
Addon.fOptions.progressCaption:SetTextColor(1, 1, 1)
Addon.fOptions.progressCaption:SetText(Addon.localization.PROGRESS)

-- ProgressFormat selector
Addon.fOptions.fProgress = iPElemsCreateListBox(nil, Addon.fOptions, Addon.localization.PROGFORMAT, {
    onSelect = function(key)
        Addon:SetProgressFormat(key)
    end,
})
Addon.fOptions.fProgress:SetSize(220, 30)
Addon.fOptions.fProgress:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -218)


-- Progress direction caption
Addon.fOptions.directionCaption = Addon.fOptions:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.directionCaption:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -252)
Addon.fOptions.directionCaption:SetJustifyH("CENTER")
Addon.fOptions.directionCaption:SetSize(180, 20)
Addon.fOptions.directionCaption:SetTextColor(1, 1, 1)
Addon.fOptions.directionCaption:SetText(Addon.localization.DIRECTION)

-- Progress direction selector
Addon.fOptions.fProgressDirection = iPElemsCreateListBox(nil, Addon.fOptions, Addon.localization.DIRECTIONS, {
    onSelect = function(key)
        Addon:SetProgressDirection(key)
    end,
})
Addon.fOptions.fProgressDirection:SetSize(220, 30)
Addon.fOptions.fProgressDirection:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -276)


-- Customize checkbox
Addon.fOptions.customize = CreateFrame("CheckButton", nil, Addon.fOptions, "InterfaceOptionsCheckButtonTemplate")
Addon.fOptions.customize:SetSize(22, 22)
Addon.fOptions.customize:SetPoint("LEFT", Addon.fOptions, "TOPLEFT", 20, -308)
Addon.fOptions.customize.label = Addon.fOptions.customize:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.customize.label:SetJustifyH("LEFT")
Addon.fOptions.customize.label:SetPoint("LEFT", Addon.fOptions.customize, "CENTER", 20, 0)
Addon.fOptions.customize.label:SetSize(200, 40)
Addon.fOptions.customize.label:SetTextColor(1, 1, 1)
Addon.fOptions.customize.label:SetText(Addon.localization.CUSTOMIZE)
Addon.fOptions.customize:SetScript("PostClick", function(self)
    Addon:ToggleCustomize(Addon.fOptions.customize:GetChecked())
end)

-- Minimap Button checkbox
Addon.fOptions.Mapbut = CreateFrame("CheckButton", nil, Addon.fOptions, "InterfaceOptionsCheckButtonTemplate")
Addon.fOptions.Mapbut:SetSize(22, 22)
Addon.fOptions.Mapbut:SetPoint("LEFT", Addon.fOptions, "TOPLEFT", 20, -340)
Addon.fOptions.Mapbut.label = Addon.fOptions.Mapbut:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.Mapbut.label:SetJustifyH("LEFT")
Addon.fOptions.Mapbut.label:SetPoint("LEFT", Addon.fOptions.Mapbut, "CENTER", 20, 0)
Addon.fOptions.Mapbut.label:SetSize(200, 40)
Addon.fOptions.Mapbut.label:SetTextColor(1, 1, 1)
Addon.fOptions.Mapbut.label:SetText(Addon.localization.MAPBUTOPT)
Addon.fOptions.Mapbut:SetScript("PostClick", function(self)
    Addon:toggleMapbutton(Addon.fOptions.Mapbut:GetChecked())
end)

-- Restore button
Addon.fOptions.restore = CreateFrame("Button", nil, Addon.fOptions, "UIPanelButtonTemplate")
Addon.fOptions.restore:SetPoint("CENTER", Addon.fOptions, "BOTTOM", 0, 98)
Addon.fOptions.restore:SetSize(200, 30)
Addon.fOptions.restore:SetText(Addon.localization.RESTORE)
Addon.fOptions.restore:SetScript("OnClick", function(self)
    Addon:RestoreOptions()
end)
-- Clear database button
Addon.fOptions.cleanDB = CreateFrame("Button", nil, Addon.fOptions, "UIPanelButtonTemplate")
Addon.fOptions.cleanDB:SetPoint("CENTER", Addon.fOptions, "BOTTOM", 0, 64)
Addon.fOptions.cleanDB:SetSize(200, 30)
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

-- Close button
Addon.fOptions.close = CreateFrame("Button", nil, Addon.fOptions, "UIPanelButtonTemplate")
Addon.fOptions.close:SetPoint("CENTER", Addon.fOptions, "BOTTOM", 0, 30)
Addon.fOptions.close:SetSize(200, 30)
Addon.fOptions.close:SetText(Addon.localization.CLOSE)
Addon.fOptions.close:SetScript("OnClick", function(self)
    Addon:CloseOptions()
end)

-- Element font size slider
Addon.fOptions.FS = CreateFrame("Frame")
Addon.fOptions.FS:SetFrameStrata("HIGH")
Addon.fOptions.FS:SetSize(150, 50)
Addon.fOptions.FS:SetPoint("CENTER", UIParent)
Addon.fOptions.FS:SetBackdrop(Addon.backdrop)
Addon.fOptions.FS:SetBackdropColor(0,0,0, 0.9)
Addon.fOptions.FS:Hide()

Addon.fOptions.FS.slider = CreateFrame("Slider", "IPMTFSSlider", Addon.fOptions.FS, "OptionsSliderTemplate")
Addon.fOptions.FS.slider:SetWidth(126)
Addon.fOptions.FS.slider:SetHeight(18)
Addon.fOptions.FS.slider:SetPoint("CENTER", Addon.fOptions.FS, "TOP", 0, -28)
Addon.fOptions.FS.slider:SetOrientation('HORIZONTAL')
Addon.fOptions.FS.slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
Addon.fOptions.FS.slider:EnableMouseWheel(true)
Addon.fOptions.FS.slider:SetMinMaxValues(10, 50)
Addon.fOptions.FS.slider:SetValue(10)
Addon.fOptions.FS.slider:SetValueStep(1.0)
Addon.fOptions.FS.slider:SetObeyStepOnDrag(true)
getglobal(Addon.fOptions.FS.slider:GetName() .. 'Low'):SetText('10')
getglobal(Addon.fOptions.FS.slider:GetName() .. 'High'):SetText('40')
getglobal(Addon.fOptions.FS.slider:GetName() .. 'Text'):SetText(Addon.localization.FONTSIZE)
Addon.fOptions.FS.slider:SetScript('OnValueChanged', function(self)
    Addon:SetFontSize(self:GetValue())
end)
Addon.fOptions.FS.slider:SetScript('OnMouseUp', function(self, button)
    if button == "LeftButton" and Addon.fontSizeFrame ~= nil then
        Addon:RecalcElem(Addon.fontSizeFrame)
    end
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
Addon.fOptions.closeX = CreateFrame("Button", nil, Addon.fOptions)
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
Addon.fOptions.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\x-close")

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
