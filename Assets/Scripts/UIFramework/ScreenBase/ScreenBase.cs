﻿using UnityEngine;

public class ScreenBase
{
    public GameObject _panelRoot = null;
    public string _strUIName = "";
    protected UICtrlBase _ctrlBase;

    public int _openOrder = 0;// 界面打开顺序
    public int _sortingLayer = 0;// 界面层级


    // 界面打开的传入参数
    protected UIOpenScreenParameterBase mOpenParam;

    public UICtrlBase CtrlBase { get => _ctrlBase;}

    public ScreenBase(string UIName, UIOpenScreenParameterBase param = null)
    {
        StartLoad(UIName, param);
    }

    public virtual void StartLoad(string UIName, UIOpenScreenParameterBase param = null)
    {
        _strUIName = UIName;
        mOpenParam = param;
        ResourcesMgr.GetInstance().LoadAsset<GameObject>(UIName, PanelLoadComplete);
    }

    // 资源加载完成
    void PanelLoadComplete(GameObject ao)
    {
        _panelRoot = Object.Instantiate(ao, GameUIManager.GetInstance().GetUIRootTransform());
        // 获取控件对象
        _ctrlBase = _panelRoot.GetComponent<UICtrlBase>();

        // 更新层级信息
        UpdateLayoutLevel();

        // 调用加载成功方法
        OnLoadSuccess();

        // 添加到控制层
        GameUIManager.GetInstance().AddUI(this);

    }
    // 脚本处理完成
    virtual protected void OnLoadSuccess()
    {
        // 注册适配监听事件
        _ctrlBase.AutoRelease(EventManager.ScreenResolutionEvt.Subscribe(UIAdapt));

        if (_ctrlBase.mUseMask)
            MaskScreenManager.GetInstance().Show(this);
    }

    virtual protected void UIAdapt(Vector2Int res)
    {

    }

    virtual public void OnClose()
    {
        GameUIManager.GetInstance().RemoveUI(this);
    }

    /// <summary>
    /// 界面打开的时候会根据选项自动给界面加上背景遮罩层，点击遮罩层传递的事件 可重写
    /// </summary>
    virtual public void OnClickMaskArea()
    {
        OnClose();
    }

    // 设置渲染顺序
    public void SetOpenOrder(int openOrder)
    {
        _openOrder = openOrder;
        if (_ctrlBase != null && _ctrlBase.ctrlCanvas != null)
        {
            _ctrlBase.ctrlCanvas.sortingOrder = openOrder;
        }
    }

    // 更新UI的层级
    private void UpdateLayoutLevel()
    {
        var camera = GameUIManager.GetInstance().GetUICamera();
        if (camera != null)
        {
            _ctrlBase.ctrlCanvas.worldCamera = camera;
        }

        _ctrlBase.ctrlCanvas.pixelPerfect = true;
        _ctrlBase.ctrlCanvas.overrideSorting = true;
        _ctrlBase.ctrlCanvas.sortingLayerID = (int)_ctrlBase.sceenPriority;
        _sortingLayer = (int)_ctrlBase.sceenPriority;
        _ctrlBase.ctrlCanvas.sortingOrder = _openOrder;
    }

    virtual public void Dispose()
    {
        GameObject.Destroy(_panelRoot);
    }





}
