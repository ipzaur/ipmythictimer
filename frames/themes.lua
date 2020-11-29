local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

local function getTextureList()
    local textureList = LSM:List('background')
    local list = {}
    for i,texture in pairs(textureList) do
        local filepath = LSM:Fetch('background', texture)
        if filepath then
            list[filepath] = texture
        end
    end
    return list
end

local function getBorderList()
    local borderList = LSM:List('border')
    local list = {
        none = 'None',
    }
    for i,border in pairs(borderList) do
        local filepath = LSM:Fetch('border', border)
        if filepath then
            list[filepath] = border
        end
    end
    return list
end

local function getFontList()
    local fontList = LSM:List('font')
    local list = {}
    for i,font in pairs(fontList) do
        local filepath = LSM:Fetch('font', font)
        list[filepath] = font
    end
    return list
end

local top = 0

function Addon:RenderThemeEditor()
    local theme = IPMTTheme[IPMTOptions.theme]

    -- Themes Frame
    Addon.fThemes = CreateFrame("ScrollFrame", "IPMTThemes", Addon.fOptions, "IPScrollBox")
    Addon.fThemes:SetFrameStrata("MEDIUM")
    Addon.fThemes:SetWidth(340)
    Addon.fThemes:SetPoint("TOPLEFT", Addon.fOptions, "TOPLEFT", Addon.fOptions.common:GetWidth() + 50, -40)
    Addon.fThemes:SetPoint("BOTTOMLEFT", Addon.fOptions, "BOTTOMLEFT", Addon.fOptions.common:GetWidth() + 50, 20)
    Addon.fThemes:SetBackdropColor(0,0,0, 0)
    Addon.fThemes:SetBackdropBorderColor(0,0,0, 0)
    Addon.fThemes.fContent:SetSize(320,680)

    -- Themes caption
    Addon.fThemes.caption = Addon.fThemes:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.caption:SetPoint("CENTER", Addon.fThemes, "TOP", 0, 20)
    Addon.fThemes.caption:SetJustifyH("CENTER")
    Addon.fThemes.caption:SetSize(250, 20)
    Addon.fThemes.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fThemes.caption:SetTextColor(1, 1, 1)
    Addon.fThemes.caption:SetText(Addon.localization.THEMEDITOR)

    top = -20

    -- Name caption
    Addon.fThemes.nameCaption = Addon.fThemes.fContent:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.nameCaption:SetPoint("CENTER", Addon.fThemes.fContent, "TOP", 0, top)
    Addon.fThemes.nameCaption:SetJustifyH("CENTER")
    Addon.fThemes.nameCaption:SetSize(200, 20)
    Addon.fThemes.nameCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.nameCaption:SetText(Addon.localization.THEMENAME)
    -- Name edit box
    top = top - 24
    Addon.fThemes.name = CreateFrame("EditBox", nil, Addon.fThemes.fContent, "IPEditBox")
    Addon.fThemes.name:SetAutoFocus(false)
    Addon.fThemes.name:SetPoint("LEFT", Addon.fThemes.fContent, "TOPLEFT", 20, top)
    Addon.fThemes.name:SetPoint("RIGHT", Addon.fThemes.fContent, "TOPRIGHT", -20, top)
    Addon.fThemes.name:SetHeight(30)
    Addon.fThemes.name:SetMaxLetters(30)
    Addon.fThemes.name:SetScript('OnTextChanged', function(self)
        Addon:SetThemeName(self:GetText())
    end)

    -- Fonts caption
    top = top - 34
    Addon.fThemes.fontsCaption = Addon.fThemes.fContent:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.fontsCaption:SetPoint("CENTER", Addon.fThemes.fContent, "TOP", 0, top)
    Addon.fThemes.fontsCaption:SetJustifyH("CENTER")
    Addon.fThemes.fontsCaption:SetSize(200, 20)
    Addon.fThemes.fontsCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.fontsCaption:SetText(Addon.localization.FONT)
    -- Fonts selector
    top = top - 24
    Addon.fThemes.fFonts = CreateFrame("Button", nil, Addon.fThemes.fContent, "IPListBox")
    Addon.fThemes.fFonts:SetHeight(30)
    Addon.fThemes.fFonts:SetPoint("LEFT", Addon.fThemes.fContent, "TOPLEFT", 20, top)
    Addon.fThemes.fFonts:SetPoint("RIGHT", Addon.fThemes.fContent, "TOPRIGHT", -20, top)
    Addon.fThemes.fFonts:SetList(getFontList, theme.font)
    Addon.fThemes.fFonts:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:SetFont(key, true)
        end,
        OnCancel = function(self)
            Addon:SetFont(theme.font)
        end,
        OnSelect = function(self, key, text)
            Addon.fThemes.fFonts.fText:SetFont(key, 12)
            Addon:SetFont(key)
        end,
        OnRenderItem = function(self, fItem, key, text)
            fItem.fText:SetFont(key, 12)
        end,
    })

    -- Background caption
    top = top - 60
    Addon.fThemes.bg = CreateFrame("Frame", nil, Addon.fThemes.fContent, "IPFieldSet")
    Addon.fThemes.bg:SetHeight(240)
    Addon.fThemes.bg:SetFrameStrata("MEDIUM")
    Addon.fThemes.bg:SetPoint("TOPLEFT", Addon.fThemes.fContent, "TOPLEFT", 10, top)
    Addon.fThemes.bg:SetPoint("TOPRIGHT", Addon.fThemes.fContent, "TOPRIGHT", -10, top)
    Addon.fThemes.bg:SetText(Addon.localization.BACKGROUND)
    Addon.fThemes.bg:SetFont(Addon.DECOR_FONT, 16 + Addon.DECOR_FONTSIZE_DELTA)

    local subTop = -40
    -- Background width caption
    Addon.fThemes.bg.widthCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.widthCaption:SetPoint("RIGHT", Addon.fThemes.bg, "TOP", -80, subTop)
    Addon.fThemes.bg.widthCaption:SetJustifyH("RIGHT")
    Addon.fThemes.bg.widthCaption:SetSize(70, 20)
    Addon.fThemes.bg.widthCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.widthCaption:SetText(Addon.localization.WIDTH)
    -- Background width edit box
    Addon.fThemes.bg.width = CreateFrame("EditBox", nil, Addon.fThemes.bg, "IPEditBox")
    Addon.fThemes.bg.width:SetAutoFocus(false)
    Addon.fThemes.bg.width:SetPoint("RIGHT", Addon.fThemes.bg, "TOP", -10, subTop)
    Addon.fThemes.bg.width:SetSize(60, 30)
    Addon.fThemes.bg.width:SetMaxLetters(4)
    Addon.fThemes.bg.width:SetScript('OnTextChanged', function(self)
        Addon:ChangeDecor('main', 'width', self:GetText())
    end)
    -- Background height caption
    Addon.fThemes.bg.heightCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.heightCaption:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -80, subTop)
    Addon.fThemes.bg.heightCaption:SetJustifyH("RIGHT")
    Addon.fThemes.bg.heightCaption:SetSize(70, 20)
    Addon.fThemes.bg.heightCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.heightCaption:SetText(Addon.localization.HEIGHT)
    -- Background height edit box
    Addon.fThemes.bg.height = CreateFrame("EditBox", nil, Addon.fThemes.bg, "IPEditBox")
    Addon.fThemes.bg.height:SetAutoFocus(false)
    Addon.fThemes.bg.height:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.height:SetSize(60, 30)
    Addon.fThemes.bg.height:SetMaxLetters(4)
    Addon.fThemes.bg.height:SetScript('OnTextChanged', function(self)
        Addon:ChangeDecor('main', 'height', self:GetText())
    end)

    -- Background texture caption
    subTop = subTop - 30
    Addon.fThemes.bg.textureCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.textureCaption:SetPoint("CENTER", Addon.fThemes.bg, "TOP", 0, subTop)
    Addon.fThemes.bg.textureCaption:SetJustifyH("CENTER")
    Addon.fThemes.bg.textureCaption:SetSize(200, 20)
    Addon.fThemes.bg.textureCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.textureCaption:SetText(Addon.localization.TEXTURE)

    -- Background texture selector
    subTop = subTop - 24
    Addon.fThemes.bg.texture = CreateFrame("Button", nil, Addon.fThemes.bg, "IPListBox")
    Addon.fThemes.bg.texture:SetSize(250, 30)
    Addon.fThemes.bg.texture:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.texture:SetList(getTextureList, theme.main.background.texture)
    Addon.fThemes.bg.texture:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:ChangeDecor('main', 'texture', key, true)
        end,
        OnCancel = function(self)
            Addon:ChangeDecor('main', 'texture', theme.main.background.texture)
        end,
        OnSelect = function(self, key, text)
            Addon:ChangeDecor('main', 'texture', key)
        end,
    })
    Addon.fThemes.bg.texture:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)
    -- Background color picker
    Addon.fThemes.bg.color = CreateFrame("Button", nil, Addon.fThemes.bg, "IPColorButton")
    Addon.fThemes.bg.color:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.color:SetBackdropColor(.5,0,0, 1)
    Addon.fThemes.bg.color:SetCallback(function(self, r, g, b, a)
        Addon:ChangeDecor('main', 'color', {r=r, g=g, b=b, a=a})
    end)
    Addon.fThemes.bg.color:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)
    -- BackgroundBorder Inset slider
    subTop = subTop - 46
    Addon.fThemes.bg.borderInset = CreateFrame("Slider", nil, Addon.fThemes.bg, "IPOptionsSlider")
    Addon.fThemes.bg.borderInset:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.borderInset:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.borderInset:SetOrientation('HORIZONTAL')
    Addon.fThemes.bg.borderInset:SetMinMaxValues(0, 30)
    Addon.fThemes.bg.borderInset:SetValueStep(1.0)
    Addon.fThemes.bg.borderInset:SetObeyStepOnDrag(true)
    Addon.fThemes.bg.borderInset.Low:SetText('0')
    Addon.fThemes.bg.borderInset.High:SetText('30')
    Addon.fThemes.bg.borderInset:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderInset.Text:SetText(Addon.localization.TXTRINDENT .. " (" .. value .. ")")
        Addon:ChangeDecor('main', 'borderInset', value)
    end)
    Addon.fThemes.bg.borderInset:SetScript('OnMouseWheel', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderInset.Text:SetText(Addon.localization.TXTRINDENT .. " (" .. value .. ")")
        Addon:ChangeDecor('main', 'borderInset', value)
    end)
    Addon.fThemes.bg.borderInset:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)
    Addon.fThemes.bg.borderInset:SetValue(theme.main.border.inset)

    -- BackgroundBorder texture caption
    subTop = subTop - 30
    Addon.fThemes.bg.borderCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.borderCaption:SetPoint("CENTER", Addon.fThemes.bg, "TOP", 0, subTop)
    Addon.fThemes.bg.borderCaption:SetJustifyH("CENTER")
    Addon.fThemes.bg.borderCaption:SetSize(200, 20)
    Addon.fThemes.bg.borderCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.borderCaption:SetText(Addon.localization.BORDER)
    -- BackgroundBorder texture selector

    subTop = subTop - 24
    Addon.fThemes.bg.border = CreateFrame("Button", nil, Addon.fThemes.bg, "IPListBox")
    Addon.fThemes.bg.border:SetSize(250, 30)
    Addon.fThemes.bg.border:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.border:SetList(getBorderList, theme.main.border.texture)
    Addon.fThemes.bg.border:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:ChangeDecor('main', 'border', key, true)
        end,
        OnCancel = function(self)
            Addon:ChangeDecor('main', 'border', theme.main.border.texture)
        end,
        OnSelect = function(self, key, text)
            Addon:ChangeDecor('main', 'border', key)
        end,
    })
    Addon.fThemes.bg.border:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)

    -- BackgroundBorder color picker
    Addon.fThemes.bg.borderColor = CreateFrame("Button", nil, Addon.fThemes.bg, "IPColorButton")
    Addon.fThemes.bg.borderColor:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.borderColor:SetBackdropColor(.5,0,0, 1)
    Addon.fThemes.bg.borderColor:SetCallback(function(self, r, g, b, a)
        Addon:ChangeDecor('main', 'borderColor', {r=r, g=g, b=b, a=a})
    end)
    Addon.fThemes.bg.borderColor:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)

    -- BackgroundBorder Size slider
    subTop = subTop - 46
    Addon.fThemes.bg.borderSize = CreateFrame("Slider", nil, Addon.fThemes.bg, "IPOptionsSlider")
    Addon.fThemes.bg.borderSize:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.borderSize:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.borderSize:SetOrientation('HORIZONTAL')
    Addon.fThemes.bg.borderSize:SetMinMaxValues(1, 30)
    Addon.fThemes.bg.borderSize:SetValueStep(1.0)
    Addon.fThemes.bg.borderSize:SetObeyStepOnDrag(true)
    Addon.fThemes.bg.borderSize.Low:SetText('1')
    Addon.fThemes.bg.borderSize.High:SetText('30')
    Addon.fThemes.bg.borderSize:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderSize.Text:SetText(Addon.localization.BRDERWIDTH .. " (" .. value .. ")")
        Addon:ChangeDecor('main', 'borderSize', value)
    end)
    Addon.fThemes.bg.borderSize:SetScript('OnMouseWheel', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderSize.Text:SetText(Addon.localization.BRDERWIDTH .. " (" .. value .. ")")
        Addon:ChangeDecor('main', 'borderSize', value)
    end)
    Addon.fThemes.bg.borderSize:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)
    Addon.fThemes.bg.borderSize:SetValue(theme.main.border.size)
    Addon.fThemes.bg:SetHeight((subTop - 40) * -1)

    top = top - Addon.fThemes.bg:GetHeight() - 47
    for i, params in ipairs(Addon.frames) do
        Addon:RenderFieldSet(params, theme.elements[params.label])
    end

