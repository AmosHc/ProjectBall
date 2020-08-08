using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class GuildCreateSubScreen : SubScreenBase
{
    GuildCreateSubCtrl mCtrl;// 创建公会子控件


    protected override void OnInit()
    {
        mCtrl = _uictrl as GuildCreateSubCtrl;

        mCtrl.btnCreate.onClick.AddListener(OnCreateClick);
        mCtrl.btnClose.onClick.AddListener(OnCloseClick);
    }

    void OnCreateClick()
    {
        PlayerData.GetInstance().SetHaveGuild(true);
    }

    void OnCloseClick()
    {
        GameUIManager.GetInstance().CloseUI(typeof(GuildScreen));
    }

    public GuildCreateSubScreen(UISubCtrlBase ctrlBase, UIOpenScreenParameterBase param = null) : base(ctrlBase, param)
    {
    }
}
