if GetLocale() ~= "zhCN" then return end

local AddonName, Addon = ...

Addon.localization.CLEANDBBT  = "清除数据库"
Addon.localization.CLEANDBTT  = "清除插件内部怪物百分比基础数据。\n" ..
                                "如果百分比计数器是错误的则会有帮助"
Addon.localization.CLOSE      = "关闭"
Addon.localization.CUSTOMIZE  = "自定义框体"
Addon.localization.CCAPTION   = "主框体:\n" ..
                                "    鼠标左键(拖动) - 移动\n" ..
                                "    鼠标右键(拖动) - 调整大小\n" ..
                                "元素:\n" ..
                                "    鼠标左键(拖动) - 移动\n" ..
                                "    鼠标右键(单击) - 字体大小\n" ..
                                "    鼠标中键(单击) - 切换可见性"
Addon.localization.DAMAGE     = "伤害"
Addon.localization.DEATHCOUNT = "死亡"
Addon.localization.DEATHSHOW  = "点击查看详细信息"
Addon.localization.DEATHTIME  = "浪费时间"
Addon.localization.DIRECTION  = "进度变化"
Addon.localization.DIRECTIONS = {
    [1] = "升序 (0% -> 100%)",
    [2] = "降序 (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "死亡历史纪录"
Addon.localization.DUNGENAME  = "地下城名称"
Addon.localization.FONT       = "字体"
Addon.localization.FONTSIZE   = "字体大小"
Addon.localization.MAPBUT     = "鼠标左键(单击)- 切换选项\n" ..
                                "鼠标左键(拖动)- 移动按钮"
Addon.localization.MAPBUTOPT  = "显示/隐藏小地图按钮"
Addon.localization.MELEEATACK = "近战攻击"
Addon.localization.OPTIONS    = "选项"
Addon.localization.OPACITY    = "背景透明度"
Addon.localization.PROGFORMAT = {
    [1] = "百分比 (100.00%)",
    [2] = "强制 (300)",
}
Addon.localization.PROGRESS   = "进度格式"
Addon.localization.RESTORE    = "恢复"
Addon.localization.SCALE      = "比例"
Addon.localization.SOURCE     = "资源"
Addon.localization.STARTINFO  = "iP Mythic Timer已载入。键入 /ipmt 开启选项。"
Addon.localization.TIME       = "时间"
Addon.localization.UNKNOWN    = "未知"
Addon.localization.WHODIED    = "谁死了"

Addon.localization.HELP = {
    LEVEL      = "启用钥匙等级",
    PLUSLEVEL  = "钥匙如何随着当前时间升级",
    TIMER      = "剩余时间",
    PLUSTIMER  = "降级钥匙进度的时间",
    DEATHTIMER = "死亡浪费的时间",
    PROGRESS   = "已击杀小怪",
    PROGNOSIS  = "杀死拉的小怪后的进度",
    BOSSES     = "已击杀BOSS",
    AFFIXES    = "启用词缀",
}

Addon.localization.CORRUPTED = {
    [161124] = "乌尔格斯，勇士噬灭者(坦克终结者)",
    [161241] = "纺虚者玛熙尔(蜘蛛)",
    [161243] = "萨姆莱克，混沌唤引者(恐惧)",
    [161244] = "腐蚀者之血(软泥)",
}