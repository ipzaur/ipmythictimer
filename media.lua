local AddonName, Addon = ...

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register('font', 'Roboto Light', Addon.FONT_ROBOTO_LIGHT, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register('font', 'Roboto', Addon.FONT_ROBOTO, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)

LSM:Register('sound', 'Acoustic String x3', Addon.ACOUSTIC_STRING_X3)
