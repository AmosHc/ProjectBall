using table;

public class LevelInfoParam : UIOpenScreenParameterBase
{
    private LevelsDefine _levelsCfg;

    public LevelsDefine LevelsCfg
    {
        get => _levelsCfg;
        set => _levelsCfg = value;
    }
}
public class GameUI : ScreenBase
{
    private GameEditorSubUI _subEditor;
    private GameRunSubUI _subRun;
    private GameCtrl _ctrl;
        
    public GameUI(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
    {
    }

    public override void OnCreate()
    {
        _ctrl = _uiCtrl as GameCtrl;
    }

    public override void BindAction()
    {
        _ctrl.AutoRelease(EventManager.OnGameOver.Subscribe(OnGameOver));
        _ctrl.AutoRelease(EventManager.OnGameOver.Subscribe(OnGameOver));
    }

    public override void OnShow()
    {
        LevelsDefine levelCfg = ((LevelInfoParam) _selfParam).LevelsCfg;
        bool isRunning = false;
        //第一次打开就是编辑窗口
        _ctrl.subEditor.gameObject.SetActive(!isRunning);
        _ctrl.subRun.gameObject.SetActive(isRunning);
        //处理子界面逻辑初始化
        if (isRunning)
        {
            _subRun = new GameRunSubUI(_ctrl.subRun);
            RegisterSubScreen(_subRun);
        }
        else
        {
            _subEditor = new GameEditorSubUI(_ctrl.subEditor, _selfParam);
            RegisterSubScreen(_subEditor);
        }
    }

    private void OnGameOver()
    {
        GameUIManager.GetInstance().OpenUI(UIConfig.FailUI, _selfParam);
    }
}