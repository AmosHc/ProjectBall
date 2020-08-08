using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapSceneManager : MonoSingleton<MapSceneManager>
{
    public SceneUnit CreateSceneUnit(int inType, int baseID, string resPath, Vector3 position, Quaternion rotation,float size = 1)
    {
        EUnitClassType type = (EUnitClassType) (inType);
        return CreateSceneUnit(type, baseID, resPath, position, rotation, size = 1);
    }

    public SceneUnit CreateSceneUnit(EUnitClassType type, int baseID, string resPath, Vector3 position, Quaternion rotation,float size = 1)
    {
        SceneUnit sceneUnit = null;
        switch (type)
        {
            case EUnitClassType.Ball:
                sceneUnit = CreateSceneBall(baseID,resPath,position,rotation);
                break;
            case EUnitClassType.StaticAgency:
                sceneUnit = CreateSceneStaticAgency(baseID,resPath,position,rotation);
                break;
            case EUnitClassType.DynamicAgency:
                sceneUnit = CreateSceneDynamicAgency(baseID,resPath,position,rotation);
                break;
            case EUnitClassType.Star:
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
        Debug.Log(position);
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

        u.gameObject.name = "Star";
        u.transform.position = position;
        u.transform.rotation = rotation;
        u.gameObject.layer = LayerMask.NameToLayer("Star");
        u.IsPlayer = true;
        u.Init(uniID);
        return u;
    }
}