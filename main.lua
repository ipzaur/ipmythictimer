local AddonName, Addon = ...
Addon.version = 1121

Addon.DECOR_FONT = Addon.FONT_ROBOTO
Addon.DECOR_FONTSIZE_DELTA = 0
if GetLocale() == "zhTW" then
    Addon.DECOR_FONT = "Arial"
    Addon.DECOR_FONTSIZE_DELTA = -2
end

Addon.problems = {}

local REAPING = 117
local CORRUPTED = 120
local TEEMING = 5

local dungeon = {
    id        = 0,
    time      = 0,
    affixes   = {},
    isReaping = false,
    isTeeming = false,
    isCorrupted = false,
    level     = 0,
    trash     = {
        total = 0,
        current = 0,
        killed = 0,
    },
    players = {},
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
    [1490] = 25, -- Mechagon Island (Junkyard)

    [1491] = 26, -- Mechagon City (Workshop)
    [1494] = 26, -- Mechagon City (Workshop)
    [1497] = 26, -- Mechagon City (Workshop)
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
                    if IPMTDB[npcID] == nil or type(IPMTDB[npcID]) == 'number' then
                        IPMTDB[npcID] = {}
                    end
                    if dungeon.isTeeming and npcInfo.teemingCount then
                        IPMTDB[npcID][dungeon.isTeeming] = npcInfo.teemingCount
                    else
                        IPMTDB[npcID][dungeon.isTeeming] = npcInfo.count
                    end
                end
                return npcInfo.count
            end
        end
    end
    return nil
end

local function GetEnemyPercent(npcID, formatType)
    local percent = nil
    -- Exclude Reaping mobs
    if npcID == 148716 or npcID == 148893 or npcID == 148894 then
        return percent
    end
    -- Corrupted has different "enemy force" on teeming
    if Addon.isCorrupted[npcID] then
        percent = Addon:GetCorruptedForce(dungeon.isTeeming)
    elseif IPMTDB and IPMTDB[npcID] and type(IPMTDB[npcID]) ~= 'number' and IPMTDB[npcID][dungeon.isTeeming] then
        percent = IPMTDB[npcID][dungeon.isTeeming]
    else
        percent = getFromMDT(npcID, true)
    end

    if percent and formatType == 1 then
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
            if not IPMTDB then
                IPMTDB = {}
            end
            if IPMTDB[killInfo.npcID] == nil or type(IPMTDB[killInfo.npcID]) == 'number' then
                IPMTDB[killInfo.npcID] = {}
            end
            if IPMTDB[killInfo.npcID][dungeon.isTeeming] == nil then
                IPMTDB[killInfo.npcID][dungeon.isTeeming] = killInfo.progress
            end
            clearKillInfo()
        end
    end
end

function Addon:UpdateCriteria()
    local numCriteria = select(3, C_Scenario.GetStepInfo())

    for c = 1, numCriteria do
        local name, _, completed, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(c)
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

            if IPMTOptions.progress == 1 then
                local progress = dungeon.trash.current / dungeon.trash.total * 100
                progress = math.min(100, progress)
                if dungeon.isReaping then
                    if (progress % 20 > 18) then
                        Addon.fMain.progress.text:SetTextColor(1,0,0)
                    elseif (progress % 20 > 15) then
                        Addon.fMain.progress.text:SetTextColor(1,1,0)
                    else
                        Addon.fMain.progress.text:SetTextColor(1,1,1)
                    end
                end
                if IPMTOptions.direction == 2 then
                    progress = 100 - progress
                end
                Addon.fMain.progress.text:SetFormattedText("%.2f%%", progress)
            else
                local progress = math.min(dungeon.trash.current, dungeon.trash.total)
                if IPMTOptions.direction == 1 then
                    Addon.fMain.progress.text:SetText(progress .. "/" .. dungeon.trash.total)
                else
                    Addon.fMain.progress.text:SetText(dungeon.trash.total - progress)
                end
            end
        end
    end
end

local function CombatLogEvent()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, x12, x13, x14, x15 = CombatLogGetCurrentEventInfo()

    if event == "UNIT_DIED" then
        if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0
                and bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_NPC) > 0
                and (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 or bit.band(destFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) > 0) then
            local _, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", destGUID)
            local npcID = select(6, strsplit("-", destGUID))
            npcID = tonumber(npcID)
            if not Addon.isCorrupted[npcID] and not (IPMTDB and IPMTDB[npcID] and (type(IPMTDB[npcID]) ~= 'number') and IPMTDB[npcID][dungeon.isTeeming]) and (getFromMDT(npcID, true) == nil) then
                killInfo.npcID = npcID
                killInfo.diedTime = GetTime()
                GrabMobInfo()
            else
                clearKillInfo()
            end
            if Addon.isCorrupted[npcID] then
                for i=1, 40 do
                    local _, _, _, _, _, _, _, _, _, spellId = UnitAura("player", i, "HARMFUL")
                    if spellId and spellId == 313445 then
                        Addon.DB.global.dungeon.corrupted[npcID] = 1
                        Addon:SetCorruption(npcID, 1)
                        break
                    end
                end
            end
        end
        if (bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0) and (not UnitIsFeignDeath(destName)) then
            local spellId, spellIcon, enemy, damage
            if dungeon.players[destName] == nil then
                spellId = nil
                spellIcon = nil
                enemy = Addon.localization.UNKNOWN
                damage = ''
            else
                spellId = dungeon.players[destName].spellId
                enemy   = dungeon.players[destName].enemy
                damage  = dungeon.players[destName].damage
                if spellId > 1 then
                    spellIcon = select(3, GetSpellInfo(spellId))
                else
                    spellIcon = 130730 -- Melee Attack Icon
                end
            end
            table.insert(Addon.DB.global.dungeon.deathes.list, {
                playerName = destName,
                time       = dungeon.time,
                enemy      = enemy,
                damage     = damage,
                spell      = {
                    id   = spellId,
                    icon = spellIcon,
                },
            })
            dungeon.players[destName] = nil
        end
    elseif bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
        if event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" then
            dungeon.players[destName] = {
                spellId = x12,
                enemy   = sourceName,
                damage  = x15,
            }
        elseif event == "SWING_DAMAGE" then
            dungeon.players[destName] = {
                spellId = 1,
                enemy   = sourceName,
                damage  = x12,
            }
        elseif event == "RANGE_DAMAGE" then
            dungeon.players[destName] = {
                spellId = 75,
                enemy   = sourceName,
                damage  = x12,
            }
        end
    end
