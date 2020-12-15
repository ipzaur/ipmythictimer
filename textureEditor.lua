local AddonName, Addon = ...

local currentDecorID = nil

function Addon:ToggleTextureEditor(decorID)
    local show = false
    if currentDecorID ~= decorID then
        show = true
    end
    Addon:CloseTextureEditor()
    if show then
        Addon:ShowTextureEditor(decorID)
    end
end

function Addon:ShowTextureEditor(decorID)
    if Addon.fTextureEditor == nil then
        Addon:RenderTextureEditor()
    end
    currentDecorID = decorID
    Addon.fTextureEditor:Show()

    local elemInfo
    if currentDecorID == "main" then
        elemInfo = IPMTTheme[IPMTOptions.theme].main
    else
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[currentDecorID]
    end

    local width = elemInfo.background.texSize.w
    local height = elemInfo.background.texSize.h
    if width == 0 and height == 0 then
        width  = elemInfo.size.w
        height = elemInfo.size.h
    end

    local left = width * elemInfo.background.coords[1]
    local right = width - width * elemInfo.background.coords[2]
    local top = height * elemInfo.background.coords[3]
    local bottom = height - height * elemInfo.background.coords[4]

    Addon.fTextureEditor.width:SetText(width)
    Addon.fTextureEditor.height:SetText(height)
    Addon.fTextureEditor.cropLeft:SetText(left)
    Addon.fTextureEditor.cropRight:SetText(right)
    Addon.fTextureEditor.cropTop:SetText(top)
    Addon.fTextureEditor.cropBottom:SetText(bottom)
end

function Addon:CloseTextureEditor()
    currentDecorID = nil
    if Addon.fTextureEditor ~= nil then
        Addon.fTextureEditor:Hide()
    end
end

function Addon:convertCoords(width, height, left, right, top, bottom)
    local result = {}

    if left == nil then
        left = 0
    end
    table.insert(result, left / width)

    if right == nil then
        right = 0
    end
    table.insert(result, (width - right) / width)

    if top == nil then
        top = 0
    end
    table.insert(result, top / height)

    if bottom == nil then
        bottom = 0
    end
    table.insert(result, (height - bottom) / height)

    return result
end

function Addon:SetTextureSettings()
    local width = tonumber(Addon.fTextureEditor.width:GetText())
    if width == nil then
        width = 0
    end
    local height = tonumber(Addon.fTextureEditor.height:GetText())
    if height == nil then
        height = 0
    end

    Addon:ChangeDecor(currentDecorID, {
        background = {
            texSize = {
                w = width,
                h = height,
            },
            coords = Addon:convertCoords(width, height,
                tonumber(Addon.fTextureEditor.cropLeft:GetText()),
                tonumber(Addon.fTextureEditor.cropRight:GetText()),
                tonumber(Addon.fTextureEditor.cropTop:GetText()),
                tonumber(Addon.fTextureEditor.cropBottom:GetText())
            ),
        },
    })
end
