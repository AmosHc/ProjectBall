using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 雷达图
/// </summary>
public class RadarChart : Image
{
    [SerializeField]
    private int _pointCount = 5;
    [SerializeField]
    private int _initRadius = 100;
    [SerializeField]
    private Sprite _pointSprite = null;
    [SerializeField]
    private Color _pointColor = Color.white;
    [SerializeField]
    private Vector2 _pointSize = Vector2.one * 10;
    [SerializeField]
    private List<float> _pointsHandlerRatios; //配置或者传递的每个点比例数据
    
    private List<RectTransform> _pointRects;
    private List<RadarChartHandler> _handlers;

    public void InitPoints()
    {
        ClearObjs(_pointRects);
        _pointRects = new List<RectTransform>();
        SpawnPoints();
        InitPointsPos();
    }
    
    public void ClearObjs<T>(List<T> optionList) where T:Component
    {
        if (optionList == null)
            return;
        for (int i = 0; i < optionList.Count; i++)
        {
            DestroyImmediate(optionList[i].gameObject);
        }
        optionList = null;
    }
    
    private void SpawnPoints()
    {
        for (int i = 0; i < _pointCount; i++)
        {
            GameObject point = new GameObject("Point_"+i);
            point.transform.SetParent(transform);
            _pointRects.Add(point.AddComponent<RectTransform>());
        }
    }

    private void InitPointsPos()
    {
        double perimeter = 2 * Math.PI;
        float radian = (float)(perimeter / _pointCount);

        float curRadian = (float)(perimeter * 0.25f);//从上面开始
        for (int i = 0; i < _pointCount; i++)
        {
            float x = Mathf.Cos(curRadian) * _initRadius;
            float y = Mathf.Sin(curRadian) * _initRadius;
            _pointRects[i].anchoredPosition = new Vector2(x, y);
            curRadian += radian;
        }
    }

    public void InitHandlers()
    {
        ClearObjs(_handlers);
        _handlers = new List<RadarChartHandler>();
        SpawnHandlers();
        InitHandlersPos();
    }
    
    private void SpawnHandlers()
    {
        for (int i = 0; i < _pointCount; i++)
        {
            GameObject obj = new GameObject("Handler_"+i);
            obj.AddComponent<RectTransform>();
            obj.AddComponent<Image>();
            RadarChartHandler handler = obj.AddComponent<RadarChartHandler>();
            handler.SetParent(transform);
            handler.SetSprite(_pointSprite);
            handler.SetColor(_pointColor);
            handler.SetSize(_pointSize);
            _handlers.Add(handler);
        }
    }

    private void InitHandlersPos()
    {
        if(_pointsHandlerRatios == null || _pointsHandlerRatios.Count != _pointCount)
        {
            for (int i = 0; i < _pointCount; i++)
            {
                _handlers[i].SetPos(_pointRects[i].anchoredPosition);
            }
        }
        else
        {
            for (int i = 0; i < _pointCount; i++)
            {
                _handlers[i].SetPos(_pointRects[i].anchoredPosition * _pointsHandlerRatios[i]);
            }
        }
    }

    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        base.OnPopulateMesh(toFill);
        toFill.Clear();
//        AddVertex(toFill);
        AddUVVertex(toFill);
        AddTriangle(toFill);
    }

    /// <summary>
    ///  2  1  5
    ///     0  
    ///  3     4
    /// </summary>
    /// <param name="toFill"></param>
    private void AddUVVertex(VertexHelper toFill)
    {
        if (_handlers == null) return;
        toFill.AddVert(Vector3.zero,color,new Vector2(0.5f,0.5f));
        toFill.AddVert(_handlers[0].transform.localPosition,color,new Vector2(0.5f,1));
        toFill.AddVert(_handlers[1].transform.localPosition,color,new Vector2(0,1));
        toFill.AddVert(_handlers[2].transform.localPosition,color,new Vector2(0,0));
        toFill.AddVert(_handlers[3].transform.localPosition,color,new Vector2(1,0));
        toFill.AddVert(_handlers[4].transform.localPosition,color,new Vector2(1,1));
    }
    private void AddVertex(VertexHelper toFill)
    {
        if (_handlers == null) return;
        toFill.AddVert(Vector3.zero,_pointColor,Vector2.zero);
        for (int i = 0; i < _handlers.Count; i++)
        {
            toFill.AddVert(_handlers[i].transform.localPosition,_pointColor,Vector2.zero);
        }
    }

    private void AddTriangle(VertexHelper toFill)
    {
        if (_handlers == null) return;
        for (int i = 1; i < _handlers.Count + 1; i++)
        {
            if (i == _handlers.Count)
            {
                toFill.AddTriangle(i, 0, 1);
            }
            else
            {
                toFill.AddTriangle(i, 0, i + 1);
            }
        }
    }
    

    private void Update()
    {
        SetVerticesDirty();
    }
}
