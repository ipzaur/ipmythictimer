local AddonName, Addon = ...

local OTClicked = false
local function CheckExpandedOT()
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if inKey and not OTClicked then
        ObjectiveTracker_Collapse()
    end
end

function Addon:elvUIFix()
    hooksecurefunc("ObjectiveTracker_Expand", CheckExpandedOT)
    ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetScript("OnClick", function(self)
        OTClicked = true
        ObjectiveTracker_MinimizeButton_OnClick()
        OTClicked = false
    end)
end