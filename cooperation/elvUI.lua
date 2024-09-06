local AddonName, Addon = ...

--[[
local OTClicked = false
local function CheckCollapsedOT(self, isCollapsed)
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if inKey and not OTClicked and not isCollapsed then
       -- ObjectiveTrackerFrame:SetCollapsed(true)
    end
    OTClicked = false
end
]]
local function CheckVisibleOT()
    if IPMTDungeon.keyActive then
        ObjectiveTrackerFrame:Hide()
    end
end

function Addon:elvUIFix()
    hooksecurefunc(ObjectiveTrackerFrame, "Show", CheckVisibleOT)
--[[
    hooksecurefunc(ObjectiveTrackerFrame, "SetCollapsed", CheckCollapsedOT)
    ObjectiveTrackerFrame.Header.MinimizeButton:SetScript("PreClick", function(self, button)
        if button == "LeftButton" then
            OTClicked = true
            print('clicked')
        end
    end)
]]
end
