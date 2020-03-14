local AddonName, Addon = ...

-- Enemy forces for corrupted mobs (season 4)
-- Grabbed from MDT

Addon.isCorrupted = {
    [161124] = 1, -- Urg'roth, Breaker of Heroes (Tank breaker)
    [161241] = 4, -- Voidweaver Mal'thir (Spider)
    [161243] = 3, -- Samh'rek, Beckoner of Chaos (Fear)
    [161244] = 2, -- Blood of the Corruptor (Blob)
}

function Addon:GetCorruptedForce(isTeeming)
    local mapID = C_Map.GetBestMapForUnit("player")
    if not isTeeming then
        if mapID == 942 then -- SotS
            return 9
        elseif mapID == 1169 then -- Tol Dagor
            return 7
        else
            return 4
        end
    else
        if mapID == 942 then -- SotS
            return 12
        elseif mapID == 1169 then -- Tol Dagor
            return 10
        else
            return 6
        end
    end
end