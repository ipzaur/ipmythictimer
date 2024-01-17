local AddonName, Addon = ...

function Addon:ToggleKeyRename()
    local show = false
    if Addon.fKeyRename == nil or not Addon.fKeyRename:IsShown() then
        show = true
    end
    if show then
        Addon:ShowKeyRename()
    else
        Addon:CloseKeyRename()
    end
end

function Addon:ShowKeyRename()
    if Addon.fKeyRename == nil then
        Addon:RenderKeyRename()
    end
    Addon.fKeyRename:Show()
end

function Addon:CloseKeyRename()
    if Addon.fKeyRename ~= nil then
        Addon.fKeyRename:Hide()
    end
end

function Addon:RenameKey(mapKeyId, name)
    if IPMTOptions.keysName == nil then
        IPMTOptions.keysName = {}
    end
    if name == "" and IPMTOptions.keysName[mapKeyId] ~= nil then
        IPMTOptions.keysName[mapKeyId] = nil
        if IPMTDungeon ~= nil and IPMTDungeon.keyActive and IPMTDungeon.keyMapId == mapKeyId then
            local dungeonName = C_ChallengeMode.GetMapUIInfo(IPMTDungeon.keyMapId)
            Addon.fMain.dungeonname.text:SetText(dungeonName)
        end
    elseif name ~= "" then
        IPMTOptions.keysName[mapKeyId] = name
        if IPMTDungeon ~= nil and IPMTDungeon.keyActive and IPMTDungeon.keyMapId == mapKeyId then
            Addon.fMain.dungeonname.text:SetText(IPMTOptions.keysName[mapKeyId])
        end
    end
end