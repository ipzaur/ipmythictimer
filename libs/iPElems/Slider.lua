local AddonName, Addon = ...

IPSliderMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    tileSize = 8,
    edgeSize = 1,
}

function IPSliderMixin:OnEnter()
    self:SetBackdropBorderColor(1,1,1, 1)
    self.Thumb:SetVertexColor(1,1,1, 1)
end

function IPSliderMixin:OnLeave()
    self:SetBackdropBorderColor(1,1,1, .5)
    self.Thumb:SetVertexColor(.5,.5,.5, 1)
end

function IPSliderMixin:OnLoad()
    self:SetBackdrop(backdrop)
    self:SetBackdropColor(.03,.03,.03, 1)
    self:SetBackdropBorderColor(1,1,1, .5)

    self.Thumb:SetTexCoord(0, 1, 0, 1)
    self.Thumb:SetVertexColor(.5,.5,.5, 1)
end

IPOptionsSliderMixin = CreateFromMixins(IPSliderMixin)

function IPOptionsSliderMixin:OnLoad()
    IPSliderMixin.OnLoad(self)

    self.Low:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
    self.Low:SetJustifyH("LEFT")
    self.High:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -2)
    self.High:SetJustifyH("RIGHT")

    self.Text:SetPoint("BOTTOM", self, "TOP", 0, 2)
end