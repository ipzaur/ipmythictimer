local AddonName, Addon = ...

local STONEBORN_ID = 174175
local STONEBORN_SPELL = 342171

function Addon:GetNameplateInfo(nameplate)
    local unitName, unitExists = nil, nil
    if nameplate and nameplate.UnitFrame then
        unitExists = nameplate.UnitFrame.unitExists
        unitName = nameplate.UnitFrame.displayedUnit
    end
    return unitName, unitExists
end

local function GrabPrognosis()
    local inCombat = false
    if UnitAffectingCombat("player") then
        inCombat = true
    else
        for i=1,4 do
            if UnitExists("party" .. i) and UnitAffectingCombat("party" .. i) then
                inCombat = true
                break
            end
        end
    end

    if inCombat then
        for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
            local unitName, unitExists = Addon:GetNameplateInfo(nameplate)
            if unitExists and UnitCanAttack("player", unitName) and not UnitIsDead(unitName) then
                local threat = UnitThreatSituation("player", unitName) or -1
                if threat >= 0 or UnitPlayerControlled(unitName .. "target") then
                    local guID = UnitGUID(unitName)
                    local _, _, _, _, _, npcID, spawnID = strsplit("-", guID)
                    if spawnID ~= nil and npcID ~= nil then
                        local npcUID = spawnID .. "_" .. npcID
                        local npcInfo = nil
                        if Addon.season.GetInfoByNamePlate then
                            npcInfo = Addon.season:GetInfoByNamePlate(unitName, npcUID)
                        end
                        if npcInfo ~= nil then
                            IPMTDungeon.prognosis[npcUID] = npcInfo.forces
                        else
                            if not IPMTDungeon.checkmobs[npcUID] and not IPMTDungeon.prognosis[npcUID] then
                                npcID = tonumber(npcID)
                                local forces = Addon:GetEnemyForces(npcID, Addon.PROGRESS_FORMAT_FORCES)
                                if forces then
                                    IPMTDungeon.prognosis[npcUID] = forces
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        IPMTDungeon.prognosis = {}
    end
end

function Addon:ShowPrognosis()
    GrabPrognosis()

    local prognosis = 0
    for npcUID, percent in pairs(IPMTDungeon.prognosis) do
        if percent then
            prognosis = prognosis + percent
        end
    end

    if prognosis > 0 then
        local progress = IPMTDungeon.trash.current + prognosis
        if Addon.season.isActive and Addon.season.Prognosis then
            Addon.season:Prognosis(progress)
        end
        if IPMTOptions.progress == Addon.PROGRESS_FORMAT_PERCENT then
            progress = progress / IPMTDungeon.trash.total * 100
            if IPMTOptions.limitProgress then
                progress = math.min(100, progress)
            end
            if IPMTOptions.direction == Addon.PROGRESS_DIRECTION_DESC then
                progress = 100 - progress
            end
            Addon.fMain.prognosis.text:SetFormattedText("%.2f%%", progress)
        else
            if IPMTOptions.direction == Addon.PROGRESS_DIRECTION_ASC then
                if IPMTOptions.limitProgress then
                    progress = math.min(progress, IPMTDungeon.trash.total)
                end
            else
                if IPMTOptions.limitProgress then
                    progress = math.max(IPMTDungeon.trash.total - progress, 0)
                else
                    progress = IPMTDungeon.trash.total - progress
                end
            end
            Addon.fMain.prognosis.text:SetText(progress)
        end
        Addon.fMain.prognosis:Show()
    elseif not Addon.opened.themes then
        Addon.fMain.prognosis:Hide()
    end
end

function Addon:PrognosisCheck()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, x12, x13, x14, x15 = CombatLogGetCurrentEventInfo()

    if event == "SPELL_AURA_APPLIED" then
        local _, _, _, _, _, npcID, spawnID = strsplit("-", destGUID)
        -- Loyal Stoneborn mind control by Ventyr's
        if tonumber(npcID) == STONEBORN_ID and tonumber(x12) == STONEBORN_SPELL then
            local npcUID = spawnID .. "_" .. npcID
            IPMTDungeon.prognosis[npcUID] = 0
            IPMTDungeon.checkmobs[npcUID] = true
        end
    end
end