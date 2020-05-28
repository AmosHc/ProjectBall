-- lua对象池
--[[ example
    local pool = Pool.create("Damage", 16, function ()
        return {value = 0.0, attacker = 0, flag = 0}
    end)

    local obj = pool:get() -- or local obj = Pool.get("Damage")

    ...使用obj

    pool:free(obj) -- or Pool.free("Damage", obj)
--]]
local Pool = {}

local kIsDebugPool = false

Pool.on = true

local DefaultPoolSize = 4



-- 带Debug信息
local function createPoolObjWithDebugInfo(pool,creator)
    local obj = nil
    if creator then
        obj = creator()
    else
        obj = {}
    end

    pool.curObjId = pool.curObjId + 1
    obj.objId = pool.curObjId
    log("[pool-"..pool.tag.."]create,cur free count:"..tostring(#pool.freeObjects))

    return obj
end

-- 原版
local function createPoolObj(creator)
    return creator and creator() or {}
end


local pools = {}
-- 创建对象池
-- @tag 对象池标签
-- @poolSize 初始大小
-- @creator 对象构造函数
-- @resetor 重置函数
function Pool.create( tag, poolSize, creator, resetor)
    local pool = pools[tag]

    if pool == nil then
        poolSize = poolSize or DefaultPoolSize

        local freeObjects = {}
        pool = {freeObjects = freeObjects, creator = creator, tag = tag}

        local createObjFunc = createPoolObj
        if kIsDebugPool then
            pool.usingObjs = {}
            pool.curObjId = 0

            createObjFunc = function(originCreator)
                return createPoolObjWithDebugInfo(pool,originCreator)
            end
        end

        for _ = 1, poolSize do
            table.insert( freeObjects,createObjFunc(creator))
        end

        pool.get = function (self)
            local obj
            if Pool.on then
                if next(self.freeObjects) then
                    obj = table.remove(self.freeObjects)
                else
                    obj = createObjFunc(self.creator)

                end

                if kIsDebugPool then
                    log("[pool-"..self.tag.."]get,cur free count:"..tostring(#self.freeObjects))
                    local info = self.usingObjs[obj.objId]
                    if info == nil then
                        info = { trace = '',obj = nil }
                        self.usingObjs[obj.objId] = info
                    end
                    info.obj = obj
                    local trace = debug.traceback('', 3)
                    info.trace = trace
                end
            else
                obj = createObjFunc(self.creator)
            end
            obj.__inPool = false


            return obj
        end

        pool.free = function (self, obj)
            assert(obj, "ojb to be freeed can't be null")
            if obj.__inPool == nil or obj.__inPool then
                return
            end
            if Pool.on then
                table.insert( self.freeObjects, obj)
                obj.__inPool = true
                if resetor then resetor(obj) end
                if obj.OnReset then obj.OnReset(obj) end

                if kIsDebugPool then
                    log("[pool-"..self.tag.."]free,cur free count:"..tostring(#self.freeObjects))
                    local info = self.usingObjs[obj.objId]
                    if info == nil then
                        logError(string.format('Invalid pool obj[%s-%d] state: not in using',self.tag,obj.objId))
                    else
                        self.usingObjs[obj.objId] = nil
                    end
                end
            end
        end

        pool.clear = function (self)
            --print(string.format("clear pool %s, objects count:%d", self.tag, #self.freeObjects))
            for k in pairs(self.freeObjects) do
                local obj = self.freeObjects[k]
                if obj.OnDispose then
                    obj:OnDispose()
                end
                self.freeObjects[k] = nil
            end
        end

        if kIsDebugPool then
            pool.showUsing = function(self)
                local usingObjs = self.usingObjs
                local count = 0
                for i, v in pairs(usingObjs) do
                    count = count + 1
                end
                log(string.format('[pool-%s] has using %d objs',self.tag,count))
                if count > 0 then
                    for i, v in pairs(usingObjs) do
                        log(string.format('[obj-%d] %s',tostring(v.obj.objId),v.trace))
                    end
                else

                end
            end
        end

        pools[tag] = pool
    end

    return pool
end

-- 获取对象池对象
function Pool.getPool(tag)
    local pool = pools[tag]
    assert(pool, "Should create pool before get")
    return pool
end

-- 从对象池获取对象
-- @tag 对象池标签
function Pool.get(tag)
    local pool = pools[tag]
    assert(pool, "Should create pool before get")

    return pool:get()
end

-- 回收对象
-- @tag 对象池标签
-- @obj 要回收的对象
function Pool.free(tag, obj)
    local pool = pools[tag]
    assert(pool, "Shoud create pool before free")

    pool:free(obj)
end

-- 清理对象池
function Pool.clear()
    for _, p in pairs(pools) do
        p:clear()
    end
end

function Pool.dump()
    for tag, pool in pairs(pools) do
        log("pool "..tag.." object count: "..#pool.freeObjects )
    end
end

if kIsDebugPool then
    function Pool.showUsing()
        for tag, pool in pairs(pools) do
            pool:showUsing()
        end
    end
end

return Pool