local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

local justifyHList = {
    CENTER = 'CENTER',
    LEFT   = 'LEFT',
    RIGHT  = 'RIGHT',
}

local justifyVList = {
    MIDDLE = 'MIDDLE',
    TOP    = 'TOP',
    BOTTOM = 'BOTTOM',
}

local GetTextureList = {
    background = function()
        local textureList = LSM:List('background')
        local list = {
            [Addon.DUNGEON_ARTWORK] = ' Dungeon artwork',
        }
        for i,texture in pairs(textureList) do
            local filepath = LSM:Fetch('background', texture)
            if filepath then
                list[filepath] = texture
            end
        end
        return list
    end,
    border = function()
        local borderList = LSM:List('border')
        local list = {
            none = ' None',
        }
        for i,border in pairs(borderList) do
            local filepath = LSM:Fetch('border', border)
            if filepath then
                list[filepath] = border
            end
        end
        return list
    end,
}

local function GetFontList()
    local fontList = LSM:List('font')
    local list = {}
    for i,font in pairs(fontList) do
        local filepath = LSM:Fetch('font', font)
        list[filepath] = font
    end
    return list
end

local top = 0

local function RenderTextureBlock(decorID, subTop, textureType)
    local parent
    if decorID == 'main' then
        parent = Addon.fThemes.bg
    else
        parent = Addon.fThemes.decors[decorID]
    end
    local listName = textureType .. 'List'
    local colorName = textureType .. 'Color'
    local marginRight = 0
    local hoverText
    if textureType == 'background' then
        hoverText = Addon.localization.TEXTURELST
        marginRight = 29
    else
        hoverText = Addon.localization.BORDERLIST
    end
    parent[listName] = CreateFrame("Button", nil, parent, "IPListBox")
    parent[listName]:SetSize(20, 30)
    parent[listName].fText:Hide()
    parent[listName].fTriangle:ClearAllPoints()
    parent[listName].fTriangle:SetPoint("CENTER", parent[listName], "CENTER", 0, 0)
    parent[listName].fTriangle:SetSize(8, 8)
    parent[listName]:SetPoint("LEFT", parent, "TOPLEFT", 10, subTop)
    parent[listName]:SetList(GetTextureList[textureType])
    parent[listName]:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            local params = {
                [textureType] = {
                    texture = key,
                },
            }
            if textureType == 'background' then
                params.background.texSize = {
                    w = 0,
                    h = 0,
                }
                params.background.coords  = {0, 1, 0, 1}
                Addon:CloseTextureEditor()
            end
            Addon:ChangeDecor(decorID, params, true)
        end,
        OnCancel = function(self)
            local original
            if decorID == 'main' then
                original = IPMTTheme[IPMTOptions.theme].main[textureType]
            else
                original = IPMTTheme[IPMTOptions.theme].decors[decorID][textureType]
            end
            local params = {
                [textureType] = {
                    texture = original.texture,
                },
            }
            if textureType == 'background' then
                params.background.texSize = original.texSize
                params.background.coords  = original.coords
            end
            Addon:ChangeDecor(decorID, params)
        end,
        OnSelect = function(self, key, text)
            local byUser = (textureType == 'texture') and parent[listName].opened
            if byUser then
                parent[textureType]:SetFocus()
            end
            parent[textureType]:SetText(key)
            if byUser then
                parent[textureType]:ClearFocus()
            end
        end,
    })
    parent[listName]:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(hoverText, .9, .9, 0, 1, true)
        GameTooltip:Show()
        self:GetParent():OnEnter()
    end)
    parent[listName]:HookScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    -- Background texture input
    parent[textureType] = CreateFrame("EditBox", nil, parent, "IPEditBox")
    parent[textureType]:SetAutoFocus(false)
    parent[textureType]:SetPoint("LEFT", parent, "TOPLEFT", 30, subTop)
    parent[textureType]:SetPoint("RIGHT", parent, "TOPRIGHT", -40 - marginRight, subTop)
    parent[textureType]:SetHeight(30)
    parent[textureType]:SetScript('OnTextChanged', function(self)
        local params = {
            [textureType] = {
                texture = self:GetText(),
            },
        }
        if textureType == 'background' and self:HasFocus() then
            params.background.texSize = {
                w = 0,
                h = 0,
            }
            params.background.coords  = {0, 1, 0, 1}
            Addon:CloseTextureEditor()
        end
        Addon:ChangeDecor(decorID, params)
    end)
    parent[textureType]:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)
    -- Background color picker
    parent[colorName] = CreateFrame("Button", nil, parent, "IPColorButton")
    parent[colorName]:SetPoint("RIGHT", parent, "TOPRIGHT", -10 - marginRight, subTop)
    parent[colorName]:SetBackdropColor(.5,0,0, 1)
    parent[colorName]:SetCallback(function(self, r, g, b, a)
        Addon:ChangeDecor(decorID, {
            [textureType] = {
                color = {r=r, g=g, b=b, a=a},
            },
        })
    end)
    parent[colorName]:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)

    if textureType == 'background' then
        local backdrop = {
            bgFile   = nil,
            edgeFile = nil,
            tile     = false,
            edgeSize = 0,
        }
        -- Texture coords editor toggler
        parent.textureCoords = CreateFrame("Button", nil, parent, "IPButton")
        parent.textureCoords:SetPoint("RIGHT", parent, "TOPRIGHT", -10, subTop)
        parent.textureCoords:SetSize(20, 20)
        parent.textureCoords:SetBackdrop(backdrop)
        parent.textureCoords:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
        parent.textureCoords.fTexture:SetSize(20, 20)
        parent.textureCoords.fTexture:SetTexCoord(0, .25, .5, 1)
        parent.textureCoords.fTexture:SetVertexColor(.75, .75, .75)
        parent.textureCoords:SetScript("OnClick", function(self)
            Addon:ToggleTextureEditor(decorID)
        end)
        parent.textureCoords:HookScript("OnEnter", function(self)
            self.fTexture:SetVertexColor(1, 1, 1)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(Addon.localization.TXTSETTING, .9, .9, 0, 1, true)
            GameTooltip:Show()
            self:GetParent():OnEnter()
        end)
        parent.textureCoords:HookScript("OnLeave", function(self)
            self.fTexture:SetVertexColor(.75, .75, .75)
            GameTooltip:Hide()
        end)
    end
