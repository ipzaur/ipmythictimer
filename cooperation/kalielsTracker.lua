local AddonName, Addon = ...

local OTClicked = false
local function CheckExpandedOT()
    local inInstance, instanceType = IsInInstance()
    local inKey = IPMTDungeon.keyActive or (inInstance and instanceType == "party")
    if inKey and not OTClicked then
        KT_ObjectiveTracker_Collapse()
        KT_ObjectiveTracker_Update()
    end
end

local hooked = false
local trying = 0
function Addon:KalielsTrackerFix()
    if not hooked and IsAddOnLoaded('!KalielsTracker') then
        local KTMinBut = _G["!KalielsTrackerMinimizeButton"]
        if KTMinBut ~= nil then
            hooksecurefunc("KT_ObjectiveTracker_Expand", CheckExpandedOT)
            local script = KTMinBut:GetScript('OnClick')
            KTMinBut:SetScript("OnClick", function(self)
                OTClicked = true
                script(KTMinBut)
                OTClicked = false
            end)
            hooked = true
        end
        trying = trying + 1
        if trying > 3 then
            hooked = true
        end
    end
end