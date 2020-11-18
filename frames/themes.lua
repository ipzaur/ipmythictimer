local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

function Addon:RenderThemeEditor()
    local theme = IPMTTheme[IPMTOptions.theme]

    -- Themes Frame
    Addon.fThemes = CreateFrame("ScrollFrame", "IPMTThemes", Addon.fOptions, "IPScrollBox")
    Addon.fThemes:SetFrameStrata("MEDIUM")
    Addon.fThemes:SetWidth(340)
    Addon.fThemes:SetPoint("TOPLEFT", Addon.fOptions, "TOPLEFT", Addon.fOptions.common:GetWidth() + 30, -40)
    Addon.fThemes:SetPoint("BOTTOMLEFT", Addon.fOptions, "BOTTOMLEFT", Addon.fOptions.common:GetWidth() + 30, 20)
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
    Addon.fThemes.caption:SetText('Редактирование темы')

    local top = -22

    -- Name caption
    Addon.fThemes.nameCaption = Addon.fThemes.fContent:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.nameCaption:SetPoint("CENTER", Addon.fThemes.fContent, "TOP", 0, top)
    Addon.fThemes.nameCaption:SetJustifyH("CENTER")
    Addon.fThemes.nameCaption:SetSize(200, 20)
    Addon.fThemes.nameCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.nameCaption:SetText('Название темы')
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
    local function getFontList()
        local fontList = LSM:List('font')
        local list = {}
        for i,font in pairs(fontList) do
            local filepath = LSM:Fetch('font', font)
            list[filepath] = font
        end
        return list
    end
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
    Addon.fThemes.bg:SetText("Фон")
    Addon.fThemes.bg:SetFont(Addon.DECOR_FONT, 16 + Addon.DECOR_FONTSIZE_DELTA)

    local subTop = -40
    -- Background width caption
    Addon.fThemes.bg.widthCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.widthCaption:SetPoint("RIGHT", Addon.fThemes.bg, "TOP", -80, subTop)
    Addon.fThemes.bg.widthCaption:SetJustifyH("RIGHT")
    Addon.fThemes.bg.widthCaption:SetSize(70, 20)
    Addon.fThemes.bg.widthCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.widthCaption:SetText('Ширина')
    -- Background width edit box
    Addon.fThemes.bg.width = CreateFrame("EditBox", nil, Addon.fThemes.bg, "IPEditBox")
    Addon.fThemes.bg.width:SetAutoFocus(false)
    Addon.fThemes.bg.width:SetPoint("RIGHT", Addon.fThemes.bg, "TOP", -10, subTop)
    Addon.fThemes.bg.width:SetSize(60, 30)
    Addon.fThemes.bg.width:SetMaxLetters(4)
    Addon.fThemes.bg.width:SetScript('OnTextChanged', function(self)
        Addon:ChangeMain('width', self:GetText())
    end)
    -- Background height caption
    Addon.fThemes.bg.heightCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.heightCaption:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -80, subTop)
    Addon.fThemes.bg.heightCaption:SetJustifyH("RIGHT")
    Addon.fThemes.bg.heightCaption:SetSize(70, 20)
    Addon.fThemes.bg.heightCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.heightCaption:SetText('Высота')
    -- Background height edit box
    Addon.fThemes.bg.height = CreateFrame("EditBox", nil, Addon.fThemes.bg, "IPEditBox")
    Addon.fThemes.bg.height:SetAutoFocus(false)
    Addon.fThemes.bg.height:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.height:SetSize(60, 30)
    Addon.fThemes.bg.height:SetMaxLetters(4)
    Addon.fThemes.bg.height:SetScript('OnTextChanged', function(self)
        Addon:ChangeMain('height', self:GetText())
    end)

    -- Background texture caption
    subTop = subTop - 30
    Addon.fThemes.bg.textureCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.bg.textureCaption:SetPoint("CENTER", Addon.fThemes.bg, "TOP", 0, subTop)
    Addon.fThemes.bg.textureCaption:SetJustifyH("CENTER")
    Addon.fThemes.bg.textureCaption:SetSize(200, 20)
    Addon.fThemes.bg.textureCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.bg.textureCaption:SetText('Текстура')
    -- Background texture selector
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
    subTop = subTop - 24
    Addon.fThemes.bg.texture = CreateFrame("Button", nil, Addon.fThemes.bg, "IPListBox")
    Addon.fThemes.bg.texture:SetSize(250, 30)
    Addon.fThemes.bg.texture:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.texture:SetList(getTextureList, theme.main.background.texture)
    Addon.fThemes.bg.texture:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:ChangeMain('texture', key, true)
        end,
        OnCancel = function(self)
            Addon:ChangeMain('texture', theme.main.background.texture)
        end,
        OnSelect = function(self, key, text)
            Addon:ChangeMain('texture', key)
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
        Addon:ChangeMain('color', {r=r, g=g, b=b, a=a})
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
        Addon.fThemes.bg.borderInset.Text:SetText("Отступ текстуры (" .. value .. ")")
        Addon:ChangeMain('borderInset', value)
    end)
    Addon.fThemes.bg.borderInset:SetScript('OnMouseWheel', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderInset.Text:SetText("Отступ текстуры (" .. value .. ")")
        Addon:ChangeMain('borderInset', value)
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
    Addon.fThemes.bg.borderCaption:SetText('Рамка')
    -- BackgroundBorder texture selector
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
    subTop = subTop - 24
    Addon.fThemes.bg.border = CreateFrame("Button", nil, Addon.fThemes.bg, "IPListBox")
    Addon.fThemes.bg.border:SetSize(250, 30)
    Addon.fThemes.bg.border:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.border:SetList(getBorderList, theme.main.border.texture)
    Addon.fThemes.bg.border:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:ChangeMain('border', key, true)
        end,
        OnCancel = function(self)
            Addon:ChangeMain('border', theme.main.border.texture)
        end,
        OnSelect = function(self, key, text)
            Addon:ChangeMain('border', key)
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
        Addon:ChangeMain('borderColor', {r=r, g=g, b=b, a=a})
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
        Addon.fThemes.bg.borderSize.Text:SetText("Толщина рамки (" .. value .. ")")
        Addon:ChangeMain('borderSize', value)
    end)
    Addon.fThemes.bg.borderSize:SetScript('OnMouseWheel', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderSize.Text:SetText("Толщина рамки (" .. value .. ")")
        Addon:ChangeMain('borderSize', value)
    end)
    Addon.fThemes.bg.borderSize:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)
    Addon.fThemes.bg.borderSize:SetValue(theme.main.border.size)
    Addon.fThemes.bg:SetHeight((subTop - 40) * -1)

    top = top - Addon.fThemes.bg:GetHeight() - 47
    for i, params in ipairs(Addon.frames) do
        local frame = params.label
        local elemInfo = theme.elements[frame]
        Addon.fThemes[frame] = CreateFrame("Frame", nil, Addon.fThemes.fContent, "IPFieldSet")
        Addon.fThemes[frame]:SetHeight(240)
        Addon.fThemes[frame]:SetFrameStrata("MEDIUM")
        Addon.fThemes[frame]:SetPoint("TOPLEFT", Addon.fThemes.fContent, "TOPLEFT", 10, top)
        Addon.fThemes[frame]:SetPoint("TOPRIGHT", Addon.fThemes.fContent, "TOPRIGHT", -10, top)
        Addon.fThemes[frame]:SetText(params.name)
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

        -- Toggle Visible button
        Addon.fThemes[frame].toggle = CreateFrame("Button", nil, Addon.fThemes[frame], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fThemes[frame].toggle:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, -30)
        Addon.fThemes[frame].toggle:SetSize(20, 20)
        Addon.fThemes[frame].toggle:SetBackdrop(Addon.backdrop)
        Addon.fThemes[frame].toggle:SetBackdropColor(0,0,0, 0)
        Addon.fThemes[frame].toggle:SetScript("OnClick", function(self)
            Addon:ToggleVisible(frame)
        end)
        Addon.fThemes[frame].toggle:SetScript("OnEnter", function(self, event, ...)
            self.icon:SetVertexColor(.9, .9, .9)
            local text
            if IPMTTheme[IPMTOptions.theme].elements[frame].hidden then
                text = 'Показать элемент'
            else
                text = 'Скрыть элемент'
            end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, .9, .9, 0, 1, true)
            GameTooltip:Show()
            Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
        end)
        Addon.fThemes[frame].toggle:SetScript("OnLeave", function(self, event, ...)
            self.icon:SetVertexColor(.5, .5, .5)
            GameTooltip:Hide()
        end)
        Addon.fThemes[frame].toggle.icon = Addon.fThemes[frame].toggle:CreateTexture()
        Addon.fThemes[frame].toggle.icon:SetSize(20, 20)
        Addon.fThemes[frame].toggle.icon:ClearAllPoints()
        Addon.fThemes[frame].toggle.icon:SetPoint("CENTER", Addon.fThemes[frame].toggle, "CENTER", 0, 0)
        Addon.fThemes[frame].toggle.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
        Addon.fThemes[frame].toggle.icon:SetVertexColor(.5, .5, .5)


        -- Toggle Movable button
        Addon.fThemes[frame].moveMode = CreateFrame("Button", nil, Addon.fThemes[frame], BackdropTemplateMixin and "BackdropTemplate")
        Addon.fThemes[frame].moveMode:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -40, -30)
        Addon.fThemes[frame].moveMode:SetSize(20, 20)
        Addon.fThemes[frame].moveMode:SetBackdrop(Addon.backdrop)
        Addon.fThemes[frame].moveMode:SetBackdropColor(0,0,0, 0)
        Addon.fThemes[frame].moveMode:SetScript("OnClick", function(self)
            Addon:ToggleMovable(frame)
        end)
        Addon.fThemes[frame].moveMode:SetScript("OnEnter", function(self, event, ...)
            if not Addon.fMain[frame].isMovable then
                self.icon:SetVertexColor(.9, .9, .9)
            end
            local text
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText('Переместить элемент', .9, .9, 0, 1, true)
            GameTooltip:Show()
            Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
        end)
        Addon.fThemes[frame].moveMode:SetScript("OnLeave", function(self, event, ...)
            if not Addon.fMain[frame].isMovable then
                self.icon:SetVertexColor(.5, .5, .5)
            end
            GameTooltip:Hide()
        end)
        Addon.fThemes[frame].moveMode.icon = Addon.fThemes[frame].moveMode:CreateTexture()
        Addon.fThemes[frame].moveMode.icon:SetSize(20, 20)
        Addon.fThemes[frame].moveMode.icon:ClearAllPoints()
        Addon.fThemes[frame].moveMode.icon:SetPoint("CENTER", Addon.fThemes[frame].moveMode, "CENTER", 0, 0)
        Addon.fThemes[frame].moveMode.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
        Addon.fThemes[frame].moveMode.icon:SetVertexColor(.5, .5, .5)
        Addon.fThemes[frame].moveMode.icon:SetTexCoord(.5, 1, .5, 1)

        subTop = -30
        if params.hasText then
            Addon.fThemes[frame].colorCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            Addon.fThemes[frame].colorCaption:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
            Addon.fThemes[frame].colorCaption:SetJustifyH("LEFT")
            Addon.fThemes[frame].colorCaption:SetSize(70, 20)
            Addon.fThemes[frame].colorCaption:SetTextColor(1, 1, 1)
            Addon.fThemes[frame].colorCaption:SetText('Цвет')
            -- Color
            local colorInfo = Addon:CopyObject(elemInfo.color)
            if colorInfo.r ~= nil then
                colorInfo = {
                    [-1] = colorInfo,
                }
            end
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
                        if params.colors ~= nil and params.colors[i] ~= nil then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetText(params.colors[i], .9, .9, 0, 1, true)
                            GameTooltip:Show()
                        end
                    end)
                    if params.colors ~= nil and params.colors[i] ~= nil then
                        Addon.fThemes[frame].color[i]:HookScript("OnLeave", function(self)
                            GameTooltip:Hide()
                        end)
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
                Addon.fThemes[frame].fontSize.Text:SetText("Размер шрифта (" .. value .. ")")
                Addon:SetFontSize(frame, value)
            end)
            Addon.fThemes[frame].fontSize:SetScript('OnMouseWheel', function(self)
                local value = self:GetValue()
                Addon.fThemes[frame].fontSize.Text:SetText("Размер шрифта (" .. value .. ")")
                Addon:SetFontSize(frame, value)
            end)
            Addon.fThemes[frame].fontSize:HookScript("OnEnter", function(self)
                Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
            end)
            Addon.fThemes[frame].fontSize:SetValue(theme.elements[frame].fontSize)
        end
        if params.hasIcons then
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
                Addon.fThemes[frame].iconSize.Text:SetText("Размер иконки (" .. value .. ")")
                Addon:SetIconSize(frame, value)
            end)
            Addon.fThemes[frame].iconSize:SetScript('OnMouseWheel', function(self)
                local value = self:GetValue()
                Addon.fThemes[frame].iconSize.Text:SetText("Размер иконки (" .. value .. ")")
                Addon:SetIconSize(frame, value)
            end)
            Addon.fThemes[frame].iconSize:HookScript("OnEnter", function(self)
                self:GetParent():OnEnter()
            end)
            Addon.fThemes[frame].iconSize:SetValue(theme.elements[frame].iconSize)
        end
        Addon.fThemes[frame]:SetHeight((subTop - 40) * -1)

        top = top - Addon.fThemes[frame]:GetHeight() - 47
    end

    Addon.fThemes.fContent:SetSize(320, (top - 20) * -1)
end