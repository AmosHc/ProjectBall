using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using UnityEngine;
using XLua;

public class GameUIManager : MonoSingleton<GameUIManager>
{
    public GameObject uiRoot;
    public GameObject poolRoot // 缓存节点
    {
        get;
        private set;
    }

    // UI列表缓存
    static Dictionary<Type, ScreenBase> _typeScreens = new Dictionary<Type, ScreenBase>();

    public int _uiOpenOrder = 0;// UI打开时的Order值 用来标识界面层级顺序
    // uicamera
    Camera uiCamera;
    public Camera UiCamera { get => uiCamera; }
    
    // 处理最上层的界面逻辑
    List<ScreenBase> _sortTemp = new List<ScreenBase>();

    // 预制分辨率
    static Vector2Int ScreenResolution = new Vector2Int(1136,640);
    void Update()
    {
        if (ScreenResolution.x != Screen.width || ScreenResolution.y != Screen.height)
        {
            ScreenResolution = new Vector2Int(Screen.width, Screen.height);
            EventManager.ScreenResolutionEvt.BroadCastEvent(ScreenResolution.x,ScreenResolution.y);
        }
    }


    protected override void Init()
    {
        // 初始化UI根节点
        uiRoot = Instantiate(Resources.Load<GameObject>("UIRoot"), transform);
        uiCamera = uiRoot.GetComponent<Canvas>().worldCamera;

        // 初始化UI缓存池
        poolRoot = new GameObject("UIPoolRoot");
        poolRoot.transform.SetParent(transform);

        Canvas canvas = poolRoot.AddComponent<Canvas>();
        canvas.enabled = false;
    }

    /// <summary>
    ///  UI打开入口没有判断条件直接打开
    /// </summary>
	public ScreenBase OpenUI(Type type, UIOpenScreenParameterBase param = null)
    {
        ScreenBase sb = GetUI(type);
        _uiOpenOrder++;

        // 如果已有界面,则不执行任何操作
        if (sb != null)
        {
            if (sb.CtrlBase != null && !sb.CtrlBase.ctrlCanvas.enabled)
            {
                sb.CtrlBase.ctrlCanvas.enabled = true;
            }
            sb.OnShow();
            // 处理最上层界面
            if (sb.CtrlBase.mHideOtherScreenWhenThisOnTop)
            {
                ProcessUIOnTop();
            }
            // 处理货币栏变化
            ChangeMoneyType();

            return sb;
        }
        sb = (ScreenBase)Activator.CreateInstance(type, param);
        sb.OnShow();

        _typeScreens.Add(type, sb);
        sb.SetOpenOrder(_uiOpenOrder); // 设置打开序号

        // 处理最上层界面
        if (sb.CtrlBase.mHideOtherScreenWhenThisOnTop)
        {
            ProcessUIOnTop();
        }

        // 处理货币栏变化
        ChangeMoneyType();

        return sb;
    }

    /// <summary>
    /// UI外部调用的获取接口
    /// </summary>
    public ScreenBase GetUI(Type type)
    {
        if (!typeof(ScreenBase).IsAssignableFrom(type)) return default;
        ScreenBase sb = null;
        if (_typeScreens.TryGetValue(type, out sb))
            return sb;
        return null;
    }

    /// <summary>
    /// UI外部调用的获取接口
    /// </summary>
    public TScreen GetUI<TScreen>() where TScreen : ScreenBase
    {
        Type type = typeof(TScreen);

        ScreenBase sb = null;

        if (_typeScreens.TryGetValue(type, out sb))
        {
            return (TScreen)sb;
        }
            
        return null;
    }

    /// <summary>
    /// UI外部调用的关闭接口
    /// </summary>
    public bool CloseUI(Type type)
    {
        ScreenBase sb = GetUI(type);
        if (sb != null)
        {
            if (type == typeof(ScreenBase))     // 标尺界面是测试界面 不用关闭
                return false;
            else
                sb.OnClose();
            return true;
        }
        return false;
    }

    public void CloseAllUI()
    {
        // 销毁会从容器中删除 不能用正常遍历方式
        List<Type> keys = new List<Type>(_typeScreens.Keys);
        foreach (var k in keys)
        {
            if (k == typeof(ScreenBase))// 标尺界面是测试界面 不用关闭
            {
                continue;
            }
            if (_typeScreens.ContainsKey(k))
                _typeScreens[k].OnClose();
        }
    }

