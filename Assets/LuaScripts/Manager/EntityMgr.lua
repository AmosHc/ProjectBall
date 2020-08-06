local EntityMgr = class("EntityMgr", Callbackable)
local Pool = require("Utility/Pool")

__ENTITY_SHADOW_TOGGLE__ = true

EntityClassType = {
    Player = 1,
    Monster = 2,
    Boss = 3,
    NPC = 4,
    NPCCollect = 5, --采集NPC
    NPCTrigger = 6, --触发器NPC
    NPCInteraction = 7, --交互NPC
    Pet = 8, --宠物
    Projectile = 10,
    SceneExplodable = 11,
    SceneTrip = 12,
    Hero = 15,
    Gadget = 16, -- 可被拿起的entity
    LightNpc = 102,
    SoulNpc = 103,
    Survey = 105,
    Glory = 106
}

function EntityMgr:ctor()
    Callbackable.ctor(self)
    self.bPause = false
    self.bHideAllEntities = false
    self.entities = {}
    self.playerList = {}

    self.SpaceList = {} --晨曦空间

    --同地图的队友（不包括主角）
    self.teamList = {}

    self.curLocalEntityUniID = LocalUniIDFrom

    self.toDeleted = {}
    self.entityPools = {}
    EventDispatcher:AddEventListener(TEAM_DETAIL_CHG, self.OnTeamChange, self)
end

function EntityMgr:GetAllEntityList()
    --return self.allEntityList
    return self.entities
end

function EntityMgr:GetAllEntityCount()
    local cnt = 0
    for i, v in pairs(self.entities) do
        cnt = cnt + 1
    end
    return cnt
end

function EntityMgr:GetPlayerList()
    return self.playerList
end

function EntityMgr:GetLightSpaceList()
    return self.SpaceList
end

function EntityMgr:GetHerosById(id)
    local heros = {}
    for i, v in pairs(self.entities) do
        if v:IsHero() and v.followIdent == id then
            table.insert(heros, v)
        end
    end
    return heros
end

function EntityMgr:HasHero(id)
    for i, v in pairs(self.entities) do
        if v:IsHero() and v.followIdent == id then
            return true
        end
    end
    return false
end

function EntityMgr:UnInit()
    Callbackable.UnInit(self)
    self:DestroyAllEntities()
    self.bHideAllEntities = false
end

function EntityMgr:OnEntityDestroyed(entity)
    self.toDeleted[entity.id] = entity
end

function EntityMgr:OnUpdate(deltaTime)
    for k, v in pairs(self.toDeleted) do
        self:DestroyEntityUnsafe(v)
        self.toDeleted[k] = nil
    end
end

function EntityMgr:OnDrawGizmos()
    for k, v in pairs(self.entities) do
        if v.OnDrawGizmos ~= nil then
            v:OnDrawGizmos()
        end
    end
end

function EntityMgr:CreateLocalPlayerPreviewEntityWithUniId(pos, rot, modelCallback, avatarCallback)
    local localPlayer = MeMgr.entity
    if (localPlayer == nil) then
        return nil
    end

    local config = MeMgr.entity.config
    if (config == nil) then
        return nil
    end

    local entityTypeId = MeMgr.entity.entityTypeId
    local race = MeMgr.entity.race

    local entity = self:CreateEntityInternal(config, false)
    assert(entity, "can not create entity by type id:" .. entityTypeId)
    entity.noHudBar = true
    entity.entityTypeId = entityTypeId
    entity.job = entityTypeId
    entity.race = race
    entity.name = config.Name and string.match(config.Name, "%D+") or ""
    entity.asset = config.ResPath
    local id = self:GetLocalUniID()
    entity.unit = MapSceneManager.Instance:CreatePreviewEntity(id, entity.asset, pos, rot, config.Size)
    entity.id = id
    entity.config = config
    entity:Init()
    entity:SetTeam(0)
    entity:UnLoadYinYing()
    entity.avatarSystem.asyncDoneCallback = avatarCallback
    entity.modelStateSystem.asyncDoneCallback = modelCallback

    --将本地玩家装备数据复制到预览模型内
    entity.avatarSystem.equipEffectArray = localPlayer.avatarSystem.equipEffectArray
    entity.avatarSystem.equipFaceArray = localPlayer.avatarSystem.equipFaceArray

    entity.customFaceSystem.faceData = localPlayer.customFaceSystem.faceData

    entity.modelStateSystem:Load(MODEL_STATE_TYPE.CHARACTER_MODEL)
    return entity
end

