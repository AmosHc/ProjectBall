using System;
using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Utility
{
    public class CommonUtility
    {
        public static double Fmod(double x, double y)
        {
            return x - (int)(x / y) * y;
        }

        public static void RefreshList<T>(Transform root,GameObject child,List<T> datas,Action<int,Transform,T> rendererHandler)
        {
            int cnt = datas.Count;
            int oldCnt = root.childCount;
            for (int i = oldCnt - 1; i >= 0; i--)
            {
                Transform item = root.GetChild(i);
                if (i > cnt)
                {
                    Object.Destroy(item.gameObject);
                }
                else if(rendererHandler != null)
                {
                    rendererHandler(i, item, datas[i]);
                }
            }

            for (int i = oldCnt; i < cnt; i++)
            {
                GameObject item = Object.Instantiate(child, root);

                if (rendererHandler != null)
                {
                    rendererHandler(i, item.transform, datas[i]);
                }
            }
        }
    }
}