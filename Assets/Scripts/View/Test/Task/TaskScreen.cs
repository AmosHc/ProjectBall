using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskScreen : ScreenBase
{
    TaskCtrl mCtrl;

    public TaskScreen(string uiRes, string UIName, UIOpenScreenParameterBase param = null) : base(uiRes, UIName, param)
    {
    }

    protected override void OnLoadSuccess()
    {
        base.OnLoadSuccess();
        mCtrl = _uiCtrl as TaskCtrl;

        mCtrl.btnClose.onClick.AddListener (OnCloseClick);
    }

    void OnCloseClick()
    {
        Close();
    }



}
