local AddonName, Addon = ...

if Addon.season.number ~= 94 then return end

Addon.season.affix = 131

function Addon.season:GetForces(npcID, isTeeming)
    if npcID == 189878 or npcID == 190128 then
        return 0
    end
end