end

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
    Addon.fThemes.fFonts:SetList(GetFontList, theme.font)
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

    -- Font style caption
    top = top - 34
    Addon.fThemes.fontStyleCaption = Addon.fThemes.fContent:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.fontStyleCaption:SetPoint("CENTER", Addon.fThemes.fContent, "TOP", 0, top)
    Addon.fThemes.fontStyleCaption:SetJustifyH("CENTER")
    Addon.fThemes.fontStyleCaption:SetSize(200, 20)
    Addon.fThemes.fontStyleCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.fontStyleCaption:SetText(Addon.localization.FONTSTYLE)
    -- Font style selector
    top = top - 24
    Addon.fThemes.fFontStyle = CreateFrame("Button", nil, Addon.fThemes.fContent, "IPListBox")
    Addon.fThemes.fFontStyle:SetHeight(30)
    Addon.fThemes.fFontStyle:SetPoint("LEFT", Addon.fThemes.fContent, "TOPLEFT", 20, top)
    Addon.fThemes.fFontStyle:SetPoint("RIGHT", Addon.fThemes.fContent, "TOPRIGHT", -20, top)
    Addon.fThemes.fFontStyle:SetList(Addon.optionList.fontStyle, theme.fontStyle, true)
    Addon.fThemes.fFontStyle:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:SetFontStyle(key, true)
        end,
        OnCancel = function(self)
            Addon:SetFontStyle(theme.fontStyle)
        end,
        OnSelect = function(self, key, text)
            Addon.fThemes.fFontStyle.fText:SetFont(theme.font, 12, key)
            Addon:SetFontStyle(key)
        end,
        OnRenderItem = function(self, fItem, key, text)
            fItem.fText:SetFont(theme.font, 12, key)
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
    Addon.fThemes.bg.width:SetNumeric(true)
    Addon.fThemes.bg.width:SetMaxLetters(4)
    Addon.fThemes.bg.width:SetScript('OnTextChanged', function(self)
        Addon:ChangeDecor('main', {
            size = {
                w = self:GetText(),
            },
        })
    end)
    Addon.fThemes.bg.width:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
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
    Addon.fThemes.bg.height:SetNumeric(true)
    Addon.fThemes.bg.height:SetMaxLetters(4)
    Addon.fThemes.bg.height:SetScript('OnTextChanged', function(self)
        Addon:ChangeDecor('main', {
            size = {
                h = self:GetText(),
            },
        })
    end)
    Addon.fThemes.bg.height:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
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
    RenderTextureBlock('main', subTop, 'background')

    -- BackgroundBorder Inset slider
    subTop = subTop - 46
    Addon.fThemes.bg.backgroundInset = CreateFrame("Slider", nil, Addon.fThemes.bg, "IPOptionsSlider")
    Addon.fThemes.bg.backgroundInset:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.backgroundInset:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.backgroundInset:SetOrientation('HORIZONTAL')
    Addon.fThemes.bg.backgroundInset:SetMinMaxValues(0, 30)
    Addon.fThemes.bg.backgroundInset:SetValueStep(1.0)
    Addon.fThemes.bg.backgroundInset:EnableMouseWheel(0)
    Addon.fThemes.bg.backgroundInset:SetObeyStepOnDrag(true)
    Addon.fThemes.bg.backgroundInset.Low:SetText('0')
    Addon.fThemes.bg.backgroundInset.High:SetText('30')
    Addon.fThemes.bg.backgroundInset:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.backgroundInset.Text:SetText(Addon.localization.TXTRINDENT .. " (" .. value .. ")")
        Addon:ChangeDecor('main', {
            background = {
                inset = value,
            }
        })
    end)
    Addon.fThemes.bg.backgroundInset:HookScript("OnEnter", function(self)
        self:GetParent():OnEnter()
    end)

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
    RenderTextureBlock('main', subTop, 'border')

    -- BackgroundBorder Size slider
    subTop = subTop - 46
    Addon.fThemes.bg.borderSize = CreateFrame("Slider", nil, Addon.fThemes.bg, "IPOptionsSlider")
    Addon.fThemes.bg.borderSize:SetPoint("LEFT", Addon.fThemes.bg, "TOPLEFT", 10, subTop)
    Addon.fThemes.bg.borderSize:SetPoint("RIGHT", Addon.fThemes.bg, "TOPRIGHT", -10, subTop)
    Addon.fThemes.bg.borderSize:SetOrientation('HORIZONTAL')
    Addon.fThemes.bg.borderSize:SetMinMaxValues(1, 30)
    Addon.fThemes.bg.borderSize:SetValueStep(1.0)
    Addon.fThemes.bg.borderSize:EnableMouseWheel(0)
    Addon.fThemes.bg.borderSize:SetObeyStepOnDrag(true)
    Addon.fThemes.bg.borderSize.Low:SetText('1')
    Addon.fThemes.bg.borderSize.High:SetText('30')
    Addon.fThemes.bg.borderSize:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        Addon.fThemes.bg.borderSize.Text:SetText(Addon.localization.BRDERWIDTH .. " (" .. value .. ")")
        Addon:ChangeDecor('main', {
            border = {
                size = value,
            },
        })
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
    Addon.fThemes.addDecor:SetPoint("CENTER", Addon.fThemes.fContent, "BOTTOM", 0, 440)
    Addon.fThemes.addDecor:SetSize(220, 30)
    Addon.fThemes.addDecor:SetText(Addon.localization.ADDELEMENT)
    Addon.fThemes.addDecor:SetScript("OnClick", function(self)
        Addon:AddDecor()
    end)

    Addon:RenderDeaths(theme.deaths)

    Addon:RecalcThemesHeight()
