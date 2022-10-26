local AddonName, Addon = ...

IPFieldSetMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = nil,
    tile     = false,
    tileSize = 8,
}

local bgColor = .072
local captionColor = .035
local deltaColor = .028

function IPFieldSetMixin:OnLoad()
    backdrop.edgeFile = nil
    backdrop.edgeSize = 0
    self:SetBackdrop(backdrop)
    self:SetBackdropColor(bgColor,bgColor,bgColor, 1)

    backdrop.edgeFile = "Interface\\Buttons\\WHITE8X8"
    backdrop.edgeSize = 2
    self.fTextBG = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    self.fTextBG:SetSize(250, 22)
    self.fTextBG:SetPoint("CENTER", self, "TOP", 0, 0)
    self.fTextBG:SetBackdrop(backdrop)
    self.fTextBG:SetBackdropColor(captionColor,captionColor,captionColor, 1)
    self.fTextBG:SetBackdropBorderColor(bgColor,bgColor,bgColor, 1)
    self.fTextBG:SetFrameStrata("MEDIUM")

    self.fTextBG.fText = self.fTextBG:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    self.fTextBG.fText:SetSize(280, 22)
    self.fTextBG.fText:ClearAllPoints()
    self.fTextBG.fText:SetPoint("CENTER", self.fTextBG, "CENTER", 0, 0)
    self.fTextBG.fText:SetJustifyH("CENTER")
    self.fTextBG.fText:SetJustifyV("MIDDLE")
    self.fTextBG.fText:SetTextColor(1, 1, 1)
    self.fTextBG.fText:SetText('')
end

function IPFieldSetMixin:OnEnter()
    self:SetBackdropColor(bgColor + deltaColor, bgColor + deltaColor, bgColor + deltaColor,  1)
    self.fTextBG:SetBackdropColor(captionColor + deltaColor,captionColor + deltaColor,captionColor + deltaColor, 1)
    self.fTextBG:SetBackdropBorderColor(bgColor + deltaColor, bgColor + deltaColor, bgColor + deltaColor,  1)
end

function IPFieldSetMixin:OnLeave()
    self:SetBackdropColor(bgColor,bgColor,bgColor, 1)
    self.fTextBG:SetBackdropColor(captionColor,captionColor,captionColor, 1)
    self.fTextBG:SetBackdropBorderColor(bgColor,bgColor,bgColor, 1)
end

function IPFieldSetMixin:RecalcTextBG()
    local width, height = self.fTextBG.fText:GetStringWidth(), self.fTextBG.fText:GetStringHeight()
    self.fTextBG:SetSize(width + 30, height + 8)
end

function IPFieldSetMixin:SetText(text)
    self.fTextBG.fText:SetText(text)
    self:RecalcTextBG()
end

function IPFieldSetMixin:SetFont(font, fontSize)
    self.fTextBG.fText:SetFont(font, fontSize)
    self:RecalcTextBG()
end