    /// <summary>
    /// UI创建时候自动处理的UI打开处理 一般不要手动调用
    /// </summary>
    public void AddUI(ScreenBase sBase)
    {
        sBase._panelRoot.transform.SetParent(GetUIRootTransform());

        sBase._panelRoot.transform.localPosition = Vector3.zero;
        sBase._panelRoot.transform.localScale = Vector3.one;
        sBase._panelRoot.transform.localRotation = Quaternion.identity;
        sBase._panelRoot.name = sBase._panelRoot.name.Replace("(Clone)", "");

        //// 处理最上层界面 如果是异步加载界面建议逻辑写在这里
        //if (sBase.CtrlBase.mHideOtherScreenWhenThisOnTop)
        //{
        //    ProcessUIOnTop();
        //}
    }

    /// <summary>
    /// UI移除时候自动处理的接口 一般不要手动调用
    /// </summary>
    public void RemoveUI(ScreenBase sBase)
    {
        if (_typeScreens.ContainsKey(sBase.GetType()))  // 根据具体需求决定到底是直接销毁还是缓存
            _typeScreens.Remove(sBase.GetType());
        sBase.Dispose();

        // 处理最上层界面
        if (sBase.CtrlBase.mHideOtherScreenWhenThisOnTop)
        {
            ProcessUIOnTop();
        }

        // 处理货币栏变化
        ChangeMoneyType();
    }

    void ProcessUIOnTop()
    {
        this.SortUIOrder();
        // 先找到第一个控制的UI层
        int index = 0;

        for (int i = 0; i < _sortTemp.Count; i++)
        {
            var tempC = _sortTemp[i];
            if (tempC.CtrlBase.mHideOtherScreenWhenThisOnTop)
            {
                tempC.CtrlBase.ctrlCanvas.enabled = true;
                index = i;// 因为是一个有序的List 所以找到第一个需要控制的界面之后记录序号，然后从它接着遍历即可
                break;
            }
        }

        // 如果没有找到 可能的情况是就是关闭了最上层界面 所以现在最上层的应该是空的
        if (index == 0)
        {
            for (int i = 0; i < _sortTemp.Count; i++)
            {
                var tempC = _sortTemp[i];
                // 找到第一个需要被隐藏的界面 隐藏就好
                if (!tempC.CtrlBase.ctrlCanvas.enabled)
                {
                    tempC.CtrlBase.ctrlCanvas.enabled = true;
                    index = i;// 因为是一个有序的List 所以找到第一个需要控制的界面之后记录序号，然后从它接着遍历即可
                    break;
                }
            }
        }

        // 找到下面需要隐藏的 
        for (int i = index + 1; i < _sortTemp.Count; i++)
        {
            var tempC = _sortTemp[i];
            if (!tempC.CtrlBase.mAlwaysShow)
            {
                // 找到需要被隐藏的界面 隐藏就好
                tempC.CtrlBase.ctrlCanvas.enabled = false;
            }
        }
    }

    void ChangeMoneyType()
    {
        this.SortUIOrder();
        // 找到第一个关心货币栏的
        for (int i = 0; i < _sortTemp.Count; i++)
        {
            if (_sortTemp[i].CtrlBase.mBCareAboutMoney)
            {
                EventManager.OnMoneyTypeChange.BroadCastEvent(_sortTemp[i].CtrlBase.MoneyType);
                break;
            }
        }
    }

    private void SortUIOrder()
    {
        _sortTemp.Clear();
        foreach (var s in _typeScreens.Values)
        {
            _sortTemp.Add(s);
        }
        // 排序 按照层级高->低的顺序
        _sortTemp.Sort(
            (a, b) =>
            {
                if (a._sortingLayer == b._sortingLayer)
                {
                    return b._openOrder.CompareTo(a._openOrder);
                }
                return b._sortingLayer.CompareTo(a._sortingLayer);
            });
    }
    
    
    //返回登陆界面时，重置常驻UI的状态
    public void Reset()
    {

    }


    #region 通用API
    //获取UIRoot节点
    public Transform GetUIRootTransform()
    {
        return transform;
    }

    public Camera GetUICamera()
    {
        return uiCamera;
    }
    #endregion
}