end

local decorOuterHeight = 0
function Addon:RecalcThemesHeight()
    local decorsHeight = (decorOuterHeight + 47) * #IPMTTheme[IPMTOptions.theme].decors
    Addon.fThemes.fContent:SetSize(320, (top - 52) * -1 + decorsHeight + Addon.fThemes.deaths:GetHeight() + 100)
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

    if frameParams.canResize then
        subTop = subTop - 40
        -- Background width caption
        Addon.fThemes[frame].widthCaption = Addon.fThemes[frame]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes[frame].widthCaption:SetPoint("RIGHT", Addon.fThemes[frame], "TOP", -80, subTop)
        Addon.fThemes[frame].widthCaption:SetJustifyH("RIGHT")
        Addon.fThemes[frame].widthCaption:SetSize(70, 20)
        Addon.fThemes[frame].widthCaption:SetTextColor(1, 1, 1)
        Addon.fThemes[frame].widthCaption:SetText(Addon.localization.WIDTH)
        -- Background width edit box
        Addon.fThemes[frame].width = CreateFrame("EditBox", nil, Addon.fThemes[frame], "IPEditBox")
        Addon.fThemes[frame].width:SetAutoFocus(false)
        Addon.fThemes[frame].width:SetPoint("RIGHT", Addon.fThemes[frame], "TOP", -10, subTop)
        Addon.fThemes[frame].width:SetSize(60, 30)
        Addon.fThemes[frame].width:SetNumeric(true)
        Addon.fThemes[frame].width:SetMaxLetters(4)
        Addon.fThemes[frame].width:SetScript('OnTextChanged', function(self)
            Addon:SetSize(frame, self:GetText(), nil)
        end)
        Addon.fThemes[frame].width:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        -- Background height caption
        Addon.fThemes[frame].heightCaption = Addon.fThemes[frame]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes[frame].heightCaption:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -80, subTop)
        Addon.fThemes[frame].heightCaption:SetJustifyH("RIGHT")
        Addon.fThemes[frame].heightCaption:SetSize(70, 20)
        Addon.fThemes[frame].heightCaption:SetTextColor(1, 1, 1)
        Addon.fThemes[frame].heightCaption:SetText(Addon.localization.HEIGHT)
        -- Background height edit box
        Addon.fThemes[frame].height = CreateFrame("EditBox", nil, Addon.fThemes[frame], "IPEditBox")
        Addon.fThemes[frame].height:SetAutoFocus(false)
        Addon.fThemes[frame].height:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
        Addon.fThemes[frame].height:SetSize(60, 30)
        Addon.fThemes[frame].height:SetNumeric(true)
        Addon.fThemes[frame].height:SetMaxLetters(4)
        Addon.fThemes[frame].height:SetScript('OnTextChanged', function(self)
            Addon:SetSize(frame, nil, self:GetText())
        end)
        Addon.fThemes[frame].height:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        subTop = subTop - 46
    end

    if (frameParams.hasText or frameParams.colors) and elemInfo.color ~= nil then
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
                        GameTooltip:SetText(frameParams.colors[i], .9, .9, 0, 1, true)
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

    if frameParams.hasText then
        -- FontSize
        subTop = subTop - 46
        Addon.fThemes[frame].fontSize = CreateFrame("Slider", nil, Addon.fThemes[frame], "IPOptionsSlider")
        Addon.fThemes[frame].fontSize:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
        Addon.fThemes[frame].fontSize:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
        Addon.fThemes[frame].fontSize:SetOrientation('HORIZONTAL')
        Addon.fThemes[frame].fontSize:SetMinMaxValues(6, 40)
        Addon.fThemes[frame].fontSize:SetValueStep(1.0)
        Addon.fThemes[frame].fontSize:EnableMouseWheel(0)
        Addon.fThemes[frame].fontSize:SetObeyStepOnDrag(true)
        Addon.fThemes[frame].fontSize.Low:SetText('6')
        Addon.fThemes[frame].fontSize.High:SetText('40')
        Addon.fThemes[frame].fontSize:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            self.Text:SetText(Addon.localization.FONTSIZE .. " (" .. value .. ")")
            Addon:SetFontSize(frame, value)
        end)
        Addon.fThemes[frame].fontSize:HookScript("OnEnter", function(self)
            Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
        end)

        -- Justify Horizontal caption
        subTop = subTop - 30
        Addon.fThemes[frame].justifyHCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fThemes[frame].justifyHCaption:SetPoint("CENTER", Addon.fThemes[frame], "TOP", 0, subTop)
        Addon.fThemes[frame].justifyHCaption:SetJustifyH("CENTER")
        Addon.fThemes[frame].justifyHCaption:SetSize(250, 20)
        Addon.fThemes[frame].justifyHCaption:SetTextColor(1, 1, 1)
        Addon.fThemes[frame].justifyHCaption:SetText(Addon.localization.JUSTIFYH)

        -- Justify Horizontal
        subTop = subTop - 24
        Addon.fThemes[frame].justifyH = CreateFrame("Button", nil, Addon.fThemes[frame], "IPListBox")
        Addon.fThemes[frame].justifyH:SetHeight(30)
        Addon.fThemes[frame].justifyH:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
        Addon.fThemes[frame].justifyH:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
        Addon.fThemes[frame].justifyH:SetList(justifyHList)
        Addon.fThemes[frame].justifyH:SetCallback({
            OnHoverItem = function(self, fItem, key, text)
                Addon:SetJustifyH(frame, key, true)
            end,
            OnCancel = function(self)
                Addon:SetJustifyH(frame, elemInfo.justifyH)
            end,
            OnSelect = function(self, key, text)
                Addon:SetJustifyH(frame, key)
            end,
        })
        Addon.fThemes[frame].justifyH:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)

        if frameParams.canAlignV then
            -- Justify Vertical caption
            subTop = subTop - 30
            Addon.fThemes[frame].justifyVCaption = Addon.fThemes.bg:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            Addon.fThemes[frame].justifyVCaption:SetPoint("CENTER", Addon.fThemes[frame], "TOP", 0, subTop)
            Addon.fThemes[frame].justifyVCaption:SetJustifyH("CENTER")
            Addon.fThemes[frame].justifyVCaption:SetSize(250, 20)
            Addon.fThemes[frame].justifyVCaption:SetTextColor(1, 1, 1)
            Addon.fThemes[frame].justifyVCaption:SetText(Addon.localization.JUSTIFYV)

            -- Justify Vertical
            subTop = subTop - 24
            Addon.fThemes[frame].justifyV = CreateFrame("Button", nil, Addon.fThemes[frame], "IPListBox")
            Addon.fThemes[frame].justifyV:SetHeight(30)
            Addon.fThemes[frame].justifyV:SetPoint("LEFT", Addon.fThemes[frame], "TOPLEFT", 10, subTop)
            Addon.fThemes[frame].justifyV:SetPoint("RIGHT", Addon.fThemes[frame], "TOPRIGHT", -10, subTop)
            Addon.fThemes[frame].justifyV:SetList(justifyVList)
            Addon.fThemes[frame].justifyV:SetCallback({
                OnHoverItem = function(self, fItem, key, text)
                    Addon:SetJustifyV(frame, key, true)
                end,
                OnCancel = function(self)
                    Addon:SetJustifyV(frame, elemInfo.justifyV)
                end,
                OnSelect = function(self, key, text)
                    Addon:SetJustifyV(frame, key)
                end,
            })
            Addon.fThemes[frame].justifyV:HookScript("OnEnter", function(self)
                self:GetParent():OnEnter()
            end)
        end

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
        Addon.fThemes[frame].iconSize:EnableMouseWheel(0)
        Addon.fThemes[frame].iconSize:SetObeyStepOnDrag(true)
        Addon.fThemes[frame].iconSize.Low:SetText('10')
        Addon.fThemes[frame].iconSize.High:SetText('40')
        Addon.fThemes[frame].iconSize:SetScript('OnValueChanged', function(self)
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
    if not Addon.opened.themes then
        return
    end
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
            self:GetParent():OnEnter()
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
            self:GetParent():OnEnter()
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
            self:GetParent():OnEnter()
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
        Addon.fThemes.decors[decorID].width:SetNumeric(true)
        Addon.fThemes.decors[decorID].width:SetMaxLetters(4)
        Addon.fThemes.decors[decorID].width:SetScript('OnTextChanged', function(self)
            Addon:ChangeDecor(decorID, {
                size = {
                    w = self:GetText(),
                },
            })
        end)
        Addon.fThemes.decors[decorID].width:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
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
        Addon.fThemes.decors[decorID].height:SetNumeric(true)
        Addon.fThemes.decors[decorID].height:SetMaxLetters(4)
        Addon.fThemes.decors[decorID].height:SetScript('OnTextChanged', function(self)
            Addon:ChangeDecor(decorID, {
                size = {
                    h = self:GetText(),
                },
            })
        end)
        Addon.fThemes.decors[decorID].height:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
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
        RenderTextureBlock(decorID, subTop, 'background')

        -- BackgroundBorder Inset slider
        subTop = subTop - 46
        Addon.fThemes.decors[decorID].backgroundInset = CreateFrame("Slider", nil, Addon.fThemes.decors[decorID], "IPOptionsSlider")
        Addon.fThemes.decors[decorID].backgroundInset:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].backgroundInset:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].backgroundInset:SetOrientation('HORIZONTAL')
        Addon.fThemes.decors[decorID].backgroundInset:SetMinMaxValues(0, 30)
        Addon.fThemes.decors[decorID].backgroundInset:SetValueStep(1.0)
        Addon.fThemes.decors[decorID].backgroundInset:EnableMouseWheel(0)
        Addon.fThemes.decors[decorID].backgroundInset:SetObeyStepOnDrag(true)
        Addon.fThemes.decors[decorID].backgroundInset.Low:SetText('0')
        Addon.fThemes.decors[decorID].backgroundInset.High:SetText('30')
        Addon.fThemes.decors[decorID].backgroundInset:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            self.Text:SetText(Addon.localization.TXTRINDENT .. " (" .. value .. ")")
            Addon:ChangeDecor(decorID, {
                background = {
                    inset = value,
                }
            })
        end)
        Addon.fThemes.decors[decorID].backgroundInset:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)
        Addon.fThemes.decors[decorID].backgroundInset:SetValue(decorInfo.background.inset)

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
        RenderTextureBlock(decorID, subTop, 'border')

        -- BackgroundBorder Size slider
        subTop = subTop - 46
        Addon.fThemes.decors[decorID].borderSize = CreateFrame("Slider", nil, Addon.fThemes.decors[decorID], "IPOptionsSlider")
        Addon.fThemes.decors[decorID].borderSize:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].borderSize:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].borderSize:SetOrientation('HORIZONTAL')
        Addon.fThemes.decors[decorID].borderSize:SetMinMaxValues(1, 30)
        Addon.fThemes.decors[decorID].borderSize:SetValueStep(1.0)
        Addon.fThemes.decors[decorID].borderSize:EnableMouseWheel(0)
        Addon.fThemes.decors[decorID].borderSize:SetObeyStepOnDrag(true)
        Addon.fThemes.decors[decorID].borderSize.Low:SetText('1')
        Addon.fThemes.decors[decorID].borderSize.High:SetText('30')
        Addon.fThemes.decors[decorID].borderSize:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            Addon.fThemes.decors[decorID].borderSize.Text:SetText(Addon.localization.BRDERWIDTH .. " (" .. value .. ")")
            Addon:ChangeDecor(decorID, {
                border = {
                    size = value,
                },
            })
        end)
        Addon.fThemes.decors[decorID].borderSize:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)

        -- Layer slider
        subTop = subTop - 46
        Addon.fThemes.decors[decorID].layer = CreateFrame("Slider", nil, Addon.fThemes.decors[decorID], "IPOptionsSlider")
        Addon.fThemes.decors[decorID].layer:SetPoint("LEFT", Addon.fThemes.decors[decorID], "TOPLEFT", 10, subTop)
        Addon.fThemes.decors[decorID].layer:SetPoint("RIGHT", Addon.fThemes.decors[decorID], "TOPRIGHT", -10, subTop)
        Addon.fThemes.decors[decorID].layer:SetOrientation('HORIZONTAL')
        Addon.fThemes.decors[decorID].layer:SetMinMaxValues(0, 50)
        Addon.fThemes.decors[decorID].layer:SetValueStep(1.0)
        Addon.fThemes.decors[decorID].layer:EnableMouseWheel(0)
        Addon.fThemes.decors[decorID].layer:SetObeyStepOnDrag(true)
        Addon.fThemes.decors[decorID].layer.Low:SetText('0')
        Addon.fThemes.decors[decorID].layer.High:SetText('50')
        Addon.fThemes.decors[decorID].layer:SetScript('OnValueChanged', function(self)
            local value = self:GetValue()
            Addon.fThemes.decors[decorID].layer.Text:SetText(Addon.localization.LAYER .. " (" .. value .. ")")
            Addon:SetLayer(decorID, value)
        end)
        Addon.fThemes.decors[decorID].layer:HookScript("OnEnter", function(self)
            self:GetParent():OnEnter()
        end)

        if decorOuterHeight == 0 then
            decorOuterHeight = (subTop - 40) * -1
        end
        Addon.fThemes.decors[decorID]:SetHeight(decorOuterHeight)
    end

    Addon.fThemes.decors[decorID]:Show()
    Addon.fThemes.decors[decorID].width:SetText(decorInfo.size.w)
    Addon.fThemes.decors[decorID].height:SetText(decorInfo.size.h)
    Addon.fThemes.decors[decorID].background:SetText(decorInfo.background.texture)
    Addon.fThemes.decors[decorID].backgroundColor:ColorChange(decorInfo.background.color.r, decorInfo.background.color.g, decorInfo.background.color.b, decorInfo.background.color.a, true)
    Addon.fThemes.decors[decorID].backgroundInset:SetValue(decorInfo.background.inset)
    Addon.fThemes.decors[decorID].border:SetText(decorInfo.border.texture)
    Addon.fThemes.decors[decorID].borderSize:SetValue(decorInfo.border.size)
    Addon.fThemes.decors[decorID].borderColor:ColorChange(decorInfo.border.color.r, decorInfo.border.color.g, decorInfo.border.color.b, decorInfo.border.color.a, true)
    Addon.fThemes.decors[decorID].layer:SetValue(decorInfo.layer)

    Addon:ToggleVisible(decorID, true)
    Addon:RecalcThemesHeight()
