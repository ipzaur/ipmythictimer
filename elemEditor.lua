local AddonName, Addon = ...

local frameName = nil

function Addon:ToggleElemEditor(frame)
    local show = false
    if frameName ~= frame then
        show = true
    end
    Addon:CloseElemEditor()
    if show then
        Addon:ShowElemEditor(frame)
    end
end

function Addon:ShowElemEditor(frame)
    if Addon.fElemEditor == nil then
        Addon:RenderElemEditor()
    end
    frameName = frame
    Addon.fElemEditor:Show()
    local elemInfo
    if type(frame) == "number" then
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[frameName]
    else
        elemInfo = IPMTTheme[IPMTOptions.theme].elements[frameName]
    end
    local point = elemInfo.position.point
    if point == nil then
        point = 'LEFT'
    end
    Addon.fElemEditor.point:SelectItem(point, true)
    local rPoint = elemInfo.position.rPoint
    if rPoint == nil then
        rPoint = 'TOPLEFT'
    end
    Addon.fElemEditor.rPoint:SelectItem(rPoint, true)
    Addon.fElemEditor.posX:SetText(elemInfo.position.x)
    Addon.fElemEditor.posY:SetText(elemInfo.position.y)
end

function Addon:CloseElemEditor()
    frameName = nil
    if Addon.fElemEditor ~= nil then
        Addon.fElemEditor:Hide()
    end
end

function Addon:SetElemPosition(param, value)
    Addon:MoveElement(frameName, {[param] = value})
end