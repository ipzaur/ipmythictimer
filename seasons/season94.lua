local AddonName, Addon = ...

if Addon.season.number ~= 94 then return end

Addon.season.affix = 131

local shroudedNpc = {
    [189878] = { -- Nathrezim Infiltrator
        [9]  = 4, -- Karazhan Lower
        [10] = 6, -- Karazhan Upper
        [25] = 7, -- Mechagon Island (Junkyard)
        [26] = 4, -- Mechagon City (Workshop)
        [37] = 3, -- Tazavesh Streets
        [38] = 6, -- Tazavesh Gambit
        [40] = 6, -- Grimrail Depot
        [41] = 4, -- Iron Docks
    },
    [190128] = { -- Zul'gamux
        [9]  = 12, -- Karazhan Lower
        [10] = 18, -- Karazhan Upper
        [25] = 21, -- Mechagon Island (Junkyard)
        [26] = 12, -- Mechagon City (Workshop)
        [37] = 9, -- Tazavesh Streets
        [38] = 18, -- Tazavesh Gambit
        [40] = 18, -- Grimrail Depot
        [41] = 12, -- Iron Docks
    },
}

function Addon.season:GetForces(npcID, isTeeming)
    if shroudedNpc[npcID] == nil then
        return nil
    end

    local mapID = C_Map.GetBestMapForUnit("player")
    local MDTMapID = Addon.MDTdungeon[mapID]
    if shroudedNpc[npcID][MDTMapID] ~= nil then
        return shroudedNpc[npcID][MDTMapID]
    else
        return nil
    end
end