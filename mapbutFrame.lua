local AddonName, Addon = ...

function Addon:InitIcon()
    Addon.DB = LibStub("AceDB-3.0"):New("IPMythicTimerDB", {
        profile = {
            minimap = {
                hide = false,
            },
        },
    })
    
    local icon = LibStub("LibDBIcon-1.0")
    local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("IPMythicTimer", {
        type = "data source",
        text = "IP Mythic Timer",
        icon = "Interface\\AddOns\\IPMythicTimer\\icon",
        OnClick = function(button, buttonPressed)
            if buttonPressed == "LeftButton" then
                Addon:ToggleOptions()
            end
        end,
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then
                return
            end
            tooltip:AddLine("|cFF33EE60IP Mythic Timer|r")
            tooltip:AddLine("|cFFFFFFFF" .. Addon.localization.MAPBUT)
        end,
    })

    icon:Register("IPMythicTimer", LDB, Addon.DB.profile.minimap)
    if not Addon.DB.profile.minimap.hide then
        icon:Show("IPMythicTimer")
    end
end
