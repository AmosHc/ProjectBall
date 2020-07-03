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
    private Transform _transform;
    private CapsuleCollider _collider;
    private Rigidbody _rigidbody;
    private AudioSource _audioSource;
    private Transform _markNameTras;
    private GameObject _root;
    
    private string _name = "";
    private int _Id;
    private bool _isPlayer = false;
    private bool _isNpc = false;
    private bool _isTrigger = false;

    public virtual void Init(int uniID)
    {
        _transform = transform;
        _Id = uniID;
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

        _transform = root.transform;
        _root = root;
    }

    public void SetIsPlayer()
    {
        _isPlayer = true;
        
        _collider = gameObject.GetComponent<CapsuleCollider>();
        _rigidbody = gameObject.GetComponent<Rigidbody>();
        _name = gameObject.name;
    }

    public void SetIsNPC(string name = "")
    {
        _isNpc = true;
        _audioSource = gameObject.GetComponent<AudioSource>();
        _audioSource.mute = true;
        _collider = gameObject.GetComponent<CapsuleCollider>();
        _rigidbody = gameObject.GetComponent<Rigidbody>();
        _markNameTras = gameObject.transform.Find("MarkName");
        _name = name;
    }

    public string Name
    {
        get => _name;
        set => _name = value;
    }

    public bool IsPlayer
    {
        get => _isPlayer;
        set => _isPlayer = value;
    }

    public bool IsNpc
    {
        get => _isNpc;
    }

    public Transform markNameTras
    {
        get => _markNameTras;
    }
}
