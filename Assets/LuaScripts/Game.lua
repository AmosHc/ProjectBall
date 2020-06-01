Game = {}

local function Main()
    require("GameInit")

    if DebugVersion then
        -- 编辑模式下提示未正确声明的全局变量
        setmetatable(_G,
            {
                __index = function(t,k)
                    if (k ~= "jit") then
                        DLog(debug.traceback("未注册的全局变量"..k,2))
                    end
                end
            });
    end
    --设置随机数种子
	math.randomseed(tostring(os.time()):reverse():sub(1,7)) 

    --GC设置
    GCTool.setup()
end

--初始化--
function Game.Start()
    Main();
    UIMgr:OpenUI("MainCityScreen")
end

function OnApplicationQuit()
    
end

function OnUpdate(deltaTime)
    UIMgr:Update()
end

return Game