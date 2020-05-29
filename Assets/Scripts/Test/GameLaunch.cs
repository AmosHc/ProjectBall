using UnityEngine;

public class GameLaunch : MonoBehaviour
{
    private void Start()
    {
//        XLuaManager.GetInstance().Startup();
        XLuaManager.GetInstance().StartGame();
        LuaFileWatcher.CreateLuaFileWatcher(XLuaManager.GetInstance().luaEnv);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.K))
        {
            XLuaManager.GetInstance().SafeDoString("GameMain.TestFunc()");
        }
    }

}
