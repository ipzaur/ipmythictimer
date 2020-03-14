local AddonName, Addon = ...

Addon.localization = {}

Addon.localization.CLEANDBBT  = "Clean database"
Addon.localization.CLEANDBTT  = "Clear the addon internal base with the percent of monsters.\n" ..
                                "Helps if the percent counter is buggy"
Addon.localization.CLOSE      = "Close"
Addon.localization.CUSTOMIZE  = "Customize frame"
Addon.localization.CCAPTION   = "Main frame:\n" ..
                                "    LMB (drag) - move\n" ..
                                "    RMB (drag) - resize\n" ..
                                "Element:\n" ..
                                "    LMB (drag) - move\n" ..
                                "    RMB (click) - font size\n" ..
                                "    MMB (click) - toggle visibility"
Addon.localization.DAMAGE     = "Damage"
Addon.localization.DEATHCOUNT = "Deaths"
Addon.localization.DEATHSHOW  = "Click for detail information"
Addon.localization.DEATHTIME  = "Time lost"
Addon.localization.DIRECTION  = "Progress changing"
Addon.localization.DIRECTIONS = {
    [1] = "ascending (0% -> 100%)",
    [2] = "descending (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "Deaths history"
Addon.localization.DUNGENAME  = "Dungeon name"
Addon.localization.FONT       = "Font"
Addon.localization.FONTSIZE   = "Font size"
Addon.localization.MAPBUT     = "LMB (click) - toggle options\n" ..
                                "LMB (drag) - move button"
Addon.localization.MAPBUTOPT  = "Show/Hide minimap button"
Addon.localization.MELEEATACK = "Melee attack"
Addon.localization.OPTIONS    = "Options"
Addon.localization.OPACITY    = "Background opacity"
Addon.localization.PROGFORMAT = {
    [1] = "Percent (100.00%)",
    [2] = "Forces (300)",
}
Addon.localization.PROGRESS   = "Progress format"
Addon.localization.RESTORE    = "Restore"
Addon.localization.SCALE      = "Scale"
Addon.localization.SOURCE     = "Source"
Addon.localization.STARTINFO  = "iP Mythic Timer loaded. Type /ipmt for options."
Addon.localization.TIME       = "Time"
Addon.localization.UNKNOWN    = "Unknown"
Addon.localization.WHODIED    = "Who died"

Addon.localization.HELP = {
    LEVEL      = "Active key Level",
    PLUSLEVEL  = "How key will upgrade with current time",
    TIMER      = "Time left",
    PLUSTIMER  = "Time to downgrade key progress",
    DEATHTIMER = "Time wasted due to deaths",
    PROGRESS   = "Trash killed",
    PROGNOSIS  = "Progress after kill pulled mobs",
    BOSSES     = "Bosses killed",
    AFFIXES    = "Active affixes",
}

Addon.localization.CORRUPTED = {
    [161124] = "Urg'roth, Breaker of Heroes (Tank breaker)",
    [161241] = "Voidweaver Mal'thir (Spider)",
    [161243] = "Samh'rek, Beckoner of Chaos (Fear)",
    [161244] = "Blood of the Corruptor (Blob)",
}