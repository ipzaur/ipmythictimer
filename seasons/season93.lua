local AddonName, Addon = ...

if Addon.season.number ~= 93 then return end

Addon.season.affix = 130

-- Enemy forces for encrypted mobs (season 93)
function Addon.season:GetForces(npcID, isTeeming)
    if npcID == 185680 or npcID == 185683 or npcID == 185685 then
        return 0
    end
end