end

local function UpdateTime(block, elapsedTime)
    if not Addon.keyActive then
        return
    end
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
        Addon.fMain.timer.text:SetText(SecondsToClock(block.timeLimit - elapsedTime))
        Addon.fMain.timer.text:SetTextColor(0, 1, 0)
        if plusTimer > 0 then
            Addon.fMain.plusTimer.text:SetText(SecondsToClock(plusTimer))
            Addon.fMain.plusTimer:Show()
            g = 1
            if (plusLevel < 2) then
                r = 1
            end
        else
            Addon.fMain.plusTimer:Hide()
            r, g, b = 1, 1, 1
        end
        plusLevel = "+" .. plusLevel+1
    else
        plusLevel = "-1"
        Addon.fMain.timer.text:SetText(SecondsToClock(elapsedTime - block.timeLimit))
        Addon.fMain.plusTimer.text:SetText(SecondsToClock(elapsedTime))
        Addon.fMain.plusTimer:Show()
        r = 1
    end
    dungeon.time = elapsedTime
    Addon.fMain.timer.text:SetTextColor(r, g, b)
    Addon.fMain.plusLevel.text:SetText(plusLevel)
end

local function UpdateDeath()
    local deathes, timeLost = C_ChallengeMode.GetDeathCount()
    if deathes > 0 then
        Addon.fMain.deathTimer.text:SetText("-" .. SecondsToClock(timeLost) .. " [" .. deathes .. "]")
        Addon.fMain.deathTimer:Show()
    else
        Addon.fMain.deathTimer:Hide()
    end
