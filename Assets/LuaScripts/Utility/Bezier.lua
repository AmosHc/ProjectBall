local Bezier = {}
local Clamp = Mathf.Clamp

function Bezier.GetNewVec3(v)
    return {
        x = v.x,
        y = v.y,
        z = v.z,
    }
end

function Bezier.ToVector3(vec3)
    return Vector3.New(vec3.x, vec3.y, vec3.z)
end

function Bezier.CreateBezier(points, startPos, endPos)
    local bezier = {
        pos = {},
        points = {},
        startPos = startPos or 1,
        endPos = endPos or #points,
    }
    for i = bezier.startPos, bezier.endPos do
        bezier.points[i] = Bezier.GetNewVec3(points[i])
        bezier.pos[i] = Bezier.GetNewVec3(points[i])
    end
    return bezier
end

function Bezier.RefreshPoints(bezier, points)
    for i = bezier.startPos, bezier.endPos do
        Bezier.CloneVec3(points[i], bezier.points[i])
    end
end

function Bezier.RefreshTargetPos(bezier, point)
    Bezier.CloneVec3(point, bezier.points[#bezier.points])
end

function Bezier.RefreshPos(bezier)
    for i = bezier.startPos, bezier.endPos do
        Bezier.CloneVec3(bezier.points[i], bezier.pos[i])
    end
end

function Bezier.GetPoint(bezier, t)
    Bezier.RefreshPos(bezier)
    return Bezier.RecursiveGetPoint(bezier, t, bezier.endPos)
end

function Bezier.RecursiveGetPoint(bezier, t, deep)
    if deep == bezier.startPos + 1 then
        Bezier.Lerp(bezier.pos[bezier.startPos], bezier.pos[deep], t)
        return Bezier.ToVector3(bezier.pos[bezier.startPos])
    end
    for i = bezier.startPos, deep - 1 do
        Bezier.Lerp(bezier.pos[i], bezier.pos[i + 1], t)
    end
    return Bezier.RecursiveGetPoint(bezier, t, deep - 1)
end

function Bezier.Clone(x, y, z, v)
    v.x = x
    v.y = y
    v.z = z
end

function Bezier.CloneVec3(v1, v2)
    v2.x = v1.x
    v2.y = v1.y
    v2.z = v1.z
end

function Bezier.Lerp(from, to, t)
    t = Clamp(t, 0, 1)
    Bezier.Clone(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t, from)
end

return Bezier