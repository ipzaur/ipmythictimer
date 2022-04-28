local AddonName, Addon = ...

if Addon.season.number ~= 93 then return end

Addon.season.affix = 130

local encryptedNpc = {
    [185680] = true, -- Vy relic
    [185683] = true, -- Wo relic
    [185685] = true, -- Urh relic

    [184911] = true, -- Vy Interceptor
    [184910] = true, -- Wo Drifter
    [184908] = true, -- Urh Dismantler
}

-- Enemy forces for encrypted mobs (season 93)
function Addon.season:GetForces(npcID, isTeeming)
    if encryptedNpc[npcID] == true then
        return 0
    end
end
