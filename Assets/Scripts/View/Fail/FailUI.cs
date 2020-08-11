using UnityEngine;

public class FailUI : ScreenBase
{
    private FailCtrl _ctrl;
    private LevelInfoParam _config;
    
    public FailUI(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
    {
        
    }

    public override void OnCreate()
    {
        _ctrl = _uiCtrl as FailCtrl;
    }

    public override void BindAction()
    {
        AddOnClickListener(_ctrl.btnContinue, OnClose);
        AddOnClickListener(_ctrl.btnReset,OnResetGame);
    }

    public override void OnShow()
    {
        _config = _selfParam as LevelInfoParam;
//        _config.LevelsCfg.LevelID;
    }

    private void OnResetGame()
    {
        //TODO 通过关卡管理器，重置整个关卡状态：1.清楚所有动态机关   2.按配置加载静态机关  3.重新生成ball和endpoint
        //_config
        Debug.Log("我他妈的重置任务ok？");
    }
}
