using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoSingleton<GameManager>
{
    public void ManagerCreate()
    {
//        XLuaManager.GetInstance().StartGame();
//        LuaFileWatcher.CreateLuaFileWatcher(XLuaManager.GetInstance().luaEnv);
        GameConfigManager.GetInstance().Create();
        SceneUnitPoolManager.GetInstance().Create();
        GameUIManager.GetInstance().Create();
        EntityManager.GetInstance().Create();
        ControllerManager.GetInstance().Create();
        AgencyManager.GetInstance().Create();
        Timers.GetInstance().Create();
    }
}