-- Decors
    top = top - 20
    -- Themes caption
    Addon.fThemes.decorCaption = Addon.fThemes.fContent:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.decorCaption:SetPoint("CENTER", Addon.fThemes.fContent, "TOP", 0, top)
    Addon.fThemes.decorCaption:SetJustifyH("CENTER")
    Addon.fThemes.decorCaption:SetSize(250, 20)
    Addon.fThemes.decorCaption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fThemes.decorCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.decorCaption:SetText(Addon.localization.DECORELEMS)
    top = top - 40

    Addon.fThemes.decors = {}
    if #IPMTTheme[IPMTOptions.theme].decors then
        for decorID, info in ipairs(IPMTTheme[IPMTOptions.theme].decors) do
            Addon:RenderDecorEditor(decorID)
        end
    end

    -- Clear database button
    Addon.fThemes.addDecor = CreateFrame("Button", nil, Addon.fThemes.fContent, "IPButton")
    Addon.fThemes.addDecor:SetPoint("CENTER", Addon.fThemes.fContent, "BOTTOM", 0, 42)
    Addon.fThemes.addDecor:SetSize(220, 30)
    Addon.fThemes.addDecor:SetText(Addon.localization.ADDELEMENT)
    Addon.fThemes.addDecor:SetScript("OnClick", function(self)
        Addon:AddDecor()
    end)

    Addon:RecalcThemesHeight()