end

local function BossKilled(encounterName)
    for b, boss in ipairs(Addon.DB.global.dungeon.bosses) do
        if boss.name == encounterName then
            boss.killed = true
            Addon.DB.global.dungeon.bossesKilled = Addon.DB.global.dungeon.bossesKilled + 1
            Addon.fMain.bosses.text:SetText(Addon.DB.global.dungeon.bossesKilled .. "/" .. #Addon.DB.global.dungeon.bosses)
            break
        end
    end
end

function Addon:OnBossesEnter(self)
    if not Addon.fOptions:IsShown() then
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetText(Addon.localization.HELP.BOSSES, 1, 1, 1)
        GameTooltip:AddLine(" ")
        for i, boss in ipairs(Addon.DB.global.dungeon.bosses) do
            local color = 1
            if boss.killed then
                color = .45
            end
            GameTooltip:AddLine(boss.name, color, color, color)
        end
        GameTooltip:Show()
    end
end

function Addon:OnAffixEnter(self, iconNum)
    if not Addon.fOptions:IsShown() then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local affixNum = #dungeon.affixes - iconNum + 1
        GameTooltip:SetText(dungeon.affixes[affixNum].name, 1, 1, 1, 1, true)
        GameTooltip:AddLine(dungeon.affixes[affixNum].text, nil, nil, nil, true)
        GameTooltip:Show()
    end
end

function Addon:OnCorruptionEnter(self, corruptionId)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetText(Addon.localization.CORRUPTED[corruptionId], 1, 1, 1, 1, true)
    GameTooltip:Show()
end

function Addon:OnDeathTimerEnter(self)
    if not Addon.fOptions:IsShown() then
        local deathes, timeLost = C_ChallengeMode.GetDeathCount()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.DEATHCOUNT .. " : " .. deathes, 1, 1, 1)
        GameTooltip:AddLine(Addon.localization.DEATHTIME .. " : " .. SecondsToClock(timeLost), .8, 0, 0)
        GameTooltip:AddLine(" ")

        local counts = {}
        for i, death in ipairs(Addon.DB.global.dungeon.deathes.list) do
            if counts[death.playerName] then
                counts[death.playerName] = counts[death.playerName] + 1
            else
                counts[death.playerName] = 1
            end
        end
        local list = {}
        for playerName, count in pairs(counts) do
            local _, class = UnitClass(playerName)
            table.insert(list, {
                count      = count,
                playerName = playerName,
                class      = class,
            })
        end
        table.sort(list, function(a, b)
            if a.count ~= b.count then
                return a.count > b.count
            else
                return a.playerName < b.playerName
            end
        end)
        for i, item in ipairs(list) do
            local color = RAID_CLASS_COLORS[item.class] or HIGHLIGHT_FONT_COLOR
            GameTooltip:AddDoubleLine(item.playerName, item.count, color.r, color.g, color.b, HIGHLIGHT_FONT_COLOR:GetRGB())
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(Addon.localization.DEATHSHOW)

        GameTooltip:Show()
    end
end

function Addon:TryToShowCorruptions()
    if not IPMTOptions.frame.corruptions.hidden and ( (Addon.keyActive and dungeon.isCorrupted) or (not Addon.keyActive and Addon.fOptions:IsShown()) or Addon.isCustomizing ) then
        if Addon.DB.global.dungeon.corrupted == nil or not Addon.keyActive then
            Addon.DB.global.dungeon.corrupted = {}
        end
        for corruptionId, flag in pairs(Addon.isCorrupted) do
            local killed = 0
            if Addon.DB.global.dungeon.corrupted[corruptionId] then
                killed = 1
            end
            local cost = ""
            if Addon.keyActive and dungeon.isCorrupted then
                cost = Addon:GetCorruptedForce(dungeon.isTeeming)
                if IPMTOptions.progress == 1 then
                    cost = 100 / dungeon.trash.total * cost
                    cost = round(cost, 2) .. "%"
                end
            else
                if IPMTOptions.progress == 1 then
                    cost = "1.25%"
                else
                    cost = 12
                end
            end
            Addon:SetCorruption(corruptionId, killed)
            Addon.fMain.corruption[corruptionId].text:SetText(cost)
        end
        Addon.fMain.corruptions:Show()
    else
        Addon.fMain.corruptions:Hide()
    end
