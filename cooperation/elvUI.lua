local AddonName, Addon = ...

local OTClicked = false
local function CheckExpandedOT()
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if inKey and not OTClicked then
        ObjectiveTracker_Collapse()
    end
end

local tryCount = 0
local function WaitAutoHider()
    if ObjectiveTrackerFrame.AutoHider ~= nil then
        ObjectiveTrackerFrame.AutoHider:HookScript('OnShow', function()
            CheckExpandedOT()
        end)
    elseif tryCount < 10 then
        tryCount = tryCount + 1
        C_Timer.After(1, WaitAutoHider)
    end
end

function Addon:elvUIFix()
    hooksecurefunc("ObjectiveTracker_Expand", CheckExpandedOT)
    ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetScript("OnClick", function(self)
        OTClicked = true
        ObjectiveTracker_MinimizeButton_OnClick()
        OTClicked = false
    end)
    WaitAutoHider()
end