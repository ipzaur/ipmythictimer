local AddonName, Addon = ...

IPScrollBoxMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    tileSize = 8,
    edgeSize = 1,
}

local buttons = {
    pos = {
        Up = {
            x = 5,
            y = -3,
            tex = {
                y1 = 1,
                y2 = 0,
            },
        },
        Down = {
            x = 5,
            y = -4,
            tex = {
                y1 = 0,
                y2 = 1,
            },
        },
    },
    colors = {
        Normal = 1,
        Disabled = .5,
        Pushed = .75,
    },
}

function IPScrollBoxMixin:OnLoad()
    self:SetBackdrop(backdrop)
    self:SetBackdropColor(.03,.03,.03, 1)
    self:SetBackdropBorderColor(1,1,1, 1)

    self.ScrollBar:SetWidth(18)
    self.ScrollBar:SetPoint("TOPLEFT", self, "TOPRIGHT", -18, -18)
    self.ScrollBar:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", -18, 18)

    self.ScrollBar.ThumbTexture:SetSize(18, 18)
    self.ScrollBar.ThumbTexture:SetTexCoord(0, 1, 0, 1)
    self.ScrollBar.ThumbTexture:SetVertexColor(.5,.5,.5, 1)
    self.ScrollBar.ThumbTexture:SetTexture("Interface\\Buttons\\WHITE8X8")
    self.ScrollBar:SetScript("OnEnter", function(self)
        self.ThumbTexture:SetVertexColor(1,1,1, 1)
    end)
    self.ScrollBar:SetScript("OnLeave", function(self)
        self.ThumbTexture:SetVertexColor(.5,.5,.5, 1)
    end)

    for buttonName, pos in pairs(buttons.pos) do
        local buttonLabel = 'Scroll' .. buttonName .. 'Button'
        for status, color in pairs(buttons.colors) do
            self.ScrollBar[buttonLabel][status]:ClearAllPoints()
            self.ScrollBar[buttonLabel][status]:SetPoint("TOPLEFT", self.ScrollBar[buttonLabel], "TOPLEFT", 5, -3)
            self.ScrollBar[buttonLabel][status]:SetTexCoord(0, 1, pos.tex.y1, pos.tex.y2)
            self.ScrollBar[buttonLabel][status]:SetSize(8, 8)
            self.ScrollBar[buttonLabel][status]:SetVertexColor(color, color, color, 1)
            self.ScrollBar[buttonLabel][status]:SetTexture("Interface\\AddOns\\" .. AddonName .. "\\Libs\\iPElems\\triangle")
        end
        self.ScrollBar[buttonLabel].Highlight:SetTexCoord(0, 1, 0, 1)
        self.ScrollBar[buttonLabel].Highlight:SetVertexColor(1, 1, 1, .1)
        self.ScrollBar[buttonLabel].Highlight:SetTexture("Interface\\Buttons\\WHITE8X8")
    end
end

function IPScrollBoxMixin:OnMouseWheel(delta)
    local scrollY = self:GetVerticalScroll() - 36 * delta
    if scrollY < 0 then
        scrollY = 0
    else
        local maxScroll = self:GetVerticalScrollRange()
        if scrollY > maxScroll then
            scrollY = maxScroll
        end
    end
    self:SetVerticalScroll(scrollY)
end
