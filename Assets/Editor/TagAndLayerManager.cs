using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;
using System;
using table;

#if UNITY_EDITOR
public class TagAndLayerManager 
{
    #region SortingLayer
    [MenuItem("GameTools/TagAndLayer管理器/SortingLayer")]
    public static void AddSortingLayer()
    {
        // 先遍历枚举拿到枚举的字符串
        List<string> lstSceenPriority = new List<string>();
        foreach(int v in Enum.GetValues(typeof(ESceenPriority)))
        {
            lstSceenPriority.Add(Enum.GetName(typeof(ESceenPriority),v));
        }

        // 清除数据
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
        if (tagManager == null)
        {
            Debug.LogError("未能序列化tagManager！！！！！！");
            return;
        }
        SerializedProperty it = tagManager.GetIterator();
        while (it.NextVisible(true))
        {
            if (it.name != "m_SortingLayers")
            {
                continue;
            }
            // 先删除所有
            while(it.arraySize > 0)
            {
                it.DeleteArrayElementAtIndex(0);
            }

            // 重新插入
            // 将枚举字符串生成到 sortingLayer
            foreach (var s in lstSceenPriority)
            {
                it.InsertArrayElementAtIndex(it.arraySize);
                SerializedProperty dataPoint = it.GetArrayElementAtIndex(it.arraySize - 1);

                while (dataPoint.NextVisible(true))
                {
                    if (dataPoint.name == "name")
                    {
                        dataPoint.stringValue = s;
                    }
                    else if(dataPoint.name == "uniqueID")
                    {
                        dataPoint.intValue = (int)Enum.Parse(typeof(ESceenPriority),s);
                    }
                }
            }
        }
        tagManager.ApplyModifiedProperties();
        AssetDatabase.SaveAssets();
    }

    #endregion

    [MenuItem("GameTools/TagAndLayer管理器/GamePlayLayer")]
    public static void AddGamePlayLayer()
    {
        List<string> enumsStrList = GetEnumsStrList(typeof(EUnitClassType));

        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset"));
        if (tagManager == null)
        {
            Debug.LogError("未能序列化tagManager！！！！！！");
            return;
        }
        SerializedProperty it = tagManager.GetIterator();
        while (it.NextVisible(true))
        {
            if(it.name.Equals("layers"))
            {
                //前面8层是unity系统使用的层，所以要先过滤掉，因为下标3 6 7是空的，不过滤，会造成层设置成功，但却设置到unity系统使用的层之中，而不能使用。
                AddLayerEnums(it, 8 , enumsStrList, typeof(EUnitClassType));
            }
        }
        tagManager.ApplyModifiedProperties();
        AssetDatabase.SaveAssets();
    }

    public static void AddLayerEnums(SerializedProperty it, int idx, List<string> enumsStrList, Type enumType)
    {
        for (int i = 0; i < enumsStrList.Count; i++)
        {
            SerializedProperty dataPoint = it.GetArrayElementAtIndex(idx + i);
            if(string.IsNullOrEmpty(dataPoint.stringValue))
            {
                dataPoint.stringValue = enumsStrList[i];
            }
        }
    }

    public static List<string> GetEnumsStrList(Type enumType)
    {
        List<string> lstSceenPriority = new List<string>();
        foreach(int v in Enum.GetValues(enumType))
        {
            lstSceenPriority.Add(Enum.GetName(enumType,v));
        }

        return lstSceenPriority;
    }

    [MenuItem("GameTools/TagAndLayer管理器/ClearLayers")]
    public static void ClearLayers()
    {
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
        if (tagManager == null)
        {
            Debug.LogError("未能序列化tagManager！！！！！！");
            return;
        }
        SerializedProperty it = tagManager.GetIterator();
        while(it.arraySize > 0)
        {
            it.DeleteArrayElementAtIndex(0);
        }
        tagManager.ApplyModifiedProperties();
        AssetDatabase.SaveAssets();
    }
    
    public static bool IsHaveSortingLayer(string sortingLayer)
    {
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/Tagmanager.asset")[0]);
        if(tagManager == null)
        {
            Debug.LogError("未能序列化tagManager！！！！！！ IsHaveSortingLayer");
            return true;
        }
        SerializedProperty it = tagManager.GetIterator();
        while(it.NextVisible(true))
        {
            if(it.name != "m_SortingLayers")
            {
                continue;
            }
            for (int i = 0; i < it.arraySize; i++)
            {
                SerializedProperty dataPoint = it.GetArrayElementAtIndex(i);
                while(dataPoint.NextVisible(true))
                {
                    if(dataPoint.name != "name")
                    {
                        continue;
                    }
                    if(dataPoint.stringValue == sortingLayer)
                    {
                        return true;
                    }
                }
            }
        }


        return false;
    }



}
#endif
