local AddonName, Addon = ...

Addon.FONT_ROBOTO_LIGHT = "Interface\\AddOns\\" .. AddonName .. "\\media\\RobotoCondensed-Light.ttf"
Addon.FONT_ROBOTO = "Interface\\AddOns\\" .. AddonName .. "\\media\\RobotoCondensed-Regular.ttf"

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register('font', 'Roboto Light', Addon.FONT_ROBOTO_LIGHT, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register('font', 'Roboto', Addon.FONT_ROBOTO, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)