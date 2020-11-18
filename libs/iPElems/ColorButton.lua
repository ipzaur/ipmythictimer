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
local isClosing = false
local function ColorChange(restore)
    if currentButton == nil then
        return
    end
    local r, g, b, a
    if restore then
        r, g, b, a = unpack(restore)
    else
        r, g, b = ColorPickerFrame:GetColorRGB()
        a = OpacitySliderFrame:GetValue()
    end
    currentButton:ColorChange(r, g, b, a)

    if isClosing == true then
        currentButton = nil
        isClosing = false
    end
end
local function ShowColorPicker(button)
    currentButton = button
    ColorPickerFrame:SetColorRGB(currentButton.r, currentButton.g, currentButton.b)
    ColorPickerFrame.hasOpacity = true
    ColorPickerFrame.opacity = currentButton.a
    ColorPickerFrame.previousValues = {currentButton.r, currentButton.g, currentButton.b, currentButton.a}
    ColorPickerFrame.func        = ColorChange
    ColorPickerFrame.opacityFunc = ColorChange
    ColorPickerFrame.cancelFunc  = ColorChange
    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()

end
ColorPickerFrame:HookScript("OnHide", function()
    if currentButton ~= nil then
        isClosing = true
    end
end)

function IPColorButtonMixin:OnClick()
    ShowColorPicker(self)
end

function IPColorButtonMixin:OnEnter()
    self:SetBackdropBorderColor(1,1,1, 1)
end

function IPColorButtonMixin:OnLeave()
    self:SetBackdropBorderColor(1,1,1, .5)
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
    self:SetBackdropBorderColor(1,1,1, .5)
end

function IPColorButtonMixin:SetCallback(Callback)
    self.Callback = Callback
end
