local AddonName, Addon = ...

Addon.MDTdungeon = {
    [934]  = 15, -- Atal Dazar
    [936]  = 16, -- Freehold
    [942]  = 18, -- Shrine of the Storm
    [1004] = 17, -- Kings Rest
    [1010] = 21, -- The Motherlode

    [1015] = 24, -- Waycrest Manor
    [1016] = 24, -- Waycrest Manor
    [1017] = 24, -- Waycrest Manor
    [1018] = 24, -- Waycrest Manor
    [1029] = 24, -- Waycrest Manor

    [1038] = 20, -- Temple of Sethraliss
    [1043] = 20, -- Temple of Sethraliss

    [1041] = 22, -- The Underrot
    [1162] = 19, -- Siege of Bolarus

    [974] = 23, -- Tol Dagor
    [975] = 23, -- Tol Dagor
    [976] = 23, -- Tol Dagor
    [977] = 23, -- Tol Dagor
    [978] = 23, -- Tol Dagor
    [979] = 23, -- Tol Dagor
    [980] = 23, -- Tol Dagor

    [1490] = 25, -- Mechagon Island (Junkyard)

    [1491] = 26, -- Mechagon City (Workshop)
    [1494] = 26, -- Mechagon City (Workshop)
    [1497] = 26, -- Mechagon City (Workshop)
}


function Addon:GetForcesFromMDT(npcID, wsave)
    if not MDT then
        return nil
    end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not Addon.MDTdungeon[mapID] then
        return nil
    end
    local npcInfos = MDT.dungeonEnemies[Addon.MDTdungeon[mapID]]
    if npcInfos then
        for i,npcInfo in pairs(npcInfos) do
            if npcInfo.id == npcID then
                if wsave then
                    if IPMTDB[npcID] == nil or type(IPMTDB[npcID]) == 'number' then
                        IPMTDB[npcID] = {}
                    end
                    if IPMTDungeon.isTeeming and npcInfo.teemingCount then
                        IPMTDB[npcID][IPMTDungeon.isTeeming] = npcInfo.teemingCount
                    else
                        IPMTDB[npcID][IPMTDungeon.isTeeming] = npcInfo.count
                    end
                end
                return npcInfo.count
            end
        end
    end
    return nil
end