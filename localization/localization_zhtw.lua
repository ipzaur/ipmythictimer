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
                                "    MMB (請點擊) - 切換可見性"
Addon.localization.DAMAGE     = "傷害"
Addon.localization.DEATHCOUNT = "死亡人數"
Addon.localization.DEATHSHOW  = "點擊查看詳細訊息"
Addon.localization.DEATHTIME  = "損失時間"
Addon.localization.DIRECTION  = "進度變化"
Addon.localization.DIRECTIONS = {
    [1] = "升序 (0% -> 100%)",
    [2] = "降序 (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "死亡紀錄"
Addon.localization.DUNGENAME  = "地城名稱"
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
    [2] = "強制 (300)",
}
Addon.localization.PROGRESS   = "進度格式"
Addon.localization.RESTORE    = "恢復"
Addon.localization.SCALE      = "縮放"
Addon.localization.SOURCE     = "資源"
Addon.localization.STARTINFO  = "iP Mythic Timer已載入。輸入 /ipmt 開啟選項。"
Addon.localization.TIME       = "時間"
Addon.localization.UNKNOWN    = "未知"
Addon.localization.WHODIED    = "誰死了"

Addon.localization.HELP = {
    LEVEL      = "啟動鑰石等級",
    PLUSLEVEL  = "鑰石將如何隨著當前時間升級",
    TIMER      = "剩餘的時間",
    PLUSTIMER  = "降鑰石等級進度的時間",
    DEATHTIMER = "因死亡而浪費的時間",
    PROGRESS   = "小怪已擊殺",
    PROGNOSIS  = "在擊殺拉的小怪後的進度",
    BOSSES     = "首領已擊殺",
    AFFIXES    = "啟用的詞綴",
}

Addon.localization.CORRUPTED = {
    [161124] = "『英雄擊破者』爾格羅斯 (坦克殺手)",
    [161241] = "虛織者瑪希爾 (蜘蛛)",
    [161243] = "山姆雷克，混沌召喚者 (恐懼)",
    [161244] = "腐化者之血 (軟泥)",
}