function EntityMgr:CreatePreviewEntityWithUniId(entityTypeId, race, pos, rot, modelCallback, avatarCallback)
    if (race == nil) then
        race = 0
    end
    local config = ConfigMgr.GetEntityConfig(entityTypeId, race)--UnitConfigMgr:Get(entityTypeId, race)
    if (config == nil) then
        ELog('找不到Entity表格数据 ID: ' .. entityTypeId .. ' Race: ' .. race)
        return nil
    end

    local entity = self:CreateEntityInternal(config, false)
    assert(entity, "can not create entity by type id:" .. entityTypeId)
    entity.noHudBar = true
    entity.entityTypeId = entityTypeId
    entity.job = entityTypeId
    entity.race = race
    entity.name = config.Name and string.match(config.Name, "%D+") or ""
    entity.asset = config.ResPath
    local id = self:GetLocalUniID()
    entity.unit = MapSceneManager.Instance:CreatePreviewEntity(id, entity.asset, pos, rot, config.Size)
    entity.id = id
    entity.config = config
    entity:Init()
    entity:SetTeam(0)
    entity:UnLoadYinYing()
    entity.avatarSystem.asyncDoneCallback = avatarCallback
    entity.modelStateSystem.asyncDoneCallback = modelCallback

    entity.modelStateSystem:Load(MODEL_STATE_TYPE.CHARACTER_MODEL)
    return entity
end

function EntityMgr:CreatePreviewEntityWithUniIdAndAvatar(entityTypeId, race, pos, rot, faceIdent, faceData, equipEffectArray, modelCallback, avatarCallback)
    if (race == nil) then
        race = 0
    end
    local config = ConfigMgr.GetEntityConfig(entityTypeId, race)--UnitConfigMgr:Get(entityTypeId, race)
    if (config == nil) then
        ELog('找不到Entity表格数据 ID: ' .. entityTypeId .. ' Race: ' .. race)
        return nil
    end

    local entity = self:CreateEntityInternal(config, false)
    assert(entity, "can not create entity by type id:" .. entityTypeId)
    entity.noHudBar = true
    entity.entityTypeId = entityTypeId
    entity.job = entityTypeId
    entity.race = race
    entity.name = config.Name and string.match(config.Name, "%D+") or ""
    entity.asset = config.ResPath
    local id = self:GetLocalUniID()
    entity.unit = MapSceneManager.Instance:CreatePreviewEntity(id, entity.asset, pos, rot, config.Size)
    entity.id = id
    entity.config = config
    entity:Init()
    entity:SetTeam(0)
    entity:UnLoadYinYing()
    if (faceIdent ~= nil) then
        entity.avatarSystem.equipFaceArray = CommonUtility:DeserializeFaceIdent(faceIdent)
    end
    if (faceData ~= nil) then
        if (entity.customFaceSystem ~= nil) then
            entity.customFaceSystem.faceData = faceData
        end
    end
    if (equipEffectArray ~= nil) then
        local modelResIdents = {}
        for _, itemID in pairs(equipEffectArray) do
            local stdItemBase = StdItemsConfig[itemID]
            if (stdItemBase ~= nil) then
                if (stdItemBase.Effect > 0) then
                    table.insert(modelResIdents, stdItemBase.Effect)
                end
            else
                table.insert(modelResIdents, itemID)
            end
        end
        entity.avatarSystem.equipEffectArray = modelResIdents
    end

    entity.avatarSystem.asyncDoneCallback = avatarCallback
    entity.modelStateSystem.asyncDoneCallback = modelCallback

    entity.modelStateSystem:Load(MODEL_STATE_TYPE.CHARACTER_MODEL)
    return entity
end

-- 根据配置参数生成entity
-- @param id 运行时id
-- @param config 配置参数
-- @param pos 位置
-- @param rot 角度
function EntityMgr:CreateEntityWithConfig(id, config, pos, rot)
    local entityTypeId = config.EntityId
    local entity = self:CreateEntityInternal(config)
    assert(entity, "can not create entity by type id:" .. entityTypeId)
    entity.entityTypeId = entityTypeId
    entity.job = entityTypeId
    entity.race = config.Race or 0
    entity.name = config.Name and string.match(config.Name, "%D+") or ""
    entity.asset = config.ResPath
    if entity:IsFighter() then
        NavMeshMgr:GetPosOnGroundX(pos)
    end
    entity.spawnLocation = pos
    entity.unit = MapSceneManager.Instance:CreateSceneUnit(entity.type, id, entity.asset, pos, rot, -1, config.ColliderRadius, config.ColliderHigh, config.Size)
    entity.unit.id = id
    entity.id = id
    entity.config = config

    if config.Type == EntityClassType.NPC or config.Type == EntityClassType.NPCTrigger or config.Type == EntityClassType.NPCInteraction
            or config.Type == EntityClassType.Gadget then
        entity.interactable = true
    end

    if entity:IsPlayer() then
        self.playerList[entity.id] = entity
    end
    if entity:IsNPC() and entity.type == EntityClassType.LightNpc or entity.type == EntityClassType.SoulNpc then
        self.SpaceList[entity.id] = entity
    end

    entity:Init()
    entity:SetTeam(0)

    self:AddEntity(id, entity)
    --self.entities[id] = entity

    -- 设置lua的transform缓存
    entity:SetPos(pos)
    entity:SetRot(rot)
    return entity
