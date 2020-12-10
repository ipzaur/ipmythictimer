local AddonName, Addon = ...

local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")

function Addon:ShowImport()
    if Addon.fImport == nil then
        Addon:RenderImport()
    end
    Addon.fImport.textarea:SetText('')
    Addon.fImport.apply:Show()
    Addon.fImport.caption:SetText(Addon.localization.THEMEACTN.IMPORT)
    Addon.fImport:Show()
end

function Addon:ShowExport()
    if Addon.fImport == nil then
        Addon:RenderImport()
    end

    local serialized = LibSerialize:Serialize(IPMTTheme[IPMTOptions.theme])
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForPrint(compressed)

    Addon.fImport.textarea:SetText(encoded)
    Addon.fImport.textarea:HighlightText()
    Addon.fImport.apply:Hide()
    Addon.fImport.caption:SetText(Addon.localization.THEMEACTN.EXPORT)

    Addon.fImport:Show()
end

function Addon:CloseImport()
    if Addon.fImport == nil then
        return
    end
    Addon.fImport:Hide()
end

function Addon:ImportTheme(encoded)
    if encoded == "" then
        return
    end
    local decoded = LibDeflate:DecodeForPrint(encoded)
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    local success, deserialized = LibSerialize:Deserialize(decompressed)
    if success then
        Addon:DuplicateTheme(deserialized, true)
    end
    Addon:CloseImport()
end