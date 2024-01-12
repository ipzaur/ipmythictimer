local AddonName, Addon = ...

Addon.MDTdungeon = {
-- DF
    [399] = 42, -- Ruby Life Pools
    [400] = 43, -- The Nokhud Offensive
    [401] = 44, -- The Azure Vault
    [402] = 45, -- Algeth'ar Academy
    [403] = 51, -- Uldaman: Legacy of Tyr
    [404] = 50, -- Neltharus
    [405] = 48, -- Brackenhide Hollow
    [406] = 49, -- Halls Of Infusion
    [463] = 100, -- Dawn Of The Infinite Lower
    [464] = 101, -- Dawn Of The Infinite Upper

-- SL
    [375] = 31, -- Mists Of Tirna Scithe
    [376] = 35, -- The Necrotic Wake
    [377] = 29, -- De Other Side
    [378] = 30, -- Halls of Atonement
    [379] = 32, -- Plaguefall
    [380] = 33, -- Sanguine Depths
    [381] = 34, -- Spires Of Ascension
    [382] = 36, -- Theater Of Pain
    [391] = 37, -- Tazavesh Streets
    [392] = 38, -- Tazavesh Gambit

-- BfA
    [244] = 15, -- Atal Dazar
    [245] = 16, -- Freehold
    [246] = 23, -- Tol Dagor
    [247] = 21, -- The Motherlode
    [249] = 17, -- Kings Rest
    [248] = 102, -- Waycrest Manor
    [250] = 20, -- Temple of Sethraliss
    [251] = 22, -- The Underrot
    [252] = 18, -- Shrine of the Storm
    [353] = 19, -- Siege of Bolarus
    [369] = 25, -- Mechagon Island (Junkyard)
    [370] = 26, -- Mechagon City (Workshop)

-- Legion
    [197] = 5, -- Eye of Azshara
    [198] = 4, -- Darkheart Thicket
    [199] = 1, -- Black Rook Hold
    [200] = 6, -- Halls of Valor
    [206] = 8, -- Neltharions Lair
    [207] = 13, -- Vault of the Wardens
    [208] = 7, -- Maw of Souls
    [209] = 12, -- The Arcway
    [210] = 3, -- Court of Stars
    [227] = 9, -- Karazhan Lower
    [233] = 2, -- Cathedral of Eternal Night
    [234] = 10, -- Karazhan Upper

-- WoD
    [165] = 46, -- Shadowmoon Burial Grounds
    [166] = 40, -- Grimrail Depot
    [168] = 104, -- The Everbloom
    [169] = 41, -- Iron Docks

-- Pandaria
    [2] = 47, -- Temple of the Jade Serpent

-- Cataclysm
    [438] = 77, -- The Vortex Pinnacle
    [456] = 105, -- Throne of Tides
}


function Addon:GetForcesFromMDT(npcID, wsave)
    npcID = tonumber(npcID)
    if not MDT then
        return nil
    end
    local npcInfos = MDT.dungeonEnemies[Addon.MDTdungeon[IPMTDungeon.keyMapId]]
    if npcInfos then
        for i,npcInfo in pairs(npcInfos) do
            if npcInfo.id == npcID then
                if wsave then
                    if IPMTDB[IPMTDungeon.keyMapId] == nil then
                        IPMTDB[IPMTDungeon.keyMapId] = {}
                    end
                    if IPMTDB[IPMTDungeon.keyMapId][npcID] == nil then
                        IPMTDB[IPMTDungeon.keyMapId][npcID] = {}
                    end
                    if IPMTDungeon.isTeeming and npcInfo.teemingCount then
                        IPMTDB[IPMTDungeon.keyMapId][npcID][IPMTDungeon.isTeeming] = npcInfo.teemingCount
                    else
                        IPMTDB[IPMTDungeon.keyMapId][npcID][IPMTDungeon.isTeeming] = npcInfo.count
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

function Addon:CheckMDTVersion(MDTName)
    local MDTversion = C_AddOns.GetAddOnMetadata(MDTName, 'Version')
    if MDTversion ~= nil and (not IPMTOptions.MDTversion or (IPMTOptions.MDTversion ~= MDTversion)) then
        if Addon:MDTHasDB() then
            IPMTOptions.MDTversion = MDTversion
            IPMTDB = {}
        end
    end
end
