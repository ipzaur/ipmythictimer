local AddonName, Addon = ...

Addon.DECOR_FONT = Addon.FONT_ROBOTO
Addon.DECOR_FONTSIZE_DELTA = 0
if GetLocale() == "zhTW" then
    Addon.DECOR_FONT = "Arial"
    Addon.DECOR_FONTSIZE_DELTA = -2
end

function Addon:round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

Addon.backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = nil,
    tile     = true,
    tileSize = 32,
}

function Addon:StartDragging(self, button)
    self:StartMoving()
    self.isMoving = true
end

function Addon:StopDragging(self, button)
    self:StopMovingOrSizing()
    self.isMoving = false
end

local function PrintObject(data, prefix, toText)
    local text = ''
    if prefix == nil then
        prefix = ''
    end
    for key,value in pairs(data) do
        if value == nil then
            text = text .. prefix .. key .. " = nil\n"
        elseif type(value) == 'table' then
            text = text .. PrintObject(value, prefix .. key .. '.', toText) .. "\n"
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

function Addon:PrintDebug()
    local text = PrintObject(IPMTDungeon, 'dungeon.', true)
    text = text .. "\n\n" .. PrintObject(IPMTOptions, 'IPMTOptions.', true)
    text = text .. "\n\n FRAMES \n\n"
    for frame, info in pairs(Addon.frameInfo) do
        if info.text ~= nil then
            text = text .. frame .. ".text = '" .. Addon.fMain[frame].text:GetText() .. "'\n"
            local fontName, fontSize = Addon.fMain[frame].text:GetFont()
            text = text .. frame .. ".font = '" .. fontName .. "'\n"
            text = text .. frame .. ".size = " .. fontSize .. "\n"
        end
    end
    Addon.fDebug:Show()
    Addon.fDebug.textarea:SetText(text)
end