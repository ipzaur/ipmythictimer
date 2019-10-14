local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

Addon.defaultOptions = {
    opacity     = 100,
    scale       = 0,
    position    = {
        main = {
            point = 'TOPRIGHT',
            x = -30,
            y = -220,
        },
        options = {
            point = 'CENTER',
            x = 0,
            y = -50,
        },
    },
    font = Addon.FONT_ROBOTO,
}

function Addon:CleanDB()
    IPMTDB = {}
end
function Addon:ToggleDBTooltip(self, show)
    if show then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.CLEANDBTT, 1, 1, 1, 1, true)
        GameTooltip:Show()
    else
        GameTooltip:Hide()
    end
end

function Addon:SetOpacity(value, initialize)
    if (type(value) ~= 'number') then
        value = Addon.defaultOptions.opacity
    end
    Addon.fMain:SetBackdropColor(0,0,0, value / 100)
    if initialize then
        Addon.fOptions.opacity:SetValue(IPMTOptions.opacity)
    end
    IPMTOptions.opacity = value
end

function Addon:SetScale(value, initialize)
    if (type(value) ~= 'number') then
        value = Addon.defaultOptions.scale
    end
    Addon.fMain:SetScale(1 + value / 100)
    if initialize then
        Addon.fOptions.scale:SetValue(IPMTOptions.scale)
    end
    IPMTOptions.scale = value
end

function Addon:SetFont(filepath)
    IPMTOptions.font = filepath
    for frame, info in pairs(IPMTOptions.frame) do
        if (info.fontSize) then
            Addon.fMain[frame].text:SetFont(IPMTOptions.font, info.fontSize)
            local width = Addon.fMain[frame].text:GetStringWidth()
            local height = Addon.fMain[frame].text:GetStringHeight()
            Addon.fMain[frame]:SetSize(width, height)
        end
    end
end

function Addon:MoveElement(self, frame)
    local x = self:GetLeft() - Addon.fMain:GetLeft()
    local y = self:GetTop() - Addon.fMain:GetTop() - self:GetHeight() / 2
    local point = "LEFT"
    local rPoint
    if x > Addon.fMain:GetWidth() / 2 then
        point = "RIGHT"
        x = self:GetRight() - Addon.fMain:GetRight()
    end
    if y < Addon.fMain:GetHeight() / -2 then
        rPoint = "BOTTOM" .. point
        y = self:GetBottom() - Addon.fMain:GetBottom() + self:GetHeight() / 2
    else
        rPoint = "TOP" .. point
    end
    self:ClearAllPoints()
    self:SetPoint(point, Addon.fMain, rPoint, x, y)
    IPMTOptions.frame[frame].point = point
    IPMTOptions.frame[frame].rPoint = rPoint
    IPMTOptions.frame[frame].x = x
    IPMTOptions.frame[frame].y = y
end

function Addon:LoadOptions()
    if IPMTOptions == nil then
        IPMTOptions = {}
    end

    if IPMTOptions.opacity == nil then
        IPMTOptions.opacity = Addon.defaultOptions.opacity
    end
    if IPMTOptions.scale == nil then
        IPMTOptions.scale = Addon.defaultOptions.scale
    end

    if IPMTOptions.position == nil then
        IPMTOptions.position = {
            main = {
                point = Addon.defaultOptions.position.main.point,
                x = Addon.defaultOptions.position.main.x,
                y = Addon.defaultOptions.position.main.y,
            },
            options = {
                point = Addon.defaultOptions.position.options.point,
                x = Addon.defaultOptions.position.options.x,
                y = Addon.defaultOptions.position.options.y,
            }
            
        }
    end

    if IPMTOptions.size == nil then
        IPMTOptions.size = {
            [0] = Addon.defaultSize[0],
            [1] = Addon.defaultSize[1],
        }
    else
        Addon.fMain:SetSize(IPMTOptions.size[0], IPMTOptions.size[1])
    end

    if IPMTOptions.frame == nil then
        IPMTOptions.frame = {}
        for frame, info in pairs(Addon.frameInfo) do
            IPMTOptions.frame[frame] = {
                x      = info.position.x,
                y      = info.position.y,
                point  = info.position.point,
                rPoint = info.position.rPoint,
            }
            if IPMTOptions.frame[frame].point == nil then
                IPMTOptions.frame[frame].point = 'LEFT'
            end
            if IPMTOptions.frame[frame].rPoint == nil then
                IPMTOptions.frame[frame].rPoint = 'TOPLEFT'
            end
            if info.text ~= nil then
                IPMTOptions.frame[frame].fontSize = info.text.fontSize
            end
        end
    else
        for frame, info in pairs(Addon.frameInfo) do
            Addon.fMain[frame]:ClearAllPoints()
            Addon.fMain[frame]:SetPoint(IPMTOptions.frame[frame].point, Addon.fMain, IPMTOptions.frame[frame].rPoint, IPMTOptions.frame[frame].x, IPMTOptions.frame[frame].y)
        end
    end

    if IPMTOptions.font == nil then
        IPMTOptions.font = Addon.defaultOptions.font
    end
    Addon:SetFont(IPMTOptions.font)

    Addon:SetOpacity(IPMTOptions.opacity, true)
    Addon:SetScale(IPMTOptions.scale, true)
    Addon:OnShow()

    if not IPMTOptions.version or IPMTOptions.version ~= Addon.version then
        Addon:ShowOptions()
        IPMTOptions.version = Addon.version
    end