end

function EntityMgr:CreateEntityWithUniId(id, entityTypeId, race, pos, rot, msg)
    local config = ConfigMgr.GetEntityConfig(entityTypeId, race)--UnitConfigMgr:Get(entityTypeId, race)
    if config == nil then
        ELog('找不到Entity表格数据 ID: ' .. entityTypeId .. ' Race: ' .. race)
        return nil
    end
    local entity = self:CreateEntityInternal(config)
    assert(entity, "can not create entity by type id:" .. entityTypeId .. " race:" .. race)
    entity.entityTypeId = entityTypeId
    entity.job = entityTypeId
    if msg then
        entity.dataModel = msg
        entity.name = msg.Name
        entity.job = msg.Job
        entity.race = msg.Race
    else
        entity.race = race
        entity.name = config.Name and string.match(config.Name, "%D+") or ""
        entity.asset = config.ResPath
    end
    if entity:IsFighter() then
        NavMeshMgr:GetPosOnGroundX(pos)
    end
    entity.spawnLocation = pos
    entity.unit = MapSceneManager.Instance:CreateSceneUnit(entity.type, id, entity.asset, pos, rot, -1, config.ColliderRadius, config.ColliderHigh, config.Size)
    entity.unit.id = id
    entity.id = id
    entity.config = config

    if config.Type == EntityClassType.NPC or config.Type == EntityClassType.NPCTrigger or config.Type == EntityClassType.NPCInteraction
            or config.Type == EntityClassType.Gadget then
        entity.interactable = true
    end

    if entity:IsPlayer() then
        self.playerList[entity.id] = entity
    end
    if entity:IsNPC() and entity.type == EntityClassType.LightNpc or entity.type == EntityClassType.SoulNpc then
        self.SpaceList[entity.id] = entity
    end

    entity:Init()
    entity:SetTeam(0)

    self:AddEntity(id, entity)
    --self.entities[id] = entity

    -- 设置lua的transform缓存
    entity:SetPos(pos)
    entity:SetRot(rot)
    return entity
end

function EntityMgr:CreateLocalEntity(entityTypeId, race, pos, rot, modelCallback, avatarCallback)
    local uniID = self:GetLocalUniID()
    local entity = self:CreateEntityWithUniId(uniID, entityTypeId, race, pos, rot)
    if entity ~= nil then
        entity.avatarSystem.asyncDoneCallback = avatarCallback
        entity.modelStateSystem.asyncDoneCallback = modelCallback
    end
    return entity
end

-- 宠物创建
function EntityMgr:CreatePetEntity(entityTypeId, hostEntity)
    local config = ConfigMgr.GetEntityConfig(entityTypeId, 0)--UnitConfigMgr:Get(entityTypeId)
    local pet = self:CreateEntityInternal(config)
    if pet == nil then
        return nil
    end
    assert(pet, "can not create entity by type id:" .. entityTypeId);
    local pos = hostEntity:GetPos()
    local rot = Quaternion.identity
    pet.entityTypeId = entityTypeId
    pet.name = config.Name and string.match(config.Name, "%D+") or ""
    pet.asset = config.ResPath
    local id = self:GetLocalUniID()
    pet.unit = MapSceneManager.Instance:CreateSceneUnit(pet.type, id, pet.asset, pos, rot, -1, config.ColliderRadius, config.ColliderHigh, config.Size)
    pet.unit.id = id
    pet.id = id
    pet.config = config

    pet:SetHost(hostEntity)
    pet:Init()
    pet:SetTeam(0)
    pet:SetSpawnPos()

    self:AddEntity(id, pet)
    --self.entities[id] = pet
    return id, pet
end

