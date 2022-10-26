local AddonName, Addon = ...

IPCheckButtonMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    edgeSize = 1,
    insets = {
        top    = 3,
        left   = 3,
        right  = 3,
        bottom = 3,
    },
}

local bgColor = .15
local hoverBgColor = .175
local disableBgColor = .175

function IPCheckButtonMixin:OnEnter()
    if not self.disabled then
        self.fChecker:SetBackdropBorderColor(1,1,1, 1)
    end
end

function IPCheckButtonMixin:OnLeave()
    if not self.disabled then
        self.fChecker:SetBackdropBorderColor(1,1,1, .5)
    end
end

function IPCheckButtonMixin:OnLoad()
    self.disabled = false

    self.fChecker = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    self.fChecker:SetSize(16, 16)
    self.fChecker:SetPoint("LEFT", self, "LEFT", 0, 0)
    self.fChecker:SetBackdrop(backdrop)
    self.fChecker:SetBackdropColor(1,1,1, 0)
    self.fChecker:SetBackdropBorderColor(1,1,1, .5)

    self.fText = self:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    self.fText:SetPoint("TOPLEFT", self, "LEFT", 26, 20)
    self.fText:SetPoint("BOTTOMRIGHT", self, "RIGHT", 0, -20)
    self.fText:SetJustifyH("LEFT")
    self.fText:SetJustifyV("MIDDLE")
    self.fText:SetTextColor(1, 1, 1)
    self.fText:SetText('')

    local SetChecked = self.SetChecked
    self.SetChecked = function(self, checked)
        if checked then
            self.fChecker:SetBackdropColor(1,1,1, 1)
        else
            self.fChecker:SetBackdropColor(1,1,1, 0)
        end
        SetChecked(self, checked)
    end
end

function IPCheckButtonMixin:SetText(text)
    self.fText:SetText(text)
end

function IPCheckButtonMixin:OnClick()
    self:SetChecked(self:GetChecked())
end

function IPCheckButtonMixin:ToggleDisabled(disable)
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