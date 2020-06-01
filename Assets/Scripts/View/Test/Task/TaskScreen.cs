using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskScreen : ScreenBase
{
    TaskCtrl mCtrl;

    public TaskScreen(UIOpenScreenParameterBase param = null) : base(UIConst.UITask, param)
    {
        
    }

    protected override void OnLoadSuccess()
    {
        base.OnLoadSuccess();
        mCtrl = _ctrlBase as TaskCtrl;

        mCtrl.btnClose.onClick.AddListener (OnCloseClick);
    }

    void OnCloseClick()
    {
        OnClose();
    }



}
