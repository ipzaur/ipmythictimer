local AddonName, Addon = ...

local nonCombatContent = {
    level = {
        content  = "24",
    },
    plusLevel = {
        content  = "+3",
    },
    timer = {
        content  = "27:32",
        colorId  = 1,
    },
    plusTimer = {
        content  = "04:19",
    },
    deathTimer = {
        content  = "-00:15 [3]",
    },
    progress = {
        content  = {"57.32%", "134/286"},
    },
    prognosis = {
        content  = {"63.46%", "148"},
    },
    bosses = {
        content  = "3/5",
    },
    dungeonname = {
        content  = Addon.localization.DUNGENAME,
    },
}

local LSM = LibStub("LibSharedMedia-3.0")

function Addon:CleanDB()
    IPMTDB = {}
end
function Addon:ToggleDBTooltip(self, show)
    if show then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.CLEANDBTT, .9, .9, 0, 1, true)
        GameTooltip:Show()
    else
        GameTooltip:Hide()
    end
end

function Addon:SetScale(value)
    IPMTOptions.scale = value
    Addon.fMain:SetScale(1 + IPMTOptions.scale / 100)
    Addon.fOptions.scale.Text:SetText(Addon.localization.SCALE .. " (" .. (IPMTOptions.scale + 100) .. "%)")
end

function Addon:SetProgressFormat(value)
    if IPMTOptions.progress ~= value then
        IPMTOptions.progress = value
        if not IPMTDungeon.keyActive then
            Addon.fMain.progress.text:SetText(nonCombatContent.progress.content[IPMTOptions.progress])
            Addon.fMain.prognosis.text:SetText(nonCombatContent.prognosis.content[IPMTOptions.progress])
        else
            Addon:UpdateProgress()
        end
        Addon:RecalcElem()
        if Addon.season.ShowTimer then
            Addon.season:ShowTimer()
        end
    end
end

function Addon:SetProgressDirection(value)
    if IPMTOptions.direction ~= value then
        IPMTOptions.direction = value
        if IPMTDungeon.keyActive then
            Addon:UpdateProgress()
        end
        Addon:RecalcElem()
    end
end

function Addon:SelectFont(font)
    local fontList = LSM:List('font')
    for i,fontName in pairs(fontList) do
        local filepath = LSM:Fetch('font', fontName)
        if (font == filepath) then
            Addon.fThemes.fFonts:SelectItem(font)
        end
    end
end

function Addon:RecalcElem(frame)
    if frame ~= nil then
        if frame == Addon.season.frameName then
            if Addon.season.recalcElem then
                Addon.season.recalcElem(frame)
            end
        elseif frame ~= "dungeonname" then
            local width = Addon.fMain[frame].text:GetStringWidth()
            local height = Addon.fMain[frame].text:GetStringHeight()
            Addon.fMain[frame]:SetSize(width, height)
        end
    else
        for i, info in ipairs(Addon.frames) do
            local frame = info.label
            if frame ~= "dungeonname" and Addon.fMain[frame].text ~= nil then
                local width = Addon.fMain[frame].text:GetStringWidth()
                local height = Addon.fMain[frame].text:GetStringHeight()
                Addon.fMain[frame]:SetSize(width, height)
            end
        end
    end
end

function Addon:ToggleOptions()
    if Addon.fOptions and Addon.fOptions:IsShown() then
        Addon:CloseOptions()
    else
        Addon:ShowOptions()
    end
end
function Addon:toggleMapbutton(show)
    local icon = LibStub("LibDBIcon-1.0")
    Addon.DB.global.minimap.hide = not show
    if not Addon.DB.global.minimap.hide then
        icon:Show("IPMythicTimer")
    else
        icon:Hide("IPMythicTimer")
    end
end

function Addon:ShowOptions()
    if Addon.fOptions == nil then
        Addon:RenderOptions()
    end
    Addon.fOptions:Show()
    Addon.fMain:Show()
    Addon.fMain:SetMovable(true)
    Addon.fMain:EnableMouse(true)
    Addon.fOptions.Mapbut:SetChecked(not Addon.DB.global.minimap.hide)
    local theme = IPMTTheme[IPMTOptions.theme]
    if IPMTDungeon and not IPMTDungeon.keyActive then
        for i, info in ipairs(Addon.frames) do
            local frame = info.label
            if info.hasText then
                local content = nonCombatContent[frame].content
                if frame == "progress" or frame == "prognosis" then
                    content = content[IPMTOptions.progress]
                end
                Addon.fMain[frame].text:SetText(content)
                if nonCombatContent[frame].colorId then
                    local color = theme.elements[frame].color[nonCombatContent[frame].colorId]
                    Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
                end
                if frame ~= "dungeonname" then
                    local width = Addon.fMain[frame].text:GetStringWidth()
                    local height = Addon.fMain[frame].text:GetStringHeight()
                    Addon.fMain[frame]:SetSize(width, height)
                end
            end
        end

        local name, description, filedataid = C_ChallengeMode.GetAffixInfo(117) -- Reaping icon
        for i = 1,4 do
            SetPortraitToTexture(Addon.fMain.affix[i].Portrait, filedataid)
            Addon.fMain.affix[i]:Show()
        end
    end

    if Addon.season.options and Addon.season.options.ShowOptions then
        Addon.season.options:ShowOptions()
    end
end

function Addon:CloseOptions()
    Addon:CloseThemeEditor()
    Addon.fMain:SetMovable(false)
    Addon.fMain:EnableMouse(false)
    if not IPMTDungeon.keyActive then
        Addon.fMain:Hide()
    end
    if IPMTDungeon.deathes and IPMTDungeon.deathes.list and #IPMTDungeon.deathes.list == 0 then
        Addon.fMain.deathTimer:Hide()
    end
    Addon.fOptions:Hide()
end

local hideMainMenu = false
local function TryToHideMainMenu()
    if hideMainMenu then
        hideMainMenu = false
        HideUIPanel(GameMenuFrame)
    end
end
hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', TryToHideMainMenu)

local _G = getfenv(0)
_G.hooksecurefunc("StaticPopup_EscapePressed", function()
    if Addon.fOptions ~= nil and Addon.fOptions:IsShown() then
        if not GameMenuFrame:IsShown() and not InterfaceOptionsFrame:IsShown() then
            Addon:CloseOptions()
            hideMainMenu = true
        end
    end
end)

function Addon:OpenSettingsFromPanel()
    Addon:ShowOptions()
    hideMainMenu = true
    InterfaceOptionsFrame:Hide()
end
