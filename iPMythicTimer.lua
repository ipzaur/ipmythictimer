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
            local npcInfo = nil
            if Addon.season.GetInfoByNamePlate then
                npcInfo = Addon.season:GetInfoByNamePlate(unit)
            end
            if npcInfo == nil then
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
            if npcInfo ~= nil then
                tooltip:AddLine(npcInfo.tooltip)
            end
        end
    end
end

local debugLines = {}
local function PrintDebug()
--[[    local text = Addon:PrintObject(IPMTDungeon, 'dungeon.', true)
    text = text .. "\n\n" .. Addon:PrintObject(IPMTOptions, 'IPMTOptions.', true)
    
    text = text .. "\n\n FRAMES \n\n"
    for frame, info in pairs(Addon.frameInfo) do
        if info.text ~= nil then
            text = text .. frame .. ".text = '" .. Addon.fMain[frame].text:GetText() .. "'\n"
            local fontName, fontSize = Addon.fMain[frame].text:GetFont()
            text = text .. frame .. ".font = '" .. fontName .. "'\n"
            text = text .. frame .. ".size = " .. fontSize .. "\n"
        end
    end--]]

--[[
    local text = Addon:PrintObject(Addon.theme, 'Addon.theme.', true)
    text = text .. "\n\n" .. Addon:PrintObject(IPMTTheme, 'IPMTTheme.', true)
--]]
    local text = ""
    for i,line in ipairs(debugLines) do
        text = text .. line .. "\n"
    end

    if not Addon.fDebug:IsShown() then
        Addon.fDebug:Show()
        print('debug')
    end
    Addon.fDebug.textarea:SetText(text)
end

function Addon:ClearDebug()
    debugLines = {}
    PrintDebug()
end
function Addon:AddDebug(text)
    if #debugLines >= 17 then
       table.remove(debugLines, 1)
    end
    table.insert(debugLines, text)
    PrintDebug()
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
    Addon.fMain:RegisterEvent("VARIABLES_LOADED")

    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipSetUnit)

    DEFAULT_CHAT_FRAME:AddMessage(Addon.localization.STARTINFO)
end

Addon:StartAddon()
