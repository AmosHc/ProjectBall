//using System;
using UnityEngine;
using UnityEngine.UI;

public class MaskScreenManager
{
    private bool _isPopup = false;
    private bool _isModel = false;
    private bool _useMask = false;
    private Color32 _glayColor = new Color32(10,10,10,150);
    private Color32 _lucencyColor = new Color32(1,1,1,0);
    
    protected static MaskScreenManager instance;
    public static MaskScreenManager GetInstance()
    {
        if (instance == null)
        {
            instance = new MaskScreenManager();
        }
        return instance;
    }

    GameObject goAutoMask;
    /// <summary>
    /// 打开遮罩面板
    /// </summary>
    /// <param name="screen">遮罩所需的参数,会根据param来设置关联的页面</param>
    public void Show(ScreenBase screen,UICtrlBase ctrl)
    {
        _isPopup = ctrl.mIsPopup;
        _isModel = ctrl.mIsModelWindow;
        _useMask = ctrl.mUseMask;
        if (goAutoMask == null)
        {
            ResourcesMgr.GetInstance().LoadAsset<GameObject>("UGUI/UIAutoMask", (ao) => {
                goAutoMask = ao;
                AttachEvent(screen);
            });
        }
        else
        {
            AttachEvent(screen);
        }
    }

    void AttachEvent(ScreenBase screen)
    {
        // 以防界面当帧打开后又立即关闭,导致screen为null报错
        if (screen == null || screen.CtrlBase == null) return;
        var go = Object.Instantiate(goAutoMask, screen.PanelRoot.transform);
        go.transform.SetAsFirstSibling();
        go.name = "UIAutoMask_Created by Mask ScreenManager";
        Button btnMask = go.GetComponent<Button>();
        Image imgMask = go.GetComponent<Image>();
        if (btnMask != null && _isPopup)
        {
            btnMask.onClick.AddListener(screen.OnClickMaskArea);
        }

        if (imgMask != null )
        {
            imgMask.color = _useMask ? _glayColor : _lucencyColor;
        }
    }
}