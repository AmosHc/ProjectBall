using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RadarChartHandler : MonoBehaviour
{
    private Image _image;

    private Image Image
    {
        get
        {
            if(_image == null)
            {
                _image = GetComponent<Image>();
            }

            return _image;
        }
    }

    private RectTransform _rect;

    private RectTransform Rect
    {
        get
        {
            if (_rect == null)
            {
                _rect = GetComponent<RectTransform>();
            }
            return _rect;
        }
    }


    public void SetParent(Transform parent)
    {
        transform.parent = parent;
    }
    
    public void SetSprite(Sprite sprite)
    {
        Image.sprite = sprite;
    }
    
    public void SetColor(Color color)
    {
        Image.color = color;
    }
    
    public void SetPos(Vector2 pos)
    {
        Rect.anchoredPosition = pos;
    }

    public void SetSize(Vector2 size)
    {
        Rect.sizeDelta = size;
    }
}
