local AddonName, Addon = ...

Addon.MDTdungeon = {
-- SL
    [1663] = 30, -- Halls of Atonement
    [1664] = 30, -- Halls of Atonement
    [1665] = 30, -- Halls of Atonement

    [1666] = 35, -- The Necrotic Wake
    [1667] = 35, -- The Necrotic Wake
    [1668] = 35, -- The Necrotic Wake

    [1669] = 31, -- Mists Of Tirna Scithe

    [1674] = 32, -- Plaguefall
    [1697] = 32, -- Plaguefall

    [1675] = 33, -- Sanguine Depths
    [1676] = 33, -- Sanguine Depths

    [1677] = 29, -- De Other Side
    [1678] = 29, -- De Other Side
    [1679] = 29, -- De Other Side
    [1680] = 29, -- De Other Side

    [1683] = 36, -- Theater Of Pain
    [1684] = 36, -- Theater Of Pain
    [1685] = 36, -- Theater Of Pain
    [1686] = 36, -- Theater Of Pain
    [1687] = 36, -- Theater Of Pain

    [1692] = 34, -- Spires Of Ascension
    [1693] = 34, -- Spires Of Ascension
    [1694] = 34, -- Spires Of Ascension
    [1695] = 34, -- Spires Of Ascension


-- BfA
    [934]  = 15, -- Atal Dazar

    [936]  = 16, -- Freehold

    [942]  = 18, -- Shrine of the Storm
    [1039] = 18, -- Shrine of the Storm

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


-- Legion
    [751] = 1, -- Black Rook Hold
    [752] = 1, -- Black Rook Hold
    [753] = 1, -- Black Rook Hold
    [754] = 1, -- Black Rook Hold
    [755] = 1, -- Black Rook Hold
    [756] = 1, -- Black Rook Hold

    [845] = 2, -- Cathedral of Eternal Night
    [846] = 2, -- Cathedral of Eternal Night
    [847] = 2, -- Cathedral of Eternal Night
    [848] = 2, -- Cathedral of Eternal Night
    [849] = 2, -- Cathedral of Eternal Night

    [761] = 3, -- Court of Stars
    [762] = 3, -- Court of Stars
    [763] = 3, -- Court of Stars

    [733] = 4, -- Darkheart Thicket

    [713] = 5, -- Eye of Azshara

    [703] = 6, -- Halls of Valor
    [704] = 6, -- Halls of Valor
    [705] = 6, -- Halls of Valor

    [706] = 7, -- Maw of Souls
    [707] = 7, -- Maw of Souls
    [708] = 7, -- Maw of Souls

    [731] = 8, -- Neltharions Lair

    [749] = 12, -- The Arcway

    [710] = 13, -- Vault of the Wardens
    [711] = 13, -- Vault of the Wardens
    [712] = 13, -- Vault of the Wardens
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

function Addon:MDTHasDB()
    return #MDT.dungeonEnemies[33] > 0
end