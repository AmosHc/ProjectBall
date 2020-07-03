using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolBase<T> where T: PoolItemBase
{
    protected Stack<T> mInstance = new Stack<T>();
    
    protected GameObject mRoot;

    public GameObject GetRoot()
    {
        return mRoot;
    }

    public void Init(string name)
    {
        if (mRoot != null)
        {
            return;
        }
        mRoot = new GameObject(name);
        Object.DontDestroyOnLoad(mRoot);
    }


    public virtual T Spawn()
    {
        if (mInstance.Count > 0)
        {
            var instance = mInstance.Pop();
            instance.gameObject.SetActive(true);
            instance.OnSpawned();
            return instance;
        }
        else
        {
            var instance = CreateItem();
            instance.OnSpawned();
            return instance;
        }
    }


    public virtual void Despawn(T instance)
    {
        instance.OnDespawned();
        instance.gameObject.SetActive(false);
        mInstance.Push(instance);
    }

    public void PreLoad(int count)
    {
        for (int i = 0; i < count; i++)
        {
            Despawn(CreateItem());
        }
    }

    public void Clear(int defaultClearCount = 1)
    {
        while (mInstance.Count > defaultClearCount)
        {
            var instance = mInstance.Pop();
            GameObject.Destroy(instance.gameObject);
        }
    }

    public virtual T CreateItem()
    {
        return null;
    }
}
