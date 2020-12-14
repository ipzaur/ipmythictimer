local AddonName, Addon = ...

IPListBoxMixin = {}

local backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile     = false,
    tileSize = 8,
    edgeSize = 1,
}
local itemHeight = 24
local maxHeight = 264

local openedListBox = nil
WorldFrame:HookScript("OnMouseDown", function(self, button)
    if button == 'LeftButton' and openedListBox ~= nil then
        openedListBox:ToggleList(false, true)
    end
end)


function IPListBoxMixin:OnClick()
    self:ToggleList(nil, true)
end

function IPListBoxMixin:OnEnter()
    self:SetBackdropBorderColor(1,1,1, 1)
    self:SetBackdropColor(.08,.08,.08, 1)
    self.fTriangle:SetVertexColor(1, 1, 1, 1)
end

function IPListBoxMixin:OnLeave()
    self:SetBackdropColor(.03,.03,.03, 1)
    if not self.opened then
        self:SetBackdropBorderColor(1,1,1, .5)
        self.fTriangle:SetVertexColor(1, 1, 1, .5)
    end
end

function IPListBoxMixin:OnLoad()
    self.opened = false
    self.selected = nil
    self.list = nil
    self.needScroll = false
    self.callback = nil
    self.noSort = false

    self:SetBackdrop(backdrop)
    self:SetBackdropColor(.03,.03,.03, 1)
    self:SetBackdropBorderColor(1,1,1, .5)

    self.fText = self:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    self.fText:SetSize(190, 20)
    self.fText:ClearAllPoints()
    self.fText:SetPoint("TOPLEFT", self, "LEFT", 10, 10)
    self.fText:SetPoint("TOPRIGHT", self, "RIGHT", -20, 10)
    self.fText:SetJustifyH("LEFT")
    self.fText:SetTextColor(1, 1, 1)
    self.fText:SetText('')

    self.fTriangle = self:CreateTexture()
    self.fTriangle:SetTexture("Interface\\AddOns\\" .. AddonName .. "\\Libs\\iPElems\\triangle")
    self.fTriangle:SetPoint("TOPRIGHT", self, "RIGHT", -6, 4)
    self.fTriangle:SetVertexColor(1, 1, 1, .5)
    self.fTriangle:SetSize(8, 8)

    self.fList = CreateFrame("ScrollFrame", nil, self, "IPScrollBox")
    self.fList:SetFrameStrata("HIGH")
    self.fList:SetSize(220, maxHeight)
    self.fList:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 1)
    self.fList.fContent:SetSize(200, 300)
    self.fList:Hide()
    self.fItem = {}
end

function IPListBoxMixin:SetList(list, current, noSort)
    self.list = list
    self.noSort = noSort
    if current then
        self:SelectItem(current, true)
    end
end

function IPListBoxMixin:SetCallback(callbacks)
    if callbacks.OnRenderItem then
        if self.callback == nil then
            self.callback = {}
        end
        self.callback.OnRenderItem = callbacks.OnRenderItem
    end
    if callbacks.OnHoverItem then
        if self.callback == nil then
            self.callback = {}
        end
        self.callback.OnHoverItem = callbacks.OnHoverItem
    end
    if callbacks.OnSelect then
        if self.callback == nil then
            self.callback = {}
        end
        self.callback.OnSelect = callbacks.OnSelect
    end
    if callbacks.OnCancel then
        if self.callback == nil then
            self.callback = {}
        end
        self.callback.OnCancel = callbacks.OnCancel
    end
end

function IPListBoxMixin:ToggleList(show, canCancel)
    if show == nil then
        show = not self.opened
    end
    if show == true then
        if openedListBox ~= nil then
            openedListBox:ToggleList(false)
        end
        local list
        if type(self.list) == 'function' then
            list = self:list()
            self:RenderList(list)
        elseif #self.fItem == 0 then
            list = self.list
            self:RenderList(list)
        end
        openedListBox = self
        self.fList:Show()
        self:SetBackdropBorderColor(1,1,1, 1)
        self.fTriangle:SetVertexColor(1, 1, 1, 1)
    else
        self.fList:Hide()
        self:SetBackdropBorderColor(1,1,1, 0.5)
        self.fTriangle:SetVertexColor(1, 1, 1, .5)
        if canCancel == true and self.callback and self.callback.OnCancel then
            self.callback:OnCancel()
        end
        openedListBox = nil
    end
    self.opened = show
