local AddonName, Addon = ...

Addon.FONT_ROBOTO_LIGHT = "Interface\\AddOns\\" .. AddonName .. "\\RobotoCondensed-Light.ttf"
Addon.FONT_ROBOTO = "Interface\\AddOns\\" .. AddonName .. "\\RobotoCondensed-Regular.ttf"

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register('font', 'Roboto Light', Addon.FONT_ROBOTO_LIGHT, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register('font', 'Roboto', Addon.FONT_ROBOTO, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
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
