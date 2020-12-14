local AddonName, Addon = ...

function Addon:Round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

function Addon:StartDragging(self, elem)
    self:StartMoving()
    self.isMoving = true
end

function Addon:StopDragging(self, elem)
    self:StopMovingOrSizing()
    self.isMoving = false
end

function Addon:PrintObject(data, prefix, toText)
    local text = ''
    if prefix == nil then
        prefix = ''
    end
    for key,value in pairs(data) do
        if value == nil then
            text = text .. prefix .. key .. " = nil\n"
        elseif type(value) == 'table' then
            text = text .. Addon:PrintObject(value, prefix .. key .. '.', toText) .. "\n"
        elseif type(value) == 'boolean' then
            if value then
                text = text .. prefix .. key .. " = true\n"
            else
                text = text .. prefix .. key .. " = false\n"
            end
        else
            text = text .. prefix .. key .. " = " .. value .. "\n"
        end
    end
    if toText then
        return text
    else
        print(text)
    end
end

function Addon:CopyObject(template, filled)
    if template == nil then
        return nil
    end
    local result = {}
    for key,value in pairs(template) do
        if type(value) == 'table' then
            if filled ~= nil and type(filled[key]) == 'table' then
                result[key] = Addon:CopyObject(value, filled[key])
            else
                result[key] = Addon:CopyObject(value)
            end
        else
            if filled and filled[key] ~= nil and type(filled[key]) ~= 'table' then
                result[key] = filled[key]
            else
                result[key] = value
            end
        end
    end
    return result
end