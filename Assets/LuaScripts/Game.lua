Game = {};
local function __G__TRACKBACK__(msg)
	error(msg);
end
G_WeakTable = {};
setmetatable(G_WeakTable,{__mode="k"});

local function Main()
    require("GameInit")

    if DebugVersion then
        -- 编辑模式下提示未正确声明的全局变量
        setmetatable(_G,
            {
                __index = function(t,k)
                    if (k ~= "jit") then
                        ErrorLogMgr:Ignore(k)
                        DLog(debug.traceback("未注册的全局变量"..k,2))
                    end
                end
            });
    end

    --管理器-- 
	math.randomseed(tostring(os.time()):reverse():sub(1,7))

    --GC设置
    GCTool.setup()
end

function OnLoginWithNetwork()
    SceneMgr:SwitchScene(SceneID.LoginWithNetworkScene)
end
function OnLobby()
	SceneMgr:SwitchScene(SceneID.Lobby)
end
function OnGame()
	--SceneMgr:SwitchScene(SceneID.Game)
end

--初始化--
function OnInitOK()
    Main();
end

function OnApplicationQuit()
    
end


require("Tools.ProfilerSampler")
UWABeginSample = UWALuaHelper.PushSample
UWAEndSample = UWALuaHelper.PopSample
function Game.OnUpdate()
    UWABeginSample("GameOnUpdate")
    BeginSample__Base("GameOnUpdate")
    SceneMgr:OnUpdate()
    --always update
    BeginSample__Base("MemDataMgrOnUpdate")
    MemDataMgr:OnUpdateFrame()
    EndSample__Base()
    EndSample__Base()
    UWAEndSample()
end

--svrTime 表示上次ping的服务器时刻
--serverDelateTime 表示上次pong的客户端时刻
function Game.SyncServerTime(svrTime)
	if svrTime <= 0 then return end
    Game.svrTime = svrTime
    Game.serverDelateTime = os.time()
end

function Game.GetSvrTime()
    return Game.svrTime + math.floor(os.time() - (Game.serverDelateTime or os.time()))
end

return Game