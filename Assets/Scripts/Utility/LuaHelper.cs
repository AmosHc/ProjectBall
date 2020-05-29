using System.IO;
using UnityEngine;

public class LuaHelper
{
    public static void SetLogLevel(int logLevel)
    {
        LogType type = LogType.Log;
        switch (logLevel)
        {
            case 1:
                type = LogType.Log;
                break;
            case 2:
                type = LogType.Warning;
                break;
            case 3:
                type = LogType.Error;
                break;
        }

        Debug.unityLogger.filterLogType = type;
    }
}