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
end