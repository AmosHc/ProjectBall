local ConstTable = {
    -- 场景相关表格
    EntityGen = "Configs/EntityGen",

    --实体表
    EntityTemplate = "Configs/EntityTemplate",
    EntityProp = "Configs/EntityProp",

    -- 装备/物品相关表格
    PropList = "Configs/PropList",
    EquipStrengthen = "Configs/EquipStrengthen",
    EquipStrengthenCost = "Configs/EquipStrengthenCost",
    EquipStrengthenLevel = "Configs/EquipStrengthenLevel",
    EquipStrengthenLevel = "Configs/EquipStrengthenLevel",

    EquipGemRelation = "Configs/EquipGemRelation",
    EquipGemLevelUp = "Configs/EquipGemLevelUp",

    -- 任务相关表格
    Task = "Configs/Task/Task",
    TaskConfig = "Configs/Task/TaskConfig",
    TaskTarget = "Configs/Task/TaskTarget",
    DailyTask = "Configs/Task/DailyTask",
    LoopTaskCfg = "Configs/Task/LoopTaskCfg",
    Mahjong = "Configs/Mahjong/Mahjong",
    MahjongCharacter = "Configs/Mahjong/MahjongCharacter",
    MahjongRelation = "Configs/Mahjong/MahjongRelation",
    MahjongEnding = "Configs/Mahjong/MahjongEnding",
    TaskPrize = "Configs/Task/TaskPrize",
    TaskPush = "Configs/Task/TaskPush",
    TaskText = "Configs/Texts/TaskText",
    TaskSavePosConfig = "Configs/Task/TaskSavePosConfig",
    Interlude = "Configs/Task/Interlude",

    --基础数据相关
    Texts = "Configs/Texts/Texts",
    Polished = "Configs/Polished",

    --神器相关
    ArtifactStone = "Configs/ArtifactStone",

    --商店相关
    Shop = "Configs/FirstClass",
    SecondShop = "Configs/SecondClass",
    ShopLimitTme = "Configs/LimitTime",
    ShopGoods = "Configs/Goods",
    ShopRefTime = "Configs/RefTime",

    --交易行
    Exchange = "Configs/Rrade",
    OnSellCost = "Configs/OnSellCost",

    --神域
    ParadiseHonour = "Configs/ParadiseHonour",

    --成就
    Achievement = "Configs/Achievement/Achievement",

    --对话树
    DialogueTreeList = "Configs/DialogueTree/DialogueTreeList",
    DialogEntity = "Configs/DialogueTree/DialogEntity",
    S_Drama = "Configs/S_Drama",
    
    TimelineList = "Configs/TimelineList",

    --剧情点
    StoryPoint = "Configs/Task/StoryPoint",
    StoryReward = "Configs/Task/StoryReward",
    StoryRewardRule = "Configs/Task/StoryRewardRule",

    --对话
    PlayerIdentity = "Configs/Task/PlayerIdentity",
    PlayerIdentityText = "Configs/Texts/PlayerIdentityText",
    NpcTalk = "Configs/Texts/NpcTalk",

    --timeline
    TimelineText = "Configs/Texts/TimelineText",

    -- 突发事件相关表格
    SEventText = "Configs/Texts/SEventText",
    SuddenEvent = "Configs/SuddenEvent/SuddenEvent",

    --设置
    SkillAuto = "Configs/SkillAuto",
    UICache = "Configs/UICache",
    --坐骑
    MountInit = "Configs/MountInit",

    --家族
    GuildShop = "Configs/GuildShop",
    GuildShopGoods = "Configs/GuildShopGoods",
    GuildCrusadeSurveyDungeon = "Configs/GuildCrusadeSurveyDungeon",
    GuildLog = "Configs/GuildLog",

    GuildTreasury = "Configs/GuildTreasury",
    GuildPosition = "Configs/GuildPosition",
    GuildParliamentSuit = "Configs/GuildParliamentSuit",
    GuildParliamentBadge = "Configs/GuildParliamentBadge",
    GuildParliament = "Configs/GuildParliament",
    GuildPara = "Configs/GuildPara",
    GuildManor = "Configs/GuildManor",
    GuildDevelopmentAdd = "Configs/GuildDevelopmentAdd",
    GuildCOC = "Configs/GuildCOC",
    GuildLog = "Configs/GuildLog",
    GuildLoot = "Configs/GuildLoot",
    GuildBuildingUpgrade = "Configs/GuildBuildingUpgrade",
    GuildBuilding = "Configs/GuildBuilding",
    GuildBase = "Configs/GuildBase",
    GuildManorTask = "Configs/GuildManorTask",

    --技能
    --Skills = "Configs/Skills",

    --无尽魔塔
    MonsterTowers = "Configs/MonsterTowers",
    Survive = "Configs/Survive",
    --大秘境
    BigRiftStorey = "Configs/BigRiftStorey",
    BigRiftRank = "Configs/BigRiftRank",

    --小秘境
    TrialRift = "Configs/TrialRift",
    TrialRiftBox = "Configs/TrialRiftBox",
    TrialRiftMap = "Configs/TrialRiftMap",

    --活动系统基本参数表
    ActivityInfo = "Configs/ActivityInfo",

    --新手引导
    Guide = "Configs/Guide/Guide",
    GuideStep = "Configs/Guide/GuideStep",
    GuideConfig = "Configs/Guide/GuideConfig",
    GuideShin = "Configs/Guide/GuideShin",
    GuideBook = "Configs/Guide/GuideBook",
    SystemLock = "Configs/Guide/SystemLock",
    SystemModuleLock = "Configs/Guide/SystemModuleLock",
    OptionGuide = "Configs/Guide/OptionGuide",
    UnlockForeshow = "Configs/Guide/UnlockForeshow",

    --福利
    MonthCard = "Configs/MonthCard",
    DaTiPuzzleCfg = "Configs/DaTiPuzzle",
    PassportInfo = "Configs/PassportInfo",
    PassportCardInfo = "Configs/PassportCardInfo",

    -- 家族远征格子相关
    GuildCrusadeGrids = "Configs/GuildCrusadeGrids",
    GuildCrusadeSurvey = "Configs/GuildCrusadeSurvey",
    GuildCrusadeSurveyDungeon = "Configs/GuildCrusadeSurveyDungeon",
    GuildCrusadeGridsQualities = "Configs/GuildCrusadeGridsQualities",
    GuildCrusadeAbyssDungeon = "Configs/GuildCrusadeAbyssDungeon",

    -- 离线配置相关
    OfflineEntityGen = "Configs/Offline/EntityGen",
    OfflineTask = "Configs/Offline/Task/Task",
    OfflineTaskConfig = "Configs/Offline/Task/TaskConfig",
    OfflineTaskTarget = "Configs/Offline/Task/TaskTarget",
    OfflineTaskText = "Configs/Offline/Task/TaskText",
    OfflineNpcTalk = "Configs/Offline/Task/NpcTalk",
    OfflineDramaText = "Configs/Offline/DramaTree/DramaText",
    --红点系统
    RedDotTree = "Configs/RedDotTree",
    Arena4vs4Config = "Configs/Arena4vs4",
    Arena4vs4DailyConfig = "Configs/Arena4vs4Daily",

    --成长之路
    GrowthReward = "Configs/Growth/GrowthReward",
    GrowthStructure = "Configs/Growth/GrowthStructure",

    --狩猎
    WildBossLevelName = "Configs/WildBossLevelName",
    FitSkillCombineCfg = "Configs/SkillCombine",

    EmojisConfig = "Configs/Emojis",
    EntityType = "Configs/EntityType",
    WantedValueCfg = "Configs/WantedValue",
    --临时加屏蔽字，后面删掉
    ShieldWordConfig = "Configs/ShieldWord",
    CurrencyIcon = "Configs/CurrencyIcon",
    
    --零散变量表
    GlobalVar = "Configs/GlobalVar",
    
    GiftToken = "Configs/GiftToken",
	
	FightCapacity = "Configs/FightCapacity",
	
	SkillDynRooms = "Configs/SkillDynRooms",
    WildBossLoot = "Configs/WildBossLoot",--狩猎boss掉落

    HeroTalk = "Configs/HeroTalk",
    CombatText = "Configs/CombatText",

    --乱斗
    ChaosBattleTask = "Configs/ChaosBattleTask",
    ChaosBattleConfig = "Configs/ChaosBattleConfig",
    DynRooms = "Configs/DynRooms"
}

return ConstTable