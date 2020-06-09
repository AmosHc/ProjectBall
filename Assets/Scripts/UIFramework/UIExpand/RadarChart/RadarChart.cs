using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 雷达图
/// </summary>
public class RadarChart : MonoBehaviour
{
    public int pointCount = 5;
    public int initRadius = 100;
    public Sprite pointSprite = null;
    public Color pointColor = Color.white;
    public Vector2 pointSize = Vector2.one;
    public List<float> _pointsHandlerRatios; //配置或者传递的每个点比例数据
    
    private List<RectTransform> _pointRects;
    private List<RadarChartHandler> _handlers;
    private void Start()
    {
        InitPoints();
        InitHandlers();
    }

    private void InitPoints()
    {
        ClearPoints();
        _pointRects = new List<RectTransform>();
        SpawnPoints();
        InitPointsPos();
    }

    private void ClearPoints()
    {
        if (_pointRects == null)
            return;
        for (int i = 0; i < _pointRects.Count; i++)
        {
            DestroyImmediate(_pointRects[i]);
        }
        _pointRects = null;
    }

    private void SpawnPoints()
    {
        for (int i = 0; i < pointCount; i++)
        {
            GameObject point = new GameObject("Point_"+i);
            point.transform.SetParent(transform);
            _pointRects.Add(point.AddComponent<RectTransform>());
        }
    }

    private void InitPointsPos()
    {
        double perimeter = 2 * Math.PI;
        float radian = (float)(perimeter / pointCount);

        float curRadian = (float)(perimeter * 0.25f);//从上面开始
        for (int i = 0; i < pointCount; i++)
        {
            float x = Mathf.Cos(curRadian) * initRadius;
            float y = Mathf.Sin(curRadian) * initRadius;
            _pointRects[i].anchoredPosition = new Vector2(x, y);
            curRadian += radian;
        }
    }

    private void InitHandlers()
    {
        _handlers = new List<RadarChartHandler>();
        SpawnHandlers();
        InitHandlersPos();
    }
    
    private void SpawnHandlers()
    {
        for (int i = 0; i < pointCount; i++)
        {
            GameObject obj = new GameObject("Handler_"+i);
            obj.AddComponent<RectTransform>();
            obj.AddComponent<Image>();
            RadarChartHandler handler = obj.AddComponent<RadarChartHandler>();
            handler.SetParent(transform);
            handler.SetSprite(pointSprite);
            handler.SetColor(pointColor);
            handler.SetSize(pointSize);
            _handlers.Add(handler);
        }
    }

    private void InitHandlersPos()
    {
        if(_pointsHandlerRatios == null || _pointsHandlerRatios.Count != pointCount)
        {
            for (int i = 0; i < pointCount; i++)
            {
                _handlers[i].SetPos(_pointRects[i].anchoredPosition);
            }
        }
        else
        {
            for (int i = 0; i < pointCount; i++)
            {
                _handlers[i].SetPos(_pointRects[i].anchoredPosition * _pointsHandlerRatios[i]);
            }
        }
    }
}
