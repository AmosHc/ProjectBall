--链表队列
local LinkedQueue = class("LinkedQueue")
local LinkedList = require("Utility/datastruct/LinkedList")

-- 新建并初始化队列
function LinkedQueue:ctor()
    self.LinkedQueue_table = LinkedList.new()
end
-- 入队列
function LinkedQueue:enQueue(element)
    self.LinkedQueue_table:InsertToLast(element)
end
-- 出队列
function LinkedQueue:deQueue()
    if self:isEmpty() then
        return 
    end
    return self.LinkedQueue_table:RemoveToHead()
end
-- 是否空队列
function LinkedQueue:isEmpty()
    return self.LinkedQueue_table:IsEmpty()
end
-- 队列大小
function LinkedQueue:size()
    return self.LinkedQueue_table:Size()
end
-- 删除元素
function LinkedQueue:Remove(e)
    local t = self:FindNode(e)
    if t ~= nil then
        self.LinkedQueue_table:Remove(t)
    end
end
-- 清空队列
function LinkedQueue:clear()
    self.LinkedQueue_table:Clear()
end
-- 打印队列元素
function LinkedQueue:printElement()
    self.LinkedQueue_table:PrintElement()
end
--UIMgr调试用接口：打印堆栈所有UI元素
function LinkedQueue:printUIElement()
    self.LinkedQueue_table:PrintUIElement()
end

--检查队列是否包含指定元素
function LinkedQueue:Contains(element)
    return self.LinkedQueue_table:FindNode(element) ~= nil
end

--移动指定元素到队头
function LinkedQueue:MoveToHead(element)
    local node = self.LinkedQueue_table:FindNode(element)
    if node then
        self.LinkedQueue_table:Remove(node)
        self.LinkedQueue_table:InsertToHead(element)
        return true
    else
        print("not find element")
        return false
    end
end
--移动指定元素到队尾
function LinkedQueue:MoveToLast(element)
    local node = self.LinkedQueue_table:FindNode(element)
    if node then
        self.LinkedQueue_table:Remove(node)
        self.LinkedQueue_table:InsertToLast(element)
        return true
    else
        print("not find element")
        return false
    end
end

return LinkedQueue