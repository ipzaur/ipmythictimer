local AddonName, Addon = ...
Addon.version = 1200

Addon.DECOR_FONT = Addon.FONT_ROBOTO
Addon.DECOR_FONTSIZE_DELTA = 0

Addon.AFFIX_TEEMING = 5

Addon.PROGRESS_FORMAT_PERCENT = 1
Addon.PROGRESS_FORMAT_FORCES  = 2

Addon.PROGRESS_DIRECTION_ASC  = 1
Addon.PROGRESS_DIRECTION_DESC = 2

Addon.season = {
    number   = 84,
    isActive = false,
}

if IPMTDungeon == nil then
    IPMTDungeon = {}
end

