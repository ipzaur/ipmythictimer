local AddonName, Addon = ...

function Addon:ToggleHelp()
    if helpShown then
        Addon:HideHelp()
    else
        Addon:ShowHelp()
    end
end