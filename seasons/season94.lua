local AddonName, Addon = ...

if Addon.season.number ~= 94 then return end

Addon.season.affix = 131

local NATHREZIM_ID = 189878
local ZULGAMUX_ID  = 190128

local shroudedNpc = {
    [NATHREZIM_ID] = { -- Nathrezim Infiltrator
        [9]  = 4, -- Karazhan Lower
        [10] = 6, -- Karazhan Upper
        [25] = 7, -- Mechagon Island (Junkyard)
        [26] = 3, -- Mechagon City (Workshop)
        [37] = 3, -- Tazavesh Streets
        [38] = 6, -- Tazavesh Gambit
        [40] = 6, -- Grimrail Depot
        [41] = 4, -- Iron Docks
    },
    [ZULGAMUX_ID] = { -- Zul'gamux
        [9]  = 12, -- Karazhan Lower
        [10] = 18, -- Karazhan Upper
        [25] = 21, -- Mechagon Island (Junkyard)
        [26] = 9, -- Mechagon City (Workshop)
        [37] = 9, -- Tazavesh Streets
        [38] = 18, -- Tazavesh Gambit
        [40] = 18, -- Grimrail Depot
        [41] = 12, -- Iron Docks
    },
}

local shroudedUID = {}

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

local function GetShroudedID(nameplate)
    local shroudedID = nil
    for i=1, 40 do
        local _, _, _, _, _, _, _, _, _, spellId = UnitBuff(nameplate, i)
        if spellId == 373011 then
            shroudedID = NATHREZIM_ID
            break
        elseif spellId == 373785 then
            shroudedID = ZULGAMUX_ID
            break
        end
    end
    return shroudedID
end

function Addon.season:GetInfoByNamePlate(nameplate, npcUID)
    local info = nil
    local shroudedID = nil
    if npcUID and shroudedUID[npcUID] then
        shroudedID = shroudedUID[npcUID]
    else
        shroudedID = GetShroudedID(nameplate)
    end
    if shroudedID ~= nil then
        info = {
            forces     = 0,
            tooltip    = "|cFFB91BD7" .. Addon.localization.SHROUDED[shroudedID],
            shroudedID = shroudedID,
        }
        local percent = Addon:GetEnemyForces(shroudedID)
        if (percent ~= nil) then
            if IPMTOptions.progress == Addon.PROGRESS_FORMAT_PERCENT then
                info.tooltip = info.tooltip .. " (" .. percent .. "%)"
            else
                info.tooltip = info.tooltip .. " (" .. percent .. ")"
            end
        end
    end
    return info
end

function Addon.season:OnUpdate()
    for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
        local unitName, unitExists = Addon:GetNameplateInfo(nameplate)
        if unitExists and not UnitIsDead(unitName) then
            local guID = UnitGUID(unitName)
            local _, _, _, _, _, npcID, spawnID = strsplit("-", guID)
            if spawnID ~= nil and npcID ~= nil then
                local npcUID = spawnID .. "_" .. npcID
                npcID = tonumber(npcID)
                if shroudedNpc[npcID] then
                    if IPMTDungeon.prognosis[npcUID] ~= nil and not UnitCanAttack("player", unitName) then
                        IPMTDungeon.prognosis[npcUID] = nil
                    end
                else
                    local shroudedID = GetShroudedID(unitName)
                    if shroudedID ~= nil then
                        shroudedUID[npcUID] = shroudedID
                    end
                end
            end
        end
    end
end

function Addon.season:ShowTimer()
    shroudedUID = {}
end
