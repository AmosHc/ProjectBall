using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Security;
using UnityEngine;
using UnityEngine.EventSystems;
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
    private List<int> _sortItemIds;
    
    void Start()
    {
        _diagramItems = new List<RotationDiagramItem>();
        _posDatas = new List<ItemPosData>();
        _sortItemIds = new List<int>();
        
        CreateItems();
        CalculateData();
        SetItemDatas();
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
            _sortItemIds.Add(i);
            AddItemPosDate(ratio, length);
            _diagramItems[i].PosId = i;
            ratio += ratioOffsets;
        }
        _sortItemIds = _sortItemIds.OrderBy((i => _posDatas[i].ScaleFactor)).ToList();
        for (int i = 0; i < _sortItemIds.Count; i++)
        {
            _posDatas[_sortItemIds[i]].Order = i;
        }
    }

    private ItemPosData AddItemPosDate(float ratio, float length)
    {
        ItemPosData posData = new ItemPosData();
        posData.X = GetPosX(ratio, length);
        posData.ScaleFactor = GetScaleFactor(ratio, scaleFactorMax, scaleFactorMin);
        _posDatas.Add(posData);
        return posData;
    }

    private void SetItemDatas()
    {
        for (int i = 0; i < _diagramItems.Count; i++)
        {
            _diagramItems[i].InitPosData(_posDatas[i]);
            _diagramItems[i].AddMoveListener(OnChange);
        }
    }

    private void OnChange(float moveOffset)
    {
        if (moveOffset < 0.05f && moveOffset > -0.05f) 
            return;
        int dir = moveOffset > 0 ? 1 : -1;
        OnChange(dir);
    }
    
    /// <summary>
    /// 正数+负数-
    /// </summary>
    /// <param name="dir"></param>
    private void OnChange(int dir)
    {
        for (int i = 0; i < _diagramItems.Count; i++)
        {
            _diagramItems[i].ChangeIndex(dir,_diagramItems.Count);
        }

        for (int i = 0; i < _diagramItems.Count; i++)
        {
            _diagramItems[i].SetPosData(_posDatas[_diagramItems[i].PosId]);
        }
    }
}

public class ItemPosData
{
    private float _x;
    private float _scaleFactor;
    private int _order = 0;

    public float X
    {
        get => _x;
        set => _x = value;
    }

    public float ScaleFactor
    {
        get => _scaleFactor;
        set => _scaleFactor = value;
    }

    public int Order
    {
        get => _order;
        set => _order = value;
    }
}
