local AddonName, Addon = ...

if Addon.season.number ~= 91 then return end

local LSM = LibStub("LibSharedMedia-3.0")

Addon.season.affix = 121

Addon.defaultOption.wavealert = true
Addon.defaultOption.percentAlert = 16
Addon.defaultOption.wavesound = Addon.ACOUSTIC_STRING_X3

function Addon.season:GetForces(npcID, isTeeming)
    if npcID == 173729 then
        return 0
    end
end

local current = {
    percent = 0,
    wave    = 0,
}
local sounded = {
    percent = current.percent,
    wave    = current.wave - 1,
}
local function AlertWave()
    if not IPMTOptions.wavealert then
        return false
    end
    if current.wave ~= sounded.wave then
        PlaySoundFile(IPMTOptions.wavesound, "SFX")
        sounded.wave = current.wave
    end
end

function Addon.season:Prognosis(forces)
    local prognosisPercent = forces / IPMTDungeon.trash.total * 100
    if sounded.percent > prognosisPercent then
        sounded.wave = current.wave - 1
    end
    sounded.percent = prognosisPercent
    local prognosisWave = math.floor(prognosisPercent / 20)
    if (prognosisPercent % 20 > 18 or current.wave < prognosisWave) then
        Addon.fMain.prognosis.text:SetTextColor(1,0,0)
    elseif (prognosisPercent % 20 > 15) then
        Addon.fMain.prognosis.text:SetTextColor(1,1,0)
    else
        Addon.fMain.prognosis.text:SetTextColor(1,1,1)
    end

    if prognosisPercent % 20 > IPMTOptions.percentAlert or current.wave < prognosisWave then
        AlertWave()
    end
end

function Addon.season:Progress(forces)
    current.percent = IPMTDungeon.trash.current / IPMTDungeon.trash.total * 100
    current.wave = math.floor(current.percent / 20)
    if (current.percent % 20 > 18) then
        Addon.fMain.progress.text:SetTextColor(1,0,0)
    elseif (current.percent % 20 > 15) then
        Addon.fMain.progress.text:SetTextColor(1,1,0)
    else
        Addon.fMain.progress.text:SetTextColor(1,1,1)
    end
end

Addon.season.options = {}

-- Sound list
local function getSoundList()
    local soundList = LSM:List('sound')
    local list = {}
    for i,sound in pairs(soundList) do
        local filepath = LSM:Fetch('sound', sound)
        list[filepath] = sound
    end
    return list
end

local openOptions = false
function Addon.season.options:Render(top)
    local subTop = top
    -- Customize checkbox
    Addon.fOptions.season.wavealert = CreateFrame("CheckButton", nil, Addon.fOptions.common, "IPCheckButton")
    Addon.fOptions.season.wavealert:SetHeight(22)
    Addon.fOptions.season.wavealert:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, subTop)
    Addon.fOptions.season.wavealert:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, subTop)
    Addon.fOptions.season.wavealert:SetText(string.gsub(Addon.localization.WAVEALERT, '{percent}', IPMTOptions.percentAlert))
    Addon.fOptions.season.wavealert:SetScript("PostClick", function(self)
        IPMTOptions.wavealert = Addon.fOptions.season.wavealert:GetChecked()
    end)
    Addon.fOptions.season.wavealert:SetChecked(IPMTOptions.wavealert)

    -- Percents for alert edit box
    -- BackgroundBorder Inset slider
    subTop = subTop - 24
    Addon.fOptions.season.percents = CreateFrame("Slider", nil, Addon.fOptions.common, "IPSlider")
    Addon.fOptions.season.percents:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, subTop)
    Addon.fOptions.season.percents:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, subTop)
    Addon.fOptions.season.percents:SetOrientation('HORIZONTAL')
    Addon.fOptions.season.percents:SetMinMaxValues(15, 19)
    Addon.fOptions.season.percents:SetValueStep(1.0)
    Addon.fOptions.season.percents:EnableMouseWheel(0)
    Addon.fOptions.season.percents:SetObeyStepOnDrag(true)
    Addon.fOptions.season.percents:SetScript('OnValueChanged', function(self)
        IPMTOptions.percentAlert = self:GetValue()
        Addon.fOptions.season.wavealert:SetText(string.gsub(Addon.localization.WAVEALERT, '{percent}', IPMTOptions.percentAlert))
    end)
    Addon.fOptions.season.percents:SetValue(IPMTOptions.percentAlert)


    subTop = subTop - 36
    Addon.fOptions.season.soundList = CreateFrame("Button", nil, Addon.fOptions.common, "IPListBox")
    Addon.fOptions.season.soundList:SetList(getSoundList, IPMTOptions.wavesound)
    Addon.fOptions.season.soundList:SetCallback({
        OnSelect = function(self, key, text)
            IPMTOptions.wavesound = key
            PlaySoundFile(IPMTOptions.wavesound, "SFX")
        end,
    })
    Addon.fOptions.season.soundList:SetHeight(30)
    Addon.fOptions.season.soundList:SetPoint("LEFT", Addon.fOptions.common, "TOPLEFT", 0, subTop)
    Addon.fOptions.season.soundList:SetPoint("RIGHT", Addon.fOptions.common, "TOPRIGHT", 0, subTop)

    return 160
end

function Addon.season.options:ShowOptions()
    Addon.fOptions.season.wavealert:SetChecked(IPMTOptions.wavealert)
    Addon.fOptions.season.soundList:SelectItem(IPMTOptions.wavesound, true)
end