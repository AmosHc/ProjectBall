using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum UnitClassType
{
    Ball = 1,//玩家
    StaticAgency = 2,//静态机关
    DynamicAgency = 3,//动态机关
    Star = 4,//星
}

public class MapSceneManager : MonoSingleton<MapSceneManager>
{
    public SceneUnit CreateSceneUnit(int inType, int baseID, string resPath, Vector3 position, Quaternion rotation,float size = 1)
    {
        UnitClassType type = (UnitClassType) (inType);
        return CreateSceneUnit(type, baseID, resPath, position, rotation, size = 1);
    }

    public SceneUnit CreateSceneUnit(UnitClassType type, int baseID, string resPath, Vector3 position, Quaternion rotation,float size = 1)
    {
        SceneUnit sceneUnit = null;
        switch (type)
        {
            case UnitClassType.Ball:
                sceneUnit = CreateSceneBall(baseID,resPath,position,rotation);
                break;
            case UnitClassType.StaticAgency:
                sceneUnit = CreateSceneStaticAgency(baseID,resPath,position,rotation);
                break;
            case UnitClassType.DynamicAgency:
                sceneUnit = CreateSceneDynamicAgency(baseID,resPath,position,rotation);
                break;
            case UnitClassType.Star:
                sceneUnit = CreateSceneStar(baseID,resPath,position,rotation);
                break;
        }

        if (sceneUnit != null)
        {
            sceneUnit.transform.localScale = Vector3.one * size;
        }

        return sceneUnit;
    }

    private SceneUnit CreateSceneBall(int uniID, string resPath, Vector3 position, Quaternion rotation)
    {
        SceneUnit u = SceneUnitPoolManager.GetInstance().Spawn();

        u.gameObject.name = "Ball";
        u.transform.position = position;
        u.transform.rotation = rotation;
        u.gameObject.layer = LayerMask.NameToLayer("Ball");
        u.IsPlayer = true;
        u.Init(uniID);
        return u;
    }
    
    private SceneUnit CreateSceneStaticAgency(int uniID, string resPath, Vector3 position, Quaternion rotation)
    {
        SceneUnit u = SceneUnitPoolManager.GetInstance().Spawn();

        u.gameObject.name = "Fighter";
        u.transform.position = position;
        u.transform.rotation = rotation;
        u.gameObject.layer = LayerMask.NameToLayer("Unit");
        u.Init(uniID);
        return u;
    }
    
    private SceneUnit CreateSceneDynamicAgency(int uniID, string resPath, Vector3 position, Quaternion rotation)
    {
        SceneUnit u = SceneUnitPoolManager.GetInstance().Spawn();

        u.gameObject.name = "Player";
        u.transform.position = position;
        u.transform.rotation = rotation;
        u.gameObject.layer = LayerMask.NameToLayer("Player");
        u.IsPlayer = true;
        u.Init(uniID);
        return u;
    }
    
    
    private SceneUnit CreateSceneStar(int uniID, string resPath, Vector3 position, Quaternion rotation)
    {
        SceneUnit u = SceneUnitPoolManager.GetInstance().Spawn();

        u.gameObject.name = "Player";
        u.transform.position = position;
        u.transform.rotation = rotation;
        u.gameObject.layer = LayerMask.NameToLayer("Player");
        u.IsPlayer = true;
        u.Init(uniID);
        return u;
    }
}