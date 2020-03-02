local AddonName, Addon = ...

local openedListBox = nil
WorldFrame:HookScript("OnMouseDown", function(self, button)
    if button == 'LeftButton' and openedListBox ~= nil then
        openedListBox:ToggleList(false)
    end
end)

local function StartDragging(self, button)
    self:StartMoving()
    self.isMoving = true
end

local function StopDragging(self, button)
    self:StopMovingOrSizing()
    self.isMoving = false
end

function iPElemsCreateListBox(name, parent, list, callback)
    local itemHeight = 24
    local maxHeight = 264
    local backdrop = {
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\AddOns\\" .. AddonName .. "\\Libs\\iPElems\\listbox",
        tile     = true,
        tileSize = 8,
        edgeSize = 8,
    }
    local element = CreateFrame("Button", name, parent)
    element.opened = false
    element.selected = nil
    element.list = nil
    element.needScroll = false

    element:SetBackdrop(backdrop)
    element:SetBackdropColor(.03,.03,.03, 1)
    element:SetBackdropBorderColor(1,1,1, .5)
    element:EnableMouse(true)
    element:SetScript("OnClick", function(self)
        element:ToggleList()
    end)
    element:SetScript("OnEnter", function(self, event, ...)
        element:SetBackdropBorderColor(1,1,1, 1)
        element:SetBackdropColor(.08,.08,.08, 1)
        element.fTriangle:SetVertexColor(1, 1, 1, 1)
    end)
    element:SetScript("OnLeave", function(self, event, ...)
        element:SetBackdropColor(.03,.03,.03, 1)
        if not element.opened then
            element:SetBackdropBorderColor(1,1,1, .5)
            element.fTriangle:SetVertexColor(1, 1, 1, .5)
        end
    end)

    element.fText = element:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    element.fText:SetSize(190, 20)
    element.fText:ClearAllPoints()
    element.fText:SetPoint("TOPLEFT", element, "LEFT", 10, 10)
    element.fText:SetPoint("TOPRIGHT", element, "RIGHT", -20, 10)
    element.fText:SetJustifyH("LEFT")
    element.fText:SetTextColor(1, 1, 1)
    element.fText:SetText('')

    element.fTriangle = element:CreateTexture()
    element.fTriangle:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")
    element.fTriangle:SetPoint("TOPRIGHT", element, "RIGHT", -6, 4)
    element.fTriangle:SetVertexColor(1, 1, 1, .5)
    element.fTriangle:SetSize(8, 8)

    element.fList = CreateFrame("ScrollFrame", nil, element, "UIPanelScrollFrameTemplate")
    element.fList:SetBackdrop(backdrop)
    element.fList:SetBackdropColor(.03,.03,.03, 1)
    element.fList:SetBackdropBorderColor(1,1,1, 1)
    element.fList:SetSize(220, maxHeight)
    element.fList:SetPoint("TOPLEFT", element, "BOTTOMLEFT", 0, 1)
    element.fList:EnableMouseWheel(true)
    element.fList:SetScript("OnMouseWheel", function(self, delta)
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
    end)
    element.fList.ScrollBar:ClearAllPoints()
    element.fList.ScrollBar:SetPoint("TOPLEFT", element.fList, "TOPRIGHT", -12, -18)
    element.fList.ScrollBar:SetPoint("BOTTOMRIGHT", element.fList, "BOTTOMRIGHT", -7, 18)
-- Up Button
    element.fList.ScrollBar.ScrollUpButton.Normal:ClearAllPoints()
    element.fList.ScrollBar.ScrollUpButton.Normal:SetPoint("TOPLEFT", element.fList.ScrollBar.ScrollUpButton, "TOPLEFT", 5, -3)
    element.fList.ScrollBar.ScrollUpButton.Normal:SetTexCoord(0, 1, 1, 0);
    element.fList.ScrollBar.ScrollUpButton.Normal:SetSize(8, 8);
    element.fList.ScrollBar.ScrollUpButton.Normal:SetVertexColor(1, 1, 1, 1)
    element.fList.ScrollBar.ScrollUpButton.Normal:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")

    element.fList.ScrollBar.ScrollUpButton.Disabled:ClearAllPoints()
    element.fList.ScrollBar.ScrollUpButton.Disabled:SetPoint("TOPLEFT", element.fList.ScrollBar.ScrollUpButton, "TOPLEFT", 5, -3)
    element.fList.ScrollBar.ScrollUpButton.Disabled:SetTexCoord(0, 1, 1, 0);
    element.fList.ScrollBar.ScrollUpButton.Disabled:SetSize(8, 8);
    element.fList.ScrollBar.ScrollUpButton.Disabled:SetVertexColor(.5, .5, .5, 1)
    element.fList.ScrollBar.ScrollUpButton.Disabled:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")

    element.fList.ScrollBar.ScrollUpButton.Pushed:ClearAllPoints()
    element.fList.ScrollBar.ScrollUpButton.Pushed:SetPoint("TOPLEFT", element.fList.ScrollBar.ScrollUpButton, "TOPLEFT", 5, -3)
    element.fList.ScrollBar.ScrollUpButton.Pushed:SetTexCoord(0, 1, 1, 0);
    element.fList.ScrollBar.ScrollUpButton.Pushed:SetSize(8, 8);
    element.fList.ScrollBar.ScrollUpButton.Pushed:SetVertexColor(.75, .75, .75, 1)
    element.fList.ScrollBar.ScrollUpButton.Pushed:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")

    element.fList.ScrollBar.ScrollUpButton.Highlight:SetTexCoord(0, 1, 0, 1);
    element.fList.ScrollBar.ScrollUpButton.Highlight:SetVertexColor(1, 1, 1, .1)
    element.fList.ScrollBar.ScrollUpButton.Highlight:SetTexture("Interface\\Buttons\\WHITE8X8")
-- Down Button
    element.fList.ScrollBar.ScrollDownButton.Normal:ClearAllPoints()
    element.fList.ScrollBar.ScrollDownButton.Normal:SetPoint("TOPLEFT", element.fList.ScrollBar.ScrollDownButton, "TOPLEFT", 5, -4)
    element.fList.ScrollBar.ScrollDownButton.Normal:SetTexCoord(0, 1, 0, 1);
    element.fList.ScrollBar.ScrollDownButton.Normal:SetSize(8, 8);
    element.fList.ScrollBar.ScrollDownButton.Normal:SetVertexColor(1, 1, 1, 1)
    element.fList.ScrollBar.ScrollDownButton.Normal:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")

    element.fList.ScrollBar.ScrollDownButton.Disabled:ClearAllPoints()
    element.fList.ScrollBar.ScrollDownButton.Disabled:SetPoint("TOPLEFT", element.fList.ScrollBar.ScrollDownButton, "TOPLEFT", 5, -4)
    element.fList.ScrollBar.ScrollDownButton.Disabled:SetTexCoord(0, 1, 0, 1);
    element.fList.ScrollBar.ScrollDownButton.Disabled:SetSize(8, 8);
    element.fList.ScrollBar.ScrollDownButton.Disabled:SetVertexColor(.5, .5, .5, 1)
    element.fList.ScrollBar.ScrollDownButton.Disabled:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")

    element.fList.ScrollBar.ScrollDownButton.Pushed:ClearAllPoints()
    element.fList.ScrollBar.ScrollDownButton.Pushed:SetPoint("TOPLEFT", element.fList.ScrollBar.ScrollDownButton, "TOPLEFT", 5, -4)
    element.fList.ScrollBar.ScrollDownButton.Pushed:SetTexCoord(0, 1, 0, 1);
    element.fList.ScrollBar.ScrollDownButton.Pushed:SetSize(8, 8);
    element.fList.ScrollBar.ScrollDownButton.Pushed:SetVertexColor(.75, .75, .75, 1)
    element.fList.ScrollBar.ScrollDownButton.Pushed:SetTexture("Interface\\AddOns\\IPMythicTimer\\Libs\\iPElems\\triangle")

    element.fList.ScrollBar.ScrollDownButton.Highlight:SetTexCoord(0, 1, 0, 1);
    element.fList.ScrollBar.ScrollDownButton.Highlight:SetVertexColor(1, 1, 1, .1)
    element.fList.ScrollBar.ScrollDownButton.Highlight:SetTexture("Interface\\Buttons\\WHITE8X8")

-- Knob
    element.fList.ScrollBar.ThumbTexture:SetTexCoord(0, 1, 0, 1);
    element.fList.ScrollBar.ThumbTexture:SetVertexColor(.5, .5, .5, 1)
    element.fList.ScrollBar.ThumbTexture:SetTexture("Interface\\Buttons\\WHITE8X8")


    element.fItems = CreateFrame("Frame", nil, element.fList)
    element.fItems:SetSize(200, 300)
    element.fList:SetScrollChild(element.fItems)
    element.fItem = {}
    element.fList:Hide()

    function element:ToggleList(show)
        if show == nil then
            show = not element.opened
        end
        if show == true then
            if openedListBox ~= nil then
                openedListBox:ToggleList(false)
            end
            if type(list) == 'function' then
                element.list = list()
                element:RenderList(element.list)
            else
                if element.list == nil then
                    element.list = list
                end
                if #element.fItem == 0 then
                    element:RenderList(element.list)
                end
            end
            openedListBox = element
            element.fList:Show()
            element:SetBackdropBorderColor(1,1,1, 1)
            element.fTriangle:SetVertexColor(1, 1, 1, 1)
        else
            element.fList:Hide()
            element:SetBackdropBorderColor(1,1,1, 0.5)
            element.fTriangle:SetVertexColor(1, 1, 1, .5)
            openedListBox = nil
        end
        element.opened = show
    end

    function element:SelectItem(key)
        if element.list == nil then
            if type(list) == 'function' then
                element.list = list()
            else
                element.list = list
            end
        end
        element.selected = key
        element.fText:SetText(element.list[element.selected])
        element:ToggleList(false)
        if callback and callback.onSelect then
            callback.onSelect(element.selected, element.list[element.selected])
        end
    end

    function element:RenderItem(num, key, text, selected)
        if element.fItem[num] then
            element.fItem[num]:Show()
        else
            element.fItem[num] = CreateFrame("Button", nil, element.fItems)
            element.fItem[num]:SetSize(100, itemHeight)
            element.fItem[num]:ClearAllPoints()
            element.fItem[num]:SetPoint("TOPLEFT", element.fItems, "TOPLEFT", 0, -1 * (num * itemHeight - itemHeight))
            element.fItem[num]:SetPoint("TOPRIGHT", element.fItems, "TOPRIGHT", 0, -1 * (num * itemHeight - itemHeight))
            element.fItem[num]:SetBackdrop(backdrop)
            element.fItem[num]:SetBackdropColor(1,1,1, 0)
            element.fItem[num]:SetBackdropBorderColor(0,0,0, 0)
            element.fItem[num]:EnableMouse(true)
            element.fItem[num]:SetScript("OnEnter", function(self, event, ...)
                element.fItem[num]:SetBackdropColor(1,1,1, .1)
            end)
            element.fItem[num]:SetScript("OnLeave", function(self, event, ...)
                element.fItem[num]:SetBackdropColor(1,1,1, 0)
            end)
            element.fItem[num]:SetScript("OnClick", function(self)
                element:SelectItem(key)
            end)
            element.fItem[num].fText = element.fItem[num]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            element.fItem[num].fText:SetPoint("TOPLEFT", element.fItem[num], "LEFT", 10, 9)
            element.fItem[num].fText:SetJustifyH("LEFT")
            element.fItem[num].fText:SetSize(400, 18)
            element.fItem[num].fText:SetTextColor(1, 1, 1)
        end
        if callback and callback.onRenderItem then
            callback.onRenderItem(element.fItem[num], key, text)
        end
        element.fItem[num].fText:SetText(text)
        local width = math.ceil(element.fItem[num].fText:GetStringWidth()) + 20
        element.fItem[num].fText:SetWidth(width)

        return width
    end

    function element:RenderList(list)
        local itemsWidth = 0
        local minWidth = element:GetWidth()
        local sorted = {}
        for key, text in pairs(list) do table.insert(sorted, {key=key, text=text}) end
        table.sort(sorted, function(item1, item2)
            return item1.text < item2.text
        end)
        for num, item in ipairs(sorted) do
            local selected = false
            if element.selected and element.selected == item.key then
                selected = true
            end
            local width = element:RenderItem(num, item.key, item.text, selected)
            itemsWidth = math.max(itemsWidth, width)
        end
        local itemsCount = #sorted
        local items = #element.fItem
        if itemsCount < items then
            for i = itemsCount+1,items do
                element.fItem[i]:Hide()
            end
        end
        local itemsHeight = itemHeight * itemsCount
        local width = math.max(minWidth, itemsWidth)
        local height = math.min(itemsHeight, maxHeight)
        element.fList:SetSize(width, height)
        element.fItems:SetSize(width, itemsHeight)
        element.needScroll = itemsHeight > maxHeight
        if element.needScroll then
            element.fList.ScrollBar:Show()
            element.fList:SetWidth(width + 18)
        else
            element.fList.ScrollBar:Hide()
        end
    end

    return element
end