end

local decorOuterHeight = 0
function Addon:RecalcThemesHeight()
    local decorsHeight = (decorOuterHeight + 47) * #IPMTTheme[IPMTOptions.theme].decors
    Addon.fThemes.fContent:SetSize(320, (top - 52) * -1 + decorsHeight)
end

function Addon:RenderFieldSet(frameParams, elemInfo)
    local frame = frameParams.label
    Addon.fThemes[frame] = CreateFrame("Frame", nil, Addon.fThemes.fContent, "IPFieldSet")
    Addon.fThemes[frame]:SetHeight(240)
    Addon.fThemes[frame]:SetFrameStrata("MEDIUM")
    Addon.fThemes[frame]:SetPoint("TOPLEFT", Addon.fThemes.fContent, "TOPLEFT", 10, top)
    Addon.fThemes[frame]:SetPoint("TOPRIGHT", Addon.fThemes.fContent, "TOPRIGHT", -10, top)
    Addon.fThemes[frame]:SetText(frameParams.name)
    Addon.fThemes[frame]:SetFont(Addon.DECOR_FONT, 16 + Addon.DECOR_FONTSIZE_DELTA)
    Addon.fThemes[frame]:HookScript("OnEnter", function(self)
        if not IPMTTheme[IPMTOptions.theme].elements[frame].hidden and not Addon.fMain[frame].isMovable then
            Addon.fMain[frame]:SetBackdropColor(1,1,1, .15)
        end
    end)
    Addon.fThemes[frame]:HookScript("OnLeave", function(self)
        if not IPMTTheme[IPMTOptions.theme].elements[frame].hidden and not Addon.fMain[frame].isMovable then
            Addon.fMain[frame]:SetBackdropColor(1,1,1, 0)
        end
    end)

    local subTop = -30
    -- Toggle Visible button
    Addon.fThemes[frame].toggle = CreateFrame("Button", nil, Addon.fThemes[frame], BackdropTemplateMixin and "BackdropTemplate")
    Addon.fThemes[frame].toggle:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
    Addon.fThemes[frame].toggle:SetSize(20, 20)
    Addon.fThemes[frame].toggle:SetBackdrop(Addon.backdrop)
    Addon.fThemes[frame].toggle:SetBackdropColor(0,0,0, 0)
    Addon.fThemes[frame].toggle:SetScript("OnClick", function(self)
        Addon:ToggleVisible(frame)
    end)
    Addon.fThemes[frame].toggle:SetScript("OnEnter", function(self, event, ...)
        Addon:HoverVisible(frame, self)
    end)
    Addon.fThemes[frame].toggle:SetScript("OnLeave", function(self, event, ...)
        Addon:BlurVisible(frame, self)
    end)
    Addon.fThemes[frame].toggle.icon = Addon.fThemes[frame].toggle:CreateTexture()
    Addon.fThemes[frame].toggle.icon:SetSize(20, 20)
    Addon.fThemes[frame].toggle.icon:ClearAllPoints()
    Addon.fThemes[frame].toggle.icon:SetPoint("CENTER", Addon.fThemes[frame].toggle, "CENTER", 0, 0)
    Addon.fThemes[frame].toggle.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fThemes[frame].toggle.icon:SetAlpha(.5)


    -- Toggle Movable button
    Addon.fThemes[frame].moveMode = CreateFrame("Button", nil, Addon.fThemes[frame], BackdropTemplateMixin and "BackdropTemplate")
    Addon.fThemes[frame].moveMode:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -40, subTop)
    Addon.fThemes[frame].moveMode:SetSize(20, 20)
    Addon.fThemes[frame].moveMode:SetBackdrop(Addon.backdrop)
    Addon.fThemes[frame].moveMode:SetBackdropColor(0,0,0, 0)
    Addon.fThemes[frame].moveMode:SetScript("OnClick", function(self)
        Addon:ToggleMovable(frame)
    end)
    Addon.fThemes[frame].moveMode:SetScript("OnEnter", function(self, event, ...)
        Addon:HoverMovable(frame, self)
    end)
    Addon.fThemes[frame].moveMode:SetScript("OnLeave", function(self, event, ...)
        Addon:BlurMovable(frame, self)
    end)
    Addon.fThemes[frame].moveMode.icon = Addon.fThemes[frame].moveMode:CreateTexture()
    Addon.fThemes[frame].moveMode.icon:SetSize(20, 20)
    Addon.fThemes[frame].moveMode.icon:ClearAllPoints()
    Addon.fThemes[frame].moveMode.icon:SetPoint("CENTER", Addon.fThemes[frame].moveMode, "CENTER", 0, 0)
    Addon.fThemes[frame].moveMode.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fThemes[frame].moveMode.icon:SetVertexColor(1, 1, 1)
    Addon.fThemes[frame].moveMode.icon:SetAlpha(.5)
    Addon.fThemes[frame].moveMode.icon:SetTexCoord(.25, .5, .5, 1)

    if frameParams.hasText then
        if elemInfo.color ~= nil then
            local colorInfo = Addon:CopyObject(elemInfo.color)
            if colorInfo.r ~= nil then
                colorInfo = {
                    [-1] = colorInfo,
                }
            end
            Addon.fThemes[frame].colorCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            Addon.fThemes[frame].colorCaption:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
            Addon.fThemes[frame].colorCaption:SetJustifyH("LEFT")
            Addon.fThemes[frame].colorCaption:SetSize(65, 20)
            Addon.fThemes[frame].colorCaption:SetTextColor(1, 1, 1)
            Addon.fThemes[frame].colorCaption:SetText(Addon.localization.COLOR)
            -- Color
            Addon.fThemes[frame].color = {}
            for i = -1,2 do
                if colorInfo[i] ~= nil then
                    Addon.fThemes[frame].color[i] = CreateFrame("Button", nil, Addon.fThemes[frame], "IPColorButton")
                    Addon.fThemes[frame].color[i]:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 90 + (i+1)*30, subTop)
                    Addon.fThemes[frame].color[i]:SetBackdropColor(.5,0,0, 1)
                    Addon.fThemes[frame].color[i]:SetCallback(function(self, r, g, b, a)
                        Addon:SetColor(frame, {r=r, g=g, b=b, a=a}, i)
                    end)
                    Addon.fThemes[frame].color[i]:ColorChange(colorInfo[i].r, colorInfo[i].g, colorInfo[i].b, colorInfo[i].a, true)
                    Addon.fThemes[frame].color[i]:HookScript("OnEnter", function(self)
                        Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
                        if frameParams.colors ~= nil and frameParams.colors[i] ~= nil then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetText(params.colors[i], .9, .9, 0, 1, true)
                            GameTooltip:Show()
                        end
                    end)
                    if frameParams.colors ~= nil and frameParams.colors[i] ~= nil then
                        Addon.fThemes[frame].color[i]:HookScript("OnLeave", function(self)
                            GameTooltip:Hide()
                        end)
                    end
                end
            end
        end

        -- FontSize
        subTop = subTop - 46
        Addon.fThemes[frame].fontSize = CreateFrame("Slider", nil, Addon.fThemes[frame], "IPOptionsSlider")
        Addon.fThemes[frame].fontSize:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
        Addon.fThemes[frame].fontSize:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
        Addon.fThemes[frame].fontSize:SetOrientation('HORIZONTAL')
        Addon.fThemes[frame].fontSize:SetMinMaxValues(6, 40)
        Addon.fThemes[frame].fontSize:SetValueStep(1.0)
        Addon.fThemes[frame].fontSize:SetObeyStepOnDrag(true)
        Addon.fThemes[frame].fontSize.Low:SetText('6')
        Addon.fThemes[frame].fontSize.High:SetText('40')
        Addon.fThemes[frame].fontSize:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            self.Text:SetText(Addon.localization.FONTSIZE .. " (" .. value .. ")")
            Addon:SetFontSize(frame, value)
        end)
        Addon.fThemes[frame].fontSize:SetScript('OnMouseWheel', function(self)
            local value = self:GetValue()
            self.Text:SetText(Addon.localization.FONTSIZE .. " (" .. value .. ")")
            Addon:SetFontSize(frame, value)
        end)
        Addon.fThemes[frame].fontSize:HookScript("OnEnter", function(self)
            Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
        end)
        Addon.fThemes[frame].fontSize:SetValue(elemInfo.fontSize)
    end
    if frameParams.hasIcons then
        -- Icon Size
        subTop = subTop - 46
        Addon.fThemes[frame].iconSize = CreateFrame("Slider", nil, Addon.fThemes[frame], "IPOptionsSlider")
        Addon.fThemes[frame].iconSize:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
        Addon.fThemes[frame].iconSize:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
        Addon.fThemes[frame].iconSize:SetOrientation('HORIZONTAL')
        Addon.fThemes[frame].iconSize:SetMinMaxValues(10, 40)
        Addon.fThemes[frame].iconSize:SetValueStep(1.0)
        Addon.fThemes[frame].iconSize:SetObeyStepOnDrag(true)
        Addon.fThemes[frame].iconSize.Low:SetText('10')
        Addon.fThemes[frame].iconSize.High:SetText('40')
        Addon.fThemes[frame].iconSize:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            Addon.fThemes[frame].iconSize.Text:SetText(Addon.localization.ICONSIZE .. " (" .. value .. ")")
            Addon:SetIconSize(frame, value)
        end)
        Addon.fThemes[frame].iconSize:SetScript('OnMouseWheel', function(self)
            local value = self:GetValue()
            Addon.fThemes[frame].iconSize.Text:SetText(Addon.localization.ICONSIZE .. " (" .. value .. ")")
            Addon:SetIconSize(frame, value)
        end)
        Addon.fThemes[frame].iconSize:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        Addon.fThemes[frame].iconSize:SetValue(elemInfo.iconSize)
    end

    Addon.fThemes[frame]:SetHeight((subTop - 40) * -1)

    top = top - Addon.fThemes[frame]:GetHeight() - 47
