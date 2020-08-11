using System.Collections;
using System.Collections.Generic;
using table;
using UnityEngine;

public class Entity : MonoBehaviour
{
    private SceneUnit _unit;
    private GameObject _modelObj;
    private EntityTemplateDefine _entityCfg;

    public EntityTemplateDefine EntityCfg
    {
        get => _entityCfg;
    }

    public SceneUnit Unit
    {
        get => _unit;
        set => _unit = value;
    }

    public virtual void Init(SceneUnit unit,EntityTemplateDefine config)
    {
        _unit = unit;
        _entityCfg = config;
        CreateEntityModel(config.ResPath);
    }
    
    private void CreateEntityModel(string resPath)
    {
        if (string.IsNullOrEmpty(resPath))
            return;
        ResourcesMgr.GetInstance().LoadAsset<GameObject>(resPath,OnModelLoadComplete);
    }

    private void OnModelLoadComplete(GameObject obj)
    {
        GameObject inst = Instantiate(obj, _unit.ThisTrans);
        inst.transform.localPosition = Vector3.zero;
        _modelObj = inst;
    }

    public virtual void UnInit()
    {
        _unit.UnInit();
        _unit = null;
        GameObject.Destroy(_modelObj);
        GameObject.Destroy(this);
    }
    
}