end

function IPListBoxMixin:SelectItem(key, woCallback)
    local list
    if type(self.list) == 'function' then
        list = self:list()
    else
        list = self.list
    end
    self.selected = key
    self.fText:SetText(list[self.selected])
    if woCallback ~= true and self.callback and self.callback.OnSelect then
        self.callback:OnSelect(self.selected, list[self.selected])
    end
    self:ToggleList(false)
end

function IPListBoxMixin:RenderItem(num, key, text, selected)
    if self.fItem[num] then
        self.fItem[num]:Show()
    else
        self.fItem[num] = CreateFrame("Button", nil, self.fList.fContent, BackdropTemplateMixin and "BackdropTemplate")
        self.fItem[num]:SetSize(100, itemHeight)
        self.fItem[num]:ClearAllPoints()
        self.fItem[num]:SetPoint("TOPLEFT", self.fList.fContent, "TOPLEFT", 0, -1 * (num * itemHeight - itemHeight))
        self.fItem[num]:SetPoint("TOPRIGHT", self.fList.fContent, "TOPRIGHT", 0, -1 * (num * itemHeight - itemHeight))
        self.fItem[num]:SetBackdrop(backdrop)
        self.fItem[num]:SetBackdropColor(1,1,1, 0)
        self.fItem[num]:SetBackdropBorderColor(0,0,0, 0)
        self.fItem[num]:EnableMouse(true)
        self.fItem[num]:SetScript("OnEnter", function(item, event, ...)
            self.fItem[num]:SetBackdropColor(1,1,1, .1)
            if self.callback and self.callback.OnHoverItem then
                self.callback:OnHoverItem(self.fItem[num], self.fItem[num].key, self.fItem[num].text)
            end
        end)
        self.fItem[num]:SetScript("OnLeave", function(item, event, ...)
            self.fItem[num]:SetBackdropColor(1,1,1, 0)
        end)
        self.fItem[num]:SetScript("OnClick", function(item)
            self:SelectItem(self.fItem[num].key)
        end)
        self.fItem[num].fText = self.fItem[num]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        self.fItem[num].fText:SetPoint("TOPLEFT", self.fItem[num], "LEFT", 10, 9)
        self.fItem[num].fText:SetJustifyH("LEFT")
        self.fItem[num].fText:SetSize(400, 18)
        self.fItem[num].fText:SetTextColor(1, 1, 1)
    end
    if self.callback and self.callback.OnRenderItem then
        self.callback:OnRenderItem(self.fItem[num], key, text)
    end
    self.fItem[num].key = key
    self.fItem[num].text = text
    self.fItem[num].fText:SetText(text)
    local width = math.ceil(self.fItem[num].fText:GetStringWidth()) + 20
    self.fItem[num].fText:SetWidth(width)

    return width
end

function IPListBoxMixin:RenderList(list)
    local itemsWidth = 0
    local minWidth = self:GetWidth()
    local sorted = {}
    for key, text in pairs(list) do
        table.insert(sorted, {
            key  = key,
            text = text,
        })
    end
    if not self.noSort then
        table.sort(sorted, function(item1, item2)
            return item1.text < item2.text
        end)
    end
    for num, item in ipairs(sorted) do
        local selected = false
        if self.selected and self.selected == item.key then
            selected = true
        end
        local width = self:RenderItem(num, item.key, item.text, selected)
        itemsWidth = math.max(itemsWidth, width)
    end
    local itemsCount = #sorted
    local items = #self.fItem
    if itemsCount < items then
        for i = itemsCount+1,items do
            self.fItem[i]:Hide()
        end
    end
    local itemsHeight = itemHeight * itemsCount
    local width = math.max(minWidth, itemsWidth)
    local height = math.min(itemsHeight, maxHeight)
    self.fList:SetSize(width, height)
    self.fList.fContent:SetSize(width, itemsHeight)
    self.needScroll = itemsHeight > maxHeight
    if self.needScroll then
        self.fList.ScrollBar:Show()
        self.fList:SetWidth(width + 18)
    else
        self.fList.ScrollBar:Hide()
    end
end
