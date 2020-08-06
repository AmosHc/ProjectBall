local Entity = class("Entity")
local Transform = require "GamePlay/Client/Entities/Transform"
local EntityRef = require("GamePlay/Client/Entities/EntityRef")

-- Entity转换成引用的形式
function EntToRef(e)
  -- 如果e已经是个引用，直接返回
  if e ~= nil and  e.valid ~= nil then
    return e
  end

  local ref
  if e ~= nil then
    ref = e.ref
  end

  if ref == nil then
    ref = EntityRef.New(e)
    if e ~= nil then
      e.ref = ref
    end
  end

  return ref
end

-- 判断entity是否有效
function IsEntValid(e)
  -- entity
  if e == nil then
    return false
  end

  -- entity ref
  if e.valid ~= nil then
    return e.valid
  end

  return true
end

function Entity:ctor()
  self.__lastUpdateTime = TIME_NOW
  self.__listNode = {value = self, removed = true}
  self.id = 0
  self.name = "Entity"
  self.desc = ""
  self.asset = ""
  self.entityTypeId = 0
  self.job = -1
  self.race = 0
  self.type = nil
  self.unit = nil
  self.team = 0
  self.camp = 0
  self.uiRoot = nil
  self.uiPanel = nil
  self.bDestroyed = false;
  self.gridX = -1
  self.gridZ = -1
  self.systems = {}
  self.dataModel = nil
  self.effects = {}
  self.isDead = false
  self.transform = Transform.new()
  -- 是否可交互
  self.interactable = false
  -- 是否可见
  self.visible = true
  self.distance = 9999
  --隐藏标记
  self.hide = false
  
  self.lodUpdateSystems = {}

  --单位的LOD等级
  self.lodLevel = 0
  self.ignoreLod = false
  -- 是否由客户端控制的单位，如技能表现相关的entity
  self.isLocal = nil

  --出身动画状态标记
  self.spawn = true

  self.attributes = {}
  self.ref = nil
  self.attributeListeners = {}
end

function Entity:Init()
  SystemLodUpdateMgr:Attach(self)
  self.bDestroyed = false
  self.isDead = false
  self.gameObject = self.unit.gameObject
  --self.config = ConfigMgr.GetEntityConfig(self.configId, self.race)
  self.transform:Init(self)
  self.unit.lodLevel = self.lodLevel
  for _, v in pairs(self.systems) do
    v:Init()
  end

  --self:InitMsgHandlers()
  self.unit:SetLuaEntity(self)
end

function Entity:UnInit()
  SystemLodUpdateMgr:Detach(self)

  if self.eventDestroyLiseners ~= nil then
    for _, v in ipairs(self.eventDestroyLiseners) do
      if v.obj == nil then
        v.func(self)
      else
        v.func(v.obj, self)
      end
    end
    self.eventDestroyLiseners = nil
  end

  for k, v in pairs(self.systems) do
    if v.UnInit ~= nil then
      v:UnInit()
    end
  end

  self:ClearAllEffects()

  if self.unit ~= nil then
    self.unit:UnInit()
    self.unit = nil
  end

  -- 是否可交互
  self.interactable = false
  -- 是否可见
  self.visible = true
  self.distance = 9999

  --if you want release mono right now, call _gc()
  self.transform:UnInit()
  self.gameObject = nil
  self.isLocal = false

  for _, v in pairs(self.attributeListeners) do
    v:clear()
  end
  
  local ref = self.ref
  self.ref = nil
  if ref ~= nil then
    ref:OnDestroyed()
  end
end

function Entity:AddSystem(systemClass)
  local system = systemClass.new(self)
  self.systems[systemClass] = system

  if system.OnLodUpdate ~= nil then
    table.insert(self.lodUpdateSystems, system)
  end
  return system
end

function Entity:IsAlive()
  return false
end

function Entity:ToRef()
  if self.ref == nil then
    self.ref = EntityRef.New(self)
  end

  return self.ref
end

-- 添加entity销毁事件的监听
function Entity:AddDestroyListener(func, obj)
  if self.eventDestroyLiseners == nil then
    self.eventDestroyLiseners = {}-- event("Destroy")
  end

  local listener = {func = func, obj = obj} -- self.eventDestroy:CreateListener(func, obj)
  table.insert(self.eventDestroyLiseners, listener)
  return listener
