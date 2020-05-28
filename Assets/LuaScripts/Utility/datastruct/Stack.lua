local Stack = class("Stack")
-- 新建并初始化栈
function Stack:ctor()
    self.stack_table = {}
end
-- 入栈
function Stack:push(element)
    local size = self:size()
    self.stack_table[size + 1] = element
end
-- 出栈
function Stack:pop()
    local size = self:size()
    if self:isEmpty() then
        print("Stack is empty!")
        return
    end
    return table.remove(self.stack_table,size)
end
-- 获取栈顶元素
function Stack:seek()
    local size = self:size()
    if self:isEmpty() then
        print("Stack is empty!")
        return
    end
    return self.stack_table[size]
end
-- 是否为空栈
function Stack:isEmpty()
    local size = self:size()
    if size == 0 then
        return true
    end
    return false
end

function Stack:contains(e)
    for k,v in pairs(self.stack_table) do
        if e == v then
            return true
        end
    end
    return false
end
-- 栈大小
function Stack:size()
    return table.nums(self.stack_table) or 0
end
-- 清空栈
function Stack:clear()
    self.stack_table = nil
    self.stack_table = {}
end

return Stack