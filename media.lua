local AddonName, Addon = ...

Addon.FONT_ROBOTO_LIGHT = "Interface\\AddOns\\" .. AddonName .. "\\media\\RobotoCondensed-Light.ttf"
Addon.FONT_ROBOTO = "Interface\\AddOns\\" .. AddonName .. "\\media\\RobotoCondensed-Regular.ttf"
Addon.ACOUSTIC_STRING_X3 = "Interface\\AddOns\\" .. AddonName .. "\\media\\acoustic_string_x3.mp3"

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register('font', 'Roboto Light', Addon.FONT_ROBOTO_LIGHT, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register('font', 'Roboto', Addon.FONT_ROBOTO, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)

LSM:Register('sound', 'Acoustic String x3', Addon.ACOUSTIC_STRING_X3)