end

-- 移除entity销毁事件的监听
function Entity:RemoveDestroyListener(func, obj)
  if self.eventDestroyLiseners == nil then
    return
  end

  for k = #self.eventDestroyLiseners, 1, -1 do
    local listener = self.eventDestroyLiseners[k]
    if listener.func == func and listener.obj == obj then
      table.remove(self.eventDestroyLiseners, k)
    end
  end
end

-- 设置属性
function Entity:SetAttribute(attributeType, value)
  if self.attributes[attributeType] == nil then
    self["Set"..attributeType] = function (self, value)
      local oldValue = self.attributes[attributeType]
      self.attributes[attributeType] = value

      if oldValue ~= value then
        self.attributes[attributeType] = value

        local listeners = self.attributeListeners[attributeType]
        if listeners ~= nil then
          for _, v in ilist(listeners) do
            if v.obj == nil then
              v.func(self, value, oldValue)
            else
              v.func(v.obj, self, value, oldValue)
            end
          end
        end
      end
    end

    self["Get"..attributeType] = function (self)
      return self.attributes[attributeType] or 0
    end
  end

  local oldValue = self.attributes[attributeType]
  if oldValue ~= value then
    self.attributes[attributeType] = value

    local listeners = self.attributeListeners[attributeType]
    if listeners ~= nil then
      for _, v in ilist(listeners) do
        if v.obj == nil then
          v.func(self, value, oldValue)
        else
          v.func(v.obj, self, value, oldValue)
        end
      end
    end
  end
end

-- 获取属性
function Entity:GetAttribute(attributeType)
  return self.attributes[attributeType] or 0
end

function Entity:AddAttributeListener(atrributeType, func, obj)
  local listeners = self.attributeListeners[atrributeType]
  if listeners == nil then
    listeners = list:new()
    self.attributeListeners[atrributeType] = listeners
  end
  listeners:push({func = func, obj = obj})
end

function Entity:RemoveAttributeLisenter(attributeType, func, obj)
  local listeners = self.attributeListeners[attributeType]
  if listeners == nil then
    ELog("event for attribute doesn't exist "..attributeType)
    return
  end

  for k, v in ilist(listeners) do
    if v.func == func and v.obj == obj then
      listeners:remove(k)
    end
  end
end

-- 杀死单位，但并不销毁单位，
function Entity:Kill()
  self.isDead = true

  -- 客户端自主决定销毁entity,
  if self.isLocal then
    local destroyDelay = self.config.DeadBodyKeepTime or 0.0
    if destroyDelay > 0.0 then
      coroutine.start(self.DoDie, self, destroyDelay)
    else
      self:Destroy()
    end
  end

  self:OnDead()
end

function Entity:DoDie(delay)
  coroutine.wait(delay)
  self:Destroy()
end

function Entity:OnTouch()

end

function Entity:OnDead()
  for _, v in pairs(self.systems) do
    if v.OnDead then
      v:OnDead()
    end
  end

  EventDispatcher:DispatchEvent(EVENT_ENTITY_DIE, self.id, self.entityTypeId)
end

-- 销毁单位,并不会马上删除，而是一帧后和其它要删除的entity统一删除
function Entity:Destroy()
  if self.bDestroyed then
    return
  end

  self.bDestroyed = true

  EntityMgr:OnEntityDestroyed(self)
end

-- 立刻销毁单位
function Entity:DestroyImmediate()
  if self.bDestroyed then
    return
  end

  self.bDestroyed = true

  EntityMgr:DestroyEntityUnsafe(self)
end

function Entity:Hide(hide)
  self.hide = hide
  if self.gameObject then
    self.gameObject:SetActive(not hide)
  else
    ELog("entityTemplate res or type not config correct, entityId: " .. self.config.EntityId)
  end
end

function Entity:RemoveSystem(systemClass)
  local system = self.systems[systemClass]
  if system ~= nil then
    system:UnInit()
    self.systems[systemClass] = nil

    if system.OnLodUpdate ~= nil then
      table.removebyvalue(self.lodUpdateSystems, system)
    end
  end
end

function Entity:OnLodUpdate(deltaTime)
  for k, v in pairs(self.lodUpdateSystems) do
    v:OnLodUpdate(deltaTime)
  end
end

