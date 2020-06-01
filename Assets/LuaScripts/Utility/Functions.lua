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
    LuaHelper.SetLogLevel(level)
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

--序列化.
function serialize(t)
    if t == nil then
        return "is nil"
    end
    local mark = {}
    local assign = {}

    local function table2str(t, parent)
        mark[t] = parent
        local ret = {}

        if "table" == type(t) then
            for i, v in pairs(t) do
                local k = tostring(i)
                local dotkey = parent .. "[" .. k .. "]"
                local t = type(v)
                if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
                    --ignore  
                elseif t == "table" then
                    if mark[v] then
                        table.insert(assign, dotkey .. "=" .. mark[v])
                    else
                        table.insert(ret, table2str(v, dotkey))
                    end
                elseif t == "string" then
                    table.insert(ret, string.format("%q", v))
                elseif t == "number" then
                    if v == math.huge then
                        table.insert(ret, "math.huge")
                    elseif v == -math.huge then
                        table.insert(ret, "-math.huge")
                    else
                        table.insert(ret, tostring(v))
                    end
                else
                    table.insert(ret, tostring(v))
                end
            end
        else
            for f, v in pairs(t) do
                local k = type(f) == "number" and "[" .. f .. "]" or f
                local dotkey = parent .. (type(f) == "number" and k or "." .. k)
                local t = type(v)
                if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
                    --ignore  
                elseif t == "table" then
                    if mark[v] then
                        table.insert(assign, dotkey .. "=" .. mark[v])
                    else
                        table.insert(ret, string.format("%s=%s", k, table2str(v, dotkey)))
                    end
                elseif t == "string" then
                    table.insert(ret, string.format("%s=%q", k, v))
                elseif t == "number" then
                    if v == math.huge then
                        table.insert(ret, string.format("%s=%s", k, "math.huge"))
                    elseif v == -math.huge then
                        table.insert(ret, string.format("%s=%s", k, "-math.huge"))
                    else
                        table.insert(ret, string.format("%s=%s", k, tostring(v)))
                    end
                else
                    table.insert(ret, string.format("%s=%s", k, tostring(v)))
                end
            end
        end

        return "{" .. table.concat(ret, ",") .. "}"
    end

    if type(t) == "table" then
        return string.format("%s%s", table2str(t, "_"), table.concat(assign, " "))
    else
        return tostring(t)
    end
end

function printf(fmt, ...)
    print(string.format(tostring(fmt), ...))
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
    if type(value) ~= "table" then
        value = {}
    end
    return value
end

function isset(hashtable, key)
    local t = type(hashtable)
    return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then
            mt = {}
        end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function class(classname, ...)
    local cls = { __cname = classname }

    local supers = { ... }
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
                string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                        classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function",
                            classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                        string.format("class() - create class \"%s\" with more than one creating function or native class",
                                classname));
                cls.__create = function()
                    return super:create()
                end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                    classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, { __index = cls.super })
    else
        setmetatable(cls, { __index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then
                    return super[key]
                end
            end
        end })
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function()
        end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    return cls
end

local binding_map_mt = { __mode = 'k' }
local binding_map = {}
setmetatable(binding_map, binding_map_mt);

function bind(fun, ...)
    local bparams = { ... }
    local r = function(...)
        local params = { ... }
        for i, var in ipairs(bparams) do
            table.insert(params, i, var)
        end
        return fun(unpack(params));
    end
    binding_map[r] = { f = fun, p = bparams }
    return r;
end

local iskindof_
iskindof_ = function(cls, name)
    local __index = rawget(cls, "__index")
    if type(__index) == "table" and rawget(__index, "__cname") == name then
        return true
    end

    if rawget(cls, "__cname") == name then
        return true
    end
    local __supers = rawget(cls, "__supers")
    if not __supers then
        return false
    end
    for _, super in ipairs(__supers) do
        if iskindof_(super, name) then
            return true
        end
    end
    return false
end

function iskindof(obj, classname)
    local t = type(obj)
    if t ~= "table" and t ~= "userdata" then
        return false
    end

    local mt
    if t == "userdata" then
        if tolua.iskindof(obj, classname) then
            return true
        end
        mt = tolua.getpeer(obj)
    else
        mt = getmetatable(obj)
    end
    if mt then
        return iskindof_(mt, classname)
    end
    return false
end

