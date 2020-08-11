public class WelcomeUI : ScreenBase
{
    public WelcomeUI(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
    {
    }
        
    public override void BindAction()
    {
        WelcomeCtrl uiCtrl = _uiCtrl as WelcomeCtrl;
        AddOnClickListener(uiCtrl.btnTouchArea, OnOpenMainMenuClick);
    }
        
    private void OnOpenMainMenuClick()
    {
        GameUIManager.GetInstance().OpenUI(UIConfig.MainMenu);
        Close();
    }
}