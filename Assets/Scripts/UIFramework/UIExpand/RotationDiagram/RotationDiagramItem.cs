using System;
using DG.Tweening;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class RotationDiagramItem : MonoBehaviour,IDragHandler,IEndDragHandler
{
    public float moveTweenTime = 0.5f;
    public float scaleTweenTime = 0.5f;
    
    private float _moveOffset = 0;
    private Action<float> _moveAction;
    private int _posID;
    public int PosId
    {
        get => _posID;
        set => _posID = value;
    }
    
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
    
    //初始化时不需要动画，会穿帮
    public void InitPosData(ItemPosData data)
    {
        this.Rect.anchoredPosition = Vector2.right * data.X;
        this.Rect.localScale = Vector3.one * data.ScaleFactor;
        transform.SetSiblingIndex(data.Order);
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
        this.Rect.DOAnchorPos(Vector2.right * data.X, moveTweenTime);
        this.Rect.DOScale(Vector3.one * data.ScaleFactor, scaleTweenTime);
        transform.SetSiblingIndex(data.Order);
    }

    public void SetOrder(int order)
    {
        transform.SetSiblingIndex(order);
    }

    public void AddMoveListener(Action<float> moveAction)
    {
        _moveAction = moveAction;
    }
    
    public void OnDrag(PointerEventData eventData)
    {
        _moveOffset += eventData.delta.x;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        _moveAction(_moveOffset);
        _moveOffset = 0;
    }

    public void ChangeIndex(int dir,int totalItemNum)
    {
        int id = _posID + dir;
        if (id < 0)
        {
            id += totalItemNum;
        }

        _posID = id % totalItemNum;
    }
}
