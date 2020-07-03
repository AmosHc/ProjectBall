using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SceneUnitPoolManager : MonoSingleton<SceneUnitPoolManager>
{
    private SceneUnitPool mSceneUnitPool;
    
    protected override void Init()
    {
        base.Init();
        mSceneUnitPool = new SceneUnitPool();
    }

    public SceneUnit Spawn()
    {
        return mSceneUnitPool.Spawn();
    }

    public void Despawn(SceneUnit instance)
    {
        mSceneUnitPool.Despawn(instance);
    }
}

public class SceneUnitPool : PoolBase<SceneUnit>
{
    public SceneUnitPool()
    {
        Init("------------SceneUnitPool------------");
    }

    public override SceneUnit CreateItem()
    {
        GameObject obj = new GameObject();

        if (obj == null)
            return null;
        obj.transform.parent = mRoot.transform;
        obj.transform.position = Vector3.zero;
        obj.transform.rotation = Quaternion.identity;
        obj.transform.localScale = Vector3.one;

        SceneUnit item = obj.GetComponent<SceneUnit>();
        if (item == null)
            item = obj.AddComponent<SceneUnit>();
        return item;
    }
}