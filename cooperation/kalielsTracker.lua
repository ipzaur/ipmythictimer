local AddonName, Addon = ...

local OTClicked = false
local function CheckExpandedOT()
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if inKey and not OTClicked then
        ObjectiveTracker_Collapse()
    end
end

local hooked = false
function Addon:KalielsTrackerFix()
    if not hooked and IsAddOnLoaded('!KalielsTracker') then
        local KTMinBut = _G["!KalielsTrackerMinimizeButton"]
        if KTMinBut ~= nil then
            hooksecurefunc("ObjectiveTracker_Expand", CheckExpandedOT)
            local script = KTMinBut:GetScript('OnClick')
            KTMinBut:SetScript("OnClick", function(self)
                OTClicked = true
                script(KTMinBut)
                OTClicked = false
            end)
            hooked = true
        end
    end
end