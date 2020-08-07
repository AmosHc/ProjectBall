using System;
using System.IO;
using table;
using tabtoy;
using UnityEngine;

public class GameConfigManager : MonoSingleton<GameConfigManager>
{
    private Config _gameConfig;

    public Config GameConfig
    {
        get => _gameConfig;
        set => _gameConfig = value;
    }
        
    public override void Create()
    {
        LoadConfigToMemory();
    }

    /// <summary>
    /// 目前将所有配置表直接加载进内存，因为是二进制数据，大小其实还好，后面如果内存过高考虑优化为按需加载
    /// </summary>
    private void LoadConfigToMemory()
    {
        using (var stream = new FileStream("Assets/ConfigData/Config.bin", FileMode.Open))
        {
            stream.Position = 0;

            var reader = new tabtoy.DataReader(stream);

            _gameConfig = new table.Config();

            var result = reader.ReadHeader(_gameConfig.GetBuildID());
            if ( result != FileState.OK)
            {
                Debug.LogError("配置数据读取失败!");
                return;
            }

            table.Config.Deserialize(_gameConfig, reader);
//                // 添加日志输出或自定义输出
//                config.TableLogger.AddTarget(new tabtoy.DebuggerTarget());
//                // 取空时, 当默认值不为空时, 输出日志
//                var nullFetchOutLog = config.GetSampleByID(0);
        }
    }
}