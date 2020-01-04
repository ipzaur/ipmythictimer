local AddonName, Addon = ...

function Addon:ToggleHelp()
    if Addon.fOptions.help.glow:IsShown() then
        Addon:HideHelp()
    else
        Addon:ShowHelp()
    end
end