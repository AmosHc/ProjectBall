using UnityEngine;

public class EntityManager : MonoSingleton<EntityManager>
{
    public override void Create()
    {
    }

    public void CreateEntityWithConfig(EUnitClassType type, int baseID, string resPath, Vector3 position, Quaternion rotation,float size = 1)
    {


//        SceneUnit unit = MapSceneManager.GetInstance().CreateSceneUnit(type);
    }
}