end


function Addon:RenderDeaths()
    local frame = 'deaths'
    local theme = IPMTTheme[IPMTOptions.theme]
    Addon.fThemes.deaths = CreateFrame("Frame", nil, Addon.fThemes.fContent, "IPFieldSet")
    Addon.fThemes.deaths:SetHeight(310)
    Addon.fThemes.deaths:SetFrameStrata("MEDIUM")
    Addon.fThemes.deaths:SetPoint("BOTTOMLEFT", Addon.fThemes.fContent, "BOTTOMLEFT", 10, 42)
    Addon.fThemes.deaths:SetPoint("BOTTOMRIGHT", Addon.fThemes.fContent, "BOTTOMRIGHT", -10, 42)
    Addon.fThemes.deaths:SetText(Addon.localization.DTHCAPTION)
    Addon.fThemes.deaths:SetFont(Addon.DECOR_FONT, 16 + Addon.DECOR_FONTSIZE_DELTA)

    local subTop = -30
    -- Toggle Visible button
    Addon.fThemes.deaths.toggle = CreateFrame("Button", nil, Addon.fThemes.deaths, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fThemes.deaths.toggle:SetPoint("RIGHT", Addon.fThemes.deaths, "TOPRIGHT", -10, subTop)
    Addon.fThemes.deaths.toggle:SetSize(20, 20)
    Addon.fThemes.deaths.toggle:SetBackdrop(Addon.backdrop)
    Addon.fThemes.deaths.toggle:SetBackdropColor(0,0,0, 0)
    Addon.fThemes.deaths.toggle:SetScript("OnClick", function(self)
        Addon:ToggleVisible(frame)
    end)
    Addon.fThemes.deaths.toggle:SetScript("OnEnter", function(self, event, ...)
        Addon:HoverVisible(frame, self)
    end)
    Addon.fThemes.deaths.toggle:SetScript("OnLeave", function(self, event, ...)
        Addon:BlurVisible(frame, self)
    end)
    Addon.fThemes.deaths.toggle.icon = Addon.fThemes.deaths.toggle:CreateTexture()
    Addon.fThemes.deaths.toggle.icon:SetSize(20, 20)
    Addon.fThemes.deaths.toggle.icon:ClearAllPoints()
    Addon.fThemes.deaths.toggle.icon:SetPoint("CENTER", Addon.fThemes.deaths.toggle, "CENTER", 0, 0)
    Addon.fThemes.deaths.toggle.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\buttons")
    Addon.fThemes.deaths.toggle.icon:SetAlpha(.5)
    Addon:ToggleVisible(frame, true)

    -- Fonts caption
    subTop = subTop - 10
    Addon.fThemes.deaths.fontsCaption = Addon.fThemes.deaths:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.deaths.fontsCaption:SetPoint("CENTER", Addon.fThemes.deaths, "TOP", 0, subTop)
    Addon.fThemes.deaths.fontsCaption:SetJustifyH("CENTER")
    Addon.fThemes.deaths.fontsCaption:SetSize(200, 20)
    Addon.fThemes.deaths.fontsCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.deaths.fontsCaption:SetText(Addon.localization.FONT)
    -- Fonts selector
    subTop = subTop - 24
    Addon.fThemes.deaths.fFonts = CreateFrame("Button", nil, Addon.fThemes.deaths, "IPListBox")
    Addon.fThemes.deaths.fFonts:SetHeight(30)
    Addon.fThemes.deaths.fFonts:SetPoint("LEFT", Addon.fThemes.deaths, "TOPLEFT", 20, subTop)
    Addon.fThemes.deaths.fFonts:SetPoint("RIGHT", Addon.fThemes.deaths, "TOPRIGHT", -20, subTop)
    Addon.fThemes.deaths.fFonts:SetList(GetFontList, theme.deaths.font)
    Addon.fThemes.deaths.fFonts:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:SetDeathsFont(key, true)
        end,
        OnCancel = function(self)
            Addon:SetDeathsFont(theme.deaths.font)
        end,
        OnSelect = function(self, key, text)
            Addon.fThemes.deaths.fFonts.fText:SetFont(key, 12)
            Addon:SetDeathsFont(key)
        end,
        OnRenderItem = function(self, fItem, key, text)
            fItem.fText:SetFont(key, 12)
        end,
    })

    -- Font style caption
    subTop = subTop - 34
    Addon.fThemes.deaths.fontStyleCaption = Addon.fThemes.deaths:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fThemes.deaths.fontStyleCaption:SetPoint("CENTER", Addon.fThemes.deaths, "TOP", 0, subTop)
    Addon.fThemes.deaths.fontStyleCaption:SetJustifyH("CENTER")
    Addon.fThemes.deaths.fontStyleCaption:SetSize(200, 20)
    Addon.fThemes.deaths.fontStyleCaption:SetTextColor(1, 1, 1)
    Addon.fThemes.deaths.fontStyleCaption:SetText(Addon.localization.FONTSTYLE)
    -- Font style selector
    subTop = subTop - 24
    Addon.fThemes.deaths.fFontStyle = CreateFrame("Button", nil, Addon.fThemes.deaths, "IPListBox")
    Addon.fThemes.deaths.fFontStyle:SetHeight(30)
    Addon.fThemes.deaths.fFontStyle:SetPoint("LEFT", Addon.fThemes.deaths, "TOPLEFT", 20, subTop)
    Addon.fThemes.deaths.fFontStyle:SetPoint("RIGHT", Addon.fThemes.deaths, "TOPRIGHT", -20, subTop)
    Addon.fThemes.deaths.fFontStyle:SetList(Addon.optionList.fontStyle, theme.deaths.fontStyle, true)
    Addon.fThemes.deaths.fFontStyle:SetCallback({
        OnHoverItem = function(self, fItem, key, text)
            Addon:SetDeathsFontStyle(key, true)
        end,
        OnCancel = function(self)
            Addon:SetDeathsFontStyle(theme.deaths.fontStyle)
        end,
        OnSelect = function(self, key, text)
            Addon.fThemes.deaths.fFontStyle.fText:SetFont(theme.deaths.font, 12, key)
            Addon:SetDeathsFontStyle(key)
        end,
        OnRenderItem = function(self, fItem, key, text)
            fItem.fText:SetFont(theme.deaths.font, 12, key)
        end,
    })

    -- Caption FontSize
    subTop = subTop - 56
    Addon.fThemes.deaths.captionFontSize = CreateFrame("Slider", nil, Addon.fThemes.deaths, "IPOptionsSlider")
    Addon.fThemes.deaths.captionFontSize:SetPoint("LEFT", Addon.fThemes.deaths, "TOPLEFT", 10, subTop)
    Addon.fThemes.deaths.captionFontSize:SetPoint("RIGHT", Addon.fThemes.deaths, "TOPRIGHT", -10, subTop)
    Addon.fThemes.deaths.captionFontSize:SetOrientation('HORIZONTAL')
    Addon.fThemes.deaths.captionFontSize:SetMinMaxValues(6, 30)
    Addon.fThemes.deaths.captionFontSize:SetValueStep(1.0)
    Addon.fThemes.deaths.captionFontSize:EnableMouseWheel(0)
    Addon.fThemes.deaths.captionFontSize:SetObeyStepOnDrag(true)
    Addon.fThemes.deaths.captionFontSize.Low:SetText('6')
    Addon.fThemes.deaths.captionFontSize.High:SetText('30')
    Addon.fThemes.deaths.captionFontSize:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        self.Text:SetText(Addon.localization.DTHCAPTFS .. " (" .. value .. ")")
        Addon:SetDeathsFontSize('caption', value)
    end)
    Addon.fThemes.deaths.captionFontSize:HookScript("OnEnter", function(self)
        Addon.fThemes.deaths:GetScript("OnEnter")(Addon.fThemes.deaths)
    end)

    -- Header FontSize
    subTop = subTop - 46
    Addon.fThemes.deaths.headerFontSize = CreateFrame("Slider", nil, Addon.fThemes.deaths, "IPOptionsSlider")
    Addon.fThemes.deaths.headerFontSize:SetPoint("LEFT", Addon.fThemes.deaths, "TOPLEFT", 10, subTop)
    Addon.fThemes.deaths.headerFontSize:SetPoint("RIGHT", Addon.fThemes.deaths, "TOPRIGHT", -10, subTop)
    Addon.fThemes.deaths.headerFontSize:SetOrientation('HORIZONTAL')
    Addon.fThemes.deaths.headerFontSize:SetMinMaxValues(6, 24)
    Addon.fThemes.deaths.headerFontSize:SetValueStep(1.0)
    Addon.fThemes.deaths.headerFontSize:EnableMouseWheel(0)
    Addon.fThemes.deaths.headerFontSize:SetObeyStepOnDrag(true)
    Addon.fThemes.deaths.headerFontSize.Low:SetText('6')
    Addon.fThemes.deaths.headerFontSize.High:SetText('24')
    Addon.fThemes.deaths.headerFontSize:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        self.Text:SetText(Addon.localization.DTHHEADFS .. " (" .. value .. ")")
        Addon:SetDeathsFontSize('header', value)
    end)
    Addon.fThemes.deaths.headerFontSize:HookScript("OnEnter", function(self)
        Addon.fThemes.deaths:GetScript("OnEnter")(Addon.fThemes.deaths)
    end)

    -- Record FontSize
    subTop = subTop - 46
    Addon.fThemes.deaths.recordFontSize = CreateFrame("Slider", nil, Addon.fThemes.deaths, "IPOptionsSlider")
    Addon.fThemes.deaths.recordFontSize:SetPoint("LEFT", Addon.fThemes.deaths, "TOPLEFT", 10, subTop)
    Addon.fThemes.deaths.recordFontSize:SetPoint("RIGHT", Addon.fThemes.deaths, "TOPRIGHT", -10, subTop)
    Addon.fThemes.deaths.recordFontSize:SetOrientation('HORIZONTAL')
    Addon.fThemes.deaths.recordFontSize:SetMinMaxValues(6, 20)
    Addon.fThemes.deaths.recordFontSize:SetValueStep(1.0)
    Addon.fThemes.deaths.recordFontSize:EnableMouseWheel(0)
    Addon.fThemes.deaths.recordFontSize:SetObeyStepOnDrag(true)
    Addon.fThemes.deaths.recordFontSize.Low:SetText('6')
    Addon.fThemes.deaths.recordFontSize.High:SetText('20')
    Addon.fThemes.deaths.recordFontSize:SetScript('OnValueChanged', function(self)
        local value = self:GetValue()
        self.Text:SetText(Addon.localization.DTHRCRDPFS .. " (" .. value .. ")")
        Addon:SetDeathsFontSize('record', value)
    end)
    Addon.fThemes.deaths.recordFontSize:HookScript("OnEnter", function(self)
        Addon.fThemes.deaths:GetScript("OnEnter")(Addon.fThemes.deaths)
    end)
end