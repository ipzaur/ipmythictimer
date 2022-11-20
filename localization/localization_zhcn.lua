if GetLocale() ~= "zhCN" then return end

local AddonName, Addon = ...

Addon.localization.ADDELEMENT = "添加元素"

Addon.localization.BACKGROUND = "背景"
Addon.localization.BORDER     = "边框"
Addon.localization.BORDERLIST = "从库中选择一个边框"
Addon.localization.BOTTOM     = "底部"
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
Addon.localization.DECORELEMS = "装饰元素"
Addon.localization.DEFAULT    = "默认"
Addon.localization.DEATHCOUNT = "死亡"
Addon.localization.DEATHSHOW  = "点击查看详细信息"
Addon.localization.DEATHTIME  = "浪费时间"
Addon.localization.DELETDECOR = "删除装饰元素"
Addon.localization.DIRECTION  = "进度变化"
Addon.localization.DIRECTIONS = {
    asc  = "升序 (0% -> 100%)",
    desc = "降序 (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "死亡历史纪录"
Addon.localization.DEATHSHIDE = "Close deaths history" -- need correct
Addon.localization.DEATHSSHOW = "Show deaths history" -- need correct
Addon.localization.DTHCAPTFS  = "Caption font size" -- need correct
Addon.localization.DTHHEADFS  = "Column name font size" -- need correct
Addon.localization.DTHRCRDPFS = "Row font size" -- need correct

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
    TORMENT   = "磨难怪",
}
Addon.localization.ELEMACTION =  {
    SHOW = "显示元素",
    HIDE = "隐藏元素",
    MOVE = "移动元素",
}
Addon.localization.ELEMPOS    = "元素位置"

Addon.localization.FONT       = "字体"
Addon.localization.FONTSIZE   = "字体大小"
Addon.localization.FONTSTYLE  = "字体样式"
Addon.localization.FONTSTYLES = {
    NORMAL  = "普通",
    OUTLINE = "轮廓线",
    MONO    = "单色",
    THOUTLN = "加粗轮廓线",
}

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
Addon.localization.IMPORT     = "导入"

Addon.localization.JUSTIFYH   = "水平文本对齐"
Addon.localization.JUSTIFYV   = "Vertical text justify" -- need correct

Addon.localization.LAYER      = "层"
Addon.localization.LEFT       = "左"
Addon.localization.LIMITPRGRS = "Limit progress to 100%" -- need correct

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
Addon.localization.RIGHT      = "右"

Addon.localization.SCALE      = "比例"
Addon.localization.SEASONOPTS = '赛季选项'
Addon.localization.SHROUDED   = {
    [189878] = "Натрезим-лазутчик", -- need correct
    [190128] = "Зул'гамуз", -- need correct
}
Addon.localization.SOURCE     = "资源"
Addon.localization.STARTINFO  = "iP Mythic Timer已载入。键入 /ipmt 开启选项。"

Addon.localization.TEXTURE    = "纹理"
Addon.localization.TEXTURELST = "从库中选择一个纹理"
Addon.localization.TXTCROP    = "裁剪纹理"
Addon.localization.TXTRINDENT = "纹理缩进"
Addon.localization.TXTSETTING = "高级纹理设置"
Addon.localization.THEME      = "主题"
Addon.localization.THEMEACTN  = {
    NEW    = "创建新主题",
    COPY   = "复制当前主题",
    IMPORT = "导入主题",
    EXPORT = "导出主题",
}
Addon.localization.THEMEBUTNS = {
    ACTIONS     = "应用当前主题",
    DUPLICATE   = "复制当前主题",
    DELETE      = "删除当前主题",
    RESTORE     = '恢复主题 "' .. Addon.localization.DEFAULT .. '" 并选择它',
    OPENEDITOR  = "打开主题编辑器",
    CLOSEEDITOR = "关闭主题编辑器",
}
Addon.localization.THEMEDITOR = "编辑主题"
Addon.localization.THEMENAME  = "主题名称"
Addon.localization.TIMERDIRS  = {
    desc = "降序 (36:00 -> 0:00)",
    asc  = "升序 (0:00 -> 36:00)",
}
Addon.localization.TIMERDIR   = "计时器方向"
Addon.localization.TOP        = "顶部"
Addon.localization.TORMENTED  = {
    [179891] = "粉碎者索苟冬 (锁链)",
    [179890] = "刽子手瓦卢斯 (恐惧)",
    [179892] = "淞心之欧罗斯 (冰)",
    [179446] = "焚化者阿蔻拉斯 (火)",
}
Addon.localization.TIME       = "时间"
Addon.localization.TIMERCHCKP = "计时器检查点"

Addon.localization.UNKNOWN    = "未知"

Addon.localization.WAVEALERT  = '每{percent}%提醒'
Addon.localization.WIDTH      = "宽度"
Addon.localization.WHODIED    = "谁死了"
