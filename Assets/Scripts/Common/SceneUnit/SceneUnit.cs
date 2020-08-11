using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum EComponentType
{
    TRIGGER_SYSTEM,
    HEAD_LOOK_SYSTEM,
}

public class SceneUnit : PoolItemBase
{
    private AudioSource _audioSource;
    private GameObject _root;
    private Transform _thisTrans;
    
    private int _Id;
    
    private bool _isStatic;
    private bool _isTrigger = false;

    public Transform ThisTrans
    {
        get => _thisTrans;
        set => _thisTrans = value;
    }

    public GameObject Root
    {
        get => _root;
        set => _root = value;
    }

    public virtual void Init(int uniID)
    {
        _Id = uniID;
        
    }

    public void UnInit()
    {
        SceneUnitPoolManager.GetInstance().Despawn(this);
    }

    public int Id
    {
        get => _Id;
        set => _Id = value;
    }


    public virtual void Awake()
    {
        base.Awake();
        var root = new GameObject("Root");
        root.transform.parent = transform;
        root.transform.localScale = Vector3.one;
        root.transform.position = Vector3.zero;
        root.transform.rotation = Quaternion.identity;
        
        ThisTrans = root.transform;
        _root = root;
    }
}
