local AddonName, Addon = ...

Addon.deaths = {}

function Addon.deaths:Toggle(show)
    if (show == nil) then
        show = not Addon.fDeaths:IsShown()
    end
    if show then
        if not Addon.fOptions:IsShown() then
            Addon.deaths:Show()
        end
    else
        Addon.fDeaths:Hide()
    end
end

function Addon.deaths:Show()
    local counts = {}
    for i, death in ipairs(Addon.DB.global.dungeon.deathes.list) do
        if counts[death.playerName] then
            counts[death.playerName] = counts[death.playerName] + 1
        else
            counts[death.playerName] = 1
        end
        Addon:FillDeathRow(i, death, counts[death.playerName])
    end
    local deaths = #Addon.DB.global.dungeon.deathes.list
    local rows = #Addon.fDeaths.line
    if deaths < rows then
        for i = deaths+1,rows do
            Addon.fDeaths.line[i]:Hide()
        end
    end
    Addon.fDeaths:Show()
    Addon.fDeaths.lines:SetHeight(Addon.deathRowHeight * deaths)
end

function Addon.deaths:Record(playerName)
    local spellId, spellIcon, enemy, damage
    if IPMTDungeon.players[playerName] == nil then
        spellId = nil
        spellIcon = nil
        enemy = Addon.localization.UNKNOWN
        damage = ''
    else
        spellId = IPMTDungeon.players[playerName].spellId
        enemy   = IPMTDungeon.players[playerName].enemy
        damage  = IPMTDungeon.players[playerName].damage
        if spellId > 1 then
            spellIcon = select(3, GetSpellInfo(spellId))
        else
            spellIcon = 130730 -- Melee Attack Icon
        end
    end
    table.insert(IPMTDungeon.deathes.list, {
        playerName = playerName,
        time       = IPMTDungeon.time,
        enemy      = enemy,
        damage     = damage,
        spell      = {
            id   = spellId,
            icon = spellIcon,
        },
    })
    IPMTDungeon.players[playerName] = nil
end

function Addon.deaths:ShowTooltip(self)
    if not Addon.fOptions:IsShown() then
        local deathes, timeLost = C_ChallengeMode.GetDeathCount()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.DEATHCOUNT .. " : " .. deathes, 1, 1, 1)
        GameTooltip:AddLine(Addon.localization.DEATHTIME .. " : " .. SecondsToClock(timeLost), .8, 0, 0)
        GameTooltip:AddLine(" ")

        local counts = {}
        for i, death in ipairs(IPMTDungeon.deathes.list) do
            if counts[death.playerName] then
                counts[death.playerName] = counts[death.playerName] + 1
            else
                counts[death.playerName] = 1
            end
        end
        local list = {}
        for playerName, count in pairs(counts) do
            local _, class = UnitClass(playerName)
            table.insert(list, {
                count      = count,
                playerName = playerName,
                class      = class,
            })
        end
        table.sort(list, function(a, b)
            if a.count ~= b.count then
                return a.count > b.count
            else
                return a.playerName < b.playerName
            end
        end)
        for i, item in ipairs(list) do
            local color = RAID_CLASS_COLORS[item.class] or HIGHLIGHT_FONT_COLOR
            GameTooltip:AddDoubleLine(item.playerName, item.count, color.r, color.g, color.b, HIGHLIGHT_FONT_COLOR:GetRGB())
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(Addon.localization.DEATHSHOW)

        GameTooltip:Show()
    end
end