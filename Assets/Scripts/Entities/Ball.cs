using System;
using table;
using UnityEngine;

public class Ball : Entity
{
    private Rigidbody2D _rigidbody;
    private CircleCollider2D _collider;
    private BallsDefine _selfCfg;
    private bool _isInCameraView;

    public override void Init(SceneUnit unit,EntityTemplateDefine config)
    {
        base.Init(unit,config);
        _selfCfg = GameConfigManager.GetInstance().GameConfig.GetBallsByEntityId(config.EntityId);
        AddRigidbody2D();
        AddCircleCollider2D();
        _isInCameraView = IsInCameraView();
    }

    private void Update()
    {
        bool newSate = IsInCameraView();
        if (newSate != _isInCameraView)
        {
            if(newSate)
                OnEnterCameraView();
            else
                OnExitCameraView();
            _isInCameraView = newSate;
        }
    }

    /// <summary>
    /// 是否在摄像机视野内
    /// </summary>
    /// <returns></returns>
    private bool IsInCameraView()
    {
        Vector3 pos = Camera.main.WorldToViewportPoint(transform.position);
        return pos.x > 0f && pos.x < 1f && pos.y > 0f && pos.y < 1f;
    }

    /// <summary>
    /// 离开摄像机视野
    /// </summary>
    private void OnExitCameraView()
    {
        EventManager.OnGameOver.BroadCastEvent();
        UnInit();
    }

    /// <summary>
    /// 进入摄像机视野
    /// </summary>
    private void OnEnterCameraView()
    {
        
    }
    
    private void AddRigidbody2D()
    {
        if (_rigidbody == null)
        {
            _rigidbody = gameObject.AddComponent<Rigidbody2D>();
            ResourcesMgr.GetInstance().LoadAsset<PhysicsMaterial2D>(_selfCfg.MaterialResPath,OnMaterialLoadComplete);
        }
    }
    
    private void RemoveRigidbody2D()
    {
        if (_rigidbody != null)
        {
            Destroy(_rigidbody);
            _rigidbody = null;
        }
    }

    private void OnMaterialLoadComplete(PhysicsMaterial2D material)
    {
        _rigidbody.sharedMaterial = material;
    }
    
    private void AddCircleCollider2D()
    {
        if (_collider == null)
        {
            _collider = gameObject.AddComponent<CircleCollider2D>();
            _collider.radius = _selfCfg.ColliderRadius;
        }
    }

    private void RemoveCircleCollider2D()
    {
        if (_collider != null)
        {
            Destroy(_collider);
            _collider = null;
        }
    }
    public override void UnInit()
    {
        base.UnInit();
        RemoveRigidbody2D();
        RemoveCircleCollider2D();
    }
}