using System.Collections.Generic;
using table;
using UnityEngine;
using Utility;

public class EntityManager : MonoSingleton<EntityManager>
{
    private Dictionary<int,List<Entity>> entities;

    public override void Create()
    {
        entities = new Dictionary<int, List<Entity>>();
    }

    public T CreateEntity<T>(int entityID, Vector3 position, Quaternion rotation) where T : Entity
    {
        EntityTemplateDefine cfg = GameConfigManager.GetInstance().GameConfig.GetEntityTemplateByEntityId(entityID);
        if (cfg == null)
        {
            Debug.LogError("传递的EntityID不存在:" + entityID);
            return null;
        }
        return CreateEntity<T>(cfg, position, rotation);
    }
    
    public T CreateEntity<T>(EntityTemplateDefine config, Vector3 position, Quaternion rotation) where T : Entity
    {
        int entityID = config.EntityId;
        SceneUnit unit = MapSceneManager.GetInstance().CreateSceneUnit(config.EntityType,entityID,config.ResPath,position,rotation);
        T entity = CommonUtility.GetOrAddComponent<T>(unit.gameObject);
        if (entity != null)
        {
            entity.Init(unit,config);
            AddEntity(entityID, entity);
        }
        return entity;
    }

    private void AddEntity(int entityID,Entity entity)
    {
        if (entities.ContainsKey(entityID))
        {
            if(entities[entityID].Contains(entity))
                return;
        }
        else
        {
            entities[entityID] = new List<Entity>();
        }
        entities[entityID].Add(entity);
    }

    public List<Entity> GetEntitys(int entityID)
    {
        return entities[entityID];
    }
}