end


function Addon:RenderDecorEditor(decorID)
    local decorInfo = IPMTTheme[IPMTOptions.theme].decors[decorID]
    if Addon.fThemes.decors[decorID] == nil then
        local decorTop = top - (decorOuterHeight + 47) * (decorID - 1)
        Addon.fThemes.decors[decorID] = CreateFrame("Frame", nil, Addon.fThemes.fContent, "IPFieldSet")
        Addon.fThemes.decors[decorID]:SetHeight(240)
        Addon.fThemes.decors[decorID]:SetFrameStrata("MEDIUM")
        Addon.fThemes.decors[decorID]:SetPoint("TOPLEFT", Addon.fThemes.fContent, "TOPLEFT", 10, decorTop)
        Addon.fThemes.decors[decorID]:SetPoint("TOPRIGHT", Addon.fThemes.fContent, "TOPRIGHT", -10, decorTop)
        Addon.fThemes.decors[decorID].fTextBG:Hide()

        local subTop = -30
        -- Remove button
        Addon.fThemes.decors[decorID].remove = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fThemes.decors[decorID].remove:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].remove:SetSize(20, 20)
        Addon.fThemes.decors[decorID].remove:SetBackdrop(Addon.backdrop)
        Addon.fThemes.decors[decorID].remove:SetBackdropColor(0,0,0, 0)
        Addon.fThemes.decors[decorID].remove:SetScript("OnClick", function(self)
            Addon:RemoveDecor(decorID)
        end)
        Addon.fThemes.decors[decorID].remove:SetScript("OnEnter", function(self, event, ...)
            Addon:HoverDecor(decorID, self)
        end)
        Addon.fThemes.decors[decorID].remove:SetScript("OnLeave", function(self, event, ...)
            Addon:BlurDecor(decorID, self)
        end)
        Addon.fThemes.decors[decorID].remove.icon = Addon.fThemes.decors[decorID].remove:CreateTexture()
        Addon.fThemes.decors[decorID].remove.icon:SetSize(20, 20)
        Addon.fThemes.decors[decorID].remove.icon:ClearAllPoints()
        Addon.fThemes.decors[decorID].remove.icon:SetPoint("CENTER", Addon.fThemes.decors[decorID].remove, "CENTER", 0, 0)
        Addon.fThemes.decors[decorID].remove.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
        Addon.fThemes.decors[decorID].remove.icon:SetAlpha(.5)
        Addon.fThemes.decors[decorID].remove.icon:SetTexCoord(.75, 1, 0, .5)

        -- Toggle Visible button
        Addon.fThemes.decors[decorID].toggle = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fThemes.decors[decorID].toggle:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].toggle:SetSize(20, 20)
        Addon.fThemes.decors[decorID].toggle:SetBackdrop(Addon.backdrop)
        Addon.fThemes.decors[decorID].toggle:SetBackdropColor(0,0,0, 0)
        Addon.fThemes.decors[decorID].toggle:SetScript("OnClick", function(self)
            Addon:ToggleVisible(decorID)
        end)
        Addon.fThemes.decors[decorID].toggle:SetScript("OnEnter", function(self, event, ...)
            Addon:HoverVisible(decorID, self)
        end)
        Addon.fThemes.decors[decorID].toggle:SetScript("OnLeave", function(self, event, ...)
            Addon:BlurVisible(decorID, self)
        end)
        Addon.fThemes.decors[decorID].toggle.icon = Addon.fThemes.decors[decorID].toggle:CreateTexture()
        Addon.fThemes.decors[decorID].toggle.icon:SetSize(20, 20)
        Addon.fThemes.decors[decorID].toggle.icon:ClearAllPoints()
        Addon.fThemes.decors[decorID].toggle.icon:SetPoint("CENTER", Addon.fThemes.decors[decorID].toggle, "CENTER", 0, 0)
        Addon.fThemes.decors[decorID].toggle.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
        Addon.fThemes.decors[decorID].toggle.icon:SetAlpha(.5)


        -- Toggle Movable button
        Addon.fThemes.decors[decorID].moveMode = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fThemes.decors[decorID].moveMode:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -40, subTop)
        Addon.fThemes.decors[decorID].moveMode:SetSize(20, 20)
        Addon.fThemes.decors[decorID].moveMode:SetBackdrop(Addon.backdrop)
        Addon.fThemes.decors[decorID].moveMode:SetBackdropColor(0,0,0, 0)
        Addon.fThemes.decors[decorID].moveMode:SetScript("OnClick", function(self)
            Addon:ToggleMovable(decorID)
        end)
        Addon.fThemes.decors[decorID].moveMode:SetScript("OnEnter", function(self, event, ...)
            Addon:HoverMovable(decorID, self)
        end)
        Addon.fThemes.decors[decorID].moveMode:SetScript("OnLeave", function(self, event, ...)
            Addon:BlurMovable(decorID, self)
        end)
        Addon.fThemes.decors[decorID].moveMode.icon = Addon.fThemes.decors[decorID].moveMode:CreateTexture()
        Addon.fThemes.decors[decorID].moveMode.icon:SetSize(20, 20)
        Addon.fThemes.decors[decorID].moveMode.icon:ClearAllPoints()
        Addon.fThemes.decors[decorID].moveMode.icon:SetPoint("CENTER", Addon.fThemes.decors[decorID].moveMode, "CENTER", 0, 0)
        Addon.fThemes.decors[decorID].moveMode.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
        Addon.fThemes.decors[decorID].moveMode.icon:SetVertexColor(1, 1, 1)
        Addon.fThemes.decors[decorID].moveMode.icon:SetAlpha(.5)
        Addon.fThemes.decors[decorID].moveMode.icon:SetTexCoord(.25, .5, .5, 1)

        subTop = subTop - 40
        -- Background width caption
        Addon.fThemes.decors[decorID].widthCaption = Addon.fThemes.decors[decorID]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes.decors[decorID].widthCaption:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOP", -80, subTop)
        Addon.fThemes.decors[decorID].widthCaption:SetJustifyH("RIGHT")
        Addon.fThemes.decors[decorID].widthCaption:SetSize(70, 20)
        Addon.fThemes.decors[decorID].widthCaption:SetTextColor(1, 1, 1)
        Addon.fThemes.decors[decorID].widthCaption:SetText(Addon.localization.WIDTH)
        -- Background width edit box
        Addon.fThemes.decors[decorID].width = CreateFrame("EditBox", nil, Addon.fThemes.decors[decorID], "IPEditBox")
        Addon.fThemes.decors[decorID].width:SetAutoFocus(false)
        Addon.fThemes.decors[decorID].width:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOP", -10, subTop)
        Addon.fThemes.decors[decorID].width:SetSize(60, 30)
        Addon.fThemes.decors[decorID].width:SetMaxLetters(4)
        Addon.fThemes.decors[decorID].width:SetScript('OnTextChanged', function(self)
            Addon:ChangeDecor(decorID, 'width', self:GetText())
        end)
        -- Background height caption
        Addon.fThemes.decors[decorID].heightCaption = Addon.fThemes.decors[decorID]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes.decors[decorID].heightCaption:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -80, subTop)
        Addon.fThemes.decors[decorID].heightCaption:SetJustifyH("RIGHT")
        Addon.fThemes.decors[decorID].heightCaption:SetSize(70, 20)
        Addon.fThemes.decors[decorID].heightCaption:SetTextColor(1, 1, 1)
        Addon.fThemes.decors[decorID].heightCaption:SetText(Addon.localization.HEIGHT)
        -- Background height edit box
        Addon.fThemes.decors[decorID].height = CreateFrame("EditBox", nil, Addon.fThemes.decors[decorID], "IPEditBox")
        Addon.fThemes.decors[decorID].height:SetAutoFocus(false)
        Addon.fThemes.decors[decorID].height:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].height:SetSize(60, 30)
        Addon.fThemes.decors[decorID].height:SetMaxLetters(4)
        Addon.fThemes.decors[decorID].height:SetScript('OnTextChanged', function(self)
            Addon:ChangeDecor(decorID, 'height', self:GetText())
        end)

        -- Background texture caption
        subTop = subTop - 30
        Addon.fThemes.decors[decorID].textureCaption = Addon.fThemes.decors[decorID]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes.decors[decorID].textureCaption:SetPoint("CENTER", Addon.fThemes.decors[decorID], "TOP", 0, subTop)
        Addon.fThemes.decors[decorID].textureCaption:SetJustifyH("CENTER")
        Addon.fThemes.decors[decorID].textureCaption:SetSize(200, 20)
        Addon.fThemes.decors[decorID].textureCaption:SetTextColor(1, 1, 1)
        Addon.fThemes.decors[decorID].textureCaption:SetText(Addon.localization.TEXTURE)

        -- Background texture selector
        subTop = subTop - 24
        Addon.fThemes.decors[decorID].texture = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], "IPListBox")
        Addon.fThemes.decors[decorID].texture:SetSize(250, 30)
        Addon.fThemes.decors[decorID].texture:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].texture:SetList(getTextureList, decorInfo.background.texture)
        Addon.fThemes.decors[decorID].texture:SetCallback({
            OnHoverItem = function(self, fItem, key, text)
                Addon:ChangeDecor(decorID, 'texture', key, true)
            end,
            OnCancel = function(self)
                Addon:ChangeDecor(decorID, 'texture', decorInfo.background.texture)
            end,
            OnSelect = function(self, key, text)
                Addon:ChangeDecor(decorID, 'texture', key)
            end,
        })
        Addon.fThemes.decors[decorID].texture:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        -- Background color picker
        Addon.fThemes.decors[decorID].color = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], "IPColorButton")
        Addon.fThemes.decors[decorID].color:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].color:SetBackdropColor(.5,0,0, 1)
        Addon.fThemes.decors[decorID].color:SetCallback(function(self, r, g, b, a)
            Addon:ChangeDecor(decorID, 'color', {r=r, g=g, b=b, a=a})
        end)
        Addon.fThemes.decors[decorID].color:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        -- BackgroundBorder Inset slider
        subTop = subTop - 46
        Addon.fThemes.decors[decorID].borderInset = CreateFrame("Slider", nil, Addon.fThemes.decors[decorID], "IPOptionsSlider")
        Addon.fThemes.decors[decorID].borderInset:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].borderInset:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].borderInset:SetOrientation('HORIZONTAL')
        Addon.fThemes.decors[decorID].borderInset:SetMinMaxValues(0, 30)
        Addon.fThemes.decors[decorID].borderInset:SetValueStep(1.0)
        Addon.fThemes.decors[decorID].borderInset:SetObeyStepOnDrag(true)
        Addon.fThemes.decors[decorID].borderInset.Low:SetText('0')
        Addon.fThemes.decors[decorID].borderInset.High:SetText('30')
        Addon.fThemes.decors[decorID].borderInset:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            self.Text:SetText(Addon.localization.TXTRINDENT .. " (" .. value .. ")")
            Addon:ChangeDecor(decorID, 'borderInset', value)
        end)
        Addon.fThemes.decors[decorID].borderInset:SetScript('OnMouseWheel', function(self)
            local value = self:GetValue()
            Addon.fThemes.decors[decorID].borderInset.Text:SetText(Addon.localization.TXTRINDENT .. " (" .. value .. ")")
            Addon:ChangeDecor(decorID, 'borderInset', value)
        end)
        Addon.fThemes.decors[decorID].borderInset:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        Addon.fThemes.decors[decorID].borderInset:SetValue(decorInfo.border.inset)

        -- BackgroundBorder texture caption
        subTop = subTop - 30
        Addon.fThemes.decors[decorID].borderCaption = Addon.fThemes.decors[decorID]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes.decors[decorID].borderCaption:SetPoint("CENTER", Addon.fThemes.decors[decorID], "TOP", 0, subTop)
        Addon.fThemes.decors[decorID].borderCaption:SetJustifyH("CENTER")
        Addon.fThemes.decors[decorID].borderCaption:SetSize(200, 20)
        Addon.fThemes.decors[decorID].borderCaption:SetTextColor(1, 1, 1)
        Addon.fThemes.decors[decorID].borderCaption:SetText(Addon.localization.BORDER)
        -- BackgroundBorder texture selector

        subTop = subTop - 24
        Addon.fThemes.decors[decorID].border = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], "IPListBox")
        Addon.fThemes.decors[decorID].border:SetSize(250, 30)
        Addon.fThemes.decors[decorID].border:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].border:SetList(getBorderList, decorInfo.border.texture)
        Addon.fThemes.decors[decorID].border:SetCallback({
            OnHoverItem = function(self, fItem, key, text)
                Addon:ChangeDecor(decorID, 'border', key, true)
            end,
            OnCancel = function(self)
                Addon:ChangeDecor(decorID, 'border', decorInfo.border.texture)
            end,
            OnSelect = function(self, key, text)
                Addon:ChangeDecor(decorID, 'border', key)
            end,
        })
        Addon.fThemes.decors[decorID].border:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)

        -- BackgroundBorder color picker
        Addon.fThemes.decors[decorID].borderColor = CreateFrame("Button", nil, Addon.fThemes.decors[decorID], "IPColorButton")
        Addon.fThemes.decors[decorID].borderColor:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].borderColor:SetBackdropColor(.5,0,0, 1)
        Addon.fThemes.decors[decorID].borderColor:SetCallback(function(self, r, g, b, a)
            Addon:ChangeDecor(decorID, 'borderColor', {r=r, g=g, b=b, a=a})
        end)
        Addon.fThemes.decors[decorID].borderColor:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)

        -- BackgroundBorder Size slider
        subTop = subTop - 46
        Addon.fThemes.decors[decorID].borderSize = CreateFrame("Slider", nil, Addon.fThemes.decors[decorID], "IPOptionsSlider")
        Addon.fThemes.decors[decorID].borderSize:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].borderSize:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].borderSize:SetOrientation('HORIZONTAL')
        Addon.fThemes.decors[decorID].borderSize:SetMinMaxValues(1, 30)
        Addon.fThemes.decors[decorID].borderSize:SetValueStep(1.0)
        Addon.fThemes.decors[decorID].borderSize:SetObeyStepOnDrag(true)
        Addon.fThemes.decors[decorID].borderSize.Low:SetText('1')
        Addon.fThemes.decors[decorID].borderSize.High:SetText('30')
        Addon.fThemes.decors[decorID].borderSize:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            Addon.fThemes.decors[decorID].borderSize.Text:SetText(Addon.localization.BRDERWIDTH .. " (" .. value .. ")")
            Addon:ChangeDecor(decorID, 'borderSize', value)
        end)
        Addon.fThemes.decors[decorID].borderSize:SetScript('OnMouseWheel', function(self)
            local value = self:GetValue()
            Addon.fThemes.decors[decorID].borderSize.Text:SetText(Addon.localization.BRDERWIDTH .. " (" .. value .. ")")
            Addon:ChangeDecor(decorID, 'borderSize', value)
        end)
        Addon.fThemes.decors[decorID].borderSize:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        if decorOuterHeight == 0 then
            decorOuterHeight = (subTop - 40) * -1
        end
        Addon.fThemes.decors[decorID]:SetHeight(decorOuterHeight)
    end

    Addon.fThemes.decors[decorID]:Show()
    Addon.fThemes.decors[decorID].texture:SelectItem(decorInfo.background.texture)
    Addon.fThemes.decors[decorID].color:ColorChange(decorInfo.background.color.r, decorInfo.background.color.g, decorInfo.background.color.b, decorInfo.background.color.a, true)
    Addon.fThemes.decors[decorID].border:SelectItem(decorInfo.border.texture)
    Addon.fThemes.decors[decorID].borderInset:SetValue(decorInfo.border.inset)
    Addon.fThemes.decors[decorID].borderSize:SetValue(decorInfo.border.size)
    Addon.fThemes.decors[decorID].borderColor:ColorChange(decorInfo.border.color.r, decorInfo.border.color.g, decorInfo.border.color.b, decorInfo.border.color.a, true)
    Addon.fThemes.decors[decorID].width:SetText(decorInfo.size.w)
    Addon.fThemes.decors[decorID].height:SetText(decorInfo.size.h)

    Addon:ToggleVisible(decorID, true)
    Addon:RecalcThemesHeight()
end