local AddonName, Addon = ...

function Addon:NamePlateKAIfix()
    if NamePlateKAI then
        function Addon:GetNameplateInfo(nameplate)
            local KAINameplate = NamePlateKAI:GetKai(nameplate)
            return KAINameplate.unitID, KAINameplate.unitExists
        end
    end
end