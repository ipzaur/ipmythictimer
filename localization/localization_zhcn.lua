if GetLocale() ~= "zhCN" then return end

local AddonName, Addon = ...

Addon.localization.ADDELEMENT = "Add element" -- need correct

Addon.localization.BACKGROUND = "背景"
Addon.localization.BORDER     = "边框"
Addon.localization.BRDERWIDTH = "边框宽度"

Addon.localization.CLEANDBBT  = "清除数据库"
Addon.localization.CLEANDBTT  = "清除插件内部怪物百分比基础数据。\n" ..
                                "如果百分比计数器是错误的则会有帮助"
Addon.localization.CLOSE      = "关闭"
Addon.localization.COLOR      = "颜色"
Addon.localization.COLORDESCR = {
    TIMER = {
        [-1] = '超时后的计时器颜色',
        [0]  = '+1的计时器颜色',
        [1]  = '+2的计时器颜色',
        [2]  = '+3的计时器颜色',
    },
    OBELISKS = {
        [-1] = '激活的方尖碑颜色',
        [0]  = '关闭的方尖碑颜色',
    },
}
Addon.localization.COPY       = "复制"
Addon.localization.CORRUPTED = {
    [161124] = "乌尔格斯，勇士噬灭者(坦克终结者)",
    [161241] = "纺虚者玛熙尔(蜘蛛)",
    [161243] = "萨姆莱克，混沌唤引者(恐惧)",
    [161244] = "腐蚀者之血(软泥)",
}

Addon.localization.DAMAGE     = "伤害"
Addon.localization.DECORELEMS = "Decor elements" -- need correct
Addon.localization.DEFAULT    = "默认"
Addon.localization.DEATHCOUNT = "死亡"
Addon.localization.DEATHSHOW  = "点击查看详细信息"
Addon.localization.DEATHTIME  = "浪费时间"
Addon.localization.DELETDECOR = "Delete decorative element" -- need correct
Addon.localization.DIRECTION  = "进度变化"
Addon.localization.DIRECTIONS = {
    asc  = "升序 (0% -> 100%)",
    desc = "降序 (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "死亡历史纪录"

Addon.localization.ELEMENT    = {
    AFFIXES   = "激活词缀",
    BOSSES    = "BOSS",
    DEATHS    = "死亡",
    DUNGENAME = "地下城名称",
    LEVEL     = "钥匙等级",
    OBELISKS  = "方尖碑",
    PLUSLEVEL = "钥匙升级",
    PLUSTIMER = "降低钥匙升级的时间",
    PROGRESS  = "敌方被击杀",
    PROGNOSIS = "拉怪后百分比",
    TIMER     = "钥匙计时器",
}
Addon.localization.ELEMACTION =  {
    SHOW = "显示元素",
    HIDE = "隐藏元素",
    MOVE = "移动元素",
}
Addon.localization.ELEMPOS    = "元素位置"

Addon.localization.FONT       = "字体"
Addon.localization.FONTSIZE   = "字体大小"

Addon.localization.HEIGHT     = "高度"
Addon.localization.HELP = {
    AFFIXES    = "启用词缀",
    BOSSES     = "已击杀BOSS",
    DEATHTIMER = "死亡浪费的时间",
    LEVEL      = "启用钥匙等级",
    PLUSLEVEL  = "钥匙如何随着当前时间升级",
    PLUSTIMER  = "降级钥匙进度的时间",
    PROGNOSIS  = "杀死拉的小怪后的进度",
    PROGRESS   = "已击杀小怪",
    TIMER      = "剩余时间",
}

Addon.localization.ICONSIZE   = "图标大小"

Addon.localization.MAPBUT     = "鼠标左键(单击)- 切换选项\n" ..
                                "鼠标左键(拖动)- 移动按钮"
Addon.localization.MAPBUTOPT  = "显示/隐藏小地图按钮"
Addon.localization.MELEEATACK = "近战攻击"

Addon.localization.OPTIONS    = "选项"

Addon.localization.POINT      = "点"
Addon.localization.PRECISEPOS = "右键进行精确定位"
Addon.localization.PROGFORMAT = {
    percent = "百分比 (100.00%)",
    forces  = "强制 (300)",
}
Addon.localization.PROGRESS   = "进度格式"

Addon.localization.RELPOINT   = '相对点'

Addon.localization.SCALE      = "比例"
Addon.localization.SEASONOPTS = '赛季选项'
Addon.localization.SOURCE     = "资源"
Addon.localization.STARTINFO  = "iP Mythic Timer已载入。键入 /ipmt 开启选项。"

Addon.localization.TEXTURE    = "纹理"
Addon.localization.TXTRINDENT = "纹理缩进"
Addon.localization.THEME      = "主题"
Addon.localization.THEMEBUTNS = {
    DUPLICATE   = "复制当前主题",
    DELETE      = "删除当前主题",
    RESTORE     = '恢复主题 "' .. Addon.localization.DEFAULT .. '" 并选择它',
    OPENEDITOR  = "打开主题编辑器",
    CLOSEEDITOR = "关闭主题编辑器",
}
Addon.localization.THEMEDITOR = "编辑主题"
Addon.localization.THEMENAME  = "主题名称"
Addon.localization.TIME       = "时间"
Addon.localization.TIMERCHCKP = "计时器检查点"

Addon.localization.UNKNOWN    = "未知"

Addon.localization.WAVEALERT  = '每20%提醒'
Addon.localization.WIDTH      = "宽度"
Addon.localization.WHODIED    = "谁死了"
