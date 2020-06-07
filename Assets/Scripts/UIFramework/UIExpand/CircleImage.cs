using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Sprites;
using UnityEngine.UI;

public class CircleImage : Image
{
    [SerializeField]
    public int segments = 100;//切割份数
    [SerializeField]
    public float fillPercent = 1;//显示百分比
    
    private readonly Color32 GRAY_COLOR = new Color32(60,60,60,255);
    
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
        return false;
    }
}