function EntityMgr:CreateLightEntity(entityTypeId, pos, rot, pointId)
    local config = ConfigMgr.GetEntityConfig(entityTypeId, 0)--UnitConfigMgr:Get(entityTypeId, 0)
    local entity = self:CreateEntityInternal(config)
    assert(entity, "can not create entity by type id:" .. entityTypeId);
    entity.entityTypeId = entityTypeId
    entity.name = config.Name and string.match(config.Name, "%D+") or ""
    entity.asset = config.ResPath
    entity.isLocal = true

    if pointId == nil then
        pointId = -1
    end
    if entity:IsFighter() then
        NavMeshMgr:GetPosOnGroundX(pos)
    end

    entity.id = self:GetLocalUniID()
    entity.config = config
    entity.unit = MapSceneManager.Instance:CreateSceneUnit(entity.type, entity.id, entity.asset, pos, rot, pointId, config.ColliderRadius, config.ColliderHigh, config.Size)
    entity:Init()
    self:AddEntity(entity.id, entity)
    --self.entities[entity.id] = entity
    return entity
end

function EntityMgr:GetPool(classType)
    local pool = self.entityPools[classType]

    if pool == nil then
        pool = Pool.create("Entity_" .. classType.__cname, 16, function()
            return classType.new()
        end)
        self.entityPools[classType] = pool
    end

    return pool
end

function EntityMgr:CreateEntityInternal(entityData, usePool)
    if entityData == nil then
        ELog("Invalid entityTypeId null")
        return nil
    end

    if usePool == nil then
        usePool = true
    end

    local entityTypeId = entityData.EntityId
    local entity = nil

    if entityData.Type == EntityClassType.Player then
        entity = self:CreateEntity(Player, usePool)
    elseif entityData.Type == EntityClassType.Monster then
        entity = self:CreateEntity(Monster, usePool)
    elseif entityData.Type == EntityClassType.Boss then
        entity = self:CreateEntity(Monster, usePool)
    elseif entityData.Type == EntityClassType.NPC or
            entityData.Type == EntityClassType.NPCCollect or
            entityData.Type == EntityClassType.NPCTrigger or
            entityData.Type == EntityClassType.NPCInteraction then
        entity = self:CreateEntity(NPC, usePool)
    elseif entityData.Type == EntityClassType.Projectile then
        entity = self:CreateEntity(Projectile, usePool)
    elseif entityData.Type == EntityClassType.SceneExplodable then
        entity = self:CreateEntity(SceneExplodable, usePool)
    elseif entityData.Type == EntityClassType.Pet then
        entity = self:CreateEntity(Pet, usePool)
    elseif entityData.Type == EntityClassType.Hero then
        entity = self:CreateEntity(Hero, usePool)
    elseif entityData.Type == EntityClassType.Gadget then
        entity = self:CreateEntity(GadgetEntity, usePool)
    elseif entityData.Type == EntityClassType.LightNpc or entityData.Type == EntityClassType.SoulNpc or entityData.Type == EntityClassType.Survey
            or entityData.Type == EntityClassType.Glory then
        entity = self:CreateEntity(NPC, usePool)
    end

    if entity == nil then
        if entityTypeId == nil then
            ELog("entity type not exist: nil")
        else
            ELog("entity type not exist:" .. entityTypeId)
        end
    else
        entity.entityTypeId = entityTypeId
        entity.type = entityData.Type
    end

    --local listener = entity.EventDestroy:CreateListener(function ()
    --    print("entity destroyed")
    --end)
    --entity.EventDestroy:AddListener(listener)
    return entity
end

function EntityMgr:CreateEntity(classType, usePool)
    if usePool then
        return self:GetPool(classType):get()
    else
        return classType.new()
    end
end

function EntityMgr:AddEntity(id, entity)
    self.entities[id] = entity
    if entity.type == EntityClassType.Monster then
        EventDispatcher:DispatchEvent(EVENT_ENTITY_MONSTER_REFRESH)
    end
end

function EntityMgr:GetEntity(id)
    --return self.allEntityList[id]
    return self.entities[id]
end

function EntityMgr:GetEntityByType(type)
    for k, v in pairs(self.entities) do
        if v.type == type then
            return v
        end
    end
end

function EntityMgr:GetEntityByConfigID(configID)
    for k, v in pairs(self.entities) do
        if v.config ~= nil and v.config.EntityId == configID then
            return v
        end
    end
    return nil
end

function EntityMgr:GetBoss()
    return self:GetEntityByType(EntityClassType.Boss)
end

function EntityMgr:DestroyEntityUnsafe(entity)
    if entity == nil then
        return
    end

    if MeMgr:IsMe(entity.id) then
        MeMgr:SetEntity(nil)
    end

    local id = entity.id
    --self.lodUpdateEntities[id] = nil
    self.entities[id] = nil

    if entity:IsPlayer() then
        self.playerList[id] = nil
    end

    if entity:IsNPC() and entity.type == EntityClassType.LightNpc or entity.type == EntityClassType.SoulNpc then
        self.SpaceList[id] = nil
    end
    if entity.type == EntityClassType.Monster then
        -- 怪物有更新
        EventDispatcher:DispatchEvent(EVENT_ENTITY_MONSTER_REFRESH)
    end

    entity:UnInit()

    if entity.__inPool ~= nil then
        self:GetPool(entity.class):free(entity)
    end
