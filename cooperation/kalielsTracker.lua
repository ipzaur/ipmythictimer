local AddonName, Addon = ...

local OTClicked = false
local function CheckExpandedOT(self, collapsed)
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if not collapsed and inKey and not OTClicked then
        KT_ObjectiveTrackerFrame:SetCollapsed(true)
    end
end

local hooked = false
local trying = 0
function Addon:KalielsTrackerFix(collapsed)
    if C_AddOns.IsAddOnLoaded('!KalielsTracker') then
        if not hooked then
            local KTMinBut = _G["!KalielsTrackerMinimizeButton"]
            if KTMinBut ~= nil then
                hooksecurefunc(KT_ObjectiveTrackerFrame, "SetCollapsed", CheckExpandedOT)
                local script = KTMinBut:GetScript('OnClick')
                KTMinBut:SetScript("OnClick", function(self)
                    OTClicked = true
                    script(KTMinBut)
                    OTClicked = false
                end)
                hooked = true
                KT_ObjectiveTrackerFrame:SetCollapsed(true)
            end
            trying = trying + 1
            if trying > 3 then
                hooked = true
            end
        else
            KT_ObjectiveTrackerFrame:SetCollapsed(collapsed)
        end
    end
end
