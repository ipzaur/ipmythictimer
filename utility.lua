local AddonName, Addon = ...

Addon.FONT_ROBOTO = "Interface\\AddOns\\" .. AddonName .. "\\RobotoCondensed-Light.ttf"
Addon.backdrop = {
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
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

    local point, relativeTo, relativePoint, x, y = self:GetPoint()
    if (self:GetName() == "IPMTMain") then
        IPMTOptions.position.main = {
            point = point,
            x     = x,
            y     = y,
        }
    elseif (self:GetName() == "IPMTSettings") then
        IPMTOptions.position.options = {
            point = point,
            x     = x,
            y     = y,
        }
    end
end