end

local function SelectFont(font)
    local fontList = LSM:List('font')
    for i,fontName in pairs(fontList) do
        local filepath = LSM:Fetch('font', fontName)
        if (font == filepath) then
            UIDropDownMenu_SetText(Addon.fOptions.fonts, fontName)
        end
    end
end

local fontSizeFrame = nil

function Addon:SetFontSize(value)
    if fontSizeFrame ~= nil then
        IPMTOptions.frame[fontSizeFrame].fontSize = value
        Addon.fMain[fontSizeFrame].text:SetFont(IPMTOptions.font, IPMTOptions.frame[fontSizeFrame].fontSize)
        local width = Addon.fMain[fontSizeFrame].text:GetStringWidth()
        local height = Addon.fMain[fontSizeFrame].text:GetStringHeight()
        Addon.fMain[fontSizeFrame]:SetSize(width, height)
        local FStext = Addon.localization.FONTSIZE .. ' [' .. IPMTOptions.frame[fontSizeFrame].fontSize .. ']'
        getglobal(Addon.fOptions.FS.slider:GetName() .. 'Text'):SetText(FStext)
    end
end

function Addon:StartFontSize(frame)
    if Addon.fMain[frame].text ~= nil then
        if fontSizeFrame ~= frame then
            fontSizeFrame = frame
            Addon.fOptions.FS:ClearAllPoints()
            Addon.fOptions.FS:SetPoint('TOP', Addon.fMain[frame], 'BOTTOM', 0, -4)
            Addon.fOptions.FS.slider:SetValue(IPMTOptions.frame[fontSizeFrame].fontSize)
            local FStext = Addon.localization.FONTSIZE .. ' [' .. IPMTOptions.frame[fontSizeFrame].fontSize .. ']'
            getglobal(Addon.fOptions.FS.slider:GetName() .. 'Text'):SetText(FStext)
            Addon.fOptions.FS:Show()
        else
            fontSizeFrame = nil
            Addon.fOptions.FS:Hide()
        end
    end
end

function Addon:ToggleCustomize(enable)
    if enable then
        for frame, info in pairs(Addon.frameInfo) do
            Addon.fMain[frame]:SetBackdropColor(1,1,1, 0.1)
            Addon.fMain[frame]:EnableMouse(true)
            Addon.fMain[frame]:SetMovable(true)
        end
        Addon.fMain:SetResizable(true)
        Addon.fMain.cCaption:Show()
    else
        for frame, info in pairs(Addon.frameInfo) do
            Addon.fMain[frame]:SetBackdropColor(1,1,1, 0)
            if (frame ~= "deathTimer") then
                Addon.fMain[frame]:EnableMouse(false)
            end
            Addon.fMain[frame]:SetMovable(false)
        end
        Addon.fMain:SetResizable(false)
        Addon.fMain.cCaption:Hide()
        Addon.fOptions.FS:SetPoint("CENTER", UIParent)
        Addon.fOptions.FS:Hide()
    end
