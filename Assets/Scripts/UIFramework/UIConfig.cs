
using System;
using System.Collections.Generic;
using Microsoft.Win32;
using ProjectBall.View;

public class UIConfigItem
{
    string _uiName;
    string _uiResPath;
    private Type _uiType;

    public string UiName
    {
        get => _uiName;
        set => _uiName = value;
    }

    public string UiResPath
    {
        get => _uiResPath;
        set => _uiResPath = value;
    }

    public Type UiType
    {
        get => _uiType;
        set => _uiType = value;
    }
    
    public UIConfigItem( string uiResPath, string uiName, Type type)
    {
        _uiResPath = uiResPath;
        _uiName = uiName;
        _uiType = type;
    }
}
public class UIConfig
{
//    public const string UIMainCity = "MainCity"; // 主城
//    public const string UIGuild = "Guild"; // 公会
//    public const string UITask = "Task"; // 任务
//    public const string UIMoney = "Money"; // 货币
    public static UIConfigItem Welcome = new UIConfigItem("Welcome","WelcomeUI",typeof(WelcomeUI)); //欢迎页
    public static UIConfigItem MainMenu = new UIConfigItem("MainMenu","MainMenuUI",typeof(MainMenuUI)); //主菜单
    public static UIConfigItem ThemeChooser = new UIConfigItem("ThemeChooser","ThemeChooserUI",typeof(ThemeChooserUI)); //一级选关
    public static UIConfigItem SelectLevelUI = new UIConfigItem("SelectLevel/SelectLevel","SelectLevelUI",typeof(SelectLevelUI)); //二级选关
    public static UIConfigItem GameUI = new UIConfigItem("Game/Game","GameUI",typeof(GameUI)); //游戏
}