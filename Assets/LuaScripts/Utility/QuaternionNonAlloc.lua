local Quaternion = Quaternion
local clamp = Mathf.Clamp
local asin 	= math.asin
local atan2 = math.atan2
local rad2Deg = Mathf.Rad2Deg

function Quaternion.LerpNonAlloc(q1, q2, t, q)
    t = clamp(t, 0, 1)
    q:Set(0,0,0,1)

    if Quaternion.Dot(q1, q2) < 0 then
        q.x = q1.x + t * (-q2.x -q1.x)
        q.y = q1.y + t * (-q2.y -q1.y)
        q.z = q1.z + t * (-q2.z -q1.z)
        q.w = q1.w + t * (-q2.w -q1.w)
    else
        q.x = q1.x + (q2.x - q1.x) * t
        q.y = q1.y + (q2.y - q1.y) * t
        q.z = q1.z + (q2.z - q1.z) * t
        q.w = q1.w + (q2.w - q1.w) * t
    end

    Quaternion.SetNormalize(q)
    return q
end

local pi = Mathf.PI
local half_pi = pi * 0.5
local two_pi = 2 * pi
local negativeFlip = -0.0001
local positiveFlip = two_pi - 0.0001

local function SanitizeEuler(euler)
    if euler.x < negativeFlip then
        euler.x = euler.x + two_pi
    elseif euler.x > positiveFlip then
        euler.x = euler.x - two_pi
    end

    if euler.y < negativeFlip then
        euler.y = euler.y + two_pi
    elseif euler.y > positiveFlip then
        euler.y = euler.y - two_pi
    end

    if euler.z < negativeFlip then
        euler.z = euler.z + two_pi
    elseif euler.z > positiveFlip then
        euler.z = euler.z + two_pi
    end
end

function Quaternion:ToEulerAnglesNonAlloc(v)
    local x = self.x
    local y = self.y
    local z = self.z
    local w = self.w

    local check = 2 * (y * z - w * x)

    if check < 0.999 then
        if check > -0.999 then
            v:Set( -asin(check),
                    atan2(2 * (x * z + w * y), 1 - 2 * (x * x + y * y)),
                    atan2(2 * (x * y + w * z), 1 - 2 * (x * x + z * z)))
            SanitizeEuler(v)
            v:Mul(rad2Deg)
            return v
        else
            v:Set(half_pi, atan2(2 * (x * y - w * z), 1 - 2 * (y * y + z * z)), 0)
            SanitizeEuler(v)
            v:Mul(rad2Deg)
            return v
        end
    else
        v:Set(-half_pi, atan2(-2 * (x * y - w * z), 1 - 2 * (y * y + z * z)), 0)
        SanitizeEuler(v)
        v:Mul(rad2Deg)
        return v
    end
end

return Quaternion