local Queue = class("Queue")
-- 默认队列容量
local default_capacity = 10000;
-- 新建并初始化队列
function Queue:ctor()
    self.capacity = default_capacity
    self.queue_table = {}
    self.size_ = 0
    self.rear = 0
    self.head = 0
end
-- 入队列
function Queue:enQueue(element)
    if self.size_ == 0 then
        self.head = 0
        self.rear = 1
        self.size_ = 1
        self.queue_table[self.rear] = element
    else 
        local temp = (self.rear + 1) % self.capacity
        if temp == self.head then 
            print("Queue is full!")
            return 
        else
            self.rear = temp
        end
        self.queue_table[self.rear] = element
        self.size_ = self.size_ + 1
    end
end
-- 出队列
function Queue:deQueue()
    if self:isEmpty() then
        print("Queue is empty!")
        return 
    end
    self.size_ = self.size_ - 1
    self.head = (self.head + 1) % self.capacity
    local value = self.queue_table[self.head]
    -- self.queue_table[self.head] = nil -- 对于table，如果元素中含有nil，则nil之后的所有元素都不存在，比如 {‘a’,nil,'b'} 其实为 {‘a’}，所以这里元素不能设置为nil
    return value
end
-- 是否空队列
function Queue:isEmpty()
    return self:size() == 0
end
-- 队列大小
function Queue:size()
    return self.size_
end
-- 清空队列
function Queue:clear()
    self.queue_table = nil
    self.queue_table = {}
    self.size_ = 0
    self.head = 0
    self.rear = 0
end

-- 打印队列元素
function Queue:printElement()
    local h = self.head
    local r = self.rear
    if h == r then 
        print("Queue is empty!")
        return
    end
    local str = nil
    local first_flag = true
    while h ~= r do
        if first_flag == true then
            str = "{"..self.queue_table[h + 1]
            h = (h + 1) % self.capacity
            first_flag = false
        else
            str = str..","..self.queue_table[h+1]
            h = (h+1) % self.capacity
        end
    end
    str = str.."}"
    print(str)
end

--检查是否包含指定元素
function Queue:Exist(element)
    local h = self.head
    local r = self.rear
    if h == r then
        print("Queue is empty!")
        return
    end
    while h ~= r do
        if self.queue_table[h + 1] == element then
            return true
        end
        h = h + 1
    end
    return false
end

return Queue