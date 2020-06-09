using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Sprites;
using UnityEngine.UI;

/// <summary>
/// 圆形遮罩
/// </summary>
public class CircleMaskImage : Image
{
    [SerializeField]
    public int segments = 100;//切割份数
    [SerializeField]
    public float fillPercent = 1;//显示百分比
    
    private readonly Color32 GRAY_COLOR = new Color32(60,60,60,255);

    private List<Vector3> _vertexList;
    
    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        toFill.Clear();
        //填充点
        AddVertex(toFill);
        //填充三角面 顺时针正面渲染 逆时针反面
        AddTriangle(toFill);
    }

    private void AddVertex(VertexHelper toFill)
    {
        float imgWidth = rectTransform.rect.width;
        float imgHeight = rectTransform.rect.height;
        int readSegments = (int)(segments * fillPercent);
        Vector4 uv = overrideSprite != null ? DataUtility.GetOuterUV(overrideSprite) : Vector4.zero;
        float uvWidth = uv.z - uv.x;
        float uvHeigth = uv.w - uv.y;
        Vector3 originPos = new Vector3((0.5f - rectTransform.pivot.x) * imgWidth,(0.5f - rectTransform.pivot.y) * imgHeight,0);
        Vector2 uvCenter = new Vector2((uvWidth * 0.5f),(uvHeigth * 0.5f));
        Vector2 convertRatio = new Vector2(uvWidth / imgWidth, uvHeigth / imgHeight );//横纵缩放

        SetOrigin(uvCenter, convertRatio, toFill, readSegments,originPos);
        SetCircleVert(uvCenter, convertRatio, toFill,imgWidth * 0.5f,readSegments,originPos);
    }
    
    private void SetOrigin(Vector2 uvCenter,Vector2 convertRatio,VertexHelper toFill,int readSegments,Vector3 originPos)
    {
        UIVertex origin = new UIVertex();
        origin.color = GetOriginColor();
        origin.position = originPos;
        origin.uv0 = new Vector2(uvCenter.x, uvCenter.y);
        toFill.AddVert(origin);
    }

    private Color32 GetOriginColor()
    {
        Color32 colorTemp = (Color.white - GRAY_COLOR) * fillPercent;
        return new Color32(
            (byte)(GRAY_COLOR.r + colorTemp.r),
            (byte)(GRAY_COLOR.g + colorTemp.g),
            (byte)(GRAY_COLOR.b + colorTemp.b),
            255);
    }

    private void SetCircleVert(Vector2 uvCenter,Vector2 convertRatio,VertexHelper toFill,float radius,int readSegments,Vector3 originPos)
    {
        _vertexList = new List<Vector3>();
        //初始化角度
        float segmentAngle = Mathf.PI * 2 / segments;
        float curAngle = 0;
        Vector3 circleVert = Vector3.zero;
        for (int i = 0; i < segments + 1; i++)
        {
            float x = Mathf.Cos(curAngle) * radius;
            float y = Mathf.Sin(curAngle) * radius;
            curAngle += segmentAngle;
            
            UIVertex vertex = new UIVertex();
            if (i < readSegments || (readSegments == segments && i == segments))
            {
                vertex.color = color;
            }
            else
            {
                vertex.color = GRAY_COLOR;
            }

            circleVert = new Vector3(x, y, 0);
            vertex.position = circleVert + originPos;
            _vertexList.Add(vertex.position);
            vertex.uv0 = new Vector2(convertRatio.x * circleVert.x + uvCenter.x,convertRatio.y * circleVert.y + uvCenter.y);
            toFill.AddVert(vertex);
        }
    }

    private void AddTriangle(VertexHelper toFill)
    {
        for (int i = 1; i < segments+1; i++)
        {
            toFill.AddTriangle(i, 0, i + 1);
        }
    }

    public override bool IsRaycastLocationValid(Vector2 screenPoint, Camera eventCamera)
    {
        Vector2 localPoint;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransform, screenPoint, eventCamera, out localPoint);
        return IsValid(localPoint);
    }

    private bool IsValid(Vector2 inputPoint)
    {
        return GetCrossPointNum(inputPoint,_vertexList) % 2 == 1;
    }

    private int GetCrossPointNum(Vector2 inputPoint, List<Vector3> vertexList)
    {
        if (vertexList == null)
        {
            Debug.LogError("vertexList is Null!");
            return 0;
        }
        Vector3 vert1 = Vector3.zero;
        Vector3 vert2 = Vector3.zero;
        int count = vertexList.Count;

        int crossNum = 0;
        for (int i = 0; i < count; i++)
        {
            vert1 = vertexList[i];
            vert2 = vertexList[(i + 1) % count];
            if (CheckPointYInRange(inputPoint, vert1, vert2))
            {
                if (CheckPointXValid(inputPoint, vert1, vert2))
                {
                    crossNum++;
                }
            }
        }
        return crossNum;
    }

    private bool CheckPointYInRange(Vector2 inputPoint, Vector3 vert1, Vector3 vert2)
    {
        if (vert1.y > vert2.y)
        {
            return vert1.y >= inputPoint.y && vert2.y <= inputPoint.y;
        }
        else
        {
            return vert2.y >= inputPoint.y && vert1.y <= inputPoint.y;
        }
    }

    private bool CheckPointXValid(Vector2 inputPoint, Vector3 vert1, Vector3 vert2)
    {
        //y = kx + b  k = y1-y2/x1-x2
        float k = (vert1.y - vert2.y) / (vert1.x - vert2.x);
        float b = vert1.y - (vert1.x * k);
        float x0 = ((inputPoint.y) - b) / k; //线段上和直线相交的点(x0,y0)，y0 = inputPoint.y
        return x0 >= inputPoint.x;//向右判断相交
    }
}
