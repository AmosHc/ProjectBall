using System;
using UnityEngine;
using UnityEditor;
using XLua;

[CSharpCallLua]
public class ResourcesMgr : MonoSingleton<ResourcesMgr>
{
    [HideInInspector]
    public Canvas ctrlCanvas;

    public void LoadAsset(string address,Action<GameObject> action)
    {
        var go = Resources.Load<GameObject>(address);
        if (action != null)
        {
            action?.Invoke(go);
        }
    }


}