local AddonName, Addon = ...

Addon.FONT_ROBOTO = "Interface\\AddOns\\" .. AddonName .. "\\RobotoCondensed-Light.ttf"
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register('font', 'Roboto Light', Addon.FONT_ROBOTO, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western + LSM.LOCALE_BIT_koKR + LSM.LOCALE_BIT_zhCN + LSM.LOCALE_BIT_zhTW)
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