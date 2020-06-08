using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RotationDiagramItem : MonoBehaviour
{
    private Image _image;

    private Image Image
    {
        get
        {
            if (_image == null)
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
        transform.SetParent(parent);
    }
    
    public void SetSprite(Sprite sprite)
    {
        Image.sprite = sprite;
    }

    public void SetPosData(ItemPosData data)
    {
        this.Rect.anchoredPosition = Vector2.right * data.X;
        this.Rect.localScale = Vector3.one * data.ScaleFactor;
    }
}
