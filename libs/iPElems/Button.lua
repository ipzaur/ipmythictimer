local AddonName, Addon = ...

IPButtonMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    edgeSize = 1,
}

local bgColor = .15
local hoverBgColor = .175
local disableBgColor = .175

function IPButtonMixin:OnEnter()
    if not self.disabled then
        self:SetBackdropBorderColor(1,1,1, 1)
        self:SetBackdropColor(hoverBgColor,hoverBgColor,hoverBgColor, 1)
    end
end

function IPButtonMixin:OnLeave()
    if not self.disabled then
        self:SetBackdropBorderColor(1,1,1, .5)
        self:SetBackdropColor(bgColor,bgColor,bgColor, 1)
    end
end

function IPButtonMixin:OnLoad()
    self.disabled = false

    self:SetBackdrop(backdrop)
    self:SetBackdropColor(bgColor,bgColor,bgColor, 1)
    self:SetBackdropBorderColor(1,1,1, .5)

    self.fText = self:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    self.fText:SetSize(190, 20)
    self.fText:ClearAllPoints()
    self.fText:SetPoint("CENTER", self, "CENTER", 0, 0)
    self.fText:SetJustifyH("CENTER")
    self.fText:SetJustifyV("MIDDLE")
    self.fText:SetTextColor(1, 1, 1)
    self.fText:SetText('')
end

function IPButtonMixin:SetText(text)
    self.fText:SetText(text)
end

function IPButtonMixin:SetTexture(texture)
    if self.fTexture == nil then
        self.fTexture = self:CreateTexture()
        self.fTexture:SetPoint("CENTER", self, "CENTER", 0, 0)
    end
    self.fTexture:SetTexture(texture)
end

function IPButtonMixin:ToggleDisabled(disable)
    if disable == nil then
        disable = not self.disabled
    end
    self.disabled = disable
    if self.disabled == true then
        self:SetBackdropColor(bgColor - .025, bgColor - .025, bgColor - .025, 1)
        self:SetBackdropBorderColor(1,1,1, .25)
    else
        self:SetBackdropColor(bgColor, bgColor, bgColor, 1)
        self:SetBackdropBorderColor(1,1,1, .5)
    end
    if self.OnDisabled ~= nil then
        self:OnDisabled(self.disabled)
    end
end