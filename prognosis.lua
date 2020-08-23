local AddonName, Addon = ...

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
            if nameplate.UnitFrame.unitExists then
                local unitName = nameplate.UnitFrame.displayedUnit
                if UnitCanAttack("player", unitName) and not UnitIsDead(unitName) then
                    local threat = UnitThreatSituation("player", unitName) or -1
                    if threat >= 0 or UnitPlayerControlled(unitName .. "target") then
                        local guID = UnitGUID(unitName)
                        local _, _, _, _, _, npcID, spawnID = strsplit("-", guID)
                        if spawnID ~= nil and npcID ~= nil then
                            local npcUID = spawnID .. "_" .. npcID
                            if not dungeon.prognosis[npcUID] then
                                npcID = tonumber(npcID)
                                local forces = Addon:GetEnemyForces(npcID, Addon.PROGRESS_FORMAT_FORCES)
                                if forces then
                                    dungeon.prognosis[npcUID] = forces
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        dungeon.prognosis = {}
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
        if Addon.season.Prognosis then
            Addon.season.Prognosis(progress)
        end
        if IPMTOptions.progress == Addon.PROGRESS_FORMAT_PERCENT then
            progress = progress / IPMTDungeon.trash.total * 100
            progress = math.min(100, progress)
            if IPMTOptions.direction == Addon.PROGRESS_DIRECTION_DESC then
                progress = 100 - progress
            end
            Addon.fMain.prognosis.text:SetFormattedText("%.2f%%", progress)
        else
            if IPMTOptions.direction == Addon.PROGRESS_DIRECTION_ASC then
                progress = math.min(progress, IPMTDungeon.trash.total)
            else
                progress = math.max(IPMTDungeon.trash.total - progress, 0)
            end
            Addon.fMain.prognosis.text:SetText(progress)
        end
        Addon.fMain.prognosis:Show()
    elseif not Addon.isCustomizing then
        Addon.fMain.prognosis:Hide()
    end
end