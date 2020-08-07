: 输出C#源码,二进制(例子中供C#读取), lua表, json格式
: 适用于csharp, golang, lua例子
tabtoy.exe ^
--mode=v2 ^
--csharp_out=..\Assets\ConfigData\Config.cs ^
--binary_out=..\Assets\ConfigData\Config.bin ^
--lua_out=..\Assets\LuaScripts\Constant\Config.lua ^
--luaenumintvalue=true ^
--combinename=Config ^
--lan=zh_cn ^
./Excels/Globals.xlsx ^
./Excels/ThemeChooser.xlsx ^
./Excels/Levels.xlsx ^
./Excels/Agencys.xlsx

@IF %ERRORLEVEL% NEQ 0 pause
rem pause