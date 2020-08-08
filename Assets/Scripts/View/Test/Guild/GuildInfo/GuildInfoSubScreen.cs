using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class GuildInfoSubScreen : SubScreenBase
{
    GuildInfoSubCtrl mCtrl;// 创建公会子控件


    protected override void OnInit()
    {
        mCtrl = _uictrl as GuildInfoSubCtrl;
        mCtrl.btnClose.onClick.AddListener(OnCloseClick);
        mCtrl.btnJumpTask.onClick.AddListener(OnOpenTaskClick);
    }

    void OnCloseClick()
    {
//        GameUIManager.GetInstance().CloseUI(typeof(GuildScreen));
    }

    void OnOpenTaskClick()
    {
//        GameUIManager.GetInstance().OpenUI(typeof(TaskScreen));
    }

    public GuildInfoSubScreen(UISubCtrlBase ctrlBase, UIOpenScreenParameterBase param = null) : base(ctrlBase, param)
    {
    }
}
