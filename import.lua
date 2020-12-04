local AddonName, Addon = ...


function Addon:ShowImport()
    if Addon.fImport == nil then
        Addon:RenderImport()
    end
    Addon.fImport:Show()
end

function Addon:CloseImport()
    if Addon.fImport == nil then
        return
    end
    Addon.fImport:Hide()
end
