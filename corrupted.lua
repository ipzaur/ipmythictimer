local AddonName, Addon = ...

-- Enemy forces for corrupted mobs (season 4)
-- Grabbed from MDT

Addon.isCorrupted = {
    [161124] = true,
    [161241] = true,
    [161243] = true,
    [161244] = true,
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