function import(moduleName, currentModuleName)
    local currentModuleNameParts
    local moduleFullName = moduleName
    local offset = 1

    while true do
        if string.byte(moduleName, offset) ~= 46 then
            -- .
            moduleFullName = string.sub(moduleName, offset)
            if currentModuleNameParts and #currentModuleNameParts > 0 then
                moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
            end
            break
        end
        offset = offset + 1

        if not currentModuleNameParts then
            if not currentModuleName then
                local n, v = debug.getlocal(3, 1)
                currentModuleName = v
            end

            currentModuleNameParts = string.split(currentModuleName, ".")
        end
        table.remove(currentModuleNameParts, #currentModuleNameParts)
    end

    return require(moduleFullName)
end

--重新require一个lua文件，替代系统文件。
function reimport(name)
    deleteFile(name)
    return require(name)
end

function deleteFile(name)
    local package = package
    name = string.gsub(name,'/','.')
    package.loaded[name] = nil
    package.preload[name] = nil
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function math.newrandomseed()
    local ok, socket = pcall(function()
        return require("socket")
    end)

    if ok then
        math.randomseed(socket.gettime() * 1000)
    else
        math.randomseed(os.time())
    end
    math.random()
    math.random()
    math.random()
    math.random()
end

function math.round(value)
    value = checknumber(value)
    return math.floor(value + 0.5)
end

local pi_div_180 = math.pi / 180
function math.angle2radian(angle)
    return angle * pi_div_180
end

local pi_mul_180 = math.pi * 180
function math.radian2angle(radian)
    return radian / pi_mul_180
end

function math.isNaN(value)
    return value ~= value
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.keys(hashtable)
    local keys = {}
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end


function table.sync(to,from)
    for key, var in pairs(from) do
        if type(var) == "table" then
            if to[key] == nil then
                to[key] = {};
            end
            table.sync(to[key],var);
        else
            to[key] = var;
        end
    end

end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.insertto(dest, src, begin)
    begin = checkint(begin)
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then
            return i
        end
    end
    return false
end

function table.IndexOf(array, value)
    for i = 1, #array do
        if array[i] == value then return i end
    end
    return 0
end

function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.removeItem(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then
                break
            end
        end
        i = i + 1
    end
    return c
end

function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end


function table.removeMatch(array,key,value)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i][key] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

function table.updateMatch(array,key,value,key1,value1)
    local c, i, max = 0, 1, #array
    while i <= max do
        print(key,value,key1,value1,array[i][key])
        if array[i][key] == value then
            print("table.updateMatch")
            array[i][key1] = value1
            c = c + 1
            i = i - 1
            max = max - 1
            break
        end
        i = i + 1
    end
    return c
end

function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

function table.walk(t, fn)
    for k, v in pairs(t) do
        fn(v, k)
    end
end

function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then
            t[k] = nil
        end
    end
end

function table.unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

function table.hasValue(t, v)
    return table.values(t)[v]
end

function table.values(t)
    local _t = {}
    for k, v in pairs(t) do
        _t[v] = true
    end
    return _t
end

local function exportstring( s )
    return string.format("%q", s)
end

function table.save(  tbl, filename )
    local charS, charE = "   ", "\n"
    local file, err = io.open( filename, "wb" )
    if err then
        return err
    end

    local tables, lookup = { tbl }, { [tbl] = 1 }
    file:write( "return {" .. charE )
    for idx, t in ipairs( tables ) do
        file:write( "-- Table: {" .. idx .. "}" .. charE )
        file:write( "{" .. charE )
        local thandled = {}

        for i, v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            if stype == "table" then
                if not lookup[v] then
                    table.insert( tables, v )
                    lookup[v] = #tables
                end
                file:write( charS .. "{" .. lookup[v] .. "}," .. charE )
            elseif stype == "string" then
                file:write(  charS .. exportstring( v ) .. "," .. charE )
            elseif stype == "number" then
                file:write(  charS .. tostring( v ) .. "," .. charE )
            elseif stype == "boolean" then
                file:write(  charS .. (v and "true" or "false") .. "," .. charE )
            end
        end

        for i, v in pairs( t ) do
            if (not thandled[i]) then
                local str = ""
                local stype = type( i )
                if stype == "table" then
                    if not lookup[i] then
                        table.insert( tables, i )
                        lookup[i] = #tables
                    end
                    str = charS .. "[{" .. lookup[i] .. "}]="
                elseif stype == "string" then
                    str = charS .. "[" .. exportstring( i ) .. "]="
                elseif stype == "number" then
                    str = charS .. "[" .. tostring( i ) .. "]="
                elseif stype == "boolean" then
                    str = charS .. "[" .. (v and "true" or "false") .. "]="
                end

                if str ~= "" then
                    stype = type( v )
                    if stype == "table" then
                        if not lookup[v] then
                            table.insert( tables, v )
                            lookup[v] = #tables
                        end
                        file:write( str .. "{" .. lookup[v] .. "}," .. charE )
                    elseif stype == "string" then
                        file:write( str .. exportstring( v ) .. "," .. charE )
                    elseif stype == "number" then
                        file:write( str .. tostring( v ) .. "," .. charE )
                    elseif stype == "boolean" then
                        file:write(  str .. (v and "true" or "false") .. "," .. charE )
                    end
                end
            end
        end
        file:write( "}," .. charE )
    end
    file:write( "}" )
    file:close()
end

function table.load( sfile )
    local ftables, err = loadfile( sfile )
    if err then
        return _, err
    end
    local tables = ftables()
    for idx = 1, #tables do
        local tolinki = {}
        for i, v in pairs( tables[idx] ) do
            if type( v ) == "table" then
                tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
                table.insert( tolinki, { i, tables[i[1]] } )
            end
        end
        for _, v in ipairs( tolinki ) do
            tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
        end
    end
    return tables[1]
end

string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.htmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, k, v)
    end
    return input
