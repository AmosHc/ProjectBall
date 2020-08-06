local Transform = class("Transform")
local EntityTransformBatch = require("GamePlay/Client/EntityTransformBatch")

local kIgnoreCheckRO = not DebugVersion
local function ToggleReadOnly(target,r)
    -- 生产版本不去做该限制
    if kIgnoreCheckRO then
        -- 直接返回,有利于jit
        return
    end
    target.__ro = r
end

function Transform:ctor()
    self.pos = CommonUtility:VecReadOnly(Vector3.New(0, 0, 0))
    self.rot = CommonUtility:VecReadOnly(Quaternion.New(0, 0, 0, 0))
    self.forward = CommonUtility:VecReadOnly(Vector3.New(0, 0, 0))
    self.right = CommonUtility:VecReadOnly(Vector3.New(0, 0, 0))
    self.left = CommonUtility:VecReadOnly(Vector3.New(0, 0, 0))
    self.up = CommonUtility:VecReadOnly(Vector3.New(0, 0, 0))
end

function Transform:Init(entity)
    self.entity = entity
    self.monoTransform = self.entity.unit.transform
    --self.pos.__ro = false
    ToggleReadOnly(self.pos,false)
    self.pos.x, self.pos.y, self.pos.z = self.entity.unit:GetPosArray(nil, nil, nil)
    --self.pos.__ro = true
    ToggleReadOnly(self.pos,true)

    --self:UpdateRot()
end

function Transform:UnInit()
    self.monoTransform = nil
    self.entity = nil
end

function Transform:GetPos(bReadOnly)
    if bReadOnly then
        return self.pos
    else
        return Vector3.New(self.pos.x, self.pos.y, self.pos.z)
    end
end

function Transform:SetPos(pos)
    --self.pos.__ro = false
    ToggleReadOnly(self.pos,false)
    self.pos:Set(pos.x, pos.y, pos.z)
    --self.pos.__ro = true
    ToggleReadOnly(self.pos,true)

    if TRANSFORM_BATCH then
        EntityTransformBatch.CollectPositionData(self.entity.index, self.pos)
    else
        self.entity.unit:SetPos(self.pos) -- must set pos immediately, transform has been cached in other system like in TrackAction
    end
end

function Transform:GetRot(bReadOnly)
    if TRANSFORM_BATCH then
        ToggleReadOnly(self.rot,false)
        self.rot.x, self.rot.y, self.rot.z, self.rot.w = self.entity.unit:GetRotArray(nil, nil, nil, nil)
        ToggleReadOnly(self.rot,true)
    end

    if bReadOnly then
        return self.rot
    else
        return Quaternion.New(self.rot.x, self.rot.y, self.rot.z, self.rot.w)
    end
end

function Transform:SetRot(rot)
    --self.rot.__ro = false
    ToggleReadOnly(self.rot,false)
    self.rot:Set(rot.x, rot.y, rot.z, rot.w)
    --self.rot.__ro = true
    ToggleReadOnly(self.rot,true)
    self.entity.unit:SetRot(self.rot) -- must set rot immediately, transform has been cached in other system like in TrackAction
    --self:UpdateRot()
end

function Transform:Rotate(erAngles)
    self.monoTransform:Rotate(erAngles)
    --self.rot.__ro = false
    ToggleReadOnly(self.rot,false)
    self.rot.x, self.rot.y, self.rot.z, self.rot.w = self.entity.unit:GetRotArray(nil, nil, nil, nil)
    --self.rot.__ro = true
    ToggleReadOnly(self.rot,true)
    --ToggleReadOnly(self.rot,false)

    --self:UpdateRot()
end

function Transform:SetForward(forward)
    forward:Set(forward.x * 100, forward.y * 100, forward.z * 100)
    if forward:NearlyZero() then
        return
    end
    --self.rot.__ro = false
    ToggleReadOnly(self.rot,false)
    Quaternion.LookRotation(forward, nil, self.rot)
    --self.rot.__ro = true
    ToggleReadOnly(self.rot,true)
    self.entity.unit:SetRot(self.rot)
    --self:UpdateRot()
end

function Transform:GetForward(bRO)
    --self.forward.__ro = false
    ToggleReadOnly(self.forward,false)
    self.forward.x, self.forward.y, self.forward.z = self.entity.unit:GetForwardArray(nil, nil, nil)
    --self.forward.__ro = true
    ToggleReadOnly(self.forward,true)

    if bRO == nil or bRO then
        return self.forward
    else
        return Vector3.New(self.forward.x, self.forward.y, self.forward.z)
    end
end

function Transform:GetRight(bRO)
    --self.right.__ro = false
    ToggleReadOnly(self.right,false)
    self.right.x, self.right.y, self.right.z = self.entity.unit:GetRightArray(nil, nil, nil)
    --self.right.__ro = true
    ToggleReadOnly(self.right,true)

    if bRO == nil or bRO then
        return self.right
    else
        return Vector3.New(self.right.x, self.right.y, self.right.z)
    end
end

function Transform:GetLeft(bRO)
    --self.right.__ro = false
    ToggleReadOnly(self.right,false)
    self.right.x, self.right.y, self.right.z = self.entity.unit:GetRightArray(nil, nil, nil)
    --self.right.__ro = true
    ToggleReadOnly(self.right,true)

    --self.left.__ro = false
    ToggleReadOnly(self.left,false)
    self.left:Set(-self.right.x, -self.left.y, -self.left.z)
    --self.left.__ro = true
    ToggleReadOnly(self.left,true)

    if bRO == nil or bRO then
        return self.left
    else
        return Vector3.New(self.left.x, self.left.y, self.left.z)
    end
end

function Transform:GetUp(bRO)
    --self.up.__ro = false
    ToggleReadOnly(self.up,false)
    self.up.x, self.up.y, self.up.z = self.entity.unit:GetUpArray(nil, nil, nil)
    --self.up.__ro = true
    ToggleReadOnly(self.up,true)

    if bRO == nil or bRO then
        return self.up
    else
        return Vector3.New(self.up.x, self.up.y, self.up.z)
    end
end

function Transform:UpdateRot()
    --self.forward.__ro = false
    ToggleReadOnly(self.forward,false)
    self.forward.x, self.forward.y, self.forward.z = self.entity.unit:GetForwardArray(nil, nil, nil)
    --self.forward.__ro = true
    ToggleReadOnly(self.forward,true)

    --self.right.__ro = false
    ToggleReadOnly(self.right,false)
    self.right.x, self.right.y, self.right.z = self.entity.unit:GetRightArray(nil, nil, nil)
    --self.right.__ro = true
    ToggleReadOnly(self.right,true)

    --self.left.__ro = false
    ToggleReadOnly(self.left,false)
    self.left:Set(-self.right.x, -self.left.y, -self.left.z)
    --self.left.__ro = true
    ToggleReadOnly(self.left,true)

    --self.up.__ro = false
    ToggleReadOnly(self.up,false)
    self.up.x, self.up.y, self.up.z = self.entity.unit:GetUpArray(nil, nil, nil)
    --self.up.__ro = true
    ToggleReadOnly(self.up,true)

end

return Transform