end

function EntityMgr:DestroyAllEntities()
    for k, v in pairs(self.entities) do
        --self:DestroyEntityUnsafe(k)
        v:DestroyImmediate()
    end

    self.playerList = {}
    self.SpaceList = {} --晨曦空间

    --self.lodUpdateEntities = {}
end

function EntityMgr:DestroyAllMonster()
    local meTeam = MeMgr:GetEntity().team

    for k, v in pairs(self.entities) do
        if v:IsFighter() and v.team ~= meTeam then
            --self:DestroyEntityUnsafe(k)
            v:Destroy()
        end
    end
end

function EntityMgr:Pause()
    self.bPause = true
end

function EntityMgr:Resume()
    self.bPause = false
end

function EntityMgr:HideAllEntity(hide, meHide)
    self.bHideAllEntities = hide
    for k, v in pairs(self.entities) do
        if not MeMgr:IsMe(v.id) then
            if IsEntValid(v) then
                v:Hide(hide)
            else
                ELog("Invalid entity .. " .. v.config.EntityId)
            end
        end
    end
    EventDispatcher:DispatchEvent(EVENT_ENTITY_MONSTER_REFRESH)
    local me = MeMgr:GetEntity()
    if me ~= nil then
        if meHide then
            MeMgr.cameraDisCheckToggle = false
        else
            MeMgr.cameraDisCheckToggle = true
        end
        me:Hide(meHide)
    end
end

function EntityMgr:OnTeamChange()
    self.teamList = {}
    for k, v in pairs(TeamMgr.teamDetail.MemberList) do
        local entity = self:GetEntity(v.Ident)
        if entity == nil then
        elseif entity == MeMgr:GetEntity() then
        elseif v.MapID ~= GameData.mapDataMgr.curMapData.MapId then
        else
            self.teamList[v.Ident] = entity
        end
    end
end


------------------
--temporary code--
------------------

function EntityMgr:OnSkill(entityId, skillIndex)
    self:GetEntity(entityId):OnSkill(skillIndex)
end

function EntityMgr:GetLocalUniID()
    if self.curLocalEntityUniID == 0 or self.curLocalEntityUniID < 0 then
        self.curLocalEntityUniID = LocalUniIDFrom
    end

    self.curLocalEntityUniID = self.curLocalEntityUniID + 1
    while self.entities[self.curLocalEntityUniID] ~= nil do
        self.curLocalEntityUniID = self.curLocalEntityUniID + 1
    end
    return self.curLocalEntityUniID
end

function EntityMgr:SetEntityOwnership(msg)
    local entity = self:GetEntity(msg.Ident)
    if entity ~= nil then
        entity.ownership = msg
    end
    TargetSelectionMgr:RefreshTargetOwner(msg.Ident)
end

function EntityMgr:DummyEffect(entityId, dummyType,scale,effect,lifetime)

    if self:GetEntity(entityId) then

        --ELog("111entityId___"..entityId.."____effect_____"..effect.name)
        if self:GetEntity(entityId).dummyPointSystem ~= nil then
            self:GetEntity(entityId).dummyPointSystem:GetEffectDummyTrans(dummyType)
        end
        local ts = self:GetEntity(entityId):GetTransform()
        if effect ~= nil then
            effect.gameObject.transform.parent = ts
        end
        scale = scale or Vector3.one
        local realScale = Vector3.one
        local parentScale = ts.transform.localScale
        if parentScale.x > 0 and parentScale.y > 0 and parentScale.z > 0 then
            realScale.x = scale.x / parentScale.x
            realScale.y = scale.y / parentScale.y
            realScale.z = scale.z / parentScale.z
        end
        effect:StartFx(realScale)
        effect:DelayUnload(lifetime)
        self:GetEntity(entityId):AddEffect(effect)
    else
        --ELog("cant find enetityed entityID"..entityId.."____effect_____"..effect.name)
    end
end
function EntityMgr:RemoveEffect(entityId,effect)
    if self:GetEntity(entityId) ~= nil and effect ~= nil then
        self:GetEntity(entityId):RemoveEffect(effect)
    else
        --ELog("EntityMgr RemoveEffect failed entityId____"..entityId.."_____effect////////???????"..effect.name)
    end
end
return EntityMgr