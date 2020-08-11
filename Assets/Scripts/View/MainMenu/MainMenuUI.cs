using UnityEngine;

public class MainMenuUI : ScreenBase
{
    public MainMenuUI(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
    {
    }

    public override void BindAction()
    {
        MainMenuCtrl uiCtrl = _uiCtrl as MainMenuCtrl;
            
        AddOnClickListener(uiCtrl.btnThemeChooser, OnOpenThemeChooserClick);
        AddOnClickListener(uiCtrl.btnSetting, OnOpenSettingClick);
        AddOnClickListener(uiCtrl.btnCreativeWorkshop, OnOpenCreativeWorkshopClick);
    }

    private void OnOpenThemeChooserClick()
    {
        GameUIManager.GetInstance().OpenUI(UIConfig.ThemeChooser);
    }

    private void OnOpenSettingClick()
    {
        Debug.Log("--跳设置");
    }

    private void OnOpenCreativeWorkshopClick()
    {
        Debug.Log("--跳创意工坊");
    }
}