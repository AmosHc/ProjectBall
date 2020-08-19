using UnityEngine;
using XLua;

public class EventManager
{
    //public static FEvent OnGuildCreated = new FEvent);   //创建公会成功
    public static FEvent<bool> OnGuildCreated = new FEvent<bool>();   //创建公会成功

    public static FEvent<EUICareAboutMoneyType[]> OnMoneyTypeChange = new FEvent<EUICareAboutMoneyType[]>();   //货币栏显示变化

    public static FEvent<int,int> ScreenResolutionEvt = new FEvent<int,int>();   //分辨率变化适配
    
    public static FEvent OnGameOver = new FEvent();//游戏失败
    
    public static FEvent<InputEvent> OnTouchBegin = new FEvent<InputEvent>();
    public static FEvent<InputEvent> OnTouchMove = new FEvent<InputEvent>();
    public static FEvent<InputEvent> OnTouchEnd = new FEvent<InputEvent>();
    
    public static FEvent<InputEvent> OnClick = new FEvent<InputEvent>();//点击
    
    public static FEvent<InputEvent> OnRightClick = new FEvent<InputEvent>();//右键点击

}
