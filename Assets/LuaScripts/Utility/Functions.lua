--level:
--1.log, print,warn,error
--2.warn,error
--3.error
--4.nothing
LogLevel =
{
    Log = 1,
    Warn = 2,
    Error = 3,
}

local enable_level_1 = false;
local enable_level_2 = false;
local enable_level_3 = false;
function SetLogLevel(level)
    if level < 2 then
        enable_level_1 = true;
        enable_level_2 = true;
        enable_level_3 = true;
    elseif level < 3 then
        enable_level_1 = false;
        enable_level_2 = true;
        enable_level_3 = true;
    elseif level < 4 then
        enable_level_1 = false;
        enable_level_2 = false;
        enable_level_3 = true;
    else
        enable_level_1 = false;
        enable_level_2 = false;
        enable_level_3 = false;
    end
    --LuaHelper.SetLogLevel(level)
end

local oldPrint = print
print = function(...)
    if DebugVersion then
        DLog('请不要使用 print 函数，该函数没有出错堆栈，无法追踪，请使用log,DLog代替.')
    end
    if not enable_level_1 then
        return;
    end
    oldPrint(...)
end

--输出日志--
function log(str)
    if not enable_level_1 then
        return;
    end
    local trace = debug.traceback(str, 3)
    oldPrint(trace)
end

--警告日志--
local unity_debug_warning = CS.UnityEngine.Debug.LogWarning
function logWarn(str)
    if not enable_level_2 then
        return;
    end
    local trace = debug.traceback(str, 3)
    unity_debug_warning(trace)
end

--错误日志--
local unity_debug_error = CS.UnityEngine.Debug.LogError
function logError(str)
    if not enable_level_3 then
        return;
    end
    local trace = debug.traceback(str, 3)
    unity_debug_error(trace)
end

DLog = log
WLog = logWarn
ELog = logError







-- 当某个地方被重复调用而不好定位的时候,可以使用
-- assertNoCallTimes(2) 当第二次被触发的时候,就会断言
function assertNoCallTimes(times)
  if not assertCalTimes then
    assertCalTimes = 0;
  end
  assertCalTimes = assertCalTimes + 1;
  if assertCalTimes >= times then
    assert(false);
  end
end


function findRecursive(trans, name, ignoreCase)
  return unity.Util.FindRecursive(trans, name, ignoreCase or false) 
end

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v) or 'nil'
end

