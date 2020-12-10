local AddonName, Addon = ...

IPEditBoxMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    tileSize = 8,
    edgeSize = 1,
}

function IPEditBoxMixin:OnEnter()
    self:SetBackdropBorderColor(1,1,1, 1)
end

function IPEditBoxMixin:OnLeave()
    self:SetBackdropBorderColor(1,1,1, .5)
end

function IPEditBoxMixin:OnLoad()
    self:SetBackdrop(backdrop)
    self:SetBackdropColor(.03,.03,.03, 1)
    self:SetBackdropBorderColor(1,1,1, .5)
    self:SetTextColor(1, 1, 1)
    self:SetFontObject("GameFontNormal")
    self:SetTextInsets(10, 10, 0, 0)
end
