using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting.Messaging;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 自定义不规则多边形点击区域组件
/// </summary>
public class CustomImage : Image
{
    private PolygonCollider2D _polygon;

    private PolygonCollider2D Polygon
    {
        get
        {
            if (_polygon == null)
            {
                _polygon = GetComponent<PolygonCollider2D>();
            }

            return _polygon;
        }
    }
    
    public override bool IsRaycastLocationValid(Vector2 screenPoint, Camera eventCamera)
    {
        Vector3 wordPoint;
        RectTransformUtility.ScreenPointToWorldPointInRectangle(rectTransform, screenPoint, eventCamera, out wordPoint);
        return Polygon.OverlapPoint(wordPoint);
    }
}
