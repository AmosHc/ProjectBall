
local GCTool = {}

-- 是否手动步进gc
-- 开启意味着手动由逻辑在循环中定帧步进调用
-- 默认为true
local kGCManually = false

GCTool.setup = function()
    -- 设置初始化gc参数
    -- 收集器在总使用内存数量达到上次垃圾收集时的 100% 开启FullGC
    local cur_pause = 100
    local default_pause = collectgarbage("setpause",cur_pause)
    log(string.format('[GCTool]tolua default pause value %d,current pause value %d',default_pause,cur_pause))
    -- 收集器的运行速度为内存分配的 100% 倍(即每次实际分配值的加权值).注意,该值如果小于 100%,则会导致垃圾回收无法完成周期
    local cur_step_mul = 500
    local default_step_mul= collectgarbage("setstepmul",cur_step_mul)
    log(string.format('[GCTool]tolua default stepmul value %d,current stepmul value %d',default_step_mul,cur_step_mul))
    -- 关闭lua自动gc
    if kGCManually then
        log('使用手动GC!')
        collectgarbage('stop')
    end
end

GCTool.print = function()
    local used = collectgarbage('count')
    log(string.format('[GCTool]get lua vm mem used %.2f mb',used / 1000.0))
end

local kStepLimit = 30 -- 每30帧步进一个step,按照帧率来,这意味着,帧率越低,gc频次越低,可以减少性能负担
local kStepCapacity = 256 -- 每次步进的收集值(KB)
local kStepAmountPerSecond = (1.0 / kStepLimit) * kStepCapacity -- 每秒大致步进多少内存,当步进的内存总值达到预期收集量(~70m),则会触发FullGC
local curStepDtCount = 0
local stepTickCount = 0
GCTool.step = function()
    if not kGCManually then
        return
    end
    curStepDtCount = curStepDtCount + 1
    if curStepDtCount >= kStepLimit then
        curStepDtCount = 0
        local result = collectgarbage("step",kStepCapacity)
        if DebugVersion then
            stepTickCount = stepTickCount + 1
            -- if stepTickCount%5 == 0 then
            --     GCTool.print()
            -- end
            if result then
                local used = collectgarbage('count')
                log(string.format('[GCTool]performed a gc call.cur mem used %.2f mb.tick count %d',used / 1000.0,stepTickCount))
                stepTickCount  = 0
            end
        end
    end
end

GCTool.collect = function()
    local used1,used2
    if DebugVersion then
        used1 = collectgarbage('count')
        log(string.format('[GCTool]before lua gc,mem used %.2f mb',used1 / 1000.0))
    end
    collectgarbage()
    if DebugVersion then
        used2 = collectgarbage('count')
        log(string.format('[GCTool]after lua gc,mem used %.2f mb,diff %.2f mb',used2 / 1000.0,(used2 - used1)/ 1000.0))
    end

    if kGCManually then
        collectgarbage('stop')
    end
end

return GCTool