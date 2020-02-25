if GetLocale() ~= "zhTW" then return end

local AddonName, Addon = ...

Addon.localization.CLEANDBBT  = "清理數據庫"
Addon.localization.CLEANDBTT  = "清理插件內部怪物百分比基礎數據。\n" ..
                                "如果百分比計數器有錯誤這是有幫助的"
Addon.localization.CLOSE      = "關閉"
Addon.localization.CUSTOMIZE  = "自定義框架"
Addon.localization.CCAPTION   = "主框架:\n" ..
                                "    滑鼠左鍵 - 移動\n" ..
                                "    滑鼠右鍵 - 調整\n" ..
                                "元素:\n" ..
                                "    滑鼠左鍵 - 移動\n" ..
                                "    滑鼠右鍵 - 字體大小\n" ..
                                "    MMB (请点击) - 切换可见性"
Addon.localization.DAMAGE     = "傷害"
Addon.localization.DEATHCOUNT = "死亡人數"
Addon.localization.DEATHSHOW  = "點擊查看詳細訊息"
Addon.localization.DEATHTIME  = "損失時間"
Addon.localization.DIRECTION  = "进度变化"
Addon.localization.DIRECTIONS = {
    [1] = "上升 (0% -> 100%)",
    [2] = "降序 (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "死亡紀錄"
Addon.localization.DUNGENAME  = "地牢名稱"
Addon.localization.FONT       = "字型"
Addon.localization.FONTSIZE   = "字體大小"
Addon.localization.MAPBUT     = "滑鼠左鍵（單擊）- 切換選項\n" ..
                                "滑鼠左鍵（拖動）- 移動按鈕"
Addon.localization.MAPBUTOPT  = "顯示/隱藏小地圖按鈕"
Addon.localization.MELEEATACK = "近戰攻擊"
Addon.localization.OPTIONS    = "選項"
Addon.localization.OPACITY    = "背景透明度"
Addon.localization.PROGFORMAT = {
    [1] = "百分 (100.00%)",
    [2] = "力 (300)",
}
Addon.localization.PROGRESS   = "进度格式"
Addon.localization.RESTORE    = "恢復"
Addon.localization.SCALE      = "縮放"
Addon.localization.SOURCE     = "資源"
Addon.localization.STARTINFO  = "iP Mythic Timer已載入。輸入 /ipmt 開啟選項。"
Addon.localization.TIME       = "時間"
Addon.localization.UNKNOWN    = "未知"
Addon.localization.WHODIED    = "誰死了"

Addon.localization.HELP = {
    LEVEL      = "活动密钥级别",
    PLUSLEVEL  = "密钥将如何随着当前时间升级",
    TIMER      = "剩下的时间",
    PLUSTIMER  = "是时候降级关键进度了",
    DEATHTIMER = "由于死亡而浪费时间",
    PROGRESS   = "垃圾被杀死",
    PROGNOSIS  = "杀死小怪后的进展",
    BOSSES     = "老板被杀",
    AFFIXES    = "主动词缀",
}