function Entity:SetTeam(teamId)
  self.unit.team = teamId
  self.team = teamId
end

function Entity:SetHeight(height)
  height = height or 1
  self.height = height
end

function Entity:SetMoveSpeed(v)
  self.moveSpeed = v
end

function Entity:GetMoveSpeed()
  return self.moveSpeed
end

function Entity:SetGrid(x, z)
  self.gridX = x
  self.gridZ = z
end

function Entity:GetTransform()
  return self.transform.monoTransform
end

function Entity:GetPos(bReadOnly)
  return self.transform:GetPos(bReadOnly)
end

function Entity:GetPosReadOnly()
  return self:GetPos(true)
end

function Entity:GetRot(bReadOnly)
  return self.transform:GetRot(bReadOnly)
end

function Entity:SetPos(pos, bOnGround)
  if bOnGround then
    pos = NavMeshMgr:CheckPos(pos)
  end
  if MeMgr:IsMe(self.id) then
    self.transform:SetPos(self.physicSystem:MoveFilter(pos))
  else
    self.transform:SetPos(pos)
  end
end

function Entity:SetRot(rot)
  self.transform:SetRot(rot)
end

function Entity:Rotate(erAngles)
  self.transform:Rotate(erAngles)
end

function Entity:SetForward(forward)
  self.transform:SetForward(forward)
end

function Entity:GetForward(bRO)
  return self.transform:GetForward(bRO)
end

function Entity:GetRight(bRO)
  return self.transform:GetRight(bRO)
end

function Entity:GetLeft(bRO)
  return self.transform:GetLeft(bRO)
end

function Entity:GetUp(bRO)
  return self.transform:GetUp(bRO)
end

function Entity:GetEffectDummyTrans(dummyType)
  return self.transform.monoTransform
end

function Entity:IsPlayer()
  return false;
end

function Entity:IsFighter()
  return false
end

function Entity:IsNPC()
  return false
end

function Entity:IsNPCInteraction()
  return false
end

function Entity:IsNPCTrigger()
  return false
end

function Entity:IsPet()
  return false
end

function Entity:IsMonster()
  return false
end

function Entity:IsHero()
  return false
end

function Entity:IsDestroyed()
  return self.bDestroyed
end

function Entity:SetUnitState(unitState)
end

function Entity:SetMountState(mountState, id, showFx)
end

function Entity:SetTransformation(transformationState, id)
end

-- 设置LOD级别
function Entity:SetEntityLODLevel(level)
  if not self.ignoreLod then
    if self.lodLevel ~= level then
      SystemLodUpdateMgr:OnLodLevelChanged(self, level)
    end
    self.lodLevel = level
    if self.unit ~= nil then
      self.unit.lodLevel = self.lodLevel
    end

  end
end

-- 不参与LOD运算
function Entity:IgnoreLod()
  self.ignoreLod = true
  self.lodLevel = 0
end

function Entity:OnChangeRender()
  for _, v in pairs(self.systems) do
    if v.OnChangeRender then
      v:OnChangeRender()
    end
  end
end

function Entity:ShowStruck()
end

function Entity:CanMove()
  return false
end

function Entity:AddEffect(effect)
  if self.effects[effect] ~= nil then
    ELog("Add effect to entity error: effect exist: " .. effect.resPath)
  else
    self.effects[effect] = effect
    if EffectMgr.useCPool then
      effect.entityID = self.id
    else
      effect.entity = self
    end
  end
end

function Entity:RemoveEffect(effect)
  if self.effects[effect] == nil then
    if EffectMgr.useCPool then
      ELog("useCP Remove effect from entity error: effect not exist: " .. effect.name)
    else
      ELog("Remove effect from entity error: effect not exist: " .. effect.resPath)
    end
  else
    self.effects[effect] = nil
  end
  if EffectMgr.useCPool then
    effect.entityID = 0
  else
    effect.entity = nil
  end

end

function Entity:ClearAllEffects()
  for i in pairs(self.effects) do
    if EffectMgr.useCPool then
      self.effects[i].entityID = 0
    else
      self.effects[i].entity = nil
    end
    self.effects[i]:UnloadFX()
  end
  self.effects = {}
end

function Entity:GetConfig(configId)
  if self[configId] ~= nil then
    return self[configId]
  end
  if self.config ~= nil then
    return self.config[configId]
  end
end

return Entity