local lookupTable = {}
local function dump_table(result,value, description, indent, nest, max_next,keylen)

    local spc = ""
    if type(keylen) == "number" then
        spc = string.rep(" ", keylen - string.len(dump_value_(description)))
    end
    if type(value) == "userdata" and tostring(value) == "FairyGUI.LuaWindow" then
        result[#result + 1 ] = string.format("%s面板:%s --数据:%s", indent, value.uiName, tostring(value.data))
    elseif type(value) ~= "table" then
        result[#result +1 ] = string.format("%s[%s]%s = %s,", indent, dump_value_(description), spc, dump_value_(value))
    elseif lookupTable[tostring(value)] then
        result[#result +1 ] = string.format("%s[%s]%s = '*REF*',", indent, dump_value_(description), spc)
    else
        lookupTable[tostring(value)] = true
        if nest > max_next then
            result[#result +1 ] = string.format("%s[%s] = '*MAX NESTING*',", indent, dump_value_(description))
        else
            result[#result +1 ] = string.format("%s[%s] = {", indent, dump_value_(description))
            local indent2 = indent.."    "
            local keys = {}
            local keylen = 0
            local values = {}
            for k, v in pairs(value) do
                keys[#keys + 1] = k
                local vk = dump_value_(k)
                local vkl = string.len(vk)
                if vkl > keylen then keylen = vkl end
                values[k] = v
            end
            table.sort(keys, function(a, b)
                if type(a) == "number" and type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b)
                end
            end)
            for i, k in ipairs(keys) do
                dump_table(result,values[k], k, indent2, nest + 1, max_next,keylen)
            end
            result[#result +1] = string.format("%s},", indent)
        end
    end
end

function dump(value, description, max_nest,tofile)
    if not DebugVersion then
        return;
    end
    description = description or "<var>"
    log(description..inspect(value))
    --lookupTable = {}
    --local result = {}
    --description = description or "<var>"
    --max_nest = max_nest or 3
    --local traceback = string.split(debug.traceback("", 2), "\n")
    --description = "dump from: " .. string.trim(traceback[3])..'\n'..description
    --
    --dump_table(result,value, description,"    ", 1,max_nest)
    --
    --local content = ''
    --for i, line in ipairs(result) do
    --    content = content..line..'\n'
    --end
    --
    --if tofile then
    --    local fileName = "dump_for_"..description..".txt";
    --    local folder = unity.Util.WriteablePath.."dump";
    --    unity.Util.CreateDirectory(folder);
    --    local path = folder.."/"..fileName;
    --    local util = require("cjson.util")
    --    util.file_save(path,content);
    --    log("写入dump数据，位置:"..path);
    --else
    --    print(content)
    --end
end

function dump_to_str(t, desc, maxNest)
    maxNest = maxNest or 3
    local result = {}
    lookupTable = {}
    dump_table(result,  t, desc, "- ",1, maxNest,1)
    local text = table.concat(result, '\n')
    return text
end

local val_to_str, key_to_str
function table_to_string( tbl )
    local result, done = {}, {}
    for k, v in ipairs( tbl ) do
        table.insert( result, val_to_str( v ) )
        done[ k ] = true
    end
    for k, v in pairs( tbl ) do
        if not done[ k ] then
            table.insert( result,
                    key_to_str( k ) .. "=" .. val_to_str( v ) )
        end
    end
    return "{" .. table.concat( result, "," ) .. "}"
end

val_to_str = function  ( v )
    if "string" == type( v ) then
        v = string.gsub( v, "\n", "\\n" )
        if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
    else
        return "table" == type( v ) and table_to_string( v ) or
                tostring( v )
    end
end

key_to_str = function  ( k )
    if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
        return k
    else
        return "[" .. table_to_string( k ) .. "]"
    end
end

function checknumber(value, base)
    return tonumber(value, base) or 0
end

function checkint(value)
    return math.round(checknumber(value))
end

function checkbool(value)
    return (value ~= nil and value ~= false)
end

function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end

function isset(hashtable, key)
    local t = type(hashtable)
    return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end

function isNull(go)
  return go == nil or go:Equals(nil);
end


function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end


function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

function io.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

function io.byteFilesize(path)
    local byteFile = io.open(path, "rb") --打开二进制文件
    if byteFile then
        local len = byteFile:seek()
        size = byteFile:seek("end")
        byteFile:seek("set", len)
        io.close(byteFile)
    end
    return size
end


local function array_wrap(t)
  return { items = t,len = t.Length }

end

local function _array_iter(arr, i) 
  if i >= arr.len then
    return
  end
  local value = arr.items[i]
  if value == nil then return end
  i = i + 1
  return i, value
end
---
-- for循环中遍历c#数组
-- 通过在包装器中提前处理好数组长度防止越界
-- 包装器只会读取一次Length,防止不小心在迭代中每次都读取Length带来的性能损耗
-- eg.
-- for key, var in array_iter(c_sharp_array) do
--   print(key);
--   print(var);
-- end
function array_iter(t) return _array_iter, array_wrap(t), 0 end


---
-- 以key作为迭代器函数
-- 在迭代器初始化的时候建立临时数组做排序，有一定代价
-- eg.
-- local function __orderedByKeys(t)
--  return orderedByKeys(t,function(k1,k2)
--    return k1 < k2;
--  end);
-- end
-- for k,v in __orderedByKeys(t)
--  -- in k orders
-- end
function orderedByKeys (t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[a[i]]
    end
  end
  return iter
end

---
-- 以value值作为迭代器函数
-- 在迭代器初始化的时候建立临时数组做排序，有一定代价
-- 注意，会将key以[__key]为键值插入到value中,会带来一定影响。请小心使用
-- eg.
-- local function __orderedByValues(t)
--  return orderedByValues(t,function(v1,v2)
--    return v1.what < v2.what;
--  end);
-- end
-- for k,v in __orderedByValues(t)
--  -- in v orders
-- end
function orderedByValues (t, f)
  local a = {}
  for n,v in pairs(t) do v.__key = n;table.insert(a, v) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i].__key, a[i]
    end
  end
  return iter
end

function ascByKey(t,sortKey)
  if sortKey then
    return orderedByKeys(t,function(k1,k2)
      return k1[sortKey] < k2[sortKey];
    end)
  else
    return orderedByKeys(t,function(k1,k2)
      return k1 < k2;
    end)
  end
end

function dscByKey(t,sortKey)
  if sortKey then
    return orderedByKeys(t,function(k1,k2)
      return k2[sortKey] < k1[sortKey];
    end)
  else
    return orderedByKeys(t,function(k1,k2)
      return k2 < k1;
    end)
  end
end

function ascByValue(t,sortKey)
  if sortKey then
    return orderedByValues(t,function(k1,k2)
      return k1[sortKey] < k2[sortKey];
    end)
  else
    return orderedByValues(t,function(k1,k2)
      return k1 < k2;
    end)
  end
end

function dscByValue(t,sortKey)
  if sortKey then
    return orderedByValues(t,function(k1,k2)
      return k2[sortKey] < k1[sortKey];
    end)
  else
    return orderedByValues(t,function(k1,k2)
      return k2 < k1;
    end)
  end
end

function wrapBool(value)
  if value then
    return 1;
  else
    return 0;
  end
end

fmt = string.format

toint = math.floor

--require "bit"

--按位取值
function GetBit(value, index)
  --local num = bit.rshift(value, index)
  --return bit.band(num, 1)
    return  value >> index & 1
end
--设置位值
function SetBit(value, index, bitValue)
  --local bLeft = bit.rshift(value, index+1)
  --bLeft = bit.lshift(bLeft, index+1)
  --local bMiddle = bit.lshift(bitValue, index)
  --local bRight = bit.rshift(value, index)
  --bRight = bit.lshift(bRight, index)
  --bRight = value - bRight
  --return bit.bor(bLeft, bMiddle, bRight)
    local bLeft = value >> index + 1
    bLeft = bLeft << index + 1
    local bMiddle = bitValue << index
    local bRight = value >> index
    bRight = bRight >> index
    bRight = value - bRight
    return bLeft | bMiddle | bRight
end
--计算其中位值为1的数量
function GetBitStep(value, max)
  if max == nil then
    max = 32
  end
  local step = 0
  for i=0,max-1 do
    if GetBit(value, i) > 0 then
      step = step + 1
    end
  end
  return step
end

--处理pairs不能按下标顺序取值的问题
function PairsByKeys(t)
    local a = {}
    for n in pairs(t) do a[#a + 1] = n end
    table.sort(a)
    local i = 0
    return function ()
        i = i + 1
        return a[i], t[a[i]]
    end
end


function testbit(val,index)
    return (val >> index & 1) == 1
end

function testbit32_high(val,index)
    return (val >> (index + 32) & 1) == 1
end

function testbit32_low(val,index)
    return (val >> index & 1) == 1
end

--- test bit for lua53 uint64 structure
--function testbit64_uint(val,index)
--    local low,high = uint64.tonum2(val)
--    if index > 31 then
--        return (high >> (index - 31) & 1) == 1
--    else
--        return (low >> index & 1) == 1
--    end
--end