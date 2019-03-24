local BOSS_CRITERIA = 165
local REAPING = 117

IPMythicTimer = {}

local dungeon = {
    bosses  = {
        count  = 0,
        killed = 0,
    },
    affixes = {},
    isReaping = false,
    level   = 0,
}
local timeCoef = {0.8, 0.6}

local function UpdateDeath()
    local deathes, timeLost = C_ChallengeMode.GetDeathCount()
    if deathes > 0 then
        fIPMT.deathTimer:SetText("-" .. GetTimeStringFromSeconds(timeLost, false, true) .. " [" .. deathes .. "]")
        fIPMT.deathTimer:Show()
    else
        fIPMT.deathTimer:Hide()
    end
end

local function UpdateCriteria()
    local stageName, stageDescription, numCriteria, _, _, _, _, numSpells, spellInfo, weightedProgress, _, widgetSetID = C_Scenario.GetStepInfo()

    dungeon.bosses.count  = 0
    dungeon.bosses.killed = 0

    for c = 1, numCriteria do
        local criteriaString, criteriaType, _, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(c)
        if criteriaType == BOSS_CRITERIA then
            dungeon.bosses.count = dungeon.bosses.count + 1
            if (quantity > 0) then 
                dungeon.bosses.killed = dungeon.bosses.killed + 1
            end
        elseif isWeightedProgress then
            local progress = tonumber(strsub(quantityString, 1, -2)) / totalQuantity * 100
            progress = math.min(100, progress)
            if (progress % 20 > 17) then
                fIPMT.progress:SetTextColor(1,1,0)
            elseif (progress % 20 > 13) then
                fIPMT.progress:SetTextColor(1,0,0)
            else
                fIPMT.progress:SetTextColor(1,1,1)
            end
            fIPMT.progress:SetFormattedText("%.2f%%", progress)
        end
    end

    fIPMT.bosses:SetText(dungeon.bosses.killed .. "/" .. dungeon.bosses.count)
end

local function UpdateTime(block, elapsedTime)
    local plusLevel = 0
    local plusTimer = 0
    local r = 0
    local g = 0
    local b = 0
    if elapsedTime < block.timeLimit then
        for level = 2,1,-1 do
            local timeLimit = timeCoef[level]*block.timeLimit
            if elapsedTime < timeLimit then
                plusLevel = level
                plusTimer = timeLimit - elapsedTime
                break
            end
        end
        fIPMT.timer:SetText(GetTimeStringFromSeconds(block.timeLimit - elapsedTime, false, true))
        fIPMT.timer:SetTextColor(0, 1, 0)
        if plusTimer > 0 then
            fIPMT.plusTimer:SetText(GetTimeStringFromSeconds(plusTimer, false, true))
            fIPMT.plusTimer:Show()
            g = 1
            if (plusLevel < 2) then
                r = 1
            end
        else
            fIPMT.plusTimer:Hide()
            r = 1
            g = 1
            b = 1
        end
        plusLevel = "+" .. plusLevel+1
    else
        plusLevel = "-1"
        fIPMT.timer:SetText(GetTimeStringFromSeconds(elapsedTime - block.timeLimit, false, true))
        fIPMT.plusTimer:Hide()
        r = 1
    end
    fIPMT.timer:SetTextColor(r, g, b)
    fIPMT.plusLevel:SetText(plusLevel)
end

local function ShowFrame()
    local block = ScenarioChallengeModeBlock
    local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()

    dungeon.level = level
    dungeon.affixes = affixes
    dungeon.isReaping = false

    fIPMT.level:SetText(dungeon.level)
    local count = #dungeon.affixes
    for i,affix in pairs(dungeon.affixes) do
        local _, _, filedataid = C_ChallengeMode.GetAffixInfo(affix);
        local iconNum = count - i + 1
        SetPortraitToTexture(fIPMT.affix[iconNum].Portrait, filedataid);
        fIPMT.affix[iconNum]:Show()

        if affix == REAPING then
            dungeon.isReaping = true
        end
    end
    for a = count+1,4 do
        fIPMT.affix[a]:Hide()
    end
    UpdateDeath()
    UpdateCriteria()
    fIPMT:Show()
    ObjectiveTrackerFrame:Hide()
end

local function StopTimer()
    fIPMT:Hide()
    ObjectiveTrackerFrame:Show()
end

hooksecurefunc("Scenario_ChallengeMode_UpdateTime", UpdateTime)
hooksecurefunc("Scenario_ChallengeMode_ShowBlock", ShowFrame)

function IPMythicTimer:OnEvent(self, event, ...)
    if (event == "CHALLENGE_MODE_DEATH_COUNT_UPDATED") then
        UpdateDeath()
    elseif (event == "SCENARIO_CRITERIA_UPDATE") then
        UpdateCriteria()
    elseif (event == "CHALLENGE_MODE_COMPLETED") then
        StopTimer()
    elseif (event == "PLAYER_ENTERING_WORLD") then
        local inInstance, instanceType = IsInInstance()
        if not (inInstance and instanceType == "party") then
            StopTimer()
        end
    end
end

function IPMythicTimer:StartAddon()
    fIPMT:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
    fIPMT:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    fIPMT:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    fIPMT:RegisterEvent("PLAYER_ENTERING_WORLD")
    --challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
end
