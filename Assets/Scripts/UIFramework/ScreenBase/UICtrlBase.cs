using UnityEngine;
using XLua;

public enum ESceenPriority
{
    Default = 0,   //大厅以下 预留 目前没有使用到
    PriorityLobby = 10,   //大厅层
    PriorityLobbyFace = 15, //大厅上运营活动
    PriorityLobbyForSystem = 20,   //大厅上各种外围系统层级
    PriorityLobbyForMatchingSystem0 = 40,   //大厅上的各种邀请或者浮动界面 
    PriorityLowLoadingCommonMessageBoxTips0 = 50, //游戏中各种通用弹框（低于loading页面）
    PriorityLobbyForLoading0 = 60, //各种loading页面层级
    PriorityUpLoadingCommonMessageBoxTips0 = 70, //游戏中各种通用弹框层级（高于loading页面）
    PriorityLobbyForNewPlayerGuide0 = 80, //游戏中新手指引层级

    //PriorityCount = 100
};

public enum EUICareAboutMoneyType
{
    Silver,// 银币
    Gold,// 金币
    Strength,// 体力
    Gem// 钻石
}

public class UICtrlBase : UIFEventAutoRelease
{
    [HideInInspector]
    private Canvas _ctrlCanvas;

    public Canvas ctrlCanvas
    {
        get { return _ctrlCanvas; }
    }

    //基准分辨率
    public Vector2 mReferenceResolution = new Vector2(1624f, 750f);

    [Tooltip("SceenBase 层级")]
    public ESceenPriority screenPriority = ESceenPriority.PriorityLobbyForSystem; // 层级
    
    [Tooltip("勾选此选项后,打开本界面时底部会自动生成遮罩\n用户点击到遮罩面板会自动关闭此页面")]
    public bool mIsPopup = false;
    
    [Tooltip("勾选此项后，设置此页面为模态窗口，模态窗口点击空白处无法穿透到底部UI")]
    public bool mIsModelWindow = false;
    
    [Tooltip("勾选此项后，打开界面会底部会生成灰色遮罩")]
    public bool mUseMask = false;


    [Tooltip("勾选此选项后,不会被 mHideOtherScreenWhenThisOnTop 控制")]
    public bool mAlwaysShow = false;
    [Tooltip("勾选此选项后,当该界面打开，会隐藏他下面的其他非AlwaysShow界面")]
    public bool mHideOtherScreenWhenThisOnTop = false;

    [Tooltip("是否关心货币栏的状态")]
    public bool mBCareAboutMoney = false;
    [Tooltip("如果CareAboutCurrency为True 那么它关心哪些")]
    public EUICareAboutMoneyType[] MoneyType;

    void Awake()
    {
        _ctrlCanvas = GetComponent<Canvas>();
    }

    public int GetScreenPriority()
    {
        return (int) screenPriority;
    }
}