using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoSingleton<GameManager>
{
    public void ManagerCreate()
    {
        XLuaManager.GetInstance().StartGame();
        LuaFileWatcher.CreateLuaFileWatcher(XLuaManager.GetInstance().luaEnv);
    }
}
