using System.Collections.Generic;
using UIFramework.ScreenBase;
using UnityEngine;

public class ScreenBase : UIBase
{
    private GameObject _panelRoot = null;
    private string _uiName = "";
    private string _uiRes = "";
    private int _openOrder = 0;// 界面打开顺序
    private int _sortingLayer = 0;// 界面层级

    private List<SubScreenBase> _allSubScreens;
    
    protected UICtrlBase _uiCtrl;
    
    // 界面打开的传入参数
    protected UIOpenScreenParameterBase _selfParam;

    public UICtrlBase CtrlBase { get => _uiCtrl;}

    public ScreenBase(string uiRes, string UIName, UIOpenScreenParameterBase param = null)
    {
        _uiRes = uiRes;
        _uiName = UIName;
        _selfParam = param;
        _allSubScreens = new List<SubScreenBase>();
        
        InitBtnListenerTabs();
        StartLoad();
    }

    public void StartLoad()
    {
        ResourcesMgr.GetInstance().LoadAsset<GameObject>(_uiRes, PanelLoadComplete);
    }

    // 资源加载完成
    void PanelLoadComplete(GameObject ao)
    {
        if (ao == null)
        {
            Debug.LogError("ScreenBase load Prefab fail, uiRes:" + _uiRes);
            return;
        }
        _panelRoot = Object.Instantiate(ao, GameUIManager.GetInstance().GetUIRootTransform());
        // 获取控件对象
        _uiCtrl = _panelRoot.GetComponent<UICtrlBase>();

        // 更新层级信息
        UpdateLayoutLevel();

        // 调用加载成功方法
        OnLoadSuccess();

        // 添加到控制层
        GameUIManager.GetInstance().AddUI(this);

    }
    
    // 界面初始化完成
    protected virtual void OnLoadSuccess()
    {
        OnCreate();
        // 注册适配监听事件
        _uiCtrl.AutoRelease(EventManager.ScreenResolutionEvt.Subscribe(UIAdapt));

        if (_uiCtrl.mUseMask || _uiCtrl.mIsPopup || _uiCtrl.mIsModelWindow)
            MaskScreenManager.GetInstance().Show(this,_uiCtrl);
    }

    // 更新UI的层级
    private void UpdateLayoutLevel()
    {
        var camera = GameUIManager.GetInstance().GetUICamera();
        if (camera != null)
        {
            _uiCtrl.ctrlCanvas.worldCamera = camera;
        }

        _uiCtrl.ctrlCanvas.pixelPerfect = true;
        _uiCtrl.ctrlCanvas.overrideSorting = true;
        _sortingLayer = (int)_uiCtrl.screenPriority;
        _uiCtrl.ctrlCanvas.sortingLayerID = _sortingLayer;
        _uiCtrl.ctrlCanvas.sortingOrder = _openOrder;
    }

    public void Show()
    {
        BindAction();
        OnShow();
    }
    
    public void Close()
    {
        UnBindAction();
        OnClose();
        GameUIManager.GetInstance().RemoveUI(this);
    }

    /// <summary>
    /// 界面打开的时候会根据选项自动给界面加上背景遮罩层，点击遮罩层传递的事件 可重写
    /// </summary>
    public virtual void OnClickMaskArea()
    {
        Close();
    }

    // 设置渲染顺序
    public void SetOpenOrder(int openOrder)
    {
        _openOrder = openOrder;
        if (_uiCtrl != null && _uiCtrl.ctrlCanvas != null)
        {
            _uiCtrl.ctrlCanvas.sortingOrder = openOrder;
        }
    }
    
    protected void RegisterSubScreen(SubScreenBase subScreenInst)
    {
        if (_allSubScreens == null)
        {
            Debug.LogError("ScreenBase已被释放，不可添加subScreenInst");
        }

        if (subScreenInst != null)
        {
            if(!_allSubScreens.Contains(subScreenInst))
                _allSubScreens.Add(subScreenInst);
        }
    }

    public void DisposeSunScreens()
    {
        if (_allSubScreens == null) 
            return;
        foreach (SubScreenBase inst in _allSubScreens)
        {
            inst.Dispose();
        }

        _allSubScreens = null;
    }
    
    public void Dispose()
    {
        DisposeSunScreens();
        OnDispose();
        GameObject.Destroy(_panelRoot);
    }

    public GameObject PanelRoot
    {
        get => _panelRoot;
        set => _panelRoot = value;
    }

    public string UiName
    {
        get => _uiName;
        set => _uiName = value;
    }

    public string UiRes
    {
        get => _uiRes;
        set => _uiRes = value;
    }

    public int OpenOrder
    {
        get => _openOrder;
        set => _openOrder = value;
    }

    public int SortingLayer
    {
        get => _sortingLayer;
        set => _sortingLayer = value;
    }

    public UIOpenScreenParameterBase SelfParam
    {
        get => _selfParam;
        set => _selfParam = value;
    }

    #region ---------- ScreenBase子类接口 所有公开接口,请勿自行添加与修改 ---------

    public virtual void OnCreate()
    {
        
    }

    public virtual void BindAction()
    {
        
    }

    public virtual void UnBindAction()
    {
        
    }

    public virtual void OnShow()
    {
        
    }

    public virtual void OnClose()
    {
        
    }

    public virtual void OnDispose()
    {
        
    }

    
    protected virtual void UIAdapt(int width, int height)
    {

    }

    #endregion


}
