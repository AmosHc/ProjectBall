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

        /// <summary>
        /// 通用刷新列表
        /// </summary>
        /// <param name="root">根节点</param>
        /// <param name="child">刷新项</param>
        /// <param name="datas">刷新数据</param>
        /// <param name="rendererHandler">回调</param>
        /// <typeparam name="T"></typeparam>
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

        public static T GetOrAddComponent<T>(GameObject obj) where T : Component
        {
            T component = obj.GetComponent<T>();
            if (component == null)
                component = obj.AddComponent<T>();
            return component;
        }
        
    }
}