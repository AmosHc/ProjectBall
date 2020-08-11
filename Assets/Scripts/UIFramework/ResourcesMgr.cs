using System;
using UnityEngine;
using UnityEditor;
using XLua;

[CSharpCallLua]
public class ResourcesMgr : MonoSingleton<ResourcesMgr>
{
    [HideInInspector]
    public Canvas ctrlCanvas;

//    public void LoadAsset(string address,Action<GameObject> action)
//    {
//        var go = Resources.Load<GameObject>(address);
//        if (action != null)
//        {
//            action?.Invoke(go);
//        }
//    }

    public void LoadAsset<T>(string address,Action<T> action) where T : UnityEngine.Object
    {
        var go = Resources.Load<T>(address);
        if (action != null)
        {
            action?.Invoke(go);
        }
    }
}