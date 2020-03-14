local AddonName, Addon = ...

function Addon:ToggleDeaths(show)
    if (show == nil) then
        show = not Addon.fDeaths:IsShown()
    end
    if show then
        if not Addon.fOptions:IsShown() then
            Addon:ShowDeaths()
        end
    else
        Addon.fDeaths:Hide()
    end
end

function Addon:ShowDeaths()
    local counts = {}
    for i, death in ipairs(Addon.DB.global.dungeon.deathes.list) do
        if counts[death.playerName] then
            counts[death.playerName] = counts[death.playerName] + 1
        else
            counts[death.playerName] = 1
        end
        Addon:FillDeathRow(i, death, counts[death.playerName])
    end
    local deaths = #Addon.DB.global.dungeon.deathes.list
    local rows = #Addon.fDeaths.line
    if deaths < rows then
        for i = deaths+1,rows do
            Addon.fDeaths.line[i]:Hide()
        end
    end
    Addon.fDeaths:Show()
    Addon.fDeaths.lines:SetHeight(Addon.deathRowHeight * deaths)
end