local AddonName, Addon = ...

Addon.deaths = {}

function Addon.deaths:Toggle(show, wFake)
    if (show == nil) then
        show = not Addon.fDeaths:IsShown()
    end
    if show then
        if not Addon.opened.options or wFake then
            Addon.deaths:Show(wFake)
        end
    else
        Addon.fDeaths:Hide()
    end
end

function Addon.deaths:Show(wFake)
    if not IPMTDungeon.deathes or not IPMTDungeon.deathes.list or #IPMTDungeon.deathes.list == 0 then
        if wFake then
            Addon.deaths:Record(nil, true)
        else
            return false
        end
    end
    local counts = {}
    for i, death in ipairs(IPMTDungeon.deathes.list) do
        if counts[death.playerName] then
            counts[death.playerName] = counts[death.playerName] + 1
        else
            counts[death.playerName] = 1
        end
        Addon:FillDeathRow(i, death, counts[death.playerName])
    end
    local deaths = #IPMTDungeon.deathes.list
    local rows = #Addon.fDeaths.line
    if deaths < rows then
        for i = deaths+1,rows do
            Addon.fDeaths.line[i]:Hide()
        end
    end
    Addon.fDeaths:Show()
    Addon.fDeaths.lines:SetHeight(Addon.deathRowHeight * deaths)
end

function Addon.deaths:Record(playerName, isFake)
    local spellId, spellIcon, enemy, color, deathTime, damage
    if isFake then
        spellId = 197137
        spellIcon = 135128
        deathTime = 585
        playerName = UnitName("player")
        local _, class = UnitClass("player")
        color = RAID_CLASS_COLORS[class] or HIGHLIGHT_FONT_COLOR
        damage = 7700
        enemy = "Ловчий из клана Колец Ненависти"
    else
        if IPMTDungeon.lastHit[playerName] == nil then
            spellId = nil
            spellIcon = nil
            enemy = Addon.localization.UNKNOWN
            damage = ''
        else
            spellId = IPMTDungeon.lastHit[playerName].spellId
            enemy   = IPMTDungeon.lastHit[playerName].enemy
            damage  = IPMTDungeon.lastHit[playerName].damage
            if spellId > 1 then
                spellIcon = C_Spell.GetSpellInfo(spellId).iconID
            else
                spellIcon = 130730 -- Melee Attack Icon
            end
        end
        color = HIGHLIGHT_FONT_COLOR
        if IPMTDungeon.players[playerName] and IPMTDungeon.players[playerName].color then
            color = IPMTDungeon.players[playerName].color
        end
        deathTime = IPMTDungeon.time
    end
    if IPMTDungeon.deathes == nil then
        IPMTDungeon.deathes = {}
    end
    if IPMTDungeon.deathes.list == nil or IPMTDungeon.deathes.list[1].isFake then
        IPMTDungeon.deathes.list = {}
    end
    local record = {
        playerName = playerName,
        time       = deathTime,
        enemy      = enemy,
        damage     = damage,
        color      = color,
        spell      = {
            id   = spellId,
            icon = spellIcon,
        },
    }
    if isFake then
        record.isFake = true
    end
    table.insert(IPMTDungeon.deathes.list, record)
    IPMTDungeon.lastHit[playerName] = nil
end

function Addon.deaths:ShowTooltip(self)
    if not IPMTDungeon.deathes or not IPMTDungeon.deathes.list or #IPMTDungeon.deathes.list == 0 then
        return false
    end

    if not Addon.opened.options then
        local deathes, timeLost = C_ChallengeMode.GetDeathCount()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(Addon.localization.DEATHCOUNT .. " : " .. deathes, 1, 1, 1)
        GameTooltip:AddLine(Addon.localization.DEATHTIME .. " : " .. SecondsToClock(timeLost), .8, 0, 0)
        GameTooltip:AddLine(" ")

        local counts = {}
        for i, death in ipairs(IPMTDungeon.deathes.list) do
            if counts[death.playerName] ~= nil then
                counts[death.playerName].count = counts[death.playerName].count + 1
            else
                counts[death.playerName] = {
                    count = 1,
                    color = death.color,
                }
            end
        end
        local list = {}
        for playerName, deathInfo in pairs(counts) do
            table.insert(list, {
                count      = deathInfo.count,
                playerName = playerName,
                color      = deathInfo.color,
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
            GameTooltip:AddDoubleLine(item.playerName, item.count, item.color.r, item.color.g, item.color.b, HIGHLIGHT_FONT_COLOR:GetRGB())
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(Addon.localization.DEATHSHOW)

        GameTooltip:Show()
    end
end

function Addon.deaths:Update()
    local deathes, timeLost = C_ChallengeMode.GetDeathCount()
    if deathes > 0 then
        Addon.fMain.deathTimer.text:SetText("-" .. SecondsToClock(timeLost) .. " [" .. deathes .. "]")
        if Addon.opened.themes or not IPMTTheme[IPMTOptions.theme].elements.deathTimer.hidden then
            Addon.fMain.deathTimer:Show()
        end
    elseif not Addon.opened.themes then
        Addon.fMain.deathTimer:Hide()
    end
end
