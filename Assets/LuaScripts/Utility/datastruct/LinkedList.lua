local LinkedList = class("LinkedList")

function LinkedList:ctor()
  self.length = 0
  self.nodeDic = {} --节点键值对，key是值，value是节点
end
--setmetatable(LinkedList, { __call = function(_, ...)
--  local t = setmetatable({ length = 0 }, LinkedList)
--  for _, v in ipairs{...} do t:push(v) end
--  return t
--end })
--添加一个元素到链表末尾
function LinkedList:InsertToLast(element)
  if element then
    t = {_value = element}
    if self.last then
      self.last._next = t
      t._prev = self.last
      self.last = t
    else
      -- this is the first node
      self.first = t
      self.last = t
    end

    self.nodeDic[element] = t
    self.length = self.length + 1
  end
end
--插入节点到表头
function LinkedList:InsertToHead(element)
  if element then
    t = {_value = element}
    if self.first then
      self.first._prev = t
      t._next = self.first
      self.first = t
    else
      -- this is the first node
      self.first = t
      self.last = t
    end

    self.nodeDic[element] = t
    self.length = self.length + 1
  end
end
--把元素插入到链表的After节点之后，如果没有指定after，且当链表里没有其他节点时，添加这个元素
function LinkedList:Insert(element, after)
  if element then
    t = {_value = element}
    if after then
      if after._next then
        after._next._prev = t
        t._next = after._next
      else
        self.last = t
      end
      
      t._prev = after    
      after._next = t
    elseif not self.first then
      -- this is the first node
      self.first = t
      self.last = t
    end
    
    self.nodeDic[element] = t
    self.length = self.length + 1
  end
end
--移除列表最后一个元素并返回
function LinkedList:RemoveToLast()
  if not self.last then return end
  local ret = self.last
  
  if ret._prev then
    ret._prev._next = nil
    self.last = ret._prev
    ret._prev = nil
  else
    -- this was the only node
    self.first = nil
    self.last = nil
  end
  
  self.length = self.length - 1
  self.nodeDic[ret._value] = nil
  return ret._value
end
--移除列表第一个元素并返回
function LinkedList:RemoveToHead()
  if not self.first then return end
  local ret = self.first

  if ret._next then
    ret._next._prev = nil
    self.first = ret._next
    ret._next = nil
  else
    -- this was the only node
    self.first = nil
    self.last = nil
  end

  self.length = self.length - 1
  self.nodeDic[ret._value] = nil
  return ret._value
end
--删除指定节点 t为节点（可以通过findNode得到）
function LinkedList:Remove(t)
  if not t then return end
  if t._next then
    if t._prev then
      t._next._prev = t._prev
      t._prev._next = t._next
    else
      -- this was the first node
      t._next._prev = nil
      self.first = t._next
    end
  elseif t._prev then
    -- this was the last node
    t._prev._next = nil
    self.last = t._prev
  else
    -- this was the only node
    self.first = nil
    self.last = nil
  end
 
  t._next = nil
  t._prev = nil
  self.nodeDic[t._value] = nil
  t._value = nil
  self.length = self.length - 1
end
--迭代器
local function iterate(self, current)
  if not current then
    current = self.first
  elseif current then
    current = current._next
  end
  
  return current
end
--返回迭代器 返回的value是节点，value._value才是元素值 用法参考printElement
function LinkedList:iterate()
  return iterate, self, nil
end
-- 是否空链表
function LinkedList:IsEmpty()
  return self.length == 0
end
-- 链表长度
function LinkedList:Size()
  return self.length
end
--查找指定值元素所在的节点
function LinkedList:FindNode(element)
  if not element then return end
  return self.nodeDic[element]
end
--清空链表
function LinkedList:Clear()
  self.length = 0
  self.nodeDic = {}
  self.first = nil
  self.last = nil
end

--UIMgr调试用接口：打印链表所有UI元素
function LinkedList:PrintElement()
  if self:IsEmpty() then
    print("LinkedQueue is empty!")
    return
  end
  local str = nil
  local first_flag = true
  for node in self:iterate() do
    if first_flag == true then
      str = "链表元素----:{"..node._value
      first_flag = false
    else
      str = str..","..node._value
    end
  end
  str = str.."}"
  print(str)
end
--打印链表所有元素
function LinkedList:PrintUIElement()
  if self:IsEmpty() then
    print("LinkedQueue is empty!")
    return
  end
  local str = nil
  local first_flag = true
  for node in self:iterate() do
    if first_flag == true then
      str = "链表元素----:{"..node._value.uiName
      first_flag = false
    else
      str = str..","..node._value.uiName
    end
  end
  str = str.."}"
  WLog(str)
end

return LinkedList