end

function string.restorehtmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, v, k)
    end
    return input
end

function string.nl2br(input)
    return string.gsub(input, "\n", "<br />")
end

function string.text2html(input)
    input = string.gsub(input, "\t", "    ")
    input = string.htmlspecialchars(input)
    input = string.gsub(input, " ", "&nbsp;")
    input = string.nl2br(input)
    return input
end

function string.splitToNumber(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == '') then
        return false
    end
    local pos, arr = 0, {}
    for st, sp in function()
        return string.find(input, delimiter, pos, true)
    end do
        table.insert(arr, string.sub(input, pos, st - 1) * 1)
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos) * 1)
    return arr
end

function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.ucfirst(input)
    return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

local function urlencodechar(char)
    return "%" .. string.format("%02X", string.byte(char))
end
function string.urlencode(input)
    input = string.gsub(tostring(input), "\n", "\r\n")
    input = string.gsub(input, "([^%w%.%- ])", urlencodechar)
    return string.gsub(input, " ", "+")
end

function string.urldecode(input)
    input = string.gsub(input, "+", " ")
    input = string.gsub(input, "%%(%x%x)", function(h)
        return string.char(checknumber(h, 16))
    end)
    input = string.gsub(input, "\r\n", "\n")
    return input
end

function string.utf8len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

function string.utf8tochars(input)
    local list = {}
    local len = string.len(input)
    local index = 1
    local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while index <= len do
        local c = string.byte(input, index)
        local offset = 1
        if c < 0xc0 then
            offset = 1
        elseif c < 0xe0 then
            offset = 2
        elseif c < 0xf0 then
            offset = 3
        elseif c < 0xf8 then
            offset = 4
        elseif c < 0xfc then
            offset = 5
        end
        local str = string.sub(input, index, index + offset - 1)
        index = index + offset
        table.insert(list, { byteNum = offset, char = str })
    end

    return list
end

function string.checkASCII(input)
    local len = string.len(input)
    local index = 1
    local arr = 0xc0
    while index <= len do
        local c = string.byte(input, index)
        if c >= 0xc0 then
            return false
        end
        index = index + 1
    end
    return true
end

function string.utf8toSub(content, bIdex, eIdex)
    local chars = string.utf8tochars(content)
    local nums = 0
    local newString = ""
    for i, v in ipairs(chars or {}) do
        if i >= bIdex and i <= eIdex then
            newString = newString .. v.char
            nums = nums + 1
        elseif i > eIdex then
            break
        end
    end
    return newString
end

function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

function string.isNilOrEmpty(str)
    return str == nil or str == ''
end


function string.endswith(input, substr)
    if input == nil or substr == nil then
        return nil, "the string or the sub-string parameter is nil"
    end
    local str_tmp = string.reverse(input)
    local substr_tmp = string.reverse(substr)
    if string.find(str_tmp, substr_tmp) ~= 1 then
        return false
    else
        return true
    end
end

function readonly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(t, k, v)
            error("!!readonly!!", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end


function Bounds2Rect(bounds)
    local origin = Camera.main:WorldToScreenPoint(Vector3.New(bounds.min.x, bounds.max.y, bounds.center.z))
    local extend = Camera.main:WorldToScreenPoint(Vector3.New(bounds.max.x, bounds.min.y, bounds.center.z))
    return Rect.New(origin.x, Screen.height - origin.y, extend.x - origin.x, origin.y - extend.y)
end

function safe_call(func,...)
    if jit then
        return xpcall(func, traceback, ...)
    else
        local args = {...}
        local func = function() func(unpack(args)) end
        return xpcall(func, traceback)
    end
end

function count_call(label,count,call)
    if not DebugVersion then
        return
    end
    local dt = rawget(_G,label)
    if dt == nil then
        dt = 0
        rawset(_G,label,dt)
    end
    if dt > count then
        dt = 0
        call()
    else
        dt = dt + 1
    end
    rawset(_G,label,dt)

end

--拷贝一个值而不是引用
function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key,orig_value in next,orig,nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy,DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end