local REAPING = 117

IPMythicTimer = {}

local dungeon = {
    id = 0,
    bosses  = {
        count  = 0,
        killed = 0,
    },
    trash = {
        total = 0,
        current = 0,
        killed = 0,
    },
    affixes = {},
    isReaping = false,
    level   = 0,
}
local timeCoef = {0.8, 0.6}

local MDTdungeon = {
    [934]  = 15, -- Atal Dazar
    [936]  = 16, -- Freehold
    [942]  = 18, -- Shrine of the Storm
    [1004] = 17, -- Kings Rest
    [1010] = 21, -- The Motherlode
    [1015] = 24, -- Waycrest Manor
    [1038] = 20, -- Temple of Sethraliss
    [1041] = 22, -- The Underrot
    [1162] = 19, -- Siege of Bolarus
    [1169] = 23, -- Tol Dagor
}

local killInfo = {
    npcID        = 0,
    progress     = 0,
    progressTime = nil,
    diedTime     = nil,
}

local function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

local function getFromMDT(npcID, wsave)
    if not MethodDungeonTools then
        return nil
    end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not MDTdungeon[mapID] then
        return nil
    end
    local npcInfos = MethodDungeonTools.dungeonEnemies[MDTdungeon[mapID]]
    if npcInfos then
        for i,npcInfo in pairs(npcInfos) do
            if npcInfo.id == npcID then
                if wsave then
                    IPMTDB[npcID] = npcInfo.count
                end
                return npcInfo.count
            end
        end
    end
    return nil
end

local function GetEnemyPercent(npcID)
    local percent = nil
    if (IPMTDB and IPMTDB[npcID]) then
        percent = IPMTDB[npcID]
    else
        percent = getFromMDT(npcID, true)
    end

    if (percent) then
        percent = 100 / dungeon.trash.total * percent
        percent = round(percent, 2)
    end
    return percent
end

local function clearKillInfo()
    killInfo = {
        npcID        = 0,
        progress     = 0,
        progressTime = nil,
        diedTime     = nil,
    }
end

local function GrabMobInfo()
    if killInfo.npcID and killInfo.diedTime and killInfo.progress and killInfo.progressTime then
        if abs(killInfo.progressTime - killInfo.diedTime) < 0.1 then
            if not IPMTDB[killInfo.npcID] then
                IPMTDB[killInfo.npcID] = killInfo.progress
            end
            clearKillInfo()
        end
    end
end

local function UpdateCriteria()
    local numCriteria = select(3, C_Scenario.GetStepInfo())

    dungeon.bosses.count  = 0
    dungeon.bosses.killed = 0

    for c = 1, numCriteria do
        local _, _, _, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(c)
        if isWeightedProgress then
            if (dungeon.trash.total == 0) then
                dungeon.trash.total = totalQuantity
            end
            local currentTrash = tonumber(strsub(quantityString, 1, -2))
            if dungeon.trash.current and currentTrash < dungeon.trash.total and currentTrash > dungeon.trash.current then
                killInfo.progress = currentTrash - dungeon.trash.current
                killInfo.progressTime = GetTime()
                GrabMobInfo()
            end
            dungeon.trash.current = currentTrash

            local progress = dungeon.trash.current / dungeon.trash.total * 100
            progress = math.min(100, progress)
            if dungeon.isReaping then
                if (progress % 20 > 18) then
                    fIPMT.progress:SetTextColor(1,0,0)
                elseif (progress % 20 > 15) then
                    fIPMT.progress:SetTextColor(1,1,0)
                else
                    fIPMT.progress:SetTextColor(1,1,1)
                end
            end
            fIPMT.progress:SetFormattedText("%.2f%%", progress)

        else
            dungeon.bosses.count = dungeon.bosses.count + 1
            if (quantity > 0) then 
                dungeon.bosses.killed = dungeon.bosses.killed + 1
            end
        end
    end

    fIPMT.bosses:SetText(dungeon.bosses.killed .. "/" .. dungeon.bosses.count)
end

local function CombatLogEvent()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10 = CombatLogGetCurrentEventInfo()

    if event == "UNIT_DIED" then
        if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0
                and bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_NPC) > 0
                and (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 or bit.band(destFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) > 0) then
            local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", destGUID)
            local npcID = select(6, strsplit("-", destGUID))
            npcID = tonumber(npcID)
            if (not (IPMTDB and IPMTDB[npcID])) and (getFromMDT(npcID, true) == nil) then
                killInfo.npcID = npcID
                killInfo.diedTime = GetTime()
                GrabMobInfo()
            else
                clearKillInfo()
            end
        end
    end
