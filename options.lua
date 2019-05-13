local AddonName, Addon = ...

Addon.defaultOptions = {
    opacity = 100,
    scale   = 0,
}

function Addon:SetOpacity(value, initialize)
    Addon.fMain:SetBackdropColor(0,0,0, value / 100)
    if initialize then
        Addon.fOptions.opacity:SetValue(IPMTOptions.opacity)
    end
    IPMTOptions.opacity = value
end

function Addon:SetScale(value, initialize)
    Addon.fMain:SetScale(1 + value / 100)
    if initialize then
        Addon.fOptions.scale:SetValue(IPMTOptions.scale)
    end
    IPMTOptions.scale = value
end

function Addon:LoadOptions()
    if (IPMTOptions == nil) then
        IPMTOptions = Addon.defaultOptions
    end
    Addon:SetOpacity(IPMTOptions.opacity, true)
    Addon:SetScale(IPMTOptions.scale, true)
end

function Addon:ShowOptions()
    Addon.fOptions:Show()
    Addon.fMain:Show()
    if not Addon.started then
        Addon.fMain.level:SetText("24")
        Addon.fMain.plusLevel:SetText("+3")
        Addon.fMain.timer:SetText("27:32")
        Addon.fMain.timer:SetTextColor(0, 1, 0)
        Addon.fMain.plusTimer:SetText("04:19")
        Addon.fMain.deathTimer:SetText("-00:15 [3]")
        Addon.fMain.deathTimer:Show()
        Addon.fMain.progress:SetText("57.32%")
        Addon.fMain.progress:SetTextColor(1,1,0)
        Addon.fMain.prognosis:SetText("63.46%")
        Addon.fMain.prognosis:SetTextColor(1,0,0)
        Addon.fMain.prognosis:Show()
        Addon.fMain.bosses:SetText("3/5")

        local name, description, filedataid = C_ChallengeMode.GetAffixInfo(117);
        for i = 1,4 do
            SetPortraitToTexture(Addon.fMain.affix[i].Portrait, filedataid);
            Addon.fMain.affix[i]:Show()
        end
    end
end

function Addon:CloseOptions()
    Addon.fOptions:Hide()
    if not Addon.started then
        Addon.fMain:Hide()
    end
end