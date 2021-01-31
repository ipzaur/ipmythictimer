local AddonName, Addon = ...

IPColorButtonMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    tileSize = 8,
    edgeSize = 1,
}

local currentButton = nil
local function ColorChange(restore)
    if currentButton == nil then
        return
    end
    local r, g, b, a
    if restore then
        r, g, b, a = unpack(restore)
    else
        r, g, b = ColorPickerFrame:GetColorRGB()
        a = 1 - OpacitySliderFrame:GetValue()
    end
    currentButton:ColorChange(r, g, b, a)
end
local function ShowColorPicker(button)
    ColorPickerFrame.hasOpacity = true
    ColorPickerFrame.opacity = 1 - currentButton.a
    ColorPickerFrame.previousValues = {currentButton.r, currentButton.g, currentButton.b, currentButton.a}
    ColorPickerFrame.func        = ColorChange
    ColorPickerFrame.opacityFunc = ColorChange
    ColorPickerFrame.cancelFunc  = ColorChange
    ColorPickerFrame:SetColorRGB(currentButton.r, currentButton.g, currentButton.b)
    OpacitySliderFrame:SetValue(1 - currentButton.a)

    ColorPickerFrame:Show()
end
ColorPickerCancelButton:HookScript("OnHide", function()
    if currentButton ~= nil then
        currentButton = nil
    end
end)
ColorPickerOkayButton:HookScript("OnHide", function()
    if currentButton ~= nil then
        currentButton = nil
    end
end)

function IPColorButtonMixin:OnClick()
    if currentButton ~= nil then
        ColorPickerFrame.cancelFunc(ColorPickerFrame.previousValues)
    end
    ColorPickerFrame:Hide()
    currentButton = self
    ShowColorPicker(self)
end

function IPColorButtonMixin:OnEnter()
    self:SetBackdropBorderColor(1,1,1)
end

function IPColorButtonMixin:OnLeave()
    self:SetBackdropBorderColor(.5,.5,.5)
end

function IPColorButtonMixin:ColorChange(r, g, b, a, woCallback)
    self.r, self.g, self.b, self.a = r, g, b, a
    self:SetBackdropColor(self.r, self.g, self.b, self.a)
    if woCallback ~= true and self.Callback ~= nil then
        self:Callback(self.r, self.g, self.b, self.a)
    end
end

function IPColorButtonMixin:OnLoad()
    self.r = 1
    self.g = 1
    self.b = 1
    self.a = 1
    self.Callback = nil

    self:SetBackdrop(backdrop)
    self:SetBackdropBorderColor(.5,.5,.5)
end

function IPColorButtonMixin:SetCallback(Callback)
    self.Callback = Callback
end