end

local function PrintDebug()
    local text = Addon:PrintObject(dungeon, 'dungeon.', true)
    text = text .. "\n\n" .. Addon:PrintObject(IPMTOptions, 'IPMTOptions.', true)
    text = text .. "\n\n FRAMES \n\n"
    for frame, info in pairs(Addon.frameInfo) do
        if info.text ~= nil then
            text = text .. frame .. ".text = '" .. Addon.fMain[frame].text:GetText() .. "'\n"
            local fontName, fontSize = Addon.fMain[frame].text:GetFont()
            text = text .. frame .. ".font = '" .. fontName .. "'\n"
            text = text .. frame .. ".size = " .. fontSize .. "\n"
        end
    end
    Addon.fDebug:Show()
    Addon.fDebug.textarea:SetText(text)
end

local function ShowFrame()
    local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()
    local name, _, difficulty, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()

    if difficulty == 8 then
        dungeon.level = level
        dungeon.affixes = {}
        dungeon.isReaping   = false
        dungeon.isTeeming   = false
        dungeon.isCorrupted = false

        Addon.DB.global.dungeon.bossesKilled = 0
        if Addon.DB.global.dungeon.bosses == nil then 
            local mapID = C_Map.GetBestMapForUnit("player")
            local uiMapGroupID = C_Map.GetMapGroupID(mapID)
            local mapGroup = {}
            if uiMapGroupID == nil or mapID == 1490 then
                table.insert(mapGroup, {
                    mapID = mapID,
                })
            else
                mapGroup = C_Map.GetMapGroupMembersInfo(uiMapGroupID)
            end
            Addon.DB.global.dungeon.bosses = {}
            for g, map in ipairs(mapGroup) do
                if (mapID ~= 1490 and map.mapID ~= 1490) or (mapID == 1490 and map.mapID == 1490) then
                    local encounters = C_EncounterJournal.GetEncountersOnMap(map.mapID)
                    for e, encounter in ipairs(encounters) do
                        local name = EJ_GetEncounterInfo(encounter.encounterID)
                        table.insert(Addon.DB.global.dungeon.bosses, {
                            name   = name,
                            killed = false,
                        })
                    end
                end
            end
        else
            for b, boss in ipairs(Addon.DB.global.dungeon.bosses) do
                if boss.killed then
                    Addon.DB.global.dungeon.bossesKilled = Addon.DB.global.dungeon.bossesKilled + 1
                end
            end
        end
        Addon.fMain.bosses.text:SetText(Addon.DB.global.dungeon.bossesKilled .. "/" .. #Addon.DB.global.dungeon.bosses)

        Addon.fMain.level.text:SetText(dungeon.level)
        local count = #affixes
        for i,affix in pairs(affixes) do
            local name, description, filedataid = C_ChallengeMode.GetAffixInfo(affix)
            local iconNum = count - i + 1
            dungeon.affixes[i] = {
                name = name,
                text = description,
            }
            SetPortraitToTexture(Addon.fMain.affix[iconNum].Portrait, filedataid)
            Addon.fMain.affix[iconNum]:Show()

            if affix == REAPING then
                dungeon.isReaping = true
            end
            if affix == TEEMING then
                dungeon.isTeeming = true
            end
            if affix == CORRUPTED then
                dungeon.isCorrupted = true
            end
        end
        for a = count+1,4 do
            Addon.fMain.affix[a]:Hide()
        end
        UpdateDeath()
        Addon:UpdateCriteria()
        Addon.fMain:Show()
        Addon.fMain.progress.text:SetTextColor(1,1,1)
        Addon.fMain.prognosis.text:SetTextColor(1,1,1)

        local dungeonName = C_Scenario.GetInfo()
        Addon.fMain.dungeonname.text:SetText(dungeonName)
        Addon.fMain:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        Addon.fMain:RegisterEvent("BOSS_KILL")
        Addon.keyActive = true
        Addon:TryToShowCorruptions()
        Addon:RecalcElem()
        Addon:CloseOptions()

        ObjectiveTrackerFrame:Hide()
    end
end

local function WipeDungeon()
    dungeon.trash.total = 0
    dungeon.trash.current = 0
    dungeon.trash.killed = 0
    if Addon.DB.global.dungeon.bosses ~= nil then
        wipe(Addon.DB.global.dungeon.bosses)
    end
    Addon.DB.global.dungeon.bossesKilled = 0
    Addon.DB.global.dungeon.bosses = nil
    wipe(Addon.DB.global.dungeon.deathes.list)
    Addon.DB.global.dungeon.deathes.count = 0
    Addon.DB.global.dungeon.corrupted = {}
    dungeon.time = 0
    wipe(dungeon.players)
end

local function HideTimer()
    if not Addon.fOptions:IsShown() then
        Addon.fMain:Hide()
    end
    Addon.keyActive = false
    ObjectiveTrackerFrame:Show()
    Addon.fMain:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Addon.fMain:UnregisterEvent("BOSS_KILL")
end

local function ShowPrognosis()
    local prognosis = 0
    for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
        if nameplate.UnitFrame.unitExists and UnitCanAttack("player", nameplate.UnitFrame.displayedUnit) and not UnitIsDead(nameplate.UnitFrame.displayedUnit) then
            local threat = UnitThreatSituation("player", nameplate.UnitFrame.displayedUnit) or -1
            if threat >= 0 or UnitPlayerControlled(nameplate.UnitFrame.displayedUnit .. "target") then
                local guID = UnitGUID(nameplate.UnitFrame.displayedUnit)
                local npcID = select(6, strsplit("-", guID))
                npcID = tonumber(npcID)
                local percent = GetEnemyPercent(npcID, IPMTOptions.progress)
                if percent then
                    prognosis = prognosis + percent
                end
            end
        end
    end
    if prognosis > 0 then
        if IPMTOptions.progress == 1 then
            local currentProgress = dungeon.trash.current / dungeon.trash.total * 100
            local progress = currentProgress + prognosis
            progress = math.min(100, progress)
            if dungeon.isReaping then
                local currentWave = math.floor(currentProgress / 20)
                local prognosisWave = math.floor(progress / 20)
                if (progress % 20 > 18 or currentWave < prognosisWave) then
                    Addon.fMain.prognosis.text:SetTextColor(1,0,0)
                elseif (progress % 20 > 15) then
                    Addon.fMain.prognosis.text:SetTextColor(1,1,0)
                else
                    Addon.fMain.prognosis.text:SetTextColor(1,1,1)
                end
            end
            if IPMTOptions.direction == 2 then
                progress = 100 - progress
            end
            Addon.fMain.prognosis.text:SetFormattedText("%.2f%%", progress)
        else
            local progress = dungeon.trash.current + prognosis
            if IPMTOptions.direction == 1 then
                progress = math.min(progress, dungeon.trash.total)
            else
                progress = math.max(dungeon.trash.total - progress, 0)
            end
            Addon.fMain.prognosis.text:SetText(progress)
        end
        Addon.fMain.prognosis:Show()
    elseif not Addon.isCustomizing then
        Addon.fMain.prognosis:Hide()
    end
end

local function OnTooltipSetUnit(tooltip)
    if dungeon.trash.total > 0 then
        local unit = select(2, tooltip:GetUnit())
        local guID = unit and UnitGUID(unit)

        if guID then
            local npcID = select(6, strsplit("-", guID))
            npcID = tonumber(npcID)
            local percent = GetEnemyPercent(npcID, IPMTOptions.progress)
            if (percent ~= nil) then
                if IPMTOptions.progress == 1 then
                    percent = percent .. "%"
                end
                tooltip:AddDoubleLine("|cFFEEDE70" .. percent)
            end
        end
    end
end

hooksecurefunc("Scenario_ChallengeMode_UpdateTime", UpdateTime)
hooksecurefunc("Scenario_ChallengeMode_ShowBlock", ShowFrame)

local updateTimer = 0 
function Addon:OnUpdate(elapsed)
    if Addon.keyActive then
        updateTimer = updateTimer + elapsed * 1000
        if updateTimer >= 300 then
            updateTimer = 0
            ShowPrognosis()
        end
    end
end

function Addon:Init()
    if IPMTDB == nil then
        IPMTDB = {}
    end
    if MethodDungeonTools then
        local MDTversion = GetAddOnMetadata('MethodDungeonTools', 'Version')
        if not IPMTOptions.MDTversion or (IPMTOptions.MDTversion ~= MDTversion) then
            IPMTOptions.MDTversion = MDTversion
            IPMTDB = {}
        end
    end
    Addon.DB = LibStub("AceDB-3.0"):New("IPMTOptions", {
        global = {
            minimap = {
                hide = false,
            },
            dungeon = {
                deathes = {
                    list = {},
                },
            },
        },
    })

    Addon.isCustomizing = false
    Addon.keyActive = false
    Addon:LoadOptions()

    Addon:InitIcon()
end

local function toggleOptions()
    Addon:ShowOptions()
end

-- Copypasted from Angry Keystones
local function InsertKeystone()
    for container = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local slots = GetContainerNumSlots(container)
        for slot = 1,slots do
            local slotLink = select(7, GetContainerItemInfo(container, slot))
            if slotLink and slotLink:match("|Hkeystone:") then
                PickupContainerItem(container, slot)
                if (CursorHasItem()) then
                    C_ChallengeMode.SlotKeystone()
                end
            end
        end
    end
end


function Addon:StartAddon()
    SLASH_IPMTOPTS1 = "/ipmt"
    SLASH_IPMTDEBUG1 = "/ipmt_debug"
    SlashCmdList["IPMTOPTS"] = toggleOptions
    SlashCmdList["IPMTDEBUG"] = PrintDebug

    Addon.fMain:RegisterEvent("ADDON_LOADED")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_RESET")
    Addon.fMain:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    Addon.fMain:RegisterEvent("PLAYER_ENTERING_WORLD")
    Addon.fMain:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")

    GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
    hooksecurefunc(ObjectiveTrackerFrame, "Show", function(self)
        if Addon.keyActive then
            ObjectiveTrackerFrame:Hide()
        end
    end)

    DEFAULT_CHAT_FRAME:AddMessage(Addon.localization.STARTINFO)
end

function Addon:OnEvent(self, event, ...)
    local arg1, arg2 = ...
    if (event == "ADDON_LOADED" and arg1 == AddonName) then
        Addon:Init()
    elseif (event == "CHALLENGE_MODE_DEATH_COUNT_UPDATED") then
        UpdateDeath()
    elseif (event == "SCENARIO_CRITERIA_UPDATE") then
        Addon:UpdateCriteria()
    elseif (event == "CHALLENGE_MODE_RESET") then
        WipeDungeon()
    elseif (event == "CHALLENGE_MODE_COMPLETED") then
        Addon.keyActive = false
    elseif (event == "PLAYER_ENTERING_WORLD") then
        local inInstance, instanceType = IsInInstance()
        if not (inInstance and instanceType == "party") then
            HideTimer()
        else
            Addon:UpdateCriteria()
        end
    elseif (event == "CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN") then
        InsertKeystone()
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        CombatLogEvent()
    elseif (event == "BOSS_KILL") then
        BossKilled(arg2)
    end
end

function Addon:OnShow()
    Addon.fOptions:ClearAllPoints()
    Addon.fOptions:SetPoint(IPMTOptions.position.options.point, IPMTOptions.position.options.x, IPMTOptions.position.options.y)
    Addon.fMain:ClearAllPoints()
    Addon.fMain:SetPoint(IPMTOptions.position.main.point, IPMTOptions.position.main.x, IPMTOptions.position.main.y)
    Addon:SetFont(IPMTOptions.font) -- may be it fix some bug ^_^
end
