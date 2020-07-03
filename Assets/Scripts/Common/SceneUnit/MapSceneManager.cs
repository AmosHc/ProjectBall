using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum UnitClassType
{
    player = 1,//玩家
    monster = 2,//怪物
    boss = 3,//Boss
}

public class MapSceneManager : MonoSingleton<MapSceneManager>
{
    public SceneUnit CreateSceneUnit(int inType, int baseID, string resPath, Vector3 position, Quaternion rotation,
        int pointID, float colliderRadius = 0.5f, float colliderHeight = 2, float size = 1)
    {
        UnitClassType type = (UnitClassType) (inType);
        SceneUnit sceneUnit = null;
        switch (type)
        {
            case UnitClassType.player:
                sceneUnit = CreateScenePlayer(baseID,resPath,position,rotation);
                break;
            case UnitClassType.monster:
                sceneUnit = CreateSceneMonster(baseID,resPath,position,rotation);
                break;
            case UnitClassType.boss:
                sceneUnit = CreateSceneBoss(baseID,resPath,position,rotation);
                break;
        }

        if (sceneUnit != null)
        {
            sceneUnit.transform.localScale = Vector3.one * size;
        }

        return sceneUnit;
    }

    private SceneUnit CreateScenePlayer(int uniID, string resPath, Vector3 position, Quaternion rotation)
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
    
    private SceneUnit CreateSceneMonster(int uniID, string resPath, Vector3 position, Quaternion rotation)
    {
        SceneUnit u = SceneUnitPoolManager.GetInstance().Spawn();

        u.gameObject.name = "Fighter";
        u.transform.position = position;
        u.transform.rotation = rotation;
        u.gameObject.layer = LayerMask.NameToLayer("Unit");
        u.Init(uniID);
        return u;
    }
    
    private SceneUnit CreateSceneBoss(int uniID, string resPath, Vector3 position, Quaternion rotation)
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