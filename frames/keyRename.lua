local AddonName, Addon = ...

local KEY_HEIGHT = 70

local keyMapIds = {
    {
        caption = Addon.localization.CURSEASON,
        ids = {456,168,198,199,244,248,463,464}
    }, {
        caption = "Dragonflight",
        ids = {399,400,401,402,403,404,405,406,463,464},
    }, {
        caption = "Shadowlands",
        ids = {375,377,382,379,378,380,376,381,391,392},
    }, {
        caption = "Battle for Azeroth",
        ids = {244,245,246,247,249,248,250,251,252,353,369,370},
    }, {
        caption = "Legion",
        ids = {197,198,199,200,206,207,208,209,210,227,234,233},
    }, {
        caption = "Warlords of Draenor",
        ids = {165,166,168,169},
    }, {
        caption = "Mists of Pandaria",
        ids = {2},
    }, {
        caption = "Cataclysm",
        ids = {438,456},
    }
}

local expansions = {}
for i, group in ipairs(keyMapIds) do
    expansions[i] = group.caption
end

function Addon:RenderKeyRename()
    Addon.fKeyRename = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fKeyRename:ClearAllPoints()
    Addon.fKeyRename:SetSize(380, 600)
    Addon.fKeyRename:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Addon.fKeyRename:SetBackdrop(Addon.backdrop)
    Addon.fKeyRename:SetBackdropColor(0,0,0, .9)
    Addon.fKeyRename:EnableMouse(true)
    Addon.fKeyRename:SetMovable(true)
    Addon.fKeyRename:RegisterForDrag("LeftButton")
    Addon.fKeyRename:SetScript("OnDragStart", function(self, button)
        Addon:StartDragging(self, button)
    end)
    Addon.fKeyRename:SetScript("OnDragStop", function(self, button)
        Addon:StopDragging(self, button)
    end)

    Addon.fKeyRename.caption = Addon.fKeyRename:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    Addon.fKeyRename.caption:SetPoint("CENTER", Addon.fKeyRename, "TOP", 0, -20)
    Addon.fKeyRename.caption:SetJustifyH("CENTER")
    Addon.fKeyRename.caption:SetSize(350, 20)
    Addon.fKeyRename.caption:SetFont(Addon.DECOR_FONT, 20)
    Addon.fKeyRename.caption:SetTextColor(1, 1, 1)
    Addon.fKeyRename.caption:SetText(Addon.localization.KEYSNAME)

    -- Addon selector
    Addon.fKeyRename.expansion = CreateFrame("Button", nil, Addon.fKeyRename, "IPListBox")
    Addon.fKeyRename.expansion:SetHeight(30)
    Addon.fKeyRename.expansion:SetPoint("LEFT", Addon.fKeyRename, "TOPLEFT", 20, -66)
    Addon.fKeyRename.expansion:SetPoint("RIGHT", Addon.fKeyRename, "TOPRIGHT", -20, -66)
    Addon.fKeyRename.expansion:SetList(expansions, 1, true)
    Addon.fKeyRename.expansion:SetCallback({
        OnSelect = function(self, key, text)
            Addon:RenderExpansion(keyMapIds[key])
        end,
    })

    -- X-Close button
    Addon.fKeyRename.closeX = CreateFrame("Button", nil, Addon.fKeyRename, BackdropTemplateMixin and "BackdropTemplate")
    Addon.fKeyRename.closeX:SetPoint("TOP", Addon.fKeyRename, "TOPRIGHT", -20, -5)
    Addon.fKeyRename.closeX:SetSize(26, 26)
    Addon.fKeyRename.closeX:SetBackdrop(Addon.backdrop)
    Addon.fKeyRename.closeX:SetBackdropColor(0,0,0, 1)
    Addon.fKeyRename.closeX:SetScript("OnClick", function(self)
        Addon:CloseKeyRename()
    end)
    Addon.fKeyRename.closeX:SetScript("OnEnter", function(self, event, ...)
        Addon.fKeyRename.closeX:SetBackdropColor(.1,.1,.1, 1)
    end)
    Addon.fKeyRename.closeX:SetScript("OnLeave", function(self, event, ...)
        Addon.fKeyRename.closeX:SetBackdropColor(0,0,0, 1)
    end)
    Addon.fKeyRename.closeX.icon = Addon.fKeyRename.closeX:CreateTexture()
    Addon.fKeyRename.closeX.icon:SetSize(16, 16)
    Addon.fKeyRename.closeX.icon:ClearAllPoints()
    Addon.fKeyRename.closeX.icon:SetPoint("CENTER", Addon.fKeyRename.closeX, "CENTER", 0, 0)
    Addon.fKeyRename.closeX.icon:SetTexture("Interface\\AddOns\\IPMythicTimer\\media\\x-close")

    Addon.fKeyRename.key = {}

    Addon:RenderExpansion(keyMapIds[1])
