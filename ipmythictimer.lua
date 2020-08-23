local AddonName, Addon = ...

local function toggleOptions()
    Addon:ShowOptions()
end

local function OnTooltipSetUnit(tooltip)
    if IPMTDungeon == nil or not IPMTDungeon.keyActive then
        return false
    end
    if IPMTDungeon.trash.total > 0 then
        local unit = select(2, tooltip:GetUnit())
        local guID = unit and UnitGUID(unit)

        if guID then
            local npcID = select(6, strsplit("-", guID))
            npcID = tonumber(npcID)
            local percent = Addon:GetEnemyForces(npcID)
            if (percent ~= nil) then
                if IPMTOptions.progress == Addon.PROGRESS_FORMAT_PERCENT then
                    percent = percent .. "%"
                end
                tooltip:AddDoubleLine("|cFFEEDE70" .. percent)
            end
        end
    end
end

function Addon:StartAddon()
    SLASH_IPMTOPTS1 = "/ipmt"
    SLASH_IPMTDEBUG1 = "/ipmt_debug"
    SlashCmdList["IPMTOPTS"] = toggleOptions
    SlashCmdList["IPMTDEBUG"] = PrintDebug

    Addon.fMain:RegisterEvent("ADDON_LOADED")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_RESET")
    Addon.fMain:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    Addon.fMain:RegisterEvent("PLAYER_ENTERING_WORLD")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")

    GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
    Addon:elvUIFix()

    DEFAULT_CHAT_FRAME:AddMessage(Addon.localization.STARTINFO)
end

Addon:StartAddon()