end

function Addon:ToggleOptions()
    if Addon.fOptions:IsShown() then
        Addon:CloseOptions()
    else
        Addon:ShowOptions()
    end
end
function Addon:toggleMapbutton(show)
    local icon = LibStub("LibDBIcon-1.0")
    Addon.DB.profile.minimap.hide = not show
    if not Addon.DB.profile.minimap.hide then
        icon:Show("IPMythicTimer")
    else
        icon:Hide("IPMythicTimer")
    end
end

function Addon:ShowOptions()
    Addon.fOptions:Show()
    Addon.fMain:Show()
    Addon.fMain:SetMovable(true)
    Addon.fMain:EnableMouse(true)
    Addon.fOptions.Mapbut:SetChecked(not Addon.DB.profile.minimap.hide)
    if not Addon.keyActive then
        for frame, info in pairs(Addon.frameInfo) do
            if info.text ~= nil then
                Addon.fMain[frame].text:SetText(info.text.content)
                if info.text.color then
                    Addon.fMain[frame].text:SetTextColor(info.text.color[0], info.text.color[1], info.text.color[2])
                end
            end
        end

        local name, description, filedataid = C_ChallengeMode.GetAffixInfo(117)
        for i = 1,4 do
            SetPortraitToTexture(Addon.fMain.affix[i].Portrait, filedataid)
            Addon.fMain.affix[i]:Show()
        end
    end
    SelectFont(IPMTOptions.font)
end

function Addon:CloseOptions()
    Addon.fOptions:Hide()
    Addon.fMain:SetMovable(false)
    Addon.fMain:EnableMouse(false)
    if not Addon.keyActive then
        Addon.fMain:Hide()
    end
    Addon:ToggleCustomize(false)
    Addon.fOptions.customize:SetChecked(false)
end

function Addon:RestoreOptions()
    Addon.fOptions.opacity:SetValue(100)
    Addon.fOptions.scale:SetValue(0)

    IPMTOptions.position.main.point = Addon.defaultOptions.position.main.point
    IPMTOptions.position.main.x = Addon.defaultOptions.position.main.x
    IPMTOptions.position.main.y = Addon.defaultOptions.position.main.y

    IPMTOptions.position.options.point = Addon.defaultOptions.position.options.point
    IPMTOptions.position.options.x = Addon.defaultOptions.position.options.x
    IPMTOptions.position.options.y = Addon.defaultOptions.position.options.y

    IPMTOptions.font = Addon.FONT_ROBOTO
    SelectFont(IPMTOptions.font)
    IPMTOptions.size = {
        [0] = Addon.defaultSize[0],
        [1] = Addon.defaultSize[1],
    }
    Addon.fMain:SetSize(IPMTOptions.size[0], IPMTOptions.size[1])
    for frame, info in pairs(Addon.frameInfo) do
        IPMTOptions.frame[frame] = {
            x      = info.position.x,
            y      = info.position.y,
            point  = info.position.point,
            rPoint = info.position.rPoint,
        }
        if IPMTOptions.frame[frame].point == nil then
            IPMTOptions.frame[frame].point = 'LEFT'
        end
        if IPMTOptions.frame[frame].rPoint == nil then
            IPMTOptions.frame[frame].rPoint = 'TOPLEFT'
        end
        if info.text ~= nil then
            IPMTOptions.frame[frame].fontSize = info.text.fontSize
            Addon.fMain[frame].text:SetFont(Addon.FONT_ROBOTO, IPMTOptions.frame[frame].fontSize)
            local width = Addon.fMain[frame].text:GetStringWidth()
            local height = Addon.fMain[frame].text:GetStringHeight()
            Addon.fMain[frame]:SetSize(width, height) 
        end
        Addon.fMain[frame]:ClearAllPoints()
        Addon.fMain[frame]:SetPoint(IPMTOptions.frame[frame].point, Addon.fMain, IPMTOptions.frame[frame].rPoint, IPMTOptions.frame[frame].x, IPMTOptions.frame[frame].y)
    end

    Addon:OnShow()
end