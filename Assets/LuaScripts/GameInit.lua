--print("=============GameInit==============")
--
--
DebugVersion = true
EnableClientGM = false
ShowLogWindow = false
TIME_NOW = 0
REAL_TIME_NOW = 0
TRANSFORM_BATCH = false

unpack = table.unpack
pack = table.pack

require ("Emmylua")
require ("Utility/Functions")
require ("BaseClass")
require ("NameSpace")
require ("math")
inspect = require ("Utility/inspect")

if DebugVersion then
    SetLogLevel(LogLevel.Log)
else
    SetLogLevel(LogLevel.Error)
end

--EventDispatcherCls = require "Core/EventDispatcher"
--EventDispatcher = EventDispatcherCls.new()
GCTool = require ("Utility/GCTool")
inWindowsEditor = Application.platform == RuntimePlatform.WindowsEditor
utable = require ("Utility/TableUtility")
UIMgr = require ("UIFrameWork/UIManager"):Create()
PlayerData = require("Constant/PlayerData").New()

math.pow = function(num1,num2)
    return num1 ^ num2
end