end

local function UpdateTime(block, elapsedTime)
    local plusLevel = 0
    local plusTimer = 0
    local r, g, b = 0, 0, 0
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
            r, g, b = 1, 1, 1
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

local function UpdateDeath()
    local deathes, timeLost = C_ChallengeMode.GetDeathCount()
    if deathes > 0 then
        fIPMT.deathTimer:SetText("-" .. GetTimeStringFromSeconds(timeLost, false, true) .. " [" .. deathes .. "]")
        fIPMT.deathTimer:Show()
    else
        fIPMT.deathTimer:Hide()
    end
end

local function ShowFrame()
    local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()
    local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()

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
    dungeon.trash.total = 0
    dungeon.trash.current = 0
    dungeon.trash.killed = 0
    ObjectiveTrackerFrame:Show()
end

-- Based on addon "Mythic Plus Pull Estimator"
local function ShowPrognosis()
    local prognosis = 0
    for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
        if nameplate.UnitFrame.unitExists and UnitCanAttack("player", nameplate.UnitFrame.displayedUnit) and not UnitIsDead(nameplate.UnitFrame.displayedUnit) then
            local threat = UnitThreatSituation("player", nameplate.UnitFrame.displayedUnit) or -1
            if threat >= 0 or UnitPlayerControlled(nameplate.UnitFrame.displayedUnit .. "target") then
                local guID = UnitGUID(nameplate.UnitFrame.displayedUnit)
                local npcID = select(6, strsplit("-", guID))
                npcID = tonumber(npcID)
                local percent = GetEnemyPercent(npcID)
                if percent then
                    prognosis = prognosis + percent
                end
            end
        end
    end
    if prognosis > 0 then
        local progress = dungeon.trash.current / dungeon.trash.total * 100 + prognosis
        progress = math.min(100, progress)
        if dungeon.isReaping then
            if (progress % 20 > 18) then
                fIPMT.progress:SetTextColor(1,0,0)
            elseif (progress % 20 > 15) then
                fIPMT.progress:SetTextColor(1,1,0)
            else
                fIPMT.progress:SetTextColor(1,1,1)
            end
        end
        fIPMT.prognosis:SetFormattedText("%.2f%%", progress)
        fIPMT.prognosis:Show()
    else
        fIPMT.prognosis:Hide()
    end
end


local function OnTooltipSetUnit(tooltip)
    if dungeon.trash.total > 0 then
        local unit = select(2, tooltip:GetUnit())
        local guID = unit and UnitGUID(unit)

        if guID then
            local npcID = select(6, strsplit("-", guID))
            npcID = tonumber(npcID)
            local percent = GetEnemyPercent(npcID)
            if (percent ~= nil) then
                tooltip:AddDoubleLine("|cFFEEDE70+" .. percent .. "%")
            end
        end
    end
end

hooksecurefunc("Scenario_ChallengeMode_UpdateTime", UpdateTime)
hooksecurefunc("Scenario_ChallengeMode_ShowBlock", ShowFrame)

function IPMythicTimer:OnEvent(self, event, ...)
    local arg1, arg2 = ...;

    if (event == "ADDON_LOADED" and arg1 == "IPMythicTimer") then
        InitDB()
    elseif (event == "CHALLENGE_MODE_DEATH_COUNT_UPDATED") then
        UpdateDeath()
    elseif (event == "SCENARIO_CRITERIA_UPDATE") then
        UpdateCriteria()
    elseif (event == "CHALLENGE_MODE_COMPLETED") then
        StopTimer()
    elseif (event == "PLAYER_ENTERING_WORLD") then
        UpdateCriteria()
        local inInstance, instanceType = IsInInstance()
        if not (inInstance and instanceType == "party") then
            StopTimer()
        end
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        CombatLogEvent()
    end
end

local updateTimer = 0 

function IPMythicTimer:OnUpdate(elapsed)
    updateTimer = updateTimer + elapsed * 1000
    if updateTimer >= 400 then
        updateTimer = 0
        ShowPrognosis()
    end
end

function InitDB()
    if (IPMTDB == nil) then
        IPMTDB = {}
    end
end

function IPMythicTimer:StartAddon()
    fIPMT:RegisterEvent("ADDON_LOADED")
    fIPMT:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
    fIPMT:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    fIPMT:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    fIPMT:RegisterEvent("PLAYER_ENTERING_WORLD")
    fIPMT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    fIPMT:RegisterEvent("UNIT_COMBAT")

    GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
end
