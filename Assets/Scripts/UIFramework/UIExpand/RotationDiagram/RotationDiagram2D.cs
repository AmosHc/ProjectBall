using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 2D仿3D轮播图
/// </summary>
public class RotationDiagram2D : MonoBehaviour
{
    public Vector2 itemSize = Vector2.zero;
    public List<Sprite> itemSprites = new List<Sprite>();
    public float offset;
    public float scaleFactorMax;
    public float scaleFactorMin;
    
    private List<RotationDiagramItem> _diagramItems;
    private List<ItemPosData> _posDatas;
    
    void Start()
    {
        _diagramItems = new List<RotationDiagramItem>();
        _posDatas = new List<ItemPosData>();
        CreateItems();
        CalculateData();
    }

    private GameObject CreateTemplate()
    {
        GameObject templateObj = new GameObject("Template");
        templateObj.AddComponent<RectTransform>().sizeDelta = itemSize;
        templateObj.AddComponent<Image>();
        templateObj.AddComponent<RotationDiagramItem>();
        return templateObj;
    }

    private void CreateItems()
    {
        GameObject template = CreateTemplate();
        for (int i = 0; i < itemSprites.Count; i++)
        {
            RotationDiagramItem item = Instantiate(template).GetComponent<RotationDiagramItem>();
            item.SetParent(transform);
            item.SetSprite(itemSprites[i]);
            _diagramItems.Add(item);
        }
        Destroy(template);
    }

    private float GetPosX(float ratio, float length)
    {
        if (ratio < 0 || ratio > 1)
        {
            Debug.LogError("当前比例必须是0-1");
            return 0;
        }

        if (ratio <= 0.25)
        {
            return length * ratio;
        }
        else if(ratio > 0.25 && ratio <= 0.75)
        {
            return length * (0.5f - ratio);
        }
        else
        {
            return length * (ratio - 1);
        }
    }

    private float GetScaleFactor(float ratio, float max, float min)
    {
        if (ratio < 0 || ratio > 1)
        {
            Debug.LogError("当前比例必须是0-1");
            return 0;
        }

        float scaleOffset = (max - min) / 0.5f;

        if (ratio <= 0.5)
        {
            return max - scaleOffset * ratio;
        }
        else
        {
            return max - scaleOffset * (1 - ratio);
        }
    }

    private void CalculateData()
    {
        float length = (itemSize.x + offset) * _diagramItems.Count;//圆弧总长度
        float ratioOffsets = 1 / (float)_diagramItems.Count;//每个item的等分缩放比例
        float ratio = 0;
        for (int i = 0; i < _diagramItems.Count; i++)
        {
            ItemPosData posData = new ItemPosData();
            posData.X = GetPosX(ratio, length);
            posData.ScaleFactor = GetScaleFactor(ratio, scaleFactorMax, scaleFactorMin);
            _diagramItems[i].SetPosData(posData);
            _posDatas.Add(posData);
            ratio += ratioOffsets;
        }
    }
}

public struct ItemPosData
{
    public float X;
    public float ScaleFactor;
}
