using UIFramework.ScreenBase;

public class SubScreenBase : UIBase
{
    protected UISubCtrlBase _uictrl;
    protected UIOpenScreenParameterBase _selfParam;

    public UISubCtrlBase CtrlBase { get { return _uictrl; } }

    public SubScreenBase(UISubCtrlBase ctrlBase,UIOpenScreenParameterBase param = null)
    {
        _uictrl = ctrlBase;
        _selfParam = param;
        InitBtnListenerTabs();
        OnInit();
        BindAction();
        OnShow();
    }

    public void Dispose()
    {
        UnBindListenerAction();
        UnBindAction();
        OnDispose();
    }
    
    /// <summary>
    /// -----------------子页面复写方法-----------------
    /// </summary>
    protected virtual void OnInit()
    {

    }

    protected virtual void BindAction()
    {

    }

    protected virtual void OnShow()
    {
        
    }
    
    protected virtual void UnBindAction()
    {

    }
    
    protected virtual void OnDispose()
    {

    }
}
