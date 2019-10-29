if GetLocale() ~= "zhTW" then return end

local AddonName, Addon = ...

Addon.localization.CLEANDBBT  = "清理数据库"
Addon.localization.CLEANDBTT  = "Clear the addon internal base with the percent of monsters.\n" ..
                                "Helps if the percent counter is buggy"
Addon.localization.CLOSE      = "關閉"
Addon.localization.CUSTOMIZE  = "自定义框架"
Addon.localization.CCAPTION   = "主框架:\n" ..
                                "    LMB (拖动) - 移动\n" ..
                                "    RMB (拖动) - 调整\n" ..
                                "元素:\n" ..
                                "    LMB (拖动) - 移动\n" ..
                                "    RMB (请点击) - 字体大小\n" ..
                                "    MMB (请点击) - 切换可见性"
Addon.localization.DAMAGE     = "损伤"
Addon.localization.DEATHCOUNT = "死亡人数"
Addon.localization.DEATHSHOW  = "点击查看详细信息"
Addon.localization.DEATHTIME  = "浪费时间"
Addon.localization.DTHCAPTION = "死亡史"
Addon.localization.FONT       = "字形"
Addon.localization.FONTSIZE   = "字体大小"
Addon.localization.MAPBUT     = "LMB（单击）- 切换选项\n" ..
                                "LMB（拖动）- 移动按钮"
Addon.localization.MAPBUTOPT  = "显示/隐藏小地图按钮"
Addon.localization.MELEEATACK = "近战攻击"
Addon.localization.OPTIONS    = "選項"
Addon.localization.OPACITY    = "背景透明度"
Addon.localization.PROGFORMAT = {
    [1] = "百分 (100.00%)",
    [2] = "力 (300)",
}
Addon.localization.PROGRESS   = "进度格式"
Addon.localization.RESTORE    = "恢復"
Addon.localization.SCALE      = "縮放"
Addon.localization.SOURCE     = "资源"
Addon.localization.STARTINFO  = "iP Mythic Timer已載入。輸入 /ipmt 開啟選項。"
Addon.localization.TIME       = "时间"
Addon.localization.WHODIED    = "谁死了"