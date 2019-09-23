local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

-- Options Frame
Addon.fOptions = CreateFrame("Frame", "IPMTSettings", UIParent)
Addon.fOptions:SetFrameStrata("MEDIUM")
Addon.fOptions:SetSize(270, 330)
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
Addon.fOptions.caption:SetSize(120, 20)
Addon.fOptions.caption:SetFont(Addon.FONT_ROBOTO, 20)
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
local function fontsDropDown_OnClick(self, fontFilepath, fontName, checked)
    UIDropDownMenu_SetText(Addon.fOptions.fonts, fontName)
    Addon:SetFont(fontFilepath)
end
local function fontsDropDown_Init(frame, level, menuList)
    local fontList = LSM:List('font')
    for i,font in pairs(fontList) do
        local filepath = LSM:Fetch('font', font)
        local info = UIDropDownMenu_CreateInfo()
        info.func = fontsDropDown_OnClick
        info.text, info.arg1, info.arg2 = font, filepath, font
        info.fontObject = CreateFont(font)
        info.fontObject:CopyFontObject('GameFontNormal')
        info.fontObject:SetFont(filepath, 12)
        info.fontObject:SetTextColor(1, 1, 1)
        info.notCheckable = true
        UIDropDownMenu_AddButton(info)
    end
end

Addon.fOptions.fonts = CreateFrame("Frame", "IPMTFonts", Addon.fOptions, "UIDropDownMenuTemplate")
Addon.fOptions.fonts:SetPoint("CENTER", Addon.fOptions, "TOP", 0, -160)
UIDropDownMenu_SetWidth(Addon.fOptions.fonts, 210)
UIDropDownMenu_Initialize(Addon.fOptions.fonts, fontsDropDown_Init)

-- ReapingAlert caption
Addon.fOptions.customize = CreateFrame("CheckButton", nil, Addon.fOptions, "InterfaceOptionsCheckButtonTemplate")
Addon.fOptions.customize:SetSize(22, 22)
Addon.fOptions.customize:SetPoint("LEFT", Addon.fOptions, "TOPLEFT", 20, -196)
Addon.fOptions.customize.label = Addon.fOptions.customize:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
Addon.fOptions.customize.label:SetJustifyH("LEFT")
Addon.fOptions.customize.label:SetPoint("LEFT", Addon.fOptions.customize, "CENTER", 20, 0)
Addon.fOptions.customize.label:SetSize(200, 40)
Addon.fOptions.customize.label:SetTextColor(1, 1, 1)
Addon.fOptions.customize.label:SetText(Addon.localization.CUSTOMIZE)
Addon.fOptions.customize:SetScript("PostClick", function(self)
    Addon:ToggleCustomize(Addon.fOptions.customize:GetChecked())
end)

-- Restore button
Addon.fOptions.restore = CreateFrame("Button", nil, Addon.fOptions, "UIPanelButtonTemplate")
Addon.fOptions.restore:SetPoint("CENTER", Addon.fOptions, "BOTTOM", 0, 98)
Addon.fOptions.restore:SetSize(200, 30)
Addon.fOptions.restore:SetText(Addon.localization.RESTORE)
Addon.fOptions.restore:SetScript("OnClick", function(self)
    Addon.RestoreOptions()
end)
-- Clear database button
Addon.fOptions.cleanDB = CreateFrame("Button", nil, Addon.fOptions, "UIPanelButtonTemplate")
Addon.fOptions.cleanDB:SetPoint("CENTER", Addon.fOptions, "BOTTOM", 0, 64)
Addon.fOptions.cleanDB:SetSize(200, 30)
Addon.fOptions.cleanDB:SetText(Addon.localization.CLEANDBBT)
Addon.fOptions.cleanDB:SetScript("OnClick", function(self)
    Addon.CleanDB()
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
    Addon.CloseOptions()
end)

-- Element font size slider
Addon.fOptions.FS = CreateFrame("Frame")
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