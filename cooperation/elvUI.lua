local AddonName, Addon = ...

local OTClicked = false
local function CheckExpandedOT()
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if inKey and not OTClicked and not ObjectiveTrackerFrame:IsCollapsed() then
        ObjectiveTrackerFrame:SetCollapsed(true)
    end
    OTClicked = false
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
    hooksecurefunc(ObjectiveTrackerFrame, "SetCollapsed", CheckExpandedOT)
    local clickFunc = ObjectiveTrackerFrame.Header.MinimizeButton:GetScript("OnClick")
    ObjectiveTrackerFrame.Header.MinimizeButton:SetScript("OnClick", function(self)
        OTClicked = true
        clickFunc()
    end)
    WaitAutoHider()
end