end

function Addon:RenderKey(index, keyMapId)
    if Addon.fKeyRename.key[index] == nil then
        local top = KEY_HEIGHT*(1-index) - 100
        Addon.fKeyRename.key[index] = CreateFrame("Frame", nil, Addon.fKeyRename, BackdropTemplateMixin and "BackdropTemplate")
        Addon.fKeyRename.key[index]:SetHeight(KEY_HEIGHT)
        Addon.fKeyRename.key[index]:SetPoint("TOPLEFT", Addon.fKeyRename, "TOPLEFT", 10, top)
        Addon.fKeyRename.key[index]:SetPoint("TOPRIGHT", Addon.fKeyRename, "TOPRIGHT", -10, top)
        if (index % 2 ~= 0) then
            Addon.fKeyRename.key[index]:SetBackdrop(Addon.backdrop)
            Addon.fKeyRename.key[index]:SetBackdropColor(.075,.075,.075, 1)
        end

        Addon.fKeyRename.key[index].cover = Addon.fKeyRename.key[index]:CreateTexture()
        Addon.fKeyRename.key[index].cover:SetSize(70, 50)
        Addon.fKeyRename.key[index].cover:ClearAllPoints()
        Addon.fKeyRename.key[index].cover:SetPoint("LEFT", Addon.fKeyRename.key[index], "LEFT", 10, 0)

        -- Default key name
        Addon.fKeyRename.key[index].caption = Addon.fKeyRename.key[index]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Addon.fKeyRename.key[index].caption:SetPoint("TOPLEFT", Addon.fKeyRename.key[index], "TOPLEFT", 90, -10)
        Addon.fKeyRename.key[index].caption:SetPoint("TOPRIGHT", Addon.fKeyRename.key[index], "TOPRIGHT", -10, -10)
        Addon.fKeyRename.key[index].caption:SetJustifyH("LEFT")
        Addon.fKeyRename.key[index].caption:SetHeight(20)
        Addon.fKeyRename.key[index].caption:SetTextColor(1, 1, 1)

        -- key name input
        Addon.fKeyRename.key[index].name = CreateFrame("EditBox", nil, Addon.fKeyRename.key[index], "IPEditBox")
        Addon.fKeyRename.key[index].name:SetAutoFocus(false)
        Addon.fKeyRename.key[index].name:SetPoint("BOTTOMLEFT", Addon.fKeyRename.key[index], "BOTTOMLEFT", 90, 10)
        Addon.fKeyRename.key[index].name:SetPoint("BOTTOMRIGHT", Addon.fKeyRename.key[index], "BOTTOMRIGHT", -10, 10)
        Addon.fKeyRename.key[index].name:SetHeight(30)
        Addon.fKeyRename.key[index].name:SetScript('OnTextChanged', function(self)
            local name = self:GetText()
            Addon:RenameKey(Addon.fKeyRename.key[index].keyMapId, name)
        end)

    elseif not Addon.fKeyRename.key[index]:IsShown() then
        Addon.fKeyRename.key[index]:Show()
    end
    local defaultName, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(keyMapId)
    Addon.fKeyRename.key[index].keyMapId = keyMapId
    Addon.fKeyRename.key[index].cover:SetTexture(texture)
    Addon.fKeyRename.key[index].caption:SetText(defaultName)
    local customName = ""
    if IPMTOptions.keysName ~= nil and IPMTOptions.keysName[keyMapId] ~= nil then
        customName = IPMTOptions.keysName[keyMapId]
    end
    Addon.fKeyRename.key[index].name:SetText(customName)
end

function Addon:RenderExpansion(expansion)
    for k, keyMapId in ipairs(expansion.ids) do
        Addon:RenderKey(k, keyMapId)
    end
    for i = #expansion.ids+1, #Addon.fKeyRename.key do
        if Addon.fKeyRename.key[i] ~= nil then
            Addon.fKeyRename.key[i]:Hide()
        end
    end
    Addon.fKeyRename:SetHeight(110 + KEY_HEIGHT * #expansion.ids)
end
