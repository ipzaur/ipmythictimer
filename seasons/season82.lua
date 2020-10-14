local AddonName, Addon = ...

if Addon.season.number ~= 82 then return end

Addon.season.affix = 117

function Addon.season:GetForces(npcID, isTeeming)
    if npcID == 148716 or npcID == 148893 or npcID == 148894 then
        return 0
    end
end

function Addon.season:Prognosis(forces)
    local currentPercent = IPMTDungeon.trash.current / IPMTDungeon.trash.total * 100
    local prognosisPercent = forces / IPMTDungeon.trash.total * 100

    local currentWave = math.floor(currentPercent / 20)
    local prognosisWave = math.floor(prognosisPercent / 20)
    if (prognosisPercent % 20 > 18 or currentWave < prognosisWave) then
        Addon.fMain.prognosis.text:SetTextColor(1,0,0)
    elseif (prognosisPercent % 20 > 15) then
        Addon.fMain.prognosis.text:SetTextColor(1,1,0)
    else
        Addon.fMain.prognosis.text:SetTextColor(1,1,1)
    end
end

function Addon.season:Progress(forces)
    local percent = IPMTDungeon.trash.current / IPMTDungeon.trash.total * 100
    if (percent % 20 > 18) then
        Addon.fMain.progress.text:SetTextColor(1,0,0)
    elseif (percent % 20 > 15) then
        Addon.fMain.progress.text:SetTextColor(1,1,0)
    else
        Addon.fMain.progress.text:SetTextColor